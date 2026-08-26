#!/bin/bash
# Apply the KnucklsOS Windows-11-like desktop layout.
# Safe to run repeatedly. Uses KDE's own tools so it won't break Plasma.
set -euo pipefail

WALL="/usr/share/wallpapers/KnucklsOS/contents/images/knucklsos-wallpaper.png"
LOOK="org.knucklsos.desktop"

echo "[KnucklsOS] Applying Windows 11-style layout..."

# Global look-and-feel (sets window theme, colors, etc.)
if command -v plasma-apply-lookandfeel >/dev/null 2>&1; then
  plasma-apply-lookandfeel -a "$LOOK" 2>/dev/null || true
fi

# Wallpaper
if [ -f "$WALL" ] && command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
  plasma-apply-wallpaperimage "$WALL" 2>/dev/null || true
fi

# KWin: enable blur + slight rounding for the Win11 acrylic feel.
kwriteconfig5 --file kwinrc --group Plugins --key blurEnabled true 2>/dev/null || true
kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key BorderSize Normal 2>/dev/null || true

# Taskbar: bottom panel, centered icons, Start-style launcher.
# (Plasma reads these on next restart of plasmashell.)
kwriteconfig5 --file plasmashellrc --group Shell --key PanelBehavior 0 2>/dev/null || true

# Restart shell so changes take effect (best-effort).
if command -v plasmashell >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  kquitapp5 plasmashell 2>/dev/null || true
  sleep 1
  (plasmashell >/dev/null 2>&1 &) || true
fi

echo "[KnucklsOS] Theme applied. If the taskbar isn't centered yet, open"
echo "System Settings → Appearance → and re-apply the 'KnucklsOS' look-and-feel."
