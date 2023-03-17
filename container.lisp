(defun Container/new (given-name children connections)
  (let ((name (format nil "%a/Container" given-name)))
    (let ((eh (Eh/new name)))
      `((handle . ,(lambda (msg)
		     (route-downwards (%call msg 'port) (%call msg 'datum) eh connections)
                     (try-all-children eh children connections)))
	(%else . ,eh)))))


(defun try-all-children (myeh children connections)
  (mapc #'(lambda (child)
            (cond ((not (%call child 'empty-input?))
                   (let ((msg (%call child 'dequeue-input)))
                     (%call child 'handle msg)
                     (route-and-clear-outputs-from-single-child child myeh connections)))))
        children))

(defun route-and-clear-outputs-from-single-child (child myeh connections)
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

