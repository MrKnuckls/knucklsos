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

echo "==> live-build version:"; lb --version

# Configure explicitly as Debian Bookworm with a pinned mirror. We pass args
# directly (not relying on config/auto/config being sourced) so live-build
# cannot fall back to its ubuntu/precise default.
echo "==> Configuring (Debian Bookworm)"
lb config noauto \
    --mode debian \
    --distribution bookworm \
    --architectures amd64 \
    --archive-areas "main contrib non-free non-free-firmware" \
    --parent-archive-areas "main contrib non-free non-free-firmware" \
    --mirror-bootstrap http://deb.debian.org/debian \
    --mirror-binary http://deb.debian.org/debian \
    --mirror-binary-security http://security.debian.org/debian-security \
    --apt-indices false \
    --apt-recommends true \
    --binary-images iso-hybrid \
    --bootappend-live "boot=live components quiet splash live-user=knucklsos" \
    --linux-packages "linux-image-amd64" \
    --initramfs-compression gzip \
    --iso-application "KnucklsOS" \
    --iso-publisher "KnucklsOS Project" \
    --iso-volume "KnucklsOS" \
    --checksums sha256

echo "==> Config written. Building ISO (this can take a while)..."
lb build

echo "==> Done. Renaming ISO to knucklsos..."
# The Ubuntu live-build fork names the ISO by --image-name (unsupported here),
# so rename whatever *.iso was produced.
for iso in *.iso; do
  [ -e "$iso" ] || continue
  mv -f "$iso" "knucklsos-$(date +%Y%m%d).iso" 2>/dev/null || mv -f "$iso" knucklsos.iso
done
echo "==> ISOs:"
ls -lh knucklsos*.iso 2>/dev/null || ls -lh *.iso 2>/dev/null || echo "NO ISO PRODUCED"
