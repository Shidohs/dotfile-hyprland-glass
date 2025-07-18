#!/bin/bash

# AleatoryWall.sh - Wallpaper changer with debugging
# Enhanced version with better error handling and logging

set -euo pipefail

# Configuration
Script_Wall=$(basename "$0")
LOG_FILE="$HOME/.config/hypr/logs/aleatory-wall.log"
DEBUG=${DEBUG:-false}

# Wallpaper directories (in order of preference)
WALL_DIRS=(
    "$HOME/Wallpapers"
    "$HOME/Pictures/Wallpapers"
    "$HOME/.local/share/wallpapers"
    "/usr/share/pixmaps"
    "/usr/share/backgrounds"
)

# Supported image formats
IMAGE_FORMATS=("*.png" "*.jpg" "*.jpeg" "*.webp" "*.bmp" "*.tiff")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo -e "${BLUE}[AleatoryWall]${NC} $1" >&2
    echo "$message" >> "$LOG_FILE" 2>/dev/null || true
}

debug() {
    if [[ "$DEBUG" == "true" ]]; then
        local message="[$(date '+%Y-%m-%d %H:%M:%S')] [DEBUG] $1"
        echo -e "${YELLOW}[DEBUG]${NC} $1" >&2
        echo "$message" >> "$LOG_FILE" 2>/dev/null || true
    fi
}

error() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1"
    echo -e "${RED}[ERROR]${NC} $1" >&2
    echo "$message" >> "$LOG_FILE" 2>/dev/null || true
}

success() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] $1"
    echo -e "${GREEN}[SUCCESS]${NC} $1" >&2
    echo "$message" >> "$LOG_FILE" 2>/dev/null || true
}

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true

# Function to kill previous instances
kill_previous_instances() {
    debug "Checking for previous instances of $Script_Wall"
    local pids=$(pgrep -f "$Script_Wall" 2>/dev/null || true)

    for pid in $pids; do
        if [[ "$pid" != "$$" ]]; then
            debug "Killing previous instance with PID: $pid"
            kill -TERM "$pid" 2>/dev/null || true
            sleep 1
            # Force kill if still running
            if kill -0 "$pid" 2>/dev/null; then
                kill -KILL "$pid" 2>/dev/null || true
            fi
        fi
    done
}

# Function to find wallpaper directory
find_wallpaper_directory() {
    debug "Searching for wallpaper directories..."

    for dir in "${WALL_DIRS[@]}"; do
        debug "Checking directory: $dir"

        # Resolve symlinks
        if [[ -L "$dir" ]]; then
            local real_dir=$(readlink -f "$dir")
            debug "Directory $dir is a symlink pointing to: $real_dir"
            dir="$real_dir"
        fi

        if [[ -d "$dir" ]]; then
            debug "Directory exists: $dir"

            # Check if directory has images
            local image_count=0
            for format in "${IMAGE_FORMATS[@]}"; do
                local count=$(find "$dir" -type f -iname "$format" 2>/dev/null | wc -l)
                image_count=$((image_count + count))
            done

            if [[ $image_count -gt 0 ]]; then
                success "Found wallpaper directory: $dir ($image_count images)"
                echo "$dir"
                return 0
            else
                debug "Directory $dir exists but contains no images"
            fi
        else
            debug "Directory does not exist: $dir"
        fi
    done

    error "No wallpaper directory found with images"
    return 1
}

# Find wallpaper directory
WALL_DIR=$(find_wallpaper_directory)
if [[ $? -ne 0 ]]; then
    error "Cannot find any wallpaper directory. Please create one of:"
    for dir in "${WALL_DIRS[@]}"; do
        error "  - $dir"
    done
    exit 1
fi

debug "Using wallpaper directory: $WALL_DIR"

# Kill previous instances
kill_previous_instances

# Find all image files
debug "Searching for image files in $WALL_DIR"
mapfile -t WALL < <(
    for format in "${IMAGE_FORMATS[@]}"; do
        find "$WALL_DIR" -type f -iname "$format" 2>/dev/null
    done | sort
)

