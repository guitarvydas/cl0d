(defstruct Eh
  name
  input
  output
  children
  connections
  handler
  persistent-data)

(defun BASIC-EH/new ()
  (let ((eh (make-eh)))
    (setf (input eh) (FIFO/new)
	  (output eh) (FIFO/new)
	  (children eh) nil
	  (connections eh) nil)
    eh))
  
(defun Container/new (name)
  (let ((eh (BASIC-EH/new)))
    (setf (name eh) name)
    (setf (handler eh) #'Container-handler)
    (setf (persistent-data eh) nil)
    eh))

(defun Leaf/new (name handler persistent-data)
  (let ((eh (BASIC-EH/new)))
    (setf (name eh) name
	  (handler eh) handler
	  (persistent-data eh) persistent-data)
    eh))
