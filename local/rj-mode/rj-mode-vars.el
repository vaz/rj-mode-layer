
(defvar rj-blacklist
  '("^evil-snipe-[tTfF]$")
  "List of regexp patterns of :jump commands to exclude from post-recentering")

;; Some "jumping" motions lack the `:jump' property by design, because they
;; shouldn't store a jump point; we still wanna recenter some of them.
(defvar rj-extra-commands
  '(evil-goto-error
    ;; include mark jumping:
    evil-goto-mark
    evil-goto-mark-line
    ;; include changelist jumping:
    goto-last-change
    goto-last-change-reverse)
  "List of extra commands to add after-advice to force recentering.
This list takes precedence over the blacklist.")

(provide 'evil-vars)
