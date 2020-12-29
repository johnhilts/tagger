
(in-package #:tagger)

(defun get-notes-by-tag (tag)
  "get info by (unique) tag"
  (let ((infos (fetch-or-create-infos)))
    (multiple-value-bind (notes) (gethash tag infos) notes)))

(defun fetch-or-create-infos ()
  "get info from persisted data"
  (fetch-or-create-hashtable *info-file-path*))

(defun get-info-list ()
  "get info list and encode as json"
  (encode-multiple-plists-to-json-as-string (fetch-or-create-infos)))

(defun note-data-get (tag)
  "get notes by tag"
  (json:encode-json-to-string (get-notes-by-tag tag)))

(define-data-update-handler info-data-add (model-note model-tags)
    "add info data to persisted data"
    (let ((existing-infos (fetch-or-create-infos)))
      (dolist (tag model-tags)
        (create-or-add-to-entry tag model-note existing-infos))
    (write-complete-file *info-file-path* existing-infos)
    (json:encode-json-to-string (list 'ok))))


(defun get-tags ()
  "get tags"
  (let ((infos (fetch-or-create-infos))
        (tags ()))
    (maphash #'(lambda (key -) (push key tags)) infos)
    tags))

(defun tag-data-get ()
  "get notes by tag"
  (json:encode-json-to-string (get-tags)))
