(defclass Up (Connection)
  ())

(defmethod guarded-deliver ((self Up) (msg Output-Message))
  ;; try to deliver the message
  ;; deliver only if message's from and port match this connection's sender's from and port, otherwise do nothing
  (when (match-p (sender self) (from msg) (port msg))
    (let ((receiver (receiver self))
	  (sender (sender self)))
      (debug self "up" msg sender receiver)
      (let ((mapped-message (make-instance 'Output-Message 
					   :from sender
					   :port (port receiver)
					   :data (data msg)
					   :trail msg)))
	(enqueue-output receiver mapped-message)))))
