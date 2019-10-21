;;; packages.el --- platformio layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: learts <learts92@gmail.com>
;; URL: https://github.com/LeartS/spacemacs-layer-platformio
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst platformio-packages
  '(
    company
    irony
    (company-irony :toggle (configuration-layer/package-used-p 'company))
    irony-eldoc
    platformio-mode
    ))

(defun platformio/init-irony ()
  (use-package irony
    :defer t
    :commands (irony-mode irony-install-server)
    :init
    (add-hook 'irony-mode-hook
              (lambda ()
                (define-key irony-mode-map [remap completion-at-point]
                  'irony-completion-at-point-async)
                (define-key irony-mode-map [remap complete-symbol]
                  'irony-completion-at-point-async)
                (irony-cdb-autosetup-compile-options)))
    ))

(defun platformio/init-company-irony ()
  (use-package company-irony
    :defer t
    :init
    (spacemacs|add-company-backends
       :backends company-irony
       :modes irony-mode)))

(defun platformio/init-irony-eldoc ()
  (use-package irony-eldoc
    :defer t
    :init
    (add-hook 'irony-mode-hook 'irony-eldoc)))

(defun platformio/init-platformio-mode ()
  (use-package platformio-mode
    :commands platformio-conditionally-enable
    :defer t
    :init
    (progn
      (add-hook 'platformio-mode-hook 'irony-mode)
      (add-to-list 'auto-mode-alist '("\\.ino" . c-mode))
      (add-hook 'c++-mode-hook 'platformio-conditionally-enable)
      (add-hook 'c-mode-hook 'platformio-conditionally-enable))))
