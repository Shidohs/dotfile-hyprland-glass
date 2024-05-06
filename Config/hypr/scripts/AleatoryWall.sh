#!/bin/bash
# Directory to search for wallpapers
WALL_DIR="$HOME/Wallpapers"

# Find all image files in the directory
WALL=( "$WALL_DIR"/*.{png,jpg,jpeg} )

# Change the wallpaper randomly
change_wallpaper() {
    # Get a random index from the list of wallpapers
    local index=$(( RANDOM % ${#WALL[@]} ))

    # Set the wallpaper using swaybg
    swaybg -i "${WALL[$index]}"
}

# Call the function to change the wallpaper initially and then every 30 minutes
change_wallpaper
while true; do
    sleep 1800
    change_wallpaper
done
