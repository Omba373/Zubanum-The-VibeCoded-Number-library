// Runs from the examples/ folder: node quickstart.js
const Z = require("../ZubaNum.js");

// A wallet that leaves the double range on the first tick.
let coins = Z.new(1e308);
coins = coins.mul(1e10);
console.log("coins            ", coins.format());
console.log("as a name        ", coins.toName());
console.log("digits           ", coins.digits().format());

// Ordering across scales: finite, tower, named, hyper, cardinal, ceiling.
const plex = Z.fromName("googolplex");
console.log("plex vs 1        ", Z.cmp(plex, 1));
console.log("plex + 1 == plex ", Z.cmp(Z.add(plex, 1), plex) === 0);

// The ladder now orders itself: mehectillion sits above googolplex.
const mehect = Z.fromName("mehectillion");
console.log("mehect vs plex   ", Z.cmp(mehect, plex));
console.log("mehect vs dup    ", Z.cmp(mehect, Z.fromName("googolduplex")));

// Pricing an upgrade across every scale at once.
const bill = Z.spend(Z.tree(4), Z.tree(3));
console.log("spend count      ", bill.count.format(), bill.scale);

// Series costs for a geometric upgrade line.
console.log("cost of level 30 ", Z.geoTerm(10, 2, 30).format());
console.log("levels in 1e6    ", Z.geoCount(10, 2, 1e6).format());

// A save string that survives a version change.
const saved = Z.toSave(plex);
console.log("saved            ", saved, "->", Z.fromSave(saved).format());
