(in-package #:tagger)

(defun client-ui ()
  "define client side UI functions"
  (ps

    (defparameter *note-text* "note-text")
    (defparameter *tags-text* "tags-text")

    (setf (chain window onload) init)))

(define-for-ps clear-field (field)
  "clear input field's value"
  (setf (chain field value) "")
  t)
    
(define-for-ps clear-children (parent-element)
  "remove all child nodes of a parent element"
  (while (chain parent-element (has-child-nodes))
    (chain parent-element (remove-child (@ parent-element first-child)))))
    
(define-for-ps init ()
  "initialize html elements and JS objects on page load"
  (render-info-filter)
  (get-tag-list-from-server)
  (setf add-button (chain document
                          (get-element-by-id "info-add-btn")))
  (chain add-button
         (add-event-listener "click" add-info false)))

(define-for-ps filter-info-by-tag (tag)
  (get-info-list-from-server tag)
  t)

(define-for-ps filter-info ()
  (let ((filter-text (@ (chain document (get-element-by-id "info-filter-text")) value)))
    (filter-info-by-tag filter-text))
  t)

(define-for-ps render-info-filter ()
  "render html elements for info filter"
  (let ((parent-element (chain document (get-element-by-id "info-filter"))))
    (jfh-web::with-html-elements
        (div
         (div
          (span (br (ref . "br")))
          (input (id . "info-filter-text") (type . "textbox") (placeholder . "Enter tag to filter on here"))
          (span "  ")
          (button (onclick . "(filter-info)") "Filter")))))
  t)

(define-for-ps render-note-list (note-list &optional tag)
  "render html elements for note list"
  (flet ((is-hyperlink (note)
           (chain note (match (regex "/^http:\\/\\/|^https:\\/\\/[\\w\\.\\?\\=\\/\\-\\~\\&]+$/i")))))
    (let* ((note-list-table-body (chain document (get-element-by-id "note-list-body")))
           (parent-element note-list-table-body)
           (column-header (chain document (get-element-by-id "note-list-column-header"))))
      (clear-children parent-element)
      (setf (chain column-header inner-text) (if tag (concatenate 'string "Notes tagged with " tag) "Notes"))
      (chain note-list
             (map
              #'(lambda (note)
                  (let ((pre-style "display:inline;")
                        (is-hyperlink (is-hyperlink note)))
                    (if is-hyperlink
                        (jfh-web::with-html-elements
                            (tr
                             (td
                              (ul (li
                                   (label
                                    (pre
                                     (style . "(echo pre-style)")
                                     (a (href . "(echo note)") note))))))))
                        (jfh-web::with-html-elements
                            (tr
                             (td
                              (ul (li
                                   (label
                                    (pre
                                     (style . "(echo pre-style)")
                                     note))))))))))
              t)))))

(define-for-ps render-tag-list (tag-list)
  "render html elements for tag list"
  (let* ((tag-list-table-body (chain document (get-element-by-id "tag-list-body")))
         (parent-element tag-list-table-body)
         (column-header (chain document (get-element-by-id "tag-list-column-header"))))
    (clear-children parent-element)
    (setf (chain column-header inner-text) "Tags")
    (chain tag-list
           (map
            #'(lambda (tag)
                (let ((pre-style "display:inline;"))
                  (jfh-web::with-html-elements
                      (tr
                       (td
                        (label
                         (pre
                          (style . "(echo pre-style)")
                          (a (onclick . "(filter-info-by-tag tag)") tag)))))))
                t)))))
