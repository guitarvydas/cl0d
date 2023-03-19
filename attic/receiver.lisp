(defclass Receiver ()
  ((target :accessor target :initarg :target)
   (port :accessor port :initarg :port)))

(defmethod initialize-instance :around ((self Receiver) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

;; target is used internally only and is never accessed externally
    
(defmethod name ((self Receiver))
  (format nil "~a[~a]" (name (target self)) (port self)))

(defmethod enqueue-input ((self Receiver) msg)
  (enqueue-input (target self) msg))

(defmethod enqueue-output ((self Receiver) msg)
  (enqueue-output (target self) msg))
