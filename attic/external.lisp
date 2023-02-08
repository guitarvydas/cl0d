(defclass id
  ((name :accessor name :initarg :name)))

(defclass yes/no
  ((bool :accessor bool :initarg :bool)))


(defun new[id] ((String name))
  (make-instance 'id :name name))

(defun new[yes/no] (v)
  (make-instance 'yes/no :bool (if v t nil)))
