# Elite NAS Pro v5.2 - Enhanced Installation Guide

## What's Been Fixed

### Critical Fixes Applied:
✅ **OOM Protection** - Service won't be killed by Android memory manager
✅ **Auto USB Detection** - Works with any USB drive, no hardcoded paths
✅ **PID Tracking** - Proper process monitoring
✅ **Auto-Restart Watchdog** - Automatically restarts if service dies
✅ **Proper Boot Timing** - Waits for network and storage
✅ **Full Logging** - Debug issues easily
✅ **Safe Process Killing** - Only kills NAS, not all Python
✅ **Port Cleanup** - Releases port before starting
✅ **Speed Optimizations** - Config file now actually loads

---

## Installation Methods

### Method 1: Fresh Install (Recommended for new users)

1. **Prepare the module zip:**
   - Replace all 7 .sh files in your module zip with the enhanced versions
   - Files to replace:
     * service.sh
     * module-restart.sh
     * module-status.sh
     * customize.sh
     * post-fs-data.sh
     * nas-open.sh
     * config_speed_optimized.sh

2. **Install via Magisk:**
   - Open Magisk Manager
   - Modules → Install from storage
   - Select the updated zip
   - Reboot

3. **Verify installation:**
   ```bash
   adb shell
   su
   nas-status
   ```

---

### Method 2: Upgrade Existing Installation (Faster)

If you already have the module installed and working:

1. **Connect via ADB:**
   ```bash
   adb connect YOUR_TV_BOX_IP
   adb shell
   su
   ```

2. **Backup current files:**
   ```bash
   cd /data/adb/modules/elite-nas-copyparty
   mkdir backup
   cp *.sh backup/
   ```

3. **Stop the service:**
   ```bash
   sh module-restart.sh
   killall python3
   sleep 3
   ```

4. **Upload new files:**
   - Using ADB push:
   ```bash
   # On your computer:
   adb push service.sh /data/adb/modules/elite-nas-copyparty/
   adb push module-restart.sh /data/adb/modules/elite-nas-copyparty/
   adb push module-status.sh /data/adb/modules/elite-nas-copyparty/
   adb push customize.sh /data/adb/modules/elite-nas-copyparty/
   adb push post-fs-data.sh /data/adb/modules/elite-nas-copyparty/
   adb push nas-open.sh /data/adb/modules/elite-nas-copyparty/
   adb push config_speed_optimized.sh /data/adb/modules/elite-nas-copyparty/
   ```
   
   - Or use a file manager app like MiXplorer with root access

5. **Set permissions:**
   ```bash
   cd /data/adb/modules/elite-nas-copyparty
   chmod 755 *.sh
   ```

6. **Start service:**
   ```bash
   sh service.sh
   sleep 5
   nas-status
   ```

7. **If working, reboot to test auto-start:**
   ```bash
   reboot
   ```

---

## Post-Installation Verification

### Step 1: Check Service Status
```bash
nas-status
```

**Expected output:**
```
==========================================
  ELITE NAS PRO v5.2 STATUS
==========================================

SERVICE STATUS:
  Status: RUNNING
  PID: 12345
  OOM Protection: ENABLED (Never Kill)
  Memory: 45 MB

WATCHDOG:
  Status: ACTIVE (PID: 12346)

NETWORK:
  URL: http://192.168.1.100:8080
  IP: 192.168.1.100
  Port: 8080
  Port Status: LISTENING
  Active Clients: 0

STORAGE:
  Path: /mnt/media_rw/XXXX-XXXX/NAS
  Size: 64.0G
  Used: 12.5G (20%)
  Free: 51.5G
  Writable: YES

RECENT LOGS:
  [2024-02-12 10:30:15] SUCCESS: Service started (PID: 12345)
  [2024-02-12 10:30:15] Access: http://192.168.1.100:8080
  [2024-02-12 10:30:16] OOM protection set
  [2024-02-12 10:30:16] Watchdog started
  [2024-02-12 10:30:17] === Service Started ===
```

### Step 2: Test Web Access
```bash
nas-open
```

Or manually open in browser: `http://YOUR_TV_BOX_IP:8080`

### Step 3: Check Logs
```bash
cat /data/adb/modules/elite-nas-copyparty/service.log
```

**Good signs:**
- "SUCCESS: Service started"
- "OOM protection set"
- "Watchdog started"
- No ERROR messages

**Bad signs:**
- "ERROR: Python not found"
- "ERROR: Process failed to start"
- Multiple restart attempts

---

## New Features Explained

### 1. Auto-Restart Watchdog
The service now monitors itself every 5 minutes. If it dies, it automatically restarts.

**How it works:**
- Watchdog starts 1 minute after service starts
- Checks every 5 minutes if service is running
- If dead, automatically restarts
- Logs all restart attempts

**Check watchdog status:**
```bash
nas-status | grep -A2 WATCHDOG
```

### 2. OOM Protection
The service is now protected from Android's memory killer.

**Verify protection:**
```bash
cat /proc/$(cat /data/adb/modules/elite-nas-copyparty/.pid)/oom_score_adj
```

Should show: `-1000` (never kill)

### 3. Dynamic USB Detection
No more hardcoded USB paths! The service automatically finds your USB drive.

**How it works:**
- Scans `/mnt/media_rw/*` for USB devices
- Tests if directory is readable
- Uses first working USB drive
- Falls back to `/sdcard` if no USB

**Check detected storage:**
```bash
cat /data/adb/modules/elite-nas-copyparty/.storage
```

### 4. Full Logging
Everything is now logged to `service.log`

