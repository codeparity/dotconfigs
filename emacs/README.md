# 🧠 Doom Emacs — Modular Custom Layer

> Modular personal configuration layer for **Doom Emacs** providing Org Mode documentation, interactive concept mapping, mind mapping, web resource linking, and AI agent integration (Codex & AGY).
>
> Source: `~/projects/dotconfigs/emacs/`  
> Target Symlink: `~/.config/doom/custom`  
> Base Docs: `~/projects/thoths/docs/`

---

## 📁 Architecture & Modular Org Configuration

All personal customizations are organized in modular `*.org` files. A lightweight loader automatically evaluates all `*.org` files in this directory on Emacs startup:

```text
projects/dotconfigs/emacs/              ~/.config/doom/
├── README.md                           ├── config.el (loads custom/config.el)
├── config.el (auto-loads *.org)  ───┐  └── packages.el (loads custom/packages.el)
├── packages.el                      │       ▲
├── packages.org                     │       │
├── base.org                         └── custom/ (symlink)
├── navigation.org
├── ai_agent.org
├── org-brain.org
├── org-mind-map.org
└── org-cliplink.org
```

---

## 🧭 Navigation (`navigation.org`)

Ergonomic split window and buffer navigation:

### Windows
| Keybinding | Scope | Action | Description |
|:---|:---|:---|:---|
| `M-h` / `M-j` / `M-k` / `M-l` | Normal & Insert | Directional Window | Move focus directly Left / Down / Up / Right |
| `M-w` | Normal & Insert | Cycle Window | Move focus clockwise to next window |

### Buffers
| Keybinding | Scope | Action | Description |
|:---|:---|:---|:---|
| `<leader> TAB` | Global | Toggle Last Buffer | Instant switch back and forth between recent two buffers |
| `H` / `L` | Normal | Prev / Next Buffer | Step backward (`H`) or forward (`L`) through buffer history |
| `M-p` / `M-n` | Normal & Insert | Prev / Next Buffer | Step backward (`M-p`) or forward (`M-n`) through buffers without leaving insert mode |

---

## 🤖 AI Agent Integration (`ai_agent.org`)

Quick, project-rooted terminal launcher for **AGY** (Antigravity CLI) and **Codex** with session memory:

| Keybinding | Scope | Action | Description |
|:---|:---|:---|:---|
| `<leader> a` | Global | Launch AI Agent | Opens terminal with last-used agent (defaults to `agy`) |
| `<leader> n a` | Global / Notes | Launch AI Agent | Same as `<leader> a` |
| `<leader> n A` | Global / Notes | Switch Agent | Prompt to select between `agy` and `codex`, sets as last-used, and launches |
| `<leader> n c` | Global / Notes | Codex CLI | Launches Codex directly (rooted at project) |
| `<leader> n g` | Global / Notes | AGY CLI | Launches AGY directly (rooted at project) |

* **Memory**: The active agent is remembered across calls (`my/last-ai-agent`). Use `C-u <leader> a` or `<leader> n A` to switch agents.
* **Auto-Revert**: Automatically refreshes clean file buffers when external agents modify them on disk.

---

## 🗂️ Documentation Base (`base.org`)

* **Documentation Root**: `~/projects/thoths/docs/` (`org-directory`)
* **Org-Brain Path**: `~/projects/thoths/docs/brain/` (`org-brain-path`)
* **Portfolio agenda**: `~/projects/thoths/docs/projects/PROJECTS.org`

---

## 🧠 Knowledge & Mind Mapping Modules

### 1. Org-Brain (`org-brain.org`)
| Key | Scope | Action | Command |
|:---|:---|:---|:---|
| `<leader>nbv` | Global | Open / Visualize Brain | `org-brain-visualize` |
| `<leader>nbg` | Global | Jump to Brain Node | `org-brain-goto` |
| `<localleader>bv` | Org Buffer | Visualize Current Buffer in Brain | `org-brain-visualize` |
| `<localleader>bc` | Org Buffer | Add Child Node | `org-brain-add-child` |
| `<localleader>bp` | Org Buffer | Add Parent Node | `org-brain-add-parent` |
| `<localleader>bf` | Org Buffer | Add Friend / Related Node | `org-brain-add-friend` |
| `<localleader>bg` | Org Buffer | Jump to Node | `org-brain-goto` |

### 2. Org-Mind-Map (`org-mind-map.org`)
| Key | Scope | Action | Command |
|:---|:---|:---|:---|
| `<localleader>mmm` | Org Buffer | Export whole tree to Graphviz Mind Map | `org-mind-map-write` |
| `<localleader>mmc` | Org Buffer | Export only current subtree to Mind Map | `org-mind-map-write-current-tree` |

### 3. Org-Cliplink (`org-cliplink.org`)
| Key | Scope | Action | Command |
|:---|:---|:---|:---|
| `<leader>nl` | Global / Org | Insert web link with fetched page title | `org-cliplink` |
