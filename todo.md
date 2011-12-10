TODOs
=====

*   Fix SBV's makefile generation.

*   Generate SBV checks, particularly for array out of bounds.

*   QuickCheck:

  *   External arrays, functions.
 
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


KNOWN BUGS
====

*   RegExpExamples.hs (and possibly other monitors) use up all memory with the
    interpreter (not sure if still the case).

*   'even' is not hidden Language.Copilot (from the Test suite, I think).

*   This specification sends the interpreter into non-termination:

*   We use stable names
    (http://www.haskell.org/ghc/docs/latest/html/libraries/base-4.4.1.0/System-Mem-StableName.html)
    for sharing, which can't determine that a name is stable for polymorphic
    functions that have type constraints.  This is because the type gets turned
    into a dictionary, and so each application is a new thunk.  For example,
    consider the small example at https://gist.github.com/1385118

    Thus, we require the restriction that all Copilot stream definitions have
    top-level definitions that are monomorphic (the monomorphic functions can
    all polymorphic functions though).  