**View logs:**
```bash
# Last 20 lines
tail -20 /data/adb/modules/elite-nas-copyparty/service.log

# Live monitoring
tail -f /data/adb/modules/elite-nas-copyparty/service.log

# Search for errors
grep ERROR /data/adb/modules/elite-nas-copyparty/service.log
```

---

## Troubleshooting

### Issue: Service shows STOPPED after reboot

**Solution 1 - Check logs:**
```bash
cat /data/adb/modules/elite-nas-copyparty/service.log
```

**Solution 2 - Manually start:**
```bash
sh /data/adb/modules/elite-nas-copyparty/service.sh
sleep 5
nas-status
```

**Solution 3 - Check Python:**
```bash
ls -l /data/data/com.termux/files/usr/bin/python3
# Should exist and be executable
```

### Issue: Watchdog not running

**Check if watchdog died:**
```bash
nas-status | grep WATCHDOG
```

**Restart service (will restart watchdog too):**
```bash
nas-restart
```

### Issue: OOM Protection shows NONE

**Manually set protection:**
```bash
PID=$(cat /data/adb/modules/elite-nas-copyparty/.pid)
echo -1000 > /proc/$PID/oom_score_adj
```

**Or restart service:**
```bash
nas-restart
```

### Issue: Storage shows "Unknown"

**Check USB connection:**
```bash
ls -la /mnt/media_rw/
```

**Manually set storage:**
```bash
# Edit service.sh, around line 52-53
# Change: STORAGE=$(detect_usb)
# To: STORAGE="/mnt/media_rw/YOUR-USB-ID"
```

### Issue: Can't access from network

**Check firewall:**
```bash
iptables -L INPUT | grep 8080
# Should show ACCEPT rule
```

**Manually add rule:**
```bash
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
```

**Check if port is listening:**
```bash
netstat -ln | grep 8080
# Should show: tcp 0 0 0.0.0.0:8080 0.0.0.0:* LISTEN
```

### Issue: Service keeps dying

**Check OOM killer logs:**
```bash
dmesg | grep -i "killed.*python"
```

**Check if OOM protection is set:**
```bash
PID=$(cat /data/adb/modules/elite-nas-copyparty/.pid)
cat /proc/$PID/oom_score_adj
# Must be -1000
```

**Check watchdog logs:**
```bash
grep WATCHDOG /data/adb/modules/elite-nas-copyparty/service.log
```

---

## Testing the Watchdog

To verify the auto-restart watchdog works:

```bash
# 1. Check current status
nas-status

# 2. Kill the service manually
PID=$(cat /data/adb/modules/elite-nas-copyparty/.pid)
kill -9 $PID

# 3. Wait 5 minutes and check again
sleep 300
nas-status
# Should show RUNNING again (watchdog restarted it)

# 4. Check logs
grep WATCHDOG /data/adb/modules/elite-nas-copyparty/service.log
# Should show: "WATCHDOG: Process died, restarting..."
```

---

## Performance Tuning

### For Mi TV Box (1-2GB RAM):
The default config is already optimized. Speed optimizations are in:
```bash
/data/adb/modules/elite-nas-copyparty/config_speed_optimized.sh
```

These optimizations:
- Disable thumbnail generation (saves RAM)
- Disable audio thumbnails (saves RAM)
- Reduce buffer sizes (faster on slow storage)
- Disable deduplication (saves CPU)

### To customize:
```bash
vi /data/adb/modules/elite-nas-copyparty/config_speed_optimized.sh
```

Add more copyparty arguments as needed.

---

## Maintenance

### Daily Check:
```bash
nas-status
```

### Weekly Check:
```bash
# Check log size
ls -lh /data/adb/modules/elite-nas-copyparty/service.log

# If > 10MB, trim it:
tail -1000 /data/adb/modules/elite-nas-copyparty/service.log > /tmp/service.log.new
mv /tmp/service.log.new /data/adb/modules/elite-nas-copyparty/service.log
```

### Monthly Check:
```bash
# Check USB drive health
df -h /mnt/media_rw/*

# Check for module updates
# (Check XDA or GitHub for new versions)
```

---

## Rollback to Original

If you need to go back to your original version:

```bash
cd /data/adb/modules/elite-nas-copyparty
killall python3
cp backup/*.sh .
chmod 755 *.sh
reboot
```

---

## Advanced: Multiple USB Drives

To use multiple USB drives, edit `service.sh`:

Find the line (around 104):
```bash
-v "$NAS_DIR/:nas:rw" \
```

Replace with:
```bash
-v "/mnt/media_rw/DRIVE1/:usb1:rw" \
-v "/mnt/media_rw/DRIVE2/:usb2:rw" \
-v "/sdcard/Downloads/:downloads:ro" \
```

---

## Getting Help

If issues persist, collect this info:

```bash
echo "=== Device Info ==="
getprop ro.product.model
getprop ro.build.version.release

echo "=== Status ==="
nas-status

echo "=== Logs ==="
tail -50 /data/adb/modules/elite-nas-copyparty/service.log

echo "=== USB Info ==="
ls -la /mnt/media_rw/

echo "=== Process Info ==="
ps | grep python
```

Save output and share when asking for help.

---

## Summary of Commands

```bash
nas-status   # Check service status
nas-restart  # Restart service
nas-open     # Open in browser

# Manual operations:
sh /data/adb/modules/elite-nas-copyparty/service.sh          # Start
cat /data/adb/modules/elite-nas-copyparty/service.log        # View log
tail -f /data/adb/modules/elite-nas-copyparty/service.log    # Live log
```

That's it! Your NAS should now be rock-solid and survive reboots, memory pressure, and network changes.
