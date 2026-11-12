#!/bin/bash
# package.sh - turn one product's build into its download: <Product>-<version>-<os>-<arch>.zip
# (macOS) or .tar.gz (Linux), holding the product, LICENSE and THIRD_PARTY_NOTICES.md, and add
# its line to SHA256SUMS.txt. A Linux app's package is an install tree (bin/, share/) to unpack
# into ~/.local, /usr/local or /opt.
#
# Usage:
#   package.sh [options] [PRODUCT_DIR [OUT_DIR]]
#
#   PRODUCT_DIR  the product's checkout, already built (cmake --build build); its folder name is
#                the product's key in products.json (StageHand, ModicumFM, ...). Default: the
#                current folder
#   OUT_DIR      where the archive and SHA256SUMS.txt go (made if missing). Default: out/ in
#                this repo, where publish.sh looks
#
# From a product's checkout, with UW_DOWNLOADS_DIR set to this repo's checkout:
#   "$UW_DOWNLOADS_DIR/scripts/package.sh"
#
# Steps:
#   1. Kind and formats from products.json; version from CMakeLists.txt's project(VERSION).
#      If HEAD is tagged, the tag must be v<version> (R4-4).
#   2. Files: an app is <P>.app (macOS); a plugin is <P>.clap, plus <P>.vst3 and (macOS)
#      <P>.component once products.json lists VST3 and AUv2 under "now".
#   3. Stage them in <P>-<version>-<os>-<arch>/ with LICENSE (LICENSE or LICENSE.txt) and
#      THIRD_PARTY_NOTICES.md. The build folder is never changed.
#      A Linux app is staged by its own install rules, cmake --install --prefix <stage>: bin/<app>,
#      share/<app>/help/, the .desktop entry and the icons; LICENSE and THIRD_PARTY_NOTICES.md go
#      in share/doc/<app>/, so unpacking with --strip-components=1 leaves nothing at the top.
#   4. Linux: stop if any staged binary needs a newer glibc or libstdc++ than Ubuntu 24.04 has
#      (R4-1), the oldest Linux the downloads support.
#      macOS: sign, notarize and staple the staged bundles with sign-notarize.sh (beside this
#      script), with PRODUCT_DIR/cmake/<P>.entitlements if there is one (StageHand).
#   5. Archive with ditto (macOS) or tar (Linux); replace the product's line in SHA256SUMS.txt.
#
# Options:
#   --sign-only        sign but don't notarize (passed to sign-notarize.sh); the archive's name
#                      ends in -unnotarized so it can't be mistaken for a release
#   --build-dir DIR    the build folder (default PRODUCT_DIR/build)
#   --products FILE    products.json (default: the one at this repo's top level)
#   --allow-dirty      package even if PRODUCT_DIR has uncommitted changes
#   -h, --help         show this help
#
# Environment: SIGN_IDENTITY and NOTARY_PROFILE pass through to sign-notarize.sh
# (SIGN_IDENTITY=- signs ad hoc, for testing, and implies --sign-only).
# MAX_GLIBC, MAX_GLIBCXX and MAX_CXXABI (Linux) are the newest symbol versions a binary may
# need: Ubuntu 24.04's, 2.39, 3.4.33 and 1.3.15. Change them only with the README's
# "What you need" section.

set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
SIGN_ONLY=0
ALLOW_DIRTY=0
BUILD_DIR=""
PRODUCTS=""
ARGS=()

die() { echo "error: $*" >&2; exit 1; }
usage() { awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "$0"; }

while [ $# -gt 0 ]; do
    case "$1" in
        --sign-only)   SIGN_ONLY=1; shift ;;
        --allow-dirty) ALLOW_DIRTY=1; shift ;;
        --build-dir)   [ $# -ge 2 ] || die "--build-dir needs a folder"; BUILD_DIR="$2"; shift 2 ;;
        --products)    [ $# -ge 2 ] || die "--products needs a file"; PRODUCTS="$2"; shift 2 ;;
        -h|--help)     usage; exit 0 ;;
        -*)            die "unknown option: $1" ;;
        *)             ARGS+=("$1"); shift ;;
    esac
done
[ ${#ARGS[@]} -le 2 ] || { usage >&2; exit 2; }
SRC_ARG=${ARGS[0]:-.}
OUT_ARG=${ARGS[1]:-$HERE/../out}

SRC=$(cd "$SRC_ARG" && pwd) || die "no such folder: $SRC_ARG"
[ -f "$SRC/CMakeLists.txt" ] || die "$SRC isn't a product checkout (no CMakeLists.txt)"
mkdir -p "$OUT_ARG"
OUT=$(cd "$OUT_ARG" && pwd)
BUILD_DIR=${BUILD_DIR:-$SRC/build}
[ -d "$BUILD_DIR" ] || die "no build folder: $BUILD_DIR (build first, or --build-dir)"

PRODUCTS=${PRODUCTS:-$HERE/../products.json}
[ -f "$PRODUCTS" ] || die "products.json not found: $PRODUCTS"

case "$(uname -s)" in
    Darwin) OS=macos ;;
    Linux)  OS=linux ;;
    *)      die "unsupported OS: $(uname -s)" ;;
