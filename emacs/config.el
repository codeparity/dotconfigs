;;; config.el -*- lexical-binding: t; -*-
;; Custom configuration for Org mode, Mind Mapping, and Brain documentation

;; Set base documentation directory to ~/projects/docs
(setq org-directory (expand-file-name "~/projects/docs/"))

;; Ensure the base directories exist
(unless (file-directory-p org-directory)
  (make-directory org-directory t))

;;; --- Org Brain Configuration ---
(use-package! org-brain
  :init
  ;; Brain files live in ~/projects/docs/brain
  (setq org-brain-path (expand-file-name "brain" org-directory))
  (unless (file-directory-p org-brain-path)
    (make-directory org-brain-path t))

  :config
  (setq org-id-track-globally t)

  ;; Evil mode compatibility for visualize window
  (evil-set-initial-state 'org-brain-visualize-mode 'emacs)

  ;; Polymode hook for editing brain nodes directly in the visualizer
  (after! polymode
    (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))

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
  :after org-brain)

;;; --- Org Mind Map Configuration ---
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

;;; --- Org Clip Link Configuration ---
(use-package! org-cliplink
  :config
  (map! :leader
        :prefix "n"
        :desc "Org Clip Link" "l" #'org-cliplink))
