;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Emacs 23以前のバージョン用
(when (> emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d"))

;; パッケージリポジトリにmelpaと開発者運営のELPAを追加
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

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
;; (global-linum-mode t)

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
;; (when (require 'auto-install nil t)
;;   ;; インストールディレクトリを設定する
;;   (setq auto-install-directory "~/.emacs.d/elisp/")
;;   ;; EmacsWikiに登録されているelispの名前を取得する
;;   (auto-install-update-emacswiki-package-name t)
;;   ;; install-elisp の関数を利用可能にする
;;   (auto-install-compatibility-setup))

;; redo+の設定
(when (require 'redo+ nil t)
  ;; C-'にリドゥを割り当てる
  (global-set-key (kbd "C-'") 'redo)
  )

;; multi-termの設定
;; (if (not (fboundp 'ad-advised-definition-p))
;;  (defun ad-advised-definition-p (definition)
;;    "Return non-nil if DEFINITION was generated from advice information."
;;    (if (or (ad-lambda-p definition)
;;            (macrop definition)
;;            (ad-compiled-p definition))
;;        (let ((docstring (ad-docstring definition)))
;;          (and (stringp docstring)
;;               (get-text-property 0 'dynamic-docstring-function docstring))))))

;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
;; グローバルでauto-completeを利用
(global-auto-complete-mode t)
(define-key ac-completing-map (kbd "M-n") 'ac-next)      ; M-nで次候補選択
(define-key ac-completing-map (kbd "M-p") 'ac-previous)  ; M-pで前候補選択
(setq ac-dwim t)  ; 空気読んでほしい
;; 情報源として
;; * ac-source-filename
;; * ac-source-words-in-same-mode-buffers
;; を利用
(setq-default ac-sources '(ac-source-filename ac-source-words-in-same-mode-buffers))
;; また、Emacs Lispモードではac-source-symbolsを追加で利用
(add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols t)))
;; 以下、自動で補完する人用
;; (setq ac-auto-start 3)
;; 以下、手動で補完する人用
(setq ac-auto-start nil)
(ac-set-trigger-key "TAB")  ; TABで補完開始(トリガーキー)
;; or
;; (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)  ; M-TABで補完開始
