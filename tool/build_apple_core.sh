#!/usr/bin/env bash
# ==============================================================================
# Wmimo Apple Core Build Script
# Builds Libclash.xcframework for iOS, iOS Simulator, and macOS
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_DIR="${ROOT_DIR}/bind/apple"
BUILD_TMP_DIR="${ROOT_DIR}/build/apple_core_tmp"

MIHOMO_TAG="v1.19.32"
MIHOMO_REPO="https://github.com/MetaCubeX/mihomo.git"

echo "=== [1/5] Checking Build Environment ==="
command -v go >/dev/null 2>&1 || { echo >&2 "[ERROR] Go is required but not installed. Aborting."; exit 1; }
command -v git >/dev/null 2>&1 || { echo >&2 "[ERROR] Git is required but not installed. Aborting."; exit 1; }

if [[ "$(uname)" != "Darwin" ]]; then
    echo "[WARNING] This script is intended to run on macOS with Xcode installed."
    echo "[WARNING] gomobile targeting iOS/macOS frameworks requires Darwin host."
fi

mkdir -p "${OUTPUT_DIR}"
mkdir -p "${BUILD_TMP_DIR}"

echo "=== [2/5] Installing and Initializing gomobile ==="
go install golang.org/x/mobile/cmd/gomobile@latest
go install golang.org/x/mobile/cmd/gobind@latest
export PATH="$(go env GOPATH)/bin:${PATH}"
gomobile init

echo "=== [3/5] Fetching Mihomo Source (${MIHOMO_TAG}) ==="
if [ ! -d "${BUILD_TMP_DIR}/mihomo" ]; then
    git clone --depth 1 --branch "${MIHOMO_TAG}" "${MIHOMO_REPO}" "${BUILD_TMP_DIR}/mihomo"
else
    echo "Using existing clone at ${BUILD_TMP_DIR}/mihomo"
fi

cd "${BUILD_TMP_DIR}/mihomo"

# Copy Apple Go Bridge package into Mihomo module
mkdir -p "${BUILD_TMP_DIR}/mihomo/libclash"
cp "${ROOT_DIR}/tool/apple_bridge/libclash.go" "${BUILD_TMP_DIR}/mihomo/libclash/libclash.go"

echo "=== [4/5] Building Libclash.xcframework via gomobile bind ==="
# Target iOS devices (arm64), iOS Simulator (arm64, x86_64), and macOS (arm64, x86_64)
gomobile bind \
    -target=ios,iossimulator,macos \
    -bundleid=com.wmimo.app.libclash \
    -ldflags="-s -w" \
    -o "${OUTPUT_DIR}/Libclash.xcframework" \
    ./libclash

echo "=== [5/5] Build Completed Successfully ==="
echo "Artifact generated at: ${OUTPUT_DIR}/Libclash.xcframework"
ls -la "${OUTPUT_DIR}/Libclash.xcframework"
