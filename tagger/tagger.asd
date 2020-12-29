#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :hunchentoot)
(ql:quickload :cl-who)
(ql:quickload :cl-json)
(ql:quickload :parenscript)

(defsystem "tagger"
  :version "0.1.0"
  :author "John Hilts"
  :license "MIT"
  :serial t
  :depends-on (#:cl-who #:hunchentoot #:parenscript #:cl-json #:jfh-web)
  :components ((:file "package")
               (:module "src"
                        :components
                        ((:file "common/constants")
                         (:file "server/web-common")
                         (:file "server/util")
                         (:file "server/io")
                         (:file "server/web-infrastructure")
                         (:file "server/info")
                         (:file "server/api")
                         (:file "client/common")
                         (:file "client/ajax")
                         (:file "client/util")
                         (:file "client/info")
                         (:file "client/ui")                         
                         (:file "server/html")
                         (:file "main"))))
  
  :description ""
  :in-order-to ((test-op (test-op "tagger/tests"))))

(defsystem "tagger/tests"
  :author "John Hilts"
  :license "MIT"
  :depends-on ("tagger")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for tagger"
  :perform (test-op (op c) (symbol-call :rove :run c)))
