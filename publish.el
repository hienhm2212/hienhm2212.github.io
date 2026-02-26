;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

(require 'ox-publish)

;; Custom HTML head with Catppuccin styling
(defvar my-blog-html-head
  "<link rel='stylesheet' href='/assets/style.css' />
<meta name='viewport' content='width=device-width, initial-scale=1.0'>")

;; Custom preamble (header)
(defvar my-blog-html-preamble
  "<header class='site-header'>
  <nav class='site-nav'>
    <a href='/' class='nav-link'>Home</a>
    <a href='/about.html' class='nav-link'>About</a>
  </nav>
</header>")

;; Custom postamble (footer)
(defvar my-blog-html-postamble
  "<footer class='site-footer'>
  <p>Made with Org-mode & Catppuccin 🌸</p>
</footer>")

;; Custom sitemap entry format (for blog post list)
;; MOVED BEFORE setq so it exists when referenced
(defun my-blog-sitemap-format-entry (entry style project)
  "Format sitemap ENTRY for the blog."
  (cond ((not (directory-name-p entry))
         (format "[[file:%s][%s]] - %s"
                 entry
                 (org-publish-find-title entry project)
                 (format-time-string "%Y-%m-%d"
                                     (org-publish-find-date entry project))))
        (t entry)))

(setq org-publish-project-alist
      `(("my-blog"
	 ;; Configuration for converting .org to HTML
	 :base-directory "./content/"
	 :base-extension "org"
	 :publishing-directory "./public/"
	 :recursive t
	 :publishing-function org-html-publish-to-html
	 :headline-levels 4  ;; Fixed: was "headline-level"
	 :auto-preamble t
	 ;; HTML settings
	 :html-doctype "html5"
	 :html-html5-fancy t
	 :html-head ,my-blog-html-head
	 :html-preamble ,my-blog-html-preamble
	 :html-postamble ,my-blog-html-postamble
	 ;; Content settings
	 :with-author t
	 :with-creator nil
	 :with-date t 
	 :with-toc t 
	 :section-numbers nil
	 :time-stamp-file nil
	 ;; Sitemap (blog index)
	 :auto-sitemap t
	 :sitemap-filename "index.org"
	 :sitemap-title "My Blog"
	 :sitemap-sort-files anti-chronologically
	 :sitemap-format-entry my-blog-sitemap-format-entry
	 :exclude "about\\.org\\|404\\.org\\|archive\\.org"
	 :sitemap-style list)
	("my-blog-pages"
	 ;; Standalone pages (about, etc.) — excluded from sitemap
	 :base-directory "./content/"
	 :base-extension "org"
	 :exclude "posts/.*\\.org\\|index\\.org"
	 :recursive nil
	 :publishing-directory "./public/"
	 :publishing-function org-html-publish-to-html
	 :html-doctype "html5"
	 :html-html5-fancy t
	 :html-head ,my-blog-html-head
	 :html-preamble ,my-blog-html-preamble
	 :html-postamble ,my-blog-html-postamble
	 :with-author t
	 :with-creator nil
	 :with-date t
	 :with-toc nil
	 :section-numbers nil
	 :time-stamp-file nil)
	("my-blog-static"
	 ;; For images, CSS, etc
	 :base-directory "./content/"
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf"
	 :publishing-directory "./public/"
	 :recursive t
	 :publishing-function org-publish-attachment)
	("website"
	 :components ("my-blog" "my-blog-pages" "my-blog-static"))))

;; Function to quickly publish
(defun my-blog-publish ()
  "Publish the blog."
  (interactive)
  (org-publish-project "website" t))

;; Actually trigger publishing when run as a script
(org-publish-project "website" t)
