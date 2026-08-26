#!/bin/bash
# KnucklsOS welcome / quick-start tips.
# Launch from the menu ("KnucklsOS Welcome") or run: knucklsos-welcome
zenity --info --no-wrap --title "Welcome to KnucklsOS" --text="$(cat <<'EOF'
KNUCKLSOS — your Windows 11-style gaming OS

QUICK START
• Steam:    open Steam, sign in. Settings → Compatibility →
            "Run other titles with Proton" → install & Play.
• .exe games: open Lutris, or right-click the .exe → Open With → Wine.
• Performance: launch any game with "gamemoderun <cmd>" (or use Lutris/Steam
  which enable GameMode automatically). MangoHUD shows FPS overlay.

HONEST NOTE
Most Windows/Steam games run great here. A few competitive titles with
kernel-level anti-cheat (e.g. Valorant) may not run. Everything else just works.

Made by Shaun. Assistant: Dom.
EOF
)" 2>/dev/null || cat <<'EOF'
KNUCKLSOS — your Windows 11-style gaming OS
See /opt/knucklsos/welcome.sh for tips. Steam + Lutris + Wine are preinstalled.
EOF
