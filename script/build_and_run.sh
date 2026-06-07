#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-run}"
APP_NAME="Caffeine"
BUNDLE_ID="com.local.Caffeine"
MIN_SYSTEM_VERSION="13.0"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
APP_CONTENTS="$APP_BUNDLE/Contents"
APP_MACOS="$APP_CONTENTS/MacOS"
APP_RESOURCES="$APP_CONTENTS/Resources"
APP_BINARY="$APP_MACOS/$APP_NAME"
INFO_PLIST="$APP_CONTENTS/Info.plist"
ICONSET="$ROOT_DIR/Assets/AppIcon.iconset"
ICON_FILE="$ROOT_DIR/Assets/Caffeine.icns"
ICON_SOURCE="$ROOT_DIR/Resources/coffe-icon.png"

generate_icon() {
  rm -rf "$ICONSET"
  mkdir -p "$ICONSET"

  make_icon_png 16 "$ICONSET/icon_16x16.png"
  make_icon_png 32 "$ICONSET/icon_16x16@2x.png"
  make_icon_png 32 "$ICONSET/icon_32x32.png"
  make_icon_png 64 "$ICONSET/icon_32x32@2x.png"
  make_icon_png 128 "$ICONSET/icon_128x128.png"
  make_icon_png 256 "$ICONSET/icon_128x128@2x.png"
  make_icon_png 256 "$ICONSET/icon_256x256.png"
  make_icon_png 512 "$ICONSET/icon_256x256@2x.png"
  make_icon_png 512 "$ICONSET/icon_512x512.png"
  make_icon_png 1024 "$ICONSET/icon_512x512@2x.png"
  iconutil -c icns "$ICONSET" -o "$ICON_FILE"
}

make_icon_png() {
  local size="$1"
  local output="$2"
  local radius=$((size / 5))

  magick "$ICON_SOURCE" \
    -resize "${size}x${size}^" \
    -gravity center \
    -extent "${size}x${size}" \
    -alpha set \
    \( -size "${size}x${size}" xc:none -fill white -draw "roundrectangle 0,0 $((size - 1)),$((size - 1)) $radius,$radius" \) \
    -compose CopyOpacity -composite \
    "$output"
}

pkill -x "$APP_NAME" >/dev/null 2>&1 || true
for _ in {1..20}; do
  if ! pgrep -x "$APP_NAME" >/dev/null; then
    break
  fi
  sleep 0.25
done

swift build
BUILD_BINARY="$(swift build --show-bin-path)/$APP_NAME"

generate_icon

rm -rf "$APP_BUNDLE"
mkdir -p "$APP_MACOS" "$APP_RESOURCES"
cp "$BUILD_BINARY" "$APP_BINARY"
cp "$ICON_FILE" "$APP_RESOURCES/Caffeine.icns"
chmod +x "$APP_BINARY"

cat >"$INFO_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleName</key>
  <string>$APP_NAME</string>
  <key>CFBundleIconFile</key>
  <string>Caffeine</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>LSMinimumSystemVersion</key>
  <string>$MIN_SYSTEM_VERSION</string>
  <key>LSUIElement</key>
  <true/>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
</dict>
</plist>
PLIST

open_app() {
  /usr/bin/open -n "$APP_BUNDLE"
}

case "$MODE" in
  run)
    open_app
    ;;
  --debug|debug)
    lldb -- "$APP_BINARY"
    ;;
  --logs|logs)
    open_app
    /usr/bin/log stream --info --style compact --predicate "process == \"$APP_NAME\""
    ;;
  --telemetry|telemetry)
    open_app
    /usr/bin/log stream --info --style compact --predicate "subsystem == \"$BUNDLE_ID\""
    ;;
  --verify|verify)
    open_app
    for _ in {1..10}; do
      if pgrep -x "$APP_NAME" >/dev/null; then
        exit 0
      fi
      sleep 0.5
    done
    exit 1
    ;;
  *)
    echo "usage: $0 [run|--debug|--logs|--telemetry|--verify]" >&2
    exit 2
    ;;
esac
