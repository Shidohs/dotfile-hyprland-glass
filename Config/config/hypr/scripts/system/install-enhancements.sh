#!/bin/bash
# Hyprland Enhancement Installation Script
# Adds new functionality and useful tools

set -euo pipefail

CONFIG_DIR="$HOME/.config/hypr"
SCRIPTS_DIR="$CONFIG_DIR/scripts"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Check dependencies
check_dependencies() {
    log "Checking dependencies..."
    
    local deps=("hyprctl" "notify-send" "jq" "bc")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing dependencies: ${missing[*]}"
        echo "Install with: sudo pacman -S ${missing[*]}"
        exit 1
    fi
    
    success "All dependencies satisfied"
}

# Create monitor auto-detection script
create_monitor_manager() {
    log "Creating monitor manager..."
    
    mkdir -p "$SCRIPTS_DIR/tools"
    
    cat > "$SCRIPTS_DIR/tools/monitor-manager.sh" << 'EOF'
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
EOF
    
    chmod +x "$SCRIPTS_DIR/tools/monitor-manager.sh"
    success "Monitor manager created"
}

# Create profile manager
create_profile_manager() {
    log "Creating profile manager..."
    
    mkdir -p "$CONFIG_DIR/profiles"
    
    # Work profile
    cat > "$CONFIG_DIR/profiles/work.conf" << 'EOF'
# Work Profile Configuration
# Optimized for productivity

# Workspace layout for work
workspace=1,monitor:DP-1,default:true
workspace=2,monitor:DP-1
workspace=3,monitor:HDMI-A-1

# Work-specific window rules
windowrule = workspace 1, class:^(kitty|Alacritty)$
windowrule = workspace 2, class:^(code|VSCodium|jetbrains-idea-ce)$
windowrule = workspace 3, class:^(firefox|brave-browser)$

# Reduced animations for performance
animation = windows, 1, 2, default, popin 80%
animation = workspaces, 1, 4, default, slide

# Focus follows mouse for productivity
input {
    follow_mouse = 2
}
EOF

    # Gaming profile
    cat > "$CONFIG_DIR/profiles/gaming.conf" << 'EOF'
# Gaming Profile Configuration
# Optimized for gaming performance

# Disable animations for maximum performance
animations {
    enabled = false
}

# Gaming-specific window rules
windowrule = workspace 7, class:^(Steam|lutris|heroic)$
windowrule = fullscreen, class:^(steam_app_)$
windowrule = immediate, class:^(steam_app_)$

# Disable blur for performance
decoration {
    blur {
        enabled = false
    }
}

# Gaming input settings
input {
    follow_mouse = 0
    sensitivity = 0
}
EOF

    # Profile switcher script
    cat > "$SCRIPTS_DIR/tools/profile-manager.sh" << 'EOF'
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
EOF
    
    chmod +x "$SCRIPTS_DIR/tools/profile-manager.sh"
    success "Profile manager created"
}

# Create workspace manager
create_workspace_manager() {
    log "Creating workspace manager..."
    
    cat > "$SCRIPTS_DIR/tools/workspace-manager.sh" << 'EOF'
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
EOF
    
    chmod +x "$SCRIPTS_DIR/tools/workspace-manager.sh"
    success "Workspace manager created"
}

