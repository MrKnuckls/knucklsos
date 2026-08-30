# KnucklsOS 🛡️

A **Windows 11–style, user-friendly gaming Linux distribution**. Built on
**Debian (Bookworm)** with the **KDE Plasma** desktop, themed with the
KnucklsOS look — fist boot splash, "KNUCKLS OS" wallpaper, and a one-click
installer.

> Made by Shaun (MrKnuckls)

---

## What it is right now (v1.1)

- **Base:** Debian 12 (Bookworm), KDE Plasma desktop, Windows-11-style theme.
- **Boot:** UEFI with **Secure Boot supported** (no need to turn it off).
- **Installer:** Calamares — double-click "Install KnucklsOS" on the desktop,
  pick your drive, done.
- **Branding:** fist boot splash (Plymouth), "KNUCKLS OS" wallpaper, Knuckls
  fist installer icon.
- **Live user:** `knucklsos`, no password — boots straight to the desktop.

**Coming next (not yet in v1.1):** the gaming stack — Steam, Lutris, Wine,
Proton-GE, GameMode, MangoHUD, and automatic GPU driver detection. The base
OS + installer are done and tested on real hardware (Dell Latitude E7270,
UEFI, Secure Boot ON).

---

## ⚠️ Honest caveat about Linux gaming

Once the gaming stack lands, Linux gaming via **Proton/Wine** runs the large
majority of Steam and Windows games great. The real exceptions are games with
**kernel-level anti-cheat** (e.g. Valorant, and some BattlEye / Easy Anti-Cheat
titles that haven't enabled Linux support) — those may not run. KnucklsOS will
run as many Windows/Steam games as Linux possibly can.

---

## Download

The ISO is a **single file** (about 2.0 GB) — no splitting, no rejoining:

- **Release (recommended, permanent):** https://github.com/MrKnuckls/knucklsos/releases
  Download `knucklsos-v1.1.iso`.
- **Actions artifact (temporary, ~30-day expiry):** each build also uploads a
  `knucklsos-iso` artifact from the Actions tab:
  https://github.com/MrKnuckls/knucklsos/actions

Then flash it to a USB stick — see **[FLASHING.md](FLASHING.md)**.

---

## Building the ISO (automated via GitHub Actions)

Pushing to the `ubuntu` branch triggers `.github/workflows/build.yml`, which
installs **native Debian live-build** on GitHub's runners and builds the ISO,
then uploads it as a release asset. You do **not** need to build it yourself.

> Note: the OS is **Debian**-based (not Ubuntu). Debian's `live-build` is the
> reliably-automated builder; the desktop and installer behave the same. The
> `main` branch holds the older abandoned v1.0 work — active development is on
> `ubuntu` (= v1.1).

---

## Project layout

```
knucklsos/
├── .github/workflows/build.yml   # automated ISO build (Debian live-build)
├── build.sh                       # live-build driver
├── config/
│   ├── package-lists/             # packages installed into the ISO
│   ├── hooks/normal/              # chroot hooks (branding, plymouth, installer)
│   └── includes.chroot/           # theme, branding art, look-and-feel
├── README.md
└── FLASHING.md
```
