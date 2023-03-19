(defun %lookup (alist key)
  ;; return function stored at "key" in alist, searching through all nested
  ;; ancestors until the first function found
  (let ((pair (assoc key alist)))
    (if pair
        (cdr pair)
      (let ((else-pair (assoc '%else alist)))
        (if else-pair
            (let ((ancestor (cdr else-pair)))
              (%lookup ancestor key))
          (error (format nil "internal error %lookup can't find ~a in ~a" key alist)))))))

(defun % (alist key)
  ;; return function stored at "key" in alist, without searching ancestors
  (let ((pair (assoc key alist)))
    (if pair
        (cdr pair)
      (error (format nil "internal error % can't find ~a in ~a" key alist)))))

(defun %call (alist key &rest args)
  ;(format *error-output* "%call ~a ~a~%" key (format-args args))
  (apply (%lookup alist key) args))

(defun %delegate (alist key &rest args) ;; same as %call - this should probably be a macro
  ;(format *error-output* "%delegate ~a ~a~%" key (format-args args))
  (apply (%lookup alist key) args))

(defun format-args (args)
  (mapcar #'(lambda (arg)
              (mapcar #'(lambda (pair) (car pair)) arg))
          args))
              