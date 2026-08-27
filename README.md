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
Pushing to `main` triggers `.github/workflows/build.yml`, which installs the
**native Debian live-build** on GitHub's runners and builds the ISO, then uploads
it. There are two ways to get the ISO:

- **Release (recommended, permanent):** the latest stable build is published as a
  GitHub Release with the ISO split into two `<2 GB` chunks (GitHub's release-asset
  limit). Download both `knucklsos-20260827.iso.part00` and `.part01`, then rejoin:
  ```bash
  cat knucklsos-20260827.iso.part00 knucklsos-20260827.iso.part01 > knucklsos-20260827.iso
  ```
  Release: https://github.com/MrKnuckls/knucklsos/releases
- **Actions artifact (temporary, ~30-day expiry):** each build also uploads a
  single `knucklsos-iso` artifact from the Actions tab:
  https://github.com/MrKnuckls/knucklsos/actions

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
├── build.sh                       # live-build driver (lb config + lb build)
├── config/
│   ├── package-lists/             # package lists (amd64 + i386 gaming libs)
│   ├── hooks/live/                # chroot hooks (Steam, Proton-GE, branding, plymouth, firstboot, i386 gaming)
│   ├── includes.chroot/           # theme, scripts, branding (distro-agnostic)
│   └── bootloaders/isolinux/      # syslinux bootloader files
└── README.md
```
