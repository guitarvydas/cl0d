(defclass Connection (Debuggable)
  ((sender :accessor sender :initarg :sender)
   (receiver :accessor receiver :initarg :receiver)))

(defmethod debug ((self Connection) note msg sender receiver)
  (when (excruciating-detail self)
    (format *error-output* "~s ~a ... ~a -> ~a~%"
	    note msg (name sender) (name receiver))))
