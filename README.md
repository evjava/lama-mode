# `lama-mode`

Major mode for Emacs for Lama ( the programming language for educational purposes, see https://github.com/JetBrains-Research/Lama )

## `Usage`

There are 2 variants:

1. Copy `lama-mode.el` to your emacs path and add this to your config:
``` elisp
(load "lama-mode")
(add-to-list 'auto-mode-alist '("\\.lama\\'" . lama-mode))
``` 

2. Add this to your config (quelpa and use-package should be installed):
``` elisp
(use-package nav-nav
  :after (rx)
  :quelpa (lama-mode :fetcher git :url "https://github.com/evjava/lama-mode.git")
  :mode ("\\.lama\\'" . lama-mode))
```
