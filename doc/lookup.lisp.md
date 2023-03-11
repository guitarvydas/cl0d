Functions and attributes are looked up by following upwards from a child to its ancestors.  This is  analogous to the way that JavaScript works.

`%lookup()` is the main lookup function

`%()` does a lookup in the object's *own* space without traversing upwards to ancestors.  This is analogous to JavaScript's *own* functionality.

`%call(object key ...args...)` `%call` is used to lookup and call a function associated with the object.  Note that *objects* are simply Lisp alists.  The `key` is the name of the function.  If the function takes arguments, they must be supplied in the `%call` function.  This is not checked.  The idea is to start as simply as possible, then layer various syntactic skins and checks onto the code process, when the code is intended for human consumption.