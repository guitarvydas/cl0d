(defclass Leaf (EH)
  ())

(defmethod initialize-instance :after ((self Leaf) &KEY &ALLOW-OTHER-KEYS)
  (let ((defname "default"))
    (setf (default-state-name self) defname)
    (let ((handler (make-instance 'Port-Handler :port "*" 
				  :func #'__handler__)))
      (let ((s (make-instance 'State :machine self :name defname :enter-func #'noop
			      :handlers (list handler) :exit-func #'noop
			      :child-machine nil)))
	(setf (states self) (list s))))))
  

