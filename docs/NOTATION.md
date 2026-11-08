# Notation

What `Z.parse(text)` and `Z.fromString(text)` read, and what `Z.format(value)`
writes back. Every row below was run against the library.

| spelling | meaning | `format` gives |
|---|---|---|
| `"123456.789"` | a finite value | `123456.789` |
| `"1e400"` | past the double window | `10^10^2.60205999132796` |
| `"10^10^6"` | power tower | `10^10^6` |
| `"googolplex"` | named value | `10^10^10^2` |
| `"mehectillion"` | nested illion | `10^10^10^2.48212595574948` |
| `"3^^3"` | tetration, level 4 | `7625597484987` |
| `"2^^^3"` | pentation, level 5 | a hyper value |
| `"10↑↑4"` | Knuth up-arrows | `10^10^10^10^1` |
| `"{10,10,3}"` | BEAF linear array | `H(5, 10, 10)` |
| `"E3#3"` | Hyper-E | `10^10^10^3` |
| `"TREE(3)"` | named family value | `TREE(3)` |
| `"aleph_1"` | cardinal | `ℵ₁` |

## Rules that are load-bearing

* **A run of two or more carets or up arrows is a hyperoperator.** `^^` is level 4,
  `^^^` is level 5. A single caret is exponentiation.
* **A trailing `!` is a factorial**, so `"5!"` is `120`.
* **A name carries no arithmetic.** `"10^(3*10^303+3)"` does not parse. To reach a
  ladder row, ask for it: `illionValue(i)`, `plexValue(k)`, `fromLog10(3e303)`, or
  the spelling itself - `"mehectillion"`. All three routes give the same value.
* **Past the ladder cap the spelling is `NaN`, not a wraparound.** `illionName` and
  `plexName` return `null` beyond `LADDER_CAP = 1e8`, and `fromName` of a name built
  past it reads back as `NaN` rather than silently landing on a smaller number.
* **`toArrow` returns `null` where no honest arrow spelling exists.** It never writes
  an approximation of a value it cannot express as a plain arrow chain.

## Names and suffixes

```js
Z.toSuffix(2.5e6)          // "2.5M"
Z.toName(1e33)             // "decillion"
Z.illionName(100000001)    // "mehectillion"
Z.illionName(100000002)    // null, past the cap
Z.plexName(1e8)            // "googolmehectaplex"
Z.illionIndex("mehectillion")   // 100000001
Z.illionValue(10000)       // 10^10^4.47712125471966
Z.toLetters(1e12)          // "D"   (Game Letter Notation)
```

`toName` runs through the same composed generators as `illionName`, so a tower whose
`log10` is an exact multiple of three prints its -illion name. A value in between -
`10^(3*10^333+3)` - stays computable and orderable with no name of its own.
