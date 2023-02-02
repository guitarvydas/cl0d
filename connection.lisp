(defclass Connection (Debuggable)
  ((sender :accessor sender :initarg :sender)
   (receiver :accessor receiver :initarg :receiver)))

(defmethod debug ((self Connection) note msg sender receiver)
  (when (excrutiating-detail self)
    (format *standard-error* "~s ~a ... ~a -> ~a~%"
	    note msg (name sender) (name receiver))))
