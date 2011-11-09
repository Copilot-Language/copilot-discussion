TODOs
=====

*   Remove stream guards(?).

*   Implement casting for SBV backend.

*   Remove Tests/... and have the regression execute everything in Examples

*   Why Maybe Tag in ExternArray and ExternFun?

*   Need Graph.hs in copilot-language?

*   Replicate Interface.hs from the "old Copilot".

*   Comments, especially at the beginning of modules and on module exports.

*   Make Copilot operator precedence match Haskell operator precedence.
    (make binary operators associative, for now we have to write 'a && ( b && c )'
     with parens).

*   Add casts to the language.  Add casts that are able to construct a floating
    point stream out of 4 Word8, 2 Word16, 1 Word32 and so on (architecture
    specific), to help protocol monitoring

*   Add a backend to Feldspar.

*   QuickCheck doesn't generate <, >, <=, etc. operators.  Also not currently
    testing mod and div.  Generating external variable checks?


KNOWN BUGS
====

*   RegExpExamples.hs (and possibly other monitors) use up all memory with the interpreter.
