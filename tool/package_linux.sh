#!/usr/bin/env bash
set -e

# Extract version from argument, environment, or pubspec.yaml
TAG="${1:-$TAG}"
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
    TAG="v1.2.13.1515"
  fi
fi

# Ensure TAG starts with 'v'
if [[ "$TAG" != v* ]]; then
  TAG="v$TAG"
fi

RAW_VERSION="${TAG#v}"
if [ -z "$RAW_VERSION" ] || [ "$RAW_VERSION" = "v" ]; then
  RAW_VERSION="1.2.13.1515"
  TAG="v1.2.13.1515"
fi
VERSION="$RAW_VERSION"

# Detect target architecture (supports x64 and arm64)
ARCH_INPUT="${2:-$(uname -m)}"
case "$ARCH_INPUT" in
  aarch64|arm64)
    ARCH_LABEL="arm64"
    DEB_ARCH="arm64"
    RPM_ARCH="aarch64"
    APPIMAGE_ARCH="aarch64"
    BUNDLE_DIR="build/linux/arm64/release/bundle"
    CORE_SRC="bind/linux/core_arm64/wmimoService"
    ;;
  *)
    ARCH_LABEL="x64"
    DEB_ARCH="amd64"
    RPM_ARCH="x86_64"
    APPIMAGE_ARCH="x86_64"
    BUNDLE_DIR="build/linux/x64/release/bundle"
    CORE_SRC="bind/linux/core/wmimoService"
    ;;
esac

DIST_DIR="dist"
mkdir -p "$DIST_DIR"

echo "=========================================================="
echo " Packaging Wmimo for Linux ($ARCH_LABEL, $TAG, version: $RAW_VERSION) "
echo "=========================================================="

# 0. Ensure Linux core service is copied & executable
if [ -f "$CORE_SRC" ]; then
  cp "$CORE_SRC" "$BUNDLE_DIR/wmimoService"
  chmod +x "$BUNDLE_DIR/wmimoService"
elif [ -f "bind/linux/core/wmimoService" ]; then
  cp "bind/linux/core/wmimoService" "$BUNDLE_DIR/wmimoService"
  chmod +x "$BUNDLE_DIR/wmimoService"
fi
chmod +x "$BUNDLE_DIR/wmimo"

