TODOs
=====

*   Replicate Interface.hs from the "old Copilot".

*   Replicate Random.hs (and the testing infrastructure) from the "old Copilot".

*   Start on the SBV backend for the interpreter.

*   Integrate a (port of) Analysis.hs from the "old Copilot".

*   Comments, especially at the beginning of modules and on module exports.

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
