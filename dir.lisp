(defun Down/new (sender-index sender-port receiver-index receiver-port)
  `((deposit . ,(lambda (data self) 
		  (let ((in-message (Input-Message/new receiver-port data)))
		    (let ((children (%delegate self 'children)))
		      (let ((receiver (nth receiver-index children))
			    (%delegate receiver 'enqueue-input in-message)))))))))

(defun Across/new (sender-index sender-port receiver-index receiver-port)
  `((deposit . ,(lambda (data self) 
		  (let ((in-message (Input-Message/new receiver-port data)))
		    (let ((children (%delegate self 'children)))
		      (let ((receiver (nth receiver-index children))
			    (%delegate receiver 'enqueue-input in-message)))))))))

(defun Up/new (sender-index sender-port receiver-index receiver-port)
  `((deposit . ,(lambda (data self) 
		  (let ((out-message (Output-Message/new receiver-port data)))
		    (let ((receiver self))
		      (%delegate receiver 'enqueue-output out-message)))))))


(defun Through/new (sender-index sender-port receiver-index receiver-port)
  `((deposit . ,(lambda (data self) 
		  (let ((out-message (Output-Message/new receiver-port data)))
		    (let ((receiver self))
		      (%delegate receiver 'enqueue-output out-message)))))))


