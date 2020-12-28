
(in-package #:tagger)

(defvar *info-api-endpoint* "/info-data")

(defvar *app-data-path* (concatenate 'string (namestring (user-homedir-pathname)) ".eztagger/"))
(defvar *info-file-path* (concatenate 'string *app-data-path* "info-list.sexp"))

(defvar *web-settings-file-path* (concatenate 'string (namestring (user-homedir-pathname)) ".config/eztagger/web-settings.sexp"))
