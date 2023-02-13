(defun Container/new (given-name children connections)
  (let ((name (format nil "%a/Container" given-name)))
    (let ((eh (Eh/new name)))
	  (let ((self-tail
		 `((enter . ,(lambda ()))
		   (exit . ,(lambda ()))
		   (reset . ,(lambda () (reset-children children) (setf busy nil)))
		   (busy? . ,(lambda () (any-child-busy? children)))
		   (%else . ,eh))))
	    (let ((route-single (lambda (msg)
				  (route-single-datum self-tail self-tail 
						      (%call msg 'port) (%call msg 'datum) 
						      children connections))))
	      (cons `(handle . ,(lambda (msg) (apply route-single (list msg))))
		    (cons `(step . ,(lambda () ;; return t if work was done, else nil
				      (cond ((any-child-busy? children) 
					     ;; punt to any (all) child that is still busy
					     (step-all-children children)
					     t)
					    ((not (%call eh 'empty-input?)) 
					     ;; no child busy - is there work in my inq?
					     (let ((msg (%call eh 'dequeue-input)))
					       (apply route-single (list msg))
					       t))
					    (t nil))))
			  self-tail)))))))

(defun any-child-busy? (children)
  (mapc #'(lambda (child)
	    (when (%delegate child 'busy?)
	      (return-from any-child-busy? t)))
	children)
  nil)

(defun reset-children (children)
  (mapc #'(lambda (child)
	    (%delegate child 'reset)))
  children)

(defun route-all-outputs-from-all-children (self children connections)
  (mapc #'(lamdba (child) (route-all-outputs-from-single-child self child children connections))
	children))

(defun route-all-outputs-from-single-child (self child children connections)
  (mapc #'(lambda (msg) 
	    (route-single-datum child (%call msg 'port) children connections))
	(%call child 'outputs-as-list)))

(defun route-single-datum (self from port datum children connections)
  ;; Container routes one datum to all receivers connected to the given {from,port} combination
  (mapc #'(lambda (connection)
	    (cond ((and (eq port (%call connection 'sender-port))
			(eq from (%call connection 'sender self children)))
		   (let ((kind (%call connection 'kind))
			 (receiver (%call connection 'receiver self children)))
		     (cond 
		      ((or (eq kind 'across)
			   (eq kind 'down))
		       (let ((receiver-port (%call connection 'receiver-port)))
			 (let ((msg (Input-Message/new receiver-port datum)))
			   (%call receiver 'enqueue-input msg))))
		      
		      ((or (eq kind 'up)
			   (eq kind 'through))
		       (let ((receiver-port (%call connection 'receiver-port)))
			 (let ((msg (Output-Message/new receiver-port datum)))
			   (%call receiver 'enqueue-output msg))))
		      
		      (t (error "internal error 1 in route-single-item")))))
		  (t nil))) ;; {from, port} doesn't match - pass
	connections))

(defun step-all-children (children)
  (mapc #'(lambda (child) (%call child 'step)) children))
