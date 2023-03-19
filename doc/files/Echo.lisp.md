# Echo.lisp

The `echo.lisp` file implements a very simple *leaf* node.

The component is created by instantiating a *Leaf* object and supplying a simple function for handling input messages.

In this case, the *Echo* component handles messages by *send*ing them to its own output port, in this case called `stdout`.

The rest of the functionality in *Echo* is handled by delegating work to its *Leaf* instance.

It simply calls `%lookup()` to fetch the *send* λ from its *Leaf* instance and *applies* this function to a newly-formed output message.

*Send ()* accepts one parameter - a list containing two items
1. the port name (a string)
2. the data

*Send ()* creates an output message and enqueues it on the component's output queue.

Data is extracted from the input message.  The port name is hard-wired to be the string `"stdout"` in this example.

Note that this code was written in the early stages of development, before it was recognized that `%call` was an idiom.  The code in this component is a look at how `%call` is implemented (using `apply`).

The functions `seqtest0()` and `seqtest1()` are examples of vanilla, sequential use of the `Echo` component.