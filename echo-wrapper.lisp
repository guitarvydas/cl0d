(defun Echo-Wrapper/new (given-name)
  (let ((children (list (Echo/new given-name))))
    (let ((connections (list
			(Down/new (Sender/new $Me "stdin") (Sender/new (nth 0 children) "stdin"))
			(Up/new (Sender/new (nth 0 children) "stderr") (Receiver/new $Me "stderr"))
			(Up/new (Sender/new (nth 0 children) "stdout") (Receiver/new $Me "stdout")))))
      (let ((ew (Container/new "echo-wrapper" children connections)))
        ew))))