(defun Container/new (given-name children connections)
  (let ((name (format nil "%a/Container" given-name)))
    (let ((eh (Eh/new name)))
      `(
	
	
	(busy? . ,(lambda () (any-child-busy? children)))
	(handle . ,(lambda (msg)
		     (route-downwards (%call msg 'port) (%call msg 'datum) eh connections)
                     (loop while (any-child-busy? children)
                           do (step-all-children eh children connections))))

	
	(step . ,(lambda ()
		   (cond ((any-child-busy? children)
			  (step-all-children eh children connections)
			  $True)
			 ((cond ((not (%call eh 'empty-input?))
				 (let ((msg (%call eh 'dequeue-input)))
				   (route-downwards (%call msg 'port) (%call msg 'datum) eh connections))
				 $True)
				(t $False))))))
	
	(%else . ,eh)))))

(defun any-child-busy? (children)
  (mapc #'(lambda (child)
	    (when (or (not (%call child 'empty-input?))
                      (%call child 'busy?))
	      (return-from any-child-busy? $True)))
	children)
  $False)

(defun step-all-children (myeh children connections)
  (mapc #'(lambda (child)
            (let ((action-taken (%call child 'step)))
              (cond ((and (not action-taken)
                          (not (%call child 'empty-input?)))
                     (let ((msg (%call child 'dequeue-input)))
                       (%call child 'handle msg)))
                    (t nil)))
            (route-and-clear-inner-messages myeh children connections))
        children))

(defun route-and-clear-inner-messages (myeh children connections)
  (mapc #'(lambda (child)
            (route-and-clear-all-inner-outputs-from-single-child child myeh connections))
	children))

(defun route-and-clear-all-inner-outputs-from-single-child (child myeh connections)
  (mapc #'(lambda (msg) 
	    (route-inner-single-datum child (%call msg 'port) (%call msg 'datum) myeh connections))
	(%call child 'outputs-as-list))
  (%call child 'clear-output))
        

(defun route-inner-single-datum (from port datum myeh connections)
  ;; Container routes one datum from a child to all receivers connected to the given {from,port} combination
  ;; handle across and up connections only - down and through do not apply here
  (let ((from-sender (Sender/new from port)))
    (mapc #'(lambda (connection)
              (cond ((%call connection 'sender-matches? from-sender)
                     (let ((kind (%call connection 'kind))
                           (receiver (%call connection 'receiver)))
                       (cond 
                        ((equal kind 'across)
                         (let ((receiver-port (%call receiver 'port)))
                           (let ((receiver-component (%call receiver 'component)))
                             (let ((msg (Input-Message/new receiver-port datum)))
                               (%call receiver-component 'enqueue-input msg)))))
                        
                        ((equal kind 'up)
                         (let ((receiver-port (%call receiver 'port)))
                           (let ((msg (Output-Message/new receiver-port datum)))
                             (%call myeh 'enqueue-output msg))))
                        
                        ((or (equal kind 'down) (equal kind 'through)) nil)
                        
                        (t (error "internal error 1 in route-inner-single-item")))))
                    (t nil))) ;; {from, port} doesn't match - pass
          connections)))

(defun route-downwards (port datum myeh connections)
  ;; Container routes its own input to its children and/or itself
  ;; across and up do not apply here
  (mapc #'(lambda (connection)
	    (cond ((%call connection 'sender-matches? (Sender/new $Me port))
		   (let ((kind (%call connection 'kind))
			 (receiver (%call connection 'receiver)))
		     (cond 
		      ((equal kind 'down)
		       (let ((receiver-port (%call receiver 'port)))
                         (let ((receiver-component (%call receiver 'component)))
                           (let ((msg (Input-Message/new receiver-port datum)))
                             (%call receiver-component 'enqueue-input msg)))))
		      
		      ((equal kind 'through)
		       (let ((receiver-port (%call connection 'receiver-port)))
			 (let ((msg (Output-Message/new receiver-port datum)))
			   (%call myeh 'send msg))))
		      
		      ((or (equal kind 'up) (equal kind 'across)) nil)

		      (t (error "internal error 2 in route-downwards")))))
		  (t nil))) ;; {Me, port} doesn't match - pass
	connections))

