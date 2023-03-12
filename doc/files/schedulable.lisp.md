# schedulable.lisp
This file implements message queues.

In general, Components are composed by composing bits of prototypes.

Any Component that is stand-alone and completely decoupled from all other messages is *schedulable*, i.e. order doesn't matter.  The Component can run at any time.  It grabs inputs from its own input queue and it produces outputs by dropping them on its own output queue.  

A Component *cannot* refer to its siblings nor its parent.  It simply drops output messages onto its own output queue, letting its parent handle the task of routing the messages to their final destination(s).

A Component *can* refer to its own children.  It can drop input messages onto its children's input queues, and, it can route messages between children, and, it can route outputs from children to its own output queue.

Not all bits of code need to be *schedulable*.  A component might include bits of code that are not  separately schedulable ("synchronous").  The component gives a reference to its own `Send()` function to such synchronous bits of code.

On the other hand, it is easier to architect and re-architect systems using *schedulable* components.  A Parent component (a "wrapper") simply instantiates sub-components and bolts them together in a LEGO-like fashion using its own routing table.

This kind of architecture, using schedulable sub-components, makes for easy re-use.  It also makes for easy replacement and upgrading.  Components are simply snapped together inside a Container.  The actual components do not need to care (in fact, cannot care) who they are connected to - they simply react to input messages and stuff results onto their own output queues without reference to any other component.

A schedulable Component implements the following functionality:
- input
	- enqueue
	- dequeue
	- empty? (test if there are any inputs)
- output
	- enqueue
	- dequeue
	- clear
	- as-list 
	- for-each.