# Basics

This example presents the simplest usage of components that demonstrates the use of Containers and Leaves.

We create one Container component which contains one Leaf component.

The Container creates one `Echo` component as a child and wires it up to its own inputs and outputs.  We use `"stdin"` for the name of the input port and `"stdout"` and `"stderr"` for the names of the output ports.  We could have used any other names, but, it is assumed that these names are familiar to anyone who has used UNIX® before[^unixrestrictive].

A Container is like a *function*, but, it is completely independent[^crs] and has input and output ports.
![[Walkthrough - Seqtest0 <-- Start Here 2023-03-11 17.38.54.excalidraw]]

A Component can be a Container or a Leaf.  Every component has one input queue and one output queue.  Exactly one of each.  Not one queue for each port, but, one input queue and one output queue for each component.

Components communicate via Messages.  

Messages are little lumps of data that are tagged with port names.  At its most basic, a Message is a pair.  It contains a *tag*, which is a string, and a *datum* which is any valid data.  In Lisp, a Message is a string plus any single valid Lisp data (an Atom, a List, etc.).

![[Walkthrough - Seqtest0 <-- Start Here 2023-03-11 17.36.34.excalidraw]]

A *Leaf* contains code and is most like what we call "programs".

![[Walkthrough - Seqtest0 <-- Start Here 2023-03-11 17.55.05.excalidraw]]

A *Container* is composed of other components (Leaves or Containers)

![[Walkthrough - Seqtest0 <-- Start Here 2023-03-11 17.56.28.excalidraw]]

A *Container* routes messages between its children.  The routing information is owned by the *Container*, not its children.

![[Walkthrough - Seqtest0 <-- Start Here 2023-03-11 18.00.24.excalidraw]]

In Lisp, the children are contained in a *list* of *components*

In Lisp, the connections are contained in a *list* of *connection* objects.  There are four kinds of *connections* - down, across, up, through.
![[Walkthrough - Seqtest0 <-- Start Here 2023-03-11 18.08.00.excalidraw]]

A *Container* is like a nano operating-system.  

Operating systems wrap State Machines around code.  *Containers* wrap State Machines around code, but, at a finer grain.

Operating systems use a sledgehammer - called *preemption* - to yank control away from code that they want to control.  *Containers* don't use *preemption*.  *Containers* rely on the *scouts' honour system* to regain control of the system[^mutual].

Ports in messages always relate to the component they belong to.  When a Message is sent to the input of a *component*, the port in the message must refer to a port of that component, not a port of the sending component.  When a Message is sent to the output of a *component*, the port in the message must refer to a port of the sending *component*.  It cannot refer to a port of another component.  For example, if a *component* sends a message to its *stdout* port, intended for another component's *stdin* port, the output message must refer only to the *stdout* port of the sender.  It must not - cannot - refer to the other component or to the other component's port.  The *container* of the *component* will do any necessary routing and mapping of output port names to input port names.

[^crs]: See Call/Return Spaghetti, ALGOL Bottleneck, 0D, etc. for essays on how to break dependencies in programs.

[^mutual]: This is just *mutual multitasking*.  *Mutual multitasking* is unsuitable for building multi-adversarial-app operating systems, but, is quite suitable for building programs.  Programs sometimes have bugs due to *infinite recursion* in their code.  Containers that contain components that run too long or recur infinitely are said to contain *bugs*.  Developers know what to do with *bugs* (spoiler: get rid of them by fixing the code).

[^unixrestrictive]: In fact, UNIX® is too restrictive.  Components can have many inputs and many outputs.  Components can have zero inputs or zero outputs.  UNIX® allows this kind of thing but does not encourage it.  UNIX makes it easier to refer to a single input and exactly two outputs - *stdin*, *stdout*, and, *stderr*, resp.  This matches the *function* pattern - one input and one output with exceptions - but, does not match well with other valid architectures, for example JS FileRead with one input (*start*) and five valid outputs (*file contents*, *user aborted the operation*, *no such file*, *timeout* and *internal error*), each of which need to be handled differently.  Currently, using textual notation, we only encourage the use of two outputs - *file contents* and *everything else*.  We over-load the meaning of *conditions* with multiple concepts (*error*, *abort*, *no such file*, *timeout*, etc.) resulting in condition handling code that is overly complex and difficult to understand.