# ZubaNum — The VibeCoded Number Library

A number library for values a normal number type cannot hold. One value type covers
`0` through the double range, then towers, then named numbers (`decillion`,
`googolplex`), then hyperoperations, then `TREE(3)` / `SSCG(3)` / `LOADER` / `BB` /
`RAYO` / `FISH7`, then cardinals and the ordinal towers up past the large Veblen
ordinal, and one ceiling above all of it.

Written with AI-generated code. Every published value was checked against an
arbitrary-precision reference computed outside this library, and the whole public
surface is dumped and diffed on every release.

## Install

No dependencies, no build step, one file.

```js
const Z = require("./ZubaNum.js");          // Node
```

```html
<script src="ZubaNum.js"></script>          <!-- browser: window.ZubaNum -->
```

## Quick start

```js
const Z = require("./ZubaNum.js");

Z.new(1e300).mul(1e300).format()   // "10^10^2.77815125038364"
Z.add(1e308, 1e308).gt(1e308)      // true, no overflow to Infinity
Z.tetrate(3, 3).toNumber()         // 7625597484987   (3^3^3)

const plex = Z.fromName("googolplex");
Z.format(plex)                     // "10^10^10^2"
Z.cmp(plex, Z.fromName("googolduplex"))   // -1, so googolplex is smaller
Z.toName(Z.new(1e33))              // "decillion"
Z.toSuffix(Z.new(2.5e6))           // "2.5M"
Z.digits(plex).format()            // "1e+100" decimal digits
```

Every function works both ways — as a static call and as a method on a value:

```js
Z.add(a, 1)     // same as     a.add(1)
Z.mul(a, b)     // same as     a.mul(b)
```

## What it reads

`Z.parse(text)` and `Z.fromString(text)` accept all of these, and `Z.format(value)`
writes them back:

| input | reads as | formats as |
|---|---|---|
| `"123456.789"` | a finite value | `123456.789` |
| `"1e400"` | past the double window | `10^10^2.60205999132796` |
| `"10^10^6"` | power tower | `10^10^6` |
| `"googolplex"` | named value | `10^10^10^2` |
| `"3^^3"` | Knuth / tetration | `7625597484987` |
| `"10↑↑4"` | up-arrows | `10^10^10^10^1` |
| `"{10,10,3}"` | BEAF linear array | `H(5, 10, 10)` |
| `"E3#3"` | Hyper-E | `10^10^10^3` |
| `"TREE(3)"` | named family value | `TREE(3)` |
| `"aleph_1"` | cardinal | `ℵ₁` |

## What is in it

**Build** — `new` `fromNumber` `fromString` `fromName` `parse` `fromLog10`
`fromSuffix` `fromTable` `fromRank` `fromJSON` `fromSave`

**Compare** — `cmp` `eq` `ne` `lt` `lte` `gt` `gte` `min` `max` `isNaN` `isFinite`
`isTower` `isNamed` `isHyper` `isCap` `isZero` `isZuba` `getKind` `getSign` `tierOf`

**Arithmetic** — `add` `sub` `mul` `div` `mod` `neg` `abs` `pow` `sqrt` `root`
`cbrt` `floor` `ceil` `round` `succ` `pred` `gcd` `lcm` `sum` `product` `clamp`
`factorial` `digits` `log10` `ln` `log` `logBase` `exp` `slog`

**Growth** — `tetrate` `pentation` `hyperoperation` (`hyper`) `arrow` `toArrow`
`beaf` `toBEAF` `hyperE` `fromHyperE` `toHyperE` `nest` `nestInfo` `nestDepth`
`spend` `lift` `layerAdd` `omegaTower` `epsilonTower` `zetaTower` `etaTower`
`phiTower` `gammaTower` `svoTower` `lvoTower` `bhoTower` `sboTower` `lboTower`
`tfbTower` `ebhoTower` and more

