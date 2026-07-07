# dotconfigs

This repository contains my personal system configuration files (dotfiles), organized and managed with a simple setup script.

## Directory Structure

```text
dotconfigs/
├── artwork/           # Color palettes, graphics, and logos
├── keyd/
│   └── default.conf   # Keyd keyboard remapper configuration (capslock/escape swaps, hjkl navigation)
├── kitty/
│   ├── kitty.conf     # Kitty terminal configuration
│   └── kitty-theme.conf # Gruvbox Dark Kitty theme
├── nvim/              # Neovim (LazyVim-based) config folder
├── tmux/              # Tmux third-party submodule configurations
├── .bashrc            # Bash configuration shell settings (oh-my-bash integration)
├── tmux.conf          # Main tmux configuration file (TPM, Catppuccin, splits, vi-mode)
├── .tmux.conf         # Backup/alternative tmux configuration file
├── setup.sh           # Easy configuration linking & setup script
└── README.md          # This documentation
```

## Quick Start / Installation

To set up all the configurations on a new machine:

1. Clone this repository (with submodules if you want them):
   ```bash
   git clone --recursive https://github.com/codeparity/dotconfigs.git
   cd dotconfigs
   ```

2. Run the interactive setup script:
   ```bash
   ./setup.sh
   ```

### What `setup.sh` does:
1. **Dependency Check**: Verifies if packages like `kitty`, `nvim`, `tmux`, and `keyd` are installed.
2. **Backups**: Safely backs up any existing configuration files/folders at `~/.bashrc`, `~/.config/kitty`, `~/.config/nvim`, and `~/.tmux.conf` to `*.bak.<timestamp>` before overwriting.
3. **Symbolic Linking**: Creates symlinks from your home directory pointing to the configs in this repo directory.
4. **Tmux Plugin Manager (TPM)**: Clones and installs TPM at `~/.tmux/plugins/tpm` if it is not already installed.
5. **Keyd Setup**: Optionally copies the Keyd keyboard remapper config to `/etc/keyd/default.conf` using `sudo` and restarts the daemon.

---

## Post-Installation Notes

### Tmux Plugins
After opening tmux for the first time, load the plugins by pressing:
`Ctrl + A` (prefix) followed by `I` (capital i) to fetch and compile Catppuccin and other plugins.

### Neovim Setup
The Neovim config uses LazyVim. On first launch (`nvim`), it will automatically download and install `lazy.nvim` and all configured plugins.
