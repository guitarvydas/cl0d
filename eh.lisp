(defun Eh/new (given-name)
  (let ((name (format nil "~a/Schedulable" given-name)))
    (let ((sched (Schedulable/new)))
      `((name . ,(lambda () name))
	(%else . ,sched)))))
