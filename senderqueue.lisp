(defclass Sender-Queue ()
  ((outputq :accessor outputq :initform (make-instance 'FIFO))))

(defmethod clear-outputs ((self Sender-Queue))
  (setf (outputq self) (make-instance 'FIFO)))

(defmethod enqueue-output ((self Sender-Queue) msg)
  (enqueue (outputq self) msg))

(defmethod dequeue-output ((self Sender-Queue))
  (dequeue (outputq self)))

(defmethod output-queue ((self Sender-Queue))
  (as-ordered-list (outputq self)))

(defmethod outputs ((self Sender-Queue))
  (outputs-FIFO-dictionary self))

(defmethod send ((self Sender-Queue) from port data cause)
  (let ((breadcrumbs
	 (if cause
	     (cons cause (trail cause))
	   (cons cause nil))))
    (let ((m (make-instance 'Output-Message :from from :port port
			    :data data :trail breadcrumbs)))
      (enqueue-output self m))))

(defmethod outputs-FIFO-dictionary ((self Sender-Queue))
  ;; return a dictionary of FIFOs, one FIFO per output port
  ;; key is the port, each key contains a FIFO of data values 
  (let ((result-dict (make-instance 'DICT)))
    (mapc #'(lambda (msg)
	      (let ((key (port msg))
		    (v   (data msg)))
	     (prepend-value result-dict key v)))
	  (as-ordered-list (outputq self)))
    (reverse-all-values-in-place-destructive result-dict)
    result-dict))

(defmethod outputs-LIFO-dictionary ((self Sender-Queue))
  ; return a dictionary of LIFOs, one LIFO per output port
  (let ((result-dict (make-instance 'DICT)))
    (mapc #'(lambda (msg)
	      (let ((key (port msg))
		    (v   (data msg)))
	     (prepend-value result-dict key v)))
	  (as-ordered-list (outputq self)))
    result-dict))
    
