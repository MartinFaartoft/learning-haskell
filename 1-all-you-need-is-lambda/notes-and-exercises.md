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
      => z 

Another λ-function can be the argument

    (λx.x) (λy.y)
    [x := (λy.y)] - x parameter is bound to input value
         => λy.y

Ran out of arguments, so cannot apply `λy.y` to anything.

Even more arguments
    
    (λx.x) (λy.y) z

λ application is left-associative, meaning

    (λx.x) (λy.y) z <=> ((λx.x) (λy.y)) z

Reduuuuuuce

    ((λx.x) (λy.y)) z
        [x := (λy.y)]
          => (λy.y) z
             [y := z]
                 => z

Reduction stops when there are no more heads left to eliminate, or no more arguments to apply functions to.

## Free variables

variable in body that are not mentioned in head are 'free'

    λx.xy - y is a free variable

&beta; reduction does not touch free variables

     λx.xy z
    [x := z]
       => zy - cannot apply z to y, since we know nothing about either

&alpha; equivalence does not apply to free variables

    λx.xz NOT equivalent to λx.xy

## Multiple arguments
Each lambda can only bind one parameter and accept only one argument. Multiple arguments = multiple nested heads, eliminated from the left. (aka Currying)

    λxy.xy is shorthand for λx.(λy.xy)

           (λxy.xy) z q
    => (λx.(λy.xy)) z q - write as nested λ's
               [x := z]
           => (λy.zy) q - eliminating outer head, replacing x
               [y := q]
                 => z q - eliminating remaining head, replacing y

Again with more interesting values

           (λxy.xy) (λz.a) q
    => (λx.(λy.xy)) (λz.a) q
               [x := (λz.a)]
          => (λy.(λz.a) y) q
                    [y := q]
                 => (λz.a) q - one more application possible
                    [z := q] - no z in body of function to replace
                        => a

More complicated example
    
          (λxyz.xz(yz))(λmn.m)(λp.p)
    (λx.λy.λz.xz(yz))(λm.λn.m)(λp.p) - explicit Currying
                      [x := λm.λn.m]
     => (λy.λz.(λm.λn.m)z(yz))(λp.p)
                       [y := (λp.p)]
         => λz.(λm.λn.m)(z)((λp.p)z) - cannot apply outermost lambda, no argument to apply to
                            [m := z] - digging into inner lambda to find something reducible
               => λz.(λn.z)((λp.p)z)
                    [n := ((λp.p)z)]
                             => λz.z - no n's left in body, so entire argument is tossed out

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
     => (λx.xx)(λx.xx) - Back where we started, divergence (called omega)

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
    2) (λx.λy.xyy)(λa.a)b
    3) (λy.y)(λx.xx)(λz.zq)
    4) (λz.z)(λz.zz)(λz.zy) (hint: alpha equivalence)
    5) (λx.λy.xyy)(λy.y)y
    6) (λ<l>a.aa</l>)(λb.ba)c
    7) (λxyz.xz(yz))(λx.z)(λx.a)