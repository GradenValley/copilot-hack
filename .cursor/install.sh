#!/usr/bin/env bash
# Idempotent setup for the copilot-hack "possible-solution" (Flask API + SvelteKit client).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# The default base image ships Python 3.12 but not the venv module. Install it once.
if ! python3 -c "import ensurepip" >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y --no-install-recommends python3.12-venv
fi

# Python API server: isolated virtualenv with Flask + model dependencies.
cd "$ROOT/possible-solution/server"
python3 -m venv .venv
.venv/bin/pip install --upgrade pip
.venv/bin/pip install -r requirements.txt

# SvelteKit client: install locked npm dependencies.
cd "$ROOT/possible-solution/client"
npm ci
