(defclass Debuggable ()
  ((excruciating-detail :accessor excruciating-detail :initform nil :initarg :excruciating-detail)))

(defmethod initialize-instance :around ((self Debuggable) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

(defmethod enable-excruciating-detail ((self Debuggable))
  (setf (excruciating-detail self) t))
(defmethod disable-excruciating-detail ((self Debuggable))
  (setf (excruciating-detail self) nil))
