(defclass Sender ()
  ((from :accessor from :initarg :from)
   (port :accessor port :initarg :port)))

(defmethod match-p ((self Sender) other port)
  (and (equal (from self) other)
       (equal (port self) port)))
