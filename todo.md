TODOs
=====

*   Replicate Interface.hs from the "old Copilot".

*   Replicate Random.hs (and the testing infrastructure) from the "old Copilot".

*   Start on the SBV backend for the interpreter.

*   Integrate a (port of) Analysis.hs from the "old Copilot".

*   Comments, especially at the beginning of modules and on module exports.

*   Use Roman rather than Greek characters.

    +   Should be done. However, if you find any remaining non-roman letters,
        pleaese tell me.

*   Derive Num so that we can have, for example `x mod 2` where x is a stream
    and 2 is interpreted as a stream of constants.

    +   copilot-language/src/Copilot/Language/Stream.Stream already derives
        `Num`. I have just now added support for Integral operators (`div` and
        `mod`).

*   Derive `Floating` (minor update).
