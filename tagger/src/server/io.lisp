
(in-package #:tagger)

(defun read-complete-file-by-line (path)
  "read entire file one line at a time"
  (let ((file ()))
    (with-open-file (in path :if-does-not-exist :create)
      (do ((line (read in nil) (read in nil)))
          ((null line) file)
        (setf file (append file (list line)))))))

(defun write-complete-file-by-line (path list)
  "write complete file one line at a time"
  (with-open-file (out path :direction :output :if-exists :supersede :if-does-not-exist :create)
    (dolist (line list)
      (print line out))))

(defun read-complete-file (path)
  "read complete file all at once"
  (with-open-file (in path :if-does-not-exist :create)
    (read in nil)))

(defun write-complete-file (path ht)
  "write complete file all at once to serialize a hashtable"
  (with-open-file (out path :direction :output :if-exists :supersede :if-does-not-exist :create)
    (maphash #'(lambda (key value) (print (list key value) out)) ht))) ;; print is just like prin1, except it precedes each output with a line break, and ends with a space
