(defun Schedulable/new ()
  (let ((inq (FIFO/new))
	(outq (FIFO/new)))
    `(
      ;; input queue
      ('enqueue-input . ,(lambda (x) (funcall (%delegate inq 'enqueue) x)))
      ('dequeue-input . ,(lambda () (funcall (%delegate inq 'dequeue))))
      ('empty-input? . ,(lambda ()  (funcall (%delegate inq 'empty?))))
      
      ;; output queue
      ('send . ,(lambda (port msg) (funcall (%delegate outq 'enqueue) port msg)))
      ('empty-output? . ,(lambda () (funcall (%delegate outq 'empty?))))
      ('for-each-output . ,(lambda (f) (funcall (%delegate outq 'for-each) f)))
      ('clear-output . ,(lambda () (funcall (%delegate outq 'clear))))
      ('outputs . ,(lambda () (funcall (%delegate outq 'contents))))
      )))

