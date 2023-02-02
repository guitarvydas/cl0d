
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
          (ld "topmessage.lisp")

          ;; hsm
          (ld "porthandler.lisp")
          (ld "state.lisp")
          (ld "hsm.lisp")

          ;; eh
          (ld "senderqueue.lisp")
          (ld "receiverqueue.lisp")
          (ld "runnable.lisp")
          (ld "eh.lisp")


          ;; connections
          (ld "sender.lisp")
          (ld "receiver.lisp")
          (ld "connection.lisp")
          (ld "up.lisp")
          (ld "down.lisp")
          (ld "across.lisp")
          (ld "passthrough.lisp")

          ;; components
          (ld "leaf.lisp")
          (ld "container.lisp")

          ;; test
          (ld "echo.lisp")
          (ld "helloworldsequential.lisp")
          (ld "helloworldconcurrent.lisp")
          (ld "test.lisp")
))
