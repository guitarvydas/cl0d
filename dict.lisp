(defclass DICT ()
  ((dict :accessor dict :initform (make-hash-table :test 'equal))))

(defmethod prepend-value ((self DICT) key v)
  (multiple-value-bind 
   (value-list success) (gethash (dict self) key)
   (if success
       (setf (gethash (dict self) key) (cons v value-list))
     (setf (gethash (dict self) key) (cons v nil)))))

(defmethod reverse-all-values-in-place-destructive ((self DICT))
  (let ((hashtable ((dict self))))
    (maphash #'(lambda (k v)
		 (setf (gethash (dict self) k) (reverse v)))
	     hashtable)))
  
