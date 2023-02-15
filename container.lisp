(defun Container/new (given-name children connections)
  (let ((name (format nil "%a/Container" given-name)))
    (let ((eh (Eh/new name)))
      `((enter . ,(lambda ()))
	(exit . ,(lambda ()))
	(reset . ,(lambda () (reset-children children)))
	(busy? . ,(lambda () (any-child-busy? children)))
	(handle . ,(lambda (msg)
		     (route-downwards (%call msg 'port) (%call msg 'datum) eh children connections)))
	
	(step . ,(lambda ()
		   (cond ((any-child-busy? children)
			  (step-all-children eh children connections)
			  True)
			 ((cond ((not (%call eh 'empty-input?))
				 (let ((msg (%call eh 'dequeue-input)))
				   (route-downwards (%call msg 'port) (%call msg 'datum) eh children connections))
				 True)
				(t False))))))
	
	(step-to-completion . ,(lambda ()
				 (loop while (any-child-busy? children)
				       do (progn
					    (step-all-children eh children connections)
					    (route-inner-messages eh children connections)))))
	(%else . ,eh)))))

(defun any-child-busy? (children)
  (mapc #'(lambda (child)
	    (when (%call child 'busy?)
	      (return-from any-child-busy? t)))
	children)
  nil)

(defun reset-children (children)
  (mapc #'(lambda (child)
	    (%call child 'reset))
        children))

(defun step-all-children (myeh children connections)
  (mapc #'(lambda (child)
            (%call child 'step)
            (route-inner-messages myeh children connections))
        children))

(defun route-inner-messages (myeh children connections)
  (mapc #'(lambda (child) (route-all-inner-outputs-from-single-child child myeh children connections))
	children))

(defun route-all-inner-outputs-from-single-child (child myeh children connections)
  (mapc #'(lambda (msg) 
	    (route-inner-single-datum child (%call msg 'port) (%call msg 'datum) myeh children connections))
	(%call child 'outputs-as-list)))

(defun route-inner-single-datum (from port datum myeh children connections)
  ;; Container routes one datum from a child to all receivers connected to the given {from,port} combination
  ;; handle across and up connections only - down and through do not apply here
  (mapc #'(lambda (connection)
	    (cond ((%call connection 'sender-matches? from port)
		   (let ((kind (%call connection 'kind))
			 (receiver (%call connection 'receiver children)))
		     (cond 
		      ((equal kind 'across)
		       (let ((receiver-port (%call connection 'receiver-port)))
			 (let ((msg (Input-Message/new receiver-port datum)))
			   (%call receiver 'enqueue-input msg))))
		      
		      ((equal kind 'up)
		       (let ((receiver-port (%call connection 'receiver-port)))
			 (let ((msg (Output-Message/new receiver-port datum)))
			   (%call myeh 'enqueue-output msg))))
		      
		      ((or (equal kind 'down) (equal kind 'through)) nil)

		      (t (error "internal error 1 in route-inner-single-item")))))
		  (t nil))) ;; {from, port} doesn't match - pass
	connections))

(defun route-downwards (port datum myeh children connections)
  ;; Container routes its own input to its children and/or itself
  ;; across and up do not apply here
  (mapc #'(lambda (connection)
	    (cond ((%call connection 'sender-matches? (Sender/new Me port))
		   (let ((kind (%call connection 'kind))
			 (receiver (%call connection 'receiver children)))
		     (cond 
		      ((equal kind 'down)
		       (let ((receiver-port (%call connection 'receiver-port)))
			 (let ((msg (Input-Message/new receiver-port datum)))
			   (%call receiver 'enqueue-input msg))))
		      
		      ((equal kind 'through)
		       (let ((receiver-port (%call connection 'receiver-port)))
			 (let ((msg (Output-Message/new receiver-port datum)))
			   (%call myeh 'enqueue-output msg))))
		      
		      ((or (equal kind 'up) (equal kind 'across)) nil)

		      (t (error "internal error 2 in route-downwards")))))
		  (t nil))) ;; {Me, port} doesn't match - pass
	connections))

