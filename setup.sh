#!/bin/bash
# (c) J~Net 2026
#
# ./setup.sh
#

DIR="$HOME/Downloads/Hermes-Desktop"
APP="$DIR/Hermes.Desktop-0.1.10-arm64.AppImage"
URL="https://github.com/sir1st/hermes-desktop/releases/download/v0.1.10/Hermes.Desktop-0.1.10-arm64.AppImage"

mkdir -p "$DIR"
cd "$DIR" || exit 1

if [ ! -f "$APP" ]; then
wget -O "$APP" "$URL" || exit 1
fi

chmod +x "$APP"
"$APP" --no-sandbox

