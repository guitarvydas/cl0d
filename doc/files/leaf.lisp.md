# leaf.lisp
```
  ...
  (let ((eh (Eh/new name)))
      `((handle . ,(lambda (msg) (funcall f msg)))
	(enter . ,(lambda ()))
	(exit . ,(lambda ()))
	(reset . ,(lambda ()))
	(step . ,(lambda () nil))
	(step-to-completion . ,(lambda () nil))
	(busy? . ,(lambda () nil))
	(%else . ,eh)
	...
```
A *leaf* component does the real work.  This is what we call *code* today.  The main difference between a *leaf* and a normal *function* in just about any programming language, is that the *leaf* can refer to a *Send()* function to put outputs on its own output queue.  It instantiates an ė prototype and punts all `send()` calls to that instance.

A *leaf* component is like a little state machine, that reacts to one input message at a time and produces outputs (if any) by enqueuing outputs on its output queue.

The file `leaf.lisp` implements a general version of a *leaf*.  This general version is used to construct other more interesting components.

Each component (*leaf* or *container*) implements the methods:
- handle ()
- enter ()
- exit ()
- reset ()
- step ()
- step-to-completion ()
- busy?

*Handle* accepts a single input message and contains the code (e.g. a λ) that is a reaction to the input message.  The code can produce zero outputs, but, if it creates 1 or more outputs, the outputs are placed on the output queue using a `send()` function call.

All components implement the same API (above), but, in the case of a *leaf* many of the operations are no-ops.

A *leaf* completes its work in one fell swoop, so it is never *busy*.

*Step* is required to allow components to implement behaviours using other sub-components and to allow routing messages between their children.  A *leaf* completes its work in one fell swoop, so it never needs to step its internals, hence, its *step* method is a no-op.

Likewise, *enter*, *exit*, and *reset* don't need to do anything, in the case of a *leaf*.

See `echo.lisp` for an example of a concrete *leaf* implementation.

The API entry point `step-to-completion ()` is a convenience for top-level components.  The intent is to continue stepping all children until quiescence.  A *leaf* has no children, hence, this entry point is a no-op.