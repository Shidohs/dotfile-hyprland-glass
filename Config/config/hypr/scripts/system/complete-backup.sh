#!/bin/bash
# Complete Hyprland Configuration Backup Script
# Creates comprehensive backup with timestamp and rollback capability

set -euo pipefail

# Configuration
BACKUP_BASE_DIR="$HOME/.config-backups"
CONFIG_DIR="$HOME/.config/hypr"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$BACKUP_BASE_DIR/hypr-backup-$TIMESTAMP"
MAX_BACKUPS=10

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    error "This script should not be run as root"
    exit 1
fi

# Create backup directory
create_backup_structure() {
    log "Creating backup structure..."
    mkdir -p "$BACKUP_DIR"/{config,scripts,themes,rofi,logs}
    mkdir -p "$BACKUP_BASE_DIR/rollback-scripts"
}

# Backup configuration files
backup_configs() {
    log "Backing up configuration files..."
    
    # Main config files
    cp "$CONFIG_DIR"/*.conf "$BACKUP_DIR/" 2>/dev/null || true
    
    # Config subdirectory
    cp -r "$CONFIG_DIR/config" "$BACKUP_DIR/" 2>/dev/null || true
    
    # Scripts
    cp -r "$CONFIG_DIR/scripts" "$BACKUP_DIR/" 2>/dev/null || true
    
    # Themes
    cp -r "$CONFIG_DIR/themes" "$BACKUP_DIR/" 2>/dev/null || true
    
    # Rofi configuration
    cp -r "$CONFIG_DIR/rofi" "$BACKUP_DIR/" 2>/dev/null || true
    
    success "Configuration files backed up"
}

# Create system info snapshot
create_system_snapshot() {
    log "Creating system snapshot..."
    
    {
        echo "# System Information - $TIMESTAMP"
        echo "## Hyprland Version"
        hyprctl version 2>/dev/null || echo "Hyprland not running"
        
        echo -e "\n## Installed Packages (Hyprland related)"
        pacman -Q | grep -E "(hypr|waybar|rofi|dunst|sway)" || true
        
        echo -e "\n## Running Processes"
        ps aux | grep -E "(hypr|waybar|rofi)" | grep -v grep || true
        
        echo -e "\n## Environment Variables"
        env | grep -E "(XDG|WAYLAND|QT|GTK)" | sort
        
        echo -e "\n## Monitor Configuration"
        hyprctl monitors 2>/dev/null || echo "Hyprland not running"
        
    } > "$BACKUP_DIR/system-info.txt"
    
    success "System snapshot created"
}

# Create rollback script
create_rollback_script() {
    log "Creating rollback script..."
    
    cat > "$BACKUP_BASE_DIR/rollback-scripts/rollback-$TIMESTAMP.sh" << 'EOF'
#!/bin/bash
# Rollback script for Hyprland configuration
# Generated automatically - DO NOT EDIT

BACKUP_DIR="BACKUP_DIR_PLACEHOLDER"
CONFIG_DIR="$HOME/.config/hypr"
TIMESTAMP="TIMESTAMP_PLACEHOLDER"

echo "🔄 Rolling back Hyprland configuration to $TIMESTAMP"
echo "⚠️  This will overwrite your current configuration!"
read -p "Continue? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Rollback cancelled"
    exit 1
fi

# Create backup of current config before rollback
CURRENT_BACKUP="$HOME/.config-backups/pre-rollback-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$CURRENT_BACKUP"
cp -r "$CONFIG_DIR" "$CURRENT_BACKUP/"

# Restore from backup
echo "Restoring configuration..."
rm -rf "$CONFIG_DIR"
cp -r "$BACKUP_DIR" "$CONFIG_DIR"

echo "✅ Rollback completed successfully"
echo "💡 Previous config saved to: $CURRENT_BACKUP"
echo "🔄 Please restart Hyprland to apply changes"
EOF

    # Replace placeholders
    sed -i "s|BACKUP_DIR_PLACEHOLDER|$BACKUP_DIR|g" "$BACKUP_BASE_DIR/rollback-scripts/rollback-$TIMESTAMP.sh"
    sed -i "s|TIMESTAMP_PLACEHOLDER|$TIMESTAMP|g" "$BACKUP_BASE_DIR/rollback-scripts/rollback-$TIMESTAMP.sh"
    
    chmod +x "$BACKUP_BASE_DIR/rollback-scripts/rollback-$TIMESTAMP.sh"
    
    success "Rollback script created: rollback-$TIMESTAMP.sh"
}

# Cleanup old backups
cleanup_old_backups() {
    log "Cleaning up old backups (keeping last $MAX_BACKUPS)..."
    
    cd "$BACKUP_BASE_DIR"
    
    # Remove old backup directories
    ls -dt hypr-backup-* 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm -rf
    
    # Remove old rollback scripts
    ls -dt rollback-scripts/rollback-*.sh 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm -f
    
    success "Cleanup completed"
}

# Create compressed archive
create_archive() {
    log "Creating compressed archive..."
    
    cd "$BACKUP_BASE_DIR"
    tar -czf "hypr-backup-$TIMESTAMP.tar.gz" "hypr-backup-$TIMESTAMP"
    
    # Verify archive
    if tar -tzf "hypr-backup-$TIMESTAMP.tar.gz" >/dev/null 2>&1; then
        success "Archive created and verified: hypr-backup-$TIMESTAMP.tar.gz"
    else
        error "Archive verification failed"
        exit 1
    fi
}

# Send notification
send_notification() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Hyprland Backup" "Configuration backed up successfully\nTimestamp: $TIMESTAMP" -i folder-download
    fi
}

# Main execution
main() {
    log "Starting Hyprland configuration backup..."
    log "Backup directory: $BACKUP_DIR"
    
    create_backup_structure
    backup_configs
    create_system_snapshot
    create_rollback_script
    create_archive
    cleanup_old_backups
    send_notification
    
    success "Backup completed successfully!"
    echo
    echo "📁 Backup location: $BACKUP_DIR"
    echo "📦 Archive: $BACKUP_BASE_DIR/hypr-backup-$TIMESTAMP.tar.gz"
    echo "🔄 Rollback script: $BACKUP_BASE_DIR/rollback-scripts/rollback-$TIMESTAMP.sh"
    echo
    echo "To rollback to this configuration:"
    echo "  bash $BACKUP_BASE_DIR/rollback-scripts/rollback-$TIMESTAMP.sh"
}

# Run main function
main "$@"
