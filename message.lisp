(defun Message/new (v)
  (let ((data v))
    `((data . ,(lambda () data)))))

;; InputMessage and OutputMessage are messages that hold onto the port tag

;; InputMessage and OutputMessage have the same structure, but are semantically
;;  different - the port of an InputMessage refers to a port of the receiver, whereas
;;  the port of an OutputMessage refers to a port of the sender
;; The router (in Container) remaps ports as appropriate.

(defun Input-Message/new (port v)
  (let ((port port)
	(data v))
    `((port . ,(lambda () port))
      (data . ,(lambda () data)))))

(defun Output-Message/new (port v)
  (let ((port port)
	(data v))
    `((port . ,(lambda () port))
      (data . ,(lambda () data)))))


        
