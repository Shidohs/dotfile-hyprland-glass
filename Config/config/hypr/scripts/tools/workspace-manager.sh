#!/bin/bash
# Intelligent Workspace Manager

get_active_workspace() {
    hyprctl activeworkspace -j | jq -r '.id'
}

get_workspace_windows() {
    local workspace="$1"
    hyprctl clients -j | jq -r ".[] | select(.workspace.id == $workspace) | .class"
}

auto_organize_windows() {
    local current_ws=$(get_active_workspace)
    
    # Get all windows in current workspace
    local windows=($(get_workspace_windows "$current_ws"))
    
    for window in "${windows[@]}"; do
        case "$window" in
            "kitty"|"Alacritty"|"foot")
                hyprctl dispatch movetoworkspace 1,address:$(hyprctl clients -j | jq -r ".[] | select(.class == \"$window\") | .address")
                ;;
            "code"|"VSCodium"|"jetbrains-idea-ce")
                hyprctl dispatch movetoworkspace 2,address:$(hyprctl clients -j | jq -r ".[] | select(.class == \"$window\") | .address")
                ;;
            "firefox"|"brave-browser"|"Google-chrome")
                hyprctl dispatch movetoworkspace 3,address:$(hyprctl clients -j | jq -r ".[] | select(.class == \"$window\") | .address")
                ;;
        esac
    done
    
    notify-send "Workspace Manager" "Windows organized automatically"
}

case "${1:-}" in
    organize)
        auto_organize_windows
        ;;
    status)
        echo "Current workspace: $(get_active_workspace)"
        echo "Windows in workspace:"
        get_workspace_windows "$(get_active_workspace)"
        ;;
    *)
        echo "Usage: $0 {organize|status}"
        exit 1
        ;;
esac
