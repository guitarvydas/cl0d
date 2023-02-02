(defclass Hello-World-Concurrent (Container)
  ())

(defmethod initialize-instance :after ((self Hello-World-Concurrent) &KEY &ALLOW-OTHER-KEYS)
  (let ((e1 (make-instance 'Echo :parent self 
			   :name (format nil "~a/~a" (name self) "e1")))
	(e2 (make-instance 'Echo :parent self 
			   :name (format nil "~a/~a" (name self) "e2")))
	(e3 (make-instance 'Echo :parent self 
			   :name (format nil "~a/~a" (name self) "e3"))))
    (setf (children self) (list e1 e2 e3))
    (setf (connections self) 
	  (list
	   (make-instance 'Pass-Through
			  :sender (make-instance 'Sender :from self :port "stdin")
			  :receiver (make-instance 'Receiver :target self :port "stdout"))
	   (make-instance 'Down 
			  :sender (make-instance 'Sender :from self :port "stdin")
			  :receiver (make-instance 'Receiver :target e1 :port "stdin"))
	   (make-instance 'Down 
			  :sender (make-instance 'Sender :from self :port "stdin")
			  :receiver (make-instance 'Receiver :target e2 :port "stdin"))
	   (make-instance 'Down 
			  :sender (make-instance 'Sender :from self :port "stdin")
			  :receiver (make-instance 'Receiver :target e3 :port "stdin"))
	   (make-instance 'Up 
			  :sender (make-instance 'Sender :from e1 :port "stdout")
			  :receiver (make-instance 'Receiver :target self :port "stdout"))
	   (make-instance 'Up 
			  :sender (make-instance 'Sender :from e2 :port "stdout")
			  :receiver (make-instance 'Receiver :target self :port "stdout"))
	   (make-instance 'Up 
			  :sender (make-instance 'Sender :from e3 :port "stdout")
			  :receiver (make-instance 'Receiver :target self :port "stdout"))))))