esac
ARCH=$(uname -m)

# --- 1. Name, kind, formats, version ------------------------------------------------------

P=$(basename "$SRC")
info=$(python3 -I - "$PRODUCTS" "$P" <<'PY'
import json, sys
products = json.load(open(sys.argv[1]))["products"]
p = products.get(sys.argv[2])
if p is None:
    sys.exit("not a product in products.json: " + sys.argv[2])
now = (p.get("formats") or {}).get("now") or []
print(p["kind"])
print(" ".join(f.split()[0] for f in now))   # "AUv2 (macOS)" -> AUv2
PY
) || die "products.json has no entry for $P"
KIND=$(sed -n 1p <<<"$info")
FORMATS=$(sed -n 2p <<<"$info")

VERSION=$(grep -m1 -oE "^project\($P VERSION [0-9]+\.[0-9]+\.[0-9]+" "$SRC/CMakeLists.txt" | awk '{print $3}') \
    || die "no project($P VERSION x.y.z) in $SRC/CMakeLists.txt"

if git -C "$SRC" rev-parse --git-dir >/dev/null 2>&1; then
    if tag=$(git -C "$SRC" describe --exact-match --tags HEAD 2>/dev/null); then
        [ "$tag" = "v$VERSION" ] || die "HEAD is tagged $tag but CMake says $VERSION (R4-4)"
    fi
    if [ "$ALLOW_DIRTY" -eq 0 ] && [ -n "$(git -C "$SRC" status --porcelain --untracked-files=no)" ]; then
        die "$P has uncommitted changes (commit them, or --allow-dirty)"
    fi
fi

# --- 2. Which files -------------------------------------------------------------------------

FILES=()
if [ "$KIND" = app ]; then
    if [ "$OS" = macos ]; then FILES=("$BUILD_DIR/$P.app")
    else FILES=("$BUILD_DIR/cmake_install.cmake"); fi
else
    for f in $FORMATS; do
        case "$f" in
            CLAP) FILES+=("$BUILD_DIR/$P.clap") ;;
            VST3) if [ "$OS" = linux ]; then FILES+=("$BUILD_DIR/Release/$P.vst3")
                  else FILES+=("$BUILD_DIR/$P.vst3"); fi ;;
            AUv2) [ "$OS" = macos ] && FILES+=("$BUILD_DIR/$P.component") ;;
            *)    die "unknown format in products.json: $f" ;;
        esac
    done
