(defpackage tagger/utility
  (:use :cl :tagger)
  (:export :split-string-by))
(in-package :tagger/utility)

(defun split-string-by (delimiter string)
  (flet ((trim (string &optional return-type)
           (let ((trimmed (string-trim '(#\Space) string)))
             (if (zerop (length trimmed))
                 (if (equal 'list return-type) () "")
                 (if (equal 'list return-type) (list trimmed) trimmed)))))
    (let ((delimiter-position (position delimiter string)))
      (if delimiter-position
          (let ((trimmed (trim (subseq string 0 delimiter-position)))
                (split-next #'(lambda ()
                                (split-string-by
                                 delimiter
                                 (subseq string (+ 1 delimiter-position))))))
            (if (zerop (length trimmed))
                (funcall split-next)
                (cons trimmed (funcall split-next))))
          (trim string 'list)))))
