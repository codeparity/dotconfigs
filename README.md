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

---

## Keyboard layering

Key handling spans several layers. Only some of them travel to a new machine,
so each concern is assigned to exactly one layer, picked by how portable that
layer is:

| Concern | Owned by | Portable across |
| --- | --- | --- |
| physical → logical remap (hjkl→arrows, capslock/esc swap) | `keyd/default.conf` | X, Wayland, TTY, any DE, any distro |
| neutralising stray key codes | `keyd/default.conf` | same |
| launching programs (screenshot, terminal, suspend) | DE keybindings (dconf) | DE-specific — re-created per environment |
| app-specific keys | `kitty/`, `nvim/`, `tmux.conf` | fully portable |

**Never let two layers own the same key.** A mapping defined in both `keyd` and
`~/.Xmodmap` does not raise an error — it surfaces as intermittent phantom
keypresses, which is a genuinely unpleasant thing to debug. `setup.sh` warns if
a leftover `~/.Xmodmap` duplicates keyd's `[meta]` layer.

**Never bind a bare, unmodified key to a global shortcut.** Distinct key codes
can resolve to the same keysym, so a bare binding may be triggered by input you
did not deliberately produce. Always require a modifier.

### The `print = noop` line

Two different key codes both resolve to the `Print` keysym in X:

| Key code | Source |
| --- | --- |
| `KEY_SYSRQ` (evdev 99 → X 107) | the physical PrtSc key |
| `KEY_PRINT` (evdev 210 → X 218) | a media/consumer-control input path |

Many keyboards present several input interfaces, and a media-oriented one may
advertise `KEY_PRINT` even though no obvious key is labelled for it. Because X
collapses both codes onto the same keysym, a global grab on a bare `Print` will
fire from either — so a screenshot tool bound to bare `Print` can appear to
launch itself at random.

`print = noop` in `[main]` swallows the media path only. `sysrq` is deliberately
left unmapped, so the physical PrtSc key still works as the screenshot hotkey.

Note that interfaces belonging to one device often share a single
vendor:product ID, so keyd's `[ids]` cannot always separate them — which is why
this is fixed per-key in `[main]` rather than by device scoping.

To confirm what a key actually emits:

```bash
sudo keyd monitor          # what keyd sees and emits, live
xev -event keyboard        # what X finally receives
```

### Safety

`keyd` runs as root and intercepts every keystroke, so `setup.sh` runs
`keyd check` and refuses to install a config that fails to parse. Keep a second
input method (an on-screen keyboard, or SSH from another machine) available when
editing this config. Recover a stuck layer with `meta+capslock` or `keyd reload`.

Program *launching* stays in the DE rather than keyd's `command()`, because keyd
executes commands as root with no `$DISPLAY` — wrong for GUI apps.
