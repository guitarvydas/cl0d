(defclass Connection (Debuggable)
  ((sender :accessor sender :initarg :sender)
   (receiver :accessor receiver :initarg :receiver)))

(defmethod initialize-instance :around ((self Connection) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

(defmethod debug ((self Connection) note msg sender receiver)
  (when (excruciating-detail self)
    (format *error-output* "~s ~a ... ~a -> ~a~%"
	    note msg (name sender) (name receiver))))
