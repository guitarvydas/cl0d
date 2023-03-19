(defun Eh/new (given-name)
  (let ((name (format nil "~a/Eh" given-name)))
    (let ((inq (FIFO/new))
          (outq (FIFO/new)))
      `((name . ,(lambda () name))
	(append-name . ,(lambda (s) (setf name (format nil "~a/~a" name s))))
        (%type . ,(lambda () nil))
        ;; input queue
        (enqueue-input . ,(lambda (x) (funcall (%lookup inq 'enqueue) x)))
        (dequeue-input . ,(lambda () (funcall (%lookup inq 'dequeue))))
        (empty-input? . ,(lambda ()  (funcall (%lookup inq 'empty?))))
        
        ;; output queue
        (send . ,(lambda (port datum) (funcall (%lookup outq 'enqueue) (Output-Message/new port datum))))
        (enqueue-output . ,(lambda (msg) (funcall (%lookup outq 'enqueue) msg)))
        (empty-output? . ,(lambda () (funcall (%lookup outq 'empty?))))
        (clear-output . ,(lambda () (funcall (%lookup outq 'clear))))
        (outputs-as-list . ,(lambda () (funcall (%lookup outq 'contents))))
        (for-each-output . ,(lambda (f) 
                              (let ((output-list (funcall (%lookup outq 'contents))))
                                (mapc f output-list))))))))

(defun %type-of (x)
  (%call x '%type))