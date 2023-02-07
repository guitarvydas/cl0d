(defclass DICT ()
  ((hashtable :accessor hashtable :initform (make-hash-table :test 'equal))))

(defmethod initialize-instance :around ((self Dict) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

(defmethod prepend-value ((self DICT) key v)
  (multiple-value-bind 
   (value-list success) (gethash key (hashtable self))
   (if success
       (setf (gethash key (hashtable self)) (cons v value-list))
     (setf (gethash key (hashtable self)) (cons v nil)))))

(defmethod reverse-all-values-in-place-destructive ((self DICT))
  (let ((ht (hashtable self)))
    (maphash #'(lambda (k v)
		 (setf (gethash k (hashtable self)) (reverse v)))
	     ht)))

(defmethod print-object ((self DICT) strm)
  (format strm "dict<")
  (maphash #'(lambda (k v)
               (format strm "~a: ~a" k v))
           (hashtable self))
  (format strm ">"))
