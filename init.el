(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

;; Add custom modes and then require them
(let ((default-directory "~/.emacs.d/modes/"))
  (normal-top-level-add-subdirs-to-load-path))

(require 'browse-only)
(require 'gcloud)
(require 'boolcase)

;; When I'm on Mac
(when (eq system-type 'darwin)
  (setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)
  ;; FIX ISPELL
  (setq ispell-program-name "aspell"))

;; Add my path to emacs
(exec-path-from-shell-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GENERAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; speed up movement apparently : https://emacs.stackexchange.com/a/28746/8964
(setq auto-window-vscroll nil)
;; no startup msg
(setq inhibit-startup-message t)
;; No bell noise, just blinking
(setq visible-bell t)
;; Make emacs fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; UTF-8 All Things!
(prefer-coding-system 'utf-8)
;; Uppercase is same as lowercase
(define-coding-system-alias 'UTF-8 'utf-8)
;; Hide tool bar, never use it
(tool-bar-mode -1)
;; Hide menu bar, never use it either
(menu-bar-mode -1)
;; Change yes or no to y or n, cause im lazy
(fset 'yes-or-no-p 'y-or-n-p)
;; auto refresh files when changed from disk
(global-auto-revert-mode t)
;; Show column number
(column-number-mode t)
;; Don't have backups, cause YOLO
(setq backup-inhibited t)
;; one line at a time
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
;; don't accelerate scrolling
(setq mouse-wheel-progressive-speed nil)
;; keyboard scroll one line at a time
(setq scroll-step 1)
;; Don't suspend emacs, so ANNOYING
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))
;; for all langs
(define-key global-map (kbd "C-c o") 'iedit-mode)
;; this saves typing
(define-key global-map (kbd "RET") 'newline-and-indent)
;; sometimes need this
(define-key global-map (kbd "C-j") 'newline)
;; For spacing problems
(global-set-key (kbd "M-\\") 'cycle-spacing)
;; Align lines to a symbol
(global-set-key (kbd "C-x \\") 'align-regexp)
;; Use ibuffer instead of default
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; Global electric mode, for matching closing parens, ect.
(electric-pair-mode)
;; echo to screen faster, cause why not
(setq echo-keystrokes 0.1)
;; Clean whitespace on save, pretty freken awesome
(add-hook 'before-save-hook 'whitespace-cleanup)
;; Aparently makefiles needs tabs, Booooooo
(add-hook 'makefile-mode 'indent-tabs-mode)
;; Stop cursor from going into minibuffer prompt text
(setq minibuffer-prompt-properties
      (quote (read-only t point-entered minibuffer-avoid-prompt
                        face minibuffer-prompt)))
;; Exactly what it sounds for
(show-paren-mode t)

;; For some reason this broke when upgrading to emacs 26.x
;;(set-face-background 'show-paren-match-face "#aaaaaa")
;; (set-face-attribute 'show-paren-match-face nil
;;                     :weight 'bold :underline nil :overline nil :slant 'normal)
;; (set-face-foreground 'show-paren-mismatch-face "red")
;; (set-face-attribute 'show-paren-mismatch-face nil
;;                     :weight 'bold :underline t :overline nil :slant 'normal)
;; make stuff pretty :D
(add-hook 'prog-mode-hook
          (lambda ()
            (push '(">=" . ?≥) prettify-symbols-alist)
            (push '("<=" . ?≤) prettify-symbols-alist)
            (push '("->" . ?→) prettify-symbols-alist)
            (rainbow-mode t)
            (rainbow-delimiters-mode)
            (flyspell-prog-mode)
            (subword-mode +1)))

;; Global mode for it
(global-prettify-symbols-mode +1)
(setq-default c-basic-offset 4 c-default-style "linux")
(setq-default indent-tabs-mode nil)
;; Default tab display is 4 spaces
(setq tab-width 4)
;; Don't save anything.
(setq auto-save-default nil)
;; show the function I'm in
(which-function-mode)
;;
(put 'upcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
;; C-x n <key> useful stuff
(put 'narrow-to-region 'disabled nil)
;; Sentences end with 1 space not 2. DIS IS 'MERIKA
(setq sentence-end-double-space nil)
;; If file doesn't end with a newline on save, automatically add one.
(setq require-final-newline t)

;; Works pretty good w/ some themes. When it doesn't, the line is barley
;; visible but I can live with that.
(global-hl-line-mode)

;; Strongly dislike this keybinding
;; (global-unset-key (kbd "C-x C-k RET"))

(put 'downcase-region 'disabled nil)

;; Load newer bytecode over older
(setq load-prefer-newer t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (delete-region
   (point)
   (progn
     (forward-word arg)
     (point))))

(defun my-backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (my-delete-word (- arg)))

(defun my-delete-line ()
  "Delete text from current position to end of line char.
This command does not push text to `kill-ring'."
  (interactive)
  (delete-region
   (point)
   (progn (end-of-line 1) (point)))
  (delete-char 1))

(defun my-delete-line-backward ()
  "Delete text between the beginning of the line to the cursor position.
This command does not push text to `kill-ring'."
  (interactive)
  (let (p1 p2)
    (setq p1 (point))
    (beginning-of-line 1)
    (setq p2 (point))
    (delete-region p1 p2)))

(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.
With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (completing-read "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(require 'iedit)

(defun iedit-dwim (arg)
  "Starts iedit but uses \\[narrow-to-defun] to limit its scope."
  (interactive "P")
  (if arg
      (iedit-mode)
    (save-excursion
      (save-restriction
        (widen)
        ;; this function determines the scope of `iedit-start'.
        (if iedit-mode
            (iedit-done)
          ;; `current-word' can of course be replaced by other
          ;; functions.
          (narrow-to-defun)
          (iedit-start (current-word) (point-min) (point-max)))))))

(defun my-next-sentence ()
  "Move point forward to the next sentence.
Start by moving to the next period, question mark or exclamation.
If this punctuation is followed by one or more whitespace
characters followed by a capital letter, or a '\', stop there. If
not, assume we're at an abbreviation of some sort and move to the
next potential sentence end"
  (interactive)
  (re-search-forward "[.?!]")
  (if (looking-at "[    \n]+[A-Z]\\|\\\\")
      nil
    (my-next-sentence)))

(defun my-last-sentence ()
  "Does the same as 'my-next-sentence' except it goes in reverse"
  (interactive)
  (re-search-backward "[.?!][   \n]+[A-Z]\\|\\.\\\\" nil t)
  (forward-char))

(defun set-transparency (onfocus notfocus)
  "Set the transparency for emacs"
  (interactive "nOn Focus: \nnOn Unfocus: ")
  (set-frame-parameter (selected-frame) 'alpha (list onfocus notfocus)))

(defun easy-camelcase (arg)
  (interactive "c")
  ;; arg is between a-z
  (cond ((and (>= arg 97) (<= arg 122))
         (insert (capitalize (char-to-string arg))))
        ;; If it's a new line
        ((= arg 13)
         (insert 10))
        ;; We probably meant a key command, so lets execute that
        (t (call-interactively
            (lookup-key (current-global-map) (char-to-string arg))))))

(defun easy-underscore (arg)
  (interactive "c")
  ;; arg is between a-z
  (cond ((and (>= arg 97) (<= arg 122))
         (insert (concat "_" (char-to-string arg))))
        ;; If it's a new line
        ((= arg 13)
         (insert 10))
        ;; We probably meant a key command, so lets execute that
        (t (call-interactively
            (lookup-key (current-global-map) (char-to-string arg))))))

(defun font-exists-p (font-name)
  (when (member font-name (font-family-list))
    t))

(require 's)
(defun remove-google-sdk-path ()
  (interactive)
  (let ((path-var (getenv "PATH")))
    (setq path-var (s-replace "/Users/gopar/Downloads/google-cloud-sdk/bin:" "" path-var))
    ))

(defun add-google-sdk-path ()
  (interactive)
  (let ((path-var (getenv "PATH")))
    (setq path-var (concat path-var ":/Users/gopar/Downloads/google-cloud-sdk/bin"))
    )
  )

;; bind them to emacs's default shortcut keys:
(global-set-key (kbd "C-S-k") 'my-delete-line-backward) ;; Ctrl+Shift+k
(global-set-key (kbd "C-k") 'my-delete-line)
(global-set-key (kbd "M-d") 'my-delete-word)
(global-set-key (kbd "C-;") 'iedit-dwim)
(global-set-key (kbd "<M-backspace>") 'my-backward-delete-word)
(global-set-key (kbd "M-e") 'my-next-sentence)
(global-set-key (kbd "M-a") 'my-last-sentence)
(global-set-key (kbd "C-x C-z") 'shell)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-mode
(require 'org)
;; Make sure we see syntax highlighting
(setq org-src-fontify-natively t
      ;; When we open a file, show all contents
      org-startup-folded nil
      ;; See down arrow instead of "..." when we have subtrees
      org-ellipsis "⤵"
      ;; Make source code indent to list or whatever.
      org-src-preserve-indentation nil
      org-edit-src-content-indentation 0)

(defun add-pcomplete-to-capf ()
  (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))

;; BULLETS BABY BULLETS
(add-hook 'org-mode-hook
          (lambda ()
            ;; (org-bullets-mode t)
            (flyspell-mode t)
            (toggle-truncate-lines -1)
            (toggle-word-wrap 1)
            (set (make-local-variable 'company-backends) '(company-dabbrev company-capf))
            (add-pcomplete-to-capf)))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((sql . t)
   (sqlite . t)
   (python . t)
   (java . t)
   (emacs-lisp . t)
   ;; Broke when upgrading to 26.1
   ;;(sh . t)
   ))


;; For syntax highlighting after export to PDF
;; Include the latex-exporter
(require 'ox-latex)
;; Add minted to the defaults packages to include when exporting.
(add-to-list 'org-latex-packages-alist '("" "minted"))
;; Tell the latex export to use the minted package for source
;; code coloration.
(setq org-latex-listings 'minted)
;; Let the exporter use the -shell-escape option to let latex
;; execute external programs.
;; This obviously and can be dangerous to activate!
(setq org-latex-pdf-process
      '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;; Extend the todo state tags
;;; The right side of | indicates the DONE states
(setq org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "AWAITING-FEEDBACK" "PR-UPDATE" "|" "DONE" "DELEGATED"))
      ;; Don't allow TODO's to close without their dependencies done
      org-enforce-todo-dependencies t
      ;; put timestamp when finished a todo
      org-log-done t
      ;; Indent the stars instead of piling them
      org-startup-indented t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flyspell
(require 'flyspell)
;; unbind flyspell key-binding
(define-key flyspell-mode-map (kbd "C-;") nil)
(setq flyspell-mode-line-string "")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpful
;; Note that the built-in `describe-function' includes both functions
;; and macros. `helpful-function' is functions only, so we provide
;; `helpful-callable' as a drop-in replacement.
(global-set-key (kbd "C-h f") #'helpful-callable)

(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; compact-docstrings
(add-hook 'prog-mode-hook #'compact-docstrings-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compilation mode
;; https://stackoverflow.com/questions/3072648/cucumbers-ansi-colors-messing-up-emacs-compilation-buffer
(require 'ansi-color)

;; Make the compilation window automatically disappear - from enberg on #emacs
(setq compilation-finish-function
      (lambda (buf str)
        (if (and (null (string-match ".*exited abnormally.*" str)) (null (string-match ".*interrupt.*" str)))
            ;;no errors, make the compilation window go away in a few seconds
            (progn
              (run-at-time
               "2 sec" nil '(lambda ()
                              (let ((buffer (get-buffer-window "*compilation*")))
                                (when buffer
                                  (quit-window nil buffer)))))
              (message "No Compilation Errors!")))))

(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; Remove these dam files
;; (add-hook 'compilation-start-hook '(shell-command "find . -regex '\(.*__pycache__.*\|*.py[co]\)' -delete"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Occur mode
(define-key occur-mode-map (kbd "<C-return>")
  '(lambda () (interactive)
     (occur-mode-goto-occurrence)
     (kill-buffer "*Occur*")
     (delete-other-windows)))

(define-key occur-mode-map (kbd "RET") 'occur-mode-goto-occurrence)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read only
;; (add-hook 'read-only-mode-hook 'viper-mode)
;; (remove-hook 'read-onlly-mode-hook 'viper-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company
(require 'cl)
(require 'company)
(require 'company-web-html)
(add-to-list 'company-backends 'company-yasnippet)
(add-to-list 'company-backends 'company-dabbrev)
(add-to-list 'company-backends 'company-web-html)

(setq company-idle-delay .1)
(setq company-minimum-prefix-length 1)
(setq company-selection-wrap-around t)
(setq company-dabbrev-downcase nil)
(setq company-lighter "")

(defun company-yasnippet-or-completion ()
  "Solve company yasnippet conflicts."
  (interactive)
  (let ((yas-fallback-behavior
         (apply 'company-complete-common nil)))
    (yas-expand)))

(add-hook 'company-mode-hook
          (lambda ()
            (substitute-key-definition
             'company-complete-common
             'company-yasnippet-or-completion
             company-active-map)))

;; on all buffers
(global-company-mode)

(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-mode-map (kbd "C-c SPC") 'company-complete)
(define-key company-mode-map (kbd "C-c C-SPC") 'company-yasnippet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Company-quickhelp
(require 'company-quickhelp)
(company-quickhelp-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Projectile
(require 'projectile)
;; Yes, yes, everywhere please
(projectile-global-mode)

;; Lighter, make it more compact
(setq projectile-mode-line
      '(:eval (format " Proj[%s]" (projectile-project-name))))

;; Ah the beaty in this
(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-ignored-projects '("~/.emacs.d/"))

(require 'helm-ag)
(define-key helm-ag-map (kbd ";") 'python-underscore)
(define-key helm-ag-edit-map (kbd ";") 'python-underscore)
(setq helm-ag-use-grep-ignore-list t)
(add-to-list 'grep-find-ignored-directories '"dist")
;; (setq projectile-indexing-method 'git)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(put 'projectile-project-run-cmd 'safe-local-variable (lambda (x) t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit

;; Disable built in version control
(setq vc-handled-backends nil)

(require 'magit)

(global-set-key (kbd "C-x g") 'magit-status)

;; Add an extra command where not to show mergers when logging
;; (magit-define-popup-switch 'magit-log-popup
;;   ?m "Omit merge commits" "--no-merge")

;; (magit-define-popup-option 'magit-commit-popup
;;   ?t "Insert file for commit msg" "--template=")


;; If the branch has a jira ticket, also add that on the commit message
(add-hook 'git-commit-setup-hook
          '(lambda ()
             (let ((has-ticket-title (string-match "^[A-Z]+-[0-9]+" (magit-get-current-branch)))
                   (words (s-split-words (magit-get-current-branch))))
               (if has-ticket-title
                   (insert (format "%s-%s " (car words) (car (cdr words))))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hydra, pretty freken awesome

(global-set-key
 (kbd "C-M-o")
 (defhydra hydra-window ()
   "window"
   ("j" windmove-left)
   ("k" windmove-down)
   ("i" windmove-up)
   ("l" windmove-right)
   ("b" balance-windows)
   ("a" (lambda ()
          (interactive)
          (ace-window 1)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body))
    "ace")
   ("v" (lambda ()
          (interactive)
          (split-window-right)
          (windmove-right))
    "vert")
   ("x" (lambda ()
          (interactive)
          (split-window-below)
          (windmove-down))
    "horz")
   ("s" (lambda ()
          (interactive)
          (ace-window 4)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body))
    "swap")
   ("d" (lambda ()
          (interactive)
          (ace-window 16)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body))
    "del")
   ("[" (lambda ()
          (interactive)
          (enlarge-window-horizontally 1)))
   ("]" (lambda ()
          (interactive)
          (shrink-window-horizontally 1)))
   ("{" (lambda ()
          (interactive)
          (enlarge-window 1)))
   ("}" (lambda ()
          (interactive)
          (enlarge-window -1)))
   ("o" delete-other-windows "1" :color blue)
   ("u" ace-maximize-window "a1" :color blue)
   ("q" nil "cancel")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Avy
(require 'avy)
(global-set-key (kbd "M-g c") 'avy-goto-char-2)
(global-set-key (kbd "M-g g") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eldoc
(require 'eldoc)
(setq eldoc-idle-delay 0.1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; electric-operator-modeRATE
(require 'electric-operator)
;; (electric-operator-add-rules-for-mode 'python-mode
;;   (cons "->" " -> "))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Corral for wrapping parens in non lisp modes
(global-set-key (kbd "M-9") 'corral-parentheses-backward)
(global-set-key (kbd "M-0") 'corral-parentheses-forward)
(global-set-key (kbd "M-[") 'corral-brackets-backward)
(global-set-key (kbd "M-]") 'corral-brackets-forward)
(global-set-key (kbd "M-\"") 'corral-single-quotes-backward)
(global-set-key (kbd "M-'") 'corral-single-quotes-forward)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; smex
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flycheck
(require 'flycheck)

(setq flycheck-mode-line "")
(define-key flycheck-mode-map (kbd "C-c C-n") #'flycheck-next-error)
(define-key flycheck-mode-map (kbd "C-c C-p") #'flycheck-previous-error)

;; Stop emacs from saying this is a dangerous variable
(put 'flycheck-python-mypy-args 'safe-local-variable (lambda (x) t))
(put 'flycheck-python-mypy-executable 'safe-local-variable (lambda (x) t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YASnippet
(require 'yasnippet)
(add-to-list 'yas-snippet-dirs "~/.emacs.d/mysnippets/")
(yas-global-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown
(require 'markdown-mode)
(add-hook 'markdown-mode-hook
          '(lambda ()
             (set (make-local-variable 'company-backends) '(company-dabbrev))
             (flyspell-mode 1)))

;; Small functions to help with creating blog posts
(defun insert-headers ()
     (interactive)
     (let ((file-name-list (s-split "-" (buffer-name)))
           (post-name "")
           (link-name ""))
       (insert "---\n")
       (insert "layout: post\n")
       (insert (format "date: %s-%s-%s\n"
                       (pop file-name-list)
                       (pop file-name-list)
                       (pop file-name-list)))
       (mapcar (lambda (x) (setq post-name (concat post-name " " (capitalize x))))
               file-name-list)
       (setq post-name (s-trim post-name))
       (setq post-name (s-chop-suffix ".Md" post-name))
       (insert (format "title: \"%s\"\n" post-name))
       (mapcar (lambda (x) (setq link-name (concat link-name "-" x)))
               file-name-list)
       (setq link-name (s-chop-prefix "-" link-name))
       (setq link-name (s-chop-suffix ".md" link-name))
       (insert (format "permalink: %s\n" link-name))
       (insert "categories:\n")
       (insert "---\n")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expand-Region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
;; Can overwrite characters that are highlighted. Thank God, for this
(pending-delete-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Icon Mode
;; (mode-icons-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'string-inflection)

(global-set-key (kbd "C-;") 'my-string-inflection-cycle-auto)

(defun my-string-inflection-cycle-auto ()
  "switching by major-mode"
  (interactive)
  (cond
   ;; for emacs-lisp-mode
   ((eq major-mode 'emacs-lisp-mode)
    (string-inflection-all-cycle))
   ;; for python
   ((eq major-mode 'python-mode)
    (string-inflection-python-style-cycle))
   ;; for java
   ((eq major-mode 'java-mode)
    (string-inflection-java-style-cycle))
   ;; for javascript
   (t
    ;; default
    (string-inflection-ruby-style-cycle))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cycle-quotes

(global-set-key (kbd "C-'") 'cycle-quotes)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm
(require 'helm-config)
(helm-mode)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ;; rebind tab to run persistent action

;; Helm-fy everything! This package is awesome
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x r b") #'helm-bookmarks)
(global-set-key (kbd "C-x m") #'helm-M-x)
(global-set-key (kbd "M-y") #'helm-show-kill-ring)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

;; For finding files
(define-key helm-find-files-map (kbd ";") '(lambda () (interactive) (insert "_")))

;; Use `helm-boring-file-regexp-list' to skip files when showing
(setq helm-ff-skip-boring-files t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm-Swoop
(require 'helm-swoop)
;; Keybindings
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; disable pre-input
(setq helm-swoop-pre-input-function
      (lambda () ""))

;; Match only for symbol
;; (setq helm-swoop-pre-input-function
;;       (lambda () (format "\\_<%s\\_> " (thing-at-point 'symbol))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; engine mode
(require 'engine-mode)
(engine-mode t)

(defengine github
  "https://github.com/search?ref=simplesearch&q=%s"
  :keybinding "v")

(defengine google
  "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
  :keybinding "g")

(defengine stack-overflow
  "https://stackoverflow.com/search?q=%s"
  :keybinding "s")

(defengine google-images
  "http://www.google.com/images?hl=en&source=hp&biw=1440&bih=795&gbv=2&aq=f&aqi=&aql=&oq=&q=%s"
  :keybinding "i")

(defengine youtube
  "http://www.youtube.com/results?aq=f&oq=&search_query=%s"
  :keybinding "y")

(defengine melps
  "http://melpa.org/#/%s"
  :keybinding "m")

(global-set-key (kbd "C-x / u") 'browse-url)
;; (global-set-key (kbd "C-x / f")
;;                 '(lambda ()
;;                    (interactive)
;;                    (browse-url-of-file (buffer-name))))
;; (global-set-key (kbd "C-x / j")
;;                 '(lambda ()
;;                    (interactive)
;;                    (browse-url-firefox (buffer-name))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elisp
(require 'header2)
 (defun elisp-occur-definitions ()
  "Show class and method definitions in a new buffer"
  (interactive)
  (let ((list-matching-lines-face nil))
    (occur "^(defun .*"))
  (let ((window (get-buffer-window "*Occur*")))
    (if window
        (select-window window)
      (switch-to-buffer "*Occur*"))))

(require 'paredit)
(setq paredit-lighter "")

(add-hook 'ielm-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook #'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (yas-minor-mode -1)
            (eldoc-mode)
            (auto-make-header)))

(define-key emacs-lisp-mode-map (kbd "M-.") 'find-function)
(define-key emacs-lisp-mode-map (kbd "C-c C-o") 'elisp-occur-definitions)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ielm
(add-hook 'ielm-mode-hook '(lambda () (set (make-local-variable 'company-backends) '(company-elisp))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python (elpy)
;; (add-to-list 'load-path "~/projs/projs/elpy")
;; (load "elpy")
(require 'elpy)
(require 'flycheck-mypy)
(elpy-enable)

(delete `elpy-module-flymake elpy-modules)
(pyvenv-tracking-mode)

(setq elpy-remove-modeline-lighter t)
;; Set timeout for backend rpc
(setq elpy-rpc-timeout 10)
(setq python-indent-offset 4)
;; Jedi is better completion but rope better refactoring
(setq elpy-rpc-backend "jedi")
(setq elpy-rpc-python-command "python")
(setq python-shell-interpreter "python")
(setq python-shell-interpreter-args "-B")
(setq elpy-test-discover-runner-command '("python" "-m" "unittest"))
;; Let's increase buffer size that elpy can do completion in
(setq elpy-rpc-ignored-buffer-size (* elpy-rpc-ignored-buffer-size 10))
;; dam errors
(setq python-shell-prompt-detect-failure-warning nil
      python-shell-completion-native nil
      python-shell-completion-native-disabled-interpreters '("pypy" "manage.py" "python"))
;; add mypy
(flycheck-add-next-checker 'python-flake8 'python-mypy)

(define-key elpy-mode-map (kbd "C-c C-n") #'flycheck-next-error)
(define-key elpy-mode-map (kbd "C-c C-p") #'flycheck-previous-error)

(define-key elpy-mode-map (kbd "<C-return>") nil)

(defun python-underscore (arg)
  (interactive "P")
  (if arg
      (insert ";")
    (insert "_")))

(defun gopar-python-setup ()
  ;; (interactive)
  (electric-operator-mode +1)
  (boolcase-mode +1)
  (flycheck-mode +1)
  (set (make-local-variable 'company-backends) '(elpy-company-backend)))

(define-key elpy-mode-map (kbd ";") 'python-underscore)
(define-key inferior-python-mode-map (kbd ";") 'python-underscore)

(add-hook 'inferior-python-mode-hook
          '(lambda ()
             (set (make-local-variable 'company-backends) '(company-capf))))
(add-hook 'elpy-mode-hook 'gopar-python-setup)

;; Experimental for elpy
;; C-c C-z takes back to previous py file buffer, but doing it again starts a new python shell buffer
(defun elpy-shell-switch-to-project-shell ()
  "Go to project Python shell with current project root already loaded in sys.path"
  (interactive)
  (let* ((buff-name-template "*Project Shell[%s]*")
         (proj-root (file-name-nondirectory (directory-file-name (elpy-project-root))))
         (buff-name (format buff-name-template proj-root)))
    ;; If buffer exists, lets just give it back
    (if (get-buffer buff-name)
        (pop-to-buffer buff-name)
      ;; Prep new project shell
      (pop-to-buffer (process-buffer (run-python (python-shell-calculate-command) t t)))
      (rename-buffer buff-name)
      (python-shell-send-string (format "import sys;sys.path.append('%s')" (elpy-project-root))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emmet-mode
(require 'emmet-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Web mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-engines-alist
      '(("django"  . "\\.html\\'")))

(defun web-mode-flyspefll-verify ()
  (let ((f (get-text-property (- (point) 1) 'face)))
    (not (memq f '(web-mode-html-attr-value-face
                   web-mode-html-tag-face
                   web-mode-html-attr-name-face
                   web-mode-doctype-face
                   web-mode-keyword-face
                   web-mode-function-name-face
                   web-mode-variable-name-face
                   web-mode-css-property-name-face
                   web-mode-css-selector-face
                   web-mode-css-color-face
                   web-mode-type-face)))))

(put 'web-mode 'flyspell-mode-predicate 'web-mode-flyspefll-verify)
(define-key web-mode-map (kbd "<return>") 'newline)

(add-hook 'web-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends) '(company-web-html company-dabbrev))
            (set (make-local-variable 'electric-pair-mode) 'nil)
            (set (make-local-variable 'yas-minor-mode) 'nil)
            (emmet-mode +1)
            ;; (company-web-angular+)
            ;; (company-web-bootstrap+)
            ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JS
(require 'js)
(require 'rjsx-mode)
(require 'flycheck-flow)
(require 'company-flow)

(setq company-flow-modes nil)
;; (setq flycheck-javascript-eslint-executable "")
(setq js-indent-level 2)
(setq js-switch-indent-offset 2)
;; remove any file name suffix associated with js-mode
(setq auto-mode-alist (rassq-delete-all 'js-mode auto-mode-alist))

(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(define-key rjsx-mode-map (kbd ";") 'easy-camelcase)

(add-to-list 'company-backends 'company-flow)
(add-hook 'rjsx-mode-hook 'flycheck-mode)
(add-hook 'rjsx-mode-hook
          '(lambda ()
            (set (make-local-variable 'company-backends) '(company-flow company-dabbrev))
            (prettier-js-mode)
            (emmet-mode)))


(flycheck-add-mode 'javascript-eslint 'rjsx-mode)
(flycheck-add-next-checker 'javascript-flow 'javascript-eslint)
(put 'flycheck-javascript-flow-executable 'safe-local-variable (lambda (x) t))
(put 'flycheck-javascript-eslint-executable 'safe-local-variable (lambda (x) t))
(put 'company-flow-executable 'safe-local-variable (lambda (x) t))

(defun flow-go-to-definition ()
  (interactive)
  (let* ((file (buffer-file-name))
          (line (number-to-string (line-number-at-pos)))
          (col (number-to-string (1+ (current-column))))
          (location (json-read-from-string
                     (shell-command-to-string (format "%s get-def --json %s %s %s"
                                                      flycheck-javascript-flow-executable file line col))))
          (path (alist-get 'path location))
          (line (alist-get 'line location))
          (offset-in-line (alist-get 'start location)))
     (if (> (length path) 0)
         (progn
           (xref-push-marker-stack)
           (find-file path)
           (goto-line line)
           (when (> offset-in-line 0)
             (forward-char (1- offset-in-line))))
       (message "Not found"))))

(define-key rjsx-mode-map (kbd "M-.") 'flow-go-to-definition)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; prettier (js formatter)
(require 'prettier-js)
(put 'prettier-js-command 'safe-local-variable (lambda (x) t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; java
(define-key java-mode-map (kbd ";") 'easy-camelcase)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Docker
(global-set-key (kbd "C-c d") 'docker)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS mode
(require 'css-mode)
(add-hook 'css-mode-hook
          '(lambda ()
             (rainbow-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'yaml-mode)

(define-key yaml-mode-map ";" 'python-underscore)

(add-hook 'yaml-mode-hook
          '(lambda () (set (make-local-variable 'company-backends) '(company-dabbrev company-capf))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'git-gutter)
;; Enable global minor mode
(global-git-gutter-mode t)
(setq git-gutter:update-interval 1)
(setq git-gutter:lighter "")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
(require 'fill-function-arguments)
(add-hook 'prog-mode-hook (lambda () (local-set-key (kbd "M-q") #'fill-function-arguments-dwim)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'diminish)

(defun remove-modelines ()
  (diminish 'highlight-indentation-mode)
  (diminish 'django-manage)
  (diminish 'boolcase-mode)
  (diminish 'yasnippet)
  (diminish 'rainbow-mode)
  (diminish 'company-mode)
  (diminish 'yas-minor-mode)
  (diminish 'projectile-mode)
  (diminish 'helm-mode)
  )
;; This should get rid of dam annoying minor modes always poping up
(add-hook 'change-major-mode-after-body-hook 'remove-modelines)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "M-+") 'shift-number-up)
(global-set-key (kbd "M-_") 'shift-number-down)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rand-theme

(require 'rand-theme)
(setq rand-theme-unwanted '(light-blue tao))
(setq colorless-themes '(tao-yang tao-yin nordless constant-light purp-light basic commentary white anti-zenburn))
(setq night-themes '(tao-yin nordless purp foggy-night metalheart))
(setq rand-theme-wanted night-themes)
(setq rand-theme-wanted colorless-themes)
(global-set-key (kbd "C-z") 'rand-theme-iterate)
(global-set-key (kbd "C-S-z") 'rand-theme-iterate-backwards)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Stuff that goes in the end :P

(find-file "~/.emacs.d/todo.org")
;; Move the custom stuff to another file
(setq custom-file "~/.emacs.d/ignoreme.el")
(load custom-file t)
(load-theme 'tao-yang)
(dimmer-mode)

(defun num-of-monitors ()
  (length (display-monitor-attributes-list)))

(if (font-exists-p "Hack")
    (let ((what-font-size-to-use nil))
      ;; At work, use a smaller font, when it's just the laptop use bigger font
      (setq what-font-size-to-use (if (> (num-of-monitors) 1) "Hack 11" "Hack 13"))
      (progn
        (add-to-list 'default-frame-alist `(font . ,what-font-size-to-use))
        (set-face-attribute 'default t :font what-font-size-to-use))
      (message "Unable to make default font biggger :(")))

;; (add-log-current-defun)
(python-shell-calculate-exec-path)
;; (require 'lsp)
;; (require 'lsp-clients)

;; (add-hook 'css-mode-hook #'lsp)
;; (add-hook 'web-mode-hook #'lsp)
;; (add-hook 'rjsx-mode-hook #'lsp)

;; (add-hook 'hack-local-variables-hook
;;           (lambda () (when (derived-mode-p 'rjsx-mode) (lsp))))

;; (require 'company-lsp)
;; (require 'lsp-ui)

(desktop-save-mode 1)
