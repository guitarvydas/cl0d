(defun Eh/new (given-name)
  (let ((name (format nil "[Eh ~a]" given-name)))
    (let ((inq (FIFO/new))
          (outq (FIFO/new)))
      `((%debug . eh)
        (%id . ,(gensym "id"))
        (name . ,(lambda () name))
        (%type . ,(lambda () nil))
        ;; input queue
	(input-queue . ,(lambda () inq))
        (enqueue-input . ,(lambda (x) (funcall (%lookup inq 'enqueue) x)))
        (dequeue-input . ,(lambda () (funcall (%lookup inq 'dequeue))))
        (empty-input? . ,(lambda ()  (funcall (%lookup inq 'empty?))))
        ;; output queue
	(output-queue . ,(lambda () outq))
        (enqueue-output . ,(lambda (msg) (funcall (%lookup outq 'enqueue) msg)))
        (dequeue-output . ,(lambda (msg) (funcall (%lookup outq 'dequeue) msg)))
        (empty-output? . ,(lambda () (funcall (%lookup outq 'empty?))))
        (clear-outputs . ,(lambda () (funcall (%lookup outq 'clear))))
        (send . ,(lambda (port datum) (funcall (%lookup outq 'enqueue) (Output-Message/new port datum))))
        (outputs . ,(lambda () (funcall (%lookup outq 'contents))))
        (map-outputs . ,(lambda (f) 
                              (let ((output-list (funcall (%lookup outq 'contents))))
                                (mapcar #'(lambda (m)
                                          (funcall f m))
                                      output-list))))

        ;; debuggery
        (finputs . ,(lambda () (let ((ins (funcall (%lookup inq 'contents))))
                                 (mapcar #'(lambda (m) (format-message m)) ins))))
        (foutputs . ,(lambda () (let ((ins (funcall (%lookup outq 'contents))))
                                 (mapcar #'(lambda (m) (format-message m)) ins))))
        ;; ideally, these debug methods are not needed, or, should be made to be alist methods in the above alist, but,
        ;; I'm straddling two worlds - sync vs. async, so I am forced to use sync debug methods while bootstrapping
        ;; the "right" way to debug async is to use a tree of backtraces - attach the backtrace to each message as a list of cause/effect
        ;; messages ; a single backtrace of control-flow is not sufficient, we need to see where each message went and what new messages 
        ;; each message caused ; in Lisp, tracking this is easy - just tack the causing message onto the end of every message (you automatically
        ;; get a tree of messages) and then provide a "debugger" to examine the chain of events (in the interim, emacs "lisp mode" formatting
        ;; is good enough)x
        
        ))))

(defun %type-of (x)
  (%call x '%type))
