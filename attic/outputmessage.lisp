(defclass Output-Message (Message)
  ()
  (:default-initargs
   :direction 'out))

(defmethod initialize-instance :around ((self Output-Message) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))
