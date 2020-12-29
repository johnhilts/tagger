
(in-package #:tagger)

(define-api-endpoint note-data *note-api-endpoint* (tag)
  "REST endpoint for tagged notes"
  (case verb
    (:post
     (info-data-add raw-data))
    (:get
     (note-data-get tag))))

(define-api-endpoint tag-data *tag-api-endpoint* ()
  "REST endpoint for tags"
  (case verb
    (:get
     (tag-data-get))))
