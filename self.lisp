(setf *print-circle* t)

(defun unsafe ()
  '#1=(1 #1# 3))

(defun circ ()
  (let ((x '(a b c)))
    (setf (car x) x)))
