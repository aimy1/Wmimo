#!/usr/bin/env bash
# ==============================================================================
# Wmimo macOS Packaging Script
# Packages Wmimo.app into DMG (.dmg) and Portable Zip (.zip)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"

cd "${ROOT_DIR}"

# 1. Determine Tag and Version
TAG="${1:-${TAG:-}}"
if [ -z "$TAG" ] || [ "$TAG" = "main" ]; then
  if [ -f "pubspec.yaml" ]; then
    PUBSPEC_VER=$(grep '^version:' pubspec.yaml | sed 's/version: //' | cut -d'+' -f1 | tr -d ' \r\n')
    PUBSPEC_BUILD=$(grep '^version:' pubspec.yaml | sed 's/version: //' | cut -d'+' -f2 | tr -d ' \r\n')
    if [ -n "$PUBSPEC_BUILD" ]; then
      TAG="v${PUBSPEC_VER}.${PUBSPEC_BUILD}"
    else
      TAG="v${PUBSPEC_VER}"
    fi
  else
    TAG="v1.2.1.1503"
  fi
fi

if [[ "$TAG" != v* ]]; then
  TAG="v$TAG"
fi

RAW_VERSION="${TAG#v}"
mkdir -p "${DIST_DIR}"

echo "=========================================================="
echo " Packaging Wmimo for macOS ($TAG, version: $RAW_VERSION) "
echo "=========================================================="

# 2. Locate built Wmimo.app
CANDIDATE_APP_DIRS=(
  "${ROOT_DIR}/build/macos/Build/Products/Release/Wmimo.app"
  "${ROOT_DIR}/build/macos/Build/Products/Release/wmimo.app"
  "${ROOT_DIR}/dist/macos/Wmimo.app"
  "${ROOT_DIR}/build/macos/Build/Products/Debug/Wmimo.app"
)

APP_PATH=""
for p in "${CANDIDATE_APP_DIRS[@]}"; do
  if [ -d "$p" ]; then
    APP_PATH="$p"
    break
  fi
done

if [ -z "$APP_PATH" ]; then
  echo "[ERROR] Could not find built macOS application bundle (Wmimo.app)."
  echo "Checked locations:"
  for p in "${CANDIDATE_APP_DIRS[@]}"; do
    echo "  - $p"
  done
  echo "Please run 'flutter build macos --release' before running this script."
  exit 1
fi

echo "Using macOS app bundle: $APP_PATH"

# 3. Ensure Mihomo Core (wmimoService) is present inside the App Bundle
MACOS_BIN_DIR="${APP_PATH}/Contents/MacOS"
mkdir -p "${MACOS_BIN_DIR}"

CORE_TARGET="${MACOS_BIN_DIR}/wmimoService"

# Prepare Universal or Architecture-specific core
CORE_SRC=""
if [ -f "${ROOT_DIR}/bind/macos/core/wmimoService" ]; then
  CORE_SRC="${ROOT_DIR}/bind/macos/core/wmimoService"
elif [ -f "${ROOT_DIR}/bind/macos/core/wmimoService_arm64" ] && [ -f "${ROOT_DIR}/bind/macos/core/wmimoService_amd64" ] && command -v lipo >/dev/null 2>&1; then
  echo "Creating Universal Binary for wmimoService via lipo..."
  mkdir -p "${ROOT_DIR}/bind/macos/core"
  lipo -create -output "${ROOT_DIR}/bind/macos/core/wmimoService" \
    "${ROOT_DIR}/bind/macos/core/wmimoService_arm64" \
    "${ROOT_DIR}/bind/macos/core/wmimoService_amd64"
  CORE_SRC="${ROOT_DIR}/bind/macos/core/wmimoService"
elif [ -f "${ROOT_DIR}/bind/macos/core/wmimoService_arm64" ]; then
  CORE_SRC="${ROOT_DIR}/bind/macos/core/wmimoService_arm64"
elif [ -f "${ROOT_DIR}/bind/macos/core/wmimoService_amd64" ]; then
  CORE_SRC="${ROOT_DIR}/bind/macos/core/wmimoService_amd64"
fi

if [ -n "$CORE_SRC" ] && [ -f "$CORE_SRC" ]; then
  echo "Embedding Mihomo core from $CORE_SRC to $CORE_TARGET..."
  cp -f "$CORE_SRC" "$CORE_TARGET"
  chmod 755 "$CORE_TARGET"
else
  echo "[WARNING] bind/macos/core/wmimoService not found! Embedded core will rely on runtime fallback."
fi

