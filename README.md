# 🐚 Shell Script to Download Videos and Audios
**Author:** Altemir Pacheco  
**Date:** 07/11/2025  

---

## Run:

```sh
chmod +x download-video.sh
```

## ✨ Features
- Lists all available formats (video and audio)
- Interactive menu with 4 options:

  **a. Best quality automatic** – downloads and merges automatically  
  **b. Manual selection** – you choose the specific video and audio IDs  
  **c. Audio only** – extracts the best quality MP3  
  **d. Video only** – downloads only the video

- Checks if **yt-dlp** and **ffmpeg** are installed  
- Colored interface for better visualization  

---

## 🧩 Requirements
- **yt-dlp** (to install: `pip install yt-dlp`)  
- **ffmpeg** (to install: `sudo apt install ffmpeg`)

## ⚠️ YouTube app/client error fix
Some videos can fail with this message:

`The following content is not available on this app`

This script already forces compatible YouTube clients via:

`--extractor-args "youtube:player_client=android,web"`

If the video still has restricted formats, update yt-dlp:

```sh
yt-dlp -U
```


