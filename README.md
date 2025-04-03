
# **Download-YT (Downloader for iOS)**  

This project automates downloading YouTube audio and video directly on iOS using **a-Shell** and **Shortcuts**. It supports:  
- **Audio downloads** (`.opus for regular audio, .mp3 for Spotify`)  
- **Video downloads** (`.webm`)  
- **Automatic file transfer to VLC and Spotify**  

⚠️ **VLC is optional but highly recommended for optimal use.** If VLC is not installed, the Shortcut may show errors, but the video/audio will still download and remain in **a-Shell's Documents folder** instead of being moved. Note that **downloading videos or plain audio requires VLC**, but **Spotify downloads work without VLC**.

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
   ```
   ```
   curl -O https://raw.githubusercontent.com/Hanako21/Download-YT/main/ytdl.sh
   ```
   ```
   chmod +x ytdl.sh
   ```
   
### **3️⃣ Import the Shortcut**  
1. Download the Shortcut file:  
   **[Download-YT](https://github.com/Hanako21/Download-YT/raw/main/Download-YT.shortcut)**  
2. Open the `.shortcut` file on your iPhone.  
3. When prompted, tap **"Add Shortcut"** to import it into the Shortcuts app.  
4. Grant **File Access Permissions** when prompted.  
 5. **Add the Shortcut to the Share Sheet**:  
   - Open the Shortcuts app.  
   - Tap the **three dots (•••)** on **Download-YT** to edit it.  
   - Tap **"Settings" (top right corner)**.  
   - Tap **"Add to Share Sheet"** and enable it.  
   - Tap **"Done"** to save.  

---

## **🚀 How to Use**  

1. Open a video you want to download.  
2. Tap the **Apple Share Sheet** (**not a website’s custom share button**) and select **Download-YT**.  
3. Choose **Audio (Opus or MP3), Video (WebM), or Spotify** when prompted.  
4. The Shortcut will:  
   - **Download the file** using `yt-dlp` in a-Shell.  
   - **Move the file to VLC or Spotify** automatically (if installed).  
   - **If VLC is not installed**, the file will stay in `a-Shell/Documents/vlcPipe`.  

---

Enjoy your downloads! 🚀  
