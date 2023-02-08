(defun Echo/new (given-name)
  (let ((f nil))
    (let ((indirect-f (lambda (msg) (apply f (list msg)))))
      (let ((my-name (format nil "~a/Echo" given-name)))
        (let ((leaf (Leaf/new my-name indirect-f)))
          (setf f (lambda (msg) (format *error-output* "in f~%") (apply (%lookup leaf 'send) (list "stdout" (apply (%lookup msg 'data) nil)))))
          `((func . ,f)
            (%else . ,leaf)))))))

