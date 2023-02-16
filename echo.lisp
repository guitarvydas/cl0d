(defun Echo/new (given-name)
  (let ((f nil))
    (let ((indirect-f (lambda (msg) (apply f (list msg)))))
      (let ((name (format nil "~a/Echo" given-name)))
	(let ((leaf (Leaf/new name indirect-f)))
          (setf f (lambda (msg)
                    ;(format *error-output* "Echo handle ~a~%" (format-message msg))
                    #+nil(progn
                      (apply (%lookup leaf 'send) (list "stdout" name))
                      (apply (%lookup leaf 'send) (list "stdout" (apply (%lookup msg 'datum) nil)))
                      )
                    (progn
                      (apply (%lookup leaf 'send) (list "stdout" (format nil "~a/~a" name (apply (%lookup msg 'datum) nil))))
                      )
                    ))
          `((func . ,f)
            (%else . ,leaf)))))))

