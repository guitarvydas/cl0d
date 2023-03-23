(defun Eh/new (given-name)
  (let ((name (format nil "[Eh ~a]" given-name)))
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
                                      output-list))))))))

(defun %type-of (x)
  (%call x '%type))
