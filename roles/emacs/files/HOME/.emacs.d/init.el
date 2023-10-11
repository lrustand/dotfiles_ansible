;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
;;(package-initialize)
;;(package-refresh-contents)

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

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
  :defer t
  :config
  (evil-collection-init))

(use-package evil-terminal-cursor-changer
  :ensure t)

(use-package which-key
  :ensure t
  :defer t
  :config
  (which-key-mode 1))

(use-package sly
  :ensure t
  :defer t)

(use-package xclip
  :ensure t
  :defer t
  :config
  (xclip-mode 1))

(use-package solarized-theme
  :ensure t)

(use-package dap-mode
  :ensure t
  :defer t)

(use-package company
  :ensure t
  :defer t
  :config
  (company-mode 1))

(use-package magit
  :ensure t
  :defer t)

(use-package yasnippet
  :ensure t
  :defer t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :defer t)

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode 1))

(use-package bitbake
  :ensure t
  :mode "bitbake-mode")

(use-package undo-tree
  :ensure t
  :defer t
  :config
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(setq x-select-enable-clipboard t)
(load-theme 'solarized-dark t)
(setq-default indent-tabs-mode nil)

(xterm-mouse-mode 1)
(savehist-mode 1)
(global-hl-line-mode 1)
(helm-mode 1)
(auto-revert-mode 1)
(save-place-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

(windmove-default-keybindings)
(require 'org-ref)
(require 'org-ref-helm)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)) 

(menu-bar-mode -1)
(unless (display-graphic-p)
        (require 'evil-terminal-cursor-changer)
        (evil-terminal-cursor-changer-activate) ; or (etcc-on)
        )
(defun highlight-selected-window ()
  "Highlight selected window with a different background color."
  (walk-windows (lambda (w)
                  (unless (eq w (selected-window))
                    (with-current-buffer (window-buffer w)
                      (buffer-face-set '(:background "#041f27"))))))
  (buffer-face-set 'default))
(add-hook 'buffer-list-update-hook 'highlight-selected-window)

(add-to-list 'default-frame-alist '(background-color . "unspecified-bg"))
;;(defun on-after-init ()
;;  (unless (display-graphic-p (selected-frame))
;;    (set-face-background 'default "unspecified-bg" (selected-frame))))
;;
;;(add-hook 'window-setup-hook 'on-after-init)

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

(add-hook 'buffer-list-update-hook 'tmux-navigate-directions)

(setq bibtex-completion-bibliography '("~/Documents/master/thesis/Ref.bib")
	bibtex-completion-library-path '("~/Documents/master/thesis/papers" "~/Documents/master/thesis/papers/ota" "~/Documents/master/thesis/papers/security" "~/Documents/master/thesis/papers/identity" "~/Documents/master/thesis/papers/chain-of-trust" )
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

(require 'lsp-latex)

(add-to-list 'TeX-view-program-list '("Okular" "okular --unique file:%o#src%n%a"))
(setq TeX-view-program-selection '((output-pdf "Okular")))

(add-hook 'tex-mode-hook 'lsp)
(add-hook 'LaTeX-mode-hook 'lsp)
(add-hook 'latex-mode-hook 'lsp)
	
(setq-default TeX-master "main") ; All master files called "main".

(setq lsp-latex-forward-search-executable "okular")
(setq lsp-latex-forward-search-args '("--unique" "file:%p#src:%l%f"))

;; For YaTeX
(with-eval-after-load "yatex"
 (add-hook 'yatex-mode-hook 'lsp))

;; For bibtex
(with-eval-after-load "bibtex"
 (add-hook 'bibtex-mode-hook 'lsp))

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
 (add-hook 'bitbake-mode-hook 'lsp))

(require 'mu4e)

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
(setq mu4e-trash-folder  "/Trash")

;;(slime-setup '(slime-fancy slime-quicklisp slime-asdf))
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