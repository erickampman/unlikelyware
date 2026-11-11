#!/bin/bash
# publish.sh - upload packages made by package.sh to a release in this repo, and merge their
# checksums into the release's SHA256SUMS.txt. For publishing one product from one machine,
# without the release workflow.
#
# Usage:
#   publish.sh [options] TAG PACKAGE...
#
#   TAG      the release: v0.9.0 (the preview, every product) or <Product>-<version>
#            (one product's release, after 1.0.0)
#   PACKAGE  <Product>-<version>-<os>-<arch>.zip or .tar.gz, as package.sh writes them
#
# Steps:
#   1. Checks each package: its name, that it isn't -unnotarized, that its version fits TAG,
#      and on a Mac that every bundle in a .zip has its notarization ticket stapled.
#   2. The release must exist, unless --create, which makes it as a draft.
#   3. Uploads the packages, replacing any of the same name.
#   4. Downloads the release's SHA256SUMS.txt, replaces these packages' lines, uploads it.
#
# Options:
#   --create           create TAG as a draft release if it doesn't exist (publish it later
#                      with: gh release edit TAG --draft=false)
#   --title TEXT       the new release's title (with --create; default TAG)
#   --notes-file FILE  the new release's notes (with --create; default: none)
#   -h, --help         show this help
#
# Environment: PUBLISH_REPO (default erickampman/unlikelyware).
#
# Two machines publishing to the same release at the same moment can lose one's checksum line;
# publish one at a time.

set -euo pipefail

REPO=${PUBLISH_REPO:-erickampman/unlikelyware}
CREATE=0
TITLE=""
NOTES=""
ARGS=()

die() { echo "error: $*" >&2; exit 1; }
usage() { awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "$0"; }

while [ $# -gt 0 ]; do
    case "$1" in
        --create)     CREATE=1; shift ;;
        --title)      [ $# -ge 2 ] || die "--title needs text"; TITLE="$2"; shift 2 ;;
        --notes-file) [ $# -ge 2 ] || die "--notes-file needs a file"; NOTES="$2"; shift 2 ;;
        -h|--help)    usage; exit 0 ;;
        -*)           die "unknown option: $1" ;;
        *)            ARGS+=("$1"); shift ;;
    esac
done
[ ${#ARGS[@]} -ge 2 ] || { usage >&2; exit 2; }
TAG=${ARGS[0]}
PKGS=("${ARGS[@]:1}")
[ -z "$NOTES" ] || [ -f "$NOTES" ] || die "no such notes file: $NOTES"

command -v gh >/dev/null || die "gh isn't installed"
if command -v sha256sum >/dev/null; then SUM=(sha256sum); else SUM=(shasum -a 256); fi

# --- 1. Check the packages ------------------------------------------------------------------

NAME_RE='^([A-Za-z0-9]+)-([0-9]+\.[0-9]+\.[0-9]+)-(macos|linux)-([a-z0-9_]+)\.(zip|tar\.gz)$'
for f in "${PKGS[@]}"; do
    [ -f "$f" ] || die "no such file: $f"
    n=$(basename "$f")
    case "$n" in *-unnotarized.*) die "$n isn't notarized (made with --sign-only or SIGN_IDENTITY=-)" ;; esac
    [[ "$n" =~ $NAME_RE ]] || die "$n isn't named <Product>-<version>-<os>-<arch>.zip or .tar.gz"
    p=${BASH_REMATCH[1]} v=${BASH_REMATCH[2]} os=${BASH_REMATCH[3]} ext=${BASH_REMATCH[5]}
    case "$TAG" in
        v*)  [ "$v" = "${TAG#v}" ] || die "$n is version $v, but the release is $TAG" ;;
        *-*) [ "$p-$v" = "$TAG" ] || die "$n is $p $v, but the release is $TAG" ;;
        *)   die "TAG should be v<version> or <Product>-<version>: $TAG" ;;
    esac
    [ "$os" = macos ] && [ "$ext" != zip ] && die "$n: a macOS package should be a .zip"
    [ "$os" = linux ] && [ "$ext" != tar.gz ] && die "$n: a Linux package should be a .tar.gz"
    if [ "$os" = macos ]; then
        if [ "$(uname -s)" = Darwin ]; then
            t=$(mktemp -d)
            ditto -x -k "$f" "$t"
            found=0
            while IFS= read -r b; do
                found=1
                xcrun stapler validate -q "$b" >/dev/null 2>&1 || { rm -rf "$t"; die "$n: no stapled ticket on $(basename "$b")"; }
            done < <(find "$t" -maxdepth 2 \( -name '*.app' -o -name '*.clap' -o -name '*.vst3' -o -name '*.component' \))
            rm -rf "$t"
            [ "$found" -eq 1 ] || die "$n holds no bundle"
        else
            echo "note: not on a Mac, so $n's notarization isn't checked"
        fi
    fi
done

# --- 2. The release -------------------------------------------------------------------------

if ! gh release view "$TAG" -R "$REPO" >/dev/null 2>&1; then
    [ "$CREATE" -eq 1 ] || die "no release $TAG in $REPO (--create makes it, as a draft)"
    NA=(--notes ""); [ -n "$NOTES" ] && NA=(--notes-file "$NOTES")
    gh release create "$TAG" -R "$REPO" --draft --title "${TITLE:-$TAG}" "${NA[@]}"
    echo "Created $TAG as a draft."
fi

# --- 3, 4. Upload, then the checksums --------------------------------------------------------

WORK=$(mktemp -d "${TMPDIR:-/tmp}/publish.XXXXXX")
trap 'rm -rf "$WORK"' EXIT

gh release upload "$TAG" -R "$REPO" --clobber "${PKGS[@]}"

if gh release download "$TAG" -R "$REPO" -p SHA256SUMS.txt -D "$WORK" 2>/dev/null; then :; else : > "$WORK/SHA256SUMS.txt"; fi
cp "$WORK/SHA256SUMS.txt" "$WORK/old"
for f in "${PKGS[@]}"; do
    n=$(basename "$f")
    grep -v "  $n\$" "$WORK/old" > "$WORK/next" || true
    mv "$WORK/next" "$WORK/old"
    (cd "$(dirname "$f")" && "${SUM[@]}" "$n") >> "$WORK/old"
done
sort -k2 "$WORK/old" > "$WORK/SHA256SUMS.txt"
gh release upload "$TAG" -R "$REPO" --clobber "$WORK/SHA256SUMS.txt"

echo "Published to $REPO $TAG:"
for f in "${PKGS[@]}"; do grep "  $(basename "$f")\$" "$WORK/SHA256SUMS.txt"; done
