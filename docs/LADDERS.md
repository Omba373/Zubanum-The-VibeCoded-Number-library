# The -illion and -plex ladders

Before v2.2 the library carried thirty typed-out names. Now both ladders are
composed from Latin roots, so they run to `ZubaNum.LADDER_CAP` and stop
there, and the list is ordered by the math rather than by where a table
happened to end.

## The rule

Write `f(n) = 10^(3n + 3)`, so `f` maps an illion index to the exponent of ten
it denotes, with `f(1) = 6` for a million. An illion index `i` has `N = i - 1`
roots, and `N` splits as

```
N = a * 1e6 + t        0 <= t < 1e6
```

* `a = 0`: the exponent is `3i`, the ordinary ladder.
* `a >= 1`: the exponent is `3 * (f(a) + t) + 3`, which nests one tier of
  -illion inside the exponent instead of running the list forever.

`megillion` is fixed at `10^3000003` and `mehectillion` is index `1e8 + 1`,
which is `10^(3 * 10^303 + 3)`. `illionExp(i)` answers the exponent for any
index, and `illionValue(i)` answers the number.

## What that fixes

`googolplex` is `10^(10^100)`. It is not an `-illion` at all, because every
illion exponent is a multiple of three and `10^100 = 1 mod 3`. What v2.3
changes is what the nested indices *denote*: an index past the first million
now takes its exponent from the rule above instead of continuing the list as
if there were a million more flat rungs, so the ordering of the top of the
ladder follows the exponent rather than the position in a table.

```
cmp(mehectillion, googolplex)      1     mehectillion is larger
cmp(mehectillion, googolduplex)   -1     googolduplex is larger
slog(googolplex)                   3.111111111
slog(mehectillion)                 3.164680662
slog(googolduplex)                 4.111111111
```

`examples/ladder_order.js` prints that list, and the names around it:

```
ILLION[1]        thousand                10^3
ILLION[2]        million                 10^6
ILLION[3]        billion                 10^9
ILLION[10]       nonillion               10^30
ILLION[100]      nonnonagintillion       10^300
ILLION[1000]     nongentononnonagintillion      10^3000
ILLION[1e6]      milnongentononnonagintinongentononnonagintillion   10^3000000
ILLION[1e8+1]    mehectillion            10^3.0000000000000003e+303
```

## The roots

A root is a meg- group, a mil- group and a units group joined by an `i`
connective, so the whole ladder comes from three tables and a loop. The sweep
is unique in both directions, which is what makes `illionIndex` safe to
round-trip - each index below prints a different name and reads back to the
index it came from:

```
1500      miliquadringentononnonagintillion
500000    milquadringentononnonagintinongentononnonagintillion
1000002   megiunillion
2000000   megmilnongentononnonagintinongentononnonagintillion
```

The pairs that a flat list would collide - 1,500 against 500,000, 1,000,002
against 2,000,000 - stay distinct because the meg- group and the units group
are read at different positions, not summed.

## The plex ladder

`plex(k)` is the `(k + 2)`-high tower of tens over a googol, so `googolplex` is
index 1, `googolduplex` index 2, and `googolmehectaplex` index `1e8` is the
tower of height `1e8 + 2`.

```
PLEX[1]     googolplex
PLEX[3]     googoltriplex
PLEX[5]     googolquintiplex
PLEX[10]    googoldeciplex
PLEX[100]   googolcentiplex
PLEX[1e8]   googolmehectaplex
```

## The cap

`LADDER_CAP` is `1e8`. Past it there is no row, and the library says so in
every direction:

```
illionName(100000001)   "mehectillion"      illionName(100000002)   null
plexName(100000000)     "googolmehectaplex" plexName(100000001)     null
illionValue(100000002)  NaN
fromString("googolmehectaplexplex")         NaN
```

A value between two named rungs - `10^(3 * 10^333 + 3)`, say - stays
computable and orderable with no name of its own. `toSuffix` and `toName` run
through the same generators, so naming reaches past the stop the typed table
reached and a tower whose `log10` is an exact multiple of three prints its
`-illion` name.
