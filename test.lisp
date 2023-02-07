(defun test ()
  (let ((m (MAP/new `( (a . ,(lambda () "hello")) (b . ,(lambda () "world"))))))
    (% m 'a)))

(defun test2 ()
  (let ((m (MAP/new `( (a . ,(lambda () "hello")) (b . ,(lambda () "world"))))))
    (% m 'b)))
