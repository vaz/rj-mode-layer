(require 'rj-mode-vars)

(defun rj/recenter (&rest _)
  "A version of recenter that ignores any args, for convenience"
  (interactive)
  (recenter nil))


(defun rj//blacklisted-p (command)
  "Predicate for if a command is blacklisted from recentering after jump.
See the var rj-blacklist."
  (let ((cmd-name (if (symbolp command)
                      (symbol-name command)
                    command)))
    (some (lambda (pattern)
            (string-match-p pattern cmd-name))
          rj-blacklist)))


;; recentering, respecting blacklist

(defun rj//recenter-unless-blacklisted (command)
  (unless (rj//blacklisted-p command)
    (rj/recenter)))

(defun rj//recenter-after-jump-command (&optional command)
  "Run in post-command-hook to recenter after :jump commands"
  (setq command (or command this-command))
  (when (evil-get-command-property command :jump)
    (rj//recenter-unless-blacklisted command)))

(defun rj//recenter-after-command (&optional command)
  "Run in post-command-hook to recenter after commands in rj-extra-commands"
  (setq command (or command this-command))
  (rj//recenter-unless-blacklisted command))


;; toggles

(defun rj//toggle-hooks (toggle)
  (cond
   (toggle
    (add-hook 'post-command-hook #'rj//recenter-after-jump-command nil t)
    ;; After jumplist navigation (e.g. `C-o', `C-i') - there's a hook for that
    (add-hook 'evil-jumps-post-jump-hook #'rj//recenter-after-command nil t))
   (t
    (remove-hook 'post-command-hook #'rj//recenter-after-jump-command t)
    (remove-hook 'evil-jumps-post-jump-hook #'rj//recenter-after-command t))))

(defun rj//toggle-advice (toggle)
  (when rj-extra-commands
    (dolist (cmd rj-extra-commands)
      (let ((advice-name (concat "rj//recenter-after:" (symbol-name cmd)))
            (after-fn (lambda (&rest _) (rj//recenter-after-command))))
        (if toggle
            (advice-add cmd :after after-fn
                        `((name . ,advice-name)))
          (progn
            (advice-remove cmd advice-name)))))))

(defun rj//toggle-all (toggle)
  (rj//toggle-hooks toggle)
  (rj//toggle-advice toggle))

(provide 'rj-mode-funcs)
