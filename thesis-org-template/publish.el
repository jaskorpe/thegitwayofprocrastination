;(add-to-list 'load-path "~/.emacs.d/org-mode/lisp")
(require 'org-export-latex)

(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))

; Document structure * for chapter, ** for section and so on
(add-to-list 'org-export-latex-classes
	     '("uiophd"
	       "\\documentclass{uiophd}"
	       ("\\chapter{%s}" . "\\chapter*{%s}")
	       ("\\section{%s}" . "\\section*{%s}")
	       ("\\subsection{%s}" . "\\subsection*{%s}")
	       ("\\subsubsection{%}" . "\\subsubsection*{%s}")
	       ("\\paragraph{%s}" . "\\paragraph*{%s}")
	       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


(setq org-export-latex-title-command "\\uiosloforside[kind={Master thesis}]")
(setq org-export-latex-hyperref-format "\\ref{%s}")

; In order to not export some properties. DEADLINE is exported
; anyway. For timestamps there seems to be a bug that exports
; timestamp if DEADLINE comes before CLOCK.
(setq org-export-with-timestamps nil)
(setq org-export-with-todo-keywords nil)

; Packages to be used. Seems like it's not possible with no options
; for package
(add-to-list 'org-export-latex-packages-alist '(\"\" uiosloforside))
;(add-to-list 'org-export-latex-packages-alist '(T1 fontenc))
;(add-to-list 'org-export-latex-packages-alist '(\"\" url))
;(add-to-list 'org-export-latex-packages-alist '(\"\" babel))

; To run this from bash: emacs -l publish.el --batch
; --visit=master.org --execute='(publish)'
; or emacs -l publish.el --batch --visit=master.org
; --funcall=org-export-as-latex-batch
(defun publish()
  (interactive)
  (org-export-as-latex-batch))
