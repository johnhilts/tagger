(defsystem "tagger"
  :version "0.1.0"
  :author "John Hilts"
  :license "MIT"
  :depends-on ("cl-json"
               "hunchentoot")
  :components ((:module "src"
                :components
                ((:file "main"))))
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