**Named tiers** — `tree` `sscg` `loader` `bb` `rayo` `fish` `fish7` `graham`
`ackermann` `family` `defineFamily` `familyInfo` `families` `hyperFamily`

**Cardinals and hierarchies** — `aleph` `beth` `cardSucc` `alephFixed` `bethFixed`
`fgh` `hardy` `isCard` `isFgh` `isHardy` `getCard` `getFgh`

**Names and suffixes** — `toName` `illionName` `plexName` `illionIndex` `plexIndex`
`illionValue` `plexValue` `illionExp` `toSuffix` `toLetters` `fromLetters`

**Display and storage** — `format` `explain` `toNumber` `toLog10` `toTable`
`toJSON` `toSave` `fromSave` `getRank` `getMantissa` `getHyper` `getAnchor`
`getFamily` `lerpLog` `randLin` `randLog` `geoTerm` `geoSum` `geoCount`

Constants: `LIMIT` `MAX` `NEG_LIMIT` `MAX_TOWER` `MAX_SAFE` `LADDER_CAP`,
`VERSION` (`"2.3.0"`), `SAVE_VERSION` (`1`).

## buza — the analysis companion

`buza.js` is a second file that `require`s `ZubaNum.js`; put both in the same
folder. It keeps the core file small and adds the maths a growth loop asks for next:

```js
const Buza = require("./buza.js");

Buza.logGamma(170).format()        // ln of Gamma
Buza.digamma(0.5).format()         // -gamma - 2 ln 2
Buza.factorialDec(0.5).format()    // 0.8862269255   (Gamma(3/2))
Buza.binomial(160, 6).format()
Buza.multifactorial(2000, 2).format()
Buza.nthRoot("googolplex", 3)      // advanced roots
Buza.superRoot("googolduplex", 2)  // the base of a tower
Buza.hyperRoot("googolplex", 2, 4)
Buza.beta(0.5, 0.5).format()       // pi
Buza.gammaLower(2, 3).format()
```

`logGamma`, `digamma`, `factorialDec`, `multifactorial` and the roots have a real
answer past a double, and give it. `gammaLower`, `gammaUpper` and `beta` are bounded
answers, so an argument a double cannot hold gives `NaN` rather than an invented one.

## Precision, and what it does not pretend

* A finite value is a double: about 15 to 17 significant digits, and the whole
  double range is exact for ordering and arithmetic.
* Past a double, a value is stored as the scale it sits on. That is what makes
  `1e400`, `googolplex` and `TREE(3)` comparable at all, and it means a small factor
  disappears: `Z.mul(Z.fromName("googolplex"), 2)` is `googolplex` again, because 2
  falls below the grid the tower sits on. Same for halving.
* `slog` (super-logarithm) is the measure that distinguishes two towers, which is
  why comparisons of tower-scale results go through it.
* `superRoot` and `hyperRoot` solve for a base, so they cost a few hundred core
  calls per answer and stop with `NaN` when the base sits past the six log levels
  the search can walk. Everything else in the library is closed form.
* `logGamma` is `NaN` at the poles of Gamma, `digamma` at the same integers, and
  `multifactorial` and the two Pochhammer products need a whole-number count.

## Verification

The release is checked with a golden dump: every public entry point prints
deterministic text (43,268 lines) and the result is diffed against the previous
release and against the other implementation of the same library. On this version
they agree on every line except four, which differ in the 17th digit of one derived
display value (`3^^3`, `3↑↑3`, `h10(3, 2)`, `aperiote(3, 2)`) because the two
platforms' math libraries round that one call differently.

The `buza` functions are checked against 410 reference values computed at 60 digits
with an independent implementation, plus identities the reference cannot state —
Gamma's reflection formula, `P + Q = 1`, Gauss duplication, the digamma recurrence,
Pascal's rule, and the forward trip of every root. 425 checks, 0 failures.

## License

See `LICENSE`.
