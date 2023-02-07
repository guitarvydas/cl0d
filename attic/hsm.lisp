(defclass HSM (Debuggable)
  ((name :accessor name :initarg :name)
   (default-state-name :accessor default-state-name :initarg :default-state-name)
   (enter-func :accessor enter-func :initarg :enter-func :initform nil)
   (exit-func :accessor exit-func :initarg :exit-func :initform nil)
   (states :accessor states :initarg :states)
   (state :accessor state :initform nil)))

(defmethod initialize-instance :around ((self HSM) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method)
  (enable-excruciating-detail self)
  (enter self))

(defmethod enter ((self HSM))
  (when (enter-func self)
    (funcall (enter-func self) self))
  (setf (state self) (lookup-state self (default-state-name self) (states self)))
  (enter (state self)))

(defmethod exit ((self HSM))
  (when (exit-func self)
    (funcall (exit-func self) self))
  (exit (state self)))

(defmethod next ((self HSM) state-name)
  (exit (state self))
  (setf (state self) (lookup-state self state-name (states self))))

(defmethod reset ((self HSM))
  (reset (state self))
  (exit (state self))
  (enter (lookup-state self (default-state-name self) (states self))))

(defmethod handle ((self HSM) msg)
  (handle (state self) msg))

(defmethod step-hsm ((self HSM))
  (when (excruciating-detail self)
    (format *error-output* "stepping ~a in state ~a" (name self) (name (state self))))
  (step-hsm (state self)))

(defmethod busy-p ((self HSM))
  (busy-p (state self)))

; worker

(defun lookup-state (self name state-list)
  (when state-list
    (if (equal name (name (car state-list)))
	(car state-list)
      (lookup-state self name (cdr state-list)))))
