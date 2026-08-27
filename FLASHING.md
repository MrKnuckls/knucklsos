# Flashing KnucklsOS to a USB Stick

Once the GitHub Actions build finishes, you'll get a `knucklsos-*.iso`
artifact. This guide explains how to put it on a USB stick and boot it.

> **What you're flashing:** a live KnucklsOS image (Debian + KDE Plasma,
> Windows-11-style desktop, with Steam / Lutris / Wine / GameMode / MangoHUD
> pre-loaded). You can try it straight from the USB, or install it to your
> hard drive from the desktop.

---

## 0. Rejoin the split ISO first (important!)

The ISO is **~2.9 GB**, but GitHub caps release downloads at 2 GB per file, so it's
published as **two** parts:

- `knucklsos-20260827.iso.part00`
- `knucklsos-20260827.iso.part01`

You **must combine them into one `.iso` before flashing** — do NOT write a `.part00`
file to the stick, it won't boot.

**Download both parts, then run this in the same folder:**

```bash
cat knucklsos-20260827.iso.part00 knucklsos-20260827.iso.part01 > knucklsos-20260827.iso
```

You should now have a single `knucklsos-20260827.iso` (~2.9 GB). Use that file in
the steps below. (If you'd rather not recombine, the Actions tab also offers a
single `knucklsos-iso` artifact — but it expires after ~30 days.)

---

## 1. What you need

- A USB stick — **8 GB minimum, 16 GB recommended** (the ISO is ~2.9 GB).
- A tool to write the ISO (pick one below).
- Back up anything important on that USB — it gets wiped.

---

## 2. Write the ISO to USB (pick one)

> Use the recombined `knucklsos-20260827.iso` from Step 0 — not the `.part00` / `.part01` files.

### Option A — Ventoy (recommended, easiest)
1. Download Ventoy from https://ventoy.net and install it to your USB stick
   (this formats the stick once).
2. Copy the `knucklsos-20260827.iso` file onto the stick like a normal file.
3. Done — no imaging step. You can keep many ISOs on the same stick.

### Option B — BalenaEtcher (simple GUI)
1. Get BalenaEtcher from https://etcher.balena.io.
2. Open it, select the `knucklsos-20260827.iso`, select your USB stick, click Flash.
3. Wait for "Flash complete" + validation.

### Option C — `dd` (command line, powerful but unforgiving)
> Triple-check the device name — `dd` will erase whatever disk you point it at.

```bash
# List disks and find your USB (e.g. /dev/sdX — NOT your main drive!)
lsblk

# Write the ISO (replace sdX with your USB device, NOT a partition like sdX1)
sudo dd if=knucklsos-20260827.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

---

## 3. Boot from the USB

1. Plug the stick into the target PC.
2. Power on and open the boot menu (usually **F12 / F11 / Esc / F8** at startup —
   varies by manufacturer).
3. Pick the USB stick.
4. If it doesn't show, go into the BIOS/UEFI setup and:
   - Make sure **USB boot** is enabled.
   - If booting fails with a black screen, try disabling **Secure Boot**
     (KnucklsOS uses a standard kernel; Secure Boot can block unsigned
     bootloaders on some machines).
5. KnucklsOS boots to a live desktop as the user **`knucklsos`** (no password).

---

## 4. First boot & installing

**Try it live:** Everything works from the USB — log into Steam, launch a
game, test your hardware. Nothing is written to your hard drive until you
install.

**Install to the hard drive:**
- Double-click the **"Install KnucklsOS"** icon on the desktop (this launches
  **Calamares**, the installer).
- Follow the steps: language → disk → user account → install.
- When it finishes, reboot and remove the USB.

**First boot after install:**
- A one-time setup runs: joins you to the `gamemode` group, sets the hostname,
  and enables the GPU auto-detect service.
- Log into **Steam** — your library and Proton (Steam Play) are pre-configured
  so most Windows games "just work."
- **GPU auto-detect:** on first login KnucklsOS checks your graphics card:
  - **AMD / Intel** → Mesa drivers are already active.
  - **NVIDIA** → the recommended `nvidia-driver` is installed automatically
    (this is fetched on first boot, not baked into the ISO, to keep the image
    smaller and version-correct). A reboot applies it.

---

## 5. Quick tips

- **GameMode:** press the GameMode key combo (or launch a game via Steam with
  GameMode enabled) to temporarily optimize the system for gaming.
- **MangoHUD:** overlay FPS/CPU/GPU stats — enable per-game in Steam launch
  options: `mangohud %command%`.
- **Flatpak:** Gnome Software is included for installing extra apps.

---

## 6. Honest caveats

- **Anti-cheat games:** a small number of titles using kernel-level anti-cheat
  (e.g. Valorant, some games with BattlEye / EAC that haven't enabled Linux
  support) will **not** run on Linux. The vast majority of Steam games do.
- **NVIDIA:** the driver installs on first boot; if you have an NVIDIA GPU,
  expect one extra reboot after the first login.
- **ISO not runtime-tested in a VM here:** the build is produced by GitHub's
  cloud runners. If anything misbehaves on your hardware, tell me and I'll
  adjust the config.

---

## 7. Where the ISO comes from

The ISO is built automatically by GitHub Actions (`.github/workflows/build.yml`)
using **native Debian live-build** in Debian mode. Every push to `main` rebuilds it.

**Get the ISO:**

- **Release (recommended, permanent):** the latest stable build is on the
  Releases page as two split chunks (GitHub caps release assets at 2 GB, and the
  ISO is ~2.9 GB):
  https://github.com/MrKnuckls/knucklsos/releases
  Download `knucklsos-20260827.iso.part00` **and** `knucklsos-20260827.iso.part01`,
  then rejoin them into one ISO:
  ```bash
  cat knucklsos-20260827.iso.part00 knucklsos-20260827.iso.part01 > knucklsos-20260827.iso
  ```
  (After that, `knucklsos-20260827.iso` is your flashable image.)
- **Actions artifact (temporary, ~30-day expiry):** each build also uploads a
  single `knucklsos-iso` artifact from the Actions tab:
  https://github.com/MrKnuckls/knucklsos/actions
