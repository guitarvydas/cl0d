(declaim (optimize (debug 3) (safety 3) (speed 0)))

(let ((root "/Users/tarvydas/quicklisp/local-projects/cl0d/"))
  (labels ((ld (fname)
             (load (format nil "~a~a" root fname))))
	  ;; basics
	  (ld "lookup.lisp")
	  (ld "fifo.lisp")
	  (ld "schedulable.lisp")
	  (ld "eh.lisp")
          ;; Message
	  (ld "message.lisp")
	  ;; leaf
	  (ld "leaf.lisp")
	  ;; connections
	  (ld "dir.lisp")
          ;; test
	  (ld "echo.lisp")
          (ld "test.lisp")
))
