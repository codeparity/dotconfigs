;;; packages.el -*- no-byte-compile: t; -*-
;; Custom packages for Org mode, mind mapping, and knowledge management

;; org-brain: uncompiled to prevent polymode macro void-variable evaluation bug
(package! org-brain :recipe (:build (:not compile)))
(package! polymode)

;; Mind map generator using graphviz
(package! org-mind-map
  :recipe (:host github :repo "the-ted/org-mind-map"))

;; Auto-titled web links for org entries
(package! org-cliplink)
