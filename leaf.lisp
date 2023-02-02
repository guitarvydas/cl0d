(defclass Leaf (EH)
  ())

(defmethod initialize-instance :after ((self EH))
  (let ((defname "default"))
    (setf (default-name self) defname)
    (let ((handler (make-instance 'Port-Handler :port "*" 
				  :func #'__handler__)))
      (setf (handler self) handler)
      (let ((s (make-instance 'State :machine self :name defname :enter nil
			      :handlers (list handler) :exit nil 
			      :child-machine nil)))
	(setf (enter self) #'noop
	      (exit self)  #'noop
	      (states self) (list s))))))
  

