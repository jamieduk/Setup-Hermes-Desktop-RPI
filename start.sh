#!/bin/bash
# (c) J~Net 2026
#
# ./start.sh
#
#

APP="/home/$USER/Downloads/Hermes-Desktop/Hermes.Desktop-0.1.10-arm64.AppImage"

chmod +x "$APP"
"$APP" --no-sandbox
