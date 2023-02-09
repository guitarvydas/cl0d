(defun Echo/new (given-name)
  (let ((f nil))
    (let ((indirect-f (lambda (msg) (apply f (list msg)))))
      (let ((name (format nil "~a/Echo" given-name)))
	(let ((leaf (Leaf/new name indirect-f)))
          (setf f (lambda (msg) (apply (%lookup leaf 'send) (list "stdout" (apply (%lookup msg 'data) nil)))))
          `((func . ,f)
            (%else . ,leaf)))))))

