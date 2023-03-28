;; exported low-level constructors

(defun gen-unique-token (component port)
  (let ((id (and component (%lookup component '%id))))
    (let ((token (sxhash (list id port))))
      (format *error-output* "gen unique token ~a = ~a ~a ~a~%"
              token
              id
              (and component (%call component 'name))
              port)
      token)))

(defun Sender/new (component port)
  (let ((token (gen-unique-token component port)))
    `((token . ,(lambda () token))
      ;; bootstrap debugging
      (%component . ,component)
      (%port . ,port)
      (%token . ,token)
      ;; end bootstrap debugging
      (%type . ,(lambda () 'Sender)))))

(defun Receiver/new (queue port)
  `((queue . ,(lambda () queue))
    (port . ,(lambda () port))
    (%type . ,(lambda () 'Receiver))))

(defun sender-matches? (sender other)
  (cond ((eq 'Sender (%type-of other))
	 (let ((other-token (%call other 'token))
	       (my-token (%call sender 'token)))
         ;; debug bootstrap
         (when (eq my-token other-token)
           (let ((sname (and (%lookup sender '%component) (%call (%lookup sender '%component) 'name)))
                 (oname (and (%lookup other '%component) (%call (%lookup other '%component) 'name)))
                 (sid (and (%lookup sender '%component) (%lookup (%lookup sender '%component) '%id)))
                 (oid (and (%lookup other '%component) (%lookup (%lookup other '%component) '%id)))
                 )
             (when (not (equal sname oname))
               (format *error-output* "~a ~a ~a ~a~%" my-token sid sname (%lookup sender '%port))
               (format *error-output* "~a ~a ~a ~a~%" other-token oid oname (%lookup other '%port))
               (throw 'sender-matches-error-1 (values)))
             (when (not (equal (%lookup sender '%port) (%lookup other '%port)))
               (format *error-output* "~a ~a ~a ~a~%" my-token sid sname (%lookup sender '%port))
               (format *error-output* "~a ~a ~a ~a~%" other-token oid oname (%lookup other '%port))
               (throw 'sender-matches-error-2 (values)))
             ))
         ;; end debug bootstrap
	   (eq my-token other-token)))
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
  (append `((%debug . down)
            (kind . ,(lambda () 'down))
	    (deposit . ,(lambda (datum) 
                          (format *error-output* "Down~%")
			  (%call (%call receiver 'queue) 'enqueue
				 (Input-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

(defun Up/new (sender receiver)
  (append `((kind . ,(lambda () 'up))
	    (deposit . ,(lambda (datum) 
                          (format *error-output* "Up~%")
			  (%call (%call receiver 'queue) 'enqueue
				 (Output-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

(defun Across/new (sender receiver)
  (append `((kind . ,(lambda () 'across))
	    (deposit . ,(lambda (datum) 
                          (format *error-output* "Across~%")
			  (%call (%call receiver 'queue) 'enqueue
				 (Input-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

(defun Through/new (sender receiver)
  (append `((kind . ,(lambda () 'through))
	    (deposit . ,(lambda (datum) 
                          (format *error-output* "Through~%")
			  (%call (%call receiver 'queue) 'enqueue
				 (Output-Message/new (%call receiver 'port) datum)))))
	  (Connector/new sender receiver)))

