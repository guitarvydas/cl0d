(defclass Across (Connection)
  ())

(defmethod guarded-deliver ((self Across) (msg Output-Message))
   ;; try to deliver the message
  ;; deliver only if message's from and port match this connection's sender's from and port, otherwise do nothing
  (when (match-p (sender self) (from msg) (port msg))
    (let ((receiver (receiver self))
	  (sender (sender self)))
      (debug self "across" msg sender receiver)
      (let ((mapped-message (make-instance 'Input-Message 
					   :from sender
					   :port (port receiver)
					   :data (data msg)
					   :trail msg)))
	(enqueue-input receiver mapped-message)))))
