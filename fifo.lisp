(defun FIFO/new ()
  (let ((queue nil))
    (let ((enqueue (lambda (x) (push x queue)))
	  (dequeue (lambda () (cond ((null queue) (throw 'dequeue-empty-queue nil))
				    (t (let ((r (car (last queue))))
					 (setf queue (butlast queue))
					 r)))))
	  (push (lambda (x) (let ((m (list x)))
			      ;; push x onto head of queue (jump the line)
			      (cond ((null queue) (setf queue m))
				    (t (setf queue (append queue m)))))))
						      
	  (clear (lambda () (setf queue nil)))
	  (empty? (lambda () (null queue)))
          (as-list (lambda () (reverse queue)))
          )
      (let ((namespace `((%debug . fifo)
                         (enqueue . ,enqueue)
                         (dequeue . ,dequeue)
                         (push . ,push)
                         (clear . ,clear)
                         (empty? . ,empty?)
                         (as-list . ,as-list)
                         )))
	namespace))))
