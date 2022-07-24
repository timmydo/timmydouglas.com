---
date: 2022-07-23
title: "Hunchentoot"
---

Often times I just use my blog to find sample code or a script for
later use. I've been wanting to write some more code in common lisp
recently and this was a fun sample app.



```lisp
;; (ql:quickload :hunchentoot)
;; (ql:quickload :cl-who)

(asdf:load-system "hunchentoot")
(asdf:load-system "cl-who")
(use-package :cl-who)

(defclass vhost (hunchentoot:acceptor)
  ((dispatch-table
    :initform '()
    :accessor dispatch-table
    :documentation "List of dispatch functions")))


(defmethod hunchentoot:acceptor-dispatch-request ((vhost vhost) request)
  (mapc (lambda (dispatcher)
	  (let ((handler (funcall dispatcher request)))
	    (when handler
	      (return-from hunchentoot:acceptor-dispatch-request (funcall handler)))))
	(dispatch-table vhost))
  (call-next-method))

(defvar *srv* (make-instance 'vhost :address "127.0.0.1" :port 8080))

(defmacro with-html ((var) &body body)
  `(with-html-output-to-string (,var)
     ,@body))

(setf (dispatch-table *srv*)
      (list
       (hunchentoot:create-prefix-dispatcher "/favicon.ico" 'foo2)
       (hunchentoot:create-prefix-dispatcher "/" 'foo1)))

(defvar *count* 0)

(defun foo2 () )
(defun foo1 ()
  (incf *count*)
  (with-html (s)
    (:html
     (:body
      "Greetings! You are visitor number "
      (str *count*)))))

(hunchentoot:start *srv*)

;; (hunchentoot:stop *srv*)

```
