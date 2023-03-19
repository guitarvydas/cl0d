(defclass Runnable ()
  ((parent :accessor parent :initarg :parent)
   (name :accessor name :initarg :name)
   (top :accessor top :initarg :top)))

(defmethod initialize-instance :around ((self Runnable) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

(defmethod run ((self Runnable))
  (loop while (busy-p self)
	do (step self))
  (loop while (handle-if-ready self)
	do (loop while (busy-p self)
		 do (step self))))
