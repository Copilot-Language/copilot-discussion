TODOs
=====

* Testing: record and compare against "golden value" outputs, at least for
  interpreter.

* Use tags for external functions in SBV backend.

* In interpretation, external functions need to take Stream arguments.

* Fix SBV's makefile generation.

* Generate SBV checks, particularly for array out of bounds.

* QuickCheck:

    * Generate external arrays and functions.
 
*  Remove stream guards(?).

* Implement casting for SBV backend.

* Remove Tests/... and have the regression execute everything in Examples

* Need Graph.hs in copilot-language?

* Replicate Interface.hs from the "old Copilot".

* Comments, especially at the beginning of modules and on module exports.

* Make Copilot operator precedence match Haskell operator precedence.  (make
  binary operators associative, for now we have to write 'a && ( b && c )' with
  parens).

* Add casts to the language.  Add casts that are able to construct a floating
  point stream out of 4 Word8, 2 Word16, 1 Word32 and so on (architecture
  specific), to help protocol monitoring

* Add a backend to Feldspar.


KNOWN BUGS
====

* The interpreter computes all output before printing to screen.  This can mean
  it takes a long time to print the output from large expressions.

* SBV: external array indicies can depend on external variables.  Need to do a
  causality analysis to ensure we're not using an updated value during sampling.
  E.g.:

  void sampleExts(void) {
    ext_idx2 = idx2;
    ext_arr1 = arr1[mk_ext_arr_arr1(queue_0, ptr_0)];
    ext_arr2 = arr2[mk_ext_arr_arr2(ext_idx2)];
  }

  (Check what's done in the copilot-c99 backend.)

* We use stable names
  (http://www.haskell.org/ghc/docs/latest/html/libraries/base-4.4.1.0/System-Mem-StableName.html)
  for sharing, which can't determine that a name is stable for polymorphic
  functions that have type constraints.  This is because the type gets turned
  into a dictionary, and so each application is a new thunk.  For example,
  consider the small example at https://gist.github.com/1385118

  Thus, we require the restriction that all Copilot stream definitions have
  top-level definitions that are monomorphic (the monomorphic functions can all
  polymorphic functions though).
