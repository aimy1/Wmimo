#!/usr/bin/env bash
# ==============================================================================
# Wmimo iOS Packaging Script
# Packages Runner.app (including wmimoService.appex) into .ipa for TrollStore & Sideload
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
    TAG="v1.2.0.1501"
  fi
fi

echo "======================================================================"
echo " Packaging Wmimo iOS IPA"
echo " Tag: $TAG"
echo "======================================================================"

mkdir -p "${DIST_DIR}"

# 2. Locate built application bundle (.app)
CANDIDATE_APP_DIRS=(
  "${ROOT_DIR}/build/ios/iphoneos/Wmimo.app"
  "${ROOT_DIR}/build/ios/iphoneos/Runner.app"
  "${ROOT_DIR}/build/ios/Release-iphoneos/Wmimo.app"
  "${ROOT_DIR}/build/ios/Release-iphoneos/Runner.app"
  "${ROOT_DIR}/build/ios/archive/Runner.xcarchive/Products/Applications/Wmimo.app"
  "${ROOT_DIR}/build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app"
)

APP_PATH=""
for p in "${CANDIDATE_APP_DIRS[@]}"; do
  if [ -d "$p" ]; then
    APP_PATH="$p"
    break
  fi
done

if [ -z "$APP_PATH" ]; then
  # Dynamic fallback: find any .app bundle inside build/ios
  APP_PATH=$(find "${ROOT_DIR}/build/ios" -type d -name "*.app" -not -path "*/PlugIns/*" -not -path "*/Frameworks/*" 2>/dev/null | grep -E "Release|iphoneos" | head -n 1 || true)
fi

if [ -z "$APP_PATH" ]; then
  APP_PATH=$(find "${ROOT_DIR}/build" -type d -name "*.app" -not -path "*/PlugIns/*" -not -path "*/Frameworks/*" 2>/dev/null | head -n 1 || true)
fi

if [ -z "$APP_PATH" ]; then
  echo "[ERROR] Could not find built iOS application bundle (.app)."
  echo "Checked locations:"
  for p in "${CANDIDATE_APP_DIRS[@]}"; do
    echo "  - $p"
  done
  echo "Available directories under build/ios:"
  ls -la "${ROOT_DIR}/build/ios" 2>/dev/null || true
  echo "Please run 'flutter build ios --release --no-codesign' before running this script."
  exit 1
fi

echo "Using iOS app bundle: $APP_PATH"

# 3. Verify embedded VPN NetworkExtension and Widgets
if [ -d "${APP_PATH}/PlugIns/wmimoService.appex" ]; then
  echo "  [OK] Found embedded VPN extension: PlugIns/wmimoService.appex"
else
  echo "  [WARNING] PlugIns/wmimoService.appex not found in ${APP_PATH}. VPN may require manual configuration."
fi

if [ -d "${APP_PATH}/PlugIns/wmimoWidgetExtension.appex" ]; then
  echo "  [OK] Found embedded Widget extension: PlugIns/wmimoWidgetExtension.appex"
fi

# 4. Clean quarantine and sanitize attributes
if command -v xattr >/dev/null 2>&1; then
  xattr -cr "$APP_PATH" 2>/dev/null || true
fi

IPA_NAME="Wmimo-iOS-universal-${TAG}.ipa"
PAYLOAD_DIR="${ROOT_DIR}/build/ios/Payload"

rm -rf "${PAYLOAD_DIR}"
mkdir -p "${PAYLOAD_DIR}"

echo "Preparing Payload directory..."
cp -R "${APP_PATH}" "${PAYLOAD_DIR}/"

cd "${ROOT_DIR}/build/ios"
echo "Creating IPA archive: ${DIST_DIR}/${IPA_NAME}..."
rm -f "${DIST_DIR}/${IPA_NAME}"
zip -r -y "${DIST_DIR}/${IPA_NAME}" Payload >/dev/null

rm -rf "${PAYLOAD_DIR}"
cd "${ROOT_DIR}"

if [ -f "${DIST_DIR}/${IPA_NAME}" ]; then
  echo "======================================================================"
  echo " [SUCCESS] iOS IPA Package created:"
  ls -lh "${DIST_DIR}/${IPA_NAME}"
  echo " Compatible with TrollStore, AltStore, Sideloadly, and enterprise signing."
  echo "======================================================================"
else
  echo "[ERROR] Failed to create ${DIST_DIR}/${IPA_NAME}."
  exit 1
fi
