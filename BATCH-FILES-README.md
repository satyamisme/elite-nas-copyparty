# Batch Files for Elite NAS Pro v5.3

## Files Included

1. **update-nas.bat** - Full update (push all files + restart)
2. **restart-nas.bat** - Quick restart only
3. **check-status.bat** - Check service status

---

## Setup

1. **Download all files** to: `C:\Users\genesislap\Downloads\files\`

2. **Edit IP address** in each .bat file if needed:
   - Open file in Notepad
   - Change: `set TVBOX_IP=192.168.0.241`
   - Save

---

## Usage

### First Time / Full Update
**Double-click:** `update-nas.bat`

**Does:**
- Connects to TV Box
- Stops old service
- Pushes all 8 files
- Sets permissions
- Starts service
- Shows status

**Time:** ~15 seconds

---

### Quick Restart
**Double-click:** `restart-nas.bat`

**Does:**
- Stops service
- Starts service
- Done

**Time:** ~10 seconds

**Use when:**
- Service is stuck
- Need to restart quickly
- No file changes needed

---

### Check Status
**Double-click:** `check-status.bat`

**Does:**
- Shows current status
- PID, OOM protection, URL, etc.

**Time:** ~3 seconds

**Use when:**
- Want to verify service is running
- Check if protections are active
- Get URL to access NAS

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
service.sh: 1 file pushed...
module-restart.sh: 1 file pushed...
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
STORAGE:  /mnt/media_rw/4E04-D72A
CLIENTS:  0 active
==========================================

Update complete!

Test in browser: http://192.168.0.241:8080/nas/
```

### restart-nas.bat
```
Restarting Elite NAS Pro...
Stopping Elite NAS...
Starting...
Elite NAS Restarted.

Done! Service restarted.
```

### check-status.bat
```
Checking Elite NAS Pro status...

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
**Solution:** Make sure `adb.exe` is in the same folder as the .bat files

### Error: "device unauthorized"
**Solution:** 
1. Look at TV Box screen
2. Accept the ADB debugging prompt
3. Run the .bat file again

### Error: "no devices/emulators found"
**Solution:**
1. Check TV Box IP address is correct in .bat file
2. Make sure Network ADB is enabled on TV Box:
   - Settings → Developer Options → Network Debugging

### Files push but service doesn't start
**Solution:**
1. Run: `check-status.bat`
2. Check logs: 
   ```cmd
   adb shell su -c "tail -20 /data/adb/modules/elite-nas-copyparty/service.log"
   ```

---

## Daily Use

**Typical workflow:**

1. **First install:** Run `update-nas.bat` once
2. **Daily:** Just use the NAS (auto-protected, auto-restarts)
3. **If stuck:** Run `restart-nas.bat`
4. **Check if working:** Run `check-status.bat`
5. **After updating files:** Run `update-nas.bat`

---

## File Locations

```
C:\Users\genesislap\Downloads\files\
├── adb.exe                     (Required)
├── AdbWinApi.dll               (Required)
├── AdbWinUsbApi.dll            (Required)
├── update-nas.bat              (Use for updates)
├── restart-nas.bat             (Use for quick restart)
├── check-status.bat            (Use to check status)
├── service.sh                  (Module files - will be pushed)
├── module-restart.sh
├── module-status.sh
├── customize.sh
├── post-fs-data.sh
├── nas-open.sh
├── config_speed_optimized.sh
└── module.prop
```

---

## Tips

- **Bookmark NAS URL:** `http://192.168.0.241:8080/nas/`
- **Pin batch files:** Right-click → Send to → Desktop (create shortcut)
- **Create desktop shortcuts** for easy access
- **Run check-status.bat** daily to verify everything working

---

## One-Click Updates

To update NAS in future:
1. Download new files to the folder
2. Double-click `update-nas.bat`
3. Done!

No need to type any commands!
