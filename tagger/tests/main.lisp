(defpackage tagger/tests/main
  (:use :cl
        :tagger
        :tagger/utility
        :jfh-testing))
(in-package :tagger/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :tagger)' in your Lisp.
;; need to use deftest?

(defun string-splitting ()
  (test-spec :category "splitting"
    (test-spec :description "should split by comma"
      (test-spec :it "typical case"
        (equal '("one" "two" "three") (tagger:split-string-by #\, "one, two, three")))
      (test-spec :it "dangling comma"
        (equal '("one" "two" "three") (tagger:split-string-by #\, "one, two, three,")))
      (test-spec :it "lots of words"
        (equal '("one and a" "two and a" "three and a four and a") (tagger:split-string-by #\, "one and a, two and a, three and a four and a,")))
      (test-spec :it "single word, no comma"
        (equal '("one") (tagger:split-string-by #\, "one")))
      (test-spec :it "double comma"
        (equal '("one" "two") (tagger:split-string-by #\, "one,,two"))))))
