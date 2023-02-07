(defclass Down (Connection)
  ())

(defmethod initialize-instance :around ((self Down) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

(defmethod guarded-deliver ((self Down) (msg Input-Message))
  ;; try to deliver the message
  ;; deliver only if message's from and port match this connection's sender's from and port, otherwise do nothing
  (when (match-p (sender self) (from msg) (port msg))
    (let ((receiver (receiver self))
	  (sender (sender self)))
      (debug self "down" msg sender receiver)
      (let ((mapped-message (make-instance 'Input-Message 
					   :from sender
					   :port (port receiver)
					   :data (data msg)
					   :trail msg)))
	(enqueue-input receiver mapped-message)))))
