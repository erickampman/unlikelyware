#!/bin/bash
# sign-notarize.sh - sign, notarize and staple macOS bundles (.clap, .vst3, .app) for
# Developer ID distribution.
#
# Usage:
#   sign-notarize.sh [options] BUNDLE...
#
# Steps: sign nested code, then each bundle (hardened runtime, secure timestamp); verify;
# zip all bundles into one submission; notarize and wait; staple each bundle; validate;
# optionally write a distribution zip of the stapled bundles.
#
# Options:
#   --entitlements FILE  entitlements for the outer bundles. Only matters for apps
#                        (StageHand needs com.apple.security.cs.disable-library-validation);
#                        a plugin runs under its host's entitlements.
#   --zip FILE           after stapling, write the bundles to FILE for distribution
#                        (replaces FILE if it exists)
#   --sign-only          sign and verify only; skip notarizing and stapling
#   -h, --help           show this help
#
# Environment:
#   SIGN_IDENTITY   default "Developer ID Application: Eric Kampman (R28W7FR6SE)".
#                   "-" signs ad hoc, for testing this script; it implies --sign-only.
#   NOTARY_PROFILE  default "unlikelyware-notary" (made by: xcrun notarytool store-credentials)
#
# Sign only our own code (PLA 5.1(d)): never point this at a third-party plugin.

set -euo pipefail

IDENTITY="${SIGN_IDENTITY:-Developer ID Application: Eric Kampman (R28W7FR6SE)}"
PROFILE="${NOTARY_PROFILE:-unlikelyware-notary}"
ENTITLEMENTS=""
OUT_ZIP=""
SIGN_ONLY=0
BUNDLES=()

die() { echo "error: $*" >&2; exit 1; }
usage() { awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "$0"; }

while [ $# -gt 0 ]; do
    case "$1" in
        --entitlements) [ $# -ge 2 ] || die "--entitlements needs a file"; ENTITLEMENTS="$2"; shift 2 ;;
        --zip)          [ $# -ge 2 ] || die "--zip needs a file"; OUT_ZIP="$2"; shift 2 ;;
        --sign-only)    SIGN_ONLY=1; shift ;;
        -h|--help)      usage; exit 0 ;;
        --)             shift; BUNDLES+=("$@"); break ;;
        -*)             die "unknown option: $1" ;;
        *)              BUNDLES+=("${1%/}"); shift ;;
    esac
