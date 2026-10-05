#!/bin/bash
# (c) J~Net 2026
#
# ./patch-hermes-opencode-go.sh
#

set -e

APPDIR="/tmp/hermes-desktop-inspect/squashfs-root"
APPIMAGE="/home/jay/Downloads/Hermes-Desktop/Hermes.Desktop-0.1.10-arm64.AppImage"
OUTPUT="/home/jay/Downloads/Hermes-Desktop/Hermes.Desktop-0.1.10-arm64-opencode-go-fixed.AppImage"
RUNTIME="/tmp/hermes-desktop-runtime"
SQUASHFS="/tmp/hermes-desktop-patched.squashfs"

echo "===== PATCH HERMES DESKTOP ====="
echo

if [ ! -f "$APPIMAGE" ]; then
    echo "ERROR: AppImage not found:"
    echo "$APPIMAGE"
    exit 1
fi

if [ ! -d "$APPDIR" ]; then
    echo "ERROR: Extracted AppImage not found:"
    echo "$APPDIR"
    exit 1
fi

echo "Checking squashfs-tools..."

if ! command -v mksquashfs >/dev/null 2>&1; then
    echo "Installing squashfs-tools..."
    sudo apt update
    sudo apt install -y squashfs-tools
fi

echo
echo "Checking patched OpenCode Go provider..."

PROVIDER="$APPDIR/resources/python/lib/python3.12/site-packages/plugins/model-providers/opencode-zen/__init__.py"

if [ ! -f "$PROVIDER" ]; then
    echo "ERROR: OpenCode Go provider not found:"
    echo "$PROVIDER"
    exit 1
fi

if ! grep -q 'x-opencode-session' "$PROVIDER"; then
    echo "ERROR: OpenCode Go session patch is not present."
    exit 1
fi

echo "OpenCode Go session patch: OK"

echo
echo "Fixing Chromium sandbox permissions..."

sudo chown root:root "$APPDIR/chrome-sandbox"
sudo chmod 4755 "$APPDIR/chrome-sandbox"

echo "chrome-sandbox:"
ls -l "$APPDIR/chrome-sandbox"

echo
echo "Removing previous temporary files..."

sudo /usr/bin/rm -f "$RUNTIME"
sudo /usr/bin/rm -f "$SQUASHFS"
sudo /usr/bin/rm -f "$OUTPUT"

echo
echo "Extracting original AppImage runtime..."

OFFSET=$("$APPIMAGE" --appimage-offset)

echo "Runtime offset: $OFFSET"

dd if="$APPIMAGE" of="$RUNTIME" bs=1 count="$OFFSET" status=none

echo
echo "Creating patched SquashFS..."

sudo mksquashfs "$APPDIR" "$SQUASHFS" \
    -noappend \
    -comp xz

echo
echo "Building patched AppImage..."

cat "$RUNTIME" "$SQUASHFS" > "$OUTPUT"

chmod +x "$OUTPUT"

echo
echo "Cleaning temporary files..."

/usr/bin/rm -f "$RUNTIME" "$SQUASHFS"

echo
echo "===== COMPLETE ====="
echo
echo "Patched AppImage:"
echo "$OUTPUT"
echo
ls -lh "$OUTPUT"
echo
echo "Testing AppImage metadata..."

"$OUTPUT" --appimage-version || true

echo
echo "Done."
