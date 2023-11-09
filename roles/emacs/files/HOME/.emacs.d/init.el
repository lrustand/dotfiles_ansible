;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-terminal-cursor-changer
  :ensure t
  :config
  (unless (display-graphic-p)
          (require 'evil-terminal-cursor-changer)
          (evil-terminal-cursor-changer-activate)))

(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))

(use-package sly
  :ensure t
  :defer t)

(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-dark t))

(use-package dap-mode
  :ensure t)

(set-frame-font "DeJavu Sans Mono 10" nil t)

(use-package company
  :ensure t
  :config
  (global-company-mode 1))

(use-package magit
  :ensure t
  :defer t)

(use-package yasnippet
  :ensure t
  :config
  (setq yas-indent-line 'auto)
  (setq yas-also-auto-indent-first-line t)
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

(use-package yasnippets-latex
  :ensure t)

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-latex
  :ensure t
  :init
  (require 'lsp-latex)

  :config
  (add-hook 'tex-mode-hook 'lsp)
  (add-hook 'latex-mode-hook 'lsp)
  (add-hook 'LaTeX-mode-hook 'lsp)

  (setq lsp-latex-forward-search-executable "okular")
  (setq lsp-latex-forward-search-args '("--noraise" "--unique" "file:%p#src:%l%f"))
  (setq lsp-latex-build-forward-search-after t)
  (setq lsp-latex-build-on-save t)

  ;; For YaTeX
  (with-eval-after-load "yatex"
    (add-hook 'yatex-mode-hook 'lsp))

  ;; For bibtex
  (with-eval-after-load "bibtex"
    (add-hook 'bibtex-mode-hook 'lsp)))

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode 1))

;; Provides only the command “restart-emacs”.
(use-package restart-emacs
  :ensure t
  ;; If I ever close Emacs, it's likely because I want to restart it.
  :bind ("C-x C-c" . restart-emacs)
  ;; Let's define an alias so there's no need to remember the order.
  :config (defalias 'emacs-restart #'restart-emacs))

(use-package bitbake
  :ensure t
  :mode "bitbake-mode"
  :config
  (add-to-list 'auto-mode-alist '("\\.\\(bb\\|bbappend\\|bbclass\\|inc\\|conf\\)\\'" . bitbake-mode))
  (with-eval-after-load 'lsp-mode
    (add-to-list 'lsp-language-id-configuration
      '(bitbake-mode . "bitbake"))
    (lsp-register-client
      (make-lsp-client
      :new-connection (lsp-stdio-connection "bitbake-language-server")
      :activation-fn (lsp-activate-on "bitbake")
      :server-id 'bitbake)))

  (with-eval-after-load "bitbake-mode"
    (add-hook 'bitbake-mode-hook 'lsp)))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode 1)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(use-package tex
  :ensure auctex
  :config
  (setq-default TeX-master "main") ; All master files called "main".
  (setq TeX-view-program-list '(("Okular" "okular --noraise --unique file:%o#src%n%a")))
  (setq TeX-view-program-selection '((output-pdf "Okular"))))

(use-package git-gutter
  :ensure t
  :config
  (add-to-list 'git-gutter:update-hooks 'focus-in-hook)
  (setq git-gutter:hide-gutter t)
  (setq git-gutter:update-interval 2)
  (setq git-gutter:unchanged-sign " ")
  (defun set-git-gutter-background ()
    (set-face-background 'git-gutter:unchanged (face-attribute 'mode-line :background))
    (set-face-background 'git-gutter:modified (face-attribute 'mode-line :background))
    (set-face-background 'git-gutter:added (face-attribute 'mode-line :background))
    (set-face-background 'git-gutter:deleted (face-attribute 'mode-line :background)))
  (add-hook 'server-after-make-frame-hook 'set-git-gutter-background)
  (add-hook 'window-setup-hook 'set-git-gutter-background)
  (global-git-gutter-mode 1))

(use-package helm
  :ensure t
  :init
  (helm-mode 1)
  :bind (("M-x"     . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x C-r" . helm-recentf)
         ("C-h a"   . helm-apropos)))


(use-package bibtex-completion
  :ensure t
  :config
  (setq bibtex-completion-bibliography '("~/Documents/master/thesis/Ref.bib")
        bibtex-completion-library-path '("~/Documents/master/thesis/papers"
                                         "~/Documents/master/thesis/papers/ota"
                                         "~/Documents/master/thesis/papers/ota/implementations"
                                         "~/Documents/master/thesis/papers/security"
                                         "~/Documents/master/thesis/papers/identity"
                                         "~/Documents/master/thesis/papers/chain-of-trust")
        bibtex-completion-notes-path "~/Documents/master/thesis/"
        bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"

        bibtex-completion-additional-search-fields '(keywords)
        bibtex-completion-display-formats
        '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
          (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
          (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
        bibtex-completion-pdf-open-function
          (lambda (fpath)
            (call-process "okular" nil 0 nil fpath)))
  (defun my-open-citation-at-point ()
    (interactive) (bibtex-completion-open-pdf (list (thing-at-point 'symbol))))

  (with-eval-after-load "evil"
    (evil-define-key 'normal 'latex-mode-map "gp" 'my-open-citation-at-point)))

(use-package ace-window
  :ensure t
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package mu4e
  :init
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
  (require 'mu4e)

  :config
  (setq mu4e-maildir (expand-file-name "~/mail/gmail"))
  ;; use mu4e for e-mail in emacs
  (setq mail-user-agent 'mu4e-user-agent)

  ;; these must start with a "/", and must exist
  ;; (i.e.. /home/user/Maildir/sent must exist)
  ;; you use e.g. 'mu mkdir' to make the Maildirs if they don't
  ;; already exist

  ;; below are the defaults; if they do not exist yet, mu4e offers to
  ;; create them. they can also functions; see their docstrings.
  (setq mu4e-sent-folder   "/Sent Mail")
  (setq mu4e-drafts-folder "/Drafts")
  (setq mu4e-trash-folder  "/Trash"))

(use-package eat
  :ensure t
  :config
  (eat-eshell-mode)
  (setq eshell-visual-commands nil))

(use-package erc
  :custom
  (erc-fill-function 'erc-fill-static)
  (erc-fill-static-center 15)
  (erc-hide-list '("JOIN" "PART" "QUIT"))
  (erc-lurker-hide-list '("JOIN" "PART" "QUIT")))

(use-package erc-twitch
  :ensure t
  :after erc
  :config
  (erc-twitch-enable))

(use-package erc-hl-nicks
  :ensure t
  :after erc
  :config
  (erc-hl-nicks-enable))

(use-package erc-image
  :ensure t
  :after erc
  :config
  (erc-image-enable))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/org-roam")
  (org-roam-dailies-directory "dailies")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n i" . org-roam-node-insert)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies)
  (org-roam-setup))

(defun org-advance ()
  (interactive)
  (when (buffer-narrowed-p)
  (beginning-of-buffer)
  (widen)
  (org-forward-heading-same-level 1))
    (org-narrow-to-subtree))

(defun org-retreat ()
  (interactive)
  (when (buffer-narrowed-p)
    (beginning-of-buffer)
    (widen)
   (org-backward-heading-same-level 1))
   (org-narrow-to-subtree))

(setq backup-directory-alist '((".*" . "~/.emacs.d/backup")))
(setq create-lockfiles nil)

(setq x-select-enable-clipboard t)
(setq-default indent-tabs-mode nil)

(xterm-mouse-mode 1)
(savehist-mode 1)
(global-hl-line-mode 1)
(global-auto-revert-mode 1)
(save-place-mode 1)
(setq dired-listing-switches "-lAh --group-directories-first")
(recentf-mode 1)
(setq recentf-max-menu-items 25)

;; change all prompts to y or n
(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(defun set-line-number-background ()
  (set-face-background 'line-number (face-attribute 'mode-line :background)))
(add-hook 'server-after-make-frame-hook 'set-line-number-background)
(add-hook 'window-setup-hook 'set-line-number-background)

(windmove-default-keybindings)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(defun git-status ()
  (let ((default-directory (eshell/pwd)))
    (with-output-to-string
      (with-current-buffer standard-output
        (call-process "git" nil t nil "status" "--porcelain")))))

(defun git-status--dirty-p ()
  (not (string-blank-p (git-status))))

(add-hook 'eshell-mode-hook (lambda () (setenv "TERM" "xterm-256color"))) 
(setq eshell-prompt-function '(lambda () (concat
  "\n"
  ;;(propertize (if venv-current-name (concat " (" venv-current-name ")\n")  "") 'face `(:foreground "#00dc00"))
  (propertize (format-time-string "[%H:%M, %d/%m/%y]\n" (current-time)) 'face '(:foreground "green" :bold))
  (if (= (user-uid) 0)
    (propertize (user-login-name) 'face '(:foreground "red" :bold))
    (propertize (user-login-name) 'face '(:foreground "green" :bold)))
  (propertize "@" 'face `(:foreground "default" :bold))
  (propertize (system-name) 'face `(:foreground "green" :bold))
  (propertize (concat " [" (eshell/pwd) "]") 'face `(:foreground "default" :bold))
  (when (magit-get-current-branch)
      (propertize (concat " [" (magit-get-current-branch)) 'face `(:foreground "default" :bold)))
      (when (git-status--dirty-p) (propertize "*" 'face `(:foreground "red" :bold)))
      (propertize "]" 'face `(:foreground "default" :bold))
  (propertize "\n")
  (propertize " ->" 'face '(:foreground "blue" :bold))
  (propertize " " 'face '(:foreground "default" :bold))
  )))
(setq eshell-prompt-regexp " -> ")

(setq eshell-visual-commands (append eshell-visual-commands
  '("ipython"
    "nvim"
    "neomutt"
    "tmux")))

(defun highlight-selected-window ()
  "Highlight selected window with a different background color."
  (walk-windows (lambda (w)
                  (unless (eq w (selected-window))
                    (with-current-buffer (window-buffer w)
                      (buffer-face-set '(:background "#041f27"))))))
  (buffer-face-set 'default))
(add-hook 'buffer-list-update-hook 'highlight-selected-window)

(add-to-list 'default-frame-alist '(background-color . "unspecified-bg"))

(defun tmux-navigate-directions ()
  (let* ((x (nth 0 (window-edges)))
         (y (nth 1 (window-edges)))
         (w (nth 2 (window-edges)))
         (h (nth 3 (window-edges)))

         (can_go_up (> y 2))
         (can_go_down (<  (+ y h) (- (frame-height) 2)))
         (can_go_left (> x 1))
         (can_go_right (< (+ x w) (frame-width))))

    (send-string-to-terminal
     (format "\e]2;emacs %s #%s\a"
    (buffer-name)
        (string
          (if can_go_up    ?U 1)
          (if can_go_down  ?D 1)
          (if can_go_left  ?L 1)
          (if can_go_right ?R 1))))))

(unless (display-graphic-p)
  (add-hook 'buffer-list-update-hook 'tmux-navigate-directions))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" default))
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   '(auctex-lua lsp-latex company-auctex pyvenv ripgrep lsp-pyright evil-collection magit yasnippet-snippets yasnippet evil-terminal-cursor-changer projectile ivy helm-bibtex org-ref ag sly flycheck-package package-lint flycheck undohist ## xclip solarized-theme neotree treemacs xelb which-key vertico evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
