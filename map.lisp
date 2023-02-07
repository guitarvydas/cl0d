(defun MAP/new (alist)
  alist)

(defun % (map sym &rest args)
  (let ((pair (assoc sym map)))
    (unless pair (format *error-output* "internal error: ~a not found in ~a~%" sym map))
    (let ((func (cdr pair)))
      (apply func args))))
