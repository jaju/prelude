;; Copyright (C) 2015 Ravindra R. Jaju

;; Author: Ravindra Jaju - https:/msync.org/

(require 'org)
(setq org-agenda-files '("~/.org/agenda" "~/.org/notes"))
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t) ;; This sets timestamps on tasks when finished.
(setq org-startup-indented t)
(setq org-src-fontify-natively t)
(setq org-todo-keywords
      '((sequence "TODO" "FEEDBACK" "VERIFY" "|" "DONE" "DELEGATED")))
(setq org-default-notes-file "~/.org/on-the-fly-notes.org")
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-cr" 'remember)

;; BEGIN -- https://github.com/stuartsierra/dotfiles
;; Org-babel and Clojure
(require 'ob-clojure)
(require 'cider)
(setq org-babel-clojure-backend 'cider)

;; And Python, JS
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (js . t)))



;; More from http://fgiasson.com/blog/index.php/2016/04/05/using-clojure-in-org-mode-and-implementing-asynchronous-processing/
;(org-defkey org-mode-map "\C-x\C-e" 'cider-eval-last-sexp)
;(org-defkey org-mode-map "\C-c\C-d" 'cider-doc)
;; END

(require 'ox-publish)
(require 'ox-hugo)
(setq org-html-html5-fancy t)
(setq org-src-tab-acts-natively t)

(setq org-reveal-root "http://p.msync.org/reveal.js")
(define-skeleton org-presentation-skeleton
  "Inserts org directives for org buffers supposed to generate a slide-show presentation, using reveal.js"
  "Title: "
  "#+Title: " str "\n"
  "#+Author: Ravindra R. Jaju\n"
  "#+Email: first-name -dot- last-name -at- the-world's-email-domain\n"
  "#+FILETAGS: :sometag:\n"
  "#+SETUPFILE: ~/.org/presentations/settings.org\n"
  "\n"
  )

(define-skeleton org-slide-skeleton
  "Inserts org slide with directive for a tangled source-code"
  "Title: "
  "* " str
  "\n"
  @ -
  "#+BEGIN_SRC java :results silent\n"
  "\n"
  "#+END_SRC"
  "\n"
  "#+BEGIN_NOTES"
  "\n"
  "#+END_NOTES")

(setq hugo-base-dir "~/Projects/hugo-blog")
(define-skeleton org-blog-skeleton
  "Inserts the right directives for hugo-orgmode blogging"
  "Title: "
  "#+HUGO_BASE_DIR: " hugo-base-dir "\n"
  "#+HUGO_SECTION: posts/" (format-time-string "%Y") "\n"
  "#+AUTHOR: Ravindra R. Jaju\n"
  "#+OPTIONS: toc:nil num:nil\n"
  "\n"
  "#+HUGO_TAGS: []\n"
  "#+Title: " str "\n"
  "#+HUGO_CUSTOM_FRONT_MATTER: :abstract <Modify me>\n"
  "#+date: " (now) "\n"
  "#+lastmod: " (now) "\n"
  "#+published: false\n"
  "\n")

(setq org-publish-project-alist
      '(
        ("org-blog.msync.org"
         :base-directory "~/.org/blog"
         :base-extension "org"
         :publishing-directory "~/Projects/hugo-blog/content"
         :recursive t
         :publishing-function org-hugo-export-to-md
         :headline-levels 4
         :html-extension "html"
         :body-only t)

        ("org-static-blog.msync.org"
         :base-directory "~/.org/blog"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/Projects/blog"
         :recursive t
         :publishing-function org-publish-attachment)

        ("msync"
         :components ("org-blog.msync.org" "org-static-blog.msync.org"))

        ("msync-presentation"
         :base-directory "~/.org/presentations"
         :publishing-directory "~/Projects/hugo-blog/content/presentation"
         :recursive t
         :base-extension "org"
         :html-extension "html"
         :headline-levels 4
         :publishing-function org-reveal-export-to-html)))

(custom-set-variables
 '(org-display-custom-times t)
 '(org-time-stamp-custom-formats "%Y-%m-%dT%T%:z"))

(defun now ()
  (interactive)
  (insert (format-time-string "%Y-%m-%dT%T%:z")))
(global-set-key (kbd "C-c C-t .") 'now)

(define-key global-map (kbd "<f9>") (lambda () (interactive) (org-hugo-export-to-md)))

;(eval-after-load 'ox ;; shouldn't be byte compiled.
;		 '(when (and user-init-file (buffer-file-name)) ;; don't do it in async
;		    (setq org-export-async-init-file
;			  (expand-file-name "org-async-init.el" (file-name-directory
;								  user-init-file)))))
