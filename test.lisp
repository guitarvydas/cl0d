
(defun test-all ()

  (let ((hw (Echo/new "hw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))
  
  (let ((hw (WrappedEcho/new "whw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message)))
  
  (values))


;;;

(defun WrappedEcho/new (given-name)
  (let ((children (list (Echo/new "0"))))
    (let ((self
           (cons '((tag . WrappedEcho))
                 (Container/new (format nil "[WrappedEcho ~a]" given-name)
                                children
                                (list
                                 (Down/new (Sender/new '$Me "stdin") (Receiver/new (nth 0 children) "stdin"))
                                 (Up/new   (Sender/new (nth 0 children) "stdout") (Sender/new '$Me "stdout"))
                                 )))))
      (fixup self))))

