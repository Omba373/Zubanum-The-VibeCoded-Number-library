# buza - the analysis companion

`buza.js` is a second file that requires `ZubaNum.js`; keep both in the same folder.
It exists so the core file stays small, and it adds the maths a growth loop asks for
after the size questions are answered.

```js
const Buza = require("./buza.js");

Buza.logGamma(170).format();        // 701.4372638
Buza.digamma(0.5).format();         // -1.963510026   (-gamma - 2 ln 2)
Buza.factorialDec(0.5).format();    // 0.8862269255   (Gamma(3/2))
Buza.beta(0.5, 0.5).format();       // 3.141592654    (pi)
Buza.binomial(160, 6).format();     // 21193254160
Buza.gammaLower(2, 3).format();     // 0.8008517265
Buza.multifactorial(2000, 2).format();   // 10^10^3.45767523838696
Buza.nthRoot("googolplex", 3);      // the cube root of a named value
Buza.superRoot("googolduplex", 2);  // the base of a tower
Buza.hyperRoot("googolplex", 2, 4); // 1.02032e+98
```

Every function takes and returns a ZubaNum value, so results order against each other
and against anything the core produces. A plain number is accepted anywhere a value
is. `superRoot` and `hyperRoot` also accept a name as text.

## Gamma family

`logGamma`, `digamma`, `gammaLower`, `gammaUpper`, `beta`.

## Factorials

`factorialDec` for arguments that are not whole numbers, `doubleFactorial` and
`multifactorial` for stepped products, `fallingFactorial` and `risingFactorial` for
the Pochhammer products.

## Roots

`nthRoot` for the plain root, `superRoot` for the base of a tower, `hyperRoot` for
either at a chosen hyperoperation level. `hyperRoot(v, n, 4)` is `superRoot(v, n)` and
`hyperRoot(v, n, 3)` is `nthRoot(v, n)` - the probe checks that they agree.

## Boundaries, stated rather than discovered at run time

* `gammaLower`, `gammaUpper` and `beta` are answers in a bounded range, so an argument
  a double cannot hold gives `NaN`. `logGamma`, `digamma`, `factorialDec`,
  `multifactorial` and the roots do have a real answer past the double window, and
  they give it from the leading term of the same series - truthful, because the terms
  that are dropped fall below what the representation can distinguish.
* `logGamma` is `NaN` at the poles of Gamma, and `digamma` at the same integers.
* `multifactorial` and the two Pochhammer products need a whole-number count. A
  decimal argument to a stepped product has no agreed value, so it gives `NaN`
  instead of inventing one - `factorialDec` is the decimal one.
* `superRoot` and `hyperRoot` need a target above 1, and stop with `NaN` when the base
  sits past the six log levels the search can walk. They are searches, so they cost a
  few hundred core calls per answer; the rest of the module is closed form.

## How it is checked

410 reference values computed at 60 digits by an independent implementation, plus the
identities a reference table cannot state: Gamma's reflection formula, integer
factorials, `P + Q = 1`, Gauss duplication, the digamma recurrence, Pascal's rule,
multifactorial against the written product, and the forward trip of every root
(`tetrate(superRoot(x, n), n)` back through `slog` against `x`).

**425 checks, 0 failures.**
