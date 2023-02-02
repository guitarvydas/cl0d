(defclass Across (Connection)
  ())

(defmethod guarded-deliver ((self Across), in-message)
   ;; try to deliver the message
  ;; deliver only if message's from and port match this connection's sender's from and port, otherwise do nothing
  (when (match (sender self) (from in-message) (port in-message))
    (let ((receiver (receiver self))
	  (sender (sender self)))
      (debug self "across" in-message sender receiver)
      (let ((mapped-message (make-instance 'Input-Message 
					   :from sender
					   :port (port receiver)
					   :data (data in-message)
					   :trail in-message)))
	(enqueue-input receiver mapped-message)))))
