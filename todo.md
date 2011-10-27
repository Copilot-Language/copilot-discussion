TODOs
=====

*   Replicate Interface.hs from the "old Copilot".

*   Comments, especially at the beginning of modules and on module exports.

*   Make Copilot operator precedence match Haskell operator precedence.
    (make binary operators associative, for now we have to write 'a && ( b && c )'
     with parens).

*   Add casts to the language.

*   Add casts that are able to construct a floating point stream out of
    4 Word8, 2 Word16, 1 Word32 and so on (architecture specific), to
    help protocol monitoring

*   Add a backend to Feldspar.

*   Remove "error" from copilot-core, copilot-c99 (unimplemented array sampling,
    I think).

BUGS
====

*   Interpreting observers doesn't work.

*   QuickCheck doesn't generate <, >, <=, etc. operators.  Also not currently
    testing mod and div.

*   Interpreting returns "head of empty" error when the args to a trigger is non-empty.

*   RegExpExamples.hs (and possibly other monitors) use up all memory with the interpreter.

DONE
====

*   Replicate Random.hs (and the testing infrastructure) from the "old Copilot".

*   Integrate a (port of) Analysis.hs from the "old Copilot".

*   Use Roman rather than Greek characters.

    +   Should be done. However, if you find any remaining non-roman letters,
        please tell me.

*   Port the voting and clock libraries to the new Copilot version

*   (Maybe) allow let expressions and streams to be both named and anonymous.
    For example, allow something like either

    let_ "var" exp

    and 
    
    var <- let_ () exp 

    The former assists with debugging.

*   SBV backend.
