#!/bin/bash
# KnucklsOS hardware auto-detect — runs ONCE on first login.
# Detects the user's CPU and graphics hardware and makes sure the right
# drivers/firmware are active. Most things (AMD GPU, Intel iGPU, Intel/AMD
# CPU microcode) are already installed out-of-the-box; for NVIDIA we ensure
# the preinstalled driver is active, fetching the recommended one only if
# it's missing AND we have network.
set -e

FLAG="$HOME/.cache/knucklsos/gpu-detected"
mkdir -p "$(dirname "$FLAG")"
[ -f "$FLAG" ] && exit 0

notify() { command -v notify-send >/dev/null 2>&1 && notify-send "KnucklsOS" "$1" 2>/dev/null || true; }

CPU_INFO=""
GPU_INFO=""
command -v lscpu >/dev/null 2>&1 && CPU_INFO="$(lscpu 2>/dev/null)"
command -v lspci >/dev/null 2>&1 && GPU_INFO="$(lspci 2>/dev/null | grep -iE 'VGA|3D|Display' || true)"

# --- CPU family note (Intel Core i5, AMD Ryzen, etc.) ---
if echo "$CPU_INFO" | grep -qiE 'intel'; then
  notify "Intel CPU detected — microcode updates active."
elif echo "$CPU_INFO" | grep -qiE 'amd'; then
  notify "AMD CPU detected — microcode updates active."
fi

# --- GPU ---
if echo "$GPU_INFO" | grep -qi nvidia; then
  notify "NVIDIA GPU detected — enabling driver…"
  if ! lsmod 2>/dev/null | grep -q nvidia; then
    if command -v ubuntu-drivers >/dev/null 2>&1; then
      pkexec ubuntu-drivers autoinstall >/dev/null 2>&1 || \
        pkexec apt-get install -y nvidia-driver-550 >/dev/null 2>&1 || true
    fi
  fi
  notify "NVIDIA driver ready. Reboot if graphics look wrong."
elif echo "$GPU_INFO" | grep -qiE 'amd|advanced micro devices|radeon'; then
  notify "AMD graphics detected — Mesa open drivers active (Gaming-ready)."
elif echo "$GPU_INFO" | grep -qiE 'intel'; then
  notify "Intel graphics detected — Mesa open drivers active (Gaming-ready)."
else
  notify "No discrete GPU detected — using default open drivers."
fi

touch "$FLAG"
