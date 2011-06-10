Questions
=========

*   Q: So the type of spec in Examples.hs is [Trigger].  Is the idea that *any*
    Copilot program should include a trigger, since triggers are how you cause
    some change to the outside world?
    
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
