# Elite NAS Pro v5.3

**Enterprise-Grade Headless NAS for Android TV (Magisk Module)**

Turn your Android TV Box (Mi Box, Fire TV, etc.) into a rock-solid, always-on NAS server.

## 🎯 Key Features (v5.3 - Bug Free)

*   **100% Headless:** Automated setup, no GUI needed.
*   **Triple Protection:**
    1.  ✅ **OOM Protection (-1000):** Never killed by memory manager.
    2.  ✅ **Wake Lock:** Never killed by Doze mode.
    3.  ✅ **Watchdog:** Auto-restarts every 5 minutes if crashed.
*   **Auto-Configuration:**
    *   Auto-detects any USB drive.
    *   Auto-detects IP address.
    *   Loads optimized speed config.
*   **Performance:** Tuned for ARM devices (buffers, no-dedup).

---

## 📂 Repository Structure

*   `module/`: Source code for the Magisk Module.
*   `client/`: Windows batch scripts for managing the NAS via ADB.
*   `scripts/`: Build scripts and tools.
*   `docs/`: Detailed documentation.

---

## 🚀 Installation

### Method 1: Magisk Manager (Recommended)

1.  Download the latest release ZIP.
2.  Copy to your Android TV device.
3.  Open Magisk Manager -> Modules -> Install from Storage.
4.  Select the ZIP and Reboot.
5.  Wait 3-5 minutes on first boot for Python setup.

### Method 2: Manual Update (via ADB)

If you have the repository on your PC:

1.  Connect your TV Box to ADB.
2.  Navigate to the `client/` directory.
3.  Edit `update-nas.bat` to set your TV Box IP.
4.  Run `update-nas.bat`.

See [docs/MINIMAL_UPDATE.md](docs/MINIMAL_UPDATE.md) for a minimal installation guide.

---

## 🛠 Management & Commands

Access these commands via ADB shell or Termux:

| Command | Description |
| :--- | :--- |
| `nas-status` | Show full status (IP, PID, OOM, Storage, Clients). |
| `nas-restart` | Safe restart of the service (releases ports first). |
| `nas-open` | Open the NAS web interface in the Android browser. |

For Windows users, use the scripts in `client/`:
*   `check-status.bat`: View status from PC.
*   `restart-nas.bat`: Restart service from PC.
*   `view-log.bat`: View service logs.

See [docs/BATCH_FILES.md](docs/BATCH_FILES.md) for details on Windows scripts.

---

## 🔍 Troubleshooting

**Service Stopped?**
Check logs:
```bash
tail -20 /data/adb/modules/elite-nas-copyparty/service.log
```

**Storage Unknown?**
Ensure USB drive is mounted at `/mnt/media_rw/`.

For more details, see the [Documentation](docs/).

---

## 🔄 Updates

To enable automatic updates via Magisk Manager, follow the instructions in [docs/ENABLE_UPDATES.md](docs/ENABLE_UPDATES.md).

---

**Elite NAS Ultimate Pro** - *Transforming TV Sticks into High-Performance Storage Appliances.*
