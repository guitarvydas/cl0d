;; not meant to be exported - Connector/new is meant to be private to the constructors
;; herein...
(defun Connector/new (sender-index sender-port receiver-index receiver-port)
  `((sender . ,(lambda (self children-array) 
		 (cond ((< sender-index 0) 
			self)
		       (t (nth sender-index children-array)))))
    (sender-port . ,(lambda () sender-port))
    (receiver . ,(lambda (self children-array) 
		 (cond ((< receiver-index 0) 
			self)
		       (t (nth receiver-index children-array)))))
    (receiver-port . ,(lambda () receiver-port))))

;; exported constructors for connectors of different kinds

(defun Down/new (sender-index sender-port receiver-index receiver-port)
  (cons `(kind . ,(lambda () 'down)) (Connector/new sender-index sender-port 
						    receiver-index receiver-port)))

(defun Across/new (sender-index sender-port receiver-index receiver-port)
  (cons `(kind . ,(lambda () 'across)) (Connector/new sender-index sender-port 
						    receiver-index receiver-port)))
(defun Up/new (sender-index sender-port receiver-index receiver-port)
  (cons `(kind . ,(lambda () 'up)) (Connector/new sender-index sender-port 
						    receiver-index receiver-port)))
(defun Through/new (sender-index sender-port receiver-index receiver-port)
  (cons `(kind . ,(lambda () 'through)) (Connector/new sender-index sender-port 
						    receiver-index receiver-port)))

