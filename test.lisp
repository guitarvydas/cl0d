(defun test ()
  (let ((m `( (a . ,(lambda () "hello")) (b . ,(lambda () "world")))))
    (apply (% m 'a) nil)))

(defun test2 ()
  (let ((m `( (a . ,(lambda () "hello")) (b . ,(lambda () "world")))))
    (apply (% m 'b) nil)))

(defun test3 ()
  (let ((q (FIFO/new)))
    (apply (% q 'enqueue) '(1))
    (apply (% q 'enqueue) '(2))
    (apply (% q 'enqueue) '(3))
    (apply (% q 'contents) nil)))

(defun test4 ()
  (let ((q (FIFO/new)))
    (apply (% q 'enqueue) '(1))
    (apply (% q 'enqueue) '(2))
    (apply (% q 'enqueue) '(3))
    (apply (% q 'dequeue) nil)
    (apply (% q 'dequeue) nil)
    (apply (% q 'dequeue) nil)
    ))

(defun test5 ()
  (let ((q (FIFO/new)))
    (apply (% q 'enqueue) '(1))
    (apply (% q 'enqueue) '(2))
    (apply (% q 'enqueue) '(3))
    (apply (% q 'dequeue) nil)
    (apply (% q 'dequeue) nil)
    (apply (% q 'dequeue) nil)
    (apply (% q 'empty?) nil)
    ))

(defun test6 ()
  (let ((echo (Echo/new "test")))
    (apply (%lookup echo 'handle) (list (Input-Message/new "stdin" "hello world")))
    (apply (%lookup echo 'outputs) nil)))

(defun test7 ()
  (let ((echo (Echo/new "test")))
    (apply (%lookup echo 'handle) (list (Input-Message/new "stdin" "hello world")))
    (apply (%lookup echo 'for-each-output)
           (list (lambda (msg)
                   (format *standard-output* "{~a: ~a}~%"
                           (apply (%lookup msg 'port) nil)
                           (apply (%lookup msg 'data) nil)
                           ))))
    (values)))

(defun display-message (msg)
  (format *standard-output* "{~a: ~a}~%"
          (apply (%lookup msg 'port) nil)
          (apply (%lookup msg 'datum) nil)))

(defun test8 ()
  (let ((echo (Echo/new "test")))
    (apply (%lookup echo 'handle) (list (Input-Message/new "stdin" 1)))
    (apply (%lookup echo 'handle) (list (Input-Message/new "stdin" 2)))
    (apply (%lookup echo 'handle) (list (Input-Message/new "stdin" 3)))
    (apply (%lookup echo 'handle) (list (Input-Message/new "stdin" "Hello")))
    (apply (%lookup echo 'handle) (list (Input-Message/new "stdin" "World")))
    (apply (%lookup echo 'for-each-output) (list #'display-message))
    (values)))

(defun test8call ()
  (let ((echo (Echo/new "test")))
    (%call echo 'handle (Input-Message/new "stdin" 1))
    (%call echo 'handle (Input-Message/new "stdin" 2))
    (%call echo 'handle (Input-Message/new "stdin" 3))
    (%call echo 'handle (Input-Message/new "stdin" "Hello"))
    (%call echo 'handle (Input-Message/new "stdin" "World"))
    (%call echo 'for-each-output #'display-message)
    (values)))

(defun seqtest0 ()
  (let ((children (list (Echo/new "child 1"))))
    (let ((connections (list
			(Down/new (Sender/new $Me "stdin") (Sender/new (nth 0 children) "stdin"))
			(Up/new (Sender/new (nth 0 children) "stderr") (Receiver/new $Me "stderr"))
			(Up/new (Sender/new (nth 0 children) "stdout") (Receiver/new $Me "stdout")))))
      (let ((seq (Sequential/new "sequential" children connections)))
        (%call seq 'handle (Input-Message/new "stdin" "Hello"))
        (apply (%lookup seq 'for-each-output) (list #'display-message))
        (values)))))

(defun seqtest1 ()
  (let ((children (list 
		   (Echo/new "child 1")
		   (Echo/new "child 2")
		   (Echo/new "child 3")
                   )))
        (let ((connections (list
			(Down/new (Sender/new $Me "stdin") (Sender/new (nth 0 children) "stdin"))
			(Across/new (Sender/new (nth 0 children) "stdout") (Receiver/new (nth 1 children) "stdin"))
			(Up/new (Sender/new (nth 0 children) "stderr") (Receiver/new $Me "stderr"))
			(Across/new (Sender/new (nth 1 children) "stdout") (Receiver/new (nth 2 children) "stdin"))
			(Up/new (Sender/new (nth 1 children) "stderr") (Receiver/new $Me "stderr"))
			(Up/new (Sender/new (nth 2 children) "stdout") (Receiver/new $Me "stdout"))
			(Up/new (Sender/new (nth 2 children) "stderr") (Receiver/new $Me "stderr")))))
          (let ((seq (Sequential/new "sequential" children connections)))
            (%call seq 'handle (Input-Message/new "stdin" "Hello"))
            (%call seq 'handle (Input-Message/new "stdin" "World"))
            (apply (%lookup seq 'for-each-output) (list #'display-message))
            ;; ??? (%call seq 'for-each-output #'display-message)
            (values)))))

(defun seqtest2 ()
  (let ((children (list
                   (Echo-Pipeline/new "container (child) 1")
                   (Echo-Pipeline/new "container (child) 2")
                   (Echo-Pipeline/new "container (child) 3")
                   )))
    (let ((connections (list
			(Down/new (Sender/new $Me "stdin") (Sender/new (nth 0 children) "stdin"))
			(Across/new (Sender/new (nth 0 children) "stdout") (Receiver/new (nth 1 children) "stdin"))
			(Across/new (Sender/new (nth 1 children) "stdout") (Receiver/new (nth 2 children) "stdin"))
			(Up/new (Sender/new (nth 2 children) "stdout") (Receiver/new $Me "stdout"))

			(Up/new (Sender/new (nth 0 children) "stderr") (Receiver/new $Me "stderr"))
			(Up/new (Sender/new (nth 1 children) "stderr") (Receiver/new $Me "stderr"))
			(Up/new (Sender/new (nth 2 children) "stderr") (Receiver/new $Me "stderr"))
                        )))
      (let ((seq (Sequential/new "sequential" children connections)))
        (%call seq 'handle (Input-Message/new "stdin" "seqccHello"))
        (apply (%lookup seq 'for-each-output) (list #'display-message))
        (values)))))

(defun wraptest0 ()
  (let ((children (list (Echo-Wrapper/new "child 1"))))
    (let ((connections (list
			(Down/new (Sender/new $Me "stdin") (Sender/new (nth 0 children) "stdin"))
			(Up/new (Sender/new (nth 0 children) "stderr") (Receiver/new $Me "stderr"))
			(Up/new (Sender/new (nth 0 children) "stdout") (Receiver/new $Me "stdout")))))
      (let ((ew (Container/new "sequential" children connections)))
        (%call ew 'handle (Input-Message/new "stdin" "Hello"))
        (apply (%lookup ew 'for-each-output) (list #'display-message))
        (values)))))

(defun partest2 ()
  (let ((children (list
                   (Echo-Pipeline/new "container (child) 1")
                   (Echo-Pipeline/new "container (child) 2")
                   (Echo-Pipeline/new "container (child) 3")
                   )))
    (let ((connections (list
			(Down/new (Sender/new $Me "stdin") (Sender/new (nth 0 children) "stdin"))
			(Down/new (Sender/new $Me "stdin") (Sender/new (nth 1 children) "stdin"))
			(Down/new (Sender/new $Me "stdin") (Sender/new (nth 2 children) "stdin"))

			(Up/new (Sender/new (nth 0 children) "stdout") (Receiver/new $Me "stdout"))
			(Up/new (Sender/new (nth 1 children) "stdout") (Receiver/new $Me "stdout"))
			(Up/new (Sender/new (nth 2 children) "stdout") (Receiver/new $Me "stdout"))

			(Up/new (Sender/new (nth 0 children) "stderr") (Receiver/new $Me "stderr"))
			(Up/new (Sender/new (nth 1 children) "stderr") (Receiver/new $Me "stderr"))
			(Up/new (Sender/new (nth 2 children) "stderr") (Receiver/new $Me "stderr"))
                        )))
      (let ((seq (Parallel/new "parallel" children connections)))
        (%call seq 'handle (Input-Message/new "stdin" "parccHello"))
        (%call seq 'handle (Input-Message/new "stdin" "parccWorld"))
        (apply (%lookup seq 'for-each-output) (list #'display-message))
        (values)))))

