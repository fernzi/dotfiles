;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; -*- lexical-binding: t -*-
;;; Fern's Dotfiles -- Emacs - User Settings
;; https://github.com/fernzi/dotfiles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Easy configuration variables,
;; mostly just for stuff I'm likely to change.

;;;; Font faces.
;; My very own custom build of Iosevka.
;; Here's just set to "monospace" so FontConfig handles it.
(defconst my/font-monospace "Iosevkins")
(defconst my/font-variable  "Iosevkins Michi Extended")
(defconst my/font-size 120)

;;;; Editor appearance.
;; I do like me some tiny indents.
(defconst my/tab-width 2)
(defconst my/line-spacing 0)
(defconst my/border-width 0)
(defconst my/margin-width '(2 1))

;;;; Startup screen niceties.
;; I may not actually remember where all the quotes come from.
(defconst my/db-title "Fern's Fantastic Emacs")
(defconst my/db-homepage "https://github.com/fernzi/dotfiles")
(defconst my/db-messages
  '("...until hope has fully withered."
    "I should say something funny, but it makes me want to die."
    "It's not me, it's you."
    "Oh, no, no... I'm not beautiful. Just very, very pretty."
    "Simple and clean is the way that you're making me feel tonight."
    "Stay weirder!"
    "Strange and unusual..."
    "We are the weirdos, mister."))

(provide 'conf)
