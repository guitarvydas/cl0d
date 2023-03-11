(defun Input-Message/new (port v)
  `((port . ,(lambda () port))
    (datum . ,(lambda () v))))

(defun Output-Message/new (port v)
  `((port . ,(lambda () port))
    (datum . ,(lambda () v))))

This file creates two kinds of messages - input and output.

They both look the same, but their `port` values are different.  `Port`s are relative to the object doing the Sending or doing the Receiving.

The router (Container) needs to map from *output* messages to *input* messages to maintain relativity.

*Input* messages can only be found on input queues of Components.  The `port`s in *input* messages are relative to the Receiving Component.  For example, if a Component sends a message from its *stdout* port, the Receiver will see the message with a tag of *stdin*.  

The data carried by a message is any kind of lump of data.  In this case, we are using Common Lisp, so the data in a message is any valid Lisp data (an Atom, a List, etc.)

*Output* messages can only be found on output queues of Components.

An *input* message is created by calling the function `Input-Message/New()`.

An *output* message is created by calling the function `Output-Message/New()`.
