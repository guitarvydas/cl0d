A connection describes a routing path between a single Sender and a single Receiver.

A Sender is a pair {Component, Port}.

A Receiver is a pair {Component, Port}.

The *kind* of ports that are involved - Input or Output - depends on the actual connection.

*All* connections belonging to a single Container must be processed "at the same time" - atomically.  This detail is handled automatically when the system is implemented in a synchronous Call/Return language in a standard operating system.  

Implementation detail: atomicity of delivery is only an issue in systems built for bare hardware that don't use standard, synchronous operating systems.  In such a case, all connections in a grouping (i.e. in a Container) must be examined and each Receiver's input queue must be locked before delivery of any message.  This is equivalent to a *commit* protocol.  This protocol ensures ordering of messages and prevents messages from being interleaved and appearing in a different order on different Receivers.  Example: if a component creates a message that is delivered to two different Receivers, that message must arrive in the same order at both Receivers.  Let's say that the new message is *A*.  If some other component is sending message *B* to the same Receivers[^any], then delivery of *B* is blocked until all of the *A*s have been delivered to all Receivers.  *All* Receivers see message *A* before message *B*, or, they *all* see message *B* before message *A*.  The actual order of the messages doesn't matter, as long as *all* Receivers see the same order.   This atomic protocol ensures that no Receiver can see *AB* while another Receiver sees *BA*.  Again, this protocol comes "for free" in a synchronous system which is the norm for most programming languages.

There are 4 different kinds of routings described by Connections:
1. *across*
2. *down*
3. *up*
4. *through*

The *across* routing is used to deliver messages from the output queue of a child to the input queue of another child.  This is the "most obvious" kind of routing - if you draw two components on a whiteboard and connect them by an arrow, the arrow represents an *across* routing.

The *down* routing is used by a Container to punt its input messages to one or more of it children.

The *up* routing is used by a Container to promote a message from a child to its own output.

The *through* routing is an edge-case, used to "stub out" components.  A Container's input message is routed directly to its own output.

## N.C. - No Connection.  

It is possible that input messages are not connected anywhere.  

For a Container, an NC input is like a *down* connection where the message is simply discarded instead of being punted to a child.

For a child component, N.C. input means only that messages never arrive on that tag.  The input port is not connected, so no message is ever sent into that port.

In the other direction, a Container NC output means that nothing is connected to the output pin of the Container component, hence, it never sends messages on that port.

A child NC output means that any messages that it sends to that port are discarded.  The output port is not connected to anything, hence, messages on that port are discarded (and garbage collected).

## /New
Connections are created by instantiating the appropriate connection with the `/new` function, e.g. `Down/new`, `Up/new`, `Across/new` and `Through/new`.



[^any]: Or any of the same Receivers.