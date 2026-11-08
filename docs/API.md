# API reference

Everything here was read off the module's own export list and the values in
brackets are printed by the library, not written from memory.

```js
const ZubaNum = require("ZubaNum.js");   // Node
// <script src="ZubaNum.js"></script>    // browser, window.ZubaNum
const Buza = require("buza.js");         // companion module, needs ZubaNum
```

## The value model

A value is an object with a `kind`. `ZubaNum.getKind(v)` answers one of the
strings below, and `ZubaNum.tierOf(v)` answers the number in the last column.

| kind | what it holds | example | tier |
| --- | --- | --- | --- |
| `finite` | a double, sign and mantissa | `fromNumber(1e300)` | 1 |
| `tower` | a power tower of tens, height and top mantissa | `fromString("3^^5")` → `10^10^10^1.09902084943703` | 1 |
| `hyper` | a held hyperoperation, not yet collapsed | `nest(5, 3, 3)` → `H(6, 3, 3)` | 1.5 |
| `named` | a named fast-growing value | `TREE3` | 2 |
| `card` | a cardinal or ordinal | `ALEPH0` | 4 |
| `cap` | the ceiling | `MAX_TOWER` | 5 |

Every function accepts a value or a plain number anywhere, and returns a value.
`cmp`, `eq`, `lt`, `lte`, `gt`, `gte` accept both forms too.

## Building values

`fromNumber` `fromString` `fromName` `fromSuffix` `fromLog10` `fromHyperE`
`fromLetters` `fromTable` `fromJSON` `fromSave` `fromRank` `new` `clone`

`fromString` is the do-anything reader: it takes `1.5e9`, `2.5K`, `10^10^10^2`,
`googolplex`, `graham's number`, `3^^4`, `2^^^3`, `3!`, `{10,10,3}` and
`H(4, 3, 2)`. `fromName` and `fromSuffix` are the narrower readers of the same
grammars. `new` is an alias of `fromNumber` for plain numbers.

## Asking what a value is

Predicates: `isFinite` `isTower` `isHyper` `isNamed` `isCard` `isCap` `isZero`
`isNaN` `isNan` `isCeiling` `isFgh` `isHardy` `isZuba` `tierOf`.

Accessors: `getKind` `getSign` `getMantissa` `getAnchor` `getHyper` `getCard`
`getRank` `getFamily` `getFgh`.

`isNaN` is the NaN check; `isZuba` is the "is this one of our values" check and
is what lets a function tell a value from a plain number.

## Arithmetic

`add` `sub` `mul` `div` `mod` `pow` `root` `exp` `ln` `log` `log10` `logBase`
`abs` `negate` `neg` `max` `min` `clamp` `floor` `ceil` `round` `sqrt` `cbrt`
`cube` `digits` `factorial` `gamma` `gcd` `lcm` `sum` `product`

`sum` and `product` fold a list and start at their own identities, so `sum()`
is 0 and `product()` is 1. `clamp(v, lo, hi)` returns `nan` when the band is
inverted rather than guessing. `digits(v)` counts the decimal digits of the
integer part of `|v|`; `digits("googolplex")` prints `1e+100`, since the true
`+1` is far below what a double can show at that size.

`factorial(n)` is exact through `170!` and uses Stirling's series above it. For
non-whole arguments, stepped products, and the Gamma family, use `buza`.

## Hyperoperations

`hyperoperation(level, a, b)` `tetrate` `pentation` `arrow(a, b, arrows)`
`hyper` `nest` `iterate` `itermult` `expoiter` `cuboiter` `trioterate`

`arrow(a, b, n)` is Knuth's up-arrow with `n` arrows, so `arrow(2, 3)` is
`2^^3 = 16` and `arrow(3, 3, 1)` is `3^3 = 27`. `nest(level, base, count)`
keeps the chain unsolved, which is what makes a value print as `H(6, 3, 3)`
and read back through `toArrow`.

`graham(n)` is Graham's number by its own arrow ladder; `GRAHAM` is `graham(64)`.

## Named big numbers and families

Constants: `TREE3` `TREE4` `SSCG2` `SSCG3` `SSCG4` `GRAHAM` `BB5` `BB6`
`LOADER` `RAYO` `FISH7`.

Calls: `tree(n)` `sscg(n)` `bb(n)` `loader(n)` `rayo(n)` `fish(n)` `ack(n)`
`ackermann(n)` `family(name, ...args)` `defineFamily` `families` `familyInfo`
`hyperFamily`.

`families()` returns the grid rows, and each row names its own spellings, so
the alias list is never something a reader has to trust from a document:

```
familyInfo("tree")
  { family: "TREE", band: 1000, index: "unbounded", min: 3, params: 1,
    prefix: "TREE", aliases: ["tree"], call: ["tree"] }
```

The named-hyperoperation spellings are their own grid - `expande`,
`multiexpande`, `powerexpande`, `aperioexpande`, `explode`, `multiexplode`,
`aperioexplode`, `detonate`, `aperiodetonate`, `epsilonate`, `megote`,
`multimegote`, `aperimegote`, `gigote`, `aperigigote`, `megoexpande`,
`aperimegoexpande`, `megoaperionate`, `gigoaperionate`, `aperiatote`,
`aperionate`, `aperioguate`, `aperiote`, `aperixxate`, `trixxate`,
`powiainate`, `powiairate`, `expandainate`, `megodainate` - and each long
spelling also answers to a short alias in the same module, `apat`, `apdt`,
`apea`, `apel`, `apeo`, `apgg`, `apgu`, `apix`, `apme`, `apmg`, `deto`,
`epan`, `epsl`, `expa`, `expl`, `expo`, `gigo`, `mego`, `muel`, `muea`,
`mume`, `poea`, `tria`, `trix`. `familyInfo(name)` is the lookup for the
family rows above (`"tree"`, `"sscg"`, `"graham"`, ...) and answers `null`
for these spellings, which are hierarchy steps rather than families.

The `h`-codes - `h11` `h12` `h20` `h100` `h1000` `h10000` and the rest - are
anchor hyperoperations at fixed positions in the hierarchy. `{10, 10, 3}`
reads as a BEAF linear array, and `H(4, 3, 2)` reads as hyper-E:

```
fromString("{10, 10, 3}")   // H(5, 10, 10)
fromString("H(4, 3, 2)")    // H(4, 3, 2)
fromString("graham's number")  // GRAHAM
```

## The -illion and -plex ladders

`ILLION` `PLEX` (index from 1, generated on demand and cached)
`illionName(i)` `plexName(k)` `illionIndex(name)` `plexIndex(name)`
`illionValue(i)` `plexValue(k)` `illionExp(i)` `LADDER_CAP`.

```
ILLION[1]                thousand
ILLION[100]              nonnonagintillion
ILLION[1000]             nongentononnonagintillion
ILLION[100000001]        mehectillion
illionName(100000002)    null
PLEX[1]                  googolplex
PLEX[5]                  googolquintiplex
PLEX[100000000]          googolmehectaplex
plexName(100000001)      null
LADDER_CAP               100000000
illionExp(1)             3
illionExp(100)           300
illionExp(1000000)       3000000
illionExp(100000001)     3.0000000000000003e+303
```

Past the cap there is no row: `illionName` and `plexName` answer `null`, the
`ILLION` and `PLEX` tables answer `undefined` for an index they will not
generate, and the spellings read back as NaN rather than wrapping around.

See [LADDERS.md](LADDERS.md) for the rule that generates them and why
`mehectillion` sits between `googolplex` and `googolduplex`.

## Ordinals and cardinals

`aleph(n)` `beth(n)` `alephFixed(n)` `bethFixed(n)` `cardSucc` `nextCardinal`
`fgh(rank, n)` `hardy(rank, n)` `lift(v, rank)` `layerAdd(v, n)`
`fromRank` `getRank`.

`Rank` and `Ordinal` are the same index grid: `ZERO` `OMEGA` `EPS0` `ZETA0`
`ETA0` `GAMMA0` `GAMMA_OMEGA` `SVO` `LVO` `BHO` `SBO` `LBO` `TFB` `EBHO`
`WEAK_INV` `WEAK_MAHLO` `WEAK_COMPACT` `TOP`, plus `phi` `gamma` `add` `succ`
`pred` `compare` `finite` `isFinite` `isLimit` `fromString` `fromAny`
`toTable` `fromTable` `toString` `ceiling`.

Tower helpers per rank: `omegaTower` `epsilonTower` `zetaTower` `etaTower`
`phiTower(v, n)` `gammaTower` `gammaOmegaTower` `sboTower` `lboTower`
`tfbTower` `bhoTower` `ebhoTower` `weakInaccessibleTower` `weakMahloTower`
`weakCompactTower`.

The named ordinals on `Ordinal` are `EPS0` `ETA0` `GAMMA0` `GAMMA_OMEGA`
`LBO` `LVO` `BHO` `EBHO` and more; `ALEPH0..ALEPH3`, `ALEPH_OMEGA`,
`ALEPH_FIXED1`, `BETH0`, `BETH1` are values, not ranks.

## Printing

`format(v)` `format(v, mode)` `toString` `toSuffix` `toName` `toNumber`
`toLog10` `toArrow` `toHyperE` `toBEAF` `toLetters` `toTable` `toJSON`
`toSave` `explain(a, b)`.

`format(v, "nest")` rewrites a retained chain of depth 2 or more into its
compressed spelling. `explain(a, b)` returns a sentence saying why the two
order the way they do -

```
explain(fromString("googolplex"), fromNumber(1e100))
  tower height 3 mantissa 2 sign 1 > finite 1e+100 (both tier 1, so the order inside the tier decides it)
```

`toSave` / `fromSave` are the compact versioned string, one line per value:

```
toSave(fromString("googolplex"))    // "1t3,2,1"     (1 = SAVE_VERSION)
```

## Game helpers

`spend(budget, cost)` `geoTerm(first, ratio, count)` `geoSum(first, ratio, count)`
`geoCount(first, ratio, budget)` `lerpLog(a, b, t)` `randLin(lo, hi)`
`randLog(lo, hi)` `clamp` `getAnchor`.

`spend` answers "how many of these fit in that" across every scale at once and
returns `{ count, remainder, exact, scale, precise }`, or `null` when `cost` is
not positive. Nothing is mutated, and the inputs are not converted down first,
so a price in `TREE(3)` and a wallet in googolplexes need no tier check:

```
spend(fromString("googolplex"), fromNumber(1e9))
  // count 10^10^10^2, remainder 0, exact true, scale "finite", precise false
```

`geoCount` is the inverse of `geoSum`, so a geometric upgrade cost keeps
working once the budget is a tower:

```
geoTerm(10, 2, 300)                 // 10 x 2^299
geoCount(10, 2, 1e6)                // 16
geoCount(10, 2, fromNumber(1e100))  // 328
geoCount(10, 2, fromString("googolplex"))  // 3.32193e100
```

`lerpLog(a, b, t)` interpolates in log space, which is the only way to name a
middle between 1 and a googolplex: `lerpLog(1, googolplex, 0.5)` is
`10^10^10^1.99869067161412`, that is `10^(0.5 x 10^100)`.

## Constants

`ZERO` `ONE` `TEN` `NAN` `INFINITY` `MIN` `MAX` `LIMIT` `NEG_LIMIT`
`MAX_TOWER` `NEG_MAX_TOWER` `CEILING` `NAME` `VERSION` `SAVE_VERSION`
`MAX_SAFE` `LADDER_CAP`.

`MAX_SAFE` is `9007199254740991`, the 2^53 window the library treats as the
edge of exact finite arithmetic. `VERSION` is `"2.3.0"` and `SAVE_VERSION` is
`1`, the tag written at the head of every `toSave` string.

## buza

15 functions, all of them taking and returning ZubaNum values:

`logGamma` `digamma` `gammaLower` `gammaUpper` `beta` `binomial`
`factorialDec` `multifactorial` `doubleFactorial` `fallingFactorial`
`risingFactorial` `nthRoot` `superRoot` `hyperRoot` `VERSION`.

See [BUZA.md](BUZA.md) for what each one refuses and why.

## Operator hooks

`__add` `__concat` `__div` `__eq` `__le` `__lt` `__mod` `__mul` `__pow`
`__sub` `__tostring` `__unm`.

These are the same operations under operator-table names, for hosts that
overload operators. In plain JavaScript the values carry `valueOf`,
`toString` and `Symbol.toPrimitive`, so `String(ZubaNum.fromString("2.5K"))`
is `"2500"` and `+ZubaNum.ONE` is `1`.
