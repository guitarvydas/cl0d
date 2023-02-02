(defclass State ()
  ((machine :accessor machine :initarg :machine)
   (name :accessor name :initarg :name)
   (enter-func :accessor enter-func :initarg :enter-func)
   (handlers :accessor handlers :initarg :handlers)
   (exit-func :accessor exit-func :initarg :exit-func)
   (child-machine :accessor child-machine :initarg :child-machine)))

(defmethod enter ((self State))
  (when (enter-func self)
    (funcall (enter-func self) self))
  (when (child-machine self)
    (enter (child-machine self))))

(defmethod exit ((self State))
  (when (exit-func self)
    (funcall (exit-func self) self))
  (when (child-machine self)
    (exit (child-machine self))))

(defmethod handle ((self State) msg)
  (let ((r (handler-chain self msg (handlers self) (child-machine self))))
    (cond (r t)
	  ((child-machine self) (handle (child-machine self) msg))
	  (t nil))))

(defmethod busy-p ((self State))
  (cond ((child-machine self) (busy-p (child-machine self)))
	(t nil)))

;; worker bee
(defun handler-chain (self msg handlers sub-machine)
  (cond (handlers
	 (let ((handler (car handlers))
	       (rest (cdr handlers)))
	   (cond ((match-port handler (port msg)) (funcall (func handler) msg) t)
		 (t (handler-chain self msg rest sub-machine)))))
	(sub-machine (handle sub-machine msg))
	(t nil)))
