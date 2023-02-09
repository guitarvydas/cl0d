(defun Echo/new (eh)
  (apply (%lookup eh 'append-name) (list "Echo"))
  (let ((f nil))
    (let ((indirect-f (lambda (msg) (apply f (list msg)))))
      (let ((leaf (Leaf/new indirect-f eh)))
        (setf f (lambda (msg) (apply (%lookup leaf 'send) (list "stdout" (apply (%lookup msg 'data) nil)))))
        `((func . ,f)
          (%else . ,leaf))))))

