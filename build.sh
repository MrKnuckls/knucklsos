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

# Preflight: ensure required commands are available and basic environment is sane.
missing=()
for cmd in lb curl tar mktemp; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
done
if [ ${#missing[@]} -ne 0 ]; then
  echo "ERROR: missing required commands: ${missing[*]}" >&2
  echo "Install the packages that provide these (e.g. live-build, curl, tar) and re-run." >&2
  exit 1
fi

# Optional but recommended checks
if command -v df >/dev/null 2>&1; then
  avail_kb=$(df --output=avail -k . | tail -n1 | tr -d '[:space:]' || echo "0")
  # Require at least 2GB free for building ISOs (2000000 KB)
  if [ -n "$avail_kb" ] && [ "$avail_kb" -lt 2000000 ]; then
    echo "WARNING: less than ~2GB available on build filesystem (avail: ${avail_kb} KB). ISO build may fail or run out of space." >&2
  fi
fi

echo "==> live-build version:"; lb --version || true

# Configure explicitly as Debian Bookworm with a pinned mirror. We pass args
# directly (not relying on config/auto/config being sourced) so live-build
# cannot fall back to its ubuntu/precise default.
echo "==> Configuring (Debian Bookworm)"
# Clean any prior config for a reproducible rebuild
lb clean 2>/dev/null || true
lb config noauto \
    --mode debian \
    --distribution bookworm \
    --architectures amd64 \
    --archive-areas "main contrib non-free non-free-firmware" \
    --parent-archive-areas "main contrib non-free non-free-firmware" \
    --mirror-bootstrap http://deb.debian.org/debian \
    --mirror-binary http://deb.debian.org/debian \
    --mirror-binary-security http://deb.debian.org/debian-security \
    --security false \
    --apt-indices false \
    --apt-recommends true \
    --binary-images iso-hybrid \
    --bootappend-live "boot=live components quiet splash username=knucklsos" \
    --linux-packages "linux-image" \
    --initramfs-compression gzip \
    --iso-application "KnucklsOS" \
    --iso-publisher "KnucklsOS Project" \
    --iso-volume "KnucklsOS" \
    --checksums sha256

echo "==> Config written. Building ISO (this can take a while)..."
lb build
build_rc=$?

echo "==> Done. Renaming ISO to knucklsos..."
# The Ubuntu live-build fork names the ISO by --image-name (unsupported here),
# so rename whatever *.iso was produced.
if [ "$build_rc" -eq 0 ]; then
  for iso in *.iso; do
    [ -e "$iso" ] || continue
    mv -f "$iso" "knucklsos-$(date +%Y%m%d).iso" 2>/dev/null || mv -f "$iso" knucklsos.iso
  done
  echo "==> ISOs:"
  ls -lh knucklsos*.iso 2>/dev/null || ls -lh *.iso 2>/dev/null || echo "NO ISO PRODUCED"
else
  echo "==> BUILD FAILED (lb build rc=$build_rc) — no ISO produced" >&2
  ls -lh *.iso 2>/dev/null || true
fi

exit $build_rc
