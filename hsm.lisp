(defclass HSM ()
  ((name :accessor name :initarg :name)
   (default-state-name :accessor default-state-name :initarg :default-state-name)
   (enter :accessor enter :initarg :enter)
   (exit :accessor exit :initarg :exit)
   (state :accessor state :initform nil)))

(defmethod initialize-instance :after ((self HSM))
  (setf (excrutiating-detail self) t)
  (enter self))

(defmethod enter ((self HSM))
  (when (enter self)
    (funcall (enter self) self))
  (setf (state self) (lookup-state self (default-state-name self) (states self)))
  (enter (state self)))

(defmethod exit ((self HSM))
  (when (exit self)
    (funcall (exit self) self))
  (exit (state self)))

(defmethod next ((self HSM) state-name)
  (exit-state self)
  (setf (state self) (lookup-state self state-name (states self))))

(defmethod reset ((self HSM))
  (reset (state self))
  (exit (state self))
  (enter-default self))

(defmethod handle ((self HSM) msg)
  (handle (state self) msg))

(defmethod step ((self HSM))
  (when (excrutiating-detail self)
    (format *standard-error* "stepping ~a in state ~a" (name self) (name (state self))))
  (step (state self)))

(defmethod busy-p ((self HSM))
  (busy-p (state self)))

; worker

(defun lookup-state (self name state-list)
  (when state-list
    (if (equal name (name (car state-list)))
	(car state-list)
      (lookup-state self name (cdr state-list)))))
