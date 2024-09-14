;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; -*- lexical-binding: t -*-
;;; Fern's Dotfiles -- Emacs Text Editor
;; https://github.com/fernzi/dotfiles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Welcome to my Emacs, fellow traveler!
;; If you're looking for the easy stuff,
;; like fonts, colours, line spacing, etc.
;; Take a look at the `conf.el' file instead.
;; Otherwise, go forth for the odd bits beyond…

;; But first of all, let's set up the package management.
;; I prefer using `setup' over the more common `use-package'.
;; Does less magic, and makes it very easy to define keywords.
;; Simple and clean. (is the way that you're making me feel tonight.)

(require 'util)

(when (eval-when-compile (version< emacs-version "27"))
  (package-initialize))

(require 'package)

(setq package-name-column-width 40
      package-version-column-width 14
      package-status-column-width 12
      package-archive-column-width 8)

;; Refresh the package list and
;; install `setup' if it's missing.
(unless (package-installed-p 'setup)
  (package-refresh-contents)
  (package-install 'setup))

(defmacro defsetup (name sig &rest body)
  "Shorthand for `setup-define'."
  (declare (debug defun))
  (let (opts)
    (when (stringp (car body))
      (setq opts (nconc (list :documentation (pop body)) opts)))
    (while (keywordp (car body))
      (let* ((prop (pop body)) (val `',(pop body)))
        (setq opts (nconc (list prop val) opts))))
    `(setup-define ,name
       (cl-function (lambda ,sig ,@body))
       ,@opts)))

;; Enable automatic garbage collection management.
;; Setting this before loading every other package.
(setup (:package gcmh)
  (gcmh-mode 1))

;;; Base Customization ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Note that I configure everything through `setup',
;; and I mean *everything*, including built-in stuff.
;; Much easier to read and remember my own tweaks
;; when all's done the same way, if you ask me.

(require 'conf)

(setup emacs
  (:option
   ;; Gotta love how we all hide the menus that show
   ;; you how to do everything and then complain that
   ;; Emacs "lacks discoverability."
   menu-bar-mode nil
   tool-bar-mode nil
   tooltip-mode nil

   ;; Neaten up the editor as well.
   line-spacing (my/or-fallback 'my/line-spacing 0)

   ;; Make TABs a bit saner.
   tab-width my/tab-width
   backward-delete-char-untabify-method nil
   electric-indent-inhibit t

   ;; Less headache-inducing scrolling.
   scroll-margin 2
   scroll-conservatively 101
   scroll-preserve-screen-position t
   mouse-wheel-progressive-speed nil

   ;; I like selections working like in 99% of editors.
   delete-selection-mode t

   ;; Making me type a three letter word is cruel and unusual.
   use-short-answers t

   ;; Minibuffer except not (less) janky.
   minibuffer-prompt-properties
   '(readonly t cursor-intangible t face minibuffer-prompt))
  (set-window-scroll-bars (minibuffer-window) nil nil)
  (:with-feature cursor-intangible
    (:hook-into minibuffer-setup-hook)))

(setup frame
  (:option
   ;; Let's make the cursor a bit more pleasing to the eye.
   cursor-type 'bar
   blink-cursor-blinks 5
   blink-cursor-delay 1
   blink-cursor-interval 1.4
   x-stretch-cursor t))

;; Set the back and forward mouse buttons
;; to go back and forward on the help.
(setup help-mode
  (:bind [mouse-8] help-go-back
         [mouse-9] help-go-forward))

;; Moving between windows/panes.
;; (setup windmove
;;   (windmove-default-keybindings 'control))

(setup savehist
  (:option history-length 10000
           history-delete-duplicates t
           savehist-mode 1))

(setup recentf
  (:option recentf-max-saved-items 50
           recentf-exclude
             '("COMMIT_EDITMSG\\'"
               ".*-autoloads\\.el\\'"
               "emacs/[0-9.]+/lisp/.*\\.el\\(\\.gz\\)?\\'"
               "[/\\]elpa/")))

;; Get all that rubbish outta my config dir.
(setup (:package no-littering)
  (:option
   no-littering-etc-directory
     (expand-file-name "emacs/conf" (xdg-data-home))
   no-littering-var-directory
     (expand-file-name "emacs/data" (xdg-data-home))
   lock-file-name-transforms
     `((".*" ,(no-littering-expand-var-file-name "lock/") t)))
  (no-littering-theme-backups))

;;; Editor Appearance ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Colour theme.
;; Probably'll make a custom one eventually,
;; so not gonna stay with this forever.
(setup (:package doom-themes)
  (:option (prepend custom-theme-load-path)
           (expand-file-name "theme" user-emacs-directory))
  (load-theme 'doom-molokai t))

;; Set all em fonts!
;; Which ones? Look back up top.
(custom-set-faces
 `(default
   ((t (:family ,my/font-monospace :height ,my/font-size))))
 `(fixed-pitch
   ((t (:family ,my/font-monospace :height ,my/font-size))))
 `(variable-pitch
   ((t (:family ,my/font-variable :height ,my/font-size))))
 `(scroll-bar
   ((t (:foreground "#383838")))))

;; Make numbers stand out a bit.
(setup (:package highlight-numbers)
  (:hook-into prog-mode
              conf-mode))

;; And so do 'em \ characters.
(setup (:package highlight-escape-sequences)
  (:with-mode hes-mode
    (:hook-into
     prog-mode
     conf-mode)))

;;;; Line numbers.
;; In that so convenient relative-to-the-current-line style.
;;
;; Though I've been questioning how useful they actually are;
;; mostly cause there's no way of having more than one space
;; between em and the text without modifying Emacs' C source,
;; so I just turned them off, and I've survived so far.
(setup display-line-numbers
;;   (:hook-into prog-mode
;;               text-mode
;;               conf-mode)
  (:option display-line-numbers-type 'visual
           display-line-numbers-width-start 999))

;; Highlight the current line.
;; Looks pretty bad by default,
;; but it's nothing a good theme won't fix.
(setup hl-line
  (:hook-into prog-mode text-mode conf-mode package-menu-mode))

;;;; Show whitespace characters.
;; And display tabs as a vertical bar. It'll change your life.
(setup whitespace
  (:hook-into prog-mode text-mode conf-mode)
  ;; (:with-mode whitespace-cleanup
  ;;   (:hook-into prog-mode text-mode conf-mode))
  (:option
   ;; Highlight trailing spaces, empty lines, and whatnot.
   ;; There doesn't seem to be a convenient way of activating
   ;; marks only for trailing spaces, annoyingly.
   whitespace-style
     '(face trailing tabs spaces
       lines-tail missing-newline-at-eof empty
       indentation space-after-tab space-before-tab
       tab-mark)
   ;; Did you know that you can set these with the actual glyph
   ;; instead of writing them in decimal like a complete idiot?
   ;; Also, using the `?\N{NAME}' char syntax makes init slower
   ;; for some strange reason, so don't, I guess.
   whitespace-display-mappings
     '((space-mark
        ?\s [?␣] [?·] [?\.])
       (space-mark
        ?\  [?¤] [?_])
       (newline-mark
        ?\n [?↩ ?\n] [?$ ?\n])
       (tab-mark
        ?\t [?▏ ?\t] [?\| ?\t] [?\\ ?\t]))
  ))

;; I like having a bar at column 80 -- or was it 72?
(setup display-fill-column-indicator
  (:hook-into prog-mode text-mode conf-mode)
  (:option display-fill-column-indicator-character ?▕))

;; Highlight matching parentheses.
;; And get rid of the delay cause why even?
(setup paren
  (:option show-paren-mode t
           show-paren-delay 0))

(setup electric-pair
  (:with-feature electric-pair-local
    (:hook-into prog-mode text-mode conf-mode)))

;; Highlight modified or added lines
;; in the… gutter? Margin? Something.
(setup (:package diff-hl)
  (:hook-into prog-mode))

;; Show FIXMEs and TODOs with a bright, visible face,
;; so your dumb baby brain won't forget 'em.
(setup (:package fic-mode)
  (:hook-into prog-mode))

;;; Editing ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Spell checking.
;; Not running it live, cause it's sloooow.
;; There's probably a package that fixes it,
;; but I'm too lazy to look it up.
(setup flyspell
  ;; (:hook-into text-mode)
  ;; (:with-feature flyspell-prog (:hook-into prog-mode))
  (:option ispell-program-name
             (cl-some 'executable-find
                      '("enchant-2"
                        "enchant"
                        "aspell"
                        "hunspell"))
           ispell-dictionary "en_US"))

;;;; Modal editing.
;; Using Vi is not a sin; it is a penance.
;;
;; Feel like most people would use Evil Mode, but,
;; if you ask me, there's very little reason to if
;; you aren't a Vim refugee.
;;
;; Honestly, I know Vim enough to use when there's
;; no other option, but I don't actually like it.
;; Vi(m) is a product of the its original environment,
;; rather than some sort of peak ergonomic achievement.
;; I mean, HJKL aren't even the real home keys.
;;
;; Think a Kakoune-like selection-based editing model
;; is a better fit for Emacs, so I use `ryo-modal' to
;; achieve something similar.
(setup (:package ryo-modal)
  (:global "<escape>" ryo-modal-mode)
  ;; Custom keyword for `setup'.
  (defsetup :ryo (&rest keys)
    "Bind several keys in `ryo-modal-mode'"
    :after-loaded t
    `(with-eval-after-load 'ryo-modal (ryo-modal-keys ,@keys))))

;; Tried to get most of the keys to behave as close
;; to the real Kakoune as I could, but this is kinda WIP.
;; TODO: Handle multiple cursors.
(setup (:require kakoune)
  (:ryo
   ;; Normal mode commands:
   ("a" forward-char :exit t)
   ("b" kak/word-select-prev-beg)
   ("c" kak/delete :exit t)
   ("d" kak/delete)
   ("e" kak/word-select-next-end)
   ("f" kak/char-select)
   ;; Look at the end for `g'.
   ;; ("h")
   ("i" ryo-modal-mode)
   ;; ("j")
   ;; ("k")
   ;; ("l")
   ;; ("m")
   ("n" isearch-repeat-forward)
   ("o" kak/line-new :exit t)
   ("p" kak/paste)
   ("q" kmacro-end-or-call-macro)
   ("r" kak/char-replace)
   ;; ("s")
   ;; ("t")
   ;; ("u")
   ;; ("v")
   ("w" kak/word-select-next-beg)
   ("x" kak/line-select)
   ("y" kak/yank)
   ;; ("z")

   ("A" move-end-of-line :exit t)
   ("B" kak/word-extend-prev-beg)
   ;; ("C")
   ;; ("D")
   ("E" kak/word-extend-next-end)
   ;; ("F")
   ;; ("G")
   ;; ("H")
   ("I" back-to-indentation :exit t)
   ;; ("J")
   ;; ("K")
   ;; ("L")
   ;; ("M")
   ;; ("N")
   ("O" kak/line-new-above :exit t)
   ("P" kak/paste-before)
   ("Q" kmacro-start-macro-or-insert-counter)
   ("R" kak/replace)
   ;; ("S")
   ;; ("T")
   ;; ("U")
   ;; ("V")
   ("W" kak/word-extend-next-beg)
   ;; ("X")
   ;; ("Y")
   ;; ("Z")

   ("M-d" delete-forward-char)
   ("M-n" isearch-repeat-backward)
   ("M-j" kak/join)

   ("#" comment-line)
   ("%" kak/buffer-select)
   ("/" isearch-forward-regexp)
   (":" execute-extended-command)
   ("@" untabify)
   ("`" kak/case-down)
   ("~" kak/case-up)

   ("M-;" kak/exchange-mark)
   ("M-@" tabify)

   ("<return>" save-buffer)

   ;; GOTO Commands:
   ("g"
    (;; Buffer navigation:
     ("g" kak/goto-line)
     ("i" back-to-indentation)
     ("e" end-of-buffer)
     ("<left>"  move-beginning-of-line)
     ("<down>"  kak/goto-last)
     ("<up>"    beginning-of-buffer)
     ("<right>" move-end-of-line)
     ;; Window navigation:
     ("t" kak/goto-win-top)
     ("b" kak/goto-win-bot)
     ("c" kak/goto-win-cen)
     ;; Buffer switching:
     ("a" kak/goto-buff-last)
     ("s" switch-to-buffer)
     ("f" find-file)))

   ;; Leader prefix:
   ("SPC"
    (;; Emacs' default chords, for convenience:
     ("c" "C-c")
     ("h" "C-h")
     ;; Buffer shenanigans:
     ("k" kill-current-buffer)
     ("r" my/revert-buffer)))

   ;; Prefix arguments:
   ("0" "M-0" :norepeat t)
   ("1" "M-1" :norepeat t)
   ("2" "M-2" :norepeat t)
   ("3" "M-3" :norepeat t)
   ("4" "M-4" :norepeat t)
   ("5" "M-5" :norepeat t)
   ("6" "M-6" :norepeat t)
   ("7" "M-7" :norepeat t)
   ("8" "M-8" :norepeat t)
   ("9" "M-9" :norepeat t)))

;; Get undo/redo to work like in a sane editor.
;; Ain't the `:ryo' keyword convenient?
(setup (:package undo-tree)
  (global-undo-tree-mode)
  (:ryo ("u" undo-tree-undo)
        ("U" undo-tree-redo)
        ("SPC o u" undo-tree-visualize)))

;;; Completion ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; There's no Ivy or Helm, only Vertico.
;; …and Orderless, and Marginalia, and…

(setup (:package vertico)
  (:option vertico-resize nil)
  (vertico-mode))

(setup (:package orderless)
  (:option completion-styles '(orderless)
           completion-category-defaults nil
           completion-category-overrides
           '((file (styles partial-completion)))))

(setup (:package marginalia)
  (marginalia-mode)
  (:with-map minibuffer-local-map
    (:bind "M-A" marginalia-cycle)))

(setup (:package corfu)
  (:with-map corfu-map
    (:bind "TAB" corfu-next
           "S-TAB" corfu-previous))
  (:option corfu-auto t
           corfu-cycle t
           corfu-quit-no-match t
           corfu-quit-at-boundary t
           global-corfu-mode t))

;; (setup (:package cape)
;; )

(setup (:package yasnippet)
  (:with-mode yas-minor-mode
    (:hook-into lua-mode)))

;;;; Key suggestions.
;; Don't remember all of Emacs' key bindings,
;; and I very much doubt anyone actually does.
;; So let's give ourselves a hand, okay?
(setup (:package which-key)
  (which-key-mode)
  (:option which-key-idle-delay 1
           which-key-idle-secondary-delay 0.2
           (prepend which-key-replacement-alist)
           '((nil . "ryo:.*:") . (nil . ""))))

;;; Utilities ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setup dired
  (:hook dired-hide-details-mode)
  (:option dired-listing-switches "-Ahlp --group-directories-first"
           dired-dwim-target t)
  (:ryo ("g j" dired-jump)))

;; (setup grep
;;   (:option grep-template "rg <C> -nH0 --no-heading -g <F> <R> <D>"))

;;; UI Enhancements ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Some other packages like using these.
;; I remember when `all-the-icons' was the cool one to use.
;; Also, Nerd fonts are stupid. Learn to use FontConfig, sheesh.
(setup (:package nerd-icons))

;; Fancy mode line/status bar.
;; It even shows when Ryo's active and everything!
(setup (:package doom-modeline)
  (doom-modeline-mode t)
  (:option column-number-mode t
           doom-modeline-height (my/scale-pixel 32)
           doom-modeline-buffer-file-name-style 'buffer-name
           doom-modeline-major-mode-icon nil))

;;;; Custom startup screen.
;; Just a bit more useful than the stock one.
;; And, honestly, I just think it looks purdy.
(setup (:package dashboard)
  (dashboard-setup-startup-hook)
  (custom-set-faces
   `(dashboard-banner-logo-title
     ((t (:inherit default
          :family ,my/font-variable
          :height ,(truncate (* 1.4 my/font-size))
          :weight bold))))
   `(dashboard-heading
     ((t (:inherit font-lock-function-name-face
          :height ,(truncate (* 1.2 my/font-size)))))))
  (:option
   initial-buffer-choice
     (when (or noninteractive (daemonp))
       (lambda () (get-buffer-create dashboard-buffer-name)))
   dashboard-banner-logo-title (format "✦ %s ✦" my/db-title)
   dashboard-startup-banner
     (expand-file-name "img/banner.png" user-emacs-directory)
   dashboard-image-banner-max-height (my/scale-pixel 256)
   dashboard-center-content t
   dashboard-vertically-center-content t
   dashboard-items '((recents . 6))
   dashboard-startupify-list
     `(dashboard-insert-banner
       dashboard-insert-banner-title
       dashboard-insert-newline
       dashboard-insert-navigator
       dashboard-insert-items
       dashboard-insert-newline
       dashboard-insert-footer
       ,(dashboard-insert-newline 2)
       dashboard-insert-init-info)
   dashboard-navigator-buttons
     (my/dashboard-entries
      '((("Homepage" "Check out my dotfiles!" "heart_box"
          (browse-url my/db-homepage))
         ("Configure" "Edit configuration file" "cog_box"
          (find-file
           (expand-file-name "init.el" user-emacs-directory)))
         ("Packages" "Open package list" "package_down"
          (list-packages))
         (nil "Open the Emacs manual" "help_box"
          (info-emacs-manual)))))
   dashboard-footer-messages my/db-messages))

;; File browser on the side. Feeling kinda mixed bout this one,
;; cause not sure I even use it, but we'll see.
(setup (:package treemacs)
  (:ryo ("SPC o t" treemacs-select-window)))

;;; Language Support ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Tree-sitter my beloved. Major modes are so easy now.
;; This means my config only works on Emacs 29 onward,
;; but I'm totally worth it.
(setup treesit
  (setq treesit-language-source-alist nil)
  (defsetup :treesit (&rest defs)
    "Setup a Tree-sitter grammar install source"
    `(push ',defs treesit-language-source-alist)))

;; And if there's any one reason why I can tolerate
;; Visual Studio Code's existence, it's language servers.
;; All that completion and checking goodness, in any editor.
;; Note that servers still have to be installed outside Emacs.
(setup eglot
  (:when-loaded
    (add-to-list 'eglot-server-programs
                 '(lua-mode "lua-language-server")))
  (:ryo
   (:mode 'eglot--managed-mode)
   ("SPC l" (("a" eglot-code-actions)
             ("d" eglot-find-declaration)
             ("f" eglot-format)
             ("F" eglot-format-buffer)
             ("i" eglot-find-implementation)
             ("r" eglot-rename)
             ("y" eglot-find-typeDefinition)))))

;; Also, wish major modes would just do what I want,
;; instead of having to set an option in all of them just
;; so pressing the tab key does the same thing every time.

;;;; AsciiDoc

(setup (:package adoc-mode)
  (:file-match "\\.a(scii)?doc\\'")
  (custom-set-faces
   '(adoc-title-0-face
     ((t (:inherit adoc-title-face
          :height 1.4))))
   '(adoc-title-1-face
     ((t (:inherit adoc-title-face
          :height 1.3))))
   '(adoc-title-2-face
     ((t (:inherit adoc-title-face
          :height 1.2))))
   '(adoc-title-3-face
     ((t (:inherit adoc-title-face
          :height 1.1))))
   '(adoc-title-4-face
     ((t (:inherit adoc-title-face
          :height 1.05))))
   '(adoc-title-5-face
     ((t (:inherit adoc-title-face
          :height 1.05))))))

;;;; C & C++

(setup c-ts-mode
  (:file-match "\\.lsl\\'")             ; Purdy janky.
  (:hook eglot-ensure)
  (:treesit c "https://github.com/tree-sitter/tree-sitter-c")
  (:option
   (prepend major-mode-remap-alist) '(c-mode . c-ts-mode)
   c-ts-mode-indent-offset my/tab-width
   c-ts-mode-indent-style "linux"))

(setup c++-ts-mode
  (:hook eglot-ensure)
  (:treesit cpp "https://github.com/tree-sitter/tree-sitter-cpp")
  (:option
   (prepend major-mode-remap-alist) '(c++-mode . c++-ts-mode)))

(setup c-or-c++-ts-mode
  (:option
   (prepend major-mode-remap-alist) '(c-or-c++-mode . c-or-c++-ts-mode)))

;;;; CMake

(setup cmake-ts-mode
  (:file-match "CMakeLists\\.txt\\'"
               "\\.cmake\\'")
  (:treesit cmake "https://github.com/uyha/tree-sitter-cmake"))

;;;; CSS

(setup css-mode
  (:file-match "\\.rasi\\'")
  (:option css-indent-offset my/tab-width))

;;;; Emacs Lisp

(setup emacs-lisp-mode
  (:hook (lambda () (setq indent-tabs-mode nil))))

;;;; Execline (Skarnet)

(setup (:package execline))

;;;; Fennel

(setup (:package fennel-mode)
  (:file-match "\\.fnl\\'"))

;;;; Fish

(setup (:package fish-mode)
  (:file-match "\\.fish\\'")
  (:option fish-indent-offset my/tab-width))

;;;; Git

(setup (:package git-modes))

;;;; Go

(setup go-ts-mode
  (:file-match "\\.go\\'"
               "go\\.mod\\'")
  (:hook eglot-ensure)
  (:treesit go "https://github.com/tree-sitter/tree-sitter-go")
  (:treesit gomod "https://github.com/camdencheek/tree-sitter-go-mod")
  (:option go-ts-mode-indent-offset my/tab-width))

;;;; Lua

(setup (:package lua-mode)
  (:file-match "\\.lua\\'")
  (:hook eglot-ensure)
  (:option lua-indent-level my/tab-width))

;;;; Markdown

(setup (:package markdown-mode)
  (:file-match "\\.md\\'"
               "\\.scd\\'")
  (:with-mode gfm-mode
    (:file-match "README\\.md\\'")))

;;;; Meson

(setup (:package meson-mode)
  (:file-match "meson(\\.build|_options.txt)\\'")
  (:option meson-indent-basic my/tab-width))

;;;; Perl

(setup cperl-mode
  (:option
   (prepend major-mode-remap-alist) '(perl-mode . cperl-mode)))
  ;; (:option perl-indent-level my/tab-width))

;;;; Python

(setup python-ts-mode
  (:hook eglot-ensure)
  (:treesit python "https://github.com/tree-sitter/tree-sitter-python")
  (:option
   (prepend major-mode-remap-alist) '(python-mode . python-ts-mode)))

;;;; Qt (Quick)

(setup (:package qml-mode)
  (:file-match "\\.qml\\'"))

;;;; Scheme

(setup scheme-mode
  (:hook (lambda () (setq indent-tabs-mode nil))))

;;;; Shell

(setup sh
  (:file-match "\\.ebuild\\'"
               "PKGBUILD"
               "lfrc")
  (:option sh-basic-offset my/tab-width))

;;;; TOML

(setup toml-ts-mode
  (:treesit toml "https://github.com/tree-sitter/tree-sitter-toml")
  (:option
   (prepend major-mode-remap-alist) '(conf-toml-mode . toml-ts-mode)))

;;;; Type/JavaScript

(setup typescript-ts-mode
  (:file-match "\\.[jt]sx?\\'")
  (:hook eglot-ensure)
  (:treesit
   typescript "https://github.com/tree-sitter/tree-sitter-typescript"
   nil "typescript/src")
  (:treesit
   tsx "https://github.com/tree-sitter/tree-sitter-typescript"
   nil "tsx/src"))

;;;; JSON

(setup json-ts-mode
  (:file-match "\\.json\\'")
  (:treesit json "https://github.com/tree-sitter/tree-sitter-json.git"))

;;;; HTML and More

(setup (:package web-mode)
  (:file-match "\\.j2\\'"
               "\\.jinja2?\\'"
               "\\.liquid\\'"
               "\\.njk\\'")
  (:hook (lambda ()
           (setq web-mode-markup-indent-offset my/tab-width
                 web-mode-attr-indent-offset my/tab-width
                 web-mode-code-indent-offset my/tab-width
                 web-mode-css-indent-offset my/tab-width))))

;;;; YAML

(setup yaml-ts-mode
  (:file-match "\\.clang-[a-z]+\\'")
  (:treesit
   yaml "https://github.com/ikatyang/tree-sitter-yaml")
  (:option (prepend major-mode-remap-alist) '(yaml-mode . yaml-ts-mode)))

;; One package's notable for its absence…
;; I don't really use Org Mode. Such a rebel.

;;; Other ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get Custom's settings off my face.
(setq custom-file
      (expand-file-name "emacs/custom.el" (xdg-data-home)))
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)
