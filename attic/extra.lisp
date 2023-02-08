
(let ((fifo (FIFO/new)))
  (% fifo 'enqueue 1))

(defun INPUT-QUEUE/new ()
  (let ((inq (FIFO/new)))
    (MAP/new
     (enqueue-input (lambda (x) (% inq 'enqueue x)))
     (dequeue-input (lambda () (% inq 'dequeue)))
     (empty? (lambda () (% inq 'empty?))))))

(defun OUTPUT-QUEUE/new ()
  (let ((outq (FIFO/new)))
    (MAP/new
     (send (lambda (x) (% outq 'enqueue x)))
     (for-each (lambda (f) (mapc #'(lambda (x)
				     (funcall f x))
				 outq)))
     (empty? (lambda () (% outq 'empty?))))))

(defun SCHEDULABLE/new (name)
  (let ((inq (FIFO/new))
	(outq (FIFO/new))
	(name name))
    (MAP/new
     (^send  (lambda (x) (% outq 'enqueue x)))
     (^for-each-output (lambda (f) (mapc #'(lambda (x)
					      (funcall f x))
					  outq)))
     (^empty-output? (lambda () (% outq 'empty?)))
     (^enqueue-input (lambda (x) (% inq 'enqueue x)))
     (^dequeue-input (lambda () (% inq 'dequeue)))
     (^empty-input? (lambda () (% inq 'empty?))))
    
(defun EH/new (name)
  (let ((sched (SCHEDULABLE/new name)))
    (MAP/new
     (^send  (lambda (x) (% sched ^send x)))
     (^for-each-output (lambda (f) (% sched ^for-each-output f)))
     (^empty-output? (lambda () (% sched '^empty-output?)))
     (^enqueue-input (lambda (x) (% sched '^enqueue-input x)))
     (^dequeue-input (lambda () (% sched '^dequeue-input)))
     (^empty-input? (lambda () (% sched '^empty-input?))))
