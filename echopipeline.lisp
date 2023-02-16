(defun Echo-Pipeline/new ()
  ;; using [] ASCII characters to group compound IDs because
  ;; LW editor displays the Unicode I want differently than emacs does
  (let ((children (list (Echo/new "[leaf 1 (Echo)]"))))
    (let ((connections (list
			(Down/new (Sender/new $Me "stdin") (Sender/new (nth 0 children) "stdin"))
			(Up/new (Sender/new (nth 0 children) "stderr") (Receiver/new $Me "stderr"))
			(Up/new (Sender/new (nth 0 children) "stdout") (Receiver/new $Me "stdout")))))
      (let ((echo-pipeline (Sequential/new "[Echo pipeline]" children connections)))
        echo-pipeline))))
