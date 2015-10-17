(add-to-list 'load-path "~/.emacs.d/extra/")

;; set up package repository
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
(package-initialize)
(load-theme 'material t)

;;---------------------- simple config -------------------
(setq frame-title-format "%b - emacs")
(setq user-full-name "Yiqing Liu")
(setq user-mail-address "logicomiracle@gmail.com")

(setq backup-inhibited t)
(setq visible-bell t)
(setq inhibit-startup-message t)
(setq column-number-mode t)
(setq mouse-yank-at-point t)

(setq kill-ring-max 3000)
(setq undo-limit 536000000)
(setq default-fill-column 80)
(setq default-frame-alist '((height . 48)))
(setq browse-url-mozilla-program "firefox")


(tool-bar-mode 0)
(blink-cursor-mode 0)
(menu-bar-mode 1)

(setq-default indent-tabs-mode nil)
(setq default-tab-width 2)
(defun range (start end step)
	(cond
	 ((> start end) '())
	 (t (cons start (range (+ step start) end step)))))
(setq tab-stop-list (mapcar (lambda (x) (* default-tab-width x)) (range 1 40 1)))

(setq sentence-end "\\([¡££¡£¿]\\|¡­¡­\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)

(setq enable-recursive-minibuffers t)
(setq scroll-margin 3
      scroll-conservatively 10000)

(setq default-major-mode 'text-mode)
(show-paren-mode t)
(setq show-paren-style 'parentheses)
(mouse-avoidance-mode 'jump)

(auto-image-file-mode)
(global-font-lock-mode t)
(global-linum-mode t)

(setq version-control t)
(setq kept-new-versions 3)
(setq delete-old-versions t)
(setq kept-old-versions 2)
(setq dired-kept-versions 1)

(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)

(put 'erase-buffer 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)
(put 'add-hook 'lisp-indent-function 1)

;; display time
(setq display-time-24hr-format nil)
(display-time)

(when (member "DejaVu Sans Mono" (font-family-list))
    (add-to-list 'initial-frame-alist '(font . "DejaVu Sans Mono-10"))
    (add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-10")))

;; ------------------- language modes -------------------
(add-to-list 'auto-mode-alist '("\\.ss$" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.yin$" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.rkt$" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(add-to-list 'auto-mode-alist '("\\.el$" . emacs-lisp-mode))

;;---------------------- paredit-mode -------------------
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code."
  t)


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

(add-hook 'scheme-mode-hook
  (lambda ()
    (paredit-mode 1)
    (define-key scheme-mode-map (kbd "<f5>")
      'scheme-send-last-sexp-split-window)
    (define-key scheme-mode-map (kbd "<f6>")
      'scheme-send-definition-split-window)))
(put 'dired-find-alternate-file 'disabled nil)

