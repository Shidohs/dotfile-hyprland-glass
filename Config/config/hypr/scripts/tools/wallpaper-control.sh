#!/bin/bash
# Wallpaper Control Script
# Easy control for AleatoryWall.sh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

SCRIPT_DIR="$HOME/.config/hypr/scripts/tools"
ALEATORY_SCRIPT="$SCRIPT_DIR/AleatoryWall.sh"
LOG_FILE="$HOME/.config/hypr/logs/aleatory-wall.log"

# Functions
show_status() {
    echo -e "${CYAN}🖼️  Wallpaper System Status${NC}"
    echo "=========================="
    
    # Check if script is running
    if pgrep -f "AleatoryWall.sh" >/dev/null; then
        local pid=$(pgrep -f "AleatoryWall.sh")
        echo -e "${GREEN}✅ Status: Running (PID: $pid)${NC}"
        
        # Show current wallpaper
        if [[ -f "$HOME/.config/hypr/.current-wallpaper" ]]; then
            local current=$(cat "$HOME/.config/hypr/.current-wallpaper")
            echo -e "${BLUE}🖼️  Current: $(basename "$current")${NC}"
        fi
        
        # Show uptime
        local start_time=$(ps -o lstart= -p $pid 2>/dev/null)
        if [[ -n "$start_time" ]]; then
            echo -e "${BLUE}⏰ Started: $start_time${NC}"
        fi
    else
        echo -e "${RED}❌ Status: Not running${NC}"
    fi
    
    # Show wallpaper directory info
    local wall_dirs=("$HOME/Wallpapers" "$HOME/Pictures/Wallpapers")
    for dir in "${wall_dirs[@]}"; do
        if [[ -d "$dir" ]] || [[ -L "$dir" ]]; then
            local count=$(find "$dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) 2>/dev/null | wc -l)
            echo -e "${BLUE}📁 Directory: $dir ($count images)${NC}"
            break
        fi
    done
}

start_daemon() {
    if pgrep -f "AleatoryWall.sh" >/dev/null; then
        echo -e "${YELLOW}⚠️  AleatoryWall is already running${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🚀 Starting AleatoryWall daemon...${NC}"
    
    if [[ -f "$ALEATORY_SCRIPT" ]]; then
        "$ALEATORY_SCRIPT" &
        sleep 2
        
        if pgrep -f "AleatoryWall.sh" >/dev/null; then
            echo -e "${GREEN}✅ AleatoryWall started successfully${NC}"
        else
            echo -e "${RED}❌ Failed to start AleatoryWall${NC}"
            return 1
        fi
    else
        echo -e "${RED}❌ AleatoryWall script not found: $ALEATORY_SCRIPT${NC}"
        return 1
    fi
}

stop_daemon() {
    if ! pgrep -f "AleatoryWall.sh" >/dev/null; then
        echo -e "${YELLOW}⚠️  AleatoryWall is not running${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🛑 Stopping AleatoryWall daemon...${NC}"
    
    pkill -f "AleatoryWall.sh"
    sleep 1
    
    if ! pgrep -f "AleatoryWall.sh" >/dev/null; then
        echo -e "${GREEN}✅ AleatoryWall stopped successfully${NC}"
    else
        echo -e "${YELLOW}⚠️  Force killing AleatoryWall...${NC}"
        pkill -9 -f "AleatoryWall.sh"
        echo -e "${GREEN}✅ AleatoryWall force stopped${NC}"
    fi
}

change_now() {
    echo -e "${BLUE}🔄 Changing wallpaper now...${NC}"
    
    if [[ -f "$ALEATORY_SCRIPT" ]]; then
        DEBUG=false "$ALEATORY_SCRIPT" --once
        echo -e "${GREEN}✅ Wallpaper changed${NC}"
    else
        echo -e "${RED}❌ AleatoryWall script not found${NC}"
        return 1
    fi
}

show_logs() {
    local lines=${1:-20}
    
    if [[ -f "$LOG_FILE" ]]; then
        echo -e "${CYAN}📋 Last $lines log entries:${NC}"
        echo "=========================="
        tail -n "$lines" "$LOG_FILE"
    else
        echo -e "${YELLOW}⚠️  No log file found${NC}"
    fi
}

restart_daemon() {
    echo -e "${BLUE}🔄 Restarting AleatoryWall daemon...${NC}"
    stop_daemon
    sleep 2
    start_daemon
}

show_help() {
    echo -e "${PURPLE}🖼️  Wallpaper Control Script${NC}"
    echo "============================"
    echo
    echo -e "${YELLOW}Usage:${NC} $0 [COMMAND]"
    echo
    echo -e "${YELLOW}Commands:${NC}"
    echo -e "  ${GREEN}status${NC}     Show current status"
    echo -e "  ${GREEN}start${NC}      Start the wallpaper daemon"
    echo -e "  ${GREEN}stop${NC}       Stop the wallpaper daemon"
    echo -e "  ${GREEN}restart${NC}    Restart the wallpaper daemon"
    echo -e "  ${GREEN}change${NC}     Change wallpaper immediately"
    echo -e "  ${GREEN}logs${NC}       Show recent log entries"
    echo -e "  ${GREEN}debug${NC}      Run diagnostic script"
    echo -e "  ${GREEN}help${NC}       Show this help message"
    echo
    echo -e "${YELLOW}Examples:${NC}"
    echo -e "  $0 status          # Check if daemon is running"
    echo -e "  $0 change          # Change wallpaper now"
    echo -e "  $0 logs 50         # Show last 50 log entries"
}

run_debug() {
    local debug_script="$SCRIPT_DIR/wallpaper-debug.sh"
    
    if [[ -f "$debug_script" ]]; then
        echo -e "${BLUE}🔍 Running diagnostic script...${NC}"
        "$debug_script"
    else
        echo -e "${RED}❌ Debug script not found: $debug_script${NC}"
        return 1
    fi
}

# Main execution
case "${1:-status}" in
    status|st)
        show_status
        ;;
    start)
        start_daemon
        ;;
    stop)
        stop_daemon
        ;;
    restart|rs)
        restart_daemon
        ;;
    change|ch)
        change_now
        ;;
    logs|log)
        show_logs "${2:-20}"
        ;;
    debug|diag)
        run_debug
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        echo -e "Use ${GREEN}$0 help${NC} for available commands"
        exit 1
        ;;
esac
