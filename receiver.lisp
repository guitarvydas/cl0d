(defclass Receiver ()
  ((who :accessor who :initarg :who)
   (port :accessor port :initarg :port)))

;; who is used internally only and is never accessed externally
    
(defmethod name ((self Receiver))
  (format nil "~a[~a]" (name (who self)) (port self)))

(defmethod enqueue-input ((self Receiver) msg)
  (enqueue-input (who self) msg))

(defmethod enqueue-output ((self Receiver) msg)
  (enqueue-output (who self) msg))
