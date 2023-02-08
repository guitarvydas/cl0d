(defun Schedulable/new ()
  (let ((inq (FIFO/new))
	(outq (FIFO/new)))
    `(
      ;; input queue
      (enqueue-input . ,(lambda (x) (funcall (%lookup inq 'enqueue) x)))
      (dequeue-input . ,(lambda () (funcall (%lookup inq 'dequeue))))
      (empty-input? . ,(lambda ()  (funcall (%lookup inq 'empty?))))
      
      ;; output queue
      (send . ,(lambda (port msg) (funcall (%lookup outq 'enqueue) (Output-Message/new port msg))))
      (empty-output? . ,(lambda () (funcall (%lookup outq 'empty?))))
      (for-each-output . ,(lambda (f) (funcall (%lookup outq 'for-each) f)))
      (clear-output . ,(lambda () (funcall (%lookup outq 'clear))))
      (outputs . ,(lambda () (funcall (%lookup outq 'contents))))
      )))

