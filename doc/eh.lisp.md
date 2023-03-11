*Eh*[^eh] implements a *schedulable* component, wrapping a name around it.

In this prototype, we see the `%else` key.  This is used by the `%lookup` function to find information in the chain of ancestors of a component. 

In this case, an *eh* component has its own unique *name* and just about every other attribute/function is punted upwards to ancestors.

Note that the chain of ancestors is created at runtime and cannot be "compiled out".  This dynamic inheritance of ancestors is a key feature in the flexibility of this system.

[^eh]: Eh is the Canadian-inspired pronunciation of the single letter `ė` from the Lithuanian alphabet.  I was adamant about not using Greek letters.
