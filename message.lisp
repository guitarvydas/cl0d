(defun Message/new (v)
  (let ((datum v))
    `((datum . ,(lambda () datum)))))

;; InputMessage and OutputMessage are messages that hold onto the port tag

;; InputMessage and OutputMessage have the same structure, but are semantically
;;  different - the port of an InputMessage refers to a port of the receiver, whereas
;;  the port of an OutputMessage refers to a port of the sender
;; The router (in Container.lisp) remaps ports as appropriate.

(defun Input-Message/new (port v)
  `((port . ,(lambda () port))
    (datum . ,(lambda () v))))

(defun Output-Message/new (port v)
  `((port . ,(lambda () port))
    (datum . ,(lambda () v))))


        
