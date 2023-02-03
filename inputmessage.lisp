(defclass Input-Message (Message)
  ()
  (:default-initargs
   :direction 'in))

(defmethod initialize-instance :around ((self Input-Message) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))
