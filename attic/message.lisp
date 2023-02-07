(defclass Base-Message (Debuggable)
  ((data :accessor data :initarg :data)))

(defclass Message (Base-Message)
  ((direction :accessor direction :initarg :direction)
   (from :accessor from :initarg :from)
   (port :accessor port :initarg :port)
   (trail :accessor trail :initarg :trail)))


(defmethod initialize-instance :around ((self Base-Message) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

(defmethod initialize-instance :around ((self Message) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

(defmethod print-object ((self Base-Message) strm)
  (format strm "~a" (data self)))

(defmethod print-object ((self Message) strm)
  (if (excruciating-detail self)
      (format strm "{~a: ~a, ~a, ~a->~a}" 
	      (direction self) (port self) (data self) (trail self))
    (format strm "{~a}" (port self))))
