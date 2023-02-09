(defun Eh/new (given-name)
  (let ((name (format nil "~a/Schedulable" given-name)))
    (let ((sched (Schedulable/new)))
      `((name . ,(lambda () name))
	(append-name . ,(lambda (s) (setf name (format nil "~a/~a" name s))))
	(%else . ,sched)))))

