;; [[file:config.org::*Core Environment & Auto-Tangle][Core Environment & Auto-Tangle:1]]
;;; config.el -*- lexical-binding: t; -*-

;; GUI-launched Emacs and subshells require ~/.local/bin in exec-path and PATH
(let ((local-bin (expand-file-name "~/.local/bin")))
  (when (file-directory-p local-bin)
    (add-to-list 'exec-path local-bin)
    (setenv "PATH" (concat local-bin ":" (getenv "PATH")))))

;; Automatically tangle config.org (and any Org buffer with :tangle) on save
(defun my/org-babel-tangle-on-save-h ()
  "Automatically tangle current Org buffer on save when a tangle destination is defined."
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (goto-char (point-min))
      (let ((has-tangle nil))
        (while (and (not has-tangle)
                    (re-search-forward ":tangle[ \t]+\\([^ \t\n\r]+\\)" nil t))
          (unless (string-equal (match-string 1) "no")
            (setq has-tangle t)))
        (when has-tangle
          (org-babel-tangle))))))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'my/org-babel-tangle-on-save-h nil 'local)))

;; Ensure already-open Org buffers also attach the hook
(dolist (buf (buffer-list))
  (with-current-buffer buf
    (when (derived-mode-p 'org-mode)
      (add-hook 'after-save-hook #'my/org-babel-tangle-on-save-h nil 'local))))

;; Refresh clean file buffers automatically when external processes modify them
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
;; Core Environment & Auto-Tangle:1 ends here

;; [[file:config.org::*Org Directory & Agenda Setup][Org Directory & Agenda Setup:1]]
;; Base Org documentation directory
(setq org-directory (expand-file-name "~/projects/thoths/docs/"))

(unless (file-directory-p org-directory)
  (make-directory org-directory t))

;; Project pipeline visible in Org agenda
(setq org-agenda-files
      (list (expand-file-name "projects/PROJECTS.org" org-directory)))
;; Org Directory & Agenda Setup:1 ends here

;; [[file:config.org::*Window Navigation][Window Navigation:1]]
;; Directional window switching test
(map! :n "M-h" #'evil-window-left
      :n "M-j" #'evil-window-down
      :n "M-k" #'evil-window-up
      :n "M-l" #'evil-window-right
      :i "M-h" #'evil-window-left
      :i "M-j" #'evil-window-down
      :i "M-k" #'evil-window-up
      :i "M-l" #'evil-window-right

      ;; Cycle window
      :n "M-w" #'evil-window-next
      :i "M-w" #'evil-window-next)
;; Window Navigation:1 ends here

;; [[file:config.org::*Buffer Navigation][Buffer Navigation:1]]
;; Toggle between last two buffers
(map! :leader
      :desc "Toggle last buffer" "TAB" #'evil-switch-to-windows-last-buffer)

;; Previous and Next buffer navigation
(map! :n "H" #'previous-buffer
      :n "L" #'next-buffer

      ;; Modifier-based buffer navigation (works in normal and insert mode)
      :ni "M-p" #'previous-buffer
      :ni "M-n" #'next-buffer)
;; Buffer Navigation:1 ends here

;; [[file:config.org::*Files & Project Tree Navigation][Files & Project Tree Navigation:1]]
;; File and project drawer navigation
(map! :leader
      (:prefix ("f" . "file")
       :desc "Save file"       "s" #'save-buffer
       :desc "Treemacs toggle" "e" #'+treemacs/toggle))
;; Files & Project Tree Navigation:1 ends here

;; [[file:config.org::*AI Agent Terminal Integration (Codex & AGY)][AI Agent Terminal Integration (Codex & AGY):1]]
(require 'project)
(require 'term)

;; Ensure Evil passes keyboard input directly to interactive CLI terminals
(after! evil
  (evil-set-initial-state 'term-mode 'emacs))

(defvar my/last-ai-agent "agy"
  "The last used AI agent ('agy' or 'codex').")

(defvar my/ai-agent-specs
  '(("agy"   . (:program "agy"   :args nil))
    ("codex" . (:program "codex" :args ("--sandbox" "workspace-write" "--ask-for-approval" "on-request"))))
  "Specifications and arguments for supported AI agents.")

(defun my/launch-ai-agent (agent-name)
  "Launch or switch to terminal for AGENT-NAME in current project."
  (let* ((spec (cdr (assoc agent-name my/ai-agent-specs)))
         (program-name (plist-get spec :program))
         (program-path (executable-find program-name))
         (extra-args (plist-get spec :args))
         (project (project-current nil))
         (default-directory (if project (project-root project) default-directory))
         (project-name (file-name-nondirectory
                        (directory-file-name (expand-file-name default-directory))))
         (term-name (format "%s-%s" agent-name project-name))
         (buffer (get-buffer (format "*%s*" term-name))))
    (unless program-path
      (user-error "%s CLI not found; ensure it is installed in exec-path" program-name))
    (setq my/last-ai-agent agent-name)
    (if (and buffer
             (get-buffer-process buffer)
             (process-live-p (get-buffer-process buffer)))
        (pop-to-buffer buffer)
      (when buffer
        (kill-buffer buffer))
      (let ((term-buffer
             (apply #'make-term term-name program-path nil extra-args)))
        (with-current-buffer term-buffer
          (term-mode)
          (term-char-mode))
        (pop-to-buffer term-buffer)))))

(defun my/ai-agent-select ()
  "Prompt to select and run an AI agent (agy or codex), saving choice as last used."
  (interactive)
  (let ((chosen (completing-read
                 (format "Select AI Agent (last used: %s): " my/last-ai-agent)
                 '("agy" "codex")
                 nil t nil nil my/last-ai-agent)))
    (my/launch-ai-agent chosen)))

(defun my/ai-agent (&optional choose)
  "Launch the last used AI agent. With prefix argument CHOOSE, prompt to select."
  (interactive "P")
  (if (or choose (not my/last-ai-agent))
      (my/ai-agent-select)
    (message "Launching last used agent: %s (use C-u to switch)" my/last-ai-agent)
    (my/launch-ai-agent my/last-ai-agent)))

(defun my/codex ()
  "Launch Codex directly in the current project."
  (interactive)
  (my/launch-ai-agent "codex"))

(defun my/agy ()
  "Launch Antigravity (AGY) directly in the current project."
  (interactive)
  (my/launch-ai-agent "agy"))

;; Keybindings: Top-level leader 'a' and notes prefix 'n'
(map! :leader
      :desc "AI Agent (last used)" "a" #'my/ai-agent
      (:prefix ("n" . "notes")
       :desc "AI Agent (last used)" "a" #'my/ai-agent
       :desc "Switch AI Agent"      "A" #'my/ai-agent-select
       :desc "Codex CLI"            "c" #'my/codex
       :desc "AGY CLI"              "g" #'my/agy))
;; AI Agent Terminal Integration (Codex & AGY):1 ends here

;; [[file:config.org::*Org Babel & SVG Composition][Org Babel & SVG Composition:1]]
(after! org
  ;; Ensure ~/.local/bin is in exec-path for mmdc
  (let ((local-bin (expand-file-name "~/.local/bin")))
    (when (file-directory-p local-bin)
      (add-to-list 'exec-path local-bin)))

  (setq ob-mermaid-cli-path (or (executable-find "mmdc")
                                (expand-file-name "~/.local/bin/mmdc")))

  ;; Explicitly load Babel diagram backends
  (require 'ob-dot nil t)
  (require 'ob-mermaid nil t)

  ;; Automatically refresh inline image previews after executing a Babel block
  (add-hook 'org-babel-after-execute-hook #'org-redisplay-inline-images)

  ;; Respect custom image width specifications and render crisp full-resolution SVGs
  (setq org-image-actual-width nil))
;; Org Babel & SVG Composition:1 ends here

;; [[file:config.org::*Org-Brain][Org-Brain:1]]
;; Pre-load polymode-core and define vars to prevent upstream macro void-variable issue
(load "polymode-core" t t)
(defvar org-brain-poly-hostmode nil)
(defvar org-brain-poly-innermode nil)

(use-package! org-brain
  :init
  ;; Brain files live in ~/projects/thoths/docs/brain
  (setq org-brain-path (expand-file-name "brain" org-directory))
  (unless (file-directory-p org-brain-path)
    (make-directory org-brain-path t))

  :config
  (setq org-id-track-globally t)

  ;; Evil mode compatibility for visualize window
  (evil-set-initial-state 'org-brain-visualize-mode 'emacs)

  ;; Global Leader bindings: SPC n b ...
  (map! :leader
        (:prefix ("n" . "notes")
         (:prefix ("b" . "brain")
          :desc "Brain Visualize" "v" #'org-brain-visualize
          :desc "Brain Goto Node" "g" #'org-brain-goto)))

  ;; Local Leader bindings in Org buffers: SPC m b ...
  (map! :map org-mode-map
        :localleader
        (:prefix ("b" . "brain")
         :desc "Brain Visualize" "v" #'org-brain-visualize
         :desc "Add Child Node"  "c" #'org-brain-add-child
         :desc "Add Parent Node" "p" #'org-brain-add-parent
         :desc "Add Friend Node" "f" #'org-brain-add-friend
         :desc "Goto Node"       "g" #'org-brain-goto)))

;; Polymode helper
(use-package! polymode
  :after org-brain
  :config
  (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))
;; Org-Brain:1 ends here

;; [[file:config.org::*Org-Mind-Map][Org-Mind-Map:1]]
(use-package! org-mind-map
  :after (org ox)
  :init
  (require 'ox)
  (setq org-mind-map-engine "dot") ; Uses system /usr/bin/dot
  :config
  (map! :map org-mode-map
        :localleader
        (:prefix ("m" . "mind-map")
         :desc "Export whole tree to mind map"    "m" #'org-mind-map-write
         :desc "Export current node to mind map" "c" #'org-mind-map-write-current-tree)))
;; Org-Mind-Map:1 ends here

;; [[file:config.org::*Org-Cliplink][Org-Cliplink:1]]
(use-package! org-cliplink
  :config
  (map! :leader
        :prefix "n"
        :desc "Org Clip Link" "l" #'org-cliplink))
;; Org-Cliplink:1 ends here
