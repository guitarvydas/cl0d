(defun Echo/new (given-name)
  (let ((f (lambda (msg) nil)))
    (let ((my-name (format nil "~a/Echo" given-name)))
      (let ((leaf (Leaf/new my-name f)))
	(setf f (lambda (msg) (funcall (%delegate leaf 'send) "stdout" (% msg 'data))))
	`((func . ,f)
	  (%else . ,leaf))))))

