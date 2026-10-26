# 🧠 Doom Emacs — Unified Literate Configuration Layer

> Unified literate configuration layer for **Doom Emacs** providing Org Mode documentation, interactive concept mapping, mind mapping, web resource linking, vector SVG diagram composition (Mermaid & Graphviz), and AI agent integration (Codex & AGY).
>
> Source: `~/projects/dotconfigs/emacs/`  
> Target Symlink: `~/.config/doom/custom`  
> Base Docs: `~/projects/thoths/docs/`

---

## 📁 Architecture & Literate Auto-Tangle

All customizations are authored in a single master literate document: [`config.org`](config.org).
Saving [`config.org`](config.org) (`SPC f s`) automatically tangles and generates both `config.el` and `packages.el`:

```text
projects/dotconfigs/emacs/                      ~/.config/doom/
├── README.md                                   ├── config.el   (loads custom/config.el)
├── config.org  (Master Literate Source)        └── packages.el (loads custom/packages.el)
│     │                                                 ▲
│     ├──[tangle on save]──► config.el   ───────────────┤
│     └──[tangle on save]──► packages.el ───────────────┘
└── custom/ (symlinked to projects/dotconfigs/emacs)
```

---

## 🧭 Navigation & Core Keybindings

Ergonomic split window, buffer, and file navigation:

### Files & Explorer Tree
| Keybinding | Scope | Action | Description |
|:---|:---|:---|:---|
| `<leader> f s` | Global | Save File | Save current buffer / file to disk (auto-tangles Org files) |
| `<leader> f e` | Global | Treemacs Toggle | Open / toggle project file tree drawer (`+treemacs/toggle`) |

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

## 🤖 AI Agent Terminal Integration

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
* **Terminal Mode**: Configured with `(evil-set-initial-state 'term-mode 'emacs)` so typed characters pass directly to the agent CLI without Vim mode interception.

---

## 🎨 Org Babel & SVG Composition

Execute diagrams inside Org mode code blocks with `C-c C-c` to generate SVG files and display them inline immediately.

### 1. Mermaid Flowcharts & Diagrams
```org
#+begin_src mermaid :file diagram.svg
graph LR
    User[Client] --> Web[Nginx]
    Web --> App[Backend API]
    App --> DB[(PostgreSQL)]
#+end_src
```

### 2. Graphviz DOT Graphs
```org
#+begin_src dot :file network.svg :cmdline -Tsvg
digraph G {
    rankdir=LR;
    node [shape=box, style=rounded];
    Client -> Router -> Server;
}
#+end_src
```

### 3. Raw SVG Markup
Tangle directly to `.svg` on save:
```org
#+begin_src xml :tangle circle.svg
<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="50" r="40" fill="#38bdf8"/>
</svg>
#+end_src
[[file:circle.svg]]
```

---

## 🧠 Knowledge & Mind Mapping Modules

### 1. Org-Brain
| Key | Scope | Action | Command |
|:---|:---|:---|:---|
| `<leader>nbv` | Global | Open / Visualize Brain | `org-brain-visualize` |
| `<leader>nbg` | Global | Jump to Brain Node | `org-brain-goto` |
| `<localleader>bv` | Org Buffer | Visualize Current Buffer in Brain | `org-brain-visualize` |
| `<localleader>bc` | Org Buffer | Add Child Node | `org-brain-add-child` |
| `<localleader>bp` | Org Buffer | Add Parent Node | `org-brain-add-parent` |
| `<localleader>bf` | Org Buffer | Add Friend / Related Node | `org-brain-add-friend` |
| `<localleader>bg` | Org Buffer | Jump to Node | `org-brain-goto` |

### 2. Org-Mind-Map
| Key | Scope | Action | Command |
|:---|:---|:---|:---|
| `<localleader>mmm` | Org Buffer | Export whole tree to Graphviz Mind Map | `org-mind-map-write` |
| `<localleader>mmc` | Org Buffer | Export only current subtree to Mind Map | `org-mind-map-write-current-tree` |

### 3. Org-Cliplink
| Key | Scope | Action | Command |
|:---|:---|:---|:---|
| `<leader>nl` | Global / Org | Insert web link with fetched page title | `org-cliplink` |

---

## 🛠️ Workflow & Maintenance

1. Edit [`config.org`](config.org).
2. Save with `SPC f s`. This automatically tangles and regenerates [`config.el`](config.el) and [`packages.el`](packages.el).
3. If new packages were added to the `Packages Definition` section, run:
   ```bash
   doom sync
   ```
4. Reload Emacs configuration in the running session with `SPC h r r` (`doom/reload`), or restart Emacs.
