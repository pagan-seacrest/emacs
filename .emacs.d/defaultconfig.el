(setq-default cursor-type 'bar)
(set-cursor-color "#ff0000")
(setq-default dired-listing-switches "-alh")
(setq backup-inhibited t) ;disable backup
(setq auto-save-default nil) ;disable auto save
;;(setq default-frame-alist '((undecorated . t))) ; frame without title
;;(toggle-scroll-bar -1) ; no scroll bar
;;(fringe-mode 0) ; nullify side strips
(tool-bar-mode -1) ; hide tool bar
(setq inhibit-startup-screen t) ; without welcome window
(if (version< emacs-version "25.0")
    (progn
      (require 'saveplace)
      (setq-default save-place t))
  (save-place-mode 1)) ; save cursor last position
  (electric-pair-mode 1)
(setq electric-pair-preserve-balance nil) ; auto pair() [] {}
(cua-mode t)
    (setq cua-auto-tabify-rectangles nil)
    (transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ; using ctrl z, y, c, x, v as undo, redo, cut, paste, copy by default
(delete-selection-mode 1)
    (require 'display-line-numbers)
(defcustom display-line-numbers-exempt-modes '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
  "Major modes on which to disable the linum mode, exempts them from global requirement"
  :group 'display-line-numbers
  :type 'list
  :version "green")
  (defun display-line-numbers--turn-on ()
 "turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'"
  (if (and
       (not (member major-mode display-line-numbers-exempt-modes))
       (not (minibufferp)))
      (display-line-numbers-mode)))

(global-display-line-numbers-mode) ; display line numbers
(menu-bar-mode -1) ; hide menu bar
(defun copy-line (arg)
      "Copy lines (as many as prefix argument) in the kill ring"
      (interactive "p")
      (kill-ring-save (line-beginning-position)
                      (line-beginning-position (+ 1 arg)))
      (message "%d line%s copied" arg (if (= 1 arg) "" "s")))
(global-set-key (kbd "C-c l") 'copy-line) ; copy current line
(defun my/select-current-line-and-forward-line (arg)
  "Select the current line and move the cursor by ARG lines IF
no region is selected.

If a region is already selected when calling this command, only move
the cursor by ARG lines."
  (interactive "p")
  (when (not (use-region-p))
    (forward-line 0)
    (set-mark-command nil))
  (forward-line arg))
;; Note that I would not recommend binding this command to `C-l'.
;; From my personal experience, the default binding to `C-l' to
;; `recenter-top-bottom' is very useful.
(global-set-key (kbd "C-l") #'my/select-current-line-and-forward-line)
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq make-backup-files nil)