// The -illion and -plex ladders, listed in the order the real math puts them.
// Run with: node examples/ladder_order.js
const ZubaNum = require("../ZubaNum.js");

const line = (a, b) => a + " ".repeat(Math.max(2, 46 - a.length)) + b;

console.log("illion ladder, index -> name -> 10^exponent");
for (const i of [1, 2, 3, 10, 100, 1000, 1e6]) {
    const e = ZubaNum.illionExp(i);
    console.log(line("  " + ZubaNum.ILLION[i], "10^" + e.toExponential(6)));
}

const cap = ZubaNum.LADDER_CAP;
console.log(line("  top of ladder (" + (cap + 1) + ")", ZubaNum.illionName(cap + 1)));
console.log(line("  one past the cap", String(ZubaNum.illionName(cap + 2))));

console.log("");
console.log("plex ladder, index -> name");
for (const k of [1, 2, 3, 5, 10, 100, cap]) {
    console.log(line("  " + ZubaNum.PLEX[k], "tower of height " + (k + 2)));
}
console.log(line("  one past the cap", String(ZubaNum.plexName(cap + 1))));

console.log("");
console.log("where the big names actually sit");
const googolplex = ZubaNum.fromString("googolplex");
const googolduplex = ZubaNum.fromString("googolduplex");
const mehectillion = ZubaNum.fromString("mehectillion");
const cases = [
    ["googolplex vs googolduplex", ZubaNum.cmp(googolplex, googolduplex)],
    ["mehectillion vs googolplex", ZubaNum.cmp(mehectillion, googolplex)],
    ["mehectillion vs googolduplex", ZubaNum.cmp(mehectillion, googolduplex)],
];
for (const [label, result] of cases) {
    console.log(line("  " + label, result === 0 ? "equal" : result > 0 ? "left is larger" : "right is larger"));
}

console.log("");
console.log("why: towers keep no mantissa, so cmp is decided one level down");
for (const v of [googolplex, mehectillion, googolduplex]) {
    console.log(line("  " + ZubaNum.toName(v) + " slog", ZubaNum.format(ZubaNum.slog(v))));
}
