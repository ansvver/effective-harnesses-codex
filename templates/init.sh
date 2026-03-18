#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Project startup helper for long-running Codex sessions.
# Replace the commented examples below with repo-specific commands.

echo "Starting project services..."

# Example: Python backend
# cd "$ROOT_DIR"
# ./.venv/bin/python -m uvicorn backend.main:app --host 127.0.0.1 --port 8000

# Example: Node frontend
# cd "$ROOT_DIR/frontend"
# npm run start:dev

echo "Edit this script to match the repo's real startup sequence."
