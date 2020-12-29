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
  (get-info-list-from-server)
  (setf add-button (chain document
                          (get-element-by-id "info-add-btn")))
  (chain add-button
         (add-event-listener "click" add-info false)))

(define-for-ps filter-info ()
  (let* ((filter-text (@ (chain document (get-element-by-id "info-filter-text")) value))
         (filtered-infos (chain info-list (filter (lambda (info) (chain (@ info tag) (match (new (-reg-exp filter-text "i")))))))))
    (render-info-list filtered-infos))
  t)

(define-for-ps render-info-filter ()
  "render html elements for info filter"
  (let ((parent-element (chain document (get-element-by-id "info-filter"))))
    (jfh-web::with-html-elements
        (div
         (div
          (span (br (ref . "br")))
          (input (id . "info-filter-text") (type . "textbox") (placeholder . "Enter text to filter on here"))
          (span "  ")
          (button (onclick . "(filter-info)") "Filter")))))
  t)

(define-for-ps render-info-list (info-list)
  "render html elements for info list"
  (let* ((info-list-table-body (chain document (get-element-by-id "info-list-body")))
         (parent-element info-list-table-body)
         (column-header (chain document (get-element-by-id "info-list-column-header")))
         (count (length info-list)))
    (clear-children parent-element)
    (setf (chain column-header inner-text) "Tagged Info")
    (chain info-list
           (map
            #'(lambda (info)
                (let ((note-text-id (+ *note-text* index))
                      (pre-style "display:inline;"))
                  (jfh-web::with-html-elements
                      (tr
                       (td
                        (label
                         (pre
                          (style . "(echo pre-style)")
                          "(@ info note)"))))))
                t)))))


