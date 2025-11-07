# download-yt-video

Shell script to download YouTube videos and audio files using yt-dlp.

## Features

- Download YouTube videos in best quality
- Download audio-only files
- Convert audio to MP3 or other formats
- Specify custom output directory
- Simple command-line interface

## Requirements

- **yt-dlp**: The main tool for downloading YouTube content
- **ffmpeg** (optional): Required for audio format conversion (e.g., to MP3)

## Installation

### Install yt-dlp

**Using pip:**
```bash
pip install yt-dlp
```

**Or download directly (Linux/Mac):**
```bash
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
```

### Install ffmpeg (Optional, for MP3 conversion)

**Ubuntu/Debian:**
```bash
sudo apt-get install ffmpeg
```

**macOS:**
```bash
brew install ffmpeg
```

**Fedora:**
```bash
sudo dnf install ffmpeg
```

## Usage

Make the script executable (first time only):
```bash
chmod +x download-yt.sh
```

### Download Video (Best Quality)

```bash
./download-yt.sh -v https://www.youtube.com/watch?v=VIDEO_ID
```

or simply (video is default):
```bash
./download-yt.sh https://www.youtube.com/watch?v=VIDEO_ID
```

### Download Audio Only

```bash
./download-yt.sh -a https://www.youtube.com/watch?v=VIDEO_ID
```

### Download Audio as MP3

```bash
./download-yt.sh -a -f mp3 https://www.youtube.com/watch?v=VIDEO_ID
```

### Specify Output Directory

```bash
./download-yt.sh -v -o ~/Downloads https://www.youtube.com/watch?v=VIDEO_ID
```

### Download Video in Specific Format

```bash
./download-yt.sh -v -f mp4 https://www.youtube.com/watch?v=VIDEO_ID
```

## Command-Line Options

| Option | Description |
|--------|-------------|
| `-v, --video` | Download video in best quality (default) |
| `-a, --audio` | Download audio only |
| `-f, --format FORMAT` | Specify output format (e.g., mp4, mp3, webm) |
| `-o, --output PATH` | Specify output directory (default: current directory) |
| `-h, --help` | Display help message |

## Examples

```bash
# Download a video
./download-yt.sh https://www.youtube.com/watch?v=dQw4w9WgXcQ

# Download audio as MP3
./download-yt.sh -a -f mp3 https://www.youtube.com/watch?v=dQw4w9WgXcQ

# Download to a specific folder
./download-yt.sh -o ~/Videos https://www.youtube.com/watch?v=dQw4w9WgXcQ

# Download audio in best quality
./download-yt.sh -a https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

## Troubleshooting

### "yt-dlp is not installed" error
Install yt-dlp using the installation instructions above.

### "ffmpeg is not installed" warning
This warning appears when trying to convert audio to MP3 without ffmpeg. Install ffmpeg or download audio in the default format.

### Download fails
- Check your internet connection
- Verify the YouTube URL is correct and the video is publicly accessible
- Some videos may have restrictions or require authentication

## License

MIT License - See LICENSE file for details
