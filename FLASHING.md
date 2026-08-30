# Flashing KnucklsOS to a USB Stick

This guide explains how to put the `knucklsos-v1.1.iso` file onto a USB stick
and boot it. The ISO is a **single file** (about 2.0 GB) — no splitting or
joining needed.

> **What you're flashing:** a live KnucklsOS image (Debian + KDE Plasma,
> Windows-11-style desktop, with the KnucklsOS fist splash and wallpaper).
> You can try it straight from the USB, or install it to your hard drive from
> the desktop.

---

## 1. What you need

- A USB stick — **8 GB minimum, 16 GB recommended**.
- A tool to write the ISO (pick one below).
- Back up anything important on that USB — it gets wiped.

---

## 2. Write the ISO to USB (pick one)

### Option A — BalenaEtcher (recommended, simplest)
1. Get BalenaEtcher from https://etcher.balena.io.
2. Open it, click **Flash from file**, select `knucklsos-v1.1.iso`.
3. Select your USB stick, click **Flash**.
4. Wait for "Flash complete" + validation. Done.

### Option B — Rufus (Windows)
1. Get Rufus from https://rufus.ie.
2. Device = your USB stick.
3. **Boot selection** = `knucklsos-v1.1.iso`.
4. **Partition scheme** = **GPT**, **Target system** = **UEFI (non CSM)**.
   (This makes the stick boot in UEFI mode, which the installer needs.)
5. Click **START**, wait for it to finish.

### Option C — Ventoy
1. Download Ventoy from https://ventoy.net and install it to your USB stick
   (formats the stick once).
2. Copy `knucklsos-v1.1.iso` onto the stick like a normal file.
3. Done — no imaging step.

### Option D — `dd` (Linux/macOS command line — powerful but unforgiving)
> Triple-check the device name — `dd` erases whatever disk you point it at.

```bash
# List disks and find your USB (e.g. /dev/sdX — NOT your main drive!)
lsblk

# Write the ISO (replace sdX with your USB device, NOT a partition like sdX1)
sudo dd if=knucklsos-v1.1.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

**How to check it worked:** the USB stick should now show a bootable volume,
and the file `knucklsos-v1.1.iso` you wrote was ~2.0 GB. If the stick doesn't
boot, re-flash with BalenaEtcher or Rufus (GPT/UEFI) and try again.

---

## 3. Boot from the USB

1. Plug the stick into the target PC.
2. Power on and open the **boot menu** (usually **F12 / F11 / Esc / F8** at
   startup — varies by manufacturer). On a Dell, tap **F12**.
3. In the boot list, pick the entry that says **"UEFI: <your USB stick>"**
   (e.g. "UEFI: General USB Flash Disk"). **Do NOT pick the plain "USB" entry**
   — that's legacy/CSM mode and the installer will fail.
4. KnucklsOS boots to a live desktop as the user **`knucklsos`** (no password).
   You'll see the fist splash during boot.

> **Secure Boot:** leave it ON. KnucklsOS ships a signed bootloader (shim +
> signed GRUB), so it boots with Secure Boot enabled. No need to disable it.

---

## 4. Install to the hard drive

1. On the live desktop, double-click the **"Install KnucklsOS"** icon (the fist
   logo). This launches **Calamares**, the installer.
   - If double-clicking does nothing, open a terminal (Konsole) and run
     `sudo calamares`.
2. Follow the steps: language → keyboard → **partitions** → user account →
   summary → install.
3. On the **Partitions** screen, choose **"Erase disk"** and select your
   internal drive (on a Dell Latitude E7270 this is the **238 GB NVMe**
   (`nvme0n1`)). This wipes the whole drive and installs KnucklsOS.
4. When it finishes, it asks to restart. **Remove the USB stick**, then reboot.
5. The PC boots into the installed KnucklsOS on the hard drive.

**How to check it worked:** after removing the USB and rebooting, you should
land on the KnucklsOS desktop (fist splash → KDE desktop) and NOT see the USB
installer again. If it boots back to the installer, the USB is still in — pull
it out and reboot.

---

## 5. Quick tips

- **Live user:** `knucklsos`, no password. When you install, you create your
  own user + password during the Calamares "user account" step.
- **Branding:** the fist boot splash, "KNUCKLS OS" wallpaper, and installer
  icon are part of v1.1.

---

## 6. Honest caveats

- **Boot mode matters:** the installer only succeeds in **UEFI** mode. If you
  boot the USB the legacy way, Calamares fails at the bootloader step. Always
  pick the **"UEFI:"** USB entry in the boot menu.
- **ISO not runtime-tested in a VM here:** the build is produced by GitHub's
  cloud runners and verified on the author's Dell Latitude E7270 (UEFI, Secure
  Boot ON). If anything misbehaves on your hardware, report it and the config
  gets adjusted.

---

## 7. Where the ISO comes from

The ISO is built automatically by GitHub Actions (`.github/workflows/build.yml`)
using **native Debian live-build** in Debian mode. Every push to the `ubuntu`
branch rebuilds it.

**Get the ISO:**

- **Release (recommended, permanent):** https://github.com/MrKnuckls/knucklsos/releases
  Download `knucklsos-v1.1.iso` (single file, ~2.0 GB).
- **Actions artifact (temporary, ~30-day expiry):**
  https://github.com/MrKnuckls/knucklsos/actions
