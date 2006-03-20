
(add-to-list 'auto-mode-alist '("\\.rhtml$" . arorem-rhtml))

(define-derived-mode arorem-rhtml
  html-mode "RHTML"
  "Another Ruby on Rails Emacs Mode (RHTML)"
  (abbrev-mode))

(define-key arorem-rhtml-map
  "\C-x\C-v" 'arorem-switch-view)


(provide 'arorem-rhtml)