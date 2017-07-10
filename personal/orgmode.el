;; Copyright (C) 2015 Ravindra R. Jaju

;; Author: Ravindra Jaju
;; URL: http://blog.msync.in/

;;; Code:

(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(define-key global-map (kbd "<f9>") (lambda () (interactive) (cd "~/.org/blog")))
(define-key global-map (kbd "<f10>") (lambda () (interactive) (org-publish-project "msync")))
(define-key global-map (kbd "<f11>") (lambda () (interactive) (org-publish-project "msync-presentation")))

(setq org-agenda-files '("~/.org/agenda" "~/.org/notes"))
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

;; More from http://fgiasson.com/blog/index.php/2016/04/05/using-clojure-in-org-mode-and-implementing-asynchronous-processing/
(org-defkey org-mode-map "\C-x\C-e" 'cider-eval-last-sexp)
(org-defkey org-mode-map "\C-c\C-d" 'cider-doc)
;; END

(setq org-html-html5-fancy t)
(setq org-src-tab-acts-natively t)

(setq org-reveal-root "/js/reveal.js")
(define-skeleton org-presentation-skeleton
  "Inserts org directives for org buffers supposed to generate a slide-show presentation, using reveal.js"
  "Title: "
  "#+Title: " str "\n"
  "#+Author: Ravindra R. Jaju\n"
  "#+Email: first-name -dot- last-name -at- the-world's-email-domain\n"
  "\n"
  "#+TAGS: example(e) video(v) discuss(d) improve(i) fixme(f) quiz(q) exercise(x)\n"
  "#+OPTIONS: reveal_center:t reveal_progress:t reveal_history:nil reveal_control:t\n"
  "#+OPTIONS: reveal_rolling_links:t reveal_keyboard:t reveal_overview:t num:nil\n"
  "#+OPTIONS: reveal_width:1200 reveal_height:800\n"
  "#+OPTIONS: toc:1\n"
  "#+REVEAL_MARGIN: 0.1\n"
  "#+REVEAL_MIN_SCALE: 0.5\n"
  "#+REVEAL_MAX_SCALE: 2.5\n"
  "#+REVEAL_TRANS: cube\n"
  "#+REVEAL_THEME: moon\n"
  "#+REVEAL_HLEVEL: 2\n"
  "#+REVEAL_HEAD_PREAMBLE: <meta name='description' content=''>\n"
  "#+REVEAL_POSTAMBLE: <p>Created by Ravindra R. Jaju.</p>\n"
  "#+REVEAL_PLUGINS: (markdown notes)\n"
  "#+REVEAL_EXTRA_CSS: ./local.css\n"
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

;; For jekyll publishing - blog.msync.in
(require 'ox-publish)

(setq org-publish-project-alist
      '(
        ("org-blog.msync.in"
         :base-directory "~/.org/blog"
         :base-extension "org"
         :publishing-directory "~/Projects/blog/jekyll"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :html-extension "html"
         :body-only t)

        ("org-static-blog.msync.in"
         :base-directory "~/.org/blog"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/Projects/blog"
         :recursive t
         :publishing-function org-publish-attachment)

        ("msync"
         :components ("org-blog.msync.in" "org-static-blog.msync.in"))

        ("msync-presentation"
         :base-directory "~/.org/presentations"
         :publishing-directory "~/Projects/blog/jekyll/_presentation"
         :recursive t
         :base-extension "org"
         :html-extension "html"
         :headline-levels 4
         :publishing-function org-reveal-export-to-html)))

(define-skeleton org-blog-skeleton
  "Inserts the right directives for jekyll-orgmode blogging"
  "Title: "
  "#+OPTIONS: toc:nil num:nil\n"
  "#+BEGIN_HTML\n"
  "---\n"
  "layout: post\n"
  "title: " str "\n"
  "author: Ravindra R. Jaju\n"
  "excerpt: \n"
  "created_at: \n"
  "categories: \n"
  "permalink: /blog/:year/:month/:day/:title.html\n"
  "published: false\n"
  "---\n"
  "#+END_HTML\n\n"
  "#+INFOJS_OPT: path:/js/org-info.js toc:nil ltoc:t up:/ home:/\n"
  "; view options are - info, overview, content, showall\n"
  "#+INFOJS_OPT: view:content\n"
  "\n")

(custom-set-variables
 '(org-display-custom-times t)
 '(org-time-stamp-custom-formats (quote ("<%a, %Y-%m-%d>" . "<%Y-%m-%d %H:%M:%S>"))))

;(eval-after-load 'ox ;; shouldn't be byte compiled.
;		 '(when (and user-init-file (buffer-file-name)) ;; don't do it in async
;		    (setq org-export-async-init-file
;			  (expand-file-name "org-async-init.el" (file-name-directory
;								  user-init-file)))))
