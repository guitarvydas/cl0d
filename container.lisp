handle (msg)
enter
exit
reset
step
busy?

^ envelope

(defun Container/new (name eh children connections)
  (let ((busy nil))
    `((handle . ,(lambda (msg) ... ))
      (enter . ,(lambda ()))
      (exit . ,(lambda ()))
      (reset . ,(lambda () (reset-children children) (setf busy nil)))
      (step . ,(lambda ()))
      (busy? . ,(lambda () (any-child-busy? children)))
      (%else . ,eh))))


(defun any-child-busy? (children)
  (mapc #'(lambda (child)
	    (when (apply (%lookup child 'busy? ))
	      (return-from any-child-busy? t)))
	children)
  nil)

(defun step ...)

(defun reset-children (children)
  (mapc #'(lambda (child)
	    (apply (%lookup child 'reset)))
	children)
