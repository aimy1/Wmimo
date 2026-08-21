#!/usr/bin/env bash
set -e

TAG="${1:-v1.0.33}"
RAW_VERSION="${TAG#v}"
BUNDLE_DIR="build/linux/x64/release/bundle"
DIST_DIR="dist"

mkdir -p "$DIST_DIR"

echo "=========================================================="
echo " Packaging Wmimo for all Linux Distributions ($TAG) "
echo "=========================================================="

# 0. Ensure Linux core service is copied & executable
if [ -f "bind/linux/core/wmimoService" ]; then
  cp bind/linux/core/wmimoService "$BUNDLE_DIR/wmimoService"
  chmod +x "$BUNDLE_DIR/wmimoService"
fi
chmod +x "$BUNDLE_DIR/wmimo"

# ------------------------------------------------------------
# 1. Universal Portable Archive (.tar.gz) - All Linux Distros
# ------------------------------------------------------------
echo "[1/5] Packaging Universal Portable Tarball (.tar.gz)..."
PORTABLE_DIR="Wmimo-Linux-x64-$TAG"
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

tar -czf "$DIST_DIR/Wmimo-Linux-x64-$TAG.tar.gz" "$PORTABLE_DIR"
rm -rf "$PORTABLE_DIR"
echo "  -> Created $DIST_DIR/Wmimo-Linux-x64-$TAG.tar.gz"

# ------------------------------------------------------------
# Common Base Layout for Deb, RPM, and Pacman packages
# ------------------------------------------------------------
PKG_ROOT="linux_pkg_root"
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
Architecture: amd64
Depends: libgtk-3-0, libayatana-appindicator3-1, libkeybinder-3.0-0, libsecret-1-0, libstdc++6
Maintainer: Wmimo <https://github.com/aimy1/Wmimo>
Homepage: https://github.com/aimy1/Wmimo
Description: Modern cross-platform Clash/Mihomo GUI proxy client.
 A sleek, modern proxy GUI client crafted with Flutter and Mihomo core.
EOF

dpkg-deb --build "$PKG_ROOT" "$DIST_DIR/Wmimo-Linux-x64-$TAG.deb"
rm -rf "$PKG_ROOT/DEBIAN"
echo "  -> Created $DIST_DIR/Wmimo-Linux-x64-$TAG.deb"

# ------------------------------------------------------------
# 3. RedHat / Fedora / CentOS / openSUSE Package (.rpm)
# ------------------------------------------------------------
echo "[3/5] Packaging RedHat / Fedora RPM Package (.rpm)..."
if command -v fpm >/dev/null 2>&1; then
  fpm -s dir -t rpm \
    -n wmimo \
    -v "$RAW_VERSION" \
    -a x86_64 \
    --license "GPL-3.0" \
    --vendor "Wmimo" \
    --url "https://github.com/aimy1/Wmimo" \
    --description "Modern cross-platform Clash/Mihomo GUI proxy client." \
    --category "Network" \
    --depends gtk3 \
    --depends libsecret \
    -C "$PKG_ROOT" \
    -p "$DIST_DIR/Wmimo-Linux-x64-$TAG.rpm"
  echo "  -> Created $DIST_DIR/Wmimo-Linux-x64-$TAG.rpm"
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
      -a x86_64 \
      --license "GPL-3.0" \
      --vendor "Wmimo" \
      --url "https://github.com/aimy1/Wmimo" \
      --description "Modern cross-platform Clash/Mihomo GUI proxy client." \
      --category "Network" \
      -C "$PKG_ROOT" \
      -p "$DIST_DIR/Wmimo-Linux-x64-$TAG.pkg.tar.zst" || true
    echo "  -> Created $DIST_DIR/Wmimo-Linux-x64-$TAG.pkg.tar.zst"
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
APP_DIR="AppDir"
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/usr/bin"
mkdir -p "$APP_DIR/usr/lib"
mkdir -p "$APP_DIR/usr/share/icons/hicolor/256x256/apps"

cp -r "$BUNDLE_DIR"/* "$APP_DIR/usr/bin/"
if [ -d "$BUNDLE_DIR/lib" ]; then
  cp -r "$BUNDLE_DIR/lib"/* "$APP_DIR/usr/lib/" 2>/dev/null || true
fi

if [ -f "assets/images/app_icon_256.png" ]; then
  cp assets/images/app_icon_256.png "$APP_DIR/wmimo.png"
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

cat << 'EOF' > "$APP_DIR/AppRun"
#!/usr/bin/env bash
HERE="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="${HERE}/usr/lib:${HERE}/usr/bin/lib:${LD_LIBRARY_PATH}"
export PATH="${HERE}/usr/bin:${PATH}"
exec "${HERE}/usr/bin/wmimo" "$@"
EOF
chmod +x "$APP_DIR/AppRun"

# Download appimagetool if not present
if [ ! -f "appimagetool" ]; then
  echo "Downloading appimagetool..."
  wget -q https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage -O appimagetool || true
  if [ -f "appimagetool" ]; then
    chmod +x appimagetool
  fi
fi

if [ -f "appimagetool" ]; then
  ARCH=x86_64 ./appimagetool --appimage-extract-and-run "$APP_DIR" "$DIST_DIR/Wmimo-Linux-x64-$TAG.AppImage" || true
  if [ -f "$DIST_DIR/Wmimo-Linux-x64-$TAG.AppImage" ]; then
    chmod +x "$DIST_DIR/Wmimo-Linux-x64-$TAG.AppImage"
    echo "  -> Created $DIST_DIR/Wmimo-Linux-x64-$TAG.AppImage"
  fi
fi
rm -rf "$APP_DIR"

echo "=========================================================="
echo " All Linux Packages Built in $DIST_DIR/:"
echo "=========================================================="
ls -lh "$DIST_DIR"/Wmimo-Linux* || true
