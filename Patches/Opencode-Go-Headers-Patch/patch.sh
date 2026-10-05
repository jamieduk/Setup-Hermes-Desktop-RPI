#!/bin/bash
# (c) J~Net 2026
#
# ./patch-hermes-opencode-session.sh
#

ROOT="/tmp/hermes-desktop-inspect/squashfs-root"
SITE="$ROOT/resources/python/lib/python3.12/site-packages"
FILE="$SITE/plugins/model-providers/opencode-zen/__init__.py"
BACKUP="$FILE.backup"

if [ ! -f "$FILE" ]; then
    echo "ERROR: Hermes provider file not found:"
    echo "$FILE"
    exit 1
fi

if [ ! -f "$BACKUP" ]; then
    cp "$FILE" "$BACKUP"
fi

python3 - "$FILE" <<'PY'
import sys
from pathlib import Path

file=Path(sys.argv[1])
text=file.read_text()

old='''    def build_api_kwargs_extras(
        self, *, reasoning_config: dict | None = None, model: str | None = None, **context
    ) -> tuple[dict[str, Any], dict[str, Any]]:
        extra_body: dict[str, Any] = {}
        top_level: dict[str, Any] = {}
'''

new='''    def build_api_kwargs_extras(
        self, *, reasoning_config: dict | None = None, model: str | None = None, **context
    ) -> tuple[dict[str, Any], dict[str, Any]]:
        extra_body: dict[str, Any] = {}
        top_level: dict[str, Any] = {}

        # OpenCode Go requires a stable session identifier for routing.
        # Hermes already provides one per conversation.
        session_id = context.get("session_id")
        if session_id:
            top_level["extra_headers"] = {
                "x-opencode-session": str(session_id),
            }
'''

if old not in text:
    print("ERROR: Expected provider code was not found.")
    print("No changes made.")
    sys.exit(1)

file.write_text(text.replace(old, new, 1))
print("Patched:", file)
PY

echo
echo "===== PATCHED OPENCODE GO PROVIDER ====="
sed -n '25,65p' "$FILE"

echo
echo "===== SYNTAX CHECK ====="
"$ROOT/resources/python/bin/python3" -m py_compile "$FILE"

if [ $? -eq 0 ]; then
    echo "Python syntax: OK"
else
    echo "Python syntax: FAILED"
    cp "$BACKUP" "$FILE"
    exit 1
fi

echo
echo "===== DONE ====="
echo "Backup:"
echo "$BACKUP"
