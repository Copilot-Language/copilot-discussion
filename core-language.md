The Copilot Core Language
=========================

This document describes the Copilot Core language.

Syntax
------

A Copilot specification, _p_, in the core language consists of

  1. a list of *streams*, _s_.1 ... _s_._n_;

  2. and a list of *triggers*, _t_.1 ... _t_._n_.

A stream, _s_, consists of

  1. a finitite list of atomic values, _x_.1 ... _x_._n_, which we denote
     *buffer*(_s_), and the length of the list we denote *size*(_s_);

  2. and an expression, _e_, which we denote *exp*(_s_).

A trigger, _t_, consists of

  1. an expression of type __bool__, _g_, which we denote *guard*(_t_);

  2. and a list of trigger arguments, _a_.1 ... _a_._n_, which we denote
     *args*(_t_);

A trigger argument, _a_, consists of

  1. an expression, _e_, which we denote *exp*(a).

Expressions are constructed as follows:

  1. If _e_ is an expression and _x_ is an *atomic* value,
     then __const__(_x_) is an expression.

  2. If _s_ is a stream with a buffer of length _i_ and _k_ is an integer such
     that 0 <= _k_ < _i_, then _s_[_k_]_ is an expression.

  3. If _op_ is an *n*-ary atomic operator and _e_.1 ... _e_._n_ are
     expressions, then _op_(_e_.1 ... _e_._n_) is an expression.

Atomic values
-------------

T.B.D.

Typing rules
------------

T.B.D.

Semantics
---------

Program execution is devided into a well ordered sequence of atomic instants
_i_0, _i_1, _i_2, ..., where _i_0, _i_1, _i_2 is isomorphic to the set of
natural numbers.

The value of an expression _e_ at the instant _i_ is denoted *E*{_e_} and is
defined by:

  + *E*{_i_}(__const__(_x_)) = *V*(_x_)

  + *E*{_i_}(_s_{_k_}) = E{_i_-_k_}(_s_)

  + *E*{_i_}(_op_(_e_.1, ..., _e_.n)) =
    (*V*(_op_))(*E*{_i_}(_e_.0), ...,*E*{_i_}(_e_.n))

The value of a stream _s_ at the instant _i_ is denoted *E*{_s_} and is defined
by:

  + *E*{_i_}(_s_) = if _i_ < 0 then *buffer*(_s_).(_i_ + *size*(_s_))
     else *E*{_i_}(*exp(_s_)).
