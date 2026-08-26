#!/bin/bash
# KnucklsOS first-boot setup. Runs ONCE after install (or first live boot)
# via systemd ConditionFirstBoot=yes. Sets up the user account + applies
# KnucklsOS defaults so the machine is ready to game immediately.
set -e

LOG=/var/log/knucklsos-firstboot.log
exec >>"$LOG" 2>&1
echo "[KnucklsOS] firstboot starting: $(date)"

# --- find the main user -----------------------------------------------
# Prefer the live 'knucklsos' account; otherwise the first real /home user.
MAIN=""
if id knucklsos >/dev/null 2>&1 && [ -d /home/knucklsos ]; then
  MAIN=knucklsos
else
  for d in /home/*; do
    [ -d "$d" ] || continue
    u=$(basename "$d")
    [ "$u" = "lost+found" ] && continue
    if id "$u" >/dev/null 2>&1; then MAIN="$u"; break; fi
  done
fi

# --- gaming group -----------------------------------------------------
groupadd -f gamemode 2>/dev/null || true

# --- apply per-user KnucklsOS config ----------------------------------
if [ -n "$MAIN" ]; then
  echo "[KnucklsOS] configuring user: $MAIN"
  install -Dm644 /etc/skel/.config/autostart/knucklsos-apply-theme.desktop \
    "/home/$MAIN/.config/autostart/knucklsos-apply-theme.desktop" 2>/dev/null || true
  install -Dm644 /etc/skel/.config/autostart/knucklsos-gpu-detect.desktop \
    "/home/$MAIN/.config/autostart/knucklsos-gpu-detect.desktop" 2>/dev/null || true
  # First-run flags so theme + gpu detect actually run for this user
  touch "/home/$MAIN/.cache/knucklsos/gpu-detected" 2>/dev/null || true
  chown -R "$MAIN":"$MAIN" "/home/$MAIN/.config" "/home/$MAIN/.cache" 2>/dev/null || true
fi

# --- friendly hostname on installed systems (skip live session) -------
if [ ! -f /etc/knucklsos-live ]; then
  hostnamectl set-hostname knucklsos 2>/dev/null || \
    echo "knucklsos" > /etc/hostname 2>/dev/null || true
fi

echo "[KnucklsOS] firstboot done"
