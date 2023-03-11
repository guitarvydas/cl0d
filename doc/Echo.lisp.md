# Echo.lisp

The `echo.lisp` file implements a very simple *leaf* node.

The component is created by instantiating a *Leaf* object and supplying a simple function for handling input messages.

In this case, the *Echo* component handles messages by *send*ing them to its own output port, in this case called `stdout`.

The rest of the functionality in *Echo* is handled by delegating work to its *Leaf* instance.

It simply calls `%lookup()` to fetch the *send* λ from its *Leaf* instance and *applies* this function to a newlyp-formed message.