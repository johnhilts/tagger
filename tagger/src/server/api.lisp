
(in-package #:tagger)

(define-api-endpoint info-data *info-api-endpoint* (id)
  "REST endpoint for tagged info"
  (case verb
    (:put
     (info-data-update raw-data))
    (:post
     (info-data-add raw-data))
    (:delete
     (info-data-delete raw-data))
    (:get
     (info-data-get id))))
