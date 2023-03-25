;; exported low-level constructors

(defun Sender/new (component port)
  `((component . ,(lambda () component))
    (port . ,(lambda () port))
    (%type . ,(lambda () 'Sender))))

(defun Receiver/new (component port)
  `((component . ,(lambda () component))
    (port . ,(lambda () port))
    (%type . ,(lambda () 'Receiver))))

(defun sender-matches? (sender other)
  (cond ((eq 'Sender (%type-of other))
	 (let ((other-component (%call other 'component))
	       (other-port (%call other 'port))
	       (my-component (%call sender 'component))
	       (my-port (%call sender 'port)))
	   (cond ((and (eq other-component my-component)
		       (equal other-port my-port))
		  $True)
		 (t
                  $False))))					 
	(t $False)))

;; not meant to be exported - Connector/new is meant to be private to the constructors
;; herein...
(defun Connector/new (sender receiver)
  `((sender . ,(lambda () sender))
    (receiver . ,(lambda () receiver))
    (sender-matches? . ,(lambda (other) (sender-matches? sender other)))
    ))


;; exported constructors for connectors of different kinds

(defun Down/new (sender receiver)
  (append `((kind . ,(lambda () 'down))
	    (deposit . ,(lambda (datum) 
			  (%call (%call receiver 'component) 'enqueue-input 
				 (Input-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

(defun Up/new (sender receiver)
  (append `((kind . ,(lambda () 'up))
	    (deposit . ,(lambda (datum) 
			  (%call (%call receiver 'component) 'enqueue-output 
				 (Output-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

(defun Across/new (sender receiver)
  (append `((kind . ,(lambda () 'across))
	    (deposit . ,(lambda (datum) 
			  (%call (%call receiver 'component) 'enqueue-input 
				 (Input-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

(defun Through/new (sender receiver)
  (append `((kind . ,(lambda () 'through))
	    (deposit . ,(lambda (datum) 
			  (%call (%call receiver 'component) 'enqueue-output 
				 (Output-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

