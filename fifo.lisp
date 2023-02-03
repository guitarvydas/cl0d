(defclass FIFO ()
  ((elements :accessor elements :initform nil)))

(defmethod initialize-instance :around ((self FIFO) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

(defmethod enqueue ((self FIFO) v)
  (push v (elements self)))

(defmethod dequeue ((self FIFO))
  (when (elements self)
    (car (last (elements self)))))

(defmethod len ((self FIFO))
  (length (elements self)))

(defmethod emptyp ((self FIFO))
  (not (null (elements self))))

(defmethod as-ordered-list ((self FIFO))
  (elements self))

(defmethod print-object ((self FIFO) strm)
  (format strm "~a" (elements self)))
