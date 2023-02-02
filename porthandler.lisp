(defclass Port-Handler ()
  ((port :accessor port :initarg :port)
   (func :accessor funct :initarg :func)))

;; A Function associated with a Port (a string)
;; The port '*' means any port.

(defmethod match-port ((self Port-Handler) port-name)
  (cond ((equal "*" port-name) t)
	((equal (port self) port-name) t)
	(t nil)))
