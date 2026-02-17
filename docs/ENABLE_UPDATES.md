
## 🔄 Enabling Auto-Updates (Magisk)

To enable automatic updates via Magisk Manager:

1.  **Host this repository** on GitHub.
2.  **Edit `module/module.prop`**:
    *   Find the line `updateJson=https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/update.json`.
    *   Replace `YOUR_USERNAME` and `YOUR_REPO` with your GitHub username and repository name.
3.  **Edit `update.json`**:
    *   Replace the `zipUrl` with the link to your latest release zip (e.g., `https://github.com/YOUR_USERNAME/YOUR_REPO/releases/latest/download/elite-nas-pro-release.zip`).
    *   Replace the `changelog` URL if desired.
4.  **Commit and Push** these changes.

When you release a new version (e.g., v5.4):
1.  Update `module/module.prop` with the new version number.
2.  Update `update.json` with the new version and zip URL.
3.  Create a GitHub Release with the new zip.
4.  Magisk will now notify users of the update!