# 4. Clean ad-hoc code signature for bundle components
if command -v codesign >/dev/null 2>&1; then
  echo "Applying clean ad-hoc code signature to bundle components..."
  ENTITLEMENTS="${ROOT_DIR}/macos/Runner/Runner.entitlements"

  # Clean quarantine attributes
  if command -v xattr >/dev/null 2>&1; then
    xattr -cr "$APP_PATH" 2>/dev/null || true
  fi

  # Sign all Frameworks and dylibs first
  if [ -d "${APP_PATH}/Contents/Frameworks" ]; then
    find "${APP_PATH}/Contents/Frameworks" -type f -perm +111 2>/dev/null | while read -r fw; do
      codesign --force --sign - "$fw" 2>/dev/null || true
    done
  fi

  # Sign helper binaries in MacOS directory
  if [ -d "${APP_PATH}/Contents/MacOS" ]; then
    find "${APP_PATH}/Contents/MacOS" -type f -perm +111 2>/dev/null | while read -r bin; do
      if [ -f "$ENTITLEMENTS" ]; then
        codesign --force --sign - --entitlements "$ENTITLEMENTS" "$bin" 2>/dev/null || codesign --force --sign - "$bin" 2>/dev/null || true
      else
        codesign --force --sign - "$bin" 2>/dev/null || true
      fi
    done
  fi

  # Sign App Bundle
  if [ -f "$ENTITLEMENTS" ]; then
    codesign --force --sign - --entitlements "$ENTITLEMENTS" "$APP_PATH" 2>/dev/null || true
  else
    codesign --force --sign - "$APP_PATH" 2>/dev/null || true
  fi
fi

# Detect Architecture of the built app (Universal, arm64, or x86_64)
ARCH_INFO="universal"
MAIN_BIN="${APP_PATH}/Contents/MacOS/Wmimo"
if [ ! -f "$MAIN_BIN" ]; then
  MAIN_BIN="${APP_PATH}/Contents/MacOS/wmimo"
fi
if [ -f "$MAIN_BIN" ] && command -v file >/dev/null 2>&1; then
  FILE_OUT=$(file "$MAIN_BIN")
  if echo "$FILE_OUT" | grep -q "arm64" && echo "$FILE_OUT" | grep -q "x86_64"; then
    ARCH_INFO="universal"
  elif echo "$FILE_OUT" | grep -q "arm64"; then
    ARCH_INFO="arm64"
  elif echo "$FILE_OUT" | grep -q "x86_64"; then
    ARCH_INFO="x64"
  fi
fi

DMG_NAME="Wmimo-macOS-${ARCH_INFO}-${TAG}.dmg"
ZIP_NAME="Wmimo-macOS-${ARCH_INFO}-${TAG}.zip"

# 5. Package Portable Zip via ditto (preserves symlinks and file attributes)
echo "[1/2] Creating Portable Zip ($ZIP_NAME)..."
rm -f "${DIST_DIR}/${ZIP_NAME}"
ditto -c -k --keepParent "$APP_PATH" "${DIST_DIR}/${ZIP_NAME}"
echo "  -> Created ${DIST_DIR}/${ZIP_NAME}"

# 6. Package DMG Installer
echo "[2/2] Creating DMG Installer ($DMG_NAME)..."
STAGE_DIR=$(mktemp -d /tmp/wmimo_dmg_stage_XXXXXX)
cleanup() {
  rm -rf "${STAGE_DIR}"
}
trap cleanup EXIT

# Copy app bundle into stage directory
cp -R "$APP_PATH" "${STAGE_DIR}/Wmimo.app"

# Create Applications symlink for drag-and-drop install
ln -s /Applications "${STAGE_DIR}/Applications"

# Optional: copy icon if present
if [ -f "${ROOT_DIR}/assets/images/app_icon_256.png" ]; then
  cp "${ROOT_DIR}/assets/images/app_icon_256.png" "${STAGE_DIR}/.VolumeIcon.png" 2>/dev/null || true
fi

# Remove previous DMG if exists
rm -f "${DIST_DIR}/${DMG_NAME}"

# Build DMG using hdiutil
hdiutil create \
  -volname "Wmimo" \
  -srcfolder "${STAGE_DIR}" \
  -ov \
  -format UDZO \
  "${DIST_DIR}/${DMG_NAME}"

echo "  -> Created ${DIST_DIR}/${DMG_NAME}"

echo "=========================================================="
echo " macOS Packaging Complete!"
echo " Outputs in dist/:"
ls -lh "${DIST_DIR}/${DMG_NAME}" "${DIST_DIR}/${ZIP_NAME}"
echo "=========================================================="
