Questions
=========

*   Q: So the underlying type of spec in Examples.hs is `[Trigger]`.  Is the idea that
    *any* Copilot program should include a trigger, since triggers are how
    you cause some change to the outside world?
    
    In other words, does your framework allow compiling something like:

        fib :: Stream Word64
        fib = [1, 1] ++ fib + drop 1 fib

    +   A: Currently triggers are not only the only way to cause some change to
        the outside world, they are also the only way to observe the behaviour
        of a Copilot program.
        
        As all streams are anonymous we can no longer observe them. We could
        implement a mechanism for observing streams, e.g. for debugging purposes:

            spec :: Spec ()
            spec =
              do
                trigger "f" booleans [ triggerArg fib, triggerArg (fib + fib) ]
                trigger "g" booleans [ triggerArg nats ]
                observe "x" (fib + fib + 4)

        In the generated C99-code the `observe` function binds the value of
        `fib + fib + 4` to the C99 variable `x`.

*   Q: Are GADTs necessary in core/src/Copilot/Core/Stream.hs?

    +   A: I assume that you mean copilot-language/src/Copilot/Core/Stream.hs?
        We don't need to use GADTs; for the sake of our users, however, we use
        GADTs as this makes the interface a lot cleaner.

        Using GADTs we can write

            fib :: Stream Word64
            fib = [1, 1] ++ fib + drop 1 fib

            counter :: (Num a, Typed a) => Stream Bool -> Stream a
            counter reset = y
              where
                zy = [0] ++ y
                y  = if reset then 0 else zy + 1

        ...instead of

            fib :: Stream s => s Word64
            fib = [1, 1] ++ fib + drop 1 fib

            counter :: (Stream s, Num a, Typed a) => s Bool -> s a
            counter reset = y
              where
                zy = [0] ++ y
                y  = if reset then 0 else zy + 1

        This is a minor detail, and if you prefer we can use type-classes in
        copilot-language instead of GADTs, in the same way as we do in
        copilot-core.

*   Q: Why are data types replicated between
    copilot-language/src/Copilot/Language/Stream.hs and
    copilot-core/src/Copilot/Core/Spec.hs?

    +   A: The reason data types are replicated is that in copilot-language a
        Copilot program is simply a list of triggers, whereas in copilot-core a
        Copilot program consists of a list of triggers and a list of
        *canonized streams*. I haven't exlained to you yet what a canonized
        stream is, but I think it is to complicated to do here. Breifly, in
        copilot-language a stream is a possible *recursive* expression, whereas
        in copilot-core a stream consists of a buffer and a *non-recursive*
        expression.

*   Q: What are the "Observers" defined in copilot-core/src/Copilot/Core/Spec.hs?

*   Q: What model of sharing is used in Copilot?

    + A: Efficiency is important for an eDSL, but there's a tradeoff against
       complexity in the compiler design.  There are two "levels" in the Copilot
       language: (1) *Stream* (Copilot/Language/Stream.hs in the
       copilot-language package), which define the basic datatype for bulding
       computational elements, (2) and *Spec* (Copilot/Language/Spec.hs in
       copilot-language) that contains a list of triggers and observers (for
       debugging).

       Second, there are (at least) two reasons to identify sharing in a
       language: (1) to identify "back-edges", which is necessary for doing things
       like compilation for deeply-embedded languages and (2) improving
       efficiency, so that common sub-expressions aren't re-evaluated.  Let us
       call (1) "pointer sharing" and (2) "efficiency sharing".  The same
       techniques can be used to address both kinds of concerns.

       In Copilot, we implement pointer sharing at the Stream level.  We use the
       techniques described in Andy Gill's "Type-Safe Observable Sharing in
       Haskell" <http://www.ittc.ku.edu/csdl/fpg/Tools/IOReification>, but we do
       not use his data-reify package itself
       <http://hackage.haskell.org/package/data-reify>.

       For simplicity sake, we do not implement efficiency sharing at the Spec
       level of Copilot.  For example, in

         spec :: Spec
         spec = do
           trigger  "f" strA [ arg strB, arg strC ]
           trigger  "g" strA [ arg strB ]
           observer "strA" strB

       the expressions strA and strB are not shared between any of the triggers
       or observers.

       As for the Stream level, we implement efficiency sharing explicitly using
       a local variable bindings, inside the Copilot language.  For example,

         majority :: (Num a, Typed a) => [Stream a] -> Stream a
         majority [] = error "Error in majority: list must be nonempty."
         majority ls = majority' 0 ls 0 0

           where
           majority' :: (Num a, Typed a)
             => Int -> [Stream a] -> Stream a -> Stream Word32 -> Stream a
           majority' _ []     candidate _   = candidate
           majority' k (x:xs) candidate cnt = 
             local (if cnt == 0 then x else candidate) $ \ candidate' ->
               local (if cnt == 0 || x == candidate then cnt+1 else cnt-1) $ \ cnt' ->
                 majority' (k+1) xs candidate' cnt'

       *local* takes and expression and a one-place function and binds the value
       of the expression to the function's argument.

       Our hope is that the use of locals is not commonly needed.  We use it in
       Copilot library functions.  By building on these libraries, we hope the
       user can largely ignore efficiency issues.  (As an aside, because we hope
       to rarely use locals, we don't build a monadic wrapper for streams, which
       is somewhat heavy-weight.)

       Currently, Copilot does not implement common-subexpression elimination
       (CSE).  Implementing CSE for the core-language (package copilot-core) is
       a bit more involved as we don't use a graph-representation.  One approach
       might be convert copilot-core specifications into a graph-representation,
       then do the CSE, and then convert the reduced graph back again into the
       core-representation (and use local variables for representing shared
       expressions).

       In practice, the only library function we have encountered so far that
       requires better efficiency sharing is the majority-vote function (shown
       above).  One reason is that Copilot already provides some modularity at
       the stream level, by allowing users to compose streams, which can be
       evaluated modularly.  For example, 

         even :: (P.Integral a, Typed a) => Stream a -> Stream Bool      
         even x = x `mod` 2 == 0

         odd :: (P.Integral a, Typed a) => Stream a -> Stream Bool       
         odd = not . even      

       Using local variables is only really necessary when generating Copilot
       expressions.  If more substantial Copilot expressions are required in
       library functions, implementing CSE may be necessary.

       As a side note, sharing can be used to control both (1) the time required
       to evaluate an eDSL and (2) the size of the code generated (when
       compiling).  While we anticipate Copilot having a variety of back-ends,
       our current main back-end is Atom
       <http://hackage.haskell.org/package/atom>.  Atom implements CSE itself,
       and it has a number of optimizations to reduce the complexity of
       expressions when values are statically known.  In practice, we have not
       experienced overly-large C programs being generated; our issues have just
       been with compilation time (and more trivially, size of expressions when
       pretty-printing them).
