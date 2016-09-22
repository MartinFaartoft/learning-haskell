# Notes and Exercises for "Haskell Programming from first principles"

# Contents

[1 - All you need is lambda](#chapter-1)  
[2 - Hello, Haskell!](#chapter-2)  

<a name="chapter-1"></a>
# 1 - All you need is lambda

    λ x . x
    |---|     Head
      |       Parameter - binds any variable in the body with the same name
          |   Body - bound variable
        |     Head-Body separator

## &alpha; equivalence
    λx.x <=> λy.y <=> λz.z (variable name holds no meaning)

## &beta; reduction
Apply λ-function to an argument - eliminate head and replace all instances of bound variable in body with input.

    λx.x z 
           head is eliminated and body replaced with input expression (z)
         z 

Another λ-function can be the argument

    (λx.x) (λy.y)
    [x := (λy.y)] - x parameter is bound to input value
             λy.y

Ran out of arguments, so cannot apply `λy.y` to anything.

Even more arguments
    
    (λx.x) (λy.y) z

λ application is left-associative, meaning

    (λx.x) (λy.y) z <=> ((λx.x) (λy.y)) z

Reduuuuuuce

    ((λx.x) (λy.y)) z
        [x := (λy.y)]
             (λy.y) z
             [y := z]
                    z

Reduction stops when there are no more heads left to eliminate, or no more arguments to apply functions to.

## Free variables

variable in body that are not mentioned in head are 'free'

    λx.xy - y is a free variable

&beta; reduction does not touch free variables

     λx.xy z
    [x := z]
          zy - cannot apply z to y, since we know nothing about either

&alpha; equivalence does not apply to free variables

    λx.xz NOT equivalent to λx.xy

## Multiple arguments
Each lambda can only bind one parameter and accept only one argument. Multiple arguments = multiple nested heads, eliminated from the left. (aka Currying)

    λxy.xy is shorthand for λx.(λy.xy)

           (λxy.xy) z q
       (λx.(λy.xy)) z q - write as nested λ's
               [x := z]
              (λy.zy) q - eliminating outer head, replacing x
               [y := q]
                    z q - eliminating remaining head, replacing y

Again with more interesting values

           (λxy.xy) (λz.a) q
       (λx.(λy.xy)) (λz.a) q
               [x := (λz.a)]
             (λy.(λz.a) y) q
                    [y := q]
                    (λz.a) q - one more application possible
                    [z := q] - no z in body of function to replace
                           a

More complicated example
    
          (λxyz.xz(yz))(λmn.m)(λp.p)
    (λx.λy.λz.xz(yz))(λm.λn.m)(λp.p) - explicit Currying
                      [x := λm.λn.m]
        (λy.λz.(λm.λn.m)z(yz))(λp.p)
                       [y := (λp.p)]
            λz.(λm.λn.m)(z)((λp.p)z) - cannot apply outermost lambda, no argument to apply to
                            [m := z] - digging into inner lambda to find something reducible
                  λz.(λn.z)((λp.p)z)
                    [n := ((λp.p)z)]
                                λz.z - no n's left in body, so entire argument is tossed out

## Equivalence Exercises
    
Choose equivalent λ

    1) λxy.xz

    a) λxz.xz
    b) λmn.mz - alpha equivalence
    c) λz(λx.xz)

    2) λxy.xxy

    a) λmn.mnp
    b) λx(λy.xy)
    c) λa(λb.aab) - alpha equivalence, head nesting just looks different

    3) λxyz.zx

    a) λx.(λy.(λz.z))
    b) λtos.st - answer, alpha equivalence
    c) λmnp.nm
    
## Normal form

In λ calculus, normal form means &beta; normal form, where there is nothing left to &beta; reduce

## Combinators

A combinator is a lambda term with no free variables - every term in the body occurs in the head.

    λx.x - no free variables, combinator

    λxy.x - no free variables, combinator

    λxy.xz(yz) - not combinator, z is free

## Divergence

Some lambda terms refuse to reduce fully - meaning that the reduction process never terminates. Opposite of convergence.

        (λx.xx)(λx.xx)
        [x := (λx.xx)]
        (λx.xx)(λx.xx) - Back where we started, divergence (called omega)

## Summary

* FP is based on expressions

* Functions have a head and a body and are those expressions that can be applied to arguments / reduced / evaluated to get a result.

* Every occurrence of a bound variables has the same value in the body of function.

* All functions take one argument and return one result

* Functions are a mapping of a set of inputs to a set of outputs. Given the same input, they always return same result.

## Chapter Exercises

Determine if each is a combinator or not

    1) λx.xxx - combinator
    2) λxy.zx - not, z is free
    3) λxyz.zy(zx) - combinator 
    4) λxyz.zy(zxy) - combinator
    5) λxy.xy(zxy) - not, z is free

Diverges?

    1) λx.xxx - converges trivially, no argument to apply to
    2) (λz.zz)(λy.yy) - diverges, omega with different param names
    3) (λx.xxx)z - converges to zzz

