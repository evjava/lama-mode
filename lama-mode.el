;;; lama-mode.el --- Major mode for Lama -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright © 2020 Eugene Vagin

;; Author: Eugene Vagin (evjava@yandex.ru)
;; Keywords: languages
;; Package-Requires: ((emacs "24.3"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A major mode for editing Lama
;;   (the programming language for educational purposes, see URL `https://github.com/JetBrains-Research/Lama')
;; in Emacs.

(require 'rx)

;; indentation

(defun lm-indent ()
  (interactive)
  (let ((p (point))
        (_ (back-to-indentation))
        (bp (point)))
    (insert "  ")
    (if (< bp p) (goto-char (+ 2 p)))))

(defun lm-unindent ()
  (interactive)
  (save-excursion
    (back-to-indentation)
    (if (or
         (<= (+ 2 (line-beginning-position)) (point))
         (= (char-before (point)) ?\t))
        (backward-delete-char-untabify 2))))

(defvar lama-mode-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "TAB") 'lm-indent)
      (define-key map (kbd "<backtab>") 'lm-unindent)
      map)
  "Keymap for `lama-mode'.")

;; highlighting
(defconst lama-mode--fun-decl-keywords '("fun"))
(defconst lama-keywords '("after" "at" "before" "boxed" "case" "esac" "do" "elif" "else" "esac" "eta" "fi" "for" "fun" "if" "import" "infix" "infixl" "infixr" "lazy" "length" "local" "od" "of" "public" "repeat" "return" "sexp" "skip" "syntax" "then" "unboxed" "until" "when" "while"))
(defconst lama-function-name-regexp 
  (rx-to-string `(and (or ,@lama-mode--fun-decl-keywords) (+ space) bow (group (+ (any alnum word))) eow) t))

(setq lama-font-lock-keywords
      (cl-flet ((words-to-regexp (words) (regexp-opt words 'words)))
        `(
          ("^[ \t]*--.*"  . font-lock-comment-face)
          ("^[ \t]*\\(\\*.*\\*\\)"  . font-lock-comment-face)
          ("\"[^\"]*\"" . font-lock-string-face)
          (,(words-to-regexp '("array" "string")) . font-lock-type-face)
          (,(words-to-regexp '("true" "false")) . font-lock-constant-face)
          (,(words-to-regexp lama-keywords) . font-lock-keyword-face)
          (,lama-function-name-regexp . (1 font-lock-function-name-face))
          (,(words-to-regexp '("failure")) . font-lock-warning-face))))
      
;;;###autoload
(define-derived-mode lama-mode text-mode "Lama mode"
  "Major mode for editing Lama (Lama Language)"

  (setq font-lock-defaults '((lama-font-lock-keywords) nil nil))
  
  (setq-local comment-start "--")
  (setq-local comment-end "\n")
  (setq-local comment-start-skip "\\(--\\|(\\*\\)[ \t]*")
  (setq-local comment-end-skip "[ \t]*\\(\\*)\\|\\s>\\)")
  (setq-local indent-line-function 'indent-relative)
)

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.lama$" . lama-mode))

;; add the mode to the `features' list
(provide 'lama-mode)
