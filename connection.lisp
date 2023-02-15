;; exported low-level constructors

(defun Sender/new (component port)
  `((component . ,(lambda () component))
    (port . ,(lambda () port))))

(defun Receiver/new (component port)
  `((component . ,(lambda () component))
    (port . ,(lambda () port))))


;; not meant to be exported - Connector/new is meant to be private to the constructors
;; herein...
(defun Connector/new (sender receiver)
  `((sender . ,(lambda () sender))
    (receiver . ,(lambda () receiver))
    (sender-matches? . ,(lambda (other)
			  (cond ((eq 'Sender (type-of other))
				 (let ((other-component (%call other 'component))
				       (other-port (%call other 'port))
				       (my-component (%call sender 'component))
				       (my-port (%call sender 'port)))
				   (cond ((and (equal other-component my-component)
					       (equal other-port my-port))
					  $True)
					 (t $False))))					 
				(t $False)))
    ))


;; exported constructors for connectors of different kinds

(defun Down/new (sender receiver)
  (cons `(kind . ,(lambda () 'down)) (Connector/new sender receiver)))
(defun Up/new (sender receiver)
  (cons `(kind . ,(lambda () 'up)) (Connector/new sender receiver)))
(defun Across/new (sender receiver)
  (cons `(kind . ,(lambda () 'across)) (Connector/new sender receiver)))
(defun Through/new (sender receiver)
  (cons `(kind . ,(lambda () 'through)) (Connector/new sender receiver)))
