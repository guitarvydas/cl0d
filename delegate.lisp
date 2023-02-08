(defun %delegate (alist key)
  ;; return function stored at "key" in alist
  (let ((pair (assoc key alist)))
    (if pair
        (cdr pair)
      (let ((else-pair (assoc '%else alist)))
        (if else-pair
            (let ((ancestor (cdr else-pair)))
              (%delegate ancestor key))
          (error (format nil "internal error %delegate can't find ~a in ~a" key alist)))))))

(defun % (alist key)
  (let ((pair (assoc key alist)))
    (if pair
        (cdr pair)
      (error (format nil "internal error % can't find ~a in ~a" key alist)))))

(defun %lookup (alist key) ;; %lookup is a synonym for %
  (% alist key))
