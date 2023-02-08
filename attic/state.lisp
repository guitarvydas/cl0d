;; State interface

(defmethod enter ((self State))
)
enter
exit
handle (Message)
step
❲is active❳ >> ❲yes/no❳

;; State initializer
(defclass State
  ((|enter| :accessor |enter| :initarg :enter)
   (|handlers| :accessor |handlers| :initarg :handlers)
   (|inner-machine| :accessor |inner-machine| :initarg :inner-machine)
   (|exit| :accessor |exit| :initarg :exit)
   (|owner| :accessor |owner| :initarg :owner)
   (|name| :accessor |name| :initarg :name)))

(defun new[State] (&key enter handlers inner-machine exit owner name)
  (make-instance 'State 
		 :enter enter :handlers handlers
		 :inner-machine inner-machine :exit exit
		 :owner owner :name name))

;; Definitions
(define-symbol-macro Port id)
(define-symbol-macro Owner |Machine|)
Owner ≡ Machine
id ≡ <external>
❲yes/no❳ ≡ <external>
Machine ≡ <elsewhere>
Message ≡ <elsewhere>

Port ≡ id
Owner ≡ Machine
id ≡ <...>
❲yes/no❳ ≡ <...>
Machine ≡ <>
Message ≡ <>

;; imported, inherited
owner.next (id)

owner.terminate >> ❲yes/no❳



❲❳
≡
