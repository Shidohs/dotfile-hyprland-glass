#!/bin/bash
# Hyprland Profile Manager

CONFIG_DIR="$HOME/.config/hypr"
PROFILES_DIR="$CONFIG_DIR/profiles"
CURRENT_PROFILE_FILE="$CONFIG_DIR/.current-profile"

switch_profile() {
    local profile="$1"
    local profile_file="$PROFILES_DIR/$profile.conf"
    
    if [[ ! -f "$profile_file" ]]; then
        echo "Profile '$profile' not found"
        exit 1
    fi
    
    # Source the profile
    echo "source = $profile_file" > "$CONFIG_DIR/current-profile.conf"
    
    # Update main config to include current profile
    if ! grep -q "source.*current-profile.conf" "$CONFIG_DIR/hyprland.conf"; then
        echo "source = ~/.config/hypr/current-profile.conf" >> "$CONFIG_DIR/hyprland.conf"
    fi
    
    # Save current profile
    echo "$profile" > "$CURRENT_PROFILE_FILE"
    
    # Reload Hyprland
    hyprctl reload
    
    notify-send "Profile Manager" "Switched to $profile profile"
}

case "${1:-}" in
    work|gaming|default)
        switch_profile "$1"
        ;;
    current)
        if [[ -f "$CURRENT_PROFILE_FILE" ]]; then
            cat "$CURRENT_PROFILE_FILE"
        else
            echo "default"
        fi
        ;;
    list)
        echo "Available profiles:"
        ls "$PROFILES_DIR"/*.conf 2>/dev/null | xargs -n1 basename | sed 's/.conf$//' || echo "No profiles found"
        ;;
    *)
        echo "Usage: $0 {work|gaming|default|current|list}"
        exit 1
        ;;
esac
