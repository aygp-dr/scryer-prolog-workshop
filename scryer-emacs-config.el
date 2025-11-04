;;; scryer-emacs-config.el --- Emacs configuration for Scryer Prolog Workshop
;;; Commentary:
;; This configuration sets up Emacs for Rust and Prolog development
;; with LSP support, org-mode integration, and useful utilities.
;;
;; Installation:
;; 1. Add to your ~/.emacs or ~/.emacs.d/init.el:
;;    (load-file "/path/to/scryer-emacs-config.el")
;; 2. Restart Emacs or evaluate the buffer
;; 3. Packages will be installed automatically on first run

;;; Code:

;; Initialize package system
(require 'package)

;; Add MELPA repository
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; Initialize package system
(package-initialize)

;; Update package archive contents if needed
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;;; ============================================================================
;;;; General Settings
;;;; ============================================================================

;; Disable startup message
(setq inhibit-startup-message t)

;; Show line numbers
(global-display-line-numbers-mode t)

;; Show column number in mode line
(column-number-mode t)

;; Enable syntax highlighting
(global-font-lock-mode t)

;; Show matching parentheses
(show-paren-mode t)

;; Auto-close brackets
(electric-pair-mode t)

;; Better scrolling
(setq scroll-conservatively 100)

;;;; ============================================================================
;;;; Org-Mode Configuration
;;;; ============================================================================

(use-package org
  :ensure t
  :config
  ;; Enable syntax highlighting in org code blocks
  (setq org-src-fontify-natively t)

  ;; Preserve indentation in code blocks
  (setq org-src-preserve-indentation t)

  ;; Don't ask for confirmation before evaluating code blocks
  (setq org-confirm-babel-evaluate nil)

  ;; Enable languages for babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (prolog . t)))

  ;; Use syntax highlighting in code blocks
  (setq org-src-tab-acts-natively t)

  ;; Org-mode key bindings
  (global-set-key (kbd "C-c l") 'org-store-link)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c c") 'org-capture))

;; Org-mode babel for tangling
(use-package ob-prolog
  :ensure nil
  :after org)

;;;; ============================================================================
;;;; Company Mode (Auto-completion)
;;;; ============================================================================

(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1
        company-tooltip-align-annotations t)
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)))

;;;; ============================================================================
;;;; Flycheck (Syntax checking)
;;;; ============================================================================

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;;;; ============================================================================
;;;; LSP Mode (Language Server Protocol)
;;;; ============================================================================

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init
  ;; Set prefix for lsp-command-keymap
  (setq lsp-keymap-prefix "C-c l")

  :config
  ;; Performance tuning
  (setq lsp-idle-delay 0.5
        lsp-enable-file-watchers nil
        lsp-enable-folding t
        lsp-enable-snippet t
        lsp-enable-symbol-highlighting t
        lsp-enable-text-document-color t)

  ;; Breadcrumb for current location
  (setq lsp-headerline-breadcrumb-enable t)

  :hook
  ((rust-mode . lsp-deferred)
   (prolog-mode . lsp-deferred)
   (lsp-mode . lsp-enable-which-key-integration)))

;; LSP UI - Enhanced UI for LSP
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-delay 0.5
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-diagnostics t)
  :bind (:map lsp-ui-mode-map
              ("C-c d" . lsp-ui-doc-show)
              ("C-c i" . lsp-ui-imenu)))

;; Company LSP integration
(use-package company-lsp
  :ensure nil  ;; Deprecated, but keeping for reference
  :commands company-lsp)

;;;; ============================================================================
;;;; Rust Configuration
;;;; ============================================================================

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :config
  ;; Format on save
  (setq rust-format-on-save t)

  ;; Set rustfmt path if needed
  ;; (setq rust-rustfmt-bin "~/.cargo/bin/rustfmt")

  :hook
  (rust-mode . lsp-deferred))

;; Cargo integration
(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode)
  :config
  (setq compilation-scroll-output t))

;; Rust playground for quick testing
(use-package rust-playground
  :ensure t
  :commands rust-playground)

