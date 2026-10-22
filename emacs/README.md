# 🧠 Doom Emacs — Custom Org & Knowledge Management Layer

> Modular personal configuration layer for **Doom Emacs** providing Org Mode documentation, interactive concept mapping, mind mapping, and web resource linking.
>
> Source: `~/projects/dotconfigs/emacs/`  
> Target Symlink: `~/.config/doom/custom`  
> Base Docs: `~/projects/docs/`

---

## 📁 Architecture & Symlinks

To keep personal customizations independent from Doom's core configuration files, this folder is softlinked into Doom's user directory:

```text
projects/dotconfigs/emacs/              ~/.config/doom/
├── README.md               <──────┐    ├── config.el   (loads custom/config.el)
├── packages.el                    └────┼── custom/     (symlink)
└── config.el                           └── packages.el (loads custom/packages.el)
```

### Automatic Setup
Run the main installer script from `~/projects/dotconfigs/`:
```bash
./setup.sh
```
Step 6 will automatically verify and link `$SCRIPT_DIR/emacs` $\rightarrow$ `~/.config/doom/custom`.

### Manual Linking (if needed)
```bash
ln -s ~/projects/dotconfigs/emacs ~/.config/doom/custom
doom sync
```

---

## 🗂️ Documentation Base

All Org-mode documents and knowledge graphs are organized under:
* **Documentation Root**: `~/projects/docs/` (`org-directory`)
* **Org-Brain Path**: `~/projects/docs/brain/` (`org-brain-path`)

---

## 🔌 Included Plugins

| Plugin | Source | Purpose |
|:---|:---|:---|
| **[org-brain](https://github.com/Kungsgeten/org-brain)** | GitHub (`:build (:not compile)`) | Concept mapping, parent/child/friend relationships, and visual node exploration |
| **[polymode](https://github.com/polymode/polymode)** | MELPA | Allows editing Org entries directly inside the `org-brain` visualizer window |
| **[org-mind-map](https://github.com/the-ted/org-mind-map)** | GitHub (`the-ted/org-mind-map`) | Exports Org outlines to visual mind map diagrams using Graphviz (`/usr/bin/dot`) |
| **[org-cliplink](https://github.com/rexim/org-cliplink)** | MELPA | Pulls titles from URLs in clipboard and inserts formatted `[[url][title]]` links |

> [!NOTE]
> `org-brain` is intentionally set to `:build (:not compile)` in `packages.el`. This prevents byte-compilation from evaluating polymode macros as void variables before polymode is loaded.

---

## ⌨️ Keybindings Cheat-Sheet

`<leader>` = `Space` | `<localleader>` = `Space m` (inside `org-mode` buffers)

### 1. Org-Brain (Concept & Knowledge Mapping)

| Key | Scope | Action | Command |
|:---|:---|:---|:---|
| `<leader>nbv` | Global | Open / Visualize Brain | `org-brain-visualize` |
| `<leader>nbg` | Global | Jump to Brain Node | `org-brain-goto` |
| `<localleader>bv` | Org Buffer | Visualize Current Buffer in Brain | `org-brain-visualize` |
| `<localleader>bc` | Org Buffer | Add Child Node | `org-brain-add-child` |
| `<localleader>bp` | Org Buffer | Add Parent Node | `org-brain-add-parent` |
| `<localleader>bf` | Org Buffer | Add Friend / Related Node | `org-brain-add-friend` |
| `<localleader>bg` | Org Buffer | Jump to Node | `org-brain-goto` |

#### Navigation inside Brain Visualize Buffer
* `j` / `k` / `h` / `l` or `Tab`: Navigate between nodes
* `Enter`: Open node at point
* `c` / `p` / `f`: Add child / parent / friend directly from visualizer
* `q`: Quit visualizer

---

### 2. Org-Mind-Map (Graphviz Diagram Exports)

| Key | Scope | Action | Command |
|:---|:---|:---|:---|
| `<localleader>mmm` | Org Buffer | Export entire tree to Graphviz Mind Map | `org-mind-map-write` |
| `<localleader>mmc` | Org Buffer | Export only current subtree to Mind Map | `org-mind-map-write-current-tree` |

* Output diagrams will be generated using `/usr/bin/dot` in the current document's directory.

---

### 3. Org-Cliplink (Web Linking)

| Key | Scope | Action | Command |
|:---|:---|:---|:---|
| `<leader>nl` | Global / Org | Insert web link from clipboard with fetched page title | `org-cliplink` |

---

## 🛠️ Maintenance & CLI Commands

After making changes to [`packages.el`](packages.el):
```bash
doom sync
```

After modifying [`config.el`](config.el):
* Changes take effect immediately upon restarting Emacs or running `M-x doom/reload`.

Run Doom health checks:
```bash
doom doctor
```
