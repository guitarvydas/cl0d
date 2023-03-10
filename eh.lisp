(defun Eh/new (given-name)
  (let ((name (format nil "~a/Eh" given-name)))
    (let ((sched (Schedulable/new name)))
      `((name . ,(lambda () name))
	(append-name . ,(lambda (s) (setf name (format nil "~a/~a" name s))))
        (%type . ,(lambda () nil))
	(%else . ,sched)))))

(defun %type-of (x)
  (%call x '%type))