(require 'package)

(setq emacs-directory "~/.emacs.d/")


(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat)))
 '(custom-safe-themes
   (quote
    ("f56eb33cd9f1e49c5df0080a3e8a292e83890a61a89bceeaa481a5f183e8e3ef" default)))
 '(package-selected-packages
   (quote
    (evil-magit magit dashboard all-the-icons org-bullets auto-complete use-package evil-collection which-key eyebrowse helpful zenburn-theme)))
 '(send-mail-function (quote mailclient-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#242424" :foreground "#f6f3e8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "nil" :family "Source Code Pro")))))

;; Helpful https://github.com/Wilfred/helpful
;;
;; Note that the built-in `describe-function' includes both functions
;; and macros. `helpful-function' is functions only, so we provide
;; `helpful-callable' as a drop-in replacement.
(global-set-key (kbd "C-h f") #'helpful-callable)

(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)

;; Lookup the current symbol at point. C-c C-d is a common keybinding
;; for this in lisp modes.
(global-set-key (kbd "C-c C-d") #'helpful-at-point)

;; Look up *F*unctions (excludes macros).
;;
;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
;; already links to the manual, if a function is referenced there.
(global-set-key (kbd "C-h F") #'helpful-function)

;; Look up *C*ommands.
;;
;; By default, C-h C is bound to describe `describe-coding-system'. I
;; don't find this very useful, but it's frequently useful to only
;; look at interactive functions.
(global-set-key (kbd "C-h C") #'helpful-command)
;;

(setq next-line-add-newlines t)

(require 'eyebrowse)

(require 'use-package)

;; evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))
;;

;; menu bar
;; disable stuff...
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; change the colour
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
;;

;; whick-key
(require 'which-key)
(which-key-mode)
;;

;; org config
;;; Load the config
(org-babel-load-file (concat user-emacs-directory "settings.org"))

;; org-bullets
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))


;; line-numbers
(setq display-line-numbers 'visual)
(setq global-display-line-numbers-mode 'visual)

;; personal information
(setq user-full-name "Jordan Chalupka"
      user-mail-address "jordanchalupka@me.com")

;; (setq initial-buffer-choice
;;      (concat user-emacs-directory "start.org"))


;; font
(set-default-font "Menlo 14")

(require 'all-the-icons)

;; Highlight corresponding parentheses when cursor is on one
(setq show-paren-delay 0) ;; shows matching parenthesis asap
(show-paren-mode t)


;; Highlight Current Line
(add-hook 'after-init-hook 'global-hl-line-mode)

;; org-babel load languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((js . t )
   (emacs-lisp . t)))


(setq-default frame-background-mode 'dark)

;; Dashboard
(defun my/dashboard-banner ()
  """Set a dashboard banner including information on package initialization
   time and garbage collections."""
  (setq dashboard-banner-logo-title "Jordan Chalupka's Emacs")
  (setq dashboard-center-content t)
  (setq dashboard-set-footer nil)
  (setq dashboard-show-shortcuts nil)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq show-week-agenda-p t)
  (setq dashboard-items
	'((recents . 5)
	  (agenda)
	  )))

(use-package dashboard
  :init
  (add-hook 'after-init-hook 'dashboard-refresh-buffer)
  (add-hook 'dashboard-mode-hook 'my/dashboard-banner)
  :config
  (setq dashboard-startup-banner 'logo)
  (dashboard-setup-startup-hook))
;;

(global-set-key (kbd "C-c j") (lambda () (interactive) (find-file (concat user-emacs-directory "init.el"))))

;; eval the current region or buffer
(defun eval-region-or-buffer ()
  (interactive)
  (let ((debug-on-error t))
    (cond
     (mark-active
      (call-interactively 'eval-region)
      (message "Region evaluated!")
      (setq deactivate-mark t))
     (t
      (eval-buffer)
      (message "Buffer evaluated!")))))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (local-set-key (kbd "C-x e") 'eval-region-or-buffer)))
;;





(setq org-agenda-include-diary t)

;; change backup directory
(setq backup-directory-alist `(("." . "~/.saves")))
; note: this may be too slow.  Maybe look into `backup-by-copying-when-linked` in the future
; (setq backup-by-copying t)



