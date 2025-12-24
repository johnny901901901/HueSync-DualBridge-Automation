# Philips Hue Sync: Multi-Bridge & Dual-Monitor Automation

A high-stability, community-driven automation method for running two independent instances of the Philips Hue Sync desktop app on one Windows PC. Optimized for dual-monitor setups where each display is controlled by a separate Philips Hue Bridge.

## 🚀 The Challenge
The native Philips Hue Sync app is hard-coded to allow only one instance and one Bridge connection. Standard workarounds often suffer from "Identity Drift," where monitor or bridge assignments revert or swap after a system restart. This script creates a "Stability Shield" to mitigate those issues.

## 🛠 Features
- **Independent Identities:** Uses folder-swapping logic for `%AppData%` and `%LocalAppData%`, ensuring each instance keeps its unique Bridge API keys and Monitor selections.
- **Instance Unlocking:** Uses the Sysinternals Handle tool to bypass the "Single Instance" lock.
- **Invisible Startup:** Background execution via VBScript ensures zero CMD windows interrupt your workflow.
- **High-Speed System Logic:** Specifically tuned for high-end hardware (tested on RTX 5090 / NVMe) to prevent configuration corruption.
- 
## 📦 Prerequisites: Mobile App Setup
Before setting up the PC automation, you must ensure both Bridges are correctly linked to your Philips Hue account on your mobile device (iOS or Android).

### 1. Requirements
- Both Bridges must be plugged into the same network/router via Ethernet.
- Your phone must be on the same Wi-Fi network.
- Ensure your Hue App is updated to at least **Version 5.31**.

### 2. Adding the Second Bridge
1. Open the **Philips Hue App** on your phone.
2. Tap the **Settings** (gear icon) at the bottom right.
3. Select **Bridges**.
4. Tap the **(+) plus icon** at the top right.
5. The app will search for the new Bridge. When found, follow the on-screen prompt to **press the large round button** on the center of the new Bridge.
6. **Consolidation (Optional):** You may see a banner saying "Use one account for all" or "Are multiple Homes actually 1 Home?". Tapping this allows you to manage both Bridges under a single "Home" profile for easier switching.

*Note: Philips Hue Entertainment Areas can only contain lights from ONE Bridge. This is why the PC automation below is required to sync two monitors simultaneously.*

## 📦 Setup Requirements

1. **The Handle Tool:**
   - Download the [Sysinternals Handle tool](https://learn.microsoft.com/en-us/sysinternals/downloads/handle) from Microsoft.
   - Use `handle64.exe` for 64-bit Windows or `handle.exe` for 32-bit.
2. **Folder Preparation (Crucial):**
   - Navigate to `%AppData%` and create a copy of the `HueSync` folder. Name it `HueSync2`.
   - Navigate to `%LocalAppData%` and find the folder named **`Signify`**. Create a copy of it and name it **`Signify2`**.
3. **App Settings:**
   - Open Hue Sync and **uncheck** "Launch Hue Sync on startup."

## ⚙️ Task Scheduler: Step-by-Step Configuration

To make this fully automatic and invisible:

1. **Open Task Scheduler:** Press `Win + R`, type `taskschd.msc`, and hit Enter.
2. **Create Task:** Click **Create Task...** (right-hand pane).
3. **General Tab:**
   - **Name:** `HueSync_DualLaunch`
   - **Security options:** Check **Run with highest privileges**. (Required for the handle tool).
4. **Triggers Tab:**
   - Click **New...** -> Select **At log on**.
   - Check **Delay task for:** and set it to **30 seconds**.
5. **Actions Tab:**
   - Click **New...** -> Action: **Start a program**.
   - **Program/script:** `wscript.exe`
   - **Add arguments:** Type the path to your VBS file in quotes, e.g., `"C:\Scripts\SilentHue.vbs"`
6. **Conditions Tab:**
   - Uncheck **Start the task only if the computer is on AC power**.

## 🛠 Customization

Before running, you must ensure the file paths in the scripts match your system:

1. **In `HueDualLaunch.bat`**: 
   - Update `SCRIPT_DIR` to the folder where you saved your scripts.
   - Update `HANDLE_EXE` if you are using the 32-bit version (`handle.exe`).
   - The script is configured for the **`Signify`** folder naming convention.

2. **In `SilentHue.vbs`**:
   - Update the path `C:\Scripts\HueDualLaunch.bat` to the actual location on your drive.

## ⚠️ Stability & "Identity Drift" Warning
The Hue Sync app is notoriously finicky when forced into multiple instances. I have set a **40-second timer** in the script because, on high-performance PCs, the app can appear "open" while it is still writing configuration data to the disk. 

**Note:** Even with this timer, the app can occasionally be temperamental. You may still experience rare instances where "Display Monitor" settings or "Bridge Selection" flip back to defaults. This is a limitation of how the Hue Sync software handles its local cache and handshakes. If this happens, a manual correction in the app settings followed by a "Quit" from the tray is usually required to "re-bake" the settings.

---
*Disclaimer: Community-driven workaround. Use at your own risk. Backup your Hue Sync configuration folders before implementing.*
