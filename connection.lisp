;; exported low-level constructors

(defun gen-unique-token (component port)
  (sxhash (list component port)))

(defun Sender/new (component port)
  (let ((token (gen-unique-token component port)))
    `((token . ,(lambda () token))
      (%type . ,(lambda () 'Sender))))

(defun Receiver/new (queue port)
  `((queue . ,(lambda () queue))
    (port . ,(lambda () port))
    (%type . ,(lambda () 'Receiver))))

(defun sender-matches? (sender other)
  (cond ((eq 'Sender (%type-of other))
	 (let ((other-token (%call other 'token)
	       (my-token (%call sender 'token))))
	   (eq my-token other-token)))
	(t $False)
	   
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
			  (%call (%call receiver 'queue) 'enqueue
				 (Input-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

(defun Up/new (sender receiver)
  (append `((kind . ,(lambda () 'up))
	    (deposit . ,(lambda (datum) 
			  (%call (%call receiver 'queue) 'enqueue
				 (Output-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

(defun Across/new (sender receiver)
  (append `((kind . ,(lambda () 'across))
	    (deposit . ,(lambda (datum) 
			  (%call (%call receiver 'queue) 'enqueue
				 (Input-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

(defun Through/new (sender receiver)
  (append `((kind . ,(lambda () 'through))
	    (deposit . ,(lambda (datum) 
			  (%call (%call receiver 'queue) 'enqueue
				 (Output-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