&beta; reduce

    1) (λabc.cba)zz(λwv.w)

    (λa.(λb.(λc.cba)))zz(λw.(λv.w)) - explicit Currying 
                           [a := z]
          (λb.(λc.cbz))z(λw.(λv.w))
                           [b := z]                                     
                (λc.czz)(λw.(λv.w))
                 [c := ((λw.(λv.w))
                      (λw.(λv.w))zz
                           [w := z]
                            (λv.z)z
                           [v := z]
                                  z                                                       

    2) (λx.λy.xyy)(λa.a)b

    (λx.λy.xyy)(λa.a)b
         [x := (λa.a)]
        (λy.(λa.a)yy)b
              [y := b]
              (λa.a)bb
              [a := b]
                    bb                 

    3) (λy.y)(λx.xx)(λz.zq)

    (λy.y)(λx.xx)(λz.zq)
          [y := (λx.xx)]
          (λx.xx)(λz.zq)
          [x := (λz.zq)]
          (λz.zq)(λz.zq)
          [z := (λz.zq)]
                (λz.zq)q
                [z := q]
                      qq

    4) (λz.z)(λz.zz)(λz.zy) (hint: alpha equivalence - not sure what to use the hint for though)

    (λz.z)(λz.zz)(λz.zy)
          [z := (λz.zz)]
          (λz.zz)(λz.zy)
          [z := (λz.zy)]
          (λz.zy)(λz.zy)
          [z := (λz.zy)]
                (λz.zy)y
                [z := y]
                      yy

    5) (λx.λy.xyy)(λy.y)y

    (λx.λy.xyy)(λy.y)y
         [x := (λy.y)]
        (λy.(λy.y)yy)y
              [y := y]
             (λy.y)yy)
              [y := y]
                    yy

    6) (λa.aa)(λb.ba)c

    (λa.aa)(λb.ba)c
     [a := (λb.ba)]
    (λb.ba)(λb.ba)c
     [b := (λb.ba)]
          (λb.ba)ac
           [b := a]
                aac

    7) (λxyz.xz(yz))(λx.z)(λx.a)

    (λx.λy.λz.xz(yz))(λx.z)(λx.a) - explicit Currying
                   [x := (λx.z')] - rename leftmost z to z' for clarity
     (λy.λz'.(λx.z)z'(yz'))(λx.a)
                    [y := (λx.a)]
         (λz'.(λx.z)z'((λx.a)z'))
                        [x := z'] - inner
                (λz'.z((λx.a)z'))
                        [x := z'] - inner again                             
                         (λz'.za)                             

<a name="chapter-2"></a>
# 2 - Hello, Haskell!

Everything is an expression or declaration

expressions may be values, combinations of values and/or functions applied to values

declarations are top-level bindings for naming expressions (more later)

## Functions

Declaring a function: (prefix with `let` in REPL)

    myFunc x = x + 1

Function names are camelCase

calling (prefix) functions:

    myFunc 1

    => 2

args follow the function name, separated by space

Haskell does not reduce completely to Normal Form, but only to 'Weak head normal form' (whatever that is - more later!)

## Infix

Functions with alphanumeric names are prefix by default, if the name is a symbol it is infix by default.

    myFunc 1 --myFunc is prefix

    1 + 1 -- + is infix

Wrap infix function in parens to convert to prefix

    (+) 1 1

Sometimes prefix functions will work as infix when wrapped in backticks

    10 `div` 4 

## Associativity and precedence

Infix operators have precendence, query with :info in REPL

    :info (*)
    infixl 7 * -- left associative infix, precedence 7 (higher is evaluated first)

    :info (+)
    infixl 6 +

    :info (^)
    infixr 8 ^ -- right associative infix, higher precendence than *

The `$` function can be used to 'clean' up parens heavy expressions

    :info ($)
    infixr 0 $ -- lowest possible precedence

    (2^) (2 + 2) -- is equivalent to
    (2^) $ 2 + 2

## Whitespace matters

All top level declarations in a source file must start on the same column

    -- test.hs

    module Test where

    a = 1
     b = 2 -- compiler error

## Sectioning (partial application)

    (+1) 2 -- (+1) evaluates to a partially applied + operation
    => 3

Watch out for ordering

    (1/) 2
    => 0.5

    (/1) 2
    => 2.0

## Let and Where

`let` introduces an expression, but `where` is a declaration and is bound to a surrounding syntactic construct (whatever that is).

    printInc n = print plusTwo
      where plusTwo = n + 2
    
    -- is equivalent to

    printInc n = let plusTwo = n + 2
                 in print plusTwo

## Chapter Exercises

Make expressions more explicit with parens

    1) 2 + 2 * 3 - 1
       2 + (2 * 3) - 1

    2) (^) 10 $ 1 + 1
       (^) 10 (1 + 1)

    3) 2 ^ 2 * 4 ^ 5 + 1
       (2 ^ 2) * (4 ^ 5) + 1

Determine if expressions are equivalent

    1) 1 + 1 
       2
       equivalent

    2) 10 ^ 2
       10 + 9 * 10
       equivalent

    3) 400 - 37
       (-) 37 400
       not equivalent, arguments switched

    4) 100 `div` 3
       100 / 3
       not equivalent integer division vs floating point division
    
    5) 2 * 5 + 18
       2 * (5 + 18)
       not equivalent, parens overrides precedence rules