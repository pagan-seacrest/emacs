(global-set-key [(control down)] 'gcm-scroll-down)
(global-set-key [(control up)]   'gcm-scroll-up) ; static scroll
(global-set-key (kbd "C-x C-w") 'delete-other-windows)
(global-set-key (kbd "C-x w") 'delete-window)
(global-set-key (kbd "M-n w") 'split-window-right)
(global-set-key (kbd "M-n C-w") 'split-window-below)
(global-set-key (kbd "M-b") 'buffer-menu) ; buffers list
(global-set-key (kbd "C-w") 'kill-buffer-and-window) ; kill buffer and its window
(global-set-key (kbd "M-a") 'mode-line-other-buffer) ; switch buffer
(global-set-key (kbd "M-q") 'kill-this-buffer) ; close current buffer
(global-set-key (kbd "M-d") 'dired)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "<escape>") 'keyboard-quit)
(global-set-key (kbd "C-f") 'isearch-forward)
(global-set-key (kbd "C-r") 'query-replace)
(global-set-key (kbd "C-q") 'save-buffers-kill-terminal)
(global-set-key (kbd "C-x s") 'save-some-buffers)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "M-s") 'split-line)
(global-set-key (kbd "M-n d") 'dired-create-directory)
(global-set-key (kbd "M-n f") 'dired-create-file)
(global-set-key (kbd "C-n") 'switch-to-buffer)
(global-set-key (kbd "S-C-s") 'write-file)
(global-set-key (kbd "M-n t") 'centaur-tabs--create-new-tab)

(defun insert-and-indent-line-above ()
  (interactive)
  (push-mark)
  (let* 
    ((ipt (progn (back-to-indentation) (point)))
     (bol (progn (move-beginning-of-line 1) (point)))
     (indent (buffer-substring bol ipt)))
    (newline)
    (previous-line)
    (insert indent)))


(global-set-key (kbd "S-C-<return>") 'insert-and-indent-line-above)

(defun copy-line-up()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (previous-line 1)
  (newline)
  (yank))
(global-set-key (kbd "C-c C-<up>") 'copy-line-up)

(defun copy-line-down()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))
(global-set-key (kbd "C-c C-<down>") 'copy-line-down)


(global-set-key (kbd "C-x <up>") 'beginning-of-buffer)
(global-set-key (kbd "C-x <down>") 'end-of-buffer)

(global-set-key (kbd "M-w") #'other-window) ; switch window - Alt + W

(global-set-key (kbd "M-<left>") 'shrink-window-horizontally)
    (global-set-key (kbd "M-<right>") 'enlarge-window-horizontally)
    (global-set-key (kbd "S-C-<up>") 'shrink-window)
    (global-set-key (kbd "S-C-<down>") 'enlarge-window)
(save-place-mode 1) ; window resizing

(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-<down>") 'move-line-down) ; swap current line up & down
(global-set-key (kbd "M-<up>")   'move-line-up)


(defun xah-comment-dwim ()
  "Like `comment-dwim', but toggle comment if cursor is not at end of line.

URL `http://ergoemacs.org/emacs/emacs_toggle_comment_by_line.html'
Version 2016-10-25"
  (interactive)
  (if (region-active-p)
      (comment-dwim nil)
    (let (($lbp (line-beginning-position))
          ($lep (line-end-position)))
      (if (eq $lbp $lep)
          (progn
            (comment-dwim nil))
        (if (eq (point) $lep)
            (progn
              (comment-dwim nil))
          (progn
            (comment-or-uncomment-region $lbp $lep)
            (forward-line )))))))

(global-set-key (kbd "M-;") 'xah-comment-dwim)				;
