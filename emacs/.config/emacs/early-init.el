;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; -*- lexical-binding: t -*-
;;; Fern's Dotfiles -- Emacs - Early Initialization
;; https://github.com/fernzi/dotfiles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Spooky performance hacks!
;; Stole most of these from Doom, honestly.
;; And I get the feeling most of em don't really do that much.

;; This really just sets garbage collection to a super high
;; threshold so it doesn't kick in on startup, and we later use
;; the `gcmh' package to automatically set it to something sane.
(setq gc-cons-threshold most-positive-fixnum)

;; Supress loading the site-lisp files.
;; We undo this at the end after init's over.
(put 'site-run-file 'orig-value site-run-file)
(setq site-run-file nil)

(require 'xdg)

(when (eval-when-compile (featurep 'native-compile))
  ;; And this saves a bit of time wasted on compilation.
  ;; Emacs' native-compiled files should already come compiled,
  ;; and rather not do even more IO everytime code gets loaded.
  (setq native-comp-deferred-compilation nil
        native-comp-async-report-warnings-errors 'silent ; Just in case
        load-prefer-newer noninteractive)

  ;; Get Emacs' native comp cache out of my configs.
  (when (boundp 'native-comp-eln-load-path)
    (let ((cdir (expand-file-name "emacs/eln/" (xdg-cache-home))))
      ;; Emacs 28 seems to be pretty wonky about this.
      ;; Sometimes find the `eln-cache' directory in my configs
      ;; even if this is set.
      (if (version< emacs-version "29")
          (add-to-list 'native-comp-eln-load-path cdir)
        (startup-redirect-eln-cache cdir)))))

(let ((orig-value file-name-handler-alist))
  ;; These usually run every time Emacs loads a file.
  ;; Yaaaah, rather not right now.
  (setq-default file-name-handler-alist nil)

  ;; Set back that stuff to something saner after Emacs' started.
  ;; We append the original values to it in case it was modified
  ;; since we un-set it.
  (add-hook 'emacs-startup-hook
    (defun my//hook/reset-file-name-handler-alist ()
      (set-default-toplevel-value
       'file-name-handler-alist
       (delete-dups (append file-name-handler-alist orig-value))))))

;;; Package Management ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add my own personal stuff to the load list.
(add-to-list 'load-path
  (expand-file-name "lib" user-emacs-directory))

;; Get packages into a place that makes more sense.
;; Please, they're not configuration.
(setq package-user-dir
      (expand-file-name "emacs/elpa" (xdg-data-home)))

;; The default repos plus MELPA.
;; Only wish a lotta people didn't go like
;; "Yeah, I added my package to NonGNU,
;; but I haven't tagged a release in forever,
;; so have fun with the version from 10 years ago."
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

;; Will deal with 'em packages later,
;; when they're actually needed.
(setq package-enable-at-startup t
      package-quickstart t)

;;; Display ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'conf)
(require 'util)

;; Setting this makes Emacs start slighly faster,
;; at least for me. Don't ask me why that is.
;; Also, please stop flashbanging me on startup.
(set-face-attribute
 'default nil
 :family my/font-monospace
 :height my/font-size
 :background "#202020")

(unless noninteractive
  (setq frame-inhibit-implied-resize t)

  ;; Quiet down Emacs!
  ;; I mean, you haven't even started yet.
  (setq-default inhibit-redisplay t
                inhibit-message t)
  (add-hook 'after-init-hook
    (defun my//hook/reset-inhibited-vars ()
      (setq-default
       inhibit-redisplay nil
       inhibit-message nil)
      (redraw-frame)))

  (advice-add #'tool-bar-setup :override #'ignore)

  ;; Silence the startup.
  ;; Sorry, but already know what Emacs is,
  ;; don't need all the messages bout it.
  (setq inhibit-startup-screen t
        inhibit-startup-echo-area-message user-login-name
        initial-major-mode 'fundamental-mode
        initial-scratch-message nil)

  ;; Remove the "For informatiot about GNU Emacs…" message.
  (advice-add #'display-startup-echo-area-message :override #'ignore)

  ;; Avoid initializing the startup screen, which happens
  ;; even when it's already disabled, apparently.
  (advice-add #'display-startup-screen :override #'ignore))

;; We unset the mode-line format so changes to it
;; won't cause any potential slowdown (maybe hopefully).
;; Our custom mode-line will later reset this.
(put 'mode-line-format 'orig-value mode-line-format)
(setq-default mode-line-format nil)
(dolist (buf (buffer-list))
  (with-current-buffer buf
    (setq mode-line-format nil)))

;; Set the default frame options early
;; for minimum pops and moves.
(setq default-frame-alist
      `((min-height . 1)
        (min-width . 1)
        (height . 44)
        (width . 80)
        (border-width . ,(my/or-fallback 'my/border-width 0))
        (menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (vertical-scroll-bars . right))
      frame-title-format "%b — GNU Emacs"
      frame-resize-pixelwise t)

(setq-default
 left-margin-width (car-safe my/margin-width)
 right-margin-width (car-safe (cdr-safe my/margin-width)))

;;; Reset Some Stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'cl-lib)

(define-advice startup--load-user-init-file
    (:around (fn &rest args) undo-hacks)
  (let (init)
    (unwind-protect
        ;; Load site-lisp files, suppressing messages.
        (progn
          (when (setq site-run-file (get 'site-run-file 'orig-value))
            (let (inhibit-startup-screen inhibit-startup-screen)
              (cl-flet ((load-file (f)
                          (load f nil 'nomessage))
                        (load (f &optional ne nm &rest as)
                          (load f ne t as)))
                (load site-run-file t t))))
          (apply fn args)
          (setq init t))
      ;; The hook tha resets the display inhibition might not
      ;; run if our init file has errors, so we do it here.
      (when (or (not init) init-file-had-error)
        (my//hook/reset-inhibited-vars))
      (advice-remove #'tool-bar-setup #'ignore)
      ;; Reset the mode line format now that init's done.
      (unless (default-toplevel-value 'mode-line-format)
        (setq-default mode-line-format
                      (get 'mode-line-format 'orig-value))))))
