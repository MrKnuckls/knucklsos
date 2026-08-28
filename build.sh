#!/bin/bash
# KnucklsOS MINIMAL Ubuntu Noble live-build driver (step 1: prove it boots).
# Tee all output to build.log so CI can surface errors.
exec > >(tee -a build.log) 2>&1
set -euo pipefail

cd "$(dirname "$0")"

if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: live-build needs root. Run: sudo ./build.sh" >&2
  exit 1
fi

echo "==> live-build version:"; lb --version || true

# Minimal: boot to a KDE desktop, nothing else yet.
# --mode ubuntu uses casper (Ubuntu's reliable live-boot), signed shim path.
lb clean 2>/dev/null || true
lb config noauto \
    --mode ubuntu \
    --distribution noble \
    --architectures amd64 \
    --archive-areas "main restricted universe multiverse" \
    --mirror-bootstrap http://archive.ubuntu.com/ubuntu \
    --mirror-binary http://archive.ubuntu.com/ubuntu \
    --mirror-binary-security http://security.ubuntu.com/ubuntu \
    --binary-images iso-hybrid \
    --syslinux-theme "" \
    --bootappend-live "boot=casper username=knucklsos components quiet splash" \
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
# Version label follows the branch: main -> v1.0, ubuntu -> v1.1, else vX.Y from branch.
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)"
case "$BRANCH" in
  main)        VER="v1.0" ;;
  ubuntu)      VER="v1.1" ;;
  *)           VER="$BRANCH" ;;
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
