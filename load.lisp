
(let ((root "/Users/tarvydas/quicklisp/local-projects/cl0d/"))
  (labels ((ld (fname)
             (load (format nil "~a~a" root fname))))
	  ;; basics
	  (ld "debuggable.lisp")
	  (ld "fifo.lisp")
	  (ld "dict.lisp")
	  (ld "message.lisp")
	  (ld "inputmessage.lisp")
	  (ld "outputmessage.lisp")
))
