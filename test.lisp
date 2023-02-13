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
          (apply (%lookup msg 'data) nil)))

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

(defun seqtest ()
  (let ((children (list 
		   (Echo/new "child 1")
		   (Echo/new "child 2"))))
    (let ((connections (list
			(Down/new 0 "in" 1 "in")
			(Across/new 1 "out" 2 "in")
			(Up/new 1 "err" 0 "err")
			(Up/new 2 "out" 0 "out")
			(Up/new 2 "err" 0 "err"))))
      (let ((seq (Sequential/new "sequential" children connections)))
        (%call seq 'handle (Input-Message/new "stdin" "Hello"))
        ;;(%call seq 'handle (Input-Message/new "stdin" "World"))
        (%call seq 'for-each-output #'display-message)
        (values)))))

;; (defun parallel ()
;;   (let ((children (list 
;; 		   (Echo/new "child 1")
;; 		   (Echo/new "child 2"))))
;;     (let ((connections (list
;; 			(Down/new 0 "in" 1 "in")
;; 			(Across/new 1 "out" 2 "in")
;; 			(Up/new 1 "err" 0 "err")
;; 			(Up/new 2 "out" 0 "out")
;; 			(Up/new 2 "err" 0 "err"))))
;;       (ParallelTest/new "sequential" children connections))))
