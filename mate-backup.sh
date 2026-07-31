#!/usr/bin/env bash

# Exit on error, undefined variables, or pipe failures
set -euo pipefail

# Color Codes for Pretty Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Helper logging functions
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
BACKUP_FILE="$SCRIPT_DIR/mate-customizations.dconf"

print_usage() {
    echo -e "${BOLD}MATE Desktop Customizations Backup Utility${NC}"
    echo "This utility backs up and restores MATE desktop customizations, including keybinds and shortcuts."
    echo ""
    echo "Usage: $0 {save|restore}"
    echo "  save    - Save current MATE customizations to $BACKUP_FILE"
    echo "  restore - Restore MATE customizations from $BACKUP_FILE"
}

check_dconf() {
    if ! command -v dconf &>/dev/null; then
        log_error "dconf is not installed. Please install dconf-cli or equivalent."
        exit 1
    fi
}

save_shortcuts() {
    log_info "Saving MATE desktop customizations (keybinds, shortcuts, etc.)..."
    dconf dump /org/mate/ > "$BACKUP_FILE"
    log_success "Successfully saved MATE customizations to:"
    echo "  -> $BACKUP_FILE"
}

restore_shortcuts() {
    if [ ! -f "$BACKUP_FILE" ]; then
        log_error "Backup file not found at $BACKUP_FILE"
        exit 1
    fi
    
    log_info "Restoring MATE desktop customizations..."
    dconf load /org/mate/ < "$BACKUP_FILE"
    log_success "Successfully restored MATE customizations from:"
    echo "  -> $BACKUP_FILE"
}

main() {
    check_dconf

    if [ $# -ne 1 ]; then
        print_usage
        exit 1
    fi

    case "$1" in
        save)
            save_shortcuts
            ;;
        restore)
            restore_shortcuts
            ;;
        *)
            log_error "Invalid action: $1"
            print_usage
            exit 1
            ;;
    esac
}

main "$@"
