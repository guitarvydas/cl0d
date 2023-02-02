(defclass Echo (Leaf)
  ())

(defmethod __handler__ ((self Leaf) message)
  (send self :from self :port-name "stdout" :data (data message) :cause message))
