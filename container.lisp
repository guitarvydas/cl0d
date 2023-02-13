handle (msg)
enter
exit
reset
step
busy?

^ envelope

(defun Container/new (given-name children connections)
  (let ((name (format nil "%a/Container" given-name)))
    (let ((eh (Eh/new name)))
      (let ((busy nil))
	`((handle . ,(lambda (msg) 
		       (route-input-message msg children connections)))
	  (enter . ,(lambda ()))
	  (exit . ,(lambda ()))
	  (reset . ,(lambda () (reset-children children) (setf busy nil)))
	  (step . ,(lambda ()
		     (cond ((any-child-busy? children)
			    (step-all-children children))
			   ((not (%delegate eh 'empty-input?))
			   ...)
			   (t nil))))
	  (busy? . ,(lambda () (any-child-busy? children)))
	  (%else . ,eh))))))


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

(defun route-single-item (from port data children connections)
  ;; Container routes one datum to all receivers connected to the given {from,port} combination
  (mapc #'(lambda (connection)
	    (cond ((and (eq port (%call connection 'sender-port))
			(eq from (%call connection 'sender)))
		   (let ((kind (%call connection 'kind)))
		     (cond 
		      ((or (eq kind 'across)
			   (eq kind 'down))
		       (let ((receiver-port (%call connection 'receiver-port)))
			 (let ((msg (Input-Message/new receiver-port data)))
			   (%call receiver 'enqueue-input msg))))
		      
		      ((or (eq kind 'up)
			   (eq kind 'through))
		       (let ((receiver-port (%call connection 'receiver-port)))
			 (let ((msg (Output-Message/new receiver-port data)))
			   (%call receiver 'enqueue-output msg))))
		      
		      (t (error "internal error 1 in route-single-item")))))
		  (t nil))) ;; {from, port} doesn't match - pass
	connections))

(defun step-all-children (children)
  ...)

  
;;;

(defun map-child-id-to-component (from-index self children)
  (cond ((>= from-index 0) (nth from-index children))
	(t self)))

;; attic

(defun route-input-message (msg self children connections)
  (route-message msg -1 children connections))

(defun route-messages-from (from/id self children connections)
  (let ((from (map-child-id-to-component (from/id self children))))
    (mapc #'(lambda (msg) (route-single-message from/id from msg children connections))
	  (%delegate from 'outputs))))

