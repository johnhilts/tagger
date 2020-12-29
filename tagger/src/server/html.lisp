
(in-package #:tagger)

(setf (html-mode) :html5)

;; allow parenscript and cl-who to work together
(setf *js-string-delimiter* #\")

(defun make-info-page ()
  "generate info HTML page"
  ;; I split this calling of ps functions into 2 operations because str is a macrolet that's only available under with-html-output-to-string
  ;; I have options to consider such as I can mimic str and then put it whereever I want and then only have to work with 1 list
  (flet ((invoke-registered-ps-functions ()
           "pull all the registered ps functions from a global plist, then put them into a list"
           (do ((e *registered-ps-functions* (cddr e))
                (result ()))
               ((null e) result)
             (push (getf *registered-ps-functions* (car e)) result))))
    (with-html-output-to-string
        (*standard-output* nil :prologue t :indent t)
      (:html :lang "en"
             (:head
              (:meta :charset "utf-8")
              (:title "Info List")
              (:link :type "text/css"
                     :rel "stylesheet"
                     :href "/styles.css")
              (:script :type "text/javascript"
                       (str (jfh-web:define-ps-with-html-macro))
                       (str (share-server-side-constants))
                       (str (client-info))
                       (str (client-ui))
                       (dolist (e (invoke-registered-ps-functions))
                         (str (funcall e)))))
             (:body
              (:div :id "info-filter")
              (:div
               (:h1 "Tagged Info"
                    (:div
                     (:div
                      (:label "Notes")
                      (:textarea :id "note-content" :placeholder "Enter Note here." :rows "5" :cols "100"))
                     (:div
                      (:label "Tags")
                      (:textarea :id "tags-content" :placeholder "Enter Tags here (comma-separated)." :rows "5" :cols "100"))
                     (:button :id "info-add-btn" "Add"))
                    (:div
                     (:div :style "display: inline-block;"
                      (:table :id "tag-list"
                              (:thead (:th :id "tag-list-column-header" "Tags"))
                              (:tbody :id "tag-list-body" (:tr (:td "(no tags yet)")))))
                     (:div :style "display: inline-block;"
                      (:table :id "note-list"
                              (:thead (:th :id "note-list-column-header" "Notes"))
                              (:tbody :id "note-list-body" (:tr (:td "(no notes yet)")))))))))))))

(define-easy-handler (todo-page :uri "/info") ()
  "HTTP endpoint"
  (make-info-page))
