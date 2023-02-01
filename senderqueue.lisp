(defclass Sender-Queue ()
  ((outputq :accessor ouputq :initform (make-instance 'FIFO))))

(defmethod clear-outputs ((self Sender-Queue))
  (setf (outputq self) (make-instance 'FIFO)))

(defmethod enqueue-output ((self Sender-Queue) msg)
  (enqueue (outputq self) msg))

(defmethod dequeue-output ((self Sender-Queue))
  (dequeue (outputq self)))

(defmethod output-queue ((self Sender-Queue))
  (as-list (outputq self)))

(defmethod outputs ((self Sender-Queue))
  (outputsFIFODictionary self))

(defmethod send ((self Sender-Queue) from port data cause)
  (let ((breadcrumbs
	 (if cause
	     (cons cause (trail cause))
	   (cons cause nil))))
    (let ((m (make-instance 'Output-Message :from from :port port
			    :data data :trail breadcrumbs)))
      (enqueue-output self m))))
      





    def outputsFIFODictionary (self):
        # return a dictionary of FIFOs, one FIFO per output port
        resultdict = {}
        for message in self._outputq.asList ():
            if (not (message.port in resultdict)):
                resultdict [message.port] = FIFO ()
            resultdict [message.port].enqueue (message.data)
        resultdict2 = {}
        for key in resultdict:
            fifo = resultdict [key]
            r = fifo.asList ()
            resultdict2 [key] = r
        return resultdict2

    def outputsLIFODictionary (self):
        # return a dictionary of LIFOs, one LIFO per output port
        resultdict = {}
        for message in self._outputq.asList ():
            if (not (message.port in resultdict)):
                resultdict [message.port] = FIFO ()
            resultdict [message.port].enqueue (message.data)
        resultdict2 = {}
        for key in resultdict:
            fifo = resultdict [key]
            r = fifo.asList ()
            r.reverse () ## newest result first
            resultdict2 [key] = r
        return resultdict2

    # internal - not exported
    def send (self, xfrom, portname, data, cause):
        if cause:
            breadcrumbs = [cause, cause.trail]
        else:
            breadcrumbs = [cause]
        m = OutputMessage (xfrom, portname, data, trail=breadcrumbs)
        self.enqueueOutput (m)
