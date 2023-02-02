(defclass Receiver-Queue ()
  ((inputq :accessor inputq :initform (make-instance 'FIFO))
   (debug-handling :accessor debug-handling :initform nil)))

(defmethod inject-message ((self Receiver-Queue) msg)
  (enqueue-input self msg))

(defmethod ready-p ((self Receiver-Queue))
  (not (emptyp (inputq self))))

(defmethod handle-if-ready ((self Receiver-Queue))
  (when (readyp self)
    (let ((m (dequeue-input self)))
      (when (debug-handling self)
        (format *error-output* "~a handling ~a" (name self) m))
      (handle self m)
      t)))

;; not exported
(defmethod enqueue-input ((self Receiver-Queue) msg)
  (enqueue (inputq self) msg))

(defmethod dequeue-input ((self Receiver-Queue))
  (dequeue (inputq self)))
