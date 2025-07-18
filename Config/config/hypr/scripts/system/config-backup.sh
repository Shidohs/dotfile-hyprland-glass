#!/bin/bash
# Automatic Configuration Backup

BACKUP_DIR="$HOME/.config-backups"
CONFIG_DIR="$HOME/.config/hypr"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

create_backup() {
    mkdir -p "$BACKUP_DIR"
    tar -czf "$BACKUP_DIR/hypr-config-$TIMESTAMP.tar.gz" -C "$HOME/.config" hypr
    
    # Keep only last 10 backups
    ls -t "$BACKUP_DIR"/hypr-config-*.tar.gz | tail -n +11 | xargs -r rm
    
    notify-send "Backup" "Configuration backed up: $TIMESTAMP"
}

# Run backup
create_backup

# Add to crontab for daily backups
(crontab -l 2>/dev/null; echo "0 2 * * * $HOME/.config/hypr/scripts/system/config-backup.sh") | crontab -