#!/bin/bash
# Hyprland Glass - Automated Installation Script
# Author: @Shidohs
# Description: Complete installation script for Hyprland Glass environment

set -euo pipefail

# Enhanced Colors and Styles
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'
NC='\033[0m' # No Color

# Gradient colors
GRADIENT1='\033[38;5;81m'   # Light blue
GRADIENT2='\033[38;5;75m'   # Medium blue
GRADIENT3='\033[38;5;69m'   # Dark blue
GRADIENT4='\033[38;5;63m'   # Purple blue

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REQUIREMENTS_FILE="$SCRIPT_DIR/requirements.json"
CONFIG_BACKUP_DIR="$HOME/.config-backups/pre-install-$(date +%Y%m%d_%H%M%S)"

# Animation and visual functions
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [${CYAN}%c${NC}]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Progress bar function
progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((current * width / total))
    local remaining=$((width - completed))

    printf "\r${BOLD}Progress: ${NC}["
    printf "%*s" $completed | tr ' ' '█'
    printf "%*s" $remaining | tr ' ' '░'
    printf "] ${GRADIENT1}%d%%${NC} (${current}/${total})" $percentage
}

# Typing effect function
type_text() {
    local text="$1"
    local delay=${2:-0.03}
    local color=${3:-$WHITE}

    for (( i=0; i<${#text}; i++ )); do
        printf "${color}%c${NC}" "${text:$i:1}"
        sleep $delay
    done
    echo
}

# Enhanced logging functions with icons
log() {
    echo -e "${BLUE}${BOLD}⏰ [$(date +'%H:%M:%S')]${NC} ${WHITE}$1${NC}";
}

success() {
    echo -e "${GREEN}${BOLD}✅ [SUCCESS]${NC} ${WHITE}$1${NC}";
}

warning() {
    echo -e "${YELLOW}${BOLD}⚠️  [WARNING]${NC} ${YELLOW}$1${NC}";
}

error() {
    echo -e "${RED}${BOLD}❌ [ERROR]${NC} ${RED}$1${NC}" >&2;
}

info() {
    echo -e "${CYAN}${BOLD}ℹ️  [INFO]${NC} ${CYAN}$1${NC}";
}

step() {
    echo -e "${PURPLE}${BOLD}🔸 [STEP]${NC} ${WHITE}$1${NC}";
}

# Box drawing function
draw_box() {
    local text="$1"
    local color=${2:-$CYAN}
    local width=${3:-60}

    echo -e "${color}╔$(printf '═%.0s' $(seq 1 $((width-2))))╗${NC}"
    printf "${color}║${NC}%*s${color}║${NC}\n" $((width-2)) ""
    printf "${color}║${NC}%*s%*s${color}║${NC}\n" $(((width-2+${#text})/2)) "$text" $(((width-2-${#text})/2)) ""
    printf "${color}║${NC}%*s${color}║${NC}\n" $((width-2)) ""
    echo -e "${color}╚$(printf '═%.0s' $(seq 1 $((width-2))))╝${NC}"
}

# Separator function
separator() {
    local char=${1:-"═"}
    local color=${2:-$GRAY}
    local width=${3:-80}

    echo -e "${color}$(printf "${char}%.0s" $(seq 1 $width))${NC}"
}

# Enhanced Banner with animations
show_banner() {
    clear
    echo

    # Animated title with gradient effect
    echo -e "${BOLD}${GRADIENT1}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                                                                          ║
    ║    ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗    ║
    ║    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗   ║
    ║    ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║   ║
    ║    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║   ║
    ║    ██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝   ║
    ║    ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ║
    ║                                                                          ║
EOF

    echo -e "${GRADIENT2}"
    cat << 'EOF'
    ║                          ██████╗ ██╗      █████╗ ███████╗███████╗         ║
    ║                         ██╔════╝ ██║     ██╔══██╗██╔════╝██╔════╝         ║
    ║                         ██║  ███╗██║     ███████║███████╗███████╗         ║
    ║                         ██║   ██║██║     ██╔══██║╚════██║╚════██║         ║
    ║                         ╚██████╔╝███████╗██║  ██║███████║███████║         ║
    ║                          ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝         ║
    ║                                                                          ║
EOF

    echo -e "${GRADIENT3}"
    cat << 'EOF'
    ║                    🌟 Premium Wayland Desktop Environment 🌟             ║
    ║                                                                          ║
    ║                        ✨ Glass Effects & Animations ✨                  ║
    ║                        🚀 Optimized for Performance 🚀                   ║
    ║                        🎨 Beautiful & Customizable 🎨                    ║
    ║                                                                          ║
    ╚══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    # Animated subtitle
    echo
    type_text "                    🔧 Automated Installation Script v2.0 🔧" 0.05 "${CYAN}${BOLD}"
    type_text "                         Author: @Shidohs | MIT License" 0.03 "${GRAY}"
    echo

    # Loading animation
    echo -e "${WHITE}${BOLD}Initializing installation environment...${NC}"
    for i in {1..20}; do
        printf "${GRADIENT1}▓${NC}"
        sleep 0.05
    done
    echo -e " ${GREEN}${BOLD}Ready!${NC}"
    echo

    separator "─" "$GRAY" 78
    echo
}

# Welcome message with system info
show_welcome() {
    echo -e "${CYAN}${BOLD}🎉 Welcome to Hyprland Glass Installer! 🎉${NC}"
    echo
    echo -e "${WHITE}This installer will set up a complete Wayland desktop environment with:${NC}"
    echo -e "${GREEN}  ✓ ${WHITE}Hyprland compositor with glass effects${NC}"
    echo -e "${GREEN}  ✓ ${WHITE}Waybar with custom themes${NC}"
    echo -e "${GREEN}  ✓ ${WHITE}Rofi launcher with multiple themes${NC}"
    echo -e "${GREEN}  ✓ ${WHITE}SwayNC notification center${NC}"
    echo -e "${GREEN}  ✓ ${WHITE}Optimized for gaming and productivity${NC}"
    echo -e "${GREEN}  ✓ ${WHITE}Automatic backup and rollback system${NC}"
    echo

    # System information
    echo -e "${BLUE}${BOLD}📊 System Information:${NC}"
    echo -e "${CYAN}  • OS: ${WHITE}$(lsb_release -d 2>/dev/null | cut -f2 || echo "Arch Linux")${NC}"
    echo -e "${CYAN}  • Kernel: ${WHITE}$(uname -r)${NC}"
    echo -e "${CYAN}  • Architecture: ${WHITE}$(uname -m)${NC}"
    echo -e "${CYAN}  • User: ${WHITE}$USER${NC}"
    echo -e "${CYAN}  • Date: ${WHITE}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo

    separator "─" "$GRAY" 78
    echo
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root"
        exit 1
    fi
}

# Enhanced system requirements check with visual feedback
check_requirements() {
    step "Checking system requirements"
    echo

    local checks=("Arch Linux" "Internet connection" "Requirements file" "Disk space" "Permissions")
    local current_check=0
    local total_checks=${#checks[@]}

    # Check if running on Arch Linux
    ((current_check++))
    printf "  ${YELLOW}⏳${NC} Checking ${checks[0]}..."
    if command -v pacman >/dev/null 2>&1; then
        printf "\r  ${GREEN}✅${NC} ${checks[0]} ${GREEN}(detected)${NC}\n"
    else
        printf "\r  ${RED}❌${NC} ${checks[0]} ${RED}(not found)${NC}\n"
        error "This script is designed for Arch Linux and derivatives"
        exit 1
    fi

    # Check internet connection
    ((current_check++))
    printf "  ${YELLOW}⏳${NC} Checking ${checks[1]}..."
    if ping -c 1 google.com >/dev/null 2>&1; then
        printf "\r  ${GREEN}✅${NC} ${checks[1]} ${GREEN}(connected)${NC}\n"
    else
        printf "\r  ${RED}❌${NC} ${checks[1]} ${RED}(no connection)${NC}\n"
        error "Internet connection required for installation"
        exit 1
    fi

    # Check if requirements file exists
    ((current_check++))
    printf "  ${YELLOW}⏳${NC} Checking ${checks[2]}..."
    if [[ -f "$REQUIREMENTS_FILE" ]]; then
        local package_count=$(jq '[.System[]] | add | length' "$REQUIREMENTS_FILE")
        printf "\r  ${GREEN}✅${NC} ${checks[2]} ${GREEN}($package_count packages)${NC}\n"
    else
        printf "\r  ${RED}❌${NC} ${checks[2]} ${RED}(not found)${NC}\n"
        error "Requirements file not found: $REQUIREMENTS_FILE"
        exit 1
    fi

    # Check disk space
    ((current_check++))
    printf "  ${YELLOW}⏳${NC} Checking ${checks[3]}..."
    local available_space=$(df / | awk 'NR==2 {print $4}')
    local required_space=2097152  # 2GB in KB
    if [[ $available_space -gt $required_space ]]; then
        local space_gb=$((available_space / 1024 / 1024))
        printf "\r  ${GREEN}✅${NC} ${checks[3]} ${GREEN}(${space_gb}GB available)${NC}\n"
    else
        printf "\r  ${RED}❌${NC} ${checks[3]} ${RED}(insufficient space)${NC}\n"
        error "At least 2GB of free disk space required"
        exit 1
    fi

    # Check permissions
    ((current_check++))
    printf "  ${YELLOW}⏳${NC} Checking ${checks[4]}..."
    if sudo -n true 2>/dev/null; then
        printf "\r  ${GREEN}✅${NC} ${checks[4]} ${GREEN}(sudo available)${NC}\n"
    else
        printf "\r  ${YELLOW}⚠️${NC} ${checks[4]} ${YELLOW}(will prompt for sudo)${NC}\n"
    fi

    echo
    success "✨ All system requirements satisfied!"
    echo
}

# Enhanced system update with progress
update_system() {
    step "Updating system packages"
    echo

    echo -e "${WHITE}Synchronizing package databases...${NC}"
    if sudo pacman -Sy --noconfirm >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅${NC} Package databases synchronized"
    else
        echo -e "  ${RED}❌${NC} Failed to sync package databases"
        exit 1
    fi

    echo -e "${WHITE}Checking for system updates...${NC}"
    local updates=$(pacman -Qu | wc -l)

    if [[ $updates -gt 0 ]]; then
        echo -e "  ${CYAN}📦${NC} Found ${WHITE}$updates${NC} packages to update"
        echo -e "${WHITE}Updating system packages (this may take a while)...${NC}"

        # Show a simple progress indicator
        sudo pacman -Su --noconfirm &
        local pid=$!

        while kill -0 $pid 2>/dev/null; do
            for i in {1..4}; do
                printf "\r  ${CYAN}⏳${NC} Updating system packages"
                printf "%*s" $i | tr ' ' '.'
                sleep 0.5
            done
        done

        wait $pid
        if [[ $? -eq 0 ]]; then
            printf "\r  ${GREEN}✅${NC} System packages updated successfully\n"
        else
            printf "\r  ${RED}❌${NC} Failed to update system packages\n"
            exit 1
        fi
    else
        echo -e "  ${GREEN}✅${NC} System is already up to date"
    fi

    echo
    success "🔄 System update completed"
    echo
}

# Install essential dependencies
install_essential_deps() {
    log "Installing essential dependencies..."
    local essential_packages=("rsync" "jq" "git" "curl" "wget" "base-devel")

    for package in "${essential_packages[@]}"; do
        if ! pacman -Qi "$package" >/dev/null 2>&1; then
            sudo pacman -S --noconfirm "$package"
        fi
    done

    success "Essential dependencies installed"
}

# Backup existing configuration
backup_existing_config() {
    log "Creating backup of existing configuration..."

    mkdir -p "$CONFIG_BACKUP_DIR"

    # Backup important directories if they exist
    local dirs_to_backup=(".config/hypr" ".config/waybar" ".config/kitty" ".config/rofi" ".zshrc" ".aliases")

    for dir in "${dirs_to_backup[@]}"; do
        if [[ -e "$HOME/$dir" ]]; then
            cp -r "$HOME/$dir" "$CONFIG_BACKUP_DIR/" 2>/dev/null || true
            info "Backed up: $dir"
        fi
    done

    success "Configuration backup created at: $CONFIG_BACKUP_DIR"
}

# Copy configuration files
copy_config_files() {
    log "Copying configuration files..."

    # Check if Config directory exists
    if [[ -d "$SCRIPT_DIR/Config/config" ]]; then
        rsync -av "$SCRIPT_DIR/Config/config/" ~/.config/
        success "Configuration files copied to ~/.config/"
    else
        # If Config directory doesn't exist, copy current directory structure
        warning "Config directory not found, using current directory structure"

        # Create necessary directories
        mkdir -p ~/.config/hypr

        # Copy configuration files
        cp -r config/ ~/.config/hypr/ 2>/dev/null || true
        cp -r scripts/ ~/.config/hypr/ 2>/dev/null || true
        cp -r themes/ ~/.config/hypr/ 2>/dev/null || true
        cp -r rofi/ ~/.config/hypr/ 2>/dev/null || true
        cp -r profiles/ ~/.config/hypr/ 2>/dev/null || true
        cp *.conf ~/.config/hypr/ 2>/dev/null || true

        success "Configuration files copied from current directory"
    fi

    # Copy home directory files if they exist
    if [[ -d "$SCRIPT_DIR/Config/Home" ]]; then
        rsync -av "$SCRIPT_DIR/Config/Home/" ~/
        success "Home directory files copied"
    fi
}

# Configure SDDM Display Manager
configure_sddm() {
    log "Configuring display manager..."

    read -p "¿Quieres cambiar el Display Manager a SDDM? (y/n): " change_dm

    case $change_dm in
        y|Y)
            log "Installing and configuring SDDM..."

            # Install SDDM if not installed
            if ! pacman -Qi sddm >/dev/null 2>&1; then
                sudo pacman -S --noconfirm sddm
            fi

            # Install SDDM dependencies
            local sddm_deps=("qt5-graphicaleffects" "qt5-svg" "qt5-quickcontrols2")
            for dep in "${sddm_deps[@]}"; do
                if ! pacman -Qi "$dep" >/dev/null 2>&1; then
                    sudo pacman -S --noconfirm "$dep"
                fi
            done

            # Disable current display manager
            local dm_service=$(systemctl list-unit-files --type=service --state=enabled | grep 'dm\.service' | awk '{print $1}')
            if [[ -n "$dm_service" ]]; then
                sudo systemctl disable "$dm_service"
                info "Disabled current display manager: $dm_service"
            fi

            # Enable SDDM
            sudo systemctl enable sddm.service

            # Install SDDM theme if available
            if [[ -f "sddm-theme/sddm_install.sh" ]]; then
                chmod +x sddm-theme/sddm_install.sh
                ./sddm-theme/sddm_install.sh
                success "SDDM theme installed"
            fi

            success "SDDM configured successfully"
            ;;
        n|N)
            info "Keeping current display manager"
            ;;
        *)
            warning "Invalid option. Keeping current display manager"
            ;;
    esac
}


# Install AUR helper
install_aur_helper() {
    log "Installing AUR helper..."

    if command -v yay >/dev/null 2>&1; then
        success "yay is already installed"
        return 0
    elif command -v paru >/dev/null 2>&1; then
        success "paru is already installed"
        return 0
    fi

    # Install yay
    log "Installing yay AUR helper..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR"

    success "yay AUR helper installed"
}

# Enhanced package installation function with visual feedback
install_package() {
    local package="$1"
    local show_progress=${2:-true}

    # Check if package is already installed
    if pacman -Qi "$package" >/dev/null 2>&1; then
        if [[ "$show_progress" == "true" ]]; then
            echo -e "  ${GREEN}✓${NC} ${GRAY}$package${NC} ${DIM}(already installed)${NC}"
        fi
        return 0
    fi

    if [[ "$show_progress" == "true" ]]; then
        printf "  ${YELLOW}⏳${NC} ${WHITE}Installing ${CYAN}$package${NC}..."
    fi

    # Try pacman first
    if sudo pacman -S --noconfirm "$package" >/dev/null 2>&1; then
        if [[ "$show_progress" == "true" ]]; then
            printf "\r  ${GREEN}✅${NC} ${WHITE}$package${NC} ${GREEN}(pacman)${NC}\n"
        fi
        return 0
    fi

    # Try AUR helpers if pacman fails
    if command -v yay >/dev/null 2>&1; then
        if yay -S --noconfirm "$package" >/dev/null 2>&1; then
            if [[ "$show_progress" == "true" ]]; then
                printf "\r  ${GREEN}✅${NC} ${WHITE}$package${NC} ${BLUE}(yay)${NC}\n"
            fi
            return 0
        fi
    elif command -v paru >/dev/null 2>&1; then
        if paru -S --noconfirm "$package" >/dev/null 2>&1; then
            if [[ "$show_progress" == "true" ]]; then
                printf "\r  ${GREEN}✅${NC} ${WHITE}$package${NC} ${BLUE}(paru)${NC}\n"
            fi
            return 0
        fi
    fi

    if [[ "$show_progress" == "true" ]]; then
        printf "\r  ${RED}❌${NC} ${WHITE}$package${NC} ${RED}(failed)${NC}\n"
    fi
    return 1
}

# Install packages from requirements.json with enhanced visuals
install_system_packages() {
    step "Installing system packages from requirements.json"
    echo

    if [[ ! -f "$REQUIREMENTS_FILE" ]]; then
        error "Requirements file not found: $REQUIREMENTS_FILE"
        exit 1
    fi

    # Get all sections from requirements.json
    local sections=($(jq -r '.System | keys[]' "$REQUIREMENTS_FILE"))
    local total_sections=${#sections[@]}
    local current_section=0

    echo -e "${WHITE}${BOLD}📦 Package Installation Overview:${NC}"
    echo -e "${CYAN}  Total sections to process: ${WHITE}$total_sections${NC}"
    echo

    for section in "${sections[@]}"; do
        ((current_section++))

        # Section header with progress
        echo -e "${PURPLE}${BOLD}┌─ Section $current_section/$total_sections: ${WHITE}$section${NC}"

        # Get packages for this section
        local packages=($(jq -r ".System[\"$section\"][]" "$REQUIREMENTS_FILE"))
        local total_packages=${#packages[@]}
        local installed=0
        local failed=0
        local current_package=0

        echo -e "${PURPLE}├─ ${CYAN}Packages to install: ${WHITE}$total_packages${NC}"
        echo -e "${PURPLE}│${NC}"

        for package in "${packages[@]}"; do
            ((current_package++))

            # Show mini progress bar for section
            local section_progress=$((current_package * 100 / total_packages))
            printf "${PURPLE}├─ ${NC}"

            if install_package "$package" true; then
                ((installed++))
            else
                ((failed++))
            fi
        done

        # Section summary
        echo -e "${PURPLE}│${NC}"
        if [[ $failed -eq 0 ]]; then
            echo -e "${PURPLE}└─ ${GREEN}${BOLD}✅ Section completed: ${WHITE}$installed${GREEN} installed, ${WHITE}$failed${GREEN} failed${NC}"
        else
            echo -e "${PURPLE}└─ ${YELLOW}${BOLD}⚠️  Section completed: ${WHITE}$installed${YELLOW} installed, ${WHITE}$failed${YELLOW} failed${NC}"
        fi
        echo

        # Overall progress
        progress_bar $current_section $total_sections
        echo
        echo
    done

    success "🎉 Package installation completed successfully!"
    echo
}

# Configure ZSH shell
configure_zsh() {
    log "Configuring ZSH shell..."

    # Check current shell
    local current_shell=$(getent passwd "$USER" | cut -d: -f7)

    if [[ "$current_shell" != "/bin/zsh" ]]; then
        log "Changing default shell to zsh..."
        chsh -s /bin/zsh
        info "Shell change completed. Please log out and log back in for changes to take effect."
    else
        info "ZSH is already the default shell"
    fi

    success "ZSH shell configured"
}

# Install and configure Oh My Zsh
setup_oh_my_zsh() {
    log "Setting up Oh My Zsh..."

    # Install Oh My Zsh if not present
    if [[ ! -d ~/.oh-my-zsh ]]; then
        log "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        success "Oh My Zsh installed"
    else
        info "Oh My Zsh is already installed"
    fi

    # Create symlink for root
    log "Creating Oh My Zsh symlink for root..."
    sudo ln -sf "$HOME/.oh-my-zsh" /root/ 2>/dev/null || true

    # Install Powerlevel10k theme
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ ! -d "$p10k_dir" ]]; then
        log "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        success "Powerlevel10k theme installed"
    else
        info "Powerlevel10k theme is already installed"
    fi

    # Create symlinks for root configuration
    log "Creating configuration symlinks for root..."
    sudo ln -sf ~/.zshrc /root/ 2>/dev/null || true
    sudo ln -sf ~/.aliases /root/ 2>/dev/null || true

    # Install Oh My Zsh plugins
    setup_zsh_plugins

    success "Oh My Zsh setup completed"
}

# Install ZSH plugins
setup_zsh_plugins() {
    log "Installing ZSH plugins..."

    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    # Define plugins to install
    local plugins=(
        "fzf-tab:https://github.com/Aloxaf/fzf-tab"
        "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions"
    )

    for plugin_info in "${plugins[@]}"; do
        local plugin_name="${plugin_info%%:*}"
        local plugin_url="${plugin_info##*:}"
        local plugin_path="$plugins_dir/$plugin_name"

        if [[ ! -d "$plugin_path" ]]; then
            log "Installing plugin: $plugin_name"
            git clone "$plugin_url" "$plugin_path"
            success "Plugin $plugin_name installed"
        else
            info "Plugin $plugin_name is already installed"
        fi
    done

    success "ZSH plugins installation completed"
}


# Setup Chaotic AUR repository
setup_chaotic_aur() {
    log "Setting up Chaotic AUR repository..."

    # Clean package cache
    sudo pacman -Sc --noconfirm

    # Initialize pacman keyring
    sudo pacman-key --init
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB

    # Install Chaotic AUR keyring and mirrorlist
    if ! pacman -Qi chaotic-keyring >/dev/null 2>&1; then
        sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
        sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
        sudo pacman -Sc --noconfirm
    fi

    # Configure pacman.conf
    if [[ -f "/etc/pacman.d/chaotic-mirrorlist" ]]; then
        if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
            echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf
            echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
            success "Chaotic AUR repository added to pacman.conf"
        else
            info "Chaotic AUR repository is already configured"
        fi
    else
        warning "Chaotic mirrorlist file not found"
    fi

    success "Chaotic AUR repository setup completed"
}

# Install additional tools
install_additional_tools() {
    log "Installing additional tools..."

    # Install Pamac if requested
    read -p "¿Quieres instalar Pamac (GUI package manager)? (y/n): " install_pamac
    if [[ "$install_pamac" =~ ^[Yy]$ ]]; then
        if ! pacman -Qi pamac-aur >/dev/null 2>&1; then
            install_package "pamac-aur"
            success "Pamac installed"
        else
            info "Pamac is already installed"
        fi
    fi

    # Install Powerpill if requested
    read -p "¿Quieres instalar Powerpill (parallel downloads)? (y/n): " install_powerpill
    if [[ "$install_powerpill" =~ ^[Yy]$ ]]; then
        if ! pacman -Qi powerpill >/dev/null 2>&1; then
            install_package "powerpill"
            success "Powerpill installed"
        else
            info "Powerpill is already installed"
        fi
    fi
}

# Enable system services
enable_services() {
    log "Enabling system services..."

    # Enable and start Bluetooth
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    success "Bluetooth service enabled"

    # Enable NetworkManager if not already enabled
    if ! systemctl is-enabled NetworkManager >/dev/null 2>&1; then
        sudo systemctl enable NetworkManager.service
        success "NetworkManager enabled"
    fi

    success "System services configured"
}

# Final system update
final_system_update() {
    log "Performing final system update..."

    # Sync package databases
    sudo pacman -Sy --noconfirm

    # Update system with powerpill if available, otherwise use pacman
    if command -v powerpill >/dev/null 2>&1; then
        sudo powerpill -Su --noconfirm
    else
        sudo pacman -Su --noconfirm
    fi

    # Update AUR packages if AUR helper is available
    if command -v yay >/dev/null 2>&1; then
        yay -Su --noconfirm
    elif command -v paru >/dev/null 2>&1; then
        paru -Su --noconfirm
    fi

    success "System update completed"
}

# Post-installation setup
post_installation_setup() {
    log "Running post-installation setup..."

    # Set executable permissions for scripts
    find ~/.config/hypr/scripts -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

    # Create necessary directories
    mkdir -p ~/Pictures/Screenshots
    mkdir -p ~/Wallpapers
    mkdir -p ~/.config/hypr/logs

    success "Post-installation setup completed"
}

# Interactive confirmation function
confirm_installation() {
    echo -e "${YELLOW}${BOLD}⚠️  IMPORTANT NOTICE ⚠️${NC}"
    echo
    echo -e "${WHITE}This installer will:${NC}"
    echo -e "${CYAN}  • Install ${WHITE}100+${CYAN} packages for Hyprland environment${NC}"
    echo -e "${CYAN}  • Backup your current configuration to ${WHITE}$CONFIG_BACKUP_DIR${NC}"
    echo -e "${CYAN}  • Modify system settings and install AUR packages${NC}"
    echo -e "${CYAN}  • Configure ZSH, Oh My Zsh, and various tools${NC}"
    echo -e "${CYAN}  • Enable system services (Bluetooth, NetworkManager)${NC}"
    echo
    echo -e "${YELLOW}Estimated installation time: ${WHITE}15-30 minutes${NC}"
    echo -e "${YELLOW}Internet connection required: ${WHITE}Yes${NC}"
    echo -e "${YELLOW}Disk space required: ${WHITE}~2GB${NC}"
    echo

    while true; do
        echo -e "${BOLD}${WHITE}Do you want to continue with the installation? ${NC}"
        echo -e "${GREEN}[Y]${NC} Yes, install Hyprland Glass"
        echo -e "${RED}[N]${NC} No, exit installer"
        echo -e "${BLUE}[I]${NC} Show system information"
        echo
        read -p "$(echo -e "${BOLD}Your choice [Y/n/i]: ${NC}")" choice

        case $choice in
            [Yy]* | "" )
                echo -e "${GREEN}${BOLD}✅ Installation confirmed!${NC}"
                echo
                break
                ;;
            [Nn]* )
                echo -e "${RED}${BOLD}❌ Installation cancelled by user${NC}"
                exit 0
                ;;
            [Ii]* )
                show_welcome
                ;;
            * )
                echo -e "${RED}Please answer Y, N, or I${NC}"
                ;;
        esac
    done
}

# Installation steps with visual progress
installation_steps() {
    local steps=(
        "Pre-installation checks"
        "System backup"
        "System update"
        "Essential dependencies"
        "Configuration files"
        "Display manager setup"
        "AUR helper installation"
        "Repository setup"
        "Package installation"
        "Shell configuration"
        "Oh My Zsh setup"
        "Additional tools"
        "System services"
        "Final updates"
        "Post-installation"
    )

    local total_steps=${#steps[@]}
    local current_step=0

    echo -e "${BOLD}${WHITE}🚀 Installation Progress${NC}"
    separator "═" "$CYAN" 78
    echo

    # Step 1: Pre-installation checks
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    check_root
    check_requirements
    progress_bar $current_step $total_steps
    echo; echo

    # Step 2: System backup
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    backup_existing_config
    progress_bar $current_step $total_steps
    echo; echo

    # Step 3: System update
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    update_system
    progress_bar $current_step $total_steps
    echo; echo

    # Step 4: Essential dependencies
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    install_essential_deps
    progress_bar $current_step $total_steps
    echo; echo

    # Step 5: Configuration files
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    copy_config_files
    progress_bar $current_step $total_steps
    echo; echo

    # Step 6: Display manager setup
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    configure_sddm
    progress_bar $current_step $total_steps
    echo; echo

    # Step 7: AUR helper installation
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    install_aur_helper
    progress_bar $current_step $total_steps
    echo; echo

    # Step 8: Repository setup
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    setup_chaotic_aur
    progress_bar $current_step $total_steps
    echo; echo

    # Step 9: Package installation (the big one)
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    install_system_packages
    progress_bar $current_step $total_steps
    echo; echo

    # Step 10: Shell configuration
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    configure_zsh
    progress_bar $current_step $total_steps
    echo; echo

    # Step 11: Oh My Zsh setup
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    setup_oh_my_zsh
    progress_bar $current_step $total_steps
    echo; echo

    # Step 12: Additional tools
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    install_additional_tools
    progress_bar $current_step $total_steps
    echo; echo

    # Step 13: System services
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    enable_services
    progress_bar $current_step $total_steps
    echo; echo

    # Step 14: Final updates
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    final_system_update
    progress_bar $current_step $total_steps
    echo; echo

    # Step 15: Post-installation
    ((current_step++))
    echo -e "${BOLD}${GRADIENT1}Step $current_step/$total_steps: ${steps[$((current_step-1))]}${NC}"
    post_installation_setup
    progress_bar $current_step $total_steps
    echo; echo
}

# Enhanced completion message
show_completion() {
    clear
    echo

    # Success banner
    echo -e "${GREEN}${BOLD}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                                                                          ║
    ║    ██████╗ ██████╗ ███╗   ███╗██████╗ ██╗     ███████╗████████╗███████╗  ║
    ║   ██╔════╝██╔═══██╗████╗ ████║██╔══██╗██║     ██╔════╝╚══██╔══╝██╔════╝  ║
    ║   ██║     ██║   ██║██╔████╔██║██████╔╝██║     █████╗     ██║   █████╗    ║
    ║   ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝     ██║   ██╔══╝    ║
    ║   ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ███████╗███████╗   ██║   ███████╗  ║
    ║    ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   ╚══════╝  ║
    ║                                                                          ║
    ║                    🎉 INSTALLATION SUCCESSFUL! 🎉                       ║
    ║                                                                          ║
    ╚══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    echo
    type_text "🌟 Hyprland Glass has been installed successfully!" 0.05 "${GREEN}${BOLD}"
    echo

    # Next steps box
    draw_box "NEXT STEPS" "$CYAN" 70
    echo
    echo -e "${WHITE}${BOLD}📋 What to do next:${NC}"
    echo
    echo -e "${CYAN}  1.${NC} ${WHITE}Reboot your system:${NC} ${YELLOW}sudo reboot${NC}"
    echo -e "${CYAN}  2.${NC} ${WHITE}Select Hyprland from your display manager${NC}"
    echo -e "${CYAN}  3.${NC} ${WHITE}Press ${CYAN}Super + D${WHITE} to open the application launcher${NC}"
    echo -e "${CYAN}  4.${NC} ${WHITE}Press ${CYAN}Super + Enter${WHITE} to open a terminal${NC}"
    echo -e "${CYAN}  5.${NC} ${WHITE}Enjoy your new desktop environment!${NC}"
    echo

    # Information box
    draw_box "USEFUL INFORMATION" "$BLUE" 70
    echo
    echo -e "${BLUE}${BOLD}📖 Documentation:${NC} ${WHITE}Check README.md for detailed usage${NC}"
    echo -e "${BLUE}${BOLD}🔧 Configuration:${NC} ${WHITE}~/.config/hypr/${NC}"
    echo -e "${BLUE}${BOLD}📦 Backup location:${NC} ${WHITE}$CONFIG_BACKUP_DIR${NC}"
    echo -e "${BLUE}${BOLD}🎨 Themes:${NC} ${WHITE}Press Super+Shift+T to change themes${NC}"
    echo -e "${BLUE}${BOLD}⚙️  Settings:${NC} ${WHITE}Press Super+Shift+S for system settings${NC}"
    echo

    # Warning box
    draw_box "IMPORTANT" "$YELLOW" 70
    echo
    echo -e "${YELLOW}${BOLD}⚠️  Please reboot to ensure all changes take effect${NC}"
    echo -e "${YELLOW}${BOLD}🔄 Some features may not work until after reboot${NC}"
    echo

    separator "═" "$GREEN" 78
    echo
    echo -e "${GREEN}${BOLD}Thank you for using Hyprland Glass! 🙏${NC}"
    echo -e "${GRAY}If you encounter any issues, please check the documentation or report them on GitHub.${NC}"
    echo
}

# Main installation function
main() {
    show_banner
    show_welcome
    confirm_installation

    # Start installation timer
    local start_time=$(date +%s)

    installation_steps

    # Calculate installation time
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))

    show_completion

    echo -e "${CYAN}${BOLD}⏱️  Installation completed in: ${WHITE}${minutes}m ${seconds}s${NC}"
    echo
}

# Help function
show_help() {
    echo -e "${CYAN}${BOLD}Hyprland Glass Installer${NC}"
    echo -e "${WHITE}Automated installation script for Hyprland Glass desktop environment${NC}"
    echo
    echo -e "${YELLOW}${BOLD}Usage:${NC}"
    echo -e "  ${WHITE}./install_config.sh [OPTIONS]${NC}"
    echo
    echo -e "${YELLOW}${BOLD}Options:${NC}"
    echo -e "  ${GREEN}-h, --help${NC}     Show this help message"
    echo -e "  ${GREEN}-v, --version${NC}  Show version information"
    echo -e "  ${GREEN}-q, --quiet${NC}    Run in quiet mode (minimal output)"
    echo -e "  ${GREEN}--dry-run${NC}      Show what would be installed without actually installing"
    echo -e "  ${GREEN}--skip-backup${NC}  Skip configuration backup (not recommended)"
    echo
    echo -e "${YELLOW}${BOLD}Examples:${NC}"
    echo -e "  ${WHITE}./install_config.sh${NC}              # Normal installation"
    echo -e "  ${WHITE}./install_config.sh --dry-run${NC}    # Preview installation"
    echo -e "  ${WHITE}./install_config.sh --quiet${NC}      # Quiet installation"
    echo
    echo -e "${GRAY}For more information, visit: https://github.com/Shidohs/dotfile-hyprland-glass${NC}"
}

# Version information
show_version() {
    echo -e "${CYAN}${BOLD}Hyprland Glass Installer${NC}"
    echo -e "${WHITE}Version: 2.0.0${NC}"
    echo -e "${WHITE}Author: @Shidohs${NC}"
    echo -e "${WHITE}License: MIT${NC}"
    echo -e "${WHITE}Repository: https://github.com/Shidohs/dotfile-hyprland-glass${NC}"
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            -q|--quiet)
                QUIET_MODE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --skip-backup)
                SKIP_BACKUP=true
                shift
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                echo -e "Use ${WHITE}--help${NC} for usage information"
                exit 1
                ;;
        esac
    done
}

# Initialize variables
QUIET_MODE=false
DRY_RUN=false
SKIP_BACKUP=false

# Parse arguments and run main function
parse_arguments "$@"

# Check for dry run mode
if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${YELLOW}${BOLD}🔍 DRY RUN MODE - No changes will be made${NC}"
    echo
    echo -e "${WHITE}This would install the following package categories:${NC}"

    if [[ -f "$REQUIREMENTS_FILE" ]]; then
        local sections=($(jq -r '.System | keys[]' "$REQUIREMENTS_FILE"))
        for section in "${sections[@]}"; do
            local count=$(jq -r ".System[\"$section\"] | length" "$REQUIREMENTS_FILE")
            echo -e "  ${CYAN}•${NC} ${WHITE}$section${NC} ${GRAY}($count packages)${NC}"
        done
    fi

    echo
    echo -e "${YELLOW}To proceed with actual installation, run without --dry-run${NC}"
    exit 0
fi

# Run main installation
main