done
[ ${#BUNDLES[@]} -gt 0 ] || { usage >&2; exit 2; }

# --- Check inputs and credentials before touching anything -------------------------------

names=""
for b in "${BUNDLES[@]}"; do
    [ -d "$b/Contents" ] || die "not a macOS bundle (no Contents folder): $b"
    n=$(basename "$b")
    case "$names" in *"|$n|"*) die "two bundles share the name $n" ;; esac
    names="$names|$n|"
done

if [ -n "$ENTITLEMENTS" ]; then
    [ -f "$ENTITLEMENTS" ] || die "entitlements file not found: $ENTITLEMENTS"
    plutil -lint -s "$ENTITLEMENTS" || die "entitlements file is not a valid plist"
fi

if [ "$IDENTITY" = "-" ]; then
    echo "Ad-hoc signing (test only): notarizing is skipped."
    TS=(--timestamp=none)
    SIGN_ONLY=1
else
    TS=(--timestamp)
    security find-identity -v -p codesigning | grep -qF "\"$IDENTITY\"" \
        || die "signing identity not in the keychain: $IDENTITY"
fi

if [ "$SIGN_ONLY" -eq 0 ]; then
    xcrun notarytool history --keychain-profile "$PROFILE" >/dev/null 2>&1 \
        || die "notarytool profile '$PROFILE' doesn't work (make it with: xcrun notarytool store-credentials)"
fi

WORK=$(mktemp -d "${TMPDIR:-/tmp}/sign-notarize.XXXXXX")
trap 'rm -rf "$WORK"' EXIT

# --- Sign ---------------------------------------------------------------------------------

sign() { # PATH [extra codesign args]
    local path="$1"; shift
    codesign --force "${TS[@]}" --options runtime --sign "$IDENTITY" "$@" "$path"
}

is_macho() { file -b "$1" | grep -q 'Mach-O'; }

sign_bundle() {
    local b="$1" main="" f dir
    if [ -f "$b/Contents/Info.plist" ]; then
        main=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$b/Contents/Info.plist" 2>/dev/null || true)
    fi

    # Nested code, innermost first (-depth lists children before their parents).
    while IFS= read -r -d '' f; do
        echo "  nested: ${f#"$b"/}"
        sign "$f"
    done < <(find "$b/Contents" -depth ! -type l \( -name '*.framework' -o -name '*.dylib' \
        -o -name '*.bundle' -o -name '*.app' -o -name '*.xpc' -o -name '*.appex' \
        -o -name '*.clap' -o -name '*.vst3' -o -name '*.component' \) -print0)

    # Extra executables next to the main one.
    for dir in "$b/Contents/MacOS" "$b/Contents/Helpers"; do
        [ -d "$dir" ] || continue
        for f in "$dir"/*; do
            [ -f "$f" ] && [ ! -L "$f" ] && [ "$(basename "$f")" != "$main" ] && is_macho "$f" || continue
            echo "  helper: ${f#"$b"/}"
            sign "$f"
        done
    done

    if [ -n "$ENTITLEMENTS" ]; then
        sign "$b" --entitlements "$ENTITLEMENTS"
    else
        sign "$b"
    fi
    codesign --verify --strict --deep --verbose=1 "$b"
}

for b in "${BUNDLES[@]}"; do
    echo "Signing $b"
    sign_bundle "$b"
done

if [ "$SIGN_ONLY" -eq 1 ]; then
    echo "Signed and verified; notarizing skipped."
else
    # --- Notarize (one submission for all bundles) -----------------------------------------
    mkdir "$WORK/submit"
    for b in "${BUNDLES[@]}"; do ditto "$b" "$WORK/submit/$(basename "$b")"; done
    ditto -c -k --keepParent "$WORK/submit" "$WORK/submit.zip"

    echo "Submitting for notarization (usually a few minutes)..."
    xcrun notarytool submit "$WORK/submit.zip" --keychain-profile "$PROFILE" \
        --wait --output-format json > "$WORK/result.json" || true
    status=$(plutil -extract status raw -o - "$WORK/result.json" 2>/dev/null || echo unknown)
    id=$(plutil -extract id raw -o - "$WORK/result.json" 2>/dev/null || echo "")
    echo "Notarization: $status${id:+ (submission $id)}"
    if [ "$status" != "Accepted" ]; then
        cat "$WORK/result.json" >&2
        if [ -n "$id" ]; then xcrun notarytool log "$id" --keychain-profile "$PROFILE" >&2 || true; fi
        die "notarization failed"
    fi

    # --- Staple and check --------------------------------------------------------------------
    for b in "${BUNDLES[@]}"; do
        echo "Stapling $b"
        xcrun stapler staple "$b"
        xcrun stapler validate "$b"
        case "$b" in *.app) spctl --assess --type exec -vv "$b" ;; esac
    done
fi

# --- Distribution zip ----------------------------------------------------------------------

if [ -n "$OUT_ZIP" ]; then
    [ "$SIGN_ONLY" -eq 1 ] && echo "Note: $OUT_ZIP holds bundles that are not notarized."
    if [ -e "$OUT_ZIP" ]; then echo "Replacing $OUT_ZIP"; rm -f "$OUT_ZIP"; fi
    if [ ${#BUNDLES[@]} -eq 1 ]; then
        ditto -c -k --keepParent "${BUNDLES[0]}" "$OUT_ZIP"
    else
        name=$(basename "$OUT_ZIP" .zip)
        mkdir -p "$WORK/dist/$name"
        for b in "${BUNDLES[@]}"; do ditto "$b" "$WORK/dist/$name/$(basename "$b")"; done
        ditto -c -k --keepParent "$WORK/dist/$name" "$OUT_ZIP"
    fi
    echo "Wrote $OUT_ZIP"
fi

echo "Done."