# Verify images were found
if [[ ${#WALL[@]} -eq 0 ]]; then
    error "No image files found in $WALL_DIR"
    error "Supported formats: ${IMAGE_FORMATS[*]}"
    exit 1
fi

success "Found ${#WALL[@]} wallpaper(s) in $WALL_DIR"

# Function to check if required tools are available
check_dependencies() {
    local deps=("swaybg" "wal" "swaync-client")
    local missing=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing dependencies: ${missing[*]}"
        error "Please install the missing packages"
        return 1
    fi

    debug "All dependencies are available"
    return 0
}

# Function to kill existing swaybg processes
kill_swaybg() {
    debug "Killing existing swaybg processes"
    pkill -f "swaybg" 2>/dev/null || true
    sleep 0.5
}

# Enhanced wallpaper change function
change_wallpaper() {
    debug "Starting wallpaper change process"

    # Select random wallpaper
    local wallpaper=$(shuf -n 1 -e "${WALL[@]}")
    local wallpaper_name=$(basename "$wallpaper")

    log "Changing wallpaper to: $wallpaper_name"

    # Verify the file exists and is readable
    if [[ ! -f "$wallpaper" ]]; then
        error "Wallpaper file not found: $wallpaper"
        return 1
    fi

    if [[ ! -r "$wallpaper" ]]; then
        error "Cannot read wallpaper file: $wallpaper"
        return 1
    fi

    # Kill existing swaybg processes
    kill_swaybg

    # Set wallpaper using swaybg
    debug "Setting wallpaper with swaybg"
    if swaybg -i "$wallpaper" -m fill >/dev/null 2>&1 & then
        debug "swaybg started successfully"
    else
        error "Failed to start swaybg"
        return 1
    fi

    # Generate color palette with pywal (if available)
    if command -v wal >/dev/null 2>&1; then
        debug "Generating color palette with pywal"
        if wal -i "$wallpaper" --backend wal -q >/dev/null 2>&1; then
            debug "Color palette generated successfully"
        else
            debug "Failed to generate color palette (non-critical)"
        fi
    else
        debug "pywal not available, skipping color generation"
    fi

    # Restart SwayNC to apply new colors (if available)
    if command -v swaync-client >/dev/null 2>&1; then
        debug "Restarting SwayNC"
        swaync-client -rs >/dev/null 2>&1 || debug "Failed to restart SwayNC (non-critical)"
    fi

    # Restart Waybar to apply new colors (if running)
    if pgrep -x "waybar" >/dev/null 2>&1; then
        debug "Restarting Waybar"
        killall -SIGUSR2 waybar 2>/dev/null || debug "Failed to restart Waybar (non-critical)"
    fi

    success "Wallpaper changed to: $wallpaper_name"

    # Save current wallpaper info
    echo "$wallpaper" > "$HOME/.config/hypr/.current-wallpaper" 2>/dev/null || true
}

# Function to handle script termination
cleanup() {
    log "Script terminating, cleaning up..."
    kill_swaybg
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Function to run in background
run_in_background() {
    log "Starting AleatoryWall daemon"
    log "Wallpaper directory: $WALL_DIR"
    log "Found ${#WALL[@]} wallpapers"
    log "Change interval: 60 minutes"

    # Change wallpaper immediately
    change_wallpaper

    # Main loop
    while true; do
        debug "Sleeping for 30 minutes..."
        sleep 3600  # 30 minutes

        # Re-scan for new wallpapers
        debug "Re-scanning wallpaper directory"
        mapfile -t WALL < <(
            for format in "${IMAGE_FORMATS[@]}"; do
                find "$WALL_DIR" -type f -iname "$format" 2>/dev/null
            done | sort
        )

        if [[ ${#WALL[@]} -eq 0 ]]; then
            error "No wallpapers found during re-scan"
            continue
        fi

        debug "Found ${#WALL[@]} wallpapers in re-scan"
        change_wallpaper
    done
}

# Main execution
main() {
    log "=== AleatoryWall Script Started ==="

    # Check dependencies
    if ! check_dependencies; then
        exit 1
    fi

    # Handle command line arguments
    case "${1:-}" in
        --debug)
            DEBUG=true
            debug "Debug mode enabled"
            ;;
        --once)
            log "Running in single-change mode"
            change_wallpaper
            exit 0
            ;;
        --help)
            echo "AleatoryWall - Automatic wallpaper changer"
            echo "Usage: $0 [--debug|--once|--help]"
            echo "  --debug  Enable debug output"
            echo "  --once   Change wallpaper once and exit"
            echo "  --help   Show this help"
            exit 0
            ;;
    esac

    # Run in background
    run_in_background &
    disown

    log "AleatoryWall daemon started in background"
}

# Run main function
main "$@"
