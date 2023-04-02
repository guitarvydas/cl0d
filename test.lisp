
(defun test-all ()

  (format *standard-output* "~%---~%")
  (let ((hw (Echo/new "hw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))
  
  (format *standard-output* "~%---~%")
  (let ((hw (WrappedEcho/new "whw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))

  (format *standard-output* "~%---~%")
  (let ((hw (WrappedWrappedEcho/new "wwhw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))
  
  (format *standard-output* "~%---~%")
  (let ((hw (WrappedEcho2/new "whw2")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))
  
  (format *standard-output* "~%---~%")
  (let ((hw (ParEcho/new "phw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))

  (format *standard-output* "~%---~%")
  (let ((hw (ParWrappedEcho/new "pwhw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))

  (format *standard-output* "~%---~%")
  (let ((hw (ParWrappedEcho/new "pwhw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (%call hw 'handle (Input-Message/new "stdin" "World"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))

  (format *standard-output* "~%---~%")
  (let ((fback (Feedback-test/new "feedback")))
    (format *standard-output* "*** ~a~%" (%call fback 'name))
    (%call fback 'handle (Input-Message/new "stdin" t))
    (format *standard-output* "~a~%" (%call fback 'map-outputs 'format-message)))

  (values))


;;;

(defun WrappedEcho/new (given-name)
  (let ((children (list (Echo/new "0"))))
    (let ((eh (Container/new-begin (format nil "[WrappedEcho ~a]" given-name))))
      (let ((outq (%call eh 'output-queue)))
	(Container/new-finalize eh
				children
				(list (Down/new (Sender/new nil "stdin") (Receiver/new (%call (nth 0 children) 'input-queue) "stdin"))
                                      (Up/new   (Sender/new (nth 0 children) "stdout") (Receiver/new outq "stdout"))))))))

(defun WrappedWrappedEcho/new (given-name)
  (let ((children (list (WrappedEcho/new "10"))))
    (let ((eh (Container/new-begin (format nil "[WrappedWrappedEcho ~a]" given-name))))
      (let ((outq (%call eh 'output-queue)))
	(Container/new-finalize eh
				children
				(list (Down/new (Sender/new nil "stdin") (Receiver/new (%call (nth 0 children) 'input-queue) "stdin"))
                                      (Up/new   (Sender/new (nth 0 children) "stdout") (Receiver/new outq "stdout"))))))))

(defun WrappedEcho2/new (given-name)
  (let ((children (list (Echo/new "0") (Echo/new "1"))))
    (let ((eh (Container/new-begin (format nil "[WrappedEcho2 ~a]" given-name))))
      (let ((outq (%call eh 'output-queue)))
	(Container/new-finalize
         eh
         children
         (list (Down/new (Sender/new nil "stdin") (Receiver/new (%call (nth 0 children) 'input-queue) "stdin"))
               (Across/new   (Sender/new (nth 0 children) "stdout") (Receiver/new (%call (nth 1 children) 'input-queue) "stdin"))
               (Up/new   (Sender/new (nth 1 children) "stdout") (Receiver/new outq "stdout")) ))))))
  
(defun ParEcho/new (given-name)
  (let ((children (list (Echo/new "p0") (Echo/new "p1"))))
    (let ((eh (Container/new-begin (format nil "[ParEcho ~a]" given-name))))
      (let ((outq (%call eh 'output-queue)))
	(Container/new-finalize
         eh
         children
         (list (Down/new (Sender/new nil "stdin") (Receiver/new (%call (nth 0 children) 'input-queue) "stdin"))
               (Down/new (Sender/new nil "stdin") (Receiver/new (%call (nth 1 children) 'input-queue) "stdin"))
               (Up/new   (Sender/new (nth 0 children) "stdout") (Receiver/new outq "stdout"))
               (Up/new   (Sender/new (nth 1 children) "stdout") (Receiver/new outq "stdout"))
               ))))))
  
(defun ParWrappedEcho/new (given-name)
  (let ((children (list (WrappedEcho/new "pw0") (WrappedEcho/new "pw1"))))
    (let ((eh (Container/new-begin (format nil "[ParWrappedEcho ~a]" given-name))))
      (let ((outq (%call eh 'output-queue)))
	(Container/new-finalize
         eh
         children
         (list (Down/new (Sender/new nil "stdin") (Receiver/new (%call (nth 0 children) 'input-queue) "stdin"))
               (Down/new (Sender/new nil "stdin") (Receiver/new (%call (nth 1 children) 'input-queue) "stdin"))
               (Up/new   (Sender/new (nth 0 children) "stdout") (Receiver/new outq "stdout"))
               (Up/new   (Sender/new (nth 1 children) "stdout") (Receiver/new outq "stdout"))
               ))))))

;;;

(defun A/new (given-name)
  (let ((name (format nil "[Echo ~a]" given-name)))
    (let ((leaf (Leaf/new name nil)))
      `((%debug . A)
        (handle . ,(lambda (msg)
                     (declare (ignore msg))
                     (%call leaf 'send (list "stdout" "v"))
                     (%call leaf 'send (list "stdout" "w"))))
        (%else . ,leaf)))))

(defun B/new (given-name)
  (let ((name (format nil "[Echo ~a]" given-name)))
    (let ((leaf (Leaf/new name nil)))
      `((%debug . A)
        (handle . ,(lambda (msg)
                     (cond 
                      ((equal "stdin" (%call msg 'port))
                       (%call leaf 'send (list "stdout" (%call msg 'datum)))
                       (%call leaf 'send (list "feedback" "z")))
                      ((equal "fback" (%call msg 'port))
                       (%call leaf 'send (list "stdout" (%call msg 'datum))))
                      (t nil))))
        (%else . ,leaf)))))


(defun Feedback-test/new (given-name)
  (let ((children (list (A/new "A") (B/new "B"))))
    (let ((eh (Container/new-begin (format nil "[Feedback-test ~a]" given-name))))
      (let ((outq (%call eh 'output-queue)))
	(Container/new-finalize
         eh
         children
         (list (Down/new (Sender/new nil "stdin") (Receiver/new (%call (nth 0 children) 'input-queue) "stdin"))
               (Across/new   (Sender/new (nth 0 children) "stdout") (Receiver/new (%call (nth 1 children) 'input-queue) "stdin")
               (Across/new   (Sender/new (nth 1 children) "feedback") (Receiver/new (%call (nth 1 children) 'input-queue) "fback")
               (Up/new   (Sender/new (nth 1 children) "stdout") (Receiver/new outq "stdout"))
               ))))))))
