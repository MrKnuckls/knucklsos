#!/bin/bash
# KnucklsOS live-build driver.
# Requires root. On Ubuntu 24.04: sudo apt install -y live-build
set -euo pipefail

cd "$(dirname "$0")"

if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: live-build needs root. Run: sudo ./build.sh" >&2
  exit 1
fi

echo "==> Installing live-build if missing"
command -v lb >/dev/null 2>&1 || apt-get update && apt-get install -y live-build

echo "==> Configuring (config/auto/config)"
lb config

echo "==> Building ISO (this takes a while: download + squashfs)..."
lb build

echo "==> Done. Look for knucklsos*.iso in: $(pwd)"
ls -lh knucklsos*.iso 2>/dev/null || ls -lh *.iso 2>/dev/null || true
