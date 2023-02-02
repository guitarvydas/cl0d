(defclass Up (Connection)
  ())

(defmethod guarded-deliver ((self Up), in-message)
    ;; try to deliver the message
  ;; deliver only if message's from and port match this connection's sender's from and port, otherwise do nothing
  (when (match (sender self) (from in-message) (port in-message))
    (let ((receiver (receiver self))
	  (sender (sender self)))
      (debug self "up" in-message sender receiver)
      (let ((mapped-message (make-instance 'Output-Message 
					   :from sender
					   :port (port receiver)
					   :data (data in-message)
					   :trail in-message)))
	(enqueue-output receiver mapped-message)))))
