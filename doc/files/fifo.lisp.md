# fifo.lisp
This file implements a simple Queue (FIFO - first in, first out[^lifo])

[^lifo] A queue, is different from a Stack.  A queue is FIFO, a stack is LIFO.  First in first out, and, last  in last out, respectively.

The FIFO prototype ("class") implements the following methods:

- enqueue
- dequeue
- push
- clear
- empty?
- contents

A new FIFO is created by calling "FIFO/new()".