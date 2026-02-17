# Batch Files for Elite NAS Pro v5.3

## Files Included

1.  **update-nas.bat** - Full update (push all files + restart)
2.  **restart-nas.bat** - Quick restart only
3.  **check-status.bat** - Check service status
4.  **get-logs.bat** - Collect diagnostic logs
5.  **view-log.bat** - Quick view of recent logs

---

## Setup

These files are located in the `client/` directory of the repository.

1.  **Navigate to the `client/` folder** on your PC.
2.  **Ensure `adb.exe`** and required DLLs are present in the folder (included in repo).
3.  **Edit IP address** in each `.bat` file if needed:
    *   Open file in Notepad (e.g., `update-nas.bat`)
    *   Change: `set TVBOX_IP=192.168.0.241` (to your TV Box IP)
    *   Save

---

## Usage

### First Time / Full Update

**Double-click:** `update-nas.bat`

**Function:**
*   Connects to TV Box via ADB.
*   Stops old service.
*   Pushes all module files from the `../module/` directory to the device.
*   Sets permissions.
*   Starts service.
*   Shows status.

**Time:** ~15 seconds

---

### Quick Restart

**Double-click:** `restart-nas.bat`

**Function:**
*   Connects to TV Box.
*   Triggers `nas-restart` on the device.
*   Done.

**Time:** ~10 seconds

**Use when:**
*   Service is stuck.
*   Need to restart quickly.
*   No file changes needed.

---

### Check Status

**Double-click:** `check-status.bat`

**Function:**
*   Shows current status (PID, OOM protection, URL, etc.).

**Time:** ~3 seconds

**Use when:**
*   Want to verify service is running.
*   Check if protections are active.
*   Get URL to access NAS.

---

## Expected Output

### update-nas.bat

```
========================================
  Elite NAS Pro v5.3 Auto Updater
========================================

[1/7] Connecting to TV Box...
[2/7] Stopping current service...
[3/7] Pushing files to /sdcard/...
...
[4/7] Copying files to module directory...
[5/7] Setting permissions...
[6/7] Starting service...
[7/7] Checking status...

==========================================
  ELITE NAS PRO v5.3 (Fixed)
==========================================
STATUS:   RUNNING (PID: 12345)
URL:      http://192.168.0.241:8080/nas/
OOM ADJ:  PROTECTED (-1000)
...
```

---

## Troubleshooting

### Error: "adb is not recognized"

**Solution:** Make sure `adb.exe` is in the `client/` folder with the `.bat` files.

### Error: "device unauthorized"

**Solution:**
1.  Look at TV Box screen.
2.  Accept the ADB debugging prompt.
3.  Run the `.bat` file again.

### Error: "no devices/emulators found"

**Solution:**
1.  Check TV Box IP address is correct in `.bat` file.
2.  Make sure Network ADB is enabled on TV Box (Settings → Developer Options → Network Debugging).

### Files push but service doesn't start

**Solution:**
1.  Run: `check-status.bat`
2.  Run: `view-log.bat` to see errors (checks `nas.log`).

---

## Daily Use

**Typical workflow:**

1.  **First install:** Run `update-nas.bat` once.
2.  **Daily:** Just use the NAS (auto-protected, auto-restarts).
3.  **If stuck:** Run `restart-nas.bat`.
4.  **Check if working:** Run `check-status.bat`.
5.  **After updating module files:** Run `update-nas.bat`.

---

## File Locations

The scripts are in `client/` and manage files in `module/`.

```
repo/
├── client/
│   ├── adb.exe
│   ├── update-nas.bat
│   ├── restart-nas.bat
│   ├── check-status.bat
│   ├── get-logs.bat
│   └── view-log.bat
├── module/
│   ├── service.sh
│   ├── module.prop
│   └── ...
└── README.md
```
