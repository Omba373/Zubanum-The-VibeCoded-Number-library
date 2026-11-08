# v2.3.0

### The -illion ladder is nested, so the list orders itself

With `f(n) = 10^(3n+3)`, illion index `i` has `N = i - 1` roots, split as
`N = a*1e6 + t` into meg-groups and a tail.

* `a = 0` keeps the exponent at `3*i`, so every name below millillion is exactly
  the v2.2 reading.
* From `a = 1` the `me-` prefix multiplies instead of adds: the exponent becomes
  `3*(f(a) + t) + 3`.
* `a = 1` is the fixed point that leaves the whole meg- family unchanged, so
  `megillion` is still `10^3000003`.
* Two steps up, **`mehectillion` (`a = 100`) is `10^(3*10^303+3)`**, which now
  sorts above `googolplex` and below `googolduplex`:

  ```js
  Z.cmp(Z.fromName("mehectillion"), Z.fromName("googolplex"))     //  1
  Z.cmp(Z.fromName("mehectillion"), Z.fromName("googolduplex"))   // -1
  ```

* Because every tier-2 exponent is at most `3*10^303+3`, it still fits a plain
  double, so no new value kind was needed.
* `illionValue(i)` and `plexValue(k)` return the exact value behind a name. Prefer
  them over subtracting two exponents: tails closer than one ULP of `10^(3a+3)`
  merge when read through `log10`, which starts at `a = 5`.

### Spelling

`millillion` and `millicentillion` now read back like the printed tables that use
them, alongside the composed `milillion` and `milicentillion` the root loop
writes. `million` is untouched.

### Unchanged on purpose

A name still carries no arithmetic: `"10^(3*10^303+3)"` does not parse. The ladder
rows are reached by `illionValue(i)`, by `fromLog10(3e303)`, or by the spelling
`"mehectillion"` - all three give the same value and name themselves the same way.

`SAVE_VERSION` stays `1`, so saves written by 2.1 and 2.2 still load.

# v2.2.0

* The -illion and -plex ladders are composed from Latin roots instead of typed out
  line by line: a root is a meg- group, a mil- group and a units group joined by an
  `i` connective, so a hundred million names come from three tables and a loop. All
  twenty-one illion and ten plex spellings the library carried before come back
  character for character, and the sweep both ways is unique - `1500` is
  `"miliquingent"` while `500000` is `"milquingent"`, `1000002` is `"megiun"` while
  `2000000` is `"meduo"`.
* The ladders stop at `LADDER_CAP = 1e8`. `illionName(100000001)` is
  `"mehectillion"` and `plexName(1e8)` is `"googolmehectaplex"`; one index past
  either returns `null` and the spelling reads back as `NaN` rather than wrapping.
* `illionName`, `plexName`, `illionIndex`, `plexIndex`, `illionValue`, `plexValue`
  are public, and `toSuffix` / `toName` run through the same generators, so naming
  reaches past the old `1e66` stop.
* New helpers: `gcd`, `lcm`, `cbrt`, `gamma`, `lambertW`, the six trig functions and
  `atan2`, `lerpLog`, `randLin`, `randLog`, `geoTerm`, `geoSum`, `geoCount`,
  `toLetters` / `fromLetters`, `graham`, `explain`, `toSave` / `fromSave`.
* Powers of ten inside name and suffix parsing are spelled out and handed to the
  number parser, so a value read back from its own spelling lands on the same double
  the plain `"1e126"` text gives.

# v2.1.0

* The core API a game screen reads directly: `add` `sub` `mul` `div` `pow`,
  `factorial`, `digits`, `sum`, `product`, `clamp`, `hyperoperation`, `tetrate`,
  `pentation`, `arrow`, `toArrow`.
* `factorial(v)` is `n!` for a non-negative integer - the product through `170!`,
  Stirling's series above it. `digits(v)` counts the decimal digits of the integer
  part of `|v|`.
* `sum()` starts at `0` and `product()` at `1`; `clamp(v, lo, hi)` returns `NaN` when
  the band is inverted.
* A run of two or more carets or up arrows is Knuth's hyperoperator, so `fromString`
  reads `"3^^3"` at level 4 and `"2^^^3"` at level 5, and a trailing `"!"` as a
  factorial. `toArrow(v)` writes a plain arrow chain back and returns `null`
  wherever no honest arrow spelling exists.
