;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; -*- lexical-binding: t -*-
;;; Fern's Dotfiles -- Emacs - Utility functions
;; https://github.com/fernzi/dotfiles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Various miscellaneous utilities.
;; I do try to put doc strings on all of them
;; so I won't forget what they're meant to do,
;; but I often also forget to do that.

;;; Interactive Commands ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/revert-buffer ()
  "Revert current buffer without confirmation."
  (interactive)
  (revert-buffer nil t t)
  (message (concat "Reverted buffer `" (buffer-name) "'")))

;;; Regular Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Don't believe Emacs has this as a function,
;; but checking if the average char width is larger
;; than 10 pixels is how Emacs decides if the screen
;; is HiDPI (i.e. high pixel density) or not.
(defun my/scale-pixel (pix)
  "Roughly decide on a good HiDPI scaling factor."
  (* pix (if (> 10 (frame-char-width)) 1 2)))

(defun my/dashboard-entries (entry)
  "Construct a list of buttons for the Emacs Dashboard navigator."
  (if (consp (car-safe entry))
      (mapcar #'my/dashboard-entries entry)
    (pcase-let ((`(,name ,desc ,icon ,func) entry))
      (list (and icon (nerd-icons-mdicon (format "nf-md-%s" icon)))
            (or name "") desc
            (cond
             ((functionp func) func)
             ((consp func) (lambda (&rest _) (eval func))))
            nil " " " "))))

(provide 'util)
