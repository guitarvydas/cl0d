(defun Echo-Pipeline/new (given-name)
  ;; using [] ASCII characters to group compound IDs because
  ;; LW editor displays the Unicode I want differently than emacs does
  (let ((name (format nil "~a/[Echo pipeline]" given-name)))
    (let ((children (list
                     (Echo/new "[leaf 1 (Echo)]")
                     (Echo/new "[leaf 2 (Echo)]")
                     (Echo/new "[leaf 3 (Echo)]")
                     )))
      (let ((connections (list
                          (Down/new (Sender/new $Me "stdin") (Sender/new (nth 0 children) "stdin"))
                          (Across/new (Sender/new (nth 0 children) "stdout") (Receiver/new (nth 1 children) "stdin"))
                          (Up/new (Sender/new (nth 1 children) "stdout") (Receiver/new $Me "stdout"))

                          (Up/new (Sender/new (nth 0 children) "stderr") (Receiver/new $Me "stderr"))
                          (Up/new (Sender/new (nth 1 children) "stderr") (Receiver/new $Me "stderr"))
                          (Up/new (Sender/new (nth 2 children) "stderr") (Receiver/new $Me "stderr"))
                          )))
        (let ((echo-pipeline (Sequential/new name children connections)))
          echo-pipeline)))))

#+nil(defun Echo-Pipeline/new (given-name)
  ;; using [] ASCII characters to group compound IDs because
  ;; LW editor displays the Unicode I want differently than emacs does
  (let ((name (format nil "~a/[Echo pipeline]" given-name)))
    (let ((children (list
                     (Echo/new "[leaf 1 (Echo)]"))))
      (let ((connections (list
                          (Down/new (Sender/new $Me "stdin") (Sender/new (nth 0 children) "stdin"))
                          (Up/new (Sender/new (nth 0 children) "stderr") (Receiver/new $Me "stderr"))
                          (Up/new (Sender/new (nth 0 children) "stdout") (Receiver/new $Me "stdout"))
                          )))
        (let ((echo-pipeline (Sequential/new name children connections)))
          echo-pipeline)))))

#+nil(defun Echo-Pipeline/new (given-name)
  ;; using [] ASCII characters to group compound IDs because
  ;; LW editor displays the Unicode I want differently than emacs does
  (let ((name (format nil "~a/[Echo pipeline]" given-name)))
    (let ((children (list
                     (Echo/new "[leaf 1 (Echo)]")
                     (Echo/new "[leaf 2 (Echo)]")
                     (Echo/new "[leaf 3 (Echo)]"))))
      (let ((connections (list
                          (Down/new (Sender/new $Me "stdin") (Sender/new (nth 0 children) "stdin"))
                          (Up/new (Sender/new (nth 0 children) "stderr") (Receiver/new $Me "stderr"))
                          (Up/new (Sender/new (nth 0 children) "stdout") (Receiver/new (nth 1 children) "stdin"))
                          (Up/new (Sender/new (nth 1 children) "stderr") (Receiver/new $Me "stderr"))
                          (Up/new (Sender/new (nth 1 children) "stdout") (Receiver/new (nth 2 children) "stdin"))
                          (Up/new (Sender/new (nth 2 children) "stderr") (Receiver/new $Me "stderr"))
                          (Up/new (Sender/new (nth 2 children) "stdout") (Receiver/new $Me "stdout"))
                          )))
        (let ((echo-pipeline (Sequential/new name children connections)))
          echo-pipeline)))))
