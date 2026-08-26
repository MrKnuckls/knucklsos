# KnucklsOS 🛡️

A **Windows 11–style, user-friendly gaming OS**. Built on **Debian** (Bookworm)
with KDE Plasma, themed to look and feel like Windows 11, and shipped with
everything needed to play **Steam** and **Windows (.exe)** games out of the box.

> Made by Shaun

---

## What's inside (by default)
- **Desktop:** KDE Plasma, themed Windows 11–like (centered taskbar, blur,
  rounded corners, KnucklsOS wallpaper + boot splash with the MrKnuckls avatar)
- **Gaming:** Steam + Proton, Lutris, Wine, Proton-GE (auto-downloaded),
  GameMode, MangoHUD, Vulkan + Mesa drivers, NVIDIA driver
- **Hardware:** open-source GPU drivers (AMD/Intel), NVIDIA driver, CPU microcode
- **Apps:** Dolphin, Konsole, Google Chrome, Papirus icons
- **Installer:** Calamares (install to HDD, dual-boot aware)

---

## ⚠️ Honest caveat about "runs every Windows game, no issues"
Linux gaming via **Proton/Wine** is excellent — the large majority of Steam
and Windows games run great. The real exceptions: games with **kernel-level
anti-cheat** (e.g. Valorant, some Easy Anti-Cheat / BattlEye titles) may not
run. KnucklsOS runs as many Windows/Steam games as Linux possibly can.

---

## Building the ISO (automated via GitHub Actions)
Pushing to `main` triggers `.github/workflows/build.yml`, which runs
`live-build` on GitHub's root-enabled runners and uploads `knucklsos-iso` as a
downloadable artifact. Download it, flash to USB (Ventoy / BalenaEtcher /
`dd`), and boot.

> Note: the OS is **Debian**-based (not Ubuntu). Debian's `live-build` is the
> reliably-automated builder; Steam/Proton/Lutris/Wine behave identically. If
> you specifically need an Ubuntu base, use **Cubic** (see below) — same result,
> manual steps.

## Build path B — local live-build
Requires root:
```bash
sudo apt install -y live-build debootstrap cpio squashfs-tools xorriso
cd knucklsos && sudo ./build.sh
```

## Build path C — Cubic (Ubuntu base, manual)
1. Download Ubuntu 24.04 Desktop ISO.
2. `sudo apt install cubic` → remaster: install the package list from
   `config/package-lists/knucklsos.cubic.txt`, copy `config/includes.chroot/*`
   into the chroot, run `/opt/knucklsos/apply-theme.sh`, finish.

---

## Project layout
```
knucklsos/
├── .github/workflows/build.yml   # automated ISO build
├── build.sh                       # live-build driver
├── config/
│   ├── auto/config                # lb_config (Debian/Bookworm)
│   ├── package-lists/             # packages
│   └── includes.chroot/           # theme, scripts, branding (distro-agnostic)
└── README.md
```
