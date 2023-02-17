(defun Echo-Concurrent/new (given-name)
  ;; using [] ASCII characters to group compound IDs because
  ;; LW editor displays the Unicode I want differently than emacs does
  (let ((name (format nil "~a/[Echo pipeline]" given-name)))
    (let ((children (list
                     (Echo/new "[pleaf 1]")
                     (Echo/new "[pleaf 2]")
                     (Echo/new "[pleaf 3]")
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
        (let ((echo-pipeline (Sequential/new name children connections)))
          echo-pipeline)))))
