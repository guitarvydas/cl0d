(defclass DICT ()
  ((dict :accessor dict :initform (make-hash-table :test 'equal))))

(defmethod initialize-instance :around ((self Dict) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

(defmethod prepend-value ((self DICT) key v)
  (multiple-value-bind 
   (value-list success) (gethash key (dict self))
   (if success
       (setf (gethash key (dict self)) (cons v value-list))
     (setf (gethash key (dict self)) (cons v nil)))))

(defmethod reverse-all-values-in-place-destructive ((self DICT))
  (let ((hashtable (dict self)))
    (maphash #'(lambda (k v)
		 (setf (gethash k (dict self)) (reverse v)))
	     hashtable)))
  
