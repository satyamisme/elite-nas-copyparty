---

# 🚀 Elite NAS Ultimate Pro

### **Enterprise-Grade Headless NAS for Android TV**


[](https://www.google.com/search?q=%5Bhttps://github.com/topjohnwu/Magisk%5D(https://github.com/topjohnwu/Magisk))
[](https://www.google.com/search?q=%23-system-requirements)

**Elite NAS Ultimate Pro** is a high-performance, background-first Network Attached Storage (NAS) solution engineered for Android TV environments (Mi TV Stick, Mi Box, Ugoos, etc.). It bridges the gap between restricted mobile firmware and enterprise file services by integrating a hardened Termux environment, architecture-aware Python bootstrapping, and the Copyparty file server. [1, 1]

---

## ✨ Key Features

| Feature | Description |
| --- | --- |
| **100% Headless** | Automated Termux bootstrapping and Python extraction. No GUI interaction required. 

 |
| **USB OTG RW Fix** | Automated remounting and permission enforcement (`chmod 777`) for external drives. 

 |
| **Speed Optimized** | Pre-configured with 256KB socket buffers to maximize ARM CPU efficiency. [1, 1] |
| **Self-Healing** | Background **Watchdog** service monitors the daemon and auto-restarts on crashes. 

 |
| **OOM Protection** | Hardened priority settings (-1000 score) to prevent system memory killers. 

 |
| **Live Dashboard** | Real-time terminal reporting of active clients, storage health, and process status. 

 |

---

## 🛠️ System Requirements

* **Host Device:** Android TV (Mi Stick 4K/jaws, Mi Box S, etc.). 


* **Android Version:** 7.0 (API 24) to 14 (API 34). 


* **Architecture:** ARMv7 (32-bit) or ARM64 (64-bit). 


* **Root:** Magisk 26.0+ or KernelSU. 



---

## 📥 Installation

1. Download the latest([https://github.com/your-repo/releases](https://www.google.com/search?q=https://github.com/your-repo/releases)).
2. Open **Magisk Manager** ➔ **Modules** ➔ **Install from storage**. 


3. Select the ZIP and reboot your device.
4. **⏱ Important:** On the first boot, wait **3-5 minutes** for the Python environment to initialize in the background. 



---

## 💻 Management & GUI Dashboard

The module includes system-wide binaries that can be executed from any terminal (ADB shell or Termux):

| Command | Action |
| --- | --- |
| `module-status` | Launches the **Enhanced Dashboard** (IP, Clients, Storage stats). 

 |
| `module-restart` | Forcefully releases ports and re-initializes all background services. 

 |
| `nas-open` | Triggers a TV intent to open the NAS web interface in the local browser. 

 |

---

## 📂 Directory Structure

elite-nas-copyparty/
├── busybox                 # Privileged binary v1.31.1 
├── copyparty.py            # Core File Server 
├── customize.sh            # Automated Magisk Installer 
├── service.sh              # Background Daemon & Watchdog 
├── config.sh               # User-defined Port/Fallback settings 
├── module-status.sh        # GUI Terminal Dashboard 
├── bootstrap-aarch64.zip   # 64-bit Python Environment 
├── bootstrap-arm.zip       # 32-bit Python Environment 
└── system/bin/             # Global symlinks (status, restart) 

---

## ⚙️ Performance Tuning

By default, the module applies high-speed parameters from `config_speed_optimized.sh` [1, 1]:

* `--s-wr-sz 262144`: High-speed socket write buffers.
* `--no-vthumb`: Disables video thumbnails to preserve TV CPU.
* `--no-dedup`: Skips hash checks for maximum write speed.

---

## 📜 Copyright & Credits

This project is a composite work utilizing several powerful open-source components:

* **BusyBox**: Copyright © 1998-2015 Multiple Authors. Licensed under [GPLv2](https://www.google.com/search?q=https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html). 


* **Termux**: Copyright © Termux Contributors. Licensed under [GPLv3](https://www.google.com/search?q=https://www.gnu.org/licenses/gpl-3.0.en.html). 


* **Copyparty**: Copyright © 9001. Licensed under the([https://github.com/9001/copyparty/blob/hovudstraum/LICENSE](https://www.google.com/search?q=https://github.com/9001/copyparty/blob/hovudstraum/LICENSE)). 


* **Module Integration**: Copyright © **GenesisPC**. All original shell scripts (`service.sh`, `customize.sh`, `module-status.sh`), architectural logic, and Android TV hardening are the property of GenesisPC. 



---

## 🔗 Links & Resources

* **Project Home:**([https://github.com/satyamisme/elite-nas-copyparty](https://www.google.com/search?q=https://github.com/satyamisme/elite-nas-copyparty))
* **Developer Support:**
* **Report Bugs:** Please include the output of `adb shell su -c module-status` in your issue. 



---

**Elite NAS Ultimate Pro** - *Transforming TV Sticks into High-Performance Storage Appliances.*
