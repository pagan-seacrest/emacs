(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(require 'dired-single)

(defun my-dired-init ()
  "Bunch of stuff to run for dired, either immediately or when it's
   loaded."
  ;; <add other stuff here>
  (define-key dired-mode-map [remap dired-find-file]
    'dired-single-buffer)
  (define-key dired-mode-map [remap dired-mouse-find-file-other-window]
    'dired-single-buffer-mouse)
  (define-key dired-mode-map [remap dired-up-directory]
    'dired-single-up-directory))

;; if dired's already loaded, then the keymap will be bound
(if (boundp 'dired-mode-map)
    ;; we're good to go; just add our bindings
    (my-dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'my-dired-init))

(require 'all-the-icons)
(require 'dired-x)
(require 'ace-mc)
(global-set-key (kbd "M-p") 'ace-mc-add-multiple-cursors)
(global-set-key (kbd "M-n p.)") 'ace-mc-add-single-cursor)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(add-hook 'prog-mode-hook 'format-all-mode)

;;===========

(require 'doom-modeline)
(doom-modeline-mode 1)

(setq doom-modeline-height 10)
(setq doom-modeline-bar-width 4)


;; Whether to use hud instead of default bar. It's only respected in GUI.
;; (defcustom doom-modeline-hud nil)

;; The limit of the window width.
;; If `window-width' is smaller than the limit, some information won't be displayed.
;; (setq doom-modeline-window-width-limit fill-column)

;; Whether display icons in the mode-line.
;; While using the server mode in GUI, should set the value explicitly.
;; (setq doom-modeline-icon (display-graphic-p))


;; Whether display the icon for `major-mode'. It respects `doom-modeline-icon'.
;; (setq doom-modeline-major-mode-icon t)

;; ========== dired-x

(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            ;; Set dired-x global variables here.  For example:
            ;; (setq dired-guess-shell-gnutar "gtar")
            ;; (setq dired-x-hands-off-my-keys nil)
            ))
(add-hook 'dired-mode-hook
          (lambda ()
            ;; Set dired-x buffer-local variables here.  For example:
            ;; (dired-omit-mode 1)
            ))
(autoload 'dired-jump "dired-x"
  "Jump to Dired buffer corresponding to current buffer." t)

(autoload 'dired-jump-other-window "dired-x"
  "Like \\[dired-jump] (dired-jump) but in other window." t)

(define-key global-map "\C-x\C-j" 'dired-jump)
(global-set-key (kbd "M-<return>") 'dired-jump-other-window)

;; ======

(require 'linum)

(defcustom linum-disabled-modes-list '(eshell-mode wl-summary-mode compilation-mode org-mode text-mode dired-mode doc-view-mode image-mode)
  "* List of modes disabled when global linum mode is on"
  :type '(repeat (sexp :tag "Major mode"))
  :tag " Major modes where linum is disabled: "
  :group 'linum
  )
(defcustom linum-disable-starred-buffers 't
  "* Disable buffers that have stars in them like *Gnu Emacs*"
  :type 'boolean
  :group 'linum)

(defun linum-on ()
  "* When linum is running globally, disable line number in modes defined in `linum-disabled-modes-list'. Changed by linum-off. Also turns off numbering in starred modes like *scratch*"

  (unless (or (minibufferp)
              (member major-mode linum-disabled-modes-list)
              (string-match "*" (buffer-name))
              (> (buffer-size) 3000000)) ;; disable linum on buffer greater than 3MB, otherwise it's unbearably slow
    (linum-mode 1)))

(provide 'linum-off)
;; ======  TABS =======================================================================================================

(require 'centaur-tabs)
(centaur-tabs-mode t)
(global-set-key (kbd "C-<`>")  'centaur-tabs-backward)
(global-set-key (kbd "C-<tab>") 'centaur-tabs-forward)
(setq centaur-tabs-style "alternate")
(setq centaur-tabs-height 24)
(setq centaur-tabs-set-bar 'over)
(setq centaur-tabs-gray-out-icons 'buffer)
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-plain-icons t)
(setq centaur-tabs-label-fixed-length 300)
(global-set-key (kbd "C-t") 'centaur-tabs--create-new-tab)



    (defun centaur-tabs-buffer-groups ()
      "`centaur-tabs-buffer-groups' control buffers' group rules.

    Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
    All buffer name start with * will group to \"Emacs\".
    Other buffer group by `centaur-tabs-get-group-name' with project name."
      (list
	(cond
	 ((or (string-equal "*" (substring (buffer-name) 0 1))
	      (memq major-mode '(magit-process-mode
				 magit-status-mode
				 magit-diff-mode
				 magit-log-mode
				 magit-file-mode
				 magit-blob-mode
				 magit-blame-mode
				 )))
	  "Emacs")
	 ((derived-mode-p 'prog-mode)
	  "Editing")
	 ((derived-mode-p 'dired-mode)
	  "Dired")
	 ((memq major-mode '(helpful-mode
			     help-mode))
	  "Help")
	 ((memq major-mode '(org-mode
			     org-agenda-clockreport-mode
			     org-src-mode
			     org-agenda-mode
			     org-beamer-mode
			     org-indent-mode
			     org-bullets-mode
			     org-cdlatex-mode
			     org-agenda-log-mode
			     diary-mode))
	  "OrgMode")
	 (t
	  (centaur-tabs-get-group-name (current-buffer))))))
	  
	 


;; =============================================================================================================
;; ======

(defun my-dired-mode-setup ()     "show less information in dired buffers"   (dired-hide-details-mode 1)) (add-hook 'dired-mode-hook 'my-dired-mode-setup)
(load-file "~/.emacs.d/defaultconfig.el")

(global-auto-revert-mode t)
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))

(defun xah-cut-line-or-region ()
  "Cut current line, or text selection.
When `universal-argument' is called first, cut whole buffer (respects `narrow-to-region').

URL `http://ergoemacs.org/emacs/emacs_copy_cut_current_line.html'
Version 2016-07-29-stackoverflow"
  (interactive)
  (if current-prefix-arg
      (progn ; not using kill-region because we don't want to include previous kill
        (kill-new (buffer-string))
        (delete-region (point-min) (point-max)))
    (if (use-region-p)
        (kill-region (region-beginning) (region-end) t)      
      (progn
        (kill-region (line-beginning-position) (line-beginning-position 2))
        (back-to-indentation)))))
(global-set-key (kbd "C-x l") 'xah-cut-line-or-region)


(defun mark-backward (&optional arg   allow-extend) ;   
      (interactive "P\np")
      (cond ((and allow-extend
               (or (and (eq last-command this-command) (mark t))
                   (and transient-mark-mode mark-active)))
      (setq arg (if arg (prefix-numeric-value arg)
               (if (< (mark) (point)) -1 1)))
                   (set-mark
                       (save-excursion
                           (goto-char (mark))
                           (forward-word arg)
                           (point))))   
      (t   (push-mark  
        (save-excursion
        (backward-word (prefix-numeric-value arg))
        (point))      nil t)))) 
(global-set-key (kbd "S-C-<right>") 'mark-word) 
(global-set-key (kbd "S-C-<left>") 'mark-backward)

(global-set-key (kbd "C-<backspace>") (lambda ()
                                        (interactive)
                                        (kill-line 0)
                                        (indent-according-to-mode)))

(defun backward-kill-line (arg)
  "Kill ARG lines backward."
  (interactive "p")
  (kill-line (- 1 arg)))
(global-set-key (kbd "C-o") 'backward-kill-line)

(defun mark-whole-word (&optional arg allow-extend)
  "Like `mark-word', but selects whole words and skips over whitespace.
If you use a negative prefix arg then select words backward.
Otherwise select them forward.

If cursor starts in the middle of word then select that whole word.

If there is whitespace between the initial cursor position and the
first word (in the selection direction), it is skipped (not selected).

If the command is repeated or the mark is active, select the next NUM
words, where NUM is the numeric prefix argument.  (Negative NUM
selects backward.)"
  (interactive "P\np")
  (let ((num  (prefix-numeric-value arg)))
    (unless (eq last-command this-command)
      (if (natnump num)
          (skip-syntax-forward "\\s-")
        (skip-syntax-backward "\\s-")))
    (unless (or (eq last-command this-command)
                (if (natnump num)
                    (looking-at "\\b")
                  (looking-back "\\b")))
      (if (natnump num)
          (left-word)
        (right-word)))
    (mark-word arg allow-extend)))
(global-set-key (kbd "M-h") 'mark-whole-word)

(defun gcm-scroll-down ()
      (interactive)
      (scroll-up 1))

(defun gcm-scroll-up ()
      (interactive)
      (scroll-down 1))
(load-file "~/.emacs.d/keymap.el")
(desktop-save-mode 1)


;(set-frame-parameter (selected-frame) 'alpha '(88 . 55))
; (add-to-list 'default-frame-alist '(alpha . (88 . 55))) ; add transparency
; =========================================================================


;; =================  ESHELL =========================

(eshell-git-prompt-use-theme 'powerline)


;; ---------------

(add-to-list 'load-path "/path/to/eshell-toggle.el")
(require 'eshell-toggle)
(global-set-key (kbd "M-e") 'eshell-toggle)

; =========================================================================
(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-12"))
(setq dired-listing-switches "-aBhl  --group-directories-first")
(add-to-list 'default-frame-alist '(height . 35))
    (add-to-list 'default-frame-alist '(width . 100))

(load-file "~/.emacs.d/tao-theme.el")
(load-theme 'tao-yin t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(centaur-tabs emmet-mode dired-quick-sort comment-dwim-2 all-the-icons-ivy eshell-toggle eshell-git-prompt format-all doom-modeline linum-relative ace-mc all-the-icons-ibuffer dired-single linum-off all-the-icons-dired dired-du persistent-soft ergoemacs-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))
(put 'dired-find-alternate-file 'disabled nil)

(require 'dired-quick-sort)
    (dired-quick-sort-setup)

;;  (require 'all-the-icons "~/.emacs.d/all-the-icons/all-the-icons.el")

(defun sanityinc/add-subdirs-to-load-path (parent-dir)
  "Add every non-hidden subdir of PARENT-DIR to `load-path'."
  (let ((default-directory parent-dir))
    (setq load-path
          (append
           (cl-remove-if-not
            #'file-directory-p
            (directory-files (expand-file-name parent-dir) t "^[^\\.]"))
           load-path))))
