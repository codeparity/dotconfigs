#!/usr/bin/env bash

# Exit on error, undefined variables, or pipe failures
set -euo pipefail

# Color Codes for Pretty Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Banner
print_banner() {
    echo -e "${BLUE}${BOLD}==================================================${NC}"
    echo -e "${CYAN}${BOLD}           Codeparity Dotconfigs Installer        ${NC}"
    echo -e "${BLUE}${BOLD}==================================================${NC}"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the absolute path of this script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Ensure ~/.config exists
mkdir -p "$HOME/.config"

# Helper to check if a command is installed
check_dependency() {
    local cmd=$1
    if command -v "$cmd" &>/dev/null; then
        echo -e "  - $cmd: ${GREEN}Installed${NC}"
        return 0
    else
        echo -e "  - $cmd: ${YELLOW}Not Installed${NC} (Config will still be linked)"
        return 1
    fi
}

# Helper to link a file/folder with backup
link_config() {
    local source=$1
    local target=$2
    
    # If the target exists
    if [ -e "$target" ] || [ -L "$target" ]; then
        # If it's already a symlink pointing to the correct source
        if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$source")" ]; then
            log_success "Already linked: $target -> $source"
            return 0
        fi
        
        # Backup existing target
        local timestamp
        timestamp=$(date +%Y%m%d_%H%M%S)
        local backup="${target}.bak.${timestamp}"
        log_warning "Backup existing configuration: $target -> $backup"
        mv "$target" "$backup"
    fi
    
    # Create parent directory of target if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Create the symlink
    ln -s "$source" "$target"
    log_success "Linked: $target -> $source"
}

# Check system dependencies
print_dependencies() {
    echo -e "\n${BOLD}Checking System Dependencies:${NC}"
    check_dependency "bash"
    check_dependency "kitty"
    check_dependency "nvim"
    check_dependency "tmux"
    check_dependency "keyd"
    echo ""
}

# Main installation flow
main() {
    print_banner
    print_dependencies
    
    # 1. Setup Bash
    echo -e "${BOLD}1. Setting up Bash Configuration...${NC}"
    if [ -f "$SCRIPT_DIR/.bashrc" ]; then
        link_config "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
    else
        log_error "Could not find .bashrc in $SCRIPT_DIR"
    fi
    echo ""

    # 2. Setup Kitty
    echo -e "${BOLD}2. Setting up Kitty Configuration...${NC}"
    if [ -d "$SCRIPT_DIR/kitty" ]; then
        link_config "$SCRIPT_DIR/kitty" "$HOME/.config/kitty"
    else
        log_error "Could not find kitty folder in $SCRIPT_DIR"
    fi
    echo ""

    # 3. Setup Neovim
    echo -e "${BOLD}3. Setting up Neovim Configuration...${NC}"
    if [ -d "$SCRIPT_DIR/nvim" ]; then
        link_config "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
    else
        log_error "Could not find nvim folder in $SCRIPT_DIR"
    fi
    echo ""

    # 4. Setup Tmux
    echo -e "${BOLD}4. Setting up Tmux Configuration...${NC}"
    # Prefer tmux.conf if present, fallback to .tmux.conf
    local tmux_src=""
    if [ -f "$SCRIPT_DIR/tmux.conf" ]; then
        tmux_src="$SCRIPT_DIR/tmux.conf"
    elif [ -f "$SCRIPT_DIR/.tmux.conf" ]; then
        tmux_src="$SCRIPT_DIR/.tmux.conf"
    fi
    
    if [ -n "$tmux_src" ]; then
        link_config "$tmux_src" "$HOME/.tmux.conf"
        
        # Install TPM (Tmux Plugin Manager) if it's not present
        local tpm_dir="$HOME/.tmux/plugins/tpm"
        if [ ! -d "$tpm_dir" ]; then
            log_info "TPM not found. Cloning Tmux Plugin Manager (TPM)..."
            git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
            log_success "TPM installed. Press 'prefix + I' inside tmux to fetch config plugins."
        else
            log_success "TPM is already installed."
        fi
    else
        log_error "Could not find tmux.conf or .tmux.conf in $SCRIPT_DIR"
    fi
    echo ""

    # 5. Setup Keyd (Keyboard Remapper)
    echo -e "${BOLD}5. Setting up Keyd Configuration...${NC}"
    if [ -f "$SCRIPT_DIR/keyd/default.conf" ]; then
        echo -e "${YELLOW}Keyd is a system-wide key remapper daemon and requires root permissions to write to /etc/keyd/default.conf.${NC}"
        read -rp "Would you like to install keyd configuration? [y/N]: " install_keyd
        if [[ "$install_keyd" =~ ^[Yy]$ ]]; then
            # Validate before writing. A malformed keyd config can leave the
            # keyboard unusable, which is awkward to recover from without one.
            if command -v keyd &>/dev/null; then
                if keyd check "$SCRIPT_DIR/keyd/default.conf" &>/dev/null; then
                    log_success "keyd config validated."
                else
                    log_error "keyd config failed validation — refusing to install it:"
                    keyd check "$SCRIPT_DIR/keyd/default.conf" || true
                    return 1
                fi
            else
                log_warning "keyd not installed; skipping config validation."
            fi

            # keyd owns physical->logical remapping. ~/.Xmodmap defining the
            # same hjkl->arrow keys would make two layers fight over one key,
            # which shows up as phantom keypresses rather than as an error.
            if [ -f "$HOME/.Xmodmap" ] && grep -qE "^keycode +(43|44|45|46) " "$HOME/.Xmodmap" 2>/dev/null; then
                log_warning "~/.Xmodmap remaps h/j/k/l, duplicating keyd's [meta] layer."
                log_warning "Consider removing it — see 'Keyboard layering' in README.md."
            fi

            log_info "Installing keyd configuration to /etc/keyd/default.conf (requires sudo)..."
            sudo mkdir -p /etc/keyd
            if [ -f "/etc/keyd/default.conf" ]; then
                local timestamp
                timestamp=$(date +%Y%m%d_%H%M%S)
                sudo cp "/etc/keyd/default.conf" "/etc/keyd/default.conf.bak.${timestamp}"
                log_warning "Backed up existing /etc/keyd/default.conf"
            fi
            sudo cp "$SCRIPT_DIR/keyd/default.conf" /etc/keyd/default.conf
            log_success "Keyd configuration copied successfully."
            
            if command -v systemctl &>/dev/null; then
                log_info "Restarting keyd systemd service..."
                sudo systemctl restart keyd || log_warning "Failed to restart keyd service. Please start/restart it manually."
            else
                log_warning "systemctl not found. Please restart keyd service manually."
            fi
        else
            log_info "Skipping keyd installation."
        fi
    else
        log_error "Could not find keyd/default.conf in $SCRIPT_DIR"
    fi
    echo ""

    echo -e "${GREEN}${BOLD}Setup completed successfully! Please restart your terminal/shell.${NC}"
}

main "$@"
