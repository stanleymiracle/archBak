;;---------------------- the magic path ------------------
(add-to-list 'load-path "~/.emacs.d/extra")

;; set up package repository
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

;; set default theme
;(load-theme 'autumn-light t)

;; display time
(setq display-time-24hr-format nil)
(display-time)

;; set default font
(when (member "DejaVu Sans Mono" (font-family-list))
    (add-to-list 'initial-frame-alist '(font . "DejaVu Sans Mono-10"))
    (add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-10")))

;; set window size
;(setq default-frame-alist
;      '((height . 47)
;        (width  . 83)))

;; line number mode
(global-linum-mode t)


;; --------------------- Boolean Settings ---------------------
;(tool-bar-mode 0)
(blink-cursor-mode 0)
(menu-bar-mode 1)
(setq column-number-mode t)
(global-font-lock-mode t)
(global-auto-revert-mode t)
(setq visible-bell t)
(setq inhibit-startup-message t)
(setq mouse-yank-at-point t)
(setq enable-recursive-minibuffers nil)
(auto-image-file-mode)
(setq require-final-newline nil)
(setq mode-require-final-newline nil)
(setq transient-mark-mode t)
(setq x-select-enable-clipboard t)
(setq truncate-partial-width-windows nil)
(setq backup-inhibited t)
(setq vc-handled-backends nil)
(setq-default visual-line-mode t)
(set-language-environment "utf-8")


;; ------------------------- value settings -----------------------
(setq frame-title-format "%b - emacs")
(setq user-full-name "Yiqing Liu")
(setq user-mail-address "stanleyxmiracle@gmail.com")

(setq kill-ring-max 3000)
(setq undo-limit 536000000)
(setq default-fill-column 80)
(setq browse-url-mozilla-program "firefox")

(setq default-major-mode 'text-mode)
(show-paren-mode t)
(setq show-paren-style 'parentheses)
(mouse-avoidance-mode 'jump)

(setq-default indent-tabs-mode nil)
(setq default-tab-width 2)
(defun range (start end step)
  (cond
   ((> start end) '())
   (t (cons start (range (+ step start) end step)))))

(setq tab-stop-list
      (mapcar (lambda (x) (* default-tab-width x)) (range 1 40 1)))

(setq sentence-end "\\([¡££¡£¿]\\|¡­¡­\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)

(put 'erase-buffer 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)
(put 'add-hook 'lisp-indent-function 1)

(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)

(setq completion-ignored-extensions
      (append completion-ignored-extensions (list ".exe" ".manifest" ".hi")))


;; ------------------------- global keys ---------------------------

;; disable minimize window
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-a"))
(global-unset-key (kbd "s-q"))
(global-unset-key (kbd "C-X C-Z"))
(global-unset-key (kbd "M-R"))

;; Useful Comment commands
(defun comment-defun ()
  (interactive)
  (mark-defun)
  (comment-region (region-beginning)
                  (region-end)))

(defun comment-box-defun (arg)
  (interactive "p")
  (mark-defun)
  (comment-box (region-beginning)
               (region-end)
               (prefix-numeric-value arg)))

(setq bookmark-save-flag 1)
(setq bookmark-default-file "~/.emacs.d/bookmarks")
(global-set-key (kbd "<f2>") 'pop-tag-mark)

(global-set-key (kbd "C-c C-c") 'copy-to-register)
(global-set-key (kbd "C-c C-v") 'insert-register)

(global-set-key (kbd "<f9>") 'narrow-to-region)
(global-set-key (kbd "<C-f9>") 'widen)

(global-set-key (kbd "<C-f12>") 'comment-defun)
(global-set-key (kbd "<f12>") 'comment-or-uncomment-region)

(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "s-g") 'goto-char)

(global-set-key (kbd "M-/") 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-line))

;; windmove keys
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

;; ------------------- window switchers -------------------
(global-set-key (kbd "C-n") 'other-window)
(global-set-key (kbd "C-p") 'other-window-backward)

(defun other-window-backward (n)
  "Select the previous window"
  (interactive "p")
  (other-window (- n)))

;; ------------------ window scrolling -------------------
(defalias 'scroll-ahead 'scroll-up)
(defalias 'scroll-behind 'scroll-down)

(defun scroll-n-lines-ahead (&optional n)
  (interactive "P")
  (scroll-ahead (prefix-numeric-value n)))

(defun scroll-n-lines-behind (&optional n)
  (interactive "P")
  (scroll-behind (prefix-numeric-value n)))

(global-set-key (kbd "C-q") 'scroll-n-lines-behind)
(global-set-key (kbd "C-a") 'scroll-n-lines-ahead)


;; ------------------- language modes -------------------
(add-to-list 'auto-mode-alist '("\\.ss$" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.yin$" . yin-mode))
(add-to-list 'auto-mode-alist '("\\.rkt$" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(add-to-list 'auto-mode-alist '("\\.el$" . emacs-lisp-mode))

;; Whitespace
(require 'whitespace)
(global-whitespace-mode 1)
;; (setq whitespace-action '(auto-cleanup)) ;; automatically clean up bad whitespace
(setq whitespace-style
      '(trailing space-before-tab indentation empty space-after-tab))

;;---------------------- paredit-mode -------------------
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code."
  t)

;;---------------------- parenface-mode -----------------
(defvar paren-face 'paren-face)

(defface paren-face
    '((((class color))
       (:foreground "DimGray")))
  "Face for displaying a paren."
  :group 'faces)

(defmacro paren-face-add-support (keywords)
  "Generate a lambda expression for use in a hook."
  `(lambda ()
     (let* ((regexp "(\\|)\\|\\[\\|\\]\\|{\\|}")
            (match (assoc regexp ,keywords)))
       (unless (eq (cdr match) paren-face)
         (setq ,keywords (cons (cons regexp paren-face) ,keywords))))))

(add-hook 'yin-mode-hook              (paren-face-add-support yin-font-lock-keywords))
(add-hook 'scheme-mode-hook           (paren-face-add-support scheme-font-lock-keywords-2))
(add-hook 'lisp-mode-hook             (paren-face-add-support lisp-font-lock-keywords-2))
(add-hook 'emacs-lisp-mode-hook       (paren-face-add-support lisp-font-lock-keywords-2))
(add-hook 'lisp-interaction-mode-hook (paren-face-add-support lisp-font-lock-keywords-2))

(provide 'parenface)

(set-face-foreground 'paren-face "DimGray")
;;---------------------- Scheme -------------------

(require 'cmuscheme)
(setq scheme-program-name "petite")


;; bypass the interactive question and start the default interpreter
(defun scheme-proc ()
  "Return the current Scheme process, starting one if necessary."
  (unless (and scheme-buffer
               (get-buffer scheme-buffer)
               (comint-check-proc scheme-buffer))
    (save-window-excursion
      (run-scheme scheme-program-name)))
  (or (scheme-get-process)
      (error "No current process. See variable `scheme-buffer'")))


(defun scheme-split-window ()
  (cond
   ((= 1 (count-windows))
    (delete-other-windows)
    (split-window-vertically (floor (* 0.68 (window-height))))
    (other-window 1)
    (switch-to-buffer "*scheme*")
    (other-window 1))
   ((not (find "*scheme*"
               (mapcar (lambda (w) (buffer-name (window-buffer w)))
                       (window-list))
               :test 'equal))
    (other-window 1)
    (switch-to-buffer "*scheme*")
    (other-window -1))))


(defun scheme-send-last-sexp-split-window ()
  (interactive)
  (scheme-split-window)
  (scheme-send-last-sexp))


(defun scheme-send-definition-split-window ()
  (interactive)
  (scheme-split-window)
  (scheme-send-definition))

(defun scheme-send-region-split-window ()
  (interactive)
  (mark-whole-buffer)
  (scheme-split-window)
  (scheme-send-region (mark) (point)))

(global-prettify-symbols-mode 1)

(defun pretty-lambda ()
  (setq prettify-symbols-alist
        '(("lambda" . 955))))
(add-hook 'scheme-mode-hook 'pretty-lambda)

(add-hook 'scheme-mode-hook
  (lambda ()
    (paredit-mode 1)
    (define-key scheme-mode-map (kbd "C-c C-c")
      'copy-to-register)
    (define-key scheme-mode-map (kbd "<f5>")
      'scheme-send-last-sexp-split-window)
    (define-key scheme-mode-map (kbd "<f6>")
      'scheme-send-definition-split-window)
    (define-key scheme-mode-map (kbd "<f7>")
      'scheme-send-region-split-window)))

(put 'dired-find-alternate-file 'disabled nil)
