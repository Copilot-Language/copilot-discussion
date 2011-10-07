TODOs
=====

*   Replicate Interface.hs from the "old Copilot".

*   Comments, especially at the beginning of modules and on module exports.

*   Make Copilot operator precedence match Haskell operator precedence.

*   Add casts to the language.

*   Ad a backend to Feldspar.

*   Remove "error" from copilot-core, copilot-c99 (unimplemented array sampling,
    I think).

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
