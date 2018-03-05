;; From https://github.com/stuartsierra/dotfiles

(require 'smex)
(smex-initialize)

(global-set-key (kbd "H-<up>") 'previous-line)
(global-set-key (kbd "H-<down>") 'next-line)
(global-set-key (kbd "H-<right>") 'forward-char)
(global-set-key (kbd "H-<left>") 'backward-char)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; The original M-x
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Switch Windows like tabs
(global-set-key (kbd "M-<tab>") 'other-window)
(global-set-key (kbd "M-S-<tab>") (lambda () (interactive) (other-window -1)))

(setq echo-keystrokes 0.1)

(require 'ox-reveal)

;(eval-after-load 'ox ;; shouldn't be byte compiled.
;  '(when (and user-init-file (buffer-file-name)) ;; don't do it in async
;     (setq org-export-async-init-file
;           (expand-file-name "init-org-async.el" (file-name-directory
;                                                  user-init-file)))))
