# Container.lisp
This file implements the API for Components that are composed of other components.

Each component (*leaf* or *container*) implements the methods:
- handle ()
- enter ()
- exit ()
- reset ()
- step ()
- step-to-completion ()
- busy?

The `step` entry point causes the Container to invoke one step in each child, then internally route messages between children.

A Container is `busy?` while any of its children are active.  A container is not `busy?` - quiescent - when all of its children are quiescent (not `busy?`).

`Step` is required for allowing components to be composed of other components that might (or might not) send messages to each other.

`Step-to-completion` is a convenience entry point that is used only for top-level components.  This entry causes the component to continuously step all of its children until all of its children are quiescent.

`Handle(...)` accepts one input message and begins the reaction to it.  In the case of a Container, the input message is punted (*Down*) to one or more of its children.

`Enter` is called to start up the component and to have it instantiate any of its children.[^nts]

`Exit` is called to drag all children out of their current state and to make them quiescent again.[^nts]

`Reset` is called to drag all children out of their current state and to make them quiescent again.

`Busy?` returns `true` or `false` if the component is *active* or *quiescent*, resp.  In the case of a Container, `busy?` returns `true` if *any* child is active.  It returns `false` if all children are quiescent.

[^nts]: Note to self: are `enter` and `exit` actually needed?  Maybe `enter` is handled by `handle` and `exit` by `reset`?  Maybe these entry points are only needed for implementing HSMs?