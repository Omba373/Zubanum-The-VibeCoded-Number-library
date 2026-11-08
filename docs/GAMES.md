# Using ZubaNum in a growth game

## One type for the whole run

Keep every currency, cost and multiplier as a ZubaNum value. Plain doubles overflow
at `1.8e308`; `Z.mul(1e308, 1e308)` keeps going and reports `10^10^2.77815125038364`.

```js
const Z = require("./ZubaNum.js");

let coins = Z.new(1e308).mul(1e10);   // past a double, still one value type
coins.format();                        // "10^10^2.50242711998443"
coins.toName();                        // "centoquinillion"
coins.digits().format();               // "319"
```

## Pricing an upgrade across scales

`Z.spend(budget, cost)` answers "how many of these fit in that" at every tier at
once, so a loop never needs a scale check. It returns `{ count, remainder, exact,
scale, precise }`, or `null` when `cost` is not a positive value. Neither input is
mutated.

```js
const bill = Z.spend(Z.tree(4), Z.tree(3));
bill.count.format();   // "TREE(4)"
bill.scale;            // "named"

Z.spend(Z.LIMIT, 5).scale;   // "limit"
```

`scale` names the tier `count` landed in - `finite`, `hyper`, `named`, `ordinal`,
`cardinal` or `limit`. `precise` is true only when both operands are finite and
inside the `2^53` window, because above it `floor` and the product round back and the
remainder stops meaning anything.

## Series costs

Geometric upgrade lines, without a loop:

```js
Z.geoTerm(10, 2, 30).format();   // cost of level 30, first=10 ratio=2  -> 5368709120
Z.geoSum(10, 2, 30).format();    // total of levels 1..30               -> 10737418230
Z.geoCount(10, 2, 1e6).format(); // how many levels fit in 1e6           -> 16
```

## Interpolating and displaying

```js
Z.lerpLog(1, 1e100, 0.5).format();   // "1e+50"  the geometric middle
Z.clamp(v, lo, hi);                   // NaN when the band is inverted
Z.toSuffix(2.5e6);                    // "2.5M"   for a compact HUD
Z.explain(a, b);                      // why two values order the way they do
```

`explain` is the one to call when a player asks why an upgrade cost more than the
number shown: `Z.explain(Z.fromName("googolplex"), Z.fromName("googolduplex"))` gives
`"tower height 3 mantissa 2 sign 1 < tower height 4 mantissa 2 sign 1 (both tier 1,
so the order inside the tier decides it)"`.

## Saving

`toJSON` / `fromJSON` for a structured store, `toSave` / `fromSave` for a compact
string beside it:

```js
const s = Z.toSave(Z.fromName("googolplex"));   // "1t3,2,1"
Z.fromSave(s).format();                          // "10^10^10^2"
```

`ZubaNum.SAVE_VERSION` is `1`. Saves written by 2.1 and 2.2 still load.

## What will bite you

* **A small factor disappears at tower scale.** Past a double a value is stored on
  the grid its scale sits on, so `Z.mul(Z.fromName("googolplex"), 2)` is
  `googolplex` again, and halving is a no-op. That is not a rounding bug - it is what
  makes `googolplex` and `TREE(3)` comparable at all. If a game needs "times two" to
  matter, do it below `1e308`.
* **Comparisons of two towers go through `slog`.** `Z.slog(v)` is the measure that
  separates them; comparing their `log10` values can land on the same point.
* **`gammaLower`, `gammaUpper` and `beta` need double arguments** (see `docs/BUZA.md`).
* **`NaN` is unordered with everything, including itself.** Comparisons involving a
  `NaN` value answer by that rule rather than pretending it is large.
