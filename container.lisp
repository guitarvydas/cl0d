
(defclass Container (EH)
  ())
  ;; ((default-name :accessor default-name :initform "default")
  ;;  ...))

(defmethod initialize-instance :after ((self EH))
  (let ((defname "default"))
    (setf (default-name self) defname)
    (let ((handler (make-instance 'Port-Handler :port "*" 
				  :func #'(lambda (msg) (handle self msg)))))
      (setf (handler self) handler)
      (let ((s (make-instance 'State :machine self :name defname :enter nil
			      :handlers (list handler) :exit nil :child-machine nil)))
	(setf (enter self) #'noop
	      (exit self)  #'noop
	      (states self) (list s))))))
  

(defmethod handle ((self Container) msg)
  (mapc #'(lambda (connection)
	    (guarded-deliver connection msg))
	(connections self))
  (run-to-completion self))

(defmethod noop ((self Container))
  )

;; helpers
(defmethod run-to-completion ((self Container))
  (loop while (any-child-ready-p self)
	do (mapc #'(lambda (child)
		     (handle-if-ready child)
		     (route-outputs self))
		 (children self))))

(defmethod any-child-ready-p ((self Container))
  (mapc #'(lambda (child)
	    (when (is-ready-p child)
	      (return-from any-child-ready-p t))))
  nil)

(defmethod route-outputs ((self Container) child)
  (let ((outputs (ouput-queue child)))
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