;; Flycheck Rust integration
(use-package flycheck-rust
  :ensure t
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;;;; ============================================================================
;;;; Prolog Configuration
;;;; ============================================================================

(use-package prolog
  :ensure nil  ;; Built-in to Emacs
  :mode (("\\.pl\\'" . prolog-mode)
         ("\\.pro\\'" . prolog-mode))
  :config
  ;; Set Scryer Prolog as the default system
  (setq prolog-system 'scryer)

  ;; Set path to scryer-prolog executable
  (setq prolog-program-name "scryer-prolog")

  ;; Additional Prolog settings
  (setq prolog-indent-width 4)

  ;; Enable electric behavior
  (add-hook 'prolog-mode-hook
            (lambda ()
              (setq-local electric-indent-chars
                          (cons ?\. electric-indent-chars))))

  :hook
  (prolog-mode . lsp-deferred))

;; Enhanced Prolog mode (sweeprolog)
;; This provides better integration with Scryer Prolog
(use-package sweeprolog
  :ensure t
  :if (executable-find "scryer-prolog")
  :config
  (setq sweeprolog-prolog-server-program "scryer-prolog")
  :hook
  (prolog-mode . sweeprolog-mode))

;;;; ============================================================================
;;;; Project Management
;;;; ============================================================================

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map))
  :config
  (setq projectile-project-search-path
        '("~/ghq/github.com/" "~/projects/")))

;;;; ============================================================================
;;;; Git Integration
;;;; ============================================================================

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;;;; ============================================================================
;;;; Which-key (Show key bindings)
;;;; ============================================================================

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))

;;;; ============================================================================
;;;; Yasnippet (Template system)
;;;; ============================================================================

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

;;;; ============================================================================
;;;; Helpful UI Improvements
;;;; ============================================================================

;; Better help buffers
(use-package helpful
  :ensure t
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

;; Rainbow delimiters for better bracket visibility
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; Highlight current line
(use-package hl-line
  :ensure nil
  :config
  (global-hl-line-mode +1))

;;;; ============================================================================
;;;; Terminal Integration
;;;; ============================================================================

(use-package vterm
  :ensure t
  :if (eq system-type 'gnu/linux)
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

;;;; ============================================================================
;;;; Custom Functions
;;;; ============================================================================

(defun scryer-workshop-tangle-and-run ()
  "Tangle current org file and run the resulting Prolog file."
  (interactive)
  (when (eq major-mode 'org-mode)
    (org-babel-tangle)
    (message "Tangling complete! Use M-x run-prolog to start Scryer Prolog.")))

(defun scryer-workshop-setup ()
  "Check if required tools are installed."
  (interactive)
  (let ((tools '(("emacs" . "Emacs")
                 ("cargo" . "Rust/Cargo")
                 ("scryer-prolog" . "Scryer Prolog")
                 ("rust-analyzer" . "Rust Analyzer (LSP)")))
        (missing '()))
    (dolist (tool tools)
      (unless (executable-find (car tool))
        (push (cdr tool) missing)))
    (if missing
        (message "Missing tools: %s" (string-join missing ", "))
      (message "All required tools are installed!"))))

;;;; ============================================================================
;;;; Key Bindings
;;;; ============================================================================

;; Custom key bindings for workshop
(global-set-key (kbd "C-c w t") 'scryer-workshop-tangle-and-run)
(global-set-key (kbd "C-c w s") 'scryer-workshop-setup)
(global-set-key (kbd "C-c w p") 'run-prolog)

;;;; ============================================================================
;;;; Welcome Message
;;;; ============================================================================

(defun scryer-workshop-welcome ()
  "Display welcome message with useful information."
  (message "Scryer Prolog Workshop configuration loaded! Key bindings: C-c w t (tangle), C-c w s (check setup), C-c w p (run prolog)"))

;; Show welcome message after initialization
(add-hook 'after-init-hook #'scryer-workshop-welcome)

;;;; ============================================================================
;;;; File Associations
;;;; ============================================================================

;; Associate .pl files with Prolog mode (not Perl!)
(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))

;; Associate .org files with org-mode (should be default)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;;;; ============================================================================
;;;; Performance Optimizations
;;;; ============================================================================

;; Increase garbage collection threshold
(setq gc-cons-threshold (* 100 1024 1024))

;; Increase amount of data which Emacs reads from process
(setq read-process-output-max (* 1024 1024))

;;;; ============================================================================
;;;; Backup Settings
;;;; ============================================================================

;; Keep backup files in a dedicated directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Create backup directory if it doesn't exist
(unless (file-exists-p "~/.emacs.d/backups")
  (make-directory "~/.emacs.d/backups" t))

(provide 'scryer-emacs-config)
;;; scryer-emacs-config.el ends here
