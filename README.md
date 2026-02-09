# Elite NAS Ultimate Pro (Magisk Module)

Elite NAS Ultimate Pro is an enterprise-grade, background-first Network Attached Storage (NAS) solution specifically designed for Android TV environments (Mi TV Stick, Mi Box, etc.). By integrating a hardened Termux environment, a privileged BusyBox binary, and the Copyparty file server, this module transforms standard media hardware into a high-performance file appliance.

## 🚀 Key Features

*   **100% Headless Setup**: Automated Termux bootstrapping and Python environment extraction. No manual interaction with the Termux GUI is required.
*   **Architecture Aware**: Automatically detects and extracts the correct environment for `aarch64` (64-bit) or `arm` (32-bit) devices during installation.
*   **USB OTG Read/Write Enforcer**: Automated remounting and permission fixing for external drives (`/mnt/media_rw/*`), overcoming standard Android storage restrictions.
*   **Speed Optimized**: Calibrated with $256$ KiB socket buffers (`--s-wr-sz 262144`) and disabled resource-heavy metadata indexing to maximize ARM CPU efficiency.
*   **Self-Healing Watchdog**: A background monitoring service that checks the daemon status every 60 seconds and auto-restarts the server if it crashes.
*   **Enterprise Observability**: A dedicated dashboard providing real-time data on active clients, storage health, and OOM (Out of Memory) priority scores.

## 🛠️ System Requirements

*   **Android Version**: 7.0 (API 24) to 14 (API 34).[1, 1]
*   **Root Framework**: Magisk 26.0+ or KernelSU.[1, 1]
*   **Device Architecture**: ARMv7 (32-bit) or ARM64 (64-bit).[1, 1]

## 📥 Installation

1.  Download the `elite-nas-ultimate.zip`.
2.  Install via **Magisk Manager** -> **Modules** -> **Install from storage**.
3.  Reboot your device.
4.  **Important**: On the first boot, the module will take 3-5 minutes to initialize the Python environment in the background.
5.  Access your NAS via browser at `http://:8080`.

## 💻 Management Commands

Run these via ADB shell or a local terminal emulator:

| Command | Description |
| :--- | :--- |
| `module-status` | Displays the NAS Dashboard (Process info, Clients, Storage). |
| `module-restart` | Forcefully releases ports and restarts all background services. |
| `nas-open` | Automatically triggers an intent to open the NAS URL on the TV's browser. |

## ⚙️ Configuration

Customization can be performed by editing `/data/adb/modules/elite-nas-copyparty/config.sh`.
*   **Port**: Default is 8080.
*   **Optimization**: Speed-optimized flags are enabled by default in the startup logic.
