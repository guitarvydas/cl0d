(defclass Echo (Leaf)
  ())

(defmethod initialize-instance :around ((self Echo) &KEY &ALLOW-OTHER-KEYS)
  (call-next-method))

(defmethod __handler__ ((self Leaf) message)
  (send self self "stdout" (data message) message))
