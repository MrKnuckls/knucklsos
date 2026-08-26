#!/bin/bash
# KnucklsOS live-build driver. Tee ALL output to build.log so CI can surface
# errors even on early failure.
exec > >(tee -a build.log) 2>&1
set -euo pipefail

cd "$(dirname "$0")"

if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: live-build needs root. Run: sudo ./build.sh" >&2
  exit 1
fi

echo "==> Installing live-build if missing"
command -v lb >/dev/null 2>&1 || apt-get update && apt-get install -y live-build

echo "==> live-build version:"; lb --version
echo "==> Configuring (config/auto/config)"
lb config

echo "==> Building ISO (this can take a while)..."
lb build

echo "==> Done. ISOs:"
ls -lh knucklsos*.iso 2>/dev/null || ls -lh *.iso 2>/dev/null || echo "NO ISO PRODUCED"
