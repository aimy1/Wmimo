#!/usr/bin/env bash
set -e

TAG="${1:-v1.0.32}"
RAW_VERSION="${TAG#v}"
BUNDLE_DIR="build/linux/x64/release/bundle"
DIST_DIR="dist"

mkdir -p "$DIST_DIR"

# 1. Copy Linux core service
if [ -f "bind/linux/core/wmimoService" ]; then
  cp bind/linux/core/wmimoService "$BUNDLE_DIR/wmimoService"
  chmod +x "$BUNDLE_DIR/wmimoService"
fi

# 2. Package Portable tar.gz
echo "Packaging Wmimo-Linux-x64-$TAG.tar.gz..."
tar -czf "$DIST_DIR/Wmimo-Linux-x64-$TAG.tar.gz" -C "$BUNDLE_DIR" .

# 3. Package Debian .deb
echo "Building Debian Package Wmimo-Linux-x64-$TAG.deb..."
DEB_ROOT="deb_package"
rm -rf "$DEB_ROOT"
mkdir -p "$DEB_ROOT/DEBIAN"
mkdir -p "$DEB_ROOT/opt/wmimo"
mkdir -p "$DEB_ROOT/usr/share/applications"
mkdir -p "$DEB_ROOT/usr/share/icons/hicolor/256x256/apps"

cp -r "$BUNDLE_DIR"/* "$DEB_ROOT/opt/wmimo/"
if [ -f "assets/images/app_icon_256.png" ]; then
  cp assets/images/app_icon_256.png "$DEB_ROOT/usr/share/icons/hicolor/256x256/apps/wmimo.png"
fi

cat << EOF > "$DEB_ROOT/DEBIAN/control"
Package: wmimo
Version: $RAW_VERSION
Section: x11
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libayatana-appindicator3-1, libkeybinder-3.0-0, libsecret-1-0, libstdc++6
Maintainer: Wmimo
Description: A modern, sleek cross-platform Clash/Mihomo GUI proxy client.
EOF

cat << 'EOF' > "$DEB_ROOT/usr/share/applications/wmimo.desktop"
[Desktop Entry]
Name=Wmimo
Comment=A modern, sleek cross-platform Clash/Mihomo GUI proxy client.
Exec=/opt/wmimo/wmimo %u
Icon=wmimo
Terminal=false
Type=Application
Categories=Network;
StartupNotify=true
EOF

dpkg-deb --build "$DEB_ROOT" "$DIST_DIR/Wmimo-Linux-x64-$TAG.deb"
rm -rf "$DEB_ROOT"

echo "Linux packaging complete:"
ls -la "$DIST_DIR"
