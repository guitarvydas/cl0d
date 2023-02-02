(defclass Echo (Leaf)
  ())

(defmethod __handler__ ((self Leaf) message)
  (send self self "stdout" (data message) message))
