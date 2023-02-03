(defclass Hello-World-Sequential (Container)
  ())

(defmethod initialize-instance :around ((self Hello-World-Sequential) &KEY &ALLOW-OTHER-KEYS)
  (let ((e1 (make-instance 'Echo :parent self 
			   :name (format nil "~a/~a" (name self) "e1")))
	(e2 (make-instance 'Echo :parent self 
			   :name (format nil "~a/~a" (name self) "e2"))))
    (setf (children self) (list e1 e2))
    (setf (connections self) 
	  (list
	   (make-instance 'Down 
			  :sender (make-instance 'Sender :from self :port "stdin")
			  :receiver (make-instance 'Receiver :target e1 :port "stdin"))
	   (make-instance 'Across 
			  :sender (make-instance 'Sender :from e1 :port "stdout")
			  :receiver (make-instance 'Receiver :target e2 :port "stdin"))
	   (make-instance 'Up 
			  :sender (make-instance 'Sender :from e2 :port "stdout")
			  :receiver (make-instance 'Receiver :target self :port "stdout"))))
    (call-next-method)))
