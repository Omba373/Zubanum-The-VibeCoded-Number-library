# Precision

What the library is exact about, where it deliberately stops, and how to tell
which one you are in. Every line below is the printed behaviour of the module,
not a promise.

## Three windows

| window | range | arithmetic |
| --- | --- | --- |
| integer-exact | `|v| <= 9007199254740991` (`ZubaNum.MAX_SAFE`) | whole numbers are exact |
| double | `|v| < 1.8e308` | 15-17 significant digits, then rounding |
| beyond | towers, hyper chains, named values, cardinals | order, log scales, and structure |

`MAX_SAFE` is what `spend(...).precise` tests against: `precise` is `true`
only when both operands are finite and inside that window, because above it
`floor` and the product round back and a remainder stops meaning anything.

`ZubaNum.tierOf(v)` answers the tier a value sits in - `1` finite or tower,
`1.5` hyper, `2` named, `4` cardinal, `5` the ceiling - and `getKind(v)`
answers the representation name for the same thing.

## The tower grid

A tower keeps its height and its top mantissa and nothing below that, so
multiplying one by a small number is a no-op. This is measured, not a bug
report:

```
mul(googolplex, 2)      10^10^10^2      cmp(..., googolplex)  0
div(googolplex, 2)      10^10^10^2      cmp(..., googolplex)  0
add(googolplex, 1)      googolplex      cmp(..., googolplex)  0
cmp(googolplex, mul(googolplex, 1.5))   0
```

The grid is coarse above the double window and exact inside it. What a tower
does keep is the ordering, and the measure that separates two towers one
mantissa apart is the super-log:

```
slog(googolplex)      3.111111111
slog(mehectillion)    3.164680662
slog(googolduplex)    4.111111111
```

`explain(a, b)` prints the same reasoning as a sentence and is the cheapest way
to check an ordering you did not expect.

## Overflow does not happen; the representation changes

```
add(1e308, 1e308)     10^10^2.48897497565316     kind  tower
```

`1e308 + 1e308` is `Infinity` in raw double arithmetic. Here it becomes a
tower, so an overflow in a game loop yields a bigger number rather than a
broken one. `toNumber` of anything past the double window is `Infinity`, which
is the honest answer for "give me a double".

## Exact past the window, in the places that can be

* `cmp` and the ordering operators are exact over the whole range, including
  between tiers - a `googolplex` and a `TREE(3)` compare correctly.
* `gcd` and `lcm` run the Euclid loop on the IEEE remainder, so they stay
  exact for integer-valued operands past `2^53`.
* `factorial` is the exact product through `170!` and Stirling's series above
  it; `buza.logGamma` is the same series, truncated where the next term falls
  below one unit in the last place of the result.
* `illionExp` and the ladder indices compose from tables, so the names are
  exact strings and the values they denote are exact grid points.
* `geoCount`, `geoSum` and `geoTerm` stay right when the budget is a tower:
  `geoCount(10, 2, googolplex)` answers `3.32193e+100`, which is
  `(10^100 - 1) x log2(10)` - the number of doublings from 10 up to
  `10^(10^100)`.

## Where it says no

* Past `LADDER_CAP` (`1e8`) the ladders have no row: `illionName`, `plexName`,
  `illionValue` and the past-cap spellings all answer `null` or `NaN` rather
  than wrapping to a wrong name.
* `buza` returns `NaN` at the poles of Gamma, for non-whole counts in stepped
  products, for a `superRoot` base past the six log levels its search can
  walk, and for an answer in a bounded range whose input a double cannot hold.
* `toArrow` answers `null` unless the value is still a retained chain -
  `nest(5, 3, 3)` prints `3^^^^3`, while `3^^4` has already collapsed to a
  tower and has no honest arrow spelling.
* `clamp(v, lo, hi)` returns `nan` when the band is inverted.
* `ZubaNum.LIMIT` and `CEILING` are ceilings, not numbers you can grow past;
  arithmetic at the ceiling stays at the ceiling.

## Checking it yourself

Every code block in these docs is printed output, and the two examples that
generate most of them run in a second:

```
node examples/ladder_order.js     # ladder names, cap boundaries, ordering
node examples/tycoon_loop.js      # geometric costs, spend, lerpLog
node examples/quickstart.js       # the tour from the README
```

The reference values behind the companion module are computed at higher
precision outside this library, and each published answer is compared to them
in one of five modes - a plain double, an exactly representable whole number,
a whole number past `2^53` compared in units in the last place, a value past a
double compared on its `log10`, and the same one level up. Both ports run
against the same corpus, so a JavaScript answer and a Luau answer for the same
call are the same number.