# Create system health monitor
create_health_monitor() {
    log "Creating system health monitor..."
    
    cat > "$SCRIPTS_DIR/system/health-monitor.sh" << 'EOF'
#!/bin/bash
# Hyprland System Health Monitor

CONFIG_DIR="$HOME/.config/hypr"
LOG_FILE="$CONFIG_DIR/logs/health.log"

mkdir -p "$(dirname "$LOG_FILE")"

check_hyprland_health() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    {
        echo "[$timestamp] Health Check"
        
        # Check if Hyprland is running
        if pgrep -x "Hyprland" > /dev/null; then
            echo "✅ Hyprland: Running"
        else
            echo "❌ Hyprland: Not running"
            return 1
        fi
        
        # Check memory usage
        local mem_usage=$(ps -o pid,ppid,cmd,%mem --sort=-%mem | grep Hyprland | head -1 | awk '{print $4}')
        echo "📊 Memory usage: ${mem_usage}%"
        
        # Check if memory usage is too high
        if (( $(echo "$mem_usage > 10" | bc -l) )); then
            echo "⚠️  High memory usage detected"
        fi
        
        # Check essential components
        for component in waybar rofi hypridle; do
            if pgrep -x "$component" > /dev/null; then
                echo "✅ $component: Running"
            else
                echo "⚠️  $component: Not running"
            fi
        done
        
        echo "---"
        
    } >> "$LOG_FILE"
}

# Run health check
check_hyprland_health

# Keep only last 100 lines of log
tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
EOF
    
    chmod +x "$SCRIPTS_DIR/system/health-monitor.sh"
    success "Health monitor created"
}

# Create keybinding additions
add_new_keybindings() {
    log "Adding new keybindings..."
    
    cat >> "$CONFIG_DIR/config/keybinds.conf" << 'EOF'

# Enhanced functionality keybindings
bind = $mainMod SHIFT, M, exec, ~/.config/hypr/scripts/tools/monitor-manager.sh
bind = $mainMod SHIFT, P, exec, ~/.config/hypr/scripts/tools/profile-manager.sh work
bind = $mainMod SHIFT, G, exec, ~/.config/hypr/scripts/tools/profile-manager.sh gaming
bind = $mainMod SHIFT, O, exec, ~/.config/hypr/scripts/tools/workspace-manager.sh organize
bind = $mainMod SHIFT, H, exec, ~/.config/hypr/scripts/system/health-monitor.sh && notify-send "Health Check" "System health logged"
EOF
    
    success "New keybindings added"
}

# Create systemd service for health monitoring
create_systemd_service() {
    log "Creating systemd service for health monitoring..."
    
    mkdir -p "$HOME/.config/systemd/user"
    
    cat > "$HOME/.config/systemd/user/hyprland-health.service" << 'EOF'
[Unit]
Description=Hyprland Health Monitor
After=graphical-session.target

[Service]
Type=oneshot
ExecStart=%h/.config/hypr/scripts/system/health-monitor.sh
EOF

    cat > "$HOME/.config/systemd/user/hyprland-health.timer" << 'EOF'
[Unit]
Description=Run Hyprland Health Monitor every 5 minutes
Requires=hyprland-health.service

[Timer]
OnCalendar=*:0/5
Persistent=true

[Install]
WantedBy=timers.target
EOF
    
    # Enable the timer
    systemctl --user daemon-reload
    systemctl --user enable hyprland-health.timer
    systemctl --user start hyprland-health.timer
    
    success "Systemd health monitoring service created and enabled"
}

# Main execution
main() {
    echo "🚀 Hyprland Enhancement Installation"
    echo "===================================="
    echo
    
    warning "This will add new functionality to your Hyprland setup"
    read -p "Continue? (y/N): " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
    
    check_dependencies
    create_monitor_manager
    create_profile_manager
    create_workspace_manager
    create_health_monitor
    add_new_keybindings
    create_systemd_service
    
    echo
    success "🎉 Enhancement installation completed!"
    echo
    echo "📋 New features added:"
    echo "  • Monitor auto-detection (Super+Shift+M)"
    echo "  • Profile manager (Super+Shift+P/G)"
    echo "  • Workspace organizer (Super+Shift+O)"
    echo "  • Health monitoring (Super+Shift+H)"
    echo "  • Systemd health service (runs every 5 minutes)"
    echo
    echo "🔄 Restart Hyprland to use new keybindings"
    echo "📊 Check health logs: ~/.config/hypr/logs/health.log"
}

main "$@"
