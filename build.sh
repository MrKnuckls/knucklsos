#!/bin/bash
# KnucklsOS v1.1 (Ubuntu branch) MINIMAL Debian-mode live-build driver.
# Debian-mode is the reliable CI engine (Noble-Ubuntu live-build is broken).
# Goal: prove the base boots to a KDE desktop on real PC before adding gaming.
# Boot is VISIBLE (no quiet splash) so failures show instead of black screen.
exec > >(tee -a build.log) 2>&1
set -euo pipefail

cd "$(dirname "$0")"

if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: live-build needs root. Run: sudo ./build.sh" >&2
  exit 1
fi

echo "==> live-build version:"; lb --version || true

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
    --bootappend-live "boot=live components username=knucklsos splash" \
    --linux-packages "linux-image" \
    --initramfs-compression gzip \
    --iso-application "KnucklsOS" \
    --iso-publisher "KnucklsOS Project" \
    --iso-volume "KnucklsOS" \
    --checksums sha256

echo "==> Building ISO..."
lb build
build_rc=$?

echo "==> Done. Renaming ISO..."
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)"
case "$BRANCH" in
  main)   VER="v1.0" ;;
  ubuntu) VER="v1.1" ;;
  *)      VER="$BRANCH" ;;
esac
if [ "$build_rc" -eq 0 ]; then
  for iso in *.iso; do
    [ -e "$iso" ] || continue
    mv -f "$iso" "knucklsos-${VER}.iso" 2>/dev/null || mv -f "$iso" knucklsos.iso
  done
  ls -lh knucklsos*.iso 2>/dev/null || ls -lh *.iso 2>/dev/null || echo "NO ISO PRODUCED"
else
  echo "==> BUILD FAILED (rc=$build_rc)" >&2
fi

exit $build_rc
