(defclass Leaf (EH)
  ())

(defmethod initialize-instance :around ((self Leaf) &KEY &ALLOW-OTHER-KEYS)
  (let ((defname "default"))
    (setf (default-state-name self) defname)
    (let ((handler (make-instance 'Port-Handler :port "*" 
				  :func #'__handler__)))
      (let ((s (make-instance 'State :machine self :name defname :enter-func #'(lambda (x))
			      :handlers (list handler) :exit-func #'(lambda (x))
			      :child-machine nil)))
	(setf (states self) (list s))))
    (call-next-method)))
  

