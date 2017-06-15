
(require 'rj-mode-vars)
(require 'rj-mode-funcs)


;;; define minor mode

(define-minor-mode rj-mode
  "Minor mode for recentering cursor after jumping motions"
  :init-value nil
  :lighter "⊖"
  (rj//toggle-all rj-mode))

(put 'rj-mode 'permanent-local t)

;;; globalize minor mode

(defun rj-init ()
  "Enable rj as long as evil is enabled in this buffer"
  (when evil-local-mode
    (rj-mode 1)))

;;;###autoload (autoload 'global-rj-mode "rj-mode")
(define-globalized-minor-mode global-rj-mode rj-mode rj-init)

(defconst rj-mode-version "0.1")

(provide 'rj-mode)
