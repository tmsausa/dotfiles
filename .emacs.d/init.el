;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Emacs 23以前のバージョン用
(when (> emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d"))

;; パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
;; インストールしたパッケージにロードパスを通して読み込む
(package-initialize)

;; def add-to-load-path
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; ターミナル以外はツールバー，スクロールバーを非表示
(when window-system
  ;; tool-barを非表示
  (tool-bar-mode 0)
  ;; scroll-barを非表示
  (scroll-bar-mode 0))

;; CocoaEmacs以外はメニューバーを非表示
(unless (eq window-system 'ns)
  ;; menu-barを非表示
  (menu-bar-mode 0))

;; C-mにnewline-and-indentを割り当てる
(define-key global-map (kbd "C-m") 'newline-and-indent)

;; M-x toggle-truncate-linesをC-c l"に
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; "C-t"でウィンドウを切り替える
(define-key global-map (kbd "C-t") 'other-window)

;; 文字コード
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; Mac OS Xの場合のファイル名の設定
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; Windows の場合のファイル名の設定
(when (eq window-system 'w32)
  (set-file-name-coding-system 'cp932)
  (setq locale-coding-system 'cp932))

;; カラム番号も表示
(column-number-mode t)

;; ファイルサイズを表示
(size-indication-mode t)
;; 時計を表示
;; (setq display-time-day-and-date t)
;; (setq display-time-24hr-format t)
(display-time-mode t)
;; バッテリー残量を表示
(display-battery-mode t)

;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
;; http::/d.hatena.ne.jp/sonota88/20110224/1298557375
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines, %d chars "
	      (count-lines (region-beginning) (region-end))
	      (- (region-end) (region-beginning)))
    ;; これだとエコーエリアがちらつく
    ;; (count-lines-region (region-beginning) (region-end))
    ""))
(add-to-list 'default-mode-line-format
	     '(:eval (count-lines-and-chars)))

;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;; 行番号を常に表示する
(global-linum-mode t)

;; TABの表示幅．初期値は8
(setq-default tab-width 4)

;; リージョンの背景色を変更
(set-face-background 'region "darkgreen")

(when (require 'color-theme nil t)
  ;; テーマを読み込むための設定
  (color-theme-initialize)
  ;; テーマhoberに変更する
  (color-theme-hober))

;; asciiフォントをmenloに
(set-face-attribute 'default nil
					:family "Menlo"
					:height 120)

;; auto-installの設定（なんかインストールがうまくいかない時がある）
(when (require 'auto-install nil t)
  ;; インストールディレクトリを設定する
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されているelispの名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; install-elisp の関数を利用可能にする
  (auto-install-compatibility-setup))

;; redo+の設定
(when (require 'redo+ nil t)
  ;; C-'にリドゥを割り当てる
  (global-set-key (kbd "C-'") 'redo)
  )

;; multi-termの設定
(if (not (fboundp 'ad-advised-definition-p))
 (defun ad-advised-definition-p (definition)
   "Return non-nil if DEFINITION was generated from advice information."
   (if (or (ad-lambda-p definition)
           (macrop definition)
           (ad-compiled-p definition))
       (let ((docstring (ad-docstring definition)))
         (and (stringp docstring)
              (get-text-property 0 'dynamic-docstring-function docstring))))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (elpy multi-term))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(elpy-enable)
(add-hook 'python-mode-hook
           '(lambda ()
              (setq indent-tabs-mode nil);;tabの幅を変える
              (setq indent-level 4)
              (setq python-indent 4)
              (setq tab-width 4)
              (define-key python-mode-map "\"" 'electric-pair) ;;括弧の補完
              (define-key python-mode-map "\'" 'electric-pair)
              (define-key python-mode-map "(" 'electric-pair)
              (define-key python-mode-map "[" 'electric-pair)
              (define-key python-mode-map "{" 'electric-pair)
              (define-key company-active-map (kbd "\C-n") 'company-select-next)
              (define-key company-active-map (kbd "\C-p") 'company-select-previous)
              (define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
              (define-key company-active-map (kbd "<tab>") 'company-complete)
              (auto-complete-mode -1)
              ))

;;elpy 色の設定 デフォルトは黄色でださい
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-minimum-prefix-length 1)
 '(company-selection-wrap-around t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "#131313" :foreground "white"))))
 '(company-scrollbar-bg ((t (:inherit company-tooltip :background "dim gray"))))
 '(company-scrollbar-fg ((t (:background "blue"))))
 '(company-tooltip ((t (:background "dim gray" :foreground "white"))))
 '(company-tooltip-annotation ((t (:inherit company-tooltip :foreground "white"))))
 '(company-tooltip-common ((t (:inherit company-tooltip :foreground "white"))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :foreground "white"))))
 '(company-tooltip-selection ((t (:inherit company-tooltip :background "blue"))))
 '(mode-line ((t (:foreground "#F8F8F2" :background "#303030" :box (:line-width 1 :color "#000000" :style released-button)))))
 '(mode-line-buffer-id ((t (:foreground nil :background nil))))
 '(mode-line-inactive ((t (:foreground "#BCBCBC" :background "#101010" :box (:line-width 1 :color "#333333"))))))
