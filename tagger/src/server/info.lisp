
(in-package #:tagger)

(defun get-info-by-id (id)
  "get info by unique ID"
  (let ((infos (test-json-data)))
         (find-if
          #'(lambda (e)
              (let ((search-id (getf e :id)))
                (equal search-id id))) infos)))

(defun get-info (id)
  "get info by ID then convert to json"
  (let ((info (get-info-by-id id)))
    (encode-plist-to-json-as-string info)))

(defun fetch-or-create-infos ()
  "get info from persisted data"
  (fetch-or-create-data *info-file-path*))

(defun get-info-list ()
  "get info list and encode as json"
  (encode-multiple-plists-to-json-as-string (fetch-or-create-infos)))

(defun info-data-get (id)
  "get info by ID or entire list"
  (if id
      (get-info (parse-integer id))
      (get-info-list)))

(define-data-update-handler info-data-add (model-note model-tags)
    "add info data to persisted data"
    (let ((existing-infos (fetch-or-create-infos)))
      (dolist (tag model-tags)
        (create-or-add-to-entry tag model-note existing-infos))
    (write-complete-file *info-file-path* existing-infos)
    (json:encode-json-to-string (list 'ok))))

(define-data-update-handler info-data-add (model)
    "add info data to persisted data"
  (let ((new-id (getf model :id))
        (existing-infos (fetch-or-create-infos)))
    (write-complete-file *info-file-path* (append existing-infos (list model)))
    (json:encode-json-to-string (list new-id))))

(define-data-update-handler info-data-update (model)
  "update info data and persisted data"
  (let* ((update-id (getf model :id))
         (existing-infos (fetch-or-create-infos))
         (updated-item-position (position-if #'(lambda (e) (= (getf e :id) update-id)) existing-infos))
         (updated-infos (splice-and-replace-item-in-list existing-infos model updated-item-position)))
    
    (write-complete-file *info-file-path* updated-infos)
    (json:encode-json-to-string (list update-id))))

(define-data-update-handler info-data-delete (model)
  "delete info by ID"
  (let ((delete-id (getf model :id)))
    (when delete-id
      (let* ((existing-infos (fetch-or-create-infos))
             (deleted-item-position (position-if #'(lambda (e) (= (getf e :id) delete-id)) existing-infos))
             (updated-infos (splice-and-remove-item-in-list existing-infos deleted-item-position)))
        (write-complete-file *info-file-path* updated-infos)
        (json:encode-json-to-string (list delete-id))))))

