#!/bin/bash
# Automatic Monitor Detection and Configuration

CONFIG_DIR="$HOME/.config/hypr"
MONITOR_CONFIG="$CONFIG_DIR/config/monitors.conf"

detect_monitors() {
    echo "# Auto-generated monitor configuration - $(date)"
    echo "# Format: monitor=name,resolution,position,scale"
    echo
    
    # Get connected monitors
    local monitors=($(hyprctl monitors -j | jq -r '.[].name'))
    local primary_set=false
    
    for i in "${!monitors[@]}"; do
        local monitor="${monitors[$i]}"
        local position="auto"
        
        if [[ $i -eq 0 && ! $primary_set ]]; then
            echo "# Primary monitor"
            echo "monitor=$monitor,preferred,auto,1"
            primary_set=true
        else
            echo "monitor=$monitor,preferred,auto,1"
        fi
    done
    
    echo
    echo "# Workspace assignments"
    for i in "${!monitors[@]}"; do
        local monitor="${monitors[$i]}"
        local workspace=$((i * 3 + 1))
        echo "workspace=$workspace,monitor:$monitor"
        echo "workspace=$((workspace + 1)),monitor:$monitor"
        echo "workspace=$((workspace + 2)),monitor:$monitor"
    done
}

# Backup current config
cp "$MONITOR_CONFIG" "$MONITOR_CONFIG.backup.$(date +%s)"

# Generate new config
detect_monitors > "$MONITOR_CONFIG"

# Reload Hyprland
hyprctl reload

notify-send "Monitor Manager" "Monitor configuration updated automatically"
