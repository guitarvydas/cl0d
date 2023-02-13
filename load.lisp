(declaim (optimize (debug 3) (safety 3) (speed 0)))

(let ((root "/Users/tarvydas/quicklisp/local-projects/cl0d/"))
  (labels ((ld (fname)
             (load (format nil "~a~a" root fname))))
	  ;; basics
	  (ld "lookup.lisp")
	  (ld "fifo.lisp")
	  (ld "message.lisp")
	  (ld "schedulable.lisp")
	  (ld "eh.lisp")
	  ;; leaf
	  (ld "leaf.lisp")
	  ;; connections
	  (ld "connection.lisp")
	  ;; container
	  (ld "container.lisp")
          ;; test
	  (ld "echo.lisp")
          (ld "sequential.lisp")
          (ld "test.lisp")
))
