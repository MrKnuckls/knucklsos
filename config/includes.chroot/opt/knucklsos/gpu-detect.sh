#!/bin/bash
# KnucklsOS GPU auto-detect — runs ONCE on first login.
# Detects the user's graphics hardware and makes sure the right driver is in
# use. AMD/Intel are covered out-of-the-box by Mesa (already installed); for
# NVIDIA we ensure the preinstalled driver is active, and only if it's missing
# AND we have network do we try to fetch the recommended one.
set -e

FLAG="$HOME/.cache/knucklsos/gpu-detected"
mkdir -p "$(dirname "$FLAG")"
[ -f "$FLAG" ] && exit 0

notify() { command -v notify-send >/dev/null 2>&1 && notify-send "KnucklsOS" "$1" 2>/dev/null || true; }

GPU_INFO=""
command -v lspci >/dev/null 2>&1 && GPU_INFO="$(lspci | grep -iE 'VGA|3D|Display' || true)"

if echo "$GPU_INFO" | grep -qi nvidia; then
  notify "NVIDIA GPU detected — enabling driver…"
  if ! lsmod 2>/dev/null | grep -q nvidia; then
    # Driver package is preinstalled; if the module isn't loaded, try the
    # recommended one (needs network + a polkit prompt). Best-effort only.
    if command -v ubuntu-drivers >/dev/null 2>&1; then
      pkexec ubuntu-drivers autoinstall >/dev/null 2>&1 || \
        pkexec apt-get install -y nvidia-driver-550 >/dev/null 2>&1 || true
    fi
  fi
  notify "NVIDIA driver ready. Reboot if graphics look wrong."
elif echo "$GPU_INFO" | grep -qiE 'amd|advanced micro devices|radeon'; then
  notify "AMD GPU detected — Mesa open drivers active."
elif echo "$GPU_INFO" | grep -qiE 'intel'; then
  notify "Intel GPU detected — Mesa open drivers active."
else
  notify "No discrete GPU detected — using default drivers."
fi

touch "$FLAG"
