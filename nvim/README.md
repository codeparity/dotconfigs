# 💤 LazyVim — Personal Keybinds Cheat-Sheet

> Custom keymaps on top of [LazyVim defaults](https://www.lazyvim.org/keymaps).
> `<leader>` = `Space` by default.

---

## General

| Key | Mode | Action |
|-----|------|--------|
| `jk` | Insert | Escape to Normal mode |
| `<Esc>` | Normal | Clear search highlight (`:noh`) |
| `fs` | Normal | Save file (`:w`) |
| `<Tab>` | Insert | Jump over closing bracket/quote/backtick (falls back to normal tab) |

---

## Insert-Mode Cursor Movement

| Key | Action |
|-----|--------|
| `Ctrl+H` | Move left |
| `Ctrl+J` | Move down |
| `Ctrl+K` | Move up |
| `Ctrl+L` | Move right |

---

## Code Running (`<leader>r` group)

| Key | Action | Plugin |
|-----|--------|--------|
| `<leader>rr` | Run Code | code_runner.nvim |
| `<leader>rf` | Run File | code_runner.nvim |
| `<leader>rft` | Run File in new tab | code_runner.nvim |
| `<leader>rp` | Run Project | code_runner.nvim |
| `<leader>rc` | Close runner | code_runner.nvim |

---

## AI / CodeCompanion (`<leader>a` group)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ac` | Normal / Visual | Toggle AI Chat sidebar |
| `<leader>ai` | Normal / Visual | Inline assistance / refactor |
| `<leader>aa` | Normal / Visual | Open action menu (Explain, Fix, Optimize…) |
| `<leader>at` | Normal / Visual | Toggle AI Terminal (agy) |
| `<leader>ag` | Normal | Open AGY terminal (auto-keymap) |

---

## Symbols / Emoji Picker 🎉

| Key | Mode | Action | Plugin |
|-----|------|--------|--------|
| `Ctrl+S` | Normal | Find Symbols / Emoji | telescope-symbols.nvim |
| `Ctrl+S` | Insert | Insert Symbol / Emoji | telescope-symbols.nvim |

---

## Terminal (ToggleTerm)

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl+\` | Normal / Insert / Terminal | Toggle terminal |
| `<Esc>` | Terminal | Exit terminal mode |
| `jk` | Terminal | Exit terminal mode |
| `Ctrl+H/J/K/L` | Terminal | Navigate to window left/down/up/right |

---

## Windows (`<leader>w` group)

### Quick Actions

| Key | Action |
|-----|--------|
| `<leader>wW` | Sticky Window Mode (Hydra — hold & repeat `Ctrl+W` keys) |
| `<leader>wz` | Zoom / maximize toggle |

### Width Presets (`<leader>w=`)

| Key | Action |
|-----|--------|
| `<leader>w=2` | 25% width |
| `<leader>w=3` | 33% width |
| `<leader>w=5` | 50% width |
| `<leader>w=7` | 75% width |
| `<leader>w=+` | Increase width (+10) |
| `<leader>w=-` | Decrease width (-10) |
| `<leader>w==` | Equalize all windows |

### Height Presets (`<leader>wv`)

| Key | Action |
|-----|--------|
| `<leader>wv2` | 25% height |
| `<leader>wv3` | 33% height |
| `<leader>wv5` | 50% height |
| `<leader>wv7` | 75% height |
| `<leader>wv+` | Increase height (+5) |
| `<leader>wv-` | Decrease height (-5) |

### Move Windows (`<leader>wm`)

| Key | Action |
|-----|--------|
| `<leader>wmh` | Move window far left |
| `<leader>wmj` | Move window far down |
| `<leader>wmk` | Move window far up |
| `<leader>wml` | Move window far right |
| `<leader>wms` | Swap window with next |

---

## Tabs (`<leader><Tab>`)

| Key | Action |
|-----|--------|
| `<leader><Tab><Tab>` | Switch to next tab |
| `<leader><Tab>n` | New tab |

---

## DAP (Debugger) — buffer-local inside DAP UI panels

| Key | Action |
|-----|--------|
| `c` | Continue |
| `n` | Step Over (Next) |
| `i` | Step Into |
| `o` | Step Out |
| `b` | Toggle Breakpoint |
| `q` | Close DAP UI |

---

## Tagbar

| Key | Action |
|-----|--------|
| `<leader>T` | Toggle Tagbar |

---

## Completion (blink.cmp)

Uses **super-tab** preset — `Tab` / `Shift+Tab` to cycle and accept completions.

---

## Installed Plugins (quick reference)

| Plugin | Purpose |
|--------|---------|
| gruvbox.nvim | Colorscheme |
| lualine.nvim | Statusline (clock section removed) |
| which-key.nvim | Keybind popup hints |
| toggleterm.nvim | Terminal inside nvim |
| ai-terminals.nvim | AGY AI terminal |
| code_runner.nvim | Run code/files/projects |
| telescope-symbols.nvim | Emoji & symbol picker |
| blink.cmp | Completion engine (super-tab) |
| compiler.nvim + overseer.nvim | Compiler / task runner |
| tagbar | Code structure sidebar |
| sniprun | Run code snippets |
| render-markdown.nvim | Rendered markdown preview |
| live-preview.nvim | Live HTML/MD preview |
| screenkey.nvim | Show pressed keys on screen |
| noice.nvim | *(disabled)* |
| window-picker | Pick windows visually |
