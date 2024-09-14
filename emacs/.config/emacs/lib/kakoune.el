;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; -*- lexical-binding: t -*-
;;; Fern's Dotfiles -- Editor - Kakoune emulation
;; https://github.com/fernzi/dotfiles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun kak/set-transient-mark (&optional pos)
  "Set a mark that deactivates once the cursor moves"
  (unless (eq (car-safe transient-mark-mode) 'only)
    (setq-local transient-mark-mode
                (cons 'only
                      (unless (eq transient-mark-mode 'lambda)
                        transient-mark-mode))))
  (push-mark pos t t))

(defun kak/apply-to-region-or-char (func &optional beg end)
  "Apply function to the region, if active; to the next char otherwise."
  (let* ((reg (use-region-p))
         (pnt (point))
         (beg (or (and reg beg) pnt))
         (end (or (and reg end) (min (point-max) (1+ pnt)))))
    (funcall func beg end)))

;;; Movement ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun kak/buffer-select ()
  "Set region to the whole buffer."
  (interactive)
  (push-mark)
  (kak/set-transient-mark (point-min))
  (goto-char (point-max)))

(defun kak/char-select (chr &optional arg)
  "Set region from the point to the next ocurrence of `chr'"
  (interactive "cSelect to next char:\np")
  (kak/set-transient-mark)
  (search-forward (char-to-string chr) nil nil arg))

(defun kak/char-extend (chr &optional arg)
  "Extend region to the next ocurrence of `chr'."
  (interactive "cExtend region to next char:\np")
  (unless (region-active-p)
    (kak/set-transient-mark))
  (search-forward (char-to-string chr) nil nil arg))

(defun kak/exchange-mark ()
  (interactive)
  (when (region-active-p)
    (exchange-point-and-mark)))

(defun kak/goto-buff-last ()
  "Switch to the previously active buffer."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(defun kak/goto-last ()
  "Move cursor to the last line in the buffer."
  (interactive)
  (goto-char (point-max))
  (beginning-of-line (and (looking-at-p "^$") 0)))

(defun kak/goto-line (arg)
  "Go to LINE, counting from like 1 at the beginning of the buffer."
  (interactive "p")
  (goto-char (point-min))
  (forward-line (1- arg)))

(defun kak/goto-win-bot ()
  "Move the cursor to the line at the bottom of the window."
  (interactive)
  (move-to-window-line -1))

(defun kak/goto-win-cen ()
  "Move the cursor to the line at the centre of the window."
  (interactive)
  (move-to-window-line nil))

(defun kak/goto-win-top ()
  "Move the cursor to the line at the top of the window."
  (interactive)
  (move-to-window-line 0))

(defun kak/line-select (&optional beg end)
  "Select the current line, or extend selection to cover whole lines."
  (interactive "r")
  (let* ((reg (use-region-p))
         (beg (and reg beg))
         (end (and reg end)))
    (when beg (goto-char beg))
    (beginning-of-line)
    (kak/set-transient-mark)
    (when end (goto-char end))
    (forward-line)))

(defun kak/word-select-next-beg (arg)
  "Select to the next word start."
  (interactive "p")
  (kak/set-transient-mark)
  (forward-to-word arg))

(defun kak/word-select-next-end (arg)
  "Select to the next word end."
  (interactive "p")
  (forward-word (max (1- arg) 0))
  (kak/set-transient-mark)
  (forward-word))

(defun kak/word-select-prev-beg (arg)
  "Select to the previous word start."
  (interactive "p")
  (kak/set-transient-mark)
  (backward-word arg))

(defun kak/word-extend-next-beg (arg)
  (interactive "p")
  (unless (use-region-p)
    (kak/set-transient-mark))
  (forward-word arg))

(defun kak/word-extend-next-end (arg)
  (interactive "p")
  (forward-word (max (1- arg) 0))
  (unless (use-region-p)
    (kak/set-transient-mark))
  (forward-word))

(defun kak/word-extend-prev-beg (arg)
  (interactive "p")
  (unless (use-region-p)
    (kak/set-transient-mark))
  (backward-word arg))

(defun kak/sexp-extend (&optional arg beg end)
  (interactive "p\nr")
  (backward-sexp arg)
  (kak/set-transient-mark)
  (forward-sexp arg))

;;; Editing ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun kak/case-down (&optional beg end)
  "Downcase region, if active; otherwise, downcase next character."
  (interactive "*r")
  (kak/apply-to-region-or-char #'downcase-region beg end))

(defun kak/case-up (&optional beg end)
  "Upcase region, if active; otherwise, upcase next character."
  (interactive "*r")
  (kak/apply-to-region-or-char #'upcase-region beg end))

(defun kak/char-replace (chr &optional beg end)
  "Overwrite the active region with the selected character."
  (interactive "*cChar to replace with:\nr")
  (kak/apply-to-region-or-char
   (lambda (beg end)
     (let ((pos (point))
           (len (- end beg)))
       (delete-region beg end)
       (goto-char beg)
       (insert-char chr len)
       (setq deactivate-mark nil)
       (when (and (< 1 len) (= pos beg))
         (kak/set-transient-mark))
       (goto-char pos)))
   beg end))

(defun kak/join (&optional arg beg end)
  "Join the next line to the current one."
  (interactive "*p\nr")
  (let* ((reg (region-active-p))
         (beg (and reg beg))
         (end (and reg end)))
    (dotimes (_ (if beg 1 arg))
      (delete-indentation (not beg) beg end))))

(defun kak/line-new (arg)
  "Insert a new line below the current line."
  (interactive "*p")
  (end-of-line)
  (newline arg t))

(defun kak/line-new-above (arg)
  "Insert a new line above the current line."
  (interactive "*p")
  (if (< (forward-line -1) 0)
      (open-line arg)
    (kak/line-new arg)))

;;; Cut, Copy & Paste ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun kak/yank (&optional beg end)
  "Save region as if killed, if active; the next character otherwise."
  (interactive "r")
  (prog1 (kak/apply-to-region-or-char #'kill-ring-save beg end)
    (setq deactivate-mark nil)))

(defun kak/delete (&optional beg end)
  "Kill region, if active; the next character otherwise."
  (interactive "*r")
  (kak/apply-to-region-or-char #'kill-region beg end))

(defun kak/paste (&optional arg pos)
  "Paste after the current region, selecting the pasted text."
  (interactive "*p\nm")
  (let ((arg (or arg 1)))
    (when (use-region-p)
      (goto-char (funcall (if (> 0 arg) #'min #'max) pos (point))))
    (when (string-suffix-p "\n" (current-kill 0))
      (forward-line (if (> 0 arg) 0 1)))
    (let ((cur (point)))
      (prog1 (dotimes (_ (abs arg)) (yank))
        (kak/set-transient-mark cur)
        (setq deactivate-mark nil)))))

(defun kak/paste-before (&optional arg pos)
  "Paste before the current region, selecting the pasted text."
  (interactive "*p\nm")
  (kak/paste (- (or arg 1)) pos))

(defun kak/replace (&optional beg end)
  "Kill region and replace with clipboard contents."
  (interactive "*r")
  (kak/apply-to-region-or-char
   (lambda (beg end)
     (let ((rev (and (= beg (point)) (< 1 (- end beg)))))
       (kak/delete beg end)
       (yank 2)
       (setq deactivate-mark nil)
       (kak/set-transient-mark (and (not rev) beg))
       (when rev (goto-char beg))))
   beg end))

(provide 'kakoune)
