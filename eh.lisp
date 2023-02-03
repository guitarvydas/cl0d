(defclass EH (HSM Receiver-Queue Sender-Queue Runnable)
  ())

(defmethod initialize-instance :around ((self EH) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))
