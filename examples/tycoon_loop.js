// An incremental-game loop: geometric costs, a wallet that leaves the double
// window, and prices priced against numbers the double could never hold.
// Run with: node examples/tycoon_loop.js
const ZubaNum = require("../ZubaNum.js");
const Z = ZubaNum;

console.log("step   cost of that step   total spent   wallet");
let wallet = Z.fromNumber(100);
const first = 10;
const ratio = 2;
for (let step = 1; step <= 8; step++) {
    const price = Z.geoTerm(first, ratio, step);
    const income = Z.mul(Z.fromNumber(3), price);
    wallet = Z.add(wallet, Z.sub(income, price));
    console.log(
        String(step).padStart(4),
        Z.toSuffix(price).padEnd(19),
        Z.toSuffix(Z.geoSum(first, ratio, step)).padEnd(13),
        Z.toSuffix(wallet)
    );
}

console.log("");
console.log("the same loop after the numbers stop fitting in a double");
const huge = Z.geoTerm(first, ratio, 300);
console.log("  price of level 300      ", Z.toSuffix(huge));
console.log("  digits in that price    ", Z.format(Z.digits(huge)));
console.log("  levels a 10^100 wallet buys", Z.format(Z.geoCount(first, ratio, Z.fromNumber(1e100))));
console.log("  levels a googolplex buys", Z.format(Z.geoCount(first, ratio, Z.fromString("googolplex"))));

console.log("");
console.log("buying an upgrade priced above the wallet's own scale");
const walletBig = Z.fromString("googolplex");
for (const price of [Z.fromNumber(1e9), Z.fromString("googol"), Z.fromString("googolplex")]) {
    const paid = Z.spend(walletBig, price);
    console.log(
        "  price " + Z.toSuffix(price).padEnd(14),
        "afforded " + Z.format(paid.count).padEnd(14),
        "scale " + String(paid.scale).padEnd(8),
        "left " + Z.format(paid.remainder)
    );
}

console.log("");
console.log("midpoints between two scales, which a plain average cannot reach");
for (const t of [0, 0.5, 1]) {
    console.log("  t = " + t, Z.toSuffix(Z.lerpLog(Z.fromNumber(1), Z.fromString("googolplex"), t)));
}