# ------------------------------------------------------------
# 1. Universal Portable Archive (.tar.gz) - All Linux Distros
# ------------------------------------------------------------
echo "[1/5] Packaging Universal Portable Tarball (.tar.gz)..."
PORTABLE_DIR="Wmimo-Linux-${ARCH_LABEL}-$TAG"
rm -rf "$PORTABLE_DIR"
mkdir -p "$PORTABLE_DIR"
cp -r "$BUNDLE_DIR"/* "$PORTABLE_DIR/"

if [ -f "assets/images/app_icon_256.png" ]; then
  cp assets/images/app_icon_256.png "$PORTABLE_DIR/wmimo.png"
fi

cat << 'EOF' > "$PORTABLE_DIR/wmimo.desktop"
[Desktop Entry]
Name=Wmimo
GenericName=Wmimo
Comment=Modern cross-platform Clash/Mihomo GUI proxy client.
Exec=wmimo %u
Icon=wmimo
Terminal=false
Type=Application
Categories=Network;Utility;
StartupNotify=true
MimeType=x-scheme-handler/wmimo;x-scheme-handler/clash;
EOF

cat << 'EOF' > "$PORTABLE_DIR/install.sh"
#!/usr/bin/env bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p ~/.local/bin ~/.local/share/applications ~/.local/share/icons/hicolor/256x256/apps
ln -sf "$DIR/wmimo" ~/.local/bin/wmimo
if [ -f "$DIR/wmimo.png" ]; then
  cp "$DIR/wmimo.png" ~/.local/share/icons/hicolor/256x256/apps/wmimo.png
fi
sed "s|Exec=wmimo|Exec=$DIR/wmimo|g" "$DIR/wmimo.desktop" > ~/.local/share/applications/wmimo.desktop
echo "Wmimo installed to ~/.local/share/applications/wmimo.desktop and ~/.local/bin/wmimo"
EOF
chmod +x "$PORTABLE_DIR/install.sh"

tar -czf "$DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.tar.gz" "$PORTABLE_DIR"
rm -rf "$PORTABLE_DIR"
echo "  -> Created $DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.tar.gz"

# ------------------------------------------------------------
# Common Base Layout for Deb, RPM, and Pacman packages
# ------------------------------------------------------------
PKG_ROOT="linux_pkg_root_${ARCH_LABEL}"
rm -rf "$PKG_ROOT"
mkdir -p "$PKG_ROOT/opt/wmimo"
mkdir -p "$PKG_ROOT/usr/bin"
mkdir -p "$PKG_ROOT/usr/share/applications"
mkdir -p "$PKG_ROOT/usr/share/icons/hicolor/256x256/apps"

cp -r "$BUNDLE_DIR"/* "$PKG_ROOT/opt/wmimo/"
ln -sf /opt/wmimo/wmimo "$PKG_ROOT/usr/bin/wmimo"

if [ -f "assets/images/app_icon_256.png" ]; then
  cp assets/images/app_icon_256.png "$PKG_ROOT/usr/share/icons/hicolor/256x256/apps/wmimo.png"
fi

cat << 'EOF' > "$PKG_ROOT/usr/share/applications/wmimo.desktop"
[Desktop Entry]
Name=Wmimo
GenericName=Wmimo
Comment=Modern cross-platform Clash/Mihomo GUI proxy client.
Exec=/opt/wmimo/wmimo %u
Icon=wmimo
Terminal=false
Type=Application
Categories=Network;Utility;
StartupNotify=true
MimeType=x-scheme-handler/wmimo;x-scheme-handler/clash;
EOF

# ------------------------------------------------------------
# 2. Debian / Ubuntu / Mint / Deepin Package (.deb)
# ------------------------------------------------------------
echo "[2/5] Packaging Debian Package (.deb)..."
mkdir -p "$PKG_ROOT/DEBIAN"
cat << EOF > "$PKG_ROOT/DEBIAN/control"
Package: wmimo
Version: $RAW_VERSION
Section: net
Priority: optional
Architecture: $DEB_ARCH
Depends: libgtk-3-0, libayatana-appindicator3-1, libkeybinder-3.0-0, libsecret-1-0, libstdc++6
Maintainer: Wmimo <https://github.com/aimy1/Wmimo>
Homepage: https://github.com/aimy1/Wmimo
Description: Modern cross-platform Clash/Mihomo GUI proxy client.
 A sleek, modern proxy GUI client crafted with Flutter and Mihomo core.
EOF

dpkg-deb --build "$PKG_ROOT" "$DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.deb"
rm -rf "$PKG_ROOT/DEBIAN"
echo "  -> Created $DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.deb"

# ------------------------------------------------------------
# 3. RedHat / Fedora / CentOS / openSUSE Package (.rpm)
# ------------------------------------------------------------
echo "[3/5] Packaging RedHat / Fedora RPM Package (.rpm)..."
if command -v fpm >/dev/null 2>&1; then
  fpm -s dir -t rpm \
    -n wmimo \
    -v "$RAW_VERSION" \
    -a "$RPM_ARCH" \
    --license "GPL-3.0" \
    --vendor "Wmimo" \
    --url "https://github.com/aimy1/Wmimo" \
    --description "Modern cross-platform Clash/Mihomo GUI proxy client." \
    --category "Network" \
    --depends gtk3 \
    --depends libsecret \
    -C "$PKG_ROOT" \
    -p "$DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.rpm"
  echo "  -> Created $DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.rpm"
else
  echo "  [Notice] fpm not found, skipping RPM package generation."
fi

# ------------------------------------------------------------
# 4. Arch Linux / Manjaro Package (.pacman / .pkg.tar.zst)
# ------------------------------------------------------------
echo "[4/5] Packaging Arch Linux / Manjaro Package (.pkg.tar.zst)..."
if command -v fpm >/dev/null 2>&1; then
  if command -v bsdtar >/dev/null 2>&1; then
    fpm -s dir -t pacman \
      -n wmimo \
      -v "$RAW_VERSION" \
      -a "$RPM_ARCH" \
      --license "GPL-3.0" \
      --vendor "Wmimo" \
      --url "https://github.com/aimy1/Wmimo" \
      --description "Modern cross-platform Clash/Mihomo GUI proxy client." \
      --category "Network" \
      -C "$PKG_ROOT" \
      -p "$DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.pkg.tar.zst" || true
    echo "  -> Created $DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.pkg.tar.zst"
  else
    echo "  [Notice] bsdtar not found, skipping pacman generation."
  fi
else
  echo "  [Notice] fpm not found, skipping Pacman package generation."
fi
rm -rf "$PKG_ROOT"

# ------------------------------------------------------------
# 5. Universal AppImage Package (.AppImage)
# ------------------------------------------------------------
echo "[5/5] Packaging Universal AppImage (.AppImage)..."
APP_DIR="AppDir_${ARCH_LABEL}"
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/usr/bin"
mkdir -p "$APP_DIR/usr/lib"
mkdir -p "$APP_DIR/usr/share/applications"
mkdir -p "$APP_DIR/usr/share/icons/hicolor/256x256/apps"

cp -r "$BUNDLE_DIR"/* "$APP_DIR/usr/bin/"
if [ -d "$BUNDLE_DIR/lib" ]; then
  cp -r "$BUNDLE_DIR/lib"/* "$APP_DIR/usr/lib/" 2>/dev/null || true
fi

if [ -f "assets/images/app_icon_256.png" ]; then
  cp assets/images/app_icon_256.png "$APP_DIR/wmimo.png"
  cp assets/images/app_icon_256.png "$APP_DIR/.DirIcon"
  cp assets/images/app_icon_256.png "$APP_DIR/usr/share/icons/hicolor/256x256/apps/wmimo.png"
fi

cat << 'EOF' > "$APP_DIR/wmimo.desktop"
[Desktop Entry]
Name=Wmimo
GenericName=Wmimo
Comment=Modern cross-platform Clash/Mihomo GUI proxy client.
Exec=wmimo %u
Icon=wmimo
Terminal=false
Type=Application
Categories=Network;Utility;
StartupNotify=true
MimeType=x-scheme-handler/wmimo;x-scheme-handler/clash;
EOF
cp "$APP_DIR/wmimo.desktop" "$APP_DIR/usr/share/applications/wmimo.desktop"

cat << 'EOF' > "$APP_DIR/AppRun"
#!/usr/bin/env bash
HERE="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="${HERE}/usr/lib:${HERE}/usr/bin/lib:${LD_LIBRARY_PATH}"
export PATH="${HERE}/usr/bin:${PATH}"
exec "${HERE}/usr/bin/wmimo" "$@"
EOF
chmod +x "$APP_DIR/AppRun"

APPIMAGETOOL_BIN="appimagetool-${APPIMAGE_ARCH}"
if [ ! -f "$APPIMAGETOOL_BIN" ]; then
  echo "Downloading $APPIMAGETOOL_BIN..."
  TOOL_URL_1="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-${APPIMAGE_ARCH}.AppImage"
  TOOL_URL_2="https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-${APPIMAGE_ARCH}.AppImage"
  if command -v curl >/dev/null 2>&1; then
    curl -fL "$TOOL_URL_1" -o "$APPIMAGETOOL_BIN" || curl -fL "$TOOL_URL_2" -o "$APPIMAGETOOL_BIN" || true
  elif command -v wget >/dev/null 2>&1; then
    wget -q "$TOOL_URL_1" -O "$APPIMAGETOOL_BIN" || wget -q "$TOOL_URL_2" -O "$APPIMAGETOOL_BIN" || true
  fi
  if [ -f "$APPIMAGETOOL_BIN" ]; then
    chmod +x "$APPIMAGETOOL_BIN"
  fi
fi

if [ -f "$APPIMAGETOOL_BIN" ]; then
  APPIMAGE_EXTRACT_AND_RUN=1 ARCH="$APPIMAGE_ARCH" ./"$APPIMAGETOOL_BIN" --no-appstream "$APP_DIR" "$DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.AppImage"
  if [ -f "$DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.AppImage" ]; then
    chmod +x "$DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.AppImage"
    echo "  -> Created $DIST_DIR/Wmimo-Linux-${ARCH_LABEL}-$TAG.AppImage"
  fi
fi
rm -rf "$APP_DIR"

echo "=========================================================="
echo " All Linux ($ARCH_LABEL) Packages Built in $DIST_DIR/:"
echo "=========================================================="
ls -lh "$DIST_DIR"/Wmimo-Linux* || true