fi
[ ${#FILES[@]} -gt 0 ] || die "nothing to package for $P"
for f in "${FILES[@]}"; do [ -e "$f" ] || die "not built: $f"; done

if [ "$OS" = macos ]; then
    for f in "${FILES[@]}"; do
        v=$(plutil -extract CFBundleShortVersionString raw -o - "$f/Contents/Info.plist" 2>/dev/null || true)
        [ "$v" = "$VERSION" ] || die "$(basename "$f") says version '$v', CMake says $VERSION (rebuild?)"
    done
fi

LICENSE=""
for l in LICENSE LICENSE.txt; do [ -f "$SRC/$l" ] && { LICENSE="$SRC/$l"; break; }; done
[ -n "$LICENSE" ] || die "no LICENSE in $SRC"
[ -f "$SRC/THIRD_PARTY_NOTICES.md" ] || die "no THIRD_PARTY_NOTICES.md in $SRC"

BASE="$P-$VERSION-$OS-$ARCH"
[ "$SIGN_ONLY" -eq 1 ] || [ "${SIGN_IDENTITY:-}" = "-" ] && SUFFIX="-unnotarized" || SUFFIX=""
if [ "$KIND" = app ] && [ "$OS" = linux ]; then
    echo "Packaging $P $VERSION ($KIND) for $OS-$ARCH: cmake --install $BUILD_DIR"
else
    echo "Packaging $P $VERSION ($KIND) for $OS-$ARCH: $(for f in "${FILES[@]}"; do printf '%s ' "$(basename "$f")"; done)"
fi

# --- 3. Stage ---------------------------------------------------------------------------------

WORK=$(mktemp -d "${TMPDIR:-/tmp}/package.XXXXXX")
trap 'rm -rf "$WORK"' EXIT
STAGE="$WORK/$BASE"
mkdir "$STAGE"
STAGED=()
if [ "$KIND" = app ] && [ "$OS" = linux ]; then
    # The build's own install rules (the same as cmake --install --prefix ~/.local).
    DESTDIR="" cmake --install "$BUILD_DIR" --prefix "$STAGE" >/dev/null \
        || die "cmake --install $BUILD_DIR failed"
    APP_BINS=("$STAGE"/bin/*)
    [ ${#APP_BINS[@]} -eq 1 ] && [ -x "${APP_BINS[0]}" ] \
        || die "expected one executable in bin/ after cmake --install, got: $(ls "$STAGE/bin" 2>/dev/null | tr '\n' ' ')"
    APP=$(basename "${APP_BINS[0]}")
    [ -f "$STAGE/share/$APP/help/help.html" ] || die "cmake --install left no share/$APP/help/help.html"
    ls "$STAGE"/share/applications/*.desktop >/dev/null 2>&1 || die "cmake --install left no .desktop entry"
    for d in "$STAGE"/*; do
        case "$(basename "$d")" in bin|share) ;; *) die "cmake --install wrote $(basename "$d")/, not just bin/ and share/" ;; esac
    done
    DOC="$STAGE/share/doc/$APP"
    mkdir -p "$DOC"
    cp "$LICENSE" "$DOC/LICENSE"
    cp "$SRC/THIRD_PARTY_NOTICES.md" "$DOC/"
    STAGED=("$STAGE")
else
    for f in "${FILES[@]}"; do
        if [ "$OS" = macos ]; then ditto "$f" "$STAGE/$(basename "$f")"
        else cp -R "$f" "$STAGE/"; fi
        STAGED+=("$STAGE/$(basename "$f")")
    done
    cp "$LICENSE" "$STAGE/LICENSE"
    cp "$SRC/THIRD_PARTY_NOTICES.md" "$STAGE/"
fi

# --- 4a. Oldest Linux the binaries run on (Linux) -----------------------------------------------
# A binary built on a newer system can ask for symbol versions Ubuntu 24.04's glibc or libstdc++
# doesn't have; it then fails to load there ("version GLIBC_2.40 not found").

if [ "$OS" = linux ]; then
    command -v objdump >/dev/null || die "objdump not found (apt install binutils)"
    declare -A MAX=([GLIBC]=${MAX_GLIBC:-2.39} [GLIBCXX]=${MAX_GLIBCXX:-3.4.33} [CXXABI]=${MAX_CXXABI:-1.3.15})
    ELF=$'\x7fELF'
    TOO_NEW=0
    while IFS= read -r -d '' bin; do
        [ "$(head -c4 "$bin")" = "$ELF" ] || continue
        syms=$(objdump -T "$bin") || die "objdump can't read $bin"
        need=""
        for lib in GLIBC GLIBCXX CXXABI; do
            v=$(grep -oE "\(${lib}_[0-9.]+\)" <<<"$syms" | tr -d '()' | sed "s/^${lib}_//" | sort -Vu | tail -1)
            [ -n "$v" ] || continue
            need+=" ${lib}_$v"
            if [ "$(printf '%s\n%s\n' "$v" "${MAX[$lib]}" | sort -V | tail -1)" != "${MAX[$lib]}" ]; then
                echo "error: ${bin#"$STAGE"/} needs ${lib}_$v; the limit is ${lib}_${MAX[$lib]} (MAX_$lib)" >&2
                TOO_NEW=1
            fi
        done
        echo "  ${bin#"$STAGE"/} needs${need:- nothing versioned}"
    done < <(find "${STAGED[@]}" -type f -print0)
    [ "$TOO_NEW" -eq 0 ] || die "build on Ubuntu 24.04 (R4-1), or the download won't run there"
fi

# --- 4. Sign and notarize (macOS) ---------------------------------------------------------------

if [ "$OS" = macos ]; then
    SN=(); [ "$SIGN_ONLY" -eq 1 ] && SN+=(--sign-only)
    [ -f "$SRC/cmake/$P.entitlements" ] && SN+=(--entitlements "$SRC/cmake/$P.entitlements")
    "$HERE/sign-notarize.sh" ${SN[@]+"${SN[@]}"} "${STAGED[@]}"
fi

# --- 5. Archive and checksum --------------------------------------------------------------------

if [ "$OS" = macos ]; then
    ARCHIVE="$BASE$SUFFIX.zip"
    rm -f "$OUT/$ARCHIVE"
    ditto -c -k --keepParent "$STAGE" "$OUT/$ARCHIVE"
    SUM=(shasum -a 256)
else
    ARCHIVE="$BASE.tar.gz"
    rm -f "$OUT/$ARCHIVE"
    tar -C "$WORK" -czf "$OUT/$ARCHIVE" "$BASE"
    SUM=(sha256sum)
fi

SUMS="$OUT/SHA256SUMS.txt"
touch "$SUMS"
grep -v "  $ARCHIVE\$" "$SUMS" > "$WORK/sums" || true
(cd "$OUT" && "${SUM[@]}" "$ARCHIVE") >> "$WORK/sums"
sort -k2 "$WORK/sums" > "$SUMS"

echo "Wrote $OUT/$ARCHIVE"
grep "  $ARCHIVE\$" "$SUMS"
