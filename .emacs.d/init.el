;;; init.el --- decitrig Emacs configuration

;;; Commentary:

;;; Code:
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)
(package-install-selected-packages)

(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file)

(require 'clang-format)
(require 'company)
(require 'flycheck)
(require 'go-mode)
(require 'google-c-style)
(require 'ido)
(require 'magit)
(require 'markdown-mode)
(require 'multi-term)
(require 'web-mode)

(ido-mode t)

(add-hook 'after-init-hook 'global-company-mode)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(global-set-key (kbd "C-c m t") #'multi-term)
(global-set-key (kbd "C-c g r") #'ff-find-other-file)
(global-set-key (kbd "C-c g f") #'clang-format-region)
(global-set-key (kbd "C-c g s") #'magit-status)

;;; Go Setup
(defvar decitrig--goroot "/usr/local/go/")
(setenv "GOROOT" decitrig--goroot)
(defvar decitrig--gopath "/Users/rwsims/go/")
(setenv "GOPATH" decitrig--gopath)

(setq gofmt-command "goimports")
(add-hook 'before-save-hook #'gofmt-before-save)

(defun decitrig--init-go-mode ()
  "Initialize go-mode with my preferences."
  (flycheck-mode)
  (setq tab-width 2))
(add-hook 'go-mode-hook #'decitrig--init-go-mode)

(add-to-list 'load-path (concat decitrig--gopath "src/github.com/dougm/goflymake"))
;;; (require 'go-flycheck)

(add-to-list 'load-path (concat decitrig--gopath "src/github.com/nsf/gocode/emacs/"))
;;; (require 'go-autocomplete)

(defun decitrig--clang-format-on-save ()
  (when (eq major-mode 'c++-mode)
    (clang-format-buffer)))

;;; C++ Setup
(defun decitrig--init-c-mode ()
  "Initialize 'c-mode' with my preferences."
  (flycheck-mode)
  (google-set-c-style)
  (add-hook 'after-save-hook 'decitrig--clang-format-on-save))

(add-hook 'c-mode-common-hook 'decitrig--init-c-mode)

;;; Org Mode Setup
(defun decitrig--init-org-mode ()
  "Initialize 'org-mode' with my preferences."
  (auto-fill-mode))

(add-hook 'org-mode-hook 'decitrig--init-org-mode)

;; Markdown mode Setup
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(defun decitrig--init-markdown-mode ()
  (auto-fill-mode)
  (set-fill-column 80))

(add-hook 'markdown-mode-hook #'decitrig--init-markdown-mode)

;; Web programming setupg
(add-to-list 'auto-mode-alist
	     '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist
	     '("\\.html\\'" . web-mode))

(defun decitrig--init-web-mode ()
  "Initialize 'web-mode' with my preferences"
  (setq tab-width 2)
  (setq indent-tabs-mode nil)
  (setq web-mode-markup-indent-offset 2))

(add-hook 'web-mode-hook #'decitrig--init-web-mode)

(defun decitrig--init-js2-mode ()
  "Initialize 'js2-mode' with my preferences"
  (setq tab-width 2)
  (setq fill-column 80)
  (setq show-trailing-whitespace t)
  (add-hook 'after-save-hook #'delete-trailing-whitespace)
  (setq indent-tabs-mode nil))

(add-hook 'js2-mode-hook #'decitrig--init-js2-mode)

(defun decitrig--init-json-mode ()
  "Initialize 'json-mode' with my preferences"
  (setq js-indent-level 2)
  (setq indent-tabs-mode nil))
(add-hook 'json-mode-hook #'decitrig--init-json-mode)

(defun decitrig--init-typescript-mode ()
  "Initialize typescript-mdode"
  (tide-setup)
  (flycheck-mode +1)
  (local-set-key (kbd "M-j") 'c-indent-new-comment-line)
  ; (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (company-mode-on))
(add-hook 'typescript-mode-hook #'decitrig--init-typescript-mode)

(setenv "PATH" (mapconcat 'identity
			  (list "/usr/local/bin"
				(concat decitrig--goroot "bin")
				(concat decitrig--gopath "bin")
				"/Users/rwsims/.npm-packages/bin"
				(getenv "PATH")) ":"))

(add-to-list 'exec-path (concat decitrig--gopath "bin"))
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/Users/rwsims/.npm-packages/bin")

(provide 'init)
;;; init.el ends here
