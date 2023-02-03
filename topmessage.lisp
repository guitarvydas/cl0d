(defclass Top-Message (Input-Message)
  ()
  (:default-initargs
   :trail nil))

(defmethod initialize-instance :around ((self Top-Message) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))
