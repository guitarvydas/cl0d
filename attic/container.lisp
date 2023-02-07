
(defclass Container (EH)
  ((children :accessor children :initarg :children)
   (connections :accessor connections :initarg :connections)))

(defmethod initialize-instance :around ((self Container) &KEY &ALLOW-OTHER-KEYS)
  (setf (default-state-name self) "default")
  (let ((handler (make-instance 'Port-Handler :port "*" 
                                :func #'(lambda (msg) (handle self msg)))))
    (let ((s (make-instance 'State :machine self :name (default-state-name self) :enter-func #'(lambda (x))
                            :handlers (list handler) :exit-func #'(lambda (x)) :child-machine nil)))
      (setf (states self) (list s)))
    (call-next-method)))
  

(defmethod handle ((self Container) msg)
  (mapc #'(lambda (connection)
	    (guarded-deliver connection msg))
	(connections self))
  (run-to-completion self))


;; helpers
(defmethod run-to-completion ((self Container))
  (loop while (any-child-ready-p self)
	do (mapc #'(lambda (child)
		     (handle-if-ready child)
		     (route-outputs self child))
		 (children self))))

(defmethod any-child-ready-p ((self Container))
  (mapc #'(lambda (child)
	    (when (ready-p child)
	      (return-from any-child-ready-p t)))
        (children self))
  nil)

(defmethod route-outputs ((self Container) child)
  (let ((outputs (output-queue child)))
    (clear-outputs child)
    (mapc #'(lambda (msg)
	      (mapc #'(lambda (conn)
			(guarded-deliver conn msg))
		    (connections self)))
	  outputs)))

(defmethod inject ((self Container) port data)
  (let ((m (make-instance 'Top-Message :from self :port port :data data)))
    (inject-message self m)))

(defmethod start ((self Container) port data)
  (inject self port data)
  (run self))
