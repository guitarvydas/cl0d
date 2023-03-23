
(defun test-all ()
  (let ((hw (Echo/new "hw")))
    (format *standard-output* "*** ~a~%" (%call hw 'name))
    (%call hw 'handle (Input-Message/new "stdin" "Hello"))
    (format *standard-output* "~a~%" (%call hw 'map-outputs 'format-message))
    (values)))
