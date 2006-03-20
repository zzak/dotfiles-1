;;;
;;;  arorem.el -
;;;
;;;  Another Ruby on Rails Emacs Mode
;;;  (C) 2006 Phil Hagelberg
;;;

;;; Motivation

;; Arorem is focused on helping with the task of editing. If you want
;; a very comprehensive Rails mode that handles webrick/mongrel,
;; searches documentation, and other things, you might want to look at
;; rails.el--https://opensvn.csie.org/mvision/emacs/.emacs.d/rails.el
;; Arorem is opinionated against mmm-mode, which seems to be more
;; trouble than it's worth. Rather than try to mix major modes on the
;; fly, it comes with an rhtml mode that is derived from html-mode and
;; includes ruby syntax rules. (heh--not yet implemented!)

;;; License

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.



(define-derived-mode arorem
  ruby-mode "arorem"
  "Another Ruby on Rails Emacs Mode"
  (abbrev-mode))

(require 'snippet)
(require 'arorem-rhtml)
(load "arorem-abbrevs")

(define-key arorem-map
  "\C-x\C-t" 'arorem-switch-test)
(define-key arorem-map
  "\C-x\C-v" 'arorem-switch-view)

(defun arorem-switch-view ()
  (interactive)
  (cond ((arorem-controller-p (buffer-file-name)) (arorem-controller-to-view))
	((arorem-view-p (buffer-file-name)) (arorem-view-to-controller))))

(defun arorem-controller-p (filename)
  (string-match "app/controllers/" filename))

(defun arorem-view-p (filename)
  (string-match "app/views/" filename))

(defun arorem-model-p (filename)
  (string-match "app/models/" filename))

(defun arorem-unit-p (filename)
  (string-match "test/unit/" filename))

(defun arorem-functional-p (filename)
  (string-match "test/functional" filename))

(defun arorem-controller-to-view ()
  (find-file (arorem-view-name-from-controller (buffer-file-name) 
					       (save-excursion
						 (search-backward "def ")
						 (forward-char 5)
						 (thing-at-point 'word)))))

(defun arorem-view-name-from-controller (controller action)
  (concat (rails-root)
	  "app/views/"
	  (substring (file-name-nondirectory controller) 0 -14)
	  "/"
	  action
	  ".rhtml"))

(defun arorem-view-to-controller ()
  (setq action (file-name-base (buffer-file-name)))
  (find-file (arorem-controller-name-from-view (buffer-file-name)))
  (beginning-of-buffer)
  (search-forward (concat "def " action))
  (recenter))

(defun arorem-controller-name-from-view (view)
  (concat (rails-root) 
	  "app/controllers/"
	   (file-name-nondirectory 
	    (expand-file-name (concat view "/..")))
	  "_controller.rb"))
  

(defun arorem-switch-test ()
  (interactive)
  (cond ((arorem-controller-p (buffer-file-name)) (arorem-controller-to-functional))
	((arorem-model-p (buffer-file-name)) (arorem-model-to-unit))
	((arorem-functional-p (buffer-file-name)) (arorem-functional-to-controller))
	((arorem-unit-p (buffer-file-name)) (arorem-unit-to-model))))
  
(defun arorem-controller-to-functional ()
  (find-file (concat (rails-root)
		     "test/functional/"
		     (file-name-base (buffer-file-name))
		     "_test.rb")))

(defun arorem-model-to-unit ()
  (find-file (concat (rails-root)
		     "test/unit/"
		     (file-name-base (buffer-file-name))
		     "_test.rb")))

(defun arorem-functional-to-controller ()
  (find-file (concat (rails-root)
		     "app/controllers/"
		     (substring (file-name-base (buffer-file-name)) 0 -5)
		     ".rb")))

(defun arorem-unit-to-model ()
  (find-file (concat (rails-root)
		     "app/models/"
		     (substring (file-name-base (buffer-file-name)) 0 -5)
		     ".rb")))


(defun rails-root (&optional dir)
  (or dir (setq dir default-directory))
  (if (file-exists-p (concat dir "config/environment.rb"))
      dir
    (if (equal dir  "/")
	nil
      (rails-root (expand-file-name (concat dir "../"))))))

(defun file-name-base (file-name)
  (file-name-sans-extension (file-name-nondirectory file-name)))

(provide 'arorem)

;;; TODO:
;; set up rails-specific highlighting?

;;; To consider:
;; extract helpers and partials
;; arorem-switch-helper?