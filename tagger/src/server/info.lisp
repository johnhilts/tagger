
(in-package #:tagger)

(defun get-info-by-tag (tag)
  "get info by (unique) tag"
  (let ((infos (fetch-or-create-infos)))
    (multiple-value-bind (note) (gethash tag infos) note)))

(defun fetch-or-create-infos ()
  "get info from persisted data"
  (fetch-or-create-hashtable *info-file-path*))

(defun get-info-list ()
  "get info list and encode as json"
  (encode-multiple-plists-to-json-as-string (fetch-or-create-infos)))

(defun info-data-get (tag)
  "get info by ID or entire list"
  (json:encode-json-to-string (get-info-by-tag tag)))

(define-data-update-handler info-data-add (model-note model-tags)
    "add info data to persisted data"
    (let ((existing-infos (fetch-or-create-infos)))
      (dolist (tag model-tags)
        (create-or-add-to-entry tag model-note existing-infos))
    (write-complete-file *info-file-path* existing-infos)
    (json:encode-json-to-string (list 'ok))))


