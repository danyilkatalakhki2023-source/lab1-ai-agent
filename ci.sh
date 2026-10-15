#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if ! cd "$ROOT"; then
    echo "ERROR: failed to change to project root '$ROOT'." >&2
    exit 1
fi

PYTHON="$ROOT/.venv/bin/python"
EXECUTABLE="$ROOT/dist/hello"

if [[ -e "$ROOT/.venv" ]]; then
    if [[ ! -x "$PYTHON" ]]; then
        echo "ERROR: existing .venv Python interpreter is missing or not runnable; it was not deleted." >&2
        exit 1
    fi
else
    if ! command -v python >/dev/null 2>&1; then
        echo "ERROR: system Python 3.13 is required to create .venv." >&2
        exit 1
    fi
    if ! python --version 2>&1 | grep -E '^Python 3\.13' >/dev/null; then
        echo "ERROR: system Python 3.13 is required to create .venv." >&2
        exit 1
    fi
    if ! python -m venv .venv; then
        echo "ERROR: failed to create .venv with system Python 3.13." >&2
        exit 1
    fi
fi

if ! "$PYTHON" --version >/dev/null 2>&1; then
    echo "ERROR: .venv Python interpreter is not runnable." >&2
    exit 1
fi

if ! "$PYTHON" --version 2>&1 | grep -E '^Python 3\.13' >/dev/null; then
    echo "ERROR: existing .venv interpreter is not Python 3.13; it was not deleted." >&2
    exit 1
fi

"$PYTHON" -m pip install -r "$ROOT/requirements-dev.txt"
"$PYTHON" -m pytest "$ROOT/tests"
"$PYTHON" -m PyInstaller --onefile --name hello --distpath "$ROOT/dist" --workpath "$ROOT/build/pyinstaller" --specpath "$ROOT/build" "$ROOT/src/hello.py"

if [[ ! -x "$EXECUTABLE" ]]; then
    echo "ERROR: expected executable was not created." >&2
    exit 1
fi

if ! "$PYTHON" -c 'import subprocess, sys; p = subprocess.run([sys.argv[1]], capture_output=True, text=True); expected = ("Hello World", "Hello World\n"); print("Executable return code:", p.returncode); print("Executable stdout:", repr(p.stdout)); sys.exit(0 if p.returncode == 0 and p.stdout in expected else 1)' "$EXECUTABLE"; then
    echo "ERROR: hello did not return code 0 with stdout equal to Hello World." >&2
    exit 1
fi

echo "Build and test succeeded."
