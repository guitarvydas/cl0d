
(defun test-all ()

  (let ((hw (Echo/new "hw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))
  
  (let ((hw (WrappedEcho/new "whw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))

  (format *standard-output* "~%---~%")
  (let ((hw (WrappedEcho2/new "wwhw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))
  
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
  
      
