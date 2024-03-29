(defun Container/new-begin (given-name)
  (let ((name (format nil "[Container ~a]" given-name)))
    (Eh/new name)))

(defun Container/new-finalize (eh children connections)
  `((%debug . Container)
    (handle . ,(lambda (msg)
		 (route-downwards (%call msg 'port) (%call msg 'datum) connections)
		 (loop while (any-child-ready? children)
		       do (dispatch-all-children children connections))))
    (%else . ,eh)))

(defun dispatch-all-children (children connections)
  (mapc #'(lambda (child)
	    (cond ((has-inputs? child)
                   (let ((msg (%call child 'dequeue-input)))
                     (%call child 'handle msg))
                   (route-and-clear-outputs-from-single-child child connections))
		  (t nil)))
	children))


(defun route-and-clear-outputs-from-single-child (child connections)
  (mapc #'(lambda (output)
	    (route-child-output child (%call output 'port) (%call output 'datum) connections))
	(%call child 'outputs))
  (%call child 'clear-outputs))
  
(defun route-child-output (child port datum connections)
  (route child port datum connections))

(defun route-downwards (port datum connections)
  (route nil port datum connections))

(defun route (from port datum connections)
  (let ((from-sender (Sender/new from port)))
    (mapc #'(lambda (connection)
	      (cond ((%call connection 'sender-matches? from-sender)
		     (%call connection 'deposit datum))
		    (t nil)))
	  connections)))

(defun any-child-ready? (children)
  (mapc #'(lambda (child)
	    (cond ((ready? child)
		   (return-from any-child-ready? $True))
		  (t nil)))
	children)
  $False)

(defun ready? (child)
  (let ((input-empty? (%call child 'empty-input?))
	(output-empty? (%call child 'empty-output?)))
    (or (not input-empty?) (not output-empty?))))

(defun has-inputs? (child)
  (let ((input-empty? (%call child 'empty-input?)))
    (not input-empty?)))

