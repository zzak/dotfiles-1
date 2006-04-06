
;;; My .emacs file

;; by Phil Hagelberg
;; Much thanks to emacswiki.org and RMS.

;; Note: this relies on files found in my .emacs.d:
;; http://dev.technomancy.us/phil/browser/dotfiles/.emacs.d


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq load-path (append '("~/.emacs.d") load-path))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     loading modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; PHP mode
(autoload 'php-mode "php-mode")
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

;; .js (javascript) loads C mode (until I find something better)
(add-to-list 'auto-mode-alist '("\\.js$" . c-mode))

;; .rhtml loads html
(add-to-list 'auto-mode-alist '("\\.rhtml$" . html-mode))

;; CSS-mode
(autoload 'css-mode "css-mode")
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))

;; YAML-mode
(autoload 'yaml-mode "yaml-mode")
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(require 'psvn)

(require 'color-theme)
(require 'zenburn)

(require 'tabbar)

(require 'htmlize)

(require 'two-mode-mode)

;; syntax highlighting by default (needs to be done before ruby-electric)
(global-font-lock-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ruby help
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ruby-electric)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))

(require 'arorem)

(defun ruby-newline-and-indent ()
  (interactive)
  (newline)
  (ruby-indent-command))

(if (= emacs-major-version 22)
    (progn
      (file-name-shadow-mode)
      (load "irc-stuff")
      (add-to-list 'hs-special-modes-alist
		   (list 'ruby-mode
			 (concat ruby-block-beg-re "\|{")
			 (concat ruby-block-end-re "\|}")
			 "#"
			 'ruby-forward-sexp nil)))
  ; so reveal-mode in my-ruby-mode-hook doesn't barf
  (defun reveal-mode() t))

(defun my-ruby-mode-hook ()
  (ruby-electric-mode)
  (hs-minor-mode)
  (reveal-mode)
  (local-set-key (kbd "RET") 'ruby-reindent-then-newline-and-indent))

(add-hook 'ruby-mode-hook 'my-ruby-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key "\C-x\C-h" 'help-command)
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-h" 'backward-kill-word)
(global-set-key "\M-g" 'goto-line)

; back to tabbar
(global-set-key [(control shift up)] 'tabbar-backward-group)
(global-set-key [(control shift down)] 'tabbar-forward-group)
(global-set-key [(control shift left)] 'tabbar-backward)
(global-set-key [(control shift right)] 'tabbar-forward)

(global-set-key [(control shift p)] 'tabbar-backward-group)
(global-set-key [(control shift n)] 'tabbar-forward-group)
(global-set-key [(control shift b)] 'tabbar-backward)
(global-set-key [(control shift f)] 'tabbar-forward)

(global-set-key [f1] 'menu-bar-mode)
(global-set-key [f9] '(lambda () 
			(interactive) 
			(ansi-term "/bin/bash")))

(global-set-key [f10] 'w3m)

(global-set-key [f2] 'color-theme-zenburn)
(global-set-key [(shift f2)] 'color-theme-standard)

(defvar ys-eshell-wins nil)
(global-set-key [f8] (lambda (win-num)
		       (interactive "p")
		       (message "win-num %s" win-num)
		       (let ((assoc-buffer (cdr (assoc win-num ys-eshell-wins))))
			 (if (not (buffer-live-p assoc-buffer))
			     (progn ; the requested buffer not there 
			       (setq assoc-buffer (eshell t))
			       (setq ys-eshell-wins (assq-delete-all win-num ys-eshell-wins))
			       (add-to-list 'ys-eshell-wins (cons win-num assoc-buffer))))
			 (switch-to-buffer assoc-buffer)
			 (rename-buffer (concat "*eshell-" (int-to-string win-num) "*"))
			 assoc-buffer)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     registers
; to load, C-x r j register-name
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; local .emacs
(set-register ?l '(file . "~/.emacs"))
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     misc things
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq font-lock-maximum-decoration t)
(blink-cursor-mode -1)
(auto-compression-mode 1) ; load .gz's automatically
(auto-image-file-mode 1) ; display images inline
(setq inhibit-startup-message t)
(setq transient-mark-mode t)
(show-paren-mode 1)
(mouse-wheel-mode 1) ; duh! this should be default.
(set-scroll-bar-mode 'right)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tabbar-mode)
(global-hl-line-mode)

(setq frame-title-format '(buffer-file-name "%f" ("%b")))

;; don't clutter directories!
(setq backup-directory-alist `(("." . ,(expand-file-name "~/.emacs.baks"))))
(setq auto-save-directory (expand-file-name "~/.emacs.baks"))

(setq browse-url-browser-function 'browse-url-epiphany)
(setq browse-url-epiphany-new-window-is-tab t)          ; for tab instead of new window.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    Nifty things to remember and hopefully use
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; M-z zap to char
; C-u C-SPC jump to previous edit
; M-/ autocomplete word 
; M-! insert output of shell command
; M-| replace region with shell output
; M-x thumbs
; C-r k Rectangle kill

; C-x h select all
; C-M-\ indent

; Macros
; C-m C-r to begin
; name it, and do stuff
; C-s to save

; temp macros
; C-m C-m to start recording
; C-m C-s to stop
; C-m C-p to play

; M-C-p, M-C-n back and forward blocks
; C-c C-s irb

(global-font-lock-mode t)