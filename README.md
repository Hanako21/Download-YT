
# **Download-YT (Downloader for iOS)**  

This project automates downloading YouTube audio and video directly on iOS using **a-Shell** and **Shortcuts**. It supports:  
- **Audio downloads** (`.opus`)  
- **Video downloads** (`.webm`)  
- **Automatic file transfer to VLC**  

⚠️ **VLC is optional but highly recommended for optimal use.** If VLC is not installed, the Shortcut may show errors, but the video/audio will still download and remain in **a-Shell's Documents folder** instead of being moved.  

---

## **📥 Setup Instructions**  

### **1️⃣ Install Required Apps**  
- Download **[a-Shell](https://apps.apple.com/app/a-shell/id1473805438)** from the App Store.  
- Download **[Shortcuts](https://apps.apple.com/app/shortcuts/id1462947752)** (if not already installed).  
- Download **[VLC for Mobile](https://apps.apple.com/app/vlc-for-mobile/id650377962)** (optional but recommended).  

### **2️⃣ Install the Script in a-Shell**  
1. Open **a-Shell** and run:  
   ```sh
   cd ~/Documents
   curl -O https://raw.githubusercontent.com/Hanako21/Download-YT/main/ytdl.sh
   chmod +x ytdl.sh
