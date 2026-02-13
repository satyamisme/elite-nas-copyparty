# Elite NAS Pro v5.3 - MINIMAL FIXED VERSION

## What Changed from Your Working v5.2

**ONLY 3 CRITICAL FIXES ADDED:**

1. ✅ **OOM Protection** - Added `echo -1000 > /proc/$PID/oom_score_adj`
   - Prevents Android from killing the service under memory pressure
   
2. ✅ **Wake Lock** - Added `echo "elite_nas_v53" > /sys/power/wake_lock`
   - Prevents Doze mode from killing service when screen off
   
3. ✅ **Watchdog** - Added simple background monitor
   - Auto-restarts service if it dies (checks every 5 minutes)

**EVERYTHING ELSE IS EXACTLY THE SAME:**
- ✅ Same paths: `/mnt/media_rw/4E04-D72A/`
- ✅ Same copyparty command: `--no-idx . --unsafe-state`
- ✅ Same port: 8080
- ✅ Same mount point: `/nas/`
- ✅ No network detection delays
- ✅ No USB detection - uses your exact path
- ✅ No logging bloat
- ✅ Simple and fast

---

## Install from PC

```cmd
cd C:\Users\genesislap\Downloads\files

REM Download the FIXED-MINIMAL files to this folder

REM Stop current service
adb shell su -c "killall -9 python3"

REM Push files
adb push service.sh /sdcard/
adb push module-restart.sh /sdcard/
adb push module-status.sh /sdcard/
adb push module.prop /sdcard/

REM Copy to module
adb shell su -c "cp /sdcard/service.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "cp /sdcard/module-restart.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "cp /sdcard/module-status.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "cp /sdcard/module.prop /data/adb/modules/elite-nas-copyparty/"

REM Set permissions
adb shell su -c "chmod 755 /data/adb/modules/elite-nas-copyparty/*.sh"

REM Start
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/service.sh"

REM Wait 5 seconds
timeout /t 5

REM Check status
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/module-status.sh"
```

**Expected output:**
```
==========================================
  ELITE NAS PRO v5.3 (Fixed)
==========================================
STATUS:   RUNNING (PID: 12345)
URL:      http://192.168.0.241:8080/nas/
OOM ADJ:  PROTECTED (-1000)
STORAGE:  /mnt/media_rw/4E04-D72A
CLIENTS:  0 active
==========================================
```

---

## Test Access

Open browser: `http://192.168.0.241:8080/nas/`

Should see all your folders:
- Movies
- Music  
- Download
- Documents
- etc.

---

## Verify Protections Work

### 1. Check OOM Protection
```cmd
adb shell su -c "cat /proc/\$(cat /data/adb/modules/elite-nas-copyparty/.pid)/oom_score_adj"
```
Should show: `-1000`

### 2. Check Wake Lock
```cmd
adb shell su -c "cat /sys/power/wake_lock | grep elite"
```
Should show: `elite_nas_v53`

### 3. Test Watchdog (Optional)
```cmd
REM Kill the service
adb shell su -c "kill -9 \$(cat /data/adb/modules/elite-nas-copyparty/.pid)"

REM Wait 5-6 minutes
timeout /t 360

REM Check if auto-restarted
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/module-status.sh"
```
Should show: RUNNING (watchdog restarted it)

---

## Differences: v5.2 vs v5.3 Minimal

| Feature | v5.2 (Original) | v5.3 Minimal |
|---------|-----------------|--------------|
| **Same Features** | | |
| USB Path | `/mnt/media_rw/4E04-D72A/` | Same ✓ |
| Port | 8080 | Same ✓ |
| Copyparty flags | `--no-idx . --unsafe-state` | Same ✓ |
| Startup speed | Fast | Same ✓ |
| **New Protections** | | |
| OOM Protection | ❌ None | ✅ -1000 |
| Wake Lock | ❌ None | ✅ Active |
| Watchdog | ❌ None | ✅ 5min check |
| PID Tracking | ❌ None | ✅ Saved to .pid |

---

## Commands

```cmd
REM Restart service
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/module-restart.sh"

REM Check status
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/module-status.sh"

REM Check if running
adb shell su -c "ps | grep python"
```

---

## Rollback to Original v5.2

If you want to go back:

```cmd
adb shell su -c "cp /data/adb/modules/elite-nas-copyparty/backup-v52/*.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "chmod 755 /data/adb/modules/elite-nas-copyparty/*.sh"
adb shell su -c "killall -9 python3"
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/service.sh"
```

---

## Summary

**This version:**
- ✅ Keeps your exact working setup
- ✅ Adds only 3 essential protections
- ✅ No path changes
- ✅ No delays
- ✅ No complex detection
- ✅ Simple and reliable

**Result:**
Your NAS works exactly like before, but now:
- Won't be killed by Android memory manager
- Won't be killed by Doze mode
- Auto-restarts if it crashes

**That's it. Simple and effective.** 🎯
