#!/bin/bash

# YouTube Video/Audio Downloader Script
# Uses yt-dlp to download YouTube content

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage information
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] URL

Download YouTube videos or audio files.

OPTIONS:
    -v, --video         Download video (default, best quality)
    -a, --audio         Download audio only (best quality)
    -f, --format FORMAT Specify format (e.g., mp4, mp3, webm)
    -o, --output PATH   Output directory (default: current directory)
    -h, --help          Display this help message

EXAMPLES:
    # Download video (best quality)
    $(basename "$0") -v https://www.youtube.com/watch?v=VIDEO_ID
    
    # Download audio only
    $(basename "$0") -a https://www.youtube.com/watch?v=VIDEO_ID
    
    # Download audio as mp3
    $(basename "$0") -a -f mp3 https://www.youtube.com/watch?v=VIDEO_ID
    
    # Download to specific directory
    $(basename "$0") -v -o ~/Downloads https://www.youtube.com/watch?v=VIDEO_ID

REQUIREMENTS:
    - yt-dlp must be installed
    - For audio conversion to mp3: ffmpeg must be installed

INSTALLATION:
    # Install yt-dlp (Linux/Mac)
    pip install yt-dlp
    # or
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
    
    # Install ffmpeg
    # Ubuntu/Debian: sudo apt-get install ffmpeg
    # Mac: brew install ffmpeg
    # Fedora: sudo dnf install ffmpeg

EOF
    exit 0
}

# Function to check if yt-dlp is installed
check_dependencies() {
    if ! command -v yt-dlp &> /dev/null; then
        echo -e "${RED}Error: yt-dlp is not installed.${NC}"
        echo "Please install it using:"
        echo "  pip install yt-dlp"
        echo "or visit: https://github.com/yt-dlp/yt-dlp"
        exit 1
    fi
    
    if [ "$AUDIO_MODE" = true ] && [ "$FORMAT" = "mp3" ]; then
        if ! command -v ffmpeg &> /dev/null; then
            echo -e "${YELLOW}Warning: ffmpeg is not installed. MP3 conversion may not work.${NC}"
            echo "Install ffmpeg for audio conversion support."
        fi
    fi
}

# Default values
AUDIO_MODE=false
VIDEO_MODE=false
FORMAT=""
OUTPUT_DIR="."
URL=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--video)
            VIDEO_MODE=true
            shift
            ;;
        -a|--audio)
            AUDIO_MODE=true
            shift
            ;;
        -f|--format)
            FORMAT="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            if [[ -z "$URL" ]]; then
                URL="$1"
            else
                echo -e "${RED}Error: Unknown option or multiple URLs provided: $1${NC}"
                echo "Use -h or --help for usage information."
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate URL is provided
if [[ -z "$URL" ]]; then
    echo -e "${RED}Error: No URL provided.${NC}"
    echo "Use -h or --help for usage information."
    exit 1
fi

# If neither video nor audio mode specified, default to video
if [ "$VIDEO_MODE" = false ] && [ "$AUDIO_MODE" = false ]; then
    VIDEO_MODE=true
fi

# Check dependencies
check_dependencies

# Create output directory if it doesn't exist
if [[ ! -d "$OUTPUT_DIR" ]]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Build yt-dlp command
YTDLP_CMD="yt-dlp"

# Set output template
YTDLP_CMD="$YTDLP_CMD -o '$OUTPUT_DIR/%(title)s.%(ext)s'"

# Configure based on mode
if [ "$AUDIO_MODE" = true ]; then
    echo -e "${GREEN}Downloading audio...${NC}"
    
    if [[ -n "$FORMAT" ]]; then
        # User specified a format
        YTDLP_CMD="$YTDLP_CMD -x --audio-format $FORMAT"
    else
        # Extract best audio
        YTDLP_CMD="$YTDLP_CMD -x --audio-format best"
    fi
else
    echo -e "${GREEN}Downloading video...${NC}"
    
    if [[ -n "$FORMAT" ]]; then
        # User specified a format
        YTDLP_CMD="$YTDLP_CMD -f 'bestvideo[ext=$FORMAT]+bestaudio/best[ext=$FORMAT]/best' --merge-output-format $FORMAT"
    else
        # Download best quality video
        YTDLP_CMD="$YTDLP_CMD -f 'bestvideo+bestaudio/best'"
    fi
fi

# Add URL
YTDLP_CMD="$YTDLP_CMD '$URL'"

# Execute the command
echo -e "${YELLOW}Executing: $YTDLP_CMD${NC}"
if eval "$YTDLP_CMD"; then
    echo -e "${GREEN}Download completed successfully!${NC}"
    exit 0
else
    echo -e "${RED}Download failed. Please check the URL and try again.${NC}"
    exit 1
fi
