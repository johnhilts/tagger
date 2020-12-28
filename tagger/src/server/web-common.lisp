
(in-package #:tagger)

(defmacro define-api-endpoint (name end-point params &body body)
  `(define-easy-handler (,name :uri ,end-point) (,@params)
     "macro to DRY REST endpoint declarations"
     (setf (content-type*) "application/json")
     (let* ((raw-data  (raw-post-data :force-text t))
            (verb (request-method *request*)))
       ,@body)))

(defmacro define-data-update-handler (name model &body body)
  "macro to DRY data update handlers for both POST and PUT"
  (let ((model-note-name (car model))
        (model-tags-name (cadr model)))
    `(defun ,name (raw-data)
       (multiple-value-bind (,model-note-name ,model-tags-name) (convert-dotted-pair-to-note-and-tags (json:decode-json-from-string raw-data))
         ,@body))))
