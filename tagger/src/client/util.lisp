(in-package #:tagger)

(defun share-server-side-constants ()
  "feed server side constants to parenscript"
  (ps

    (defun user-homedir-pathname ()
      "")

    (defun namestring (path)
      path)
    
    (defmacro share-server-side-constants ()
      (flet (
             (a-defvar (e) (equal 'defvar (car e)))
             (constants-from-server ()
               (read-complete-file-by-line "./src/common/constants.lisp")))
        `(progn
           ,@(mapcar #'print
              (remove-if-not #'a-defvar
                             (constants-from-server))))))

    (share-server-side-constants)))

(define-for-ps get-next-index (todo-list)
  "calculate next index for todo list"
  (let ((id-list (chain todo-list (map #'(lambda (todo) (@ todo id)))))
        (max-fn (@ -Math max)))
    (if (length id-list)
        (+ 1 (chain max-fn (apply null id-list)))
        1)))

(define-for-ps echo (string)
  "just echo back string ... convenience wrapper method"
  (chain string (to-string)))
