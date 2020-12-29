(in-package #:tagger)

(defun client-info ()
  "define client side functions to handle tagged info"
  (ps
    (defvar info-list ([]))))

(define-for-ps send-new-info-item-to-server (info-item)
  "save new info on server"
  (send-to-server *info-api-endpoint* "POST" info-item))
    
(define-for-ps add-info (evt)
  "add info on client and server and re-render html elements"
  (chain evt (prevent-default))
  (let* ((note (chain document (get-element-by-id "note-content")))
         (tags (chain document (get-element-by-id "tags-content")))
         (note-text (chain note value))
         (tag-text (chain tags value))
         (info-item  (create note note-text tags tag-text)))
    (chain info-list (push info-item))
    (clear-field note)
    (clear-field tags)
    (render-info-list info-list)
    (send-new-info-item-to-server info-item)
    t))

(define-for-ps get-info-list-from-server ()
  "define callback and get info list from server and re-render html elements"
  (flet ((call-back ()
           (let ((server-info-list (chain -j-s-o-n (parse (@ this response-text)))))
             (render-info-list server-info-list)
             (setf info-list server-info-list)
             t)))
    (let ((get-url (concatenate 'string *info-api-endpoint* "?tag=")))
      (get-from-server get-url call-back))))
