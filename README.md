# KnucklsOS 🛡️

A **Windows 11–style, user-friendly gaming OS** built on Ubuntu 24.04 (Noble).
Boots to a centered-taskbar, acrylic-look desktop and ships with everything
needed to play **Steam** and **Windows (.exe)** games out of the box.

> Made by Shaun. Assistant: **Dom** (Hermes).

---

## What's inside (by default)
- **Desktop:** KDE Plasma, themed to look & feel like Windows 11
  (centered taskbar, Start-style launcher, blur, rounded corners, Win11 wallpaper)
- **Gaming:** Steam + Proton, Lutris, Wine, Proton-GE (auto-downloaded),
  GameMode, MangoHUD, Vulkan + Mesa drivers, Xbox controller support
- **Hardware:** open-source GPU drivers, plus NVIDIA driver metapackage
- **Apps:** Dolphin file manager, Konsole, Chromium, Papirus icons
- **Branding:** "KnucklsOS" name, wallpaper, welcome screen

---

## ⚠️ Honest caveat about "runs every Windows game, no issues"
Linux gaming via **Proton/Wine** is excellent — the large majority of Steam
and Windows games run great, often faster than on Windows. The real exceptions:
- Games with **kernel-level anti-cheat** (e.g. Valorant, some Easy Anti-Cheat /
  BattlEye titles) may not run, or need manual setup.
- A small number of titles are incompatible.

KnucklsOS is configured to run **as many Windows/Steam games as Linux possibly
can**, with the best compatibility tools preinstalled. It will not magically run
the ~5% of anti-cheat-locked games. Everything else: install, click Play.

---

## Build path A — Cubic (EASIEST, recommended for Shaun)
Cubic is a friendly GUI to remaster an Ubuntu ISO. No scripting needed.
1. Download the **Ubuntu 24.04 Desktop (amd64)** ISO.
2. Install Cubic: `sudo apt install cubic` (or from its PPA).
3. In Cubic:
   - Start from the Ubuntu ISO.
   - On the **Terminal** page, run the package install:
     `sudo apt update && sudo apt install -y $(cat /usr/share/knucklsos/packages.txt)`
     (or just paste the list from `config/package-lists/knucklsos.cubic.txt`).
   - Copy the folders from this repo's `config/includes.chroot/` into the
     chroot filesystem (e.g. `cp -r config/includes.chroot/* /`).
   - Run `/opt/knucklsos/apply-theme.sh` once to bake in the layout.
   - Finish → Cubic produces `knucklsos.iso`.
4. Flash with Ventoy / BalenaEtcher / Rufus and boot.

## Build path B — live-build (scriptable, reproducible)
Requires root. On a machine with sudo:
```bash
sudo apt install -y live-build
cd knucklsos
chmod +x build.sh
sudo ./build.sh          # produces knucklsos.iso in build/ or current dir
```
`build.sh` calls `lb config` (see `config/auto/config`) then `lb build`.

> Note: live-build's Ubuntu mode can be finicky on some hosts. If it fights
> you, use **Path A (Cubic)** — same result, far less pain.

---

## First boot
- You'll land on the KnucklsOS desktop as user **knucklsos** (live session).
- The theme applies automatically on first login.
- Open **Steam** → enable Steam Play for all titles (Settings → Compatibility →
  "Run other titles with Proton") → install & play.
- For non-Steam .exe games, use **Lutris** or right-click → Open with Wine.
- Welcome screen: run `knucklsos-welcome` from the menu for tips.

---

## Project layout
```
knucklsos/
├── build.sh                 # live-build driver
├── config/
│   ├── auto/config          # lb_config options
│   ├── package-lists/       # packages for live-build + plain list for Cubic
│   ├── includes.chroot/     # files copied into the OS (theme, scripts, branding)
│   └── hooks/live/          # build-time scripts (Proton-GE, gaming tweaks, branding)
└── README.md
```

## Tweaking
- Theme/layout logic lives in `config/includes.chroot/opt/knucklsos/apply-theme.sh`.
- Wallpaper: `config/includes.chroot/usr/share/wallpapers/KnucklsOS/`.
- Add packages: edit `config/package-lists/knucklsos.list.chroot` (and the
  `.cubic.txt` mirror).
