# Elite NAS Pro v5.3 - Minimal Update Guide

This guide explains how to update an existing v5.2 installation to v5.3 (Bug-Free Version) manually, preserving your existing configuration but adding critical protections.

## What's New in v5.3

1.  ✅ **OOM Protection:** Service won't be killed by Android memory manager (-1000 score).
2.  ✅ **Wake Lock:** Prevents Doze mode from killing service when screen is off.
3.  ✅ **Watchdog:** Auto-restarts service if it crashes (checks every 5 minutes).

Everything else (paths, port, config) remains the same.

---

## Update Instructions (from PC)

**Prerequisites:**
1.  You have this repository cloned or downloaded.
2.  Your TV Box is connected via ADB.
3.  You have `adb` installed (or use the one in `client/`).

**Steps:**

1.  Open a command prompt in the `client/` directory of this repository.

2.  Run the following commands:

    ```cmd
    REM Stop current service
    adb shell su -c "killall -9 python3"

    REM Push updated files from module/ directory
    adb push ..\module\service.sh /sdcard/
    adb push ..\module\module-restart.sh /sdcard/
    adb push ..\module\module-status.sh /sdcard/
    adb push ..\module\module.prop /sdcard/

    REM Copy to module directory
    adb shell su -c "cp /sdcard/service.sh /data/adb/modules/elite-nas-copyparty/"
    adb shell su -c "cp /sdcard/module-restart.sh /data/adb/modules/elite-nas-copyparty/"
    adb shell su -c "cp /sdcard/module-status.sh /data/adb/modules/elite-nas-copyparty/"
    adb shell su -c "cp /sdcard/module.prop /data/adb/modules/elite-nas-copyparty/"

    REM Set permissions
    adb shell su -c "chmod 755 /data/adb/modules/elite-nas-copyparty/*.sh"

    REM Start service
    adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/service.sh"

    REM Wait 5 seconds
    timeout /t 5

    REM Check status
    adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/module-status.sh"
    ```

    *Alternatively, you can just run `update-nas.bat` which does this automatically.*

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
Should show: `RUNNING` (watchdog restarted it)

---

## Rollback to Original v5.2

If you want to go back:

```cmd
adb shell su -c "cp /data/adb/modules/elite-nas-copyparty/backup-v52/*.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "chmod 755 /data/adb/modules/elite-nas-copyparty/*.sh"
adb shell su -c "killall -9 python3"
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/service.sh"
```
