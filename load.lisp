
(let ((root "/Users/tarvydas/quicklisp/local-projects/cl0d/"))
  (labels ((ld (fname)
             (load (format nil "~a~a" root fname))))
	  ;; basics
	  (ld "delegate.lisp")
	  (ld "fifo.lisp")
	  (ld "schedulable.lisp")
          ;; Message
	  (ld "message.lisp")
	  ;; leaf
	  (ld "leaf.lisp")
          ;; test
	  (ld "echo.lisp")
          (ld "test.lisp")
))
