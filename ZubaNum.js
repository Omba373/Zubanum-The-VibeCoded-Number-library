/*
    ZubaNum v2.3.0  (JavaScript big-number library)

    A big-number library with a finite TREE(3)/SSCG(3)/LOADER/BB/RAYO/FISH7
    tier, unbounded family indices, Ackermann's function, a caller-extensible
    family registry, transfinite cardinals, the fast-growing and Hardy
    hierarchies, BEAF arrays, Hyper-E and the -ote family grid, hyper-nesting
    compression, ordinal ranks past LVO up to the weakly compact ceiling, and
    a formal LIMIT ceiling.

    There are five ordered tiers:
        1. finite doubles, finite-rank towers and finite hyper values
           T(0, m) = m, T(h+1, m) = 10^T(h, m), mantissa in [1, 10)
           H(level, base, arg) holds a hyperoperation too large to expand;
           with a named operand it is anchored inside that constant's band
        1.5 plain hyper bands and 2 named-mega finite values: GRAHAM,
           TREE(3), TREE(4), TREE(n), SSCG(3), SSCG(4), SSCG(n),
           LOADER = D^5(99), BB(6), BB(n), RAYO = rayo(1e100),
           higher RAYO(n), and FISH7 = fish(7)
        3. infinite-rank ordinal towers and formal hierarchy values: ranks
           0,1,2,... < omega < epsilon_0 < zeta_0 < eta_0 <
           phi(n,0) < Gamma_0 < SVO < LVO < BHO < SBO < LBO < TFB < EBHO
           < WI < WM < WC, where the collapsing spellings fold into the same
           ladder (psi(Omega) is epsilon_0, psi(Omega^2) is Gamma_0 and
           psi(Omega^Omega) is BHO); f_alpha(n) and H_alpha(n) with an
           infinite or non-integer level keep their (level, argument) form
        4. cardinals: aleph_alpha and beth_alpha for any index this library
           can name, plus the n-th fixed point of either ladder
        5. LIMIT, the formal saturation bound (above every representable
           value; MIN = -LIMIT is the floor). It is a sentinel, not a number.

    TREE(3), SSCG(3), Loader's number, busy beaver values, Rayo's number,
    Fish number 7 and Graham's number are genuine finite integers, so they
    are not treated as infinity: TREE3 + 1, TREE3 * 2, TREE3 ^ 2, TREE3 - 1
    and the same operations on SSCG3, LOADER, BB6, RAYO and FISH7 all keep
    their identity. A named magnitude is coef * B^p + off, where B is
    GRAHAM, TREE(n), SSCG(n), D^n(99), BB(n), RAYO or FISH7. Finite-rank
    towers sit below named values, and infinite-rank towers sit above them,
    matching finite < transfinite. Hyperoperations, tetration, pentation,
    powers and exp with a named operand stay finite too: they become
    anchored H(level, base, arg) values inside that constant's band.

    Hyperoperations above tetration are finite too, so they get a finite
    band instead of saturating:
        Z.hyperoperation(100, 2, 2)     // 4
        Z.hyperoperation(100, 4, 2)     // H(100, 4, 2), finite
        Z.hyperoperation(100, H, 2)     // H(100, H(100, 4, 2), 2)
        Z.hyperoperation(100, TREE3, 2) // H(100, TREE(3), 2), finite
    H(level, base, arg) is the application itself when the tower cannot be
    expanded in compact form. The plain band sits above every finite-rank
    tower and below every named-mega value; ordering inside it is level,
    then base, then arg, then power/coefficient/offset. As with the
    TREE/SSCG/BB bands, that ordering is a convention, not a proof. A named
    operand anchors the result inside that constant's band: H(100, TREE(3), 2)
    is above every plain TREE(3) value and below TREE(4), SSCG(3) and the
    later families. Infinite-rank towers and LIMIT still saturate.

    A family index is a value, not a number, so iterating a sequence is one
    object rather than a loop that cannot finish. Z.tree(Z.tree(3)) is
    TREE(TREE(3)) and Z.tree(Z.omega()) is TREE(omega); ordering inside a
    family reads the index through the same ladder every other value uses, so
    TREE(3) < TREE(TREE(3)) < TREE(omega) < TREE(omega + 1) all hold, and a
    non-integer or infinite index simply stays formal.

    Z.ackermann(m, n), alias Z.ack, is Ackermann's function on the identity
    A(0,n) = n+1 and A(m,n) = H_m(2, n+3) - 3 for m >= 1, so it is exact
    wherever the hyperoperation band is exact - A(3,3) is 61, A(4,1) is 65533 -
    and a level past that window stays a formal H value instead of saturating:
    A(100,100) is H(100, 2, 103)-3. n may be any non-negative value including
    TREE(3); m must be a non-negative integer because a hyperoperation level
    has to be a number. fromString reads ack(4,2) and ackermann(4,2).

    Z.defineFamily({...}) registers a caller-supplied giant so it behaves like
    a built-in one. A single row supplies the band, the index rule, the
    parameter count, the display prefix and the accepted spellings, and
    construction, ordering, formatting, parsing, serialization and the
    exported factory all read that row:
        Z.defineFamily({ name: "quark", band: 7000, prefix: "QK",
                         params: 3, index: "unbounded", min: 0,
                         factory: "quark" });
        Z.quark(2, 5, Z.tree(3));      // QK(2,5,TREE(3))
        Z.fromString("qk(2,5,3)");     // call spelling is the lowercase prefix
    params > 1 gives a family several arguments, ordered left to right after
    the index, and every argument is a full value, so a registered family
    reaches the scales the built-in ones do. A bare alias needs a default
    index and a one-parameter family. Registration is all-or-nothing: it
    returns the canonical name, or null and the reason - a taken name, band,
    alias, call spelling or factory, a non-integer band/params/min, an
    unknown index rule, or a multi-parameter family declared with
    index "none". Z.families() lists every family in band order,
    Z.familyInfo(name) returns one row, and Z.family(name, index, ...) builds
    any family by name.

    Z.nest(level, base, count) compresses a repeated hyperoperation chain:
    applying H_level(base, .) to its own base count times is exactly
    H_{level+1}(base, count), so Z.nest(3, 2, 4) is 65536 and
    Z.nest(13, 3, Z.tree(3)) stays formal. level must be an integer >= 1,
    while base and count accept any value. Z.nestInfo(v) reads an existing
    chain back as { level, base, depth, count } and returns null unless v is
    a plain positive chain whose innermost argument is the base itself, so a
    powered or differently seeded chain does not qualify. Z.nestDepth(v) is
    the depth alone, 0 when there is none, and Z.format(v, "nest") rewrites a
    chain of depth 2 or more to its compressed spelling. Compression is a
    read-only view: a chain and its compressed form are the same number, but
    the structural comparator ranks the compressed one higher, so nestInfo is
    verified by re-iterating the chain rather than by comparing against it.

    Z.spend(budget, cost) answers "how many of these fit in that" across
    every scale at once. It returns { count, remainder, exact, scale, precise },
    or null when cost is not a positive value, so a game loop can price an
    upgrade in TREE(3) against a wallet in googolplexes without a tier check:
        Z.spend(Z.tree(4), Z.tree(3));   // count = TREE(4), scale = "named"
        Z.spend(Z.LIMIT, 5);             // count = LIMIT,   scale = "limit"
    count is floor(budget / cost) and remainder is budget - count * cost, both
    full ZubaNum values, and neither input is mutated. scale names the tier
    count landed in - finite, hyper, named, ordinal, cardinal or limit -
    while precise is true only when both operands are finite and inside the
    2^53 window, because above it floor and the product round back and the
    remainder stops meaning anything.

    The v2.1 core API is the set a game screen reads directly: add sub mul div
    pow, factorial digits, sum product clamp, hyperoperation tetrate pentation
    arrow, and toArrow. Z.factorial(v) is n! for a non-negative integer - the
    product through 170!, Stirling's series above it - and Z.digits(v) counts
    the decimal digits of the integer part of |v|. The folds start at their own
    identities, so sum() is 0 and product() is 1, and clamp(v, lo, hi) keeps v
    between the bounds or returns nan when the band is inverted. A run of two
    or more carets or up arrows in a spelling is Knuth's hyperoperator, so
    fromString reads "3^^3" at level 4 and "2^^^3" at level 5 and a trailing
    "!" as a factorial, while Z.toArrow(v) writes a plain up-arrow chain back
    and returns null wherever no honest arrow spelling exists.

    What is new in v2.2.0
    * The -illion and -plex ladders are composed from Latin roots instead of
      typed out line by line. A root is written as a meg- group, a mil- group
      and a units group joined by an "i" connective, so a hundred million
      names come from three tables and a loop. All twenty-one illion and ten
      plex spellings the library carried before come back character for
      character, and the sweep both ways is unique: 1,500 is "miliquingent"
      while 500,000 is "milquingent", 1,000,002 is "megiun" while 2,000,000 is
      "meduo". ZubaNum.ILLION and ZubaNum.PLEX generate on index and cache
      what is asked for, with rows numbered from 1 so ILLION[1] is "thousand".
    * The ladders stop at ZubaNum.LADDER_CAP = 1e8, so the top names are
      "mehectillion" and "googolmehectaplex", the latter the tower of
      height 1e8 + 2. Past the cap illionName and plexName return null and the
      spellings read back as NaN rather than wrapping around.
    * ZubaNum.illionName(i), plexName(k), illionIndex(name), plexIndex(name),
      illionValue(i) and plexValue(k)
      are public, and toSuffix and toName now run through the same generators,
      so naming reaches past the old 1e66 stop and a tower whose log10 is an
      exact multiple of three prints its -illion name. A value in between -
      10^(3*10^333+3) - stays computable and orderable with no name of its own.
    * New helpers, all of them honest about what they cannot do: gcd and lcm
      on integer-valued operands (the Euclid loop runs on the IEEE remainder,
      so it stays exact past 2^53, and lcm leaves log space when the product
      does not fit), cbrt, gamma (exact factorials to 170!, Stirling above it),
      lambertW, the six trig functions and atan2, lerpLog for a geometric
      middle, randLin and randLog, geoTerm/geoSum/geoCount for series costs,
      Game Letter Notation in toLetters/fromLetters, graham(n) as an arrow
      ladder of its own, explain(a, b) to say why two values order the way
      they do, and toSave/fromSave for a compact versioned string beside
      toJSON.
    * Powers of ten inside name and suffix parsing are spelled out and handed
      to the number parser instead of multiplied into place, so a value read
      back from its own spelling lands on the same double the plain "1e126"
      text gives.

    What is new in v2.3.0
    * The -illion ladder is nested, so the list orders itself. Writing
      f(n) = 10^(3n+3), illion index i has N = i - 1 roots, split as
      N = a*1e6 + t into a meg-groups and a tail. For a = 0 the exponent stays
      3*i, which is every name below millillion and exactly the v2.2 reading.
      From a = 1 the exponent is 3*(f(a) + t) + 3, so the me- prefix multiplies
      instead of adding. a = 1 is the fixed point that keeps the whole meg-
      family unchanged: megillion is still 10^3000003. Two steps up,
      mehectillion (a = 100) is 10^(3*10^303+3), which sorts above googolplex
      and below googolduplex, and the ladder as a whole now runs from thousand
      past the -plex entries it used to sit under.
    * Because every tier-2 exponent is at most 3*10^303+3, it still fits a plain
      double, so no new value kind is needed. ZubaNum.illionValue(i) and
      ZubaNum.plexValue(k) return the exact value behind a name, and
      illionName(i) keeps composing names for any i within the cap. Tails closer
      than one ULP of 10^(3a+3) merge when read through log10; that starts at
      a = 5 and is why a ladder walk should ask for illionValue(i) rather than
      subtract two exponents.
    * Spelling: "millillion" and "millicentillion" now read back like the
      printed tables that use them, alongside the composed "milillion" and
      "milicentillion" the root loop writes. "million" is untouched.
    * A name still carries no arithmetic: "10^(3*10^303+3)" does not parse, and
      the ladder rows are reached by illionValue(i), by fromLog10(3e303), or by
      the spelling "mehectillion" - all three give the same value and name
      themselves the same way.

    The fast-growing hierarchy is Z.fgh(alpha, n): f_0(n) = n + 1, f_1(n) =
    2n, f_2(n) = n * 2^n and, for a finite level a >= 3, f_a(n) =
    H(a + 1, n, n), so f_3(3) = 7625597484987 and f_4(3) is a tower. An
    infinite or non-integer level stays formal and keeps (level, argument)
    inside tier 3, ordered by the level's rank and then the argument, so
    f_omega(100) > f_12(100) > f_3(3) and every hierarchy value stays below
    the cardinals. Z.fgh(Z.aleph(1), 3) is legal and displays as f(aleph_1)(3).
    Spellings include fgh(omega,100), fg(omega,100) and f_omega(100).

    The Hardy hierarchy is Z.hardy(alpha, n, base): H_0(x) = x + base,
    H_{a+1}(x) = H_a(x + 1) and H_l(x) = H_{l[x]}(x), so a finite level is
    plain addition - Z.hardy(3, 10) is 13 and Z.hardy("omega", 100) stays
    formal. It sits beside fgh at the same rank and below it at the same
    level, which is the relation this library models rather than a theorem.

    Cardinals are Z.aleph(alpha) and Z.beth(alpha) for any index, with
    Z.cardSucc and Z.nextCardinal for the successor, and Z.alephFixed(n) and
    Z.bethFixed(n) for the n-th fixed point. Sum and product of infinite
    cardinals collapse to the larger one, which is exactly right; the
    powerset Z.exp(aleph) becomes the next beth, and cardinal division keeps
    the larger side. Ordering between two cardinals is by index and is
    definite, while a cardinal against anything else in tier 4 or below is
    decided by the tier alone.

    BEAF linear arrays are Z.beaf(entries, entrySize) and Z.toBEAF(v), arrow
    chains Z.arrow(base, exponent) spell as base{1,n}x, and Hyper-E is
    Z.hyperE(digits, value) with Z.fromHyperE and Z.toHyperE for the game
    notations that read {m,n}E and E# forms. The -ote grid is Z.expande,
    Z.h11 and the rest of the families, each taking (a, b) and collapsing to
    the same ladder the ordinal ranks use.

    Usage:
        const Z = require("./ZubaNum.js");   // Node / bundlers
        // window.ZubaNum                    // browser global

        const x = Z.new("1e308");
        Z.toString(Z.mul(Z.TREE3, 2));       // "2·TREE(3)"
        Z.lt(Z.SSCG3, Z.LOADER);             // true
        Z.format(Z.tree(Z.tree(3)));         // "TREE(TREE(3))"

    Every API function works both statically and as a value method, so the
    call forms `x.add(1)` and `Z.add(x, 1)` are the same operation:

        x.add(1)  ===  Z.add(x, 1)
        v.pow(2)  ===  Z.pow(v, 2)

    Values are objects tagged by `kind` ("finite" | "tower" | "named" |
    "hyper" | "card" | "fgh" | "cap" | "nan") whose prototype is the
    namespace, so method dispatch and static dispatch share one
    implementation.
*/

(function (root, factory) {
    const api = factory();
    if (typeof module === "object" && module !== null && module.exports) {
        module.exports = api;
    }
    if (typeof exports === "object" && exports !== null) {
        exports.ZubaNum = api;
    }
    if (root) {
        root.ZubaNum = api;
    }
})(typeof globalThis !== "undefined" ? globalThis
    : typeof window !== "undefined" ? window
        : typeof self !== "undefined" ? self : null, function () {
    "use strict";

    // The namespace is callable, so ZubaNum("1e308")
    // is ZubaNum.new("1e308"). Values are Object.create(ZubaNum), so they read
    // as ordinary objects (typeof "object") while inheriting every function.
    function ZubaNum(v) {
        return ZubaNum.new(v);
    }
    ZubaNum.VERSION = "2.3.0";
    ZubaNum.NAME = "ZubaNum";
    ZubaNum.CEILING = "finite TREE(3), SSCG(3), LOADER, BB(6), RAYO, FISH7 / cardinals / ranks up to WC / LIMIT ceiling";

    const LN10 = Math.LN10;
    const E_CONST = Math.E;
    // Rayo's number is Rayo(10^100), the smallest number above everything
    // nameable in first-order set theory with at most a googol symbols.
    const RAYO_INDEX = 1e100;
    const MAX_DOUBLE = 1.7976931348623157e308;
    const LOG10_MAX_DOUBLE = Math.log(MAX_DOUBLE) / LN10;
    const MAX_SAFE = 9007199254740991;
    // Mantissas are snapped to a 1e-14 grid so values produced by different
    // routes (parse, log/pow, add) become canonically identical.
    const MANTISSA_SCALE = 1e14;
    // log10(SSCG(2)) = log10(3*2^(3*2^95) - 8), rounded to double precision.
    const SSCG2_LOG10 = 3.5775080127201285e28;

    const isnan = (x) => x !== x;
    const isfinite = (x) => x === x && x !== Infinity && x !== -Infinity;
    const log10 = Math.log10;
    const pow10 = (x) => Math.pow(10, x);

    // A power of ten reaches its double by spelling it: the decimal text goes
    // through the same correctly-rounded parser a literal does. Math.pow(10, e)
    // is one unit in the last place away from that value for some exponents, and
    // a grid snap moves it further still, so 10^e built any other way would make
    // "1e23" and 10^23 two different numbers. Returns Infinity past the double
    // window, which is the caller's signal to keep the exponent instead.
    function pow10OfText(digits, exp) {
        return Number(digits + "e" + numfloor(exp));
    }

    function snapSignificant(x, digits) {
        if (x === 0 || !isfinite(x)) {
            return x;
        }
        const sign = x < 0 ? -1 : 1;
        x = Math.abs(x);
        const e = Math.floor(log10(x));
        const scale = Math.pow(10, digits - 1 - e);
        if (!isfinite(scale) || scale === 0) {
            return sign * x;
        }
        x = Math.floor(x * scale + 0.5) / scale;
        return sign * x;
    }

    // JS truncates toward zero while this library floors toward -inf, so every
    // integer clamp goes through this helper.
    function numfloor(x) {
        return x >= 0 ? Math.floor(x) : Math.ceil(x);
    }

    // Modulo is defined as `a - floor(a / b) * b`, so the result takes the
    // sign of the divisor and huge operands collapse to 0. The `%` operator is
    // a truncating fmod and cannot be used.
    function floorMod(a, b) {
        return a - Math.floor(a / b) * b;
    }

    // tonumber() returns NaN for non-numeric input. Callers test isfinite, so
    // absent and unparseable input select the same branch.
    function tonumber(x) {
        if (x === null || x === undefined || x === false || typeof x === "object") {
            return NaN;
        }
        if (typeof x === "number") {
            return x;
        }
        if (typeof x !== "string") {
            return NaN;
        }
        const s = x.trim();
        if (s === "") {
            return NaN;
        }
        if (/^[+-]?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?$/.test(s)) {
            return Number(s);
        }
        if (/^0[xX][0-9a-fA-F]+$/.test(s)) {
            return parseInt(s, 16);
        }
        return NaN;
    }

    // C printf helpers ------------------------------------------------------
    // Formatting needs the C printf specs below, and JS has no %g, so they are
    // reproduced digit-for-digit with the glibc rules: use exponent notation
    // when the decimal exponent is < -4 or >= the digit count, strip trailing
    // zeros, and pad the exponent to at least two digits.
    function padExp(n) {
        const sign = n < 0 ? "-" : "+";
        const a = Math.abs(n);
        return sign + (a < 10 ? "0" + a : String(a));
    }

    function trimZeros(s) {
        if (s.indexOf(".") === -1) {
            return s;
        }
        return s.replace(/0+$/, "").replace(/\.$/, "");
    }

    function formatG(x, digits) {
        if (isnan(x)) {
            return "nan";
        }
        if (x === Infinity) {
            return "inf";
        }
        if (x === -Infinity) {
            return "-inf";
        }
        if (x === 0) {
            return 1 / x < 0 ? "-0" : "0";
        }
        const neg = x < 0;
        const a = Math.abs(x);
        let e = Math.floor(log10(a));
        // Rounding up onto a power of ten shifts the exponent.
        if (a >= Math.pow(10, e + 1)) {
            e = e + 1;
        } else if (a < Math.pow(10, e)) {
            e = e - 1;
        }
        if (e >= -4 && e < digits) {
            return (neg ? "-" : "") + trimZeros(a.toFixed(Math.max(0, digits - 1 - e)));
        }
        const parts = a.toExponential(Math.max(0, digits - 1)).split("e");
        return (neg ? "-" : "") + trimZeros(parts[0]) + "e" + padExp(parseInt(parts[1], 10));
    }

    function formatFixed(x, digits) {
        if (isnan(x)) {
            return "nan";
        }
        if (x === Infinity) {
            return "inf";
        }
        if (x === -Infinity) {
            return "-inf";
        }
        // Fixed-point printing rounds an exact half to the nearest even digit,
        // so 2.5 becomes 2 while 3.5 becomes 4. toFixed always rounds halves
        // away from zero, which is the one case where the two disagree.
        const scaled = Math.abs(x) * Math.pow(10, digits);
        const low = Math.floor(scaled);
        const rest = scaled - low;
        const units = rest > 0.5 || (rest === 0.5 && low % 2 !== 0) ? low + 1 : low;
        const out = (units / Math.pow(10, digits)).toFixed(digits);
        return x < 0 ? "-" + out : out;
    }

    // string.lower is byte-based and leaves UTF-8 sequences untouched, so Γ
    // survives as Γ and the spelling tables carry both Greek cases themselves.
    // String.toLowerCase() is Unicode-aware and would fold Γ to γ.
    const lowerText = (s) => s.replace(/[A-Z]/g, (c) => c.toLowerCase());
    const upperText = (s) => s.replace(/[a-z]/g, (c) => c.toUpperCase());

    // An `a:match(p) or a:match(q)` chain stops at the first match, and an
    // empty capture counts as a match. `||` would skip it, so the alternatives
    // go through this helper instead.
    function firstMatch(s, patterns) {
        for (let i = 0; i < patterns.length; i++) {
            const m = match1(s, patterns[i]);
            if (m !== null) {
                return m;
            }
        }
        return null;
    }

    // tostring(n) for the integers that appear in rank spellings.
    const toStr = (n) => String(n);

    // Object maps must be prototype-free so
    // arbitrary spellings cannot hit Object.prototype keys.
    const nilMap = () => Object.create(null);

    // Ordinal ranks ---------------------------------------------------------
    // A rank is a sum of atoms with positive integer coefficients, sorted
    // descending, plus a trailing finite offset. Atom order:
    // omega < phi(1,0)=epsilon_0 < phi(2,0)=zeta_0 < phi(3,0)=eta_0
    //       < phi(n,0) < Gamma_0 < Gamma_omega < SVO < LVO < BHO < SBO < LBO
    //       < TFB < EBHO < WI < WM < WC.
    // This is a deliberately small, canonical fragment of ordinal arithmetic:
    // closed under ordinal +, successor, predecessor where defined, compare.

    const Rank = {};

    // Ordinal atoms in ascending order. omega and phi(n,0) share the first
    // bucket and are separated by n. gamma is the Feferman-Schutte family:
    // Gamma_0 is the Feferman-Schutte ordinal, Gamma_n its successors,
    // Gamma_omega their limit. Above LVO runs the collapsing ladder
    // BHO = psi(Omega^Omega), the small and large Buchholz ordinals, TFB and
    // extended Buchholz, then the weak large-cardinal ordinals I, M and K,
    // which is the rank ceiling.
    const ATOM_ORDER = nilMap();
    ATOM_ORDER.omega = 1;
    ATOM_ORDER.phi = 1;
    ATOM_ORDER.gamma = 2;
    ATOM_ORDER.gamma_omega = 3;
    ATOM_ORDER.svo = 4;
    ATOM_ORDER.lvo = 5;
    ATOM_ORDER.bho = 6;
    ATOM_ORDER.sbo = 7;
    ATOM_ORDER.lbo = 8;
    ATOM_ORDER.tfb = 9;
    ATOM_ORDER.ebho = 10;
    ATOM_ORDER.weak_inv = 11;
    ATOM_ORDER.weak_mahlo = 12;
    ATOM_ORDER.weak_compact = 13;

    const ATOM_NAMES = nilMap();
    ATOM_NAMES.gamma_omega = "Γω";
    ATOM_NAMES.svo = "SVO";
    ATOM_NAMES.lvo = "LVO";
    ATOM_NAMES.bho = "BHO";
    ATOM_NAMES.sbo = "SBO";
    ATOM_NAMES.lbo = "LBO";
    ATOM_NAMES.tfb = "TFB";
    ATOM_NAMES.ebho = "EBHO";
    ATOM_NAMES.weak_inv = "WI";
    ATOM_NAMES.weak_mahlo = "WM";
    ATOM_NAMES.weak_compact = "WC";

    // [band, level] for an atom; both parts drive the ordering.
    function atomOrder(a) {
        const k = a.k;
        const bucket = ATOM_ORDER[k];
        if (bucket === undefined) {
            return [0, 0];
        }
        if (k === "phi") {
            return [bucket, Math.max(1, numfloor(tonumber(a.n) || 1))];
        } else if (k === "gamma") {
            return [bucket, Math.max(0, numfloor(tonumber(a.n) || 0))];
        }
        return [bucket, 0];
    }

    Rank.atomCmp = function (a, b) {
        const ab = atomOrder(a);
        const bb = atomOrder(b);
        if (ab[0] !== bb[0]) {
            return ab[0] < bb[0] ? -1 : 1;
        }
        if (ab[1] !== bb[1]) {
            return ab[1] < bb[1] ? -1 : 1;
        }
        return 0;
    };

    Rank.copyTerm = (t) => ({ k: t.k, n: t.n, c: t.c });

    Rank.copy = function (r) {
        const src = r.terms;
        const terms = new Array(src.length);
        for (let i = 0; i < src.length; i++) {
            terms[i] = Rank.copyTerm(src[i]);
        }
        return { _rank: true, terms, fin: r.fin };
    };

    Rank.normalize = function (r) {
        const src = r.terms || [];
        const terms = [];
        for (let i = 0; i < src.length; i++) {
            const t = src[i];
            const c = numfloor(tonumber(t.c) || 0);
            if (c > 0 && t.k !== undefined && t.k !== null) {
                terms.push({ k: t.k, n: t.n, c });
            }
        }
        terms.sort((x, y) => {
            const cmp = Rank.atomCmp(x, y);
            if (cmp !== 0) {
                return cmp > 0 ? -1 : 1;
            }
            return y.c - x.c;
        });
        const merged = [];
        for (let i = 0; i < terms.length; i++) {
            const t = terms[i];
            const last = merged[merged.length - 1];
            if (last !== undefined && Rank.atomCmp(last, t) === 0) {
                last.c = last.c + t.c;
            } else {
                merged.push(t);
            }
        }
        let fin = tonumber(r.fin) || 0;
        if (!isfinite(fin) || fin < 0) {
            fin = 0;
        }
        fin = numfloor(fin);
        return { _rank: true, terms: merged, fin };
    };

    Rank.isZero = (r) => r.terms.length === 0 && r.fin === 0;
    Rank.isFinite = (r) => r.terms.length === 0;

    Rank.finiteValue = (r) => (r.terms.length === 0 ? r.fin : null);
    Rank.isLimit = (r) => r.terms.length > 0 && r.fin === 0;

    Rank.addFinite = function (r, n) {
        const out = Rank.copy(r);
        let v = tonumber(n) || 0;
        if (!isfinite(v)) {
            v = 0;
        }
        out.fin = out.fin + numfloor(v);
        if (out.fin < 0) {
            out.fin = 0;
        }
        return out;
    };

    Rank.succ = (r) => Rank.addFinite(r, 1);

    Rank.pred = function (r) {
        if (r.fin > 0) {
            const out = Rank.copy(r);
            out.fin = out.fin - 1;
            return out;
        }
        // Limit ranks have no predecessor in this notation; callers use this
        // only for a coarse logarithm, so returning the limit itself is safe.
        return Rank.copy(r);
    };

    Rank.add = function (a, b) {
        if (Rank.isZero(b)) {
            return Rank.copy(a);
        }
        if (Rank.isZero(a)) {
            return Rank.copy(b);
        }
        const firstB = b.terms[0];
        if (firstB === undefined) {
            return Rank.addFinite(a, b.fin);
        }
        const terms = [];
        let keep = a.terms.length;
        while (keep > 0 && Rank.atomCmp(a.terms[keep - 1], firstB) < 0) {
            keep = keep - 1;
        }
        for (let i = 0; i < keep; i++) {
            terms.push(Rank.copyTerm(a.terms[i]));
        }
        for (let i = 0; i < b.terms.length; i++) {
            const t = b.terms[i];
            const last = terms[terms.length - 1];
            if (last !== undefined && Rank.atomCmp(last, t) === 0) {
                last.c = last.c + t.c;
            } else {
                terms.push(Rank.copyTerm(t));
            }
        }
        return Rank.normalize({ _rank: true, terms, fin: b.fin });
    };

    Rank.compare = function (a, b) {
        if (a === b) {
            // Ranks are immutable, so a shared object is the cheapest equality.
            return 0;
        }
        const an = a.terms.length;
        const bn = b.terms.length;
        let i = 0;
        let j = 0;
        while (i < an && j < bn) {
            const cmp = Rank.atomCmp(a.terms[i], b.terms[j]);
            if (cmp !== 0) {
                return cmp;
            }
            if (a.terms[i].c !== b.terms[j].c) {
                return a.terms[i].c < b.terms[j].c ? -1 : 1;
            }
            i = i + 1;
            j = j + 1;
        }
        if (i < an) {
            return 1;
        }
        if (j < bn) {
            return -1;
        }
        if (a.fin !== b.fin) {
            return a.fin < b.fin ? -1 : 1;
        }
        return 0;
    };

    Rank.eq = (a, b) => Rank.compare(a, b) === 0;

    // The representable rank space is exactly [0, TOP]. Anything above the
    // ceiling (TOP+1, TOP*2, or a larger atom) saturates to the LIMIT sentinel.
    Rank.withinCeiling = (r) => Rank.compare(r, Rank.TOP) <= 0;

    Rank.atomName = function (t) {
        if (t.k === "omega") {
            return "ω";
        } else if (t.k === "phi") {
            const n = Math.max(1, numfloor(tonumber(t.n) || 1));
            if (n === 1) {
                return "ε₀";
            } else if (n === 2) {
                return "ζ₀";
            } else if (n === 3) {
                return "η₀";
            }
            return "φ(" + n + ",0)";
        } else if (t.k === "gamma") {
            const n = Math.max(0, numfloor(tonumber(t.n) || 0));
            if (n === 0) {
                return "Γ₀";
            }
            return "Γ" + toStr(n);
        }
        const named = ATOM_NAMES[t.k];
        if (named !== undefined) {
            return named;
        }
        return "?";
    };

    Rank.toString = function (r) {
        if (r.terms.length === 0) {
            return toStr(r.fin);
        }
        const parts = [];
        for (let i = 0; i < r.terms.length; i++) {
            const t = r.terms[i];
            let name = Rank.atomName(t);
            if (t.c > 1) {
                name = name + "·" + toStr(t.c);
            }
            parts.push(name);
        }
        if (r.fin > 0) {
            parts.push(toStr(r.fin));
        }
        return parts.join("+");
    };

    Rank.toTable = function (r) {
        const terms = new Array(r.terms.length);
        for (let i = 0; i < r.terms.length; i++) {
            const t = r.terms[i];
            terms[i] = { k: t.k, n: t.n, c: t.c };
        }
        return { __zubarank: 1, terms, fin: r.fin };
    };

    Rank.fromTable = function (t) {
        if (t === null || typeof t !== "object") {
            return null;
        }
        if (t.__zubarank !== 1) {
            return null;
        }
        return Rank.normalize({
            _rank: true,
            terms: t.terms || [],
            fin: t.fin === undefined ? 0 : t.fin,
        });
    };

    const atomRank = (k, n) => Rank.normalize({ terms: [{ k, n, c: 1 }], fin: 0 });

    Rank.ZERO = { _rank: true, terms: [], fin: 0 };
    Rank.OMEGA = atomRank("omega");
    Rank.EPS0 = atomRank("phi", 1);
    Rank.ZETA0 = atomRank("phi", 2);
    Rank.ETA0 = atomRank("phi", 3);
    Rank.GAMMA0 = atomRank("gamma");
    Rank.GAMMA_OMEGA = atomRank("gamma_omega");
    Rank.SVO = atomRank("svo");
    Rank.LVO = atomRank("lvo");
    Rank.BHO = atomRank("bho");
    Rank.SBO = atomRank("sbo");
    Rank.LBO = atomRank("lbo");
    Rank.TFB = atomRank("tfb");
    Rank.EBHO = atomRank("ebho");
    Rank.WEAK_INV = atomRank("weak_inv");
    Rank.WEAK_MAHLO = atomRank("weak_mahlo");
    Rank.WEAK_COMPACT = atomRank("weak_compact");
    Rank.TOP = Rank.WEAK_COMPACT;

    // Values ----------------------------------------------------------------
    // finite : ordinary double, |n| <= MAX_DOUBLE
    // tower  : sign * T(rank, m), where T(0,m)=m and T(h+1,m)=10^T(h,m)
    // cap    : LIMIT, the formal ceiling sentinel
    // nan    : invalid operation

    const IS_ZUBA = Symbol.for("ZubaNum.value");

    const Impl = {};
    let ZERO, ONE, TEN, NAN, CAP, NEG_CAP, MAX_TOWER, NEG_MAX_TOWER;
    let GRAHAM, TREE3, TREE4, SSCG2, SSCG3, SSCG4, LOADER, BB5, BB6, RAYO, FISH7;
    let ALEPH0, ALEPH1, ALEPH2, ALEPH3, ALEPH_OMEGA, BETH0, BETH1, ALEPH_FP1;
    let Named, Hyper, Idx, Card, Fgh, Beaf, HyperE, Grid;

    // Brand check: only objects inheriting this flag count as library values.
    ZubaNum[IS_ZUBA] = true;

    Impl.isZuba = (v) => v !== null && typeof v === "object" && v[IS_ZUBA] === true;
    Impl.isNan = (v) => v !== null && typeof v === "object" && v.kind === "nan";
    Impl.isCap = (v) => v !== null && typeof v === "object" && v.kind === "cap";
    Impl.isZero = (v) => v !== null && typeof v === "object" && v.kind === "finite" && v.n === 0;

    Impl.newValue = function (props) {
        const v = Object.create(ZubaNum);
        for (const k in props) {
            if (Object.prototype.hasOwnProperty.call(props, k)) {
                v[k] = props[k];
            }
        }
        return v;
    };

    Impl.finite = function (n) {
        if (isnan(n)) {
            return NAN;
        }
        if (n === 0) {
            return ZERO;
        }
        if (n === Infinity) {
            return CAP;
        }
        if (n === -Infinity) {
            return NEG_CAP;
        }
        return Impl.newValue({ kind: "finite", n });
    };

    Impl.maxTower = () => MAX_TOWER;
    Impl.negativeMax = () => NEG_MAX_TOWER;

    Impl.copy = function (v) {
        if (v.kind === "finite") {
            return Impl.finite(v.n);
        } else if (v.kind === "tower") {
            return Impl.newValue({
                kind: "tower",
                sign: v.sign,
                rank: Rank.copy(v.rank),
                m: v.m,
            });
        } else if (v.kind === "named") {
            return Named.copy(v);
        } else if (v.kind === "hyper") {
            return Hyper.copy(v);
        } else if (v.kind === "card") {
            return Card.copy(v);
        } else if (v.kind === "fgh") {
            return Fgh.copy(v);
        }
        return v;
    };

    Impl.signOf = function (v) {
        if (v.kind === "finite") {
            if (v.n > 0) {
                return 1;
            } else if (v.n < 0) {
                return -1;
            }
            return 0;
        } else if (v.kind === "tower" || v.kind === "named" || v.kind === "hyper"
            || v.kind === "card" || v.kind === "fgh") {
            return v.sign;
        } else if (v.kind === "cap") {
            return v.sign;
        }
        return null;
    };

    Impl.negate = function (v) {
        if (v.kind === "nan") {
            return NAN;
        } else if (v.kind === "cap") {
            return v.sign > 0 ? NEG_CAP : CAP;
        } else if (v.kind === "named") {
            return Named.withSign(v, -v.sign);
        } else if (v.kind === "hyper") {
            return Hyper.withSign(v, -v.sign);
        } else if (v.kind === "card") {
            return Card.withSign(v, -v.sign);
        } else if (v.kind === "fgh") {
            return Fgh.withSign(v, -v.sign);
        } else if (v.kind === "tower") {
            const out = Impl.copy(v);
            out.sign = -out.sign;
            return out;
        } else if (v.kind === "finite") {
            return Impl.finite(-v.n);
        }
        return NAN;
    };

    Impl.canonical = function (sign, rank, m) {
        if (sign === 0 || isnan(m)) {
            return NAN;
        }
        if (rank === undefined || rank === null) {
            rank = Rank.ZERO;
        }
        if (!isfinite(m)) {
            if (m === Infinity) {
                return sign > 0 ? CAP : NEG_CAP;
            }
            return NAN;
        }
        if (m < 0) {
            m = -m;
            sign = -sign;
        }
        if (sign === 0 || m === 0) {
            return ZERO;
        }
        sign = sign > 0 ? 1 : -1;

        if (Rank.isZero(rank)) {
            return Impl.finite(sign * m);
        }

        let guard = 0;
        while (m < 1 && guard < 8) {
            m = pow10(m);
            rank = Rank.pred(rank);
            guard = guard + 1;
        }
        while (m >= 10 && guard < 16) {
            m = log10(m);
            rank = Rank.succ(rank);
            guard = guard + 1;
        }
        if (!isfinite(m)) {
            return sign > 0 ? CAP : NEG_CAP;
        }
        if (m < 1) {
            m = 1;
        } else if (m >= 10) {
            return sign > 0 ? CAP : NEG_CAP;
        }

        const snapped = Math.floor(m * MANTISSA_SCALE + 0.5) / MANTISSA_SCALE;
        if (snapped >= 10) {
            rank = Rank.succ(rank);
            m = 1;
        } else {
            m = snapped;
        }

        if (!Rank.withinCeiling(rank)) {
            return sign > 0 ? CAP : NEG_CAP;
        }

        if (Rank.isFinite(rank)) {
            const h = Rank.finiteValue(rank);
            if (h === 0) {
                return Impl.finite(sign * m);
            } else if (h === 1) {
                const v = pow10(m);
                if (isfinite(v)) {
                    const sv = snapSignificant(v, 15);
                    return Impl.finite(sign * (isfinite(sv) ? sv : v));
                }
            } else if (h === 2) {
                const e = pow10(m);
                if (isfinite(e) && e <= LOG10_MAX_DOUBLE) {
                    const v = pow10(e);
                    if (isfinite(v)) {
                        const sv = snapSignificant(v, 15);
                        return Impl.finite(sign * (isfinite(sv) ? sv : v));
                    }
                }
            }
        }

        return Impl.newValue({ kind: "tower", sign, rank, m });
    };

    Impl.fromParts = (rank, m) => Impl.canonical(1, rank, m);

    // Returns [rank, mantissa], or null when the value has no super-log parts.
    Impl.slogPartsFromFinite = function (n) {
        if (!isfinite(n) || n <= 0) {
            return null;
        }
        let h = 0;
        let x = n;
        while (x >= 10 && h < 8) {
            x = log10(x);
            h = h + 1;
        }
        if (x < 1) {
            return null;
        }
        return [Rank.addFinite(Rank.ZERO, h), x];
    };

    Impl.partsFromPositive = function (v) {
        if (v.kind === "tower") {
            if (v.sign < 0) {
                return null;
            }
            return [v.rank, v.m];
        } else if (v.kind === "finite") {
            if (v.n <= 0) {
                return null;
            }
            return Impl.slogPartsFromFinite(v.n);
        }
        return null;
    };

    Impl.fromLog10Value = function (v) {
        if (v.kind === "nan") {
            return NAN;
        } else if (v.kind === "cap") {
            return CAP;
        } else if (v.kind === "finite") {
            const n = v.n;
            if (n < -324) {
                return ZERO;
            } else if (n <= LOG10_MAX_DOUBLE) {
                const mag = pow10(n);
                if (isfinite(mag)) {
                    return Impl.finite(mag);
                }
                return CAP;
            }
            const parts = Impl.slogPartsFromFinite(n);
            if (parts === null) {
                return NAN;
            }
            return Impl.fromParts(Rank.succ(parts[0]), parts[1]);
        } else if (v.kind === "tower") {
            if (v.sign < 0) {
                return ZERO;
            }
            return Impl.fromParts(Rank.succ(v.rank), v.m);
        }
        return NAN;
    };

    Impl.log10Value = function (v) {
        if (v.kind === "nan") {
            return NAN;
        } else if (v.kind === "cap") {
            return MAX_TOWER;
        } else if (v.kind === "named" || v.kind === "hyper") {
            // log10 of a named-mega or hyper-scale value is itself out of
            // reach; the compact tower ladder has no slot for it.
            return NAN;
        } else if (v.kind === "finite") {
            const n = v.n;
            if (n > 0) {
                return Impl.finite(log10(n));
            }
            return NAN;
        } else if (v.kind === "tower") {
            if (v.sign < 0) {
                return NAN;
            }
            const out = Impl.fromParts(Rank.pred(v.rank), v.m);
            if (out.kind === "finite") {
                const r = numfloor(out.n + 0.5);
                // Mantissa rounding loses the exact exponent of 10^n towers.
                if (Math.abs(out.n - r) <= 1e-12 * Math.max(1, Math.abs(r))) {
                    return Impl.finite(r);
                }
            }
            return out;
        }
        return NAN;
    };

    // Named-mega tier -------------------------------------------------------
    // Graham's number, TREE(3), SSCG(3) and Loader's number are finite
    // integers, but they dwarf any compact tower this library can write with
    // double-precision heights. They get their own tier: above every
    // finite-rank tower, below every infinite-rank tower.
    // A magnitude is coef * B^pow + off, where B is the named base and
    // coef/pow/off are finite doubles. Cross-family products and quotients
    // are dominated by the larger base; the smaller factor is below tier
    // resolution.

    // tonumber() keeps absent input distinct from a real NaN: absent or
    // unparseable input is undefined here, while a NaN number stays NaN.
    // Validators that branch on `tonumber(x) === undefined` must not treat
    // the two alike.
    function tonumberNil(x) {
        if (typeof x === "number") {
            return x;
        }
        if (typeof x === "string") {
            const v = tonumber(x);
            return isnan(v) ? undefined : v;
        }
        return undefined;
    }
    const orDefault = (x, d) => (x === undefined || x === null ? d : x);
    const SPACE_RE = /[ \t\r\n\f\v]+/g;
    const stripSpace = (s) => s.replace(SPACE_RE, "");
    const ltrimSpace = (s) => s.replace(/^[ \t\r\n\f\v]+/, "");
    const rtrimSpace = (s) => s.replace(/[ \t\r\n\f\v]+$/, "");

    // A field the caller left out and a field explicitly cleared mean the
    // same thing on these registry paths, so nothing compares to only one of
    // the two.
    function NAMED_has(x) {
        return x !== undefined && x !== null;
    }

    Named = {};

    const COEF_MAX = 1e308;

    // One registry describes every named family: cross-family band, index
    // rule, canonical spellings and factory name. Construction, ordering,
    // formatting, parsing and the factory entry points all read this table,
    // so a family is declared once instead of appearing in several
    // if-chains.
    Named.FAMILIES = [
        { family: "GRAHAM", band: 100, index: "none" },
        { family: "TREE", band: 1000, index: "unbounded", min: 3, prefix: "TREE" },
        { family: "SSCG", band: 2000, index: "unbounded", min: 3, prefix: "SSCG" },
        { family: "LOADER", band: 3000, index: "unbounded", min: 1, prefix: "D" },
        { family: "BB", band: 4000, index: "unbounded", min: 1, prefix: "BB" },
        { family: "RAYO", band: 5000, index: "unbounded", min: RAYO_INDEX, prefix: "RAYO", default: RAYO_INDEX },
        { family: "FISH7", band: 6000, index: "fixed", fixed: 7 },
    ];
    Named.BASE_ORDER = nilMap();
    Named.SPEC = nilMap();
    for (let i = 0; i < Named.FAMILIES.length; i++) {
        const spec = Named.FAMILIES[i];
        Named.BASE_ORDER[spec.family] = spec.band;
        Named.SPEC[spec.family] = spec;
    }

    // Exact base spellings resolve with one lookup instead of walking the
    // per-family pattern chain. Family prefixes with arguments ("BB(6)",
    // "rayo(2e100)") still use the patterns below.
    Named.ALIASES = Object.assign(nilMap(), {
        graham: ["GRAHAM", null],
        "graham'snumber": ["GRAHAM", null],
        grahamsnumber: ["GRAHAM", null],
        g: ["GRAHAM", null],
        tree: ["TREE", 3],
        sscg: ["SSCG", 3],
        loader: ["LOADER", 5],
        "loader'snumber": ["LOADER", 5],
        loadersnumber: ["LOADER", 5],
        bb: ["BB", 6],
        busybeaver: ["BB", 6],
        busybeavernumber: ["BB", 6],
        rayo: ["RAYO", RAYO_INDEX],
        "rayo'snumber": ["RAYO", RAYO_INDEX],
        rayosnumber: ["RAYO", RAYO_INDEX],
        rayonumber: ["RAYO", RAYO_INDEX],
        fish7: ["FISH7", 7],
        fishnumber7: ["FISH7", 7],
        fishno7: ["FISH7", 7],
        "fishno.7": ["FISH7", 7],
        f7: ["FISH7", 7],
    });

    // Characters that can start a named spelling. The string parser skips the
    // named parser for numeric input by testing this class, so registering a
    // family widens it instead of leaving the new prefix unparsable.
    const NAMED_LETTER_RE = /[A-Za-z]/;
    let NAMED_GATE = "[gGtTsSlLdDbBrRfF]";
    let NAMED_GATE_RE = new RegExp(NAMED_GATE);
    Named.GATE = NAMED_GATE;

    Named.widenGate = function (text) {
        let extra = "";
        for (let i = 0; i < text.length; i++) {
            const c = text.charAt(i);
            if (NAMED_LETTER_RE.test(c)) {
                const up = upperText(c);
                const lo = lowerText(c);
                if (NAMED_GATE.indexOf(up) === -1 && extra.indexOf(up) === -1) {
                    extra = extra + up;
                }
                if (up !== lo && NAMED_GATE.indexOf(lo) === -1
                    && extra.indexOf(lo) === -1) {
                    extra = extra + lo;
                }
            }
        }
        if (extra !== "") {
            NAMED_GATE = "[" + NAMED_GATE.slice(1, -1) + extra + "]";
            NAMED_GATE_RE = new RegExp(NAMED_GATE);
            Named.GATE = NAMED_GATE;
        }
    };

    Named.baseOrder = function (v) {
        const o = Named.BASE_ORDER[v.family];
        return o === undefined ? 1000 : o;
    };

    // Extra arguments of a multi-parameter family, kept as values so every
    // scale is legal. Single-index families leave nx unset and never touch
    // these paths.
    Named.argsText = function (v) {
        const nx = v.nx;
        if (!NAMED_has(nx)) {
            return Named.indexText(v);
        }
        const parts = [Named.indexText(v)];
        for (let i = 0; i < nx.length; i++) {
            parts.push(Impl.format(nx[i]));
        }
        return parts.join(",");
    };

    Named.argsCmp = function (a, b) {
        const xa = a.nx;
        const xb = b.nx;
        if (!NAMED_has(xa) || !NAMED_has(xb)) {
            if (!NAMED_has(xa) && !NAMED_has(xb)) {
                return 0;
            }
            return NAMED_has(xa) ? 1 : -1;
        }
        const n = xa.length < xb.length ? xa.length : xb.length;
        for (let i = 0; i < n; i++) {
            const c = Impl.compare(xa[i], xb[i]);
            if (c !== null && c !== undefined && c !== 0) {
                return c;
            }
        }
        if (xa.length === xb.length) {
            return 0;
        }
        return xa.length < xb.length ? -1 : 1;
    };

    Named.argsEq = function (a, b) {
        return Named.argsCmp(a, b) === 0;
    };

    Named.baseName = function (v) {
        if (v.family === "GRAHAM") {
            return "GRAHAM";
        }
        if (v.family === "LOADER") {
            if (v.n === 1) {
                return "D(99)";
            }
            return "D^" + Named.indexText(v) + "(99)";
        }
        if (v.family === "BB") {
            return "BB(" + Named.indexText(v) + ")";
        }
        if (v.family === "RAYO") {
            if (v.n === RAYO_INDEX) {
                return "RAYO";
            }
            return "RAYO(" + Named.indexText(v) + ")";
        }
        if (v.family === "FISH7") {
            return "FISH7";
        }
        const spec = Named.SPEC[v.family];
        const prefix = spec !== undefined && NAMED_has(spec.prefix)
            ? spec.prefix : v.family;
        return prefix + "(" + Named.argsText(v) + ")";
    };

    Named.copy = function (v) {
        return Impl.newValue({
            kind: "named",
            sign: v.sign,
            family: v.family,
            n: v.n,
            idx: v.idx,
            nx: v.nx,
            p: v.p,
            coef: v.coef,
            off: v.off,
            band: v.band,
        });
    };

    Named.withSign = function (v, sign) {
        const out = Named.copy(v);
        out.sign = sign < 0 ? -1 : 1;
        return out;
    };

    Named.normalize = function (family, n, sign, pow, coef, off, idx, nx) {
        sign = sign < 0 ? -1 : 1;
        if (isnan(coef) || isnan(pow) || isnan(off)) {
            return NAN;
        }
        if (!isfinite(pow) || pow <= 0) {
            return sign > 0 ? CAP : NEG_CAP;
        }
        if (!isfinite(coef) || coef <= 0) {
            if (coef === 0) {
                if (!isfinite(off) || off === 0) {
                    return ZERO;
                }
                return Impl.finite(sign * off);
            }
            return sign > 0 ? CAP : NEG_CAP;
        }
        if (coef > COEF_MAX) {
            coef = COEF_MAX;
        }
        if (!isfinite(off)) {
            off = 0;
        }
        const band = Named.BASE_ORDER[family];
        return Impl.newValue({
            kind: "named",
            sign,
            family,
            n,
            idx,
            nx,
            p: pow,
            coef,
            off,
            band: band === undefined ? 1000 : band,
        });
    };

    // Family indices are unbounded: TREE(TREE(3)), BB(RAYO) and TREE(ω) are
    // legal named values. An index that is a plain integer keeps the numeric
    // field so the common case stays allocation-free; anything else is stored
    // as a subscript and ordered through the ladder the cardinal subscripts
    // use. Returns [n, null] for an integer index and [null, idx] for a
    // subscript.
    Named.indexArg = function (spec, n) {
        const min = spec.min || 0;
        if (!NAMED_has(n)) {
            // Only a missing index falls back to the family default; an index
            // that cannot be read (LIMIT, garbage text) stays rejected.
            const d = spec.default;
            if (!NAMED_has(d) || !isfinite(d) || d !== numfloor(d) || d < min) {
                return [null, null];
            }
            return [d, null];
        }
        const num = tonumberNil(n);
        if (num !== undefined) {
            if (isfinite(num) && num === numfloor(num) && num >= min) {
                return [num, null];
            }
            return [null, null];
        }
        const idx = Idx.fromArg(n);
        if (idx === null) {
            return [null, null];
        }
        if (idx.cls === "fin" && idx.v.kind === "finite") {
            const v = idx.v.n;
            if (isfinite(v) && v === numfloor(v) && v >= min) {
                return [v, null];
            }
            return [null, null];
        }
        if (Idx.compare(idx, Idx.fin(Impl.finite(min))) < 0) {
            return [null, null];
        }
        return [null, idx];
    };

    Named.new = function (family, n, sign, pow, coef, off, nx) {
        const spec = Named.SPEC[family];
        if (spec === undefined) {
            return NAN;
        }
        let idx = null;
        if (spec.index === "none") {
            n = null;
        } else if (spec.index === "fixed") {
            n = !NAMED_has(n) ? spec.fixed : tonumberNil(n);
            if (n !== spec.fixed) {
                return NAN;
            }
        } else if (spec.index === "integer") {
            n = tonumberNil(n);
            if (!NAMED_has(n) && NAMED_has(spec.default)) {
                n = spec.default;
            }
            if (!NAMED_has(n) || !isfinite(n) || n !== numfloor(n) || n < spec.min) {
                return NAN;
            }
        } else if (typeof n === "object" && n !== null && NAMED_has(n.cls)) {
            // An already-resolved subscript: fromTable and the value builders.
            idx = n;
            n = null;
            if (Idx.compare(idx, Idx.fin(Impl.finite(spec.min || 0))) < 0) {
                return NAN;
            }
        } else {
            const resolved = Named.indexArg(spec, n);
            n = resolved[0];
            idx = resolved[1];
            if (!NAMED_has(n) && !NAMED_has(idx)) {
                return NAN;
            }
        }
        let args = null;
        const want = (spec.params || 1) - 1;
        if (want > 0) {
            if (!Array.isArray(nx) || nx.length !== want) {
                return NAN;
            }
            args = [];
            for (let i = 0; i < want; i++) {
                const a = nx[i];
                if (!Impl.isZuba(a) || a.kind === "nan") {
                    return NAN;
                }
                args.push(Impl.copy(a));
            }
        } else if (NAMED_has(nx)) {
            return NAN;
        }
        sign = orDefault(tonumberNil(sign), 1);
        pow = orDefault(tonumberNil(pow), 1);
        coef = orDefault(tonumberNil(coef), 1);
        off = orDefault(tonumberNil(off), 0);
        if (!isfinite(pow) || pow <= 0 || !isfinite(coef) || coef <= 0
            || !isfinite(off)) {
            return NAN;
        }
        return Named.normalize(family, n, sign, pow, coef, off, idx, args);
    };

    // Factory entry point: resolves raw arguments the way the built-in
    // families do, so a registered family accepts the same index and value
    // spellings.
    Named.make = function (family, index, args, sign, pow, coef, off) {
        const spec = Named.SPEC[family];
        if (spec === undefined) {
            return NAN;
        }
        let ix = index;
        if (NAMED_has(ix) && typeof ix !== "number") {
            ix = Impl.indexSource(ix);
        }
        let nx = null;
        const want = (spec.params || 1) - 1;
        if (want > 0) {
            if (!Array.isArray(args)) {
                return NAN;
            }
            nx = [];
            for (let i = 0; i < want; i++) {
                const a = Impl.asValue(args[i]);
                if (a.kind === "nan") {
                    return NAN;
                }
                nx.push(a);
            }
        }
        return Named.new(family, ix, sign, pow, coef, off, nx);
    };

    Named.indexOf = function (v) {
        if (NAMED_has(v.n)) {
            return v.n;
        }
        return NAMED_has(v.idx) ? v.idx : null;
    };

    Named.indexText = function (v) {
        if (NAMED_has(v.n)) {
            return Named.numberText(v.n);
        }
        if (NAMED_has(v.idx)) {
            return Idx.toString(v.idx);
        }
        return "";
    };

    // Ordering two indices of the same family. Integer indices compare
    // numerically without allocating; a formal subscript goes through the Idx
    // ladder, where any integer index sits below every non-integer one.
    Named.indexCmp = function (a, b) {
        const na = a.n;
        const nb = b.n;
        if (NAMED_has(na) && NAMED_has(nb)) {
            if (na === nb) {
                return 0;
            }
            return na < nb ? -1 : 1;
        }
        let ia = a.idx;
        let ib = b.idx;
        if (!NAMED_has(ia)) {
            if (!NAMED_has(na)) {
                return NAMED_has(ib) ? -1 : 0;
            }
            ia = Idx.fin(Impl.finite(na));
        } else if (!NAMED_has(ib) && !NAMED_has(nb)) {
            return 1;
        }
        if (!NAMED_has(ib)) {
            ib = Idx.fin(Impl.finite(nb));
        }
        return Idx.compare(ia, ib);
    };

    Named.indexEq = function (a, b) {
        if (NAMED_has(a.n) || NAMED_has(b.n)) {
            return a.n === b.n;
        }
        if (!NAMED_has(a.idx) || !NAMED_has(b.idx)) {
            return NAMED_has(a.idx) === NAMED_has(b.idx);
        }
        return Idx.compare(a.idx, b.idx) === 0;
    };

    function NAMED_bandOf(v) {
        if (NAMED_has(v.band)) {
            return v.band;
        }
        const o = Named.BASE_ORDER[v.family];
        return o === undefined ? 1000 : o;
    }

    Named.compareMag = function (a, b) {
        // Same-family comparisons are the common case; skip the band check.
        if (a.family !== b.family) {
            const oa = NAMED_bandOf(a);
            const ob = NAMED_bandOf(b);
            return oa < ob ? -1 : 1;
        }
        let c = Named.indexCmp(a, b);
        if (c !== 0) {
            return c;
        }
        c = Named.argsCmp(a, b);
        if (c !== 0) {
            return c;
        }
        if (a.p !== b.p) {
            return a.p < b.p ? -1 : 1;
        }
        if (a.coef !== b.coef) {
            return a.coef < b.coef ? -1 : 1;
        }
        if (a.off !== b.off) {
            return a.off < b.off ? -1 : 1;
        }
        return 0;
    };

    // Identity of the underlying constant, ignoring coef, power and offset:
    // TREE(3) and 5·TREE(3)^2 share the same base.
    Named.compareBase = function (a, b) {
        if (a.family !== b.family) {
            const oa = NAMED_bandOf(a);
            const ob = NAMED_bandOf(b);
            return oa < ob ? -1 : 1;
        }
        const c = Named.indexCmp(a, b);
        if (c !== 0) {
            return c;
        }
        return Named.argsCmp(a, b);
    };

    Named.magAdd = function (a, b) {
        if (a.family === b.family && a.p === b.p && Named.indexEq(a, b)
            && Named.argsEq(a, b)) {
            return Named.normalize(a.family, a.n, 1, a.p, a.coef + b.coef,
                a.off + b.off, a.idx, a.nx);
        }
        return Named.compareMag(a, b) >= 0 ? Named.copy(a) : Named.copy(b);
    };

    Named.magSub = function (a, b) {
        if (a.family === b.family && a.p === b.p && Named.indexEq(a, b)
            && Named.argsEq(a, b)) {
            const coef = a.coef - b.coef;
            const off = a.off - b.off;
            if (coef <= 0) {
                if (off <= 0) {
                    return ZERO;
                }
                return Impl.finite(off);
            }
            return Named.normalize(a.family, a.n, 1, a.p, coef, off, a.idx, a.nx);
        }
        return Named.copy(a);
    };

    Named.addValues = function (a, b) {
        if (a.sign === b.sign) {
            return Impl.signedMagnitude(a.sign, Named.magAdd(a, b));
        }
        const cmp = Named.compareMag(a, b);
        if (cmp === 0) {
            return ZERO;
        } else if (cmp > 0) {
            return Impl.signedMagnitude(a.sign, Named.magSub(a, b));
        }
        return Impl.signedMagnitude(b.sign, Named.magSub(b, a));
    };

    Named.addFinite = function (v, n) {
        const off = v.off + v.sign * n;
        if (!isfinite(off)) {
            return Named.copy(v);
        }
        return Named.normalize(v.family, v.n, v.sign, v.p, v.coef, off,
            v.idx, v.nx);
    };

    Named.mulFinite = function (v, n) {
        let sign = v.sign;
        if (n < 0) {
            sign = -sign;
            n = -n;
        }
        let coef = v.coef * n;
        if (coef > COEF_MAX) {
            coef = COEF_MAX;
        }
        let off = v.off * n;
        if (!isfinite(off)) {
            off = 0;
        }
        return Named.normalize(v.family, v.n, sign, v.p, coef, off, v.idx, v.nx);
    };

    Named.mul = function (a, b) {
        const sign = a.sign * b.sign;
        if (a.family === b.family && Named.indexEq(a, b) && Named.argsEq(a, b)) {
            return Named.normalize(a.family, a.n, sign, a.p + b.p,
                a.coef * b.coef, 0, a.idx, a.nx);
        }
        const big = Named.compareMag(a, b) >= 0 ? a : b;
        return Named.withSign(big, sign);
    };

    Named.div = function (a, b) {
        const sign = a.sign * b.sign;
        if (a.family === b.family && Named.indexEq(a, b) && Named.argsEq(a, b)) {
            const pow = a.p - b.p;
            if (pow > 0) {
                return Named.normalize(a.family, a.n, sign, pow, a.coef / b.coef,
                    0, a.idx, a.nx);
            } else if (pow === 0) {
                const q = a.coef / b.coef;
                if (!isfinite(q)) {
                    return sign > 0 ? CAP : NEG_CAP;
                }
                return Impl.finite(sign * q);
            }
            return ZERO;
        }
        const cmp = Named.compareMag(a, b);
        if (cmp === 0) {
            return ONE;
        } else if (cmp > 0) {
            return Named.withSign(a, sign);
        }
        return ZERO;
    };

    Named.pow = function (v, exponent) {
        if (exponent === 1) {
            return Named.copy(v);
        }
        const pow = v.p * exponent;
        let coef = Math.pow(v.coef, exponent);
        if (!isfinite(pow) || pow <= 0 || !isfinite(coef) || coef <= 0) {
            if (isnan(coef) || pow === 0) {
                return NAN;
            }
            return v.sign > 0 ? CAP : NEG_CAP;
        }
        if (coef > COEF_MAX) {
            coef = COEF_MAX;
        }
        return Named.normalize(v.family, v.n, v.sign, pow, coef, 0, v.idx, v.nx);
    };

    Named.numberText = function (n) {
        if (n === numfloor(n) && Math.abs(n) < 1e15) {
            return formatFixed(n, 0);
        }
        let s = formatG(n, 15);
        if (tonumber(s) !== n) {
            s = formatG(n, 17);
        }
        return s;
    };

    Named.format = function (v) {
        let base = Named.baseName(v);
        if (v.p !== 1) {
            base = base + "^" + Named.numberText(v.p);
        }
        let body = v.coef !== 1 ? Named.numberText(v.coef) + "·" + base : base;
        if (v.off > 0) {
            body = body + "+" + Named.numberText(v.off);
        } else if (v.off < 0) {
            body = body + "-" + Named.numberText(-v.off);
        }
        if (v.sign < 0) {
            if (v.coef === 1 && v.p === 1 && v.off === 0) {
                return "-" + body;
            }
            return "-(" + body + ")";
        }
        return body;
    };

    // "prefix(index)" spellings and the smallest index each one accepts. The
    // index may itself carry parentheses (TREE(TREE(3))), so the matching
    // close paren is found by scanning instead of by a pattern.
    const NAMED_CALL_FAMILY = nilMap();
    NAMED_CALL_FAMILY.tree = ["TREE", 1];
    NAMED_CALL_FAMILY.sscg = ["SSCG", 0];
    NAMED_CALL_FAMILY.bb = ["BB", 0];
    NAMED_CALL_FAMILY.busybeaver = ["BB", 0];
    NAMED_CALL_FAMILY.loader = ["LOADER", 0];
    NAMED_CALL_FAMILY.rayo = ["RAYO", RAYO_INDEX];
    NAMED_CALL_FAMILY.fish = ["FISH7", 7];

    // Returns [head, inner] only when the whole spelling is one balanced call.
    function NAMED_splitCall(name) {
        if (name.slice(-1) !== ")") {
            return null;
        }
        const open = name.indexOf("(");
        if (open === -1) {
            return null;
        }
        let depth = 0;
        for (let i = open; i < name.length; i++) {
            const c = name.charAt(i);
            if (c === "(") {
                depth = depth + 1;
            } else if (c === ")") {
                depth = depth - 1;
                if (depth === 0) {
                    if (i !== name.length - 1) {
                        return null;
                    }
                    return [name.slice(0, open), name.slice(open + 1, i)];
                }
            }
        }
        return null;
    }

    // Exposed so a registered family can add its own call spelling, and so the
    // Ackermann parser can reuse the balanced-paren scan.
    Named.CALL = NAMED_CALL_FAMILY;
    Named.splitCall = NAMED_splitCall;

    // Resolve an index spelling: a plain integer stays numeric, anything else
    // becomes a formal subscript. Returns [family, n, null, null] or
    // [family, null, idx, null], or null when the spelling is rejected.
    function NAMED_resolveIndex(family, lo, text, depth) {
        let n = tonumberNil(text);
        if (n === undefined) {
            const idx = Idx.fromToken(text, NAMED_has(depth) ? depth : 0);
            if (idx === null) {
                return null;
            }
            if (idx.cls === "fin" && idx.v.kind === "finite") {
                n = idx.v.n;
            } else {
                return [family, null, idx, null];
            }
        }
        if (!isfinite(n) || n !== numfloor(n) || n < lo) {
            return null;
        }
        return [family, n, null, null];
    }

    // "F(a,b,...)" for a family declared with several parameters. Every
    // argument after the first is a full value, so a multi-parameter family
    // reaches the same scales the single-index ones do.
    function NAMED_resolveArgs(call, inner, depth) {
        const family = call[0];
        const spec = Named.SPEC[family];
        const want = spec !== undefined ? (spec.params || 1) : 1;
        const parts = Hyper.splitArgs(inner);
        if (parts === null || parts.length !== want) {
            return null;
        }
        const head = NAMED_resolveIndex(family, call[1], parts[0], depth);
        if (head === null) {
            return null;
        }
        let nx = null;
        if (want > 1) {
            nx = [];
            const d = (NAMED_has(depth) ? depth : 0) + 1;
            for (let i = 1; i < want; i++) {
                const v = Impl.parseString(parts[i], d);
                if (v.kind === "nan") {
                    return null;
                }
                nx.push(v);
            }
        }
        return [head[0], head[1], head[2], nx];
    }

    Named.parseBase = function (name, depth) {
        const alias = Named.ALIASES[name];
        if (alias !== undefined) {
            return [alias[0], alias[1], null, null];
        }
        if (name === "d(99)") {
            return ["LOADER", 1, null, null];
        }
        const call2 = NAMED_splitCall(name);
        if (call2 !== null) {
            const head = call2[0];
            const inner = call2[1];
            const call = Named.CALL[head];
            if (call !== undefined && inner !== "") {
                const spec = Named.SPEC[call[0]];
                if (spec !== undefined && (spec.params || 1) > 1) {
                    return NAMED_resolveArgs(call, inner, depth);
                }
                if (call[0] === "RAYO" && tonumberNil(inner) === undefined) {
                    // Accept the canonical spelling rayo(10^100).
                    const pm = /^([0-9.]+)\^([0-9.]+)$/.exec(inner);
                    const p = pm !== null && tonumber(pm[1]) === 10
                        ? tonumber(pm[2]) : NaN;
                    if (isfinite(p)) {
                        const n = Math.pow(10, p);
                        if (isfinite(n) && n === numfloor(n) && n >= RAYO_INDEX) {
                            return ["RAYO", n, null, null];
                        }
                    }
                }
                return NAMED_resolveIndex(call[0], call[1], inner, depth);
            }
        }
        // D^k(99) and Dk(99): k may be any index spelling, so it is scanned
        // rather than matched, and the "(99)" seed is what the closing paren
        // belongs to.
        if (name.charAt(0) === "d" && name.slice(-4) === "(99)") {
            let k = name.slice(1, -4);
            if (k.charAt(0) === "^") {
                k = k.slice(1);
            }
            if (k !== "") {
                return NAMED_resolveIndex("LOADER", 0, k, depth);
            }
        }
        const lidx = match1(name, /^loader([0-9eE+-.]+)$/);
        if (lidx !== null) {
            const n = tonumber(lidx);
            if (!isfinite(n) || n !== numfloor(n) || n < 0) {
                return null;
            }
            return ["LOADER", n, null, null];
        }
        const bidx = firstMatch(name,
            [/^bb([0-9eE+-.]+)$/, /^busybeaver([0-9eE+-.]+)$/]);
        if (bidx !== null) {
            const n = tonumber(bidx);
            if (!isfinite(n) || n !== numfloor(n) || n < 0) {
                return null;
            }
            return ["BB", n, null, null];
        }
        const tidx = match1(name, /^tree([0-9eE+-.]+)$/);
        if (tidx !== null) {
            const n = tonumber(tidx);
            if (!isfinite(n) || n !== numfloor(n) || n < 1) {
                return null;
            }
            return ["TREE", n, null, null];
        }
        const sidx = match1(name, /^sscg([0-9eE+-.]+)$/);
        if (sidx !== null) {
            const n = tonumber(sidx);
            if (!isfinite(n) || n !== numfloor(n) || n < 0) {
                return null;
            }
            return ["SSCG", n, null, null];
        }
        return null;
    };

    function match1(s, re) {
        const m = re.exec(s);
        return m === null ? null : m[1];
    }

    Named.parse = function (s, pd) {
        if (typeof s !== "string") {
            return null;
        }
        let t = stripSpace(lowerText(s));
        t = t.split("·").join("*");
        if (t === "") {
            return null;
        }
        let sign = 1;
        if (t.charAt(0) === "+") {
            t = t.slice(1);
        } else if (t.charAt(0) === "-") {
            sign = -1;
            t = t.slice(1);
        }
        if (t.charAt(0) === "(" && t.charAt(t.length - 1) === ")") {
            t = t.slice(1, -1);
        }
        let depth = 0;
        let cut = -1;
        for (let i = 0; i < t.length; i++) {
            const c = t.charAt(i);
            if (c === "(") {
                depth = depth + 1;
            } else if (c === ")") {
                depth = depth - 1;
                if (depth < 0) {
                    return null;
                }
            } else if (depth === 0 && (c === "+" || c === "-") && i > 0
                && t.charAt(i - 1) !== "e") {
                cut = i;
            }
        }
        if (depth !== 0) {
            return null;
        }
        let off = 0;
        if (cut >= 0) {
            off = tonumber(t.slice(cut));
            if (!isfinite(off)) {
                return null;
            }
            t = t.slice(0, cut);
        }
        let coef = 1;
        const star = t.indexOf("*");
        if (star >= 0) {
            coef = tonumber(t.slice(0, star));
            if (!isfinite(coef) || coef <= 0) {
                return null;
            }
            t = t.slice(star + 1);
        }
        let pow = 1;
        const pw = /^([\s\S]*?)\^([0-9eE+-.]+)$/.exec(t);
        if (pw !== null) {
            pow = tonumber(pw[2]);
            if (!isfinite(pow) || pow <= 0) {
                return null;
            }
            t = pw[1];
        }
        const parsed = Named.parseBase(t, pd);
        if (parsed === null) {
            return null;
        }
        const family = parsed[0];
        const n = parsed[1];
        const nidx = parsed[2];
        const nx = parsed[3];
        if (!NAMED_has(nidx) && !NAMED_has(nx)) {
            if (family === "TREE" && n < 3) {
                // Friedman's small cases: TREE(1) = 1, TREE(2) = 3.
                if (coef !== 1 || pow !== 1 || off !== 0) {
                    return null;
                }
                const small = n === 1 ? ONE : Impl.finite(3);
                return sign < 0 ? Impl.negate(small) : Impl.copy(small);
            }
            if (family === "SSCG" && n < 3) {
                // SSCG(0) = 2, SSCG(1) = 5, SSCG(2) is a finite tower.
                if (coef !== 1 || pow !== 1 || off !== 0) {
                    return null;
                }
                const small = Impl.sscgValue(Impl.finite(n));
                return sign < 0 ? Impl.negate(small) : Impl.copy(small);
            }
            if (family === "LOADER" && n === 0) {
                // D^0(99) is zero iterations of D: the seed itself.
                if (coef !== 1 || pow !== 1 || off !== 0) {
                    return null;
                }
                return Impl.finite(sign * 99);
            }
            if (family === "BB" && n < 6) {
                // Rado's known cases: BB(0..5) = 0, 1, 4, 6, 13, 4098.
                if (coef !== 1 || pow !== 1 || off !== 0) {
                    return null;
                }
                const small = Impl.bbValue(Impl.finite(n));
                return sign < 0 ? Impl.negate(small) : Impl.copy(small);
            }
        }
        return Named.new(family, NAMED_has(nidx) ? nidx : n, sign, pow, coef, off, nx);
    };

    // Finite hyperoperation band --------------------------------------------
    // Hyperoperations above tetration outgrow doubles and compact towers long
    // before they stop being finite integers, so they must not turn into
    // LIMIT or into infinite-rank towers. Levels 3+ keep a structural finite
    // value H(level, base, arg) shaped like a named magnitude:
    // coef * H^p + off. Without a named operand the band sits above every
    // finite-rank tower and below every named-mega value; ordering inside it
    // is level, then base, then arg, then power/coefficient/offset. With a
    // named operand the value is anchored inside that constant's band (above
    // the plain constant, below the next index/family), because a
    // hyperoperation on a named integer is still far below the next named
    // giant. As with the TREE/SSCG/BB bands, the ordering is a modelling
    // convention, not a proof about arbitrary hyperoperations.

    Hyper = {};

    const HYPER_COEF_MAX = 1e308;

    // Hyper operands must be non-negative finite-tier values: a double,
    // another hyper value, a positive finite-rank tower, or a positive named
    // constant. Infinite-rank towers and LIMIT already sit above the model
    // and saturate.
    Hyper.eligible = function (v) {
        if (v === null || typeof v !== "object") {
            return false;
        }
        if (v.kind === "finite") {
            return Impl.signOf(v) >= 0;
        } else if (v.kind === "hyper") {
            return v.sign > 0;
        } else if (v.kind === "named") {
            return v.sign > 0;
        } else if (v.kind === "tower") {
            return v.sign > 0 && Rank.isFinite(v.rank);
        }
        return false;
    };

    // Greatest named constant mentioned in a hyper expression, or null when
    // the value is a plain finite-tier H(...). The anchor decides which named
    // band the value belongs to.
    Hyper.anchorOf = function (v) {
        if (v === null || typeof v !== "object") {
            return null;
        }
        if (v.kind === "named") {
            return v.sign > 0 ? v : null;
        }
        if (v.kind !== "hyper") {
            return null;
        }
        const a = Hyper.anchorOf(v.base);
        const b = Hyper.anchorOf(v.arg);
        if (a === null) {
            return b;
        } else if (b === null) {
            return a;
        }
        return Named.compareBase(a, b) >= 0 ? a : b;
    };

    Hyper.copy = (v) => Impl.newValue({
        kind: "hyper",
        sign: v.sign,
        level: v.level,
        base: Impl.copy(v.base),
        arg: Impl.copy(v.arg),
        p: v.p,
        coef: v.coef,
        off: v.off,
    });

    Hyper.withSign = function (v, sign) {
        const out = Hyper.copy(v);
        out.sign = sign < 0 ? -1 : 1;
        return out;
    };

    Hyper.normalize = function (level, base, arg, sign, pow, coef, off) {
        sign = sign < 0 ? -1 : 1;
        if (isnan(coef) || isnan(pow) || isnan(off)) {
            return NAN;
        }
        if (!isfinite(pow) || pow <= 0) {
            return sign > 0 ? CAP : NEG_CAP;
        }
        if (!isfinite(coef) || coef <= 0) {
            if (coef === 0) {
                if (!isfinite(off) || off === 0) {
                    return ZERO;
                }
                return Impl.finite(sign * off);
            }
            return sign > 0 ? CAP : NEG_CAP;
        }
        if (coef > HYPER_COEF_MAX) {
            coef = HYPER_COEF_MAX;
        }
        if (!isfinite(off)) {
            off = 0;
        }
        return Impl.newValue({
            kind: "hyper",
            sign,
            level,
            base,
            arg,
            p: pow,
            coef,
            off,
        });
    };

    Hyper.new = function (level, base, arg, sign, pow, coef, off) {
        level = tonumberNil(level);
        if (level === undefined || !isfinite(level) || level !== Math.floor(level) || level < 3) {
            return NAN;
        }
        if (!Impl.isZuba(base) || !Impl.isZuba(arg)) {
            return NAN;
        }
        if (!Hyper.eligible(base) || !Hyper.eligible(arg)) {
            return NAN;
        }
        sign = orDefault(tonumberNil(sign), 1);
        pow = orDefault(tonumberNil(pow), 1);
        coef = orDefault(tonumberNil(coef), 1);
        off = orDefault(tonumberNil(off), 0);
        if (!isfinite(pow) || pow <= 0 || !isfinite(coef) || coef <= 0
            || !isfinite(off)) {
            return NAN;
        }
        return Hyper.normalize(level, Impl.copy(base), Impl.copy(arg), sign, pow, coef, off);
    };

    Hyper.sameStruct = function (a, b) {
        if (a.level !== b.level) {
            return false;
        }
        return Impl.compare(a.base, b.base) === 0 && Impl.compare(a.arg, b.arg) === 0;
    };

    // True when target is a proper base/arg subexpression of v.
    function hyperContains(v, target) {
        if (v === null || typeof v !== "object" || v.kind !== "hyper") {
            return false;
        }
        if (Impl.compare(v.base, target) === 0 || Impl.compare(v.arg, target) === 0) {
            return true;
        }
        return hyperContains(v.base, target) || hyperContains(v.arg, target);
    }

    // Applying a hyperoperation with base > 1 to target as its argument grows
    // past target (2^X > X, c^c > c, exp of a hyper value above it). A target
    // inside the base only counts for counts above 1: sqrt(X) is smaller.
    function hyperGrowsAbove(v, target) {
        if (v.base.kind === "finite") {
            if (v.base.n <= 1) {
                return false;
            }
        } else if (Impl.signOf(v.base) <= 0) {
            return false;
        }
        if (Impl.compare(v.arg, target) === 0 || hyperContains(v.arg, target)) {
            return true;
        }
        if (Impl.compare(v.base, target) === 0 || hyperContains(v.base, target)) {
            return v.arg.kind !== "finite" || v.arg.n > 1;
        }
        return false;
    }

    Hyper.compareMag = function (a, b) {
        // A named anchor outranks the structural order: everything anchored
        // on TREE(3) is below everything anchored on TREE(4), whatever the
        // levels.
        const aa = Hyper.anchorOf(a);
        const ab = Hyper.anchorOf(b);
        if (aa !== null || ab !== null) {
            if (aa === null) {
                return -1;
            } else if (ab === null) {
                return 1;
            }
            const ac = Named.compareMag(aa, ab);
            if (ac !== 0) {
                return ac;
            }
        }
        // A value fed into another hyperoperation outranks its own argument:
        // exp(centation) is above the centation it exponentiates.
        if (hyperGrowsAbove(a, b)) {
            return 1;
        } else if (hyperGrowsAbove(b, a)) {
            return -1;
        }
        // Higher hyper levels dominate: centation beats any fixed power or
        // power tower of the same constant.
        if (a.level !== b.level) {
            return a.level < b.level ? -1 : 1;
        }
        // At one level a constant in the argument grows with the constant
        // itself (2^c, c^c), so it outranks a fixed power of it (c^k) whose
        // argument is still a plain count.
        const abase = Hyper.anchorOf(a.base);
        const bbase = Hyper.anchorOf(b.base);
        const aarg = Hyper.anchorOf(a.arg);
        const barg = Hyper.anchorOf(b.arg);
        if (aarg !== null && barg === null && bbase !== null) {
            return 1;
        } else if (barg !== null && aarg === null && abase !== null) {
            return -1;
        }
        let c = Impl.compare(a.base, b.base);
        if (c !== 0) {
            return c;
        }
        c = Impl.compare(a.arg, b.arg);
        if (c !== 0) {
            return c;
        }
        if (a.p !== b.p) {
            return a.p < b.p ? -1 : 1;
        }
        if (a.coef !== b.coef) {
            return a.coef < b.coef ? -1 : 1;
        }
        if (a.off !== b.off) {
            return a.off < b.off ? -1 : 1;
        }
        return 0;
    };

    Hyper.magAdd = function (a, b) {
        if (Hyper.sameStruct(a, b)) {
            return Hyper.normalize(a.level, Impl.copy(a.base), Impl.copy(a.arg), 1,
                a.p, a.coef + b.coef, a.off + b.off);
        }
        return Hyper.compareMag(a, b) >= 0 ? Hyper.copy(a) : Hyper.copy(b);
    };

    Hyper.magSub = function (a, b) {
        if (Hyper.sameStruct(a, b)) {
            const coef = a.coef - b.coef;
            const off = a.off - b.off;
            if (coef <= 0) {
                if (off <= 0) {
                    return ZERO;
                }
                return Impl.finite(off);
            }
            return Hyper.normalize(a.level, Impl.copy(a.base), Impl.copy(a.arg), 1,
                a.p, coef, off);
        }
        return Hyper.copy(a);
    };

    Hyper.addValues = function (a, b) {
        if (a.sign === b.sign) {
            return Impl.signedMagnitude(a.sign, Hyper.magAdd(a, b));
        }
        const cmp = Hyper.compareMag(a, b);
        if (cmp === 0) {
            return ZERO;
        } else if (cmp > 0) {
            return Impl.signedMagnitude(a.sign, Hyper.magSub(a, b));
        }
        return Impl.signedMagnitude(b.sign, Hyper.magSub(b, a));
    };

    Hyper.addFinite = function (v, n) {
        const off = v.off + v.sign * n;
        if (!isfinite(off)) {
            return Hyper.copy(v);
        }
        return Hyper.normalize(v.level, Impl.copy(v.base), Impl.copy(v.arg), v.sign,
            v.p, v.coef, off);
    };

    Hyper.mulFinite = function (v, n) {
        let sign = v.sign;
        if (n < 0) {
            sign = -sign;
            n = -n;
        }
        let coef = v.coef * n;
        if (coef > HYPER_COEF_MAX) {
            coef = HYPER_COEF_MAX;
        }
        let off = v.off * n;
        if (!isfinite(off)) {
            off = 0;
        }
        return Hyper.normalize(v.level, Impl.copy(v.base), Impl.copy(v.arg), sign,
            v.p, coef, off);
    };

    Hyper.mul = function (a, b) {
        const sign = a.sign * b.sign;
        if (Hyper.sameStruct(a, b)) {
            return Hyper.normalize(a.level, Impl.copy(a.base), Impl.copy(a.arg), sign,
                a.p + b.p, a.coef * b.coef, 0);
        }
        const big = Hyper.compareMag(a, b) >= 0 ? a : b;
        return Hyper.withSign(big, sign);
    };

    Hyper.div = function (a, b) {
        const sign = a.sign * b.sign;
        if (Hyper.sameStruct(a, b)) {
            const pow = a.p - b.p;
            if (pow > 0) {
                return Hyper.normalize(a.level, Impl.copy(a.base), Impl.copy(a.arg), sign,
                    pow, a.coef / b.coef, 0);
            } else if (pow === 0) {
                const q = a.coef / b.coef;
                if (!isfinite(q)) {
                    return sign > 0 ? CAP : NEG_CAP;
                }
                return Impl.finite(sign * q);
            }
            return ZERO;
        }
        const cmp = Hyper.compareMag(a, b);
        if (cmp === 0) {
            return ONE;
        } else if (cmp > 0) {
            return Hyper.withSign(a, sign);
        }
        return ZERO;
    };

    Hyper.pow = function (v, exponent) {
        if (exponent === 1) {
            return Hyper.copy(v);
        }
        const pow = v.p * exponent;
        let coef = Math.pow(v.coef, exponent);
        if (!isfinite(pow) || pow <= 0 || !isfinite(coef) || coef <= 0) {
            if (isnan(coef) || pow === 0) {
                return NAN;
            }
            return v.sign > 0 ? CAP : NEG_CAP;
        }
        if (coef > HYPER_COEF_MAX) {
            coef = HYPER_COEF_MAX;
        }
        return Hyper.normalize(v.level, Impl.copy(v.base), Impl.copy(v.arg), v.sign,
            pow, coef, 0);
    };

    Hyper.format = function (v) {
        // exp() results anchor on Euler's number; print it exactly so the
        // decimal rounding of the double cannot break a string roundtrip.
        let baseText;
        if (v.base.kind === "finite" && v.base.n === E_CONST) {
            baseText = "e";
        } else {
            baseText = Impl.format(v.base);
        }
        let base = "H(" + Named.numberText(v.level) + ", "
            + baseText + ", " + Impl.format(v.arg) + ")";
        if (v.p !== 1) {
            base = base + "^" + Named.numberText(v.p);
        }
        let body = v.coef !== 1 ? Named.numberText(v.coef) + "·" + base : base;
        if (v.off > 0) {
            body = body + "+" + Named.numberText(v.off);
        } else if (v.off < 0) {
            body = body + "-" + Named.numberText(-v.off);
        }
        if (v.sign < 0) {
            if (v.coef === 1 && v.p === 1 && v.off === 0) {
                return "-" + body;
            }
            return "-(" + body + ")";
        }
        return body;
    };

    // Splits "100, 4, 2" on top-level commas; returns null on unbalanced parens.
    Hyper.splitArgs = function (s) {
        let depth = 0;
        let start = 0;
        const out = [];
        for (let i = 0; i < s.length; i++) {
            const c = s.charAt(i);
            if (c === "(") {
                depth = depth + 1;
            } else if (c === ")") {
                depth = depth - 1;
                if (depth < 0) {
                    return null;
                }
            } else if (c === "," && depth === 0) {
                out.push(s.slice(start, i));
                start = i + 1;
            }
        }
        if (depth !== 0) {
            return null;
        }
        out.push(s.slice(start));
        return out;
    };

    Hyper.parse = function (s) {
        if (typeof s !== "string") {
            return null;
        }
        let t = stripSpace(s.toLowerCase());
        t = t.split("·").join("*");
        if (t === "") {
            return null;
        }
        let sign = 1;
        if (t.charAt(0) === "+") {
            t = t.slice(1);
        } else if (t.charAt(0) === "-") {
            sign = -1;
            t = t.slice(1);
        }
        if (t.charAt(0) === "(" && t.charAt(t.length - 1) === ")") {
            t = t.slice(1, -1);
        }
        let depth = 0;
        let cut = -1;
        for (let i = 0; i < t.length; i++) {
            const c = t.charAt(i);
            if (c === "(") {
                depth = depth + 1;
            } else if (c === ")") {
                depth = depth - 1;
                if (depth < 0) {
                    return null;
                }
            } else if (depth === 0 && (c === "+" || c === "-") && i > 0
                && t.charAt(i - 1) !== "e") {
                cut = i;
            }
        }
        if (depth !== 0) {
            return null;
        }
        let off = 0;
        if (cut >= 0) {
            off = tonumber(t.slice(cut));
            if (!isfinite(off)) {
                return null;
            }
            t = t.slice(0, cut);
        }
        let coef = 1;
        const star = t.indexOf("*");
        if (star >= 0) {
            coef = tonumber(t.slice(0, star));
            if (!isfinite(coef) || coef <= 0) {
                return null;
            }
            t = t.slice(star + 1);
        }
        let pow = 1;
        const pw = /^([\s\S]*?)\^([0-9+.deE-]+)$/.exec(t);
        if (pw !== null) {
            pow = tonumber(pw[2]);
            if (!isfinite(pow) || pow <= 0) {
                return null;
            }
            t = pw[1];
        }
        if (t.charAt(0) !== "h" || t.charAt(1) !== "(" || t.charAt(t.length - 1) !== ")") {
            return null;
        }
        const args = Hyper.splitArgs(t.slice(2, -1));
        if (args === null || args.length !== 3) {
            return null;
        }
        const level = tonumber(args[0]);
        if (!isfinite(level) || level !== Math.floor(level) || level < 3) {
            return null;
        }
        const baseV = Impl.parseString(args[1]);
        const argV = Impl.parseString(args[2]);
        if (baseV.kind === "nan" || argV.kind === "nan") {
            return null;
        }
        const out = Hyper.new(level, baseV, argV, sign, pow, coef, off);
        if (out.kind === "nan") {
            return null;
        }
        return out;
    };

    // Cardinals, fixed points and the fast-growing hierarchy ----------------
    // The infinite tier. A card value is an initial ordinal: aleph_alpha,
    // beth_alpha, or the n-th fixed point of one of those ladders. Every other
    // value models a finite integer, so it is always a *finite* subscript:
    // aleph(rayo(1e100)) stays below aleph(omega) because Rayo's number, huge
    // as it is, is still a natural number.
    //
    // Index classes, in increasing order:
    //   fin  - finite ordinal: doubles, hyper band values and named-mega values
    //   ord  - countable ordinal from the rank fragment (omega ... WC)
    //   card - a cardinal used as a subscript, e.g. aleph(aleph(1))
    //   fp   - fixed point of the aleph or beth ladder
    // fin < ord because every finite value is below every infinite ordinal, and
    // ord < card because every rank in the fragment is countable, hence below
    // the first uncountable cardinal. A fixed point closes the ladder below it,
    // so it sits above every index drawn from that ladder.
    //
    // f_0(n) = n + 1, f_1(n) = 2n, f_2(n) = n * 2^n and f_{a+1}(n) = f_a^(n+1)(n).
    // A finite level expands into the hyper band this library already models, so
    // only transfinite levels stay formal: f_alpha(n) with an ordinal index is
    // ordered inside tier 3 by that index.

    Idx = {};

    const IDX_CLASS = nilMap();
    IDX_CLASS.fin = 1;
    IDX_CLASS.ord = 2;
    IDX_CLASS.card = 3;
    IDX_CLASS.fp = 4;

    const ALEPH_GLYPH = "ℵ";
    const BETH_GLYPH = "ℶ";
    const SUBSCRIPT_DIGITS = "₀₁₂₃₄₅₆₇₈₉";

    Idx.opGlyph = (op) => (op === "beth" ? BETH_GLYPH : ALEPH_GLYPH);

    Idx.fin = (v) => ({ cls: "fin", v: Impl.magnitude(v) });

    Idx.ord = (r) => ({ cls: "ord", rank: Rank.copy(r) });

    Idx.cardOf = (op, inner) => ({ cls: "card", op, idx: inner });

    Idx.fpOf = (op, inner) => ({ cls: "fp", op, idx: inner });

    // A cardinal subscript is an ordinal, not a tower height, so it is not
    // capped by the ranking ceiling: aleph_(LVO+1) is legal even though no
    // tower rises that far.
    Idx.fromRank = function (r) {
        if (r === null || r === undefined) {
            return null;
        }
        if (Rank.isFinite(r)) {
            return Idx.fin(Impl.finite(Rank.finiteValue(r)));
        }
        return Idx.ord(r);
    };

    Idx.copy = function (i) {
        if (i.cls === "fin") {
            return { cls: "fin", v: Impl.copy(i.v) };
        } else if (i.cls === "ord") {
            return { cls: "ord", rank: Rank.copy(i.rank) };
        }
        return { cls: i.cls, op: i.op, idx: Idx.copy(i.idx) };
    };

    Idx.isZero = (i) => i.cls === "fin" && Impl.isZero(i.v);

    // Reading a value as an ordinal subscript. Everything finite stays a finite
    // index; an infinite-rank tower contributes its rank, which is exactly the
    // ordinal this library can name; cardinals become cardinal indices.
    Idx.fromValue = function (v) {
        if (!Impl.isZuba(v) || v.kind === "nan" || v.kind === "cap") {
            return null;
        }
        if (Impl.signOf(v) < 0) {
            return null;
        }
        if (v.kind === "card") {
            if (v.mode === "fp") {
                return Idx.fpOf(v.op, v.idx);
            }
            return Idx.cardOf(v.op, v.idx);
        } else if (v.kind === "fgh") {
            if (v.idx.cls !== "ord") {
                return null;
            }
            return Idx.ord(v.idx.rank);
        } else if (v.kind === "tower") {
            if (Rank.isFinite(v.rank)) {
                return Idx.fin(v);
            }
            return Idx.ord(v.rank);
        }
        return Idx.fin(v);
    };

    Idx.compare = function (a, b) {
        const ca = IDX_CLASS[a.cls];
        const cb = IDX_CLASS[b.cls];
        if (ca !== cb) {
            return ca < cb ? -1 : 1;
        }
        if (a.cls === "fin") {
            return Impl.cmpPositive(a.v, b.v);
        } else if (a.cls === "ord") {
            return Rank.compare(a.rank, b.rank);
        }
        const c = Idx.compare(a.idx, b.idx);
        if (c !== 0) {
            return c;
        }
        if (a.op === b.op) {
            return 0;
        }
        // Inside a subscript the model keeps the two ladders interleaved with
        // aleph below beth, matching aleph_alpha <= beth_alpha.
        return a.op === "aleph" ? -1 : 1;
    };

    Idx.compareLadder = function (opA, modeA, idxA, opB, modeB, idxB) {
        // Same ordering as comparing cardOf/fpOf wrappers, without building them.
        const ca = IDX_CLASS[modeA === "fp" ? "fp" : "card"];
        const cb = IDX_CLASS[modeB === "fp" ? "fp" : "card"];
        if (ca !== cb) {
            return ca < cb ? -1 : 1;
        }
        const c = Idx.compare(idxA, idxB);
        if (c !== 0) {
            return c;
        }
        if (opA === opB) {
            return 0;
        }
        return opA === "aleph" ? -1 : 1;
    };

    Idx.succ = function (i) {
        if (i.cls === "fin") {
            return Idx.fin(Impl.addValues(i.v, ONE));
        } else if (i.cls === "ord") {
            return Idx.ord(Rank.succ(i.rank));
        }
        const inner = Idx.succ(i.idx);
        if (inner === null) {
            return null;
        }
        return { cls: i.cls, op: i.op, idx: inner };
    };

    Idx.subText = function (i) {
        if (i.cls !== "fin") {
            return null;
        }
        const v = i.v;
        if (v.kind !== "finite" || v.n < 0 || v.n > 999 || v.n !== Math.floor(v.n)) {
            return null;
        }
        const digits = toStr(Math.floor(v.n));
        let out = "";
        for (let k = 0; k < digits.length; k++) {
            const d = tonumber(digits.charAt(k));
            if (isnan(d)) {
                return null;
            }
            out = out + SUBSCRIPT_DIGITS.charAt(d);
        }
        return out;
    };

    Idx.toString = function (i) {
        if (i.cls === "fin") {
            const sub = Idx.subText(i);
            if (sub !== null) {
                return sub;
            }
            return Impl.format(i.v);
        } else if (i.cls === "ord") {
            return Rank.toString(i.rank);
        } else if (i.cls === "card") {
            return Idx.opGlyph(i.op) + Idx.tail(i.idx);
        }
        return Idx.opGlyph(i.op) + "*" + Idx.tail(i.idx);
    };

    // Text that follows a glyph: subscript digits for small finite indices, an
    // underscore plus rank for ordinals, parentheses for structured ones.
    Idx.tail = function (i) {
        const sub = Idx.subText(i);
        if (sub !== null) {
            return sub;
        }
        if (i.cls === "ord") {
            return "_" + Rank.toString(i.rank);
        }
        return "(" + Idx.toString(i) + ")";
    };

    Idx.toTable = function (i) {
        if (i.cls === "fin") {
            return { cls: "fin", v: Impl.toTable(i.v) };
        } else if (i.cls === "ord") {
            return { cls: "ord", rank: Rank.toTable(i.rank) };
        }
        return { cls: i.cls, op: i.op, idx: Idx.toTable(i.idx) };
    };

    Idx.fromTable = function (t) {
        if (t === null || typeof t !== "object") {
            return null;
        }
        if (t.cls === "fin") {
            const v = Impl.fromTable(t.v);
            if (v.kind === "nan" || Impl.signOf(v) < 0) {
                return null;
            }
            return Idx.fin(v);
        } else if (t.cls === "ord") {
            const r = Rank.fromTable(t.rank);
            if (r === null) {
                return null;
            }
            return Idx.ord(r);
        } else if (t.cls === "card" || t.cls === "fp") {
            if (t.op !== "aleph" && t.op !== "beth") {
                return null;
            }
            const inner = Idx.fromTable(t.idx);
            if (inner === null) {
                return null;
            }
            return { cls: t.cls, op: t.op, idx: inner };
        }
        return null;
    };

    // Reading an index from a spelling: rank atoms first (omega, eps0, "1+1"),
    // then any ordinary numeric or named value as a finite subscript.
    Idx.fromToken = function (tok, depth) {
        if (tok === undefined || tok === null || tok === "") {
            return Idx.fin(ZERO);
        }
        // A pure numeric spelling is always a value subscript: rank parsing
        // would swallow "1e3003" as a finite rank and clamp its out-of-range
        // mantissa to 0.
        let r = null;
        if (isnan(tonumber(tok))) {
            r = Impl.parseRankString(tok);
        }
        if (r !== null) {
            return Idx.fromRank(r);
        }
        const v = Impl.parseString(tok, depth + 1);
        if (v.kind === "nan") {
            return null;
        }
        return Idx.fromValue(v);
    };

    // Reading an index from a call argument: rank tables and rank spellings
    // give an ordinal index, anything else is read as a value and classified.
    Idx.fromArg = function (x) {
        if (x === undefined || x === null) {
            return Idx.fin(ZERO);
        }
        if (typeof x === "object" && !Impl.isZuba(x)) {
            return Idx.fromRank(Impl.rankFromAny(x));
        }
        if (typeof x === "string") {
            const r = Impl.rankFromAny(x);
            if (r !== null && !Rank.isFinite(r)) {
                return Idx.ord(r);
            }
        }
        const v = Impl.asValue(x);
        if (v.kind === "nan") {
            return null;
        }
        return Idx.fromValue(v);
    };

    Card = {};

    Card.copy = (v) => Impl.newValue({
        kind: "card",
        sign: v.sign,
        op: v.op,
        mode: v.mode,
        idx: Idx.copy(v.idx),
    });

    Card.withSign = function (v, sign) {
        // The magnitude helpers collapse to ordinary values (0, 1, the
        // ceiling), so only a real cardinal is copied and re-signed.
        if (v.kind !== "card") {
            if (v.kind === "cap") {
                return sign < 0 ? NEG_CAP : CAP;
            }
            return v;
        }
        const out = Card.copy(v);
        out.sign = sign < 0 ? -1 : 1;
        return out;
    };

    // aleph_alpha / beth_alpha. aleph applied to a fixed point of the same
    // ladder is that fixed point, so the two spellings collapse to one value.
    Card.plain = function (op, idx, sign) {
        if (idx === null || idx === undefined || (op !== "aleph" && op !== "beth")) {
            return NAN;
        }
        sign = orDefault(tonumberNil(sign), 1) < 0 ? -1 : 1;
        if (idx.cls === "fp" && idx.op === op) {
            return Card.fixed(op, idx.idx, sign);
        }
        return Impl.newValue({
            kind: "card",
            sign,
            op,
            mode: "plain",
            idx: Idx.copy(idx),
        });
    };

    // The n-th fixed point of the aleph (or beth) ladder.
    Card.fixed = function (op, idx, sign) {
        if (idx === null || idx === undefined || (op !== "aleph" && op !== "beth")) {
            return NAN;
        }
        sign = orDefault(tonumberNil(sign), 1) < 0 ? -1 : 1;
        if (Idx.isZero(idx)) {
            // The zeroth rung of the ladder is where the fixed-point search
            // starts, so it names the base cardinal rather than a fixed point.
            return Card.plain(op, Idx.copy(idx), sign);
        }
        return Impl.newValue({
            kind: "card",
            sign,
            op,
            mode: "fp",
            idx: Idx.copy(idx),
        });
    };

    Card.fpIndex = (v) => Idx.fpOf(v.op, v.idx);

    // Ordering. Provably decidable pairs give -1/0/1; pairs whose order really
    // is independent of ZFC give null, which reads back as "incomparable".
    Card.compareMag = function (a, b) {
        if (a.mode === "plain" && b.mode === "plain") {
            if (a.op === b.op) {
                return Idx.compare(a.idx, b.idx);
            }
            const c = Idx.compare(a.idx, b.idx);
            if (c === 0) {
                if (Idx.isZero(a.idx) && Idx.isZero(b.idx)) {
                    return 0;
                }
                return null;
            }
            // aleph_alpha <= beth_alpha, so a smaller subscript is decisive
            // only when the aleph side is the smaller one.
            if (a.op === "aleph") {
                return c < 0 ? -1 : null;
            }
            return c > 0 ? 1 : null;
        }
        if (a.mode === "fp" && b.mode === "fp") {
            const c = Idx.compare(a.idx, b.idx);
            if (c !== 0) {
                return c;
            }
            if (a.op === b.op) {
                return 0;
            }
            return null;
        }
        let plain;
        let fp;
        if (a.mode === "fp") {
            fp = a;
            plain = b;
        } else {
            plain = a;
            fp = b;
        }
        let c;
        if (plain.op === fp.op) {
            c = Idx.compare(plain.idx, Card.fpIndex(fp));
        } else if (plain.op === "aleph") {
            c = Idx.compare(plain.idx, Card.fpIndex(fp));
            if (c > 0) {
                c = null;
            }
        } else {
            c = null;
        }
        if (c === null) {
            return null;
        }
        return plain === a ? c : -c;
    };

    Card.comparePositive = (a, b) => Card.compareMag(a, b);

    // Arithmetic has to pick a side even where ZFC cannot decide the order, so
    // it uses this total reading: the subscript decides, and an equal subscript
    // ties toward the upper (beth / fixed-point) ladder.
    Card.compareDefinite = (a, b) =>
        Idx.compareLadder(a.op, a.mode, a.idx, b.op, b.mode, b.idx);

    // 2^kappa, read as the next rung of the beth ladder. Under GCH this is the
    // successor cardinal; without it the library still gives the beth value,
    // which is the bound ZFC actually proves for the power set of an aleph.
    Card.powerSet = function (k) {
        const i = Idx.succ(k.idx);
        if (i === null) {
            return CAP;
        }
        if (k.mode === "fp") {
            return Card.fixed("beth", i, 1);
        }
        return Card.plain("beth", i, 1);
    };

    Card.magPow = function (a, b) {
        if (b.kind !== "card") {
            if (Impl.isZero(b)) {
                return ONE;
            }
            return Card.copy(a);
        }
        // k^lambda is at least k and at least 2^lambda, and equals 2^lambda
        // once the exponent reaches the base, so the model returns the larger.
        const ps = Card.powerSet(b);
        if (Card.compareDefinite(ps, a) >= 0) {
            return ps;
        }
        return Card.copy(a);
    };

    Card.cardSucc = function (v) {
        if (v.kind === "card") {
            const i = Idx.succ(v.idx);
            if (i === null) {
                return CAP;
            }
            if (v.mode === "fp") {
                return Card.fixed(v.op, i, v.sign);
            }
            return Card.plain(v.op, i, v.sign);
        }
        if (v.kind === "nan") {
            return NAN;
        }
        if (v.kind === "cap") {
            return CAP;
        }
        if (v.kind === "finite" && v.n >= 0 && v.n <= MAX_SAFE) {
            return Impl.finite(Math.floor(v.n) + 1);
        }
        // Every other value this library holds is a finite integer, so the next
        // cardinal above it is the first infinite one.
        return Card.copy(ALEPH0);
    };

    // Signed cardinal operations. Every non-card operand is a finite integer,
    // so it is absorbed by the cardinal unless the exponent position says
    // otherwise.
    Card.addValues = function (a, b) {
        if (a.kind !== "card") {
            return Card.copy(b);
        } else if (b.kind !== "card") {
            return Card.copy(a);
        }
        if (a.sign === b.sign) {
            // kappa + lambda is the larger cardinal, so one compare decides the
            // result and a single copy builds it.
            return Card.copy(Card.compareDefinite(a, b) >= 0 ? a : b);
        }
        const c = Card.compareDefinite(a, b);
        if (c === 0) {
            return ZERO;
        }
        // Opposite signs cancel into subtraction: the larger magnitude keeps
        // its own sign.
        return Card.copy(c > 0 ? a : b);
    };

    Card.mulValues = function (a, b) {
        const sign = Impl.signOf(a) * Impl.signOf(b);
        if (a.kind !== "card") {
            return Card.withSign(b, sign);
        } else if (b.kind !== "card") {
            return Card.withSign(a, sign);
        }
        return Card.withSign(Card.compareDefinite(a, b) >= 0 ? a : b, sign);
    };

    Card.divValues = function (a, b) {
        const sign = Impl.signOf(a) * Impl.signOf(b);
        if (a.kind === "card" && b.kind === "card") {
            const c = Card.compareDefinite(a, b);
            if (c === 0) {
                return ONE;
            } else if (c > 0) {
                return Card.withSign(a, sign);
            }
            return ZERO;
        }
        if (a.kind === "card") {
            // Dividing by a finite integer leaves an infinite cardinal alone.
            return Card.withSign(a, sign);
        }
        return ZERO;
    };

    Card.powValues = function (a, b) {
        if (b.kind === "card") {
            if (a.kind === "card") {
                return Card.withSign(
                    Card.magPow(Impl.magnitude(a), Impl.magnitude(b)), 1);
            }
            if (Impl.signOf(a) < 0) {
                // The parity of a cardinal exponent is not representable.
                return NAN;
            }
            const ab = Impl.magnitude(a);
            if (ab.kind === "finite") {
                if (ab.n === 1) {
                    return ONE;
                } else if (ab.n < 1) {
                    return ZERO;
                }
            }
            // k^kappa = 2^kappa for every finite k >= 2.
            return Card.powerSet(b);
        }
        if (a.kind !== "card") {
            return null;
        }
        if (Impl.isZero(b)) {
            return ONE;
        }
        if (Impl.signOf(b) < 0) {
            // 1 / kappa is smaller than every cardinal this model can name.
            return ZERO;
        }
        if (a.sign < 0) {
            if (b.kind !== "finite" || b.n !== Math.floor(b.n)) {
                // The parity of a non-integer exponent is not representable.
                return NAN;
            }
            if (floorMod(Math.abs(b.n), 2) === 0) {
                return Card.withSign(a, 1);
            }
            return Card.copy(a);
        }
        return Card.copy(a);
    };

    Card.format = function (v) {
        const glyph = Idx.opGlyph(v.op);
        const body = v.mode === "fp"
            ? glyph + "*" + Idx.tail(v.idx)
            : glyph + Idx.tail(v.idx);
        return v.sign < 0 ? "-" + body : body;
    };

    Card.toTable = (v) => ({
        __zuba: 1,
        kind: "card",
        sign: v.sign,
        op: v.op,
        mode: v.mode,
        idx: Idx.toTable(v.idx),
    });

    Card.fromTable = function (t) {
        const idx = Idx.fromTable(t.idx);
        if (idx === null) {
            return NAN;
        }
        if (t.mode === "fp") {
            return Card.fixed(t.op, idx, t.sign);
        }
        return Card.plain(t.op, idx, t.sign);
    };

    Fgh = {};

    Fgh.copy = (v) => Impl.newValue({
        kind: "fgh",
        sign: v.sign,
        mode: v.mode,
        idx: Idx.copy(v.idx),
        arg: Impl.copy(v.arg),
    });

    Fgh.withSign = function (v, sign) {
        const out = Fgh.copy(v);
        out.sign = sign < 0 ? -1 : 1;
        return out;
    };

    // Finite levels expand into the value model; a level that is not a plain
    // integer stays formal and is ordered by its own index.
    Fgh.expand = function (alpha, n) {
        if (alpha.kind !== "finite") {
            return null;
        }
        const a = numfloor(alpha.n);
        if (a < 0 || !isfinite(a) || a !== alpha.n) {
            return null;
        }
        if (a === 0) {
            return Impl.addValues(n, ONE);
        } else if (a === 1) {
            return Impl.mulValues(n, Impl.finite(2));
        } else if (a === 2) {
            return Impl.mulValues(n, Impl.powValues(Impl.finite(2), n));
        }
        return Impl.hyperValue(a + 1, n, n);
    };

    Fgh.create = function (idx, arg) {
        if (idx === null || idx === undefined || !Impl.isZuba(arg) || arg.kind === "nan") {
            return NAN;
        }
        if (Impl.signOf(arg) < 0) {
            return NAN;
        }
        if (idx.cls === "fin") {
            const expanded = Fgh.expand(idx.v, arg);
            if (expanded !== null) {
                return expanded;
            }
        }
        return Impl.newValue({
            kind: "fgh",
            sign: 1,
            idx: Idx.copy(idx),
            arg: Impl.magnitude(arg),
        });
    };

    // Hardy hierarchy: H_0(x) = x, H_{a+1}(x) = H_a(x + 1), H_l(x) = H_{l[x]}(x).
    // A finite level is plain addition, which the value model holds exactly, so
    // only transfinite levels stay formal. The hierarchy is relativised to the
    // seed function x -> x + base, which shifts every level by the same amount,
    // so base folds into the argument instead of becoming a third field.
    Fgh.hardy = function (idx, arg, base) {
        if (idx === null || idx === undefined || !Impl.isZuba(arg) || arg.kind === "nan") {
            return NAN;
        }
        let seed = arg;
        if (base !== undefined && base !== null) {
            const b = Impl.asValue(base);
            if (b.kind === "nan") {
                return NAN;
            }
            seed = Impl.addValues(arg, b);
        }
        if (Impl.signOf(seed) < 0) {
            return NAN;
        }
        if (idx.cls === "fin") {
            const k = idx.v;
            if (k.kind !== "finite" || k.n < 0 || k.n !== numfloor(k.n) || !isfinite(k.n)) {
                return NAN;
            }
            return Impl.addValues(seed, k);
        }
        return Impl.newValue({
            kind: "fgh",
            mode: "hardy",
            sign: 1,
            idx: Idx.copy(idx),
            arg: Impl.magnitude(seed),
        });
    };

    Fgh.rankOf = (v) => (v.idx.cls === "ord" ? v.idx.rank : Rank.TOP);

    Fgh.comparePositive = function (a, b) {
        const ic = Idx.compare(a.idx, b.idx);
        if (ic !== 0) {
            return ic;
        }
        return Impl.compare(a.arg, b.arg);
    };

    Fgh.format = function (v) {
        const head = v.mode === "hardy" ? "H" : "f";
        const body = head + Idx.tail(v.idx) + "(" + Impl.format(v.arg) + ")";
        return v.sign < 0 ? "-" + body : body;
    };

    Fgh.toTable = (v) => ({
        __zuba: 1,
        kind: "fgh",
        sign: v.sign,
        mode: v.mode,
        idx: Idx.toTable(v.idx),
        arg: Impl.toTable(v.arg),
    });

    Fgh.fromTable = function (t) {
        const idx = Idx.fromTable(t.idx);
        const arg = Impl.fromTable(t.arg);
        if (idx === null || arg.kind === "nan") {
            return NAN;
        }
        if (t.mode === "hardy") {
            return Fgh.hardy(idx, arg);
        }
        return Fgh.create(idx, arg);
    };

    // Split "name(a, b)" into the argument strings, respecting one level of
    // nesting so a nested rank spelling may itself contain a comma.
    function splitArgs2(inner) {
        let depth = 0;
        for (let i = 0; i < inner.length; i++) {
            const ch = inner.charAt(i);
            if (ch === "(") {
                depth = depth + 1;
            } else if (ch === ")") {
                depth = depth - 1;
            } else if (ch === "," && depth === 0) {
                return [inner.slice(0, i), inner.slice(i + 1)];
            }
        }
        return [inner, null];
    }

    // Subscript digits are their own characters, so a spelling such as
    // "aleph₁₂" reads as the index 12 without going through the value parser.
    function subDigitValue(tok) {
        const ascii = tonumberNil(tok);
        if (ascii !== undefined) {
            return ascii;
        }
        if (tok.length === 0) {
            return null;
        }
        let value = 0;
        for (let i = 0; i < tok.length; i++) {
            const d = SUBSCRIPT_DIGITS.indexOf(tok.charAt(i));
            if (d < 0) {
                return null;
            }
            value = value * 10 + d;
        }
        return value;
    }

    // Spellings: aleph(...), aleph_5, aleph5, aleph(omega), alephfixed(2),
    // beth(...), fgh(omega, 100), f_omega(100) and the glyph forms.
    //
    // A depth-zero sign splits an additive remainder from the cardinal head, so
    // "aleph(omega)+1" folds through cardinal arithmetic instead of failing.
    const CARDINAL_HEADS = nilMap();
    CARDINAL_HEADS.ale = true;
    CARDINAL_HEADS.alp = true;
    CARDINAL_HEADS.bet = true;
    CARDINAL_HEADS.fgh = true;
    CARDINAL_HEADS.har = true;

    // Non-global so the whitespace guard below stays stateless.
    const HAS_SPACE = /[ \t\r\n\f\v]/;

    function splitCardinalOffset(low) {
        const head = low.slice(0, 3);
        if (CARDINAL_HEADS[head] !== true
            && !(low.charAt(0) === "f" && low.charAt(1) === "_")
            && !(low.charAt(0) === "h" && low.charAt(1) === "_")) {
            return null;
        }
        let depth = 0;
        for (let i = 1; i < low.length; i++) {
            const b = low.charCodeAt(i);
            if (b === 40) {
                depth = depth + 1;
            } else if (b === 41) {
                depth = depth - 1;
            } else if (depth === 0 && (b === 43 || b === 45)) {
                return [low.slice(0, i), b === 43 ? "+" : "-", low.slice(i + 1)];
            }
        }
        return null;
    }

    // Hoisted so a parse does not rebuild one regex per alternative.
    const ALEPH_FIXED_RE = [
        /^alephfixed\(([\s\S]*?)\)$/, /^aleph_fix\(([\s\S]*?)\)$/,
        /^aleph_fixed\(([\s\S]*?)\)$/, /^aleph_fp\(([\s\S]*?)\)$/,
        /^alpehfixed\(([\s\S]*?)\)$/,
    ];
    const BETH_FIXED_RE = [
        /^bethfixed\(([\s\S]*?)\)$/, /^beth_fix\(([\s\S]*?)\)$/,
        /^beth_fixed\(([\s\S]*?)\)$/, /^beth_fp\(([\s\S]*?)\)$/,
    ];
    const ALEPH_CALL_RE = [/^aleph\(([\s\S]*?)\)$/, /^alpeh\(([\s\S]*?)\)$/];
    const BETH_CALL_RE = [/^beth\(([\s\S]*?)\)$/];
    const ALEPH_TAIL_RE = [/^aleph[_=]?([\s\S]+)$/, /^alpeh[_=]?([\s\S]+)$/];
    const BETH_TAIL_RE = [/^beth[_=]?([\s\S]+)$/];
    const FGH_CALL_RE = [/^fgh\(([\s\S]*?)\)$/, /^fg\(([\s\S]*?)\)$/];
    const FGH_SHORT_RE = /^f_([^(]+)\(([\s\S]*?)\)$/;
    const HARDY_CALL_RE = [/^hardy\(([\s\S]*?)\)$/];
    const HARDY_SHORT_RE = /^h_([^(]+)\(([\s\S]*?)\)$/;

    Card.parse = function (s, depth) {
        if (typeof s !== "string") {
            return null;
        }
        let t = s;
        // Each replacement builds a new string, so pay for them only when the
        // spelling actually carries whitespace or a cardinal glyph.
        if (HAS_SPACE.test(t)) {
            t = stripSpace(t);
        }
        if (t.charCodeAt(0) > 127 || t.indexOf(ALEPH_GLYPH) !== -1
            || t.indexOf(BETH_GLYPH) !== -1) {
            t = t.split(ALEPH_GLYPH).join("aleph");
            t = t.split(BETH_GLYPH).join("beth");
        }
        let sign = 1;
        if (t.charAt(0) === "-") {
            sign = -1;
            t = t.slice(1);
        } else if (t.charAt(0) === "+") {
            t = t.slice(1);
        }
        const low = lowerText(t);

        const offset = splitCardinalOffset(low);
        if (offset !== null && offset[2] !== "") {
            const head = Card.parse(offset[0], depth);
            if (head !== null && head.kind !== "nan") {
                const rest = Impl.parseString(offset[2], depth + 1);
                if (offset[1] === "+") {
                    return Impl.addValues(head, rest);
                }
                return Impl.subValues(head, rest);
            }
        }

        function make(op, mode, tok) {
            const idx = Idx.fromToken(tok, depth);
            if (idx === null) {
                return NAN;
            }
            if (mode === "fp") {
                return Card.fixed(op, idx, sign);
            }
            return Card.plain(op, idx, sign);
        }

        let tok = firstMatch(low, ALEPH_FIXED_RE);
        if (tok !== null) {
            return make("aleph", "fp", tok);
        }
        tok = firstMatch(low, BETH_FIXED_RE);
        if (tok !== null) {
            return make("beth", "fp", tok);
        }

        tok = firstMatch(low, ALEPH_CALL_RE);
        if (tok !== null) {
            return make("aleph", "plain", tok);
        }
        tok = firstMatch(low, BETH_CALL_RE);
        if (tok !== null) {
            return make("beth", "plain", tok);
        }

        if (low === "aleph" || low === "alpeh"
            || low.replace(/[-_]/g, "") === "alephnull") {
            return Card.plain("aleph", Idx.fin(ZERO), sign);
        }
        let tail = firstMatch(low, ALEPH_TAIL_RE);
        if (tail !== null) {
            const d = subDigitValue(tail);
            if (d !== null && d >= 0) {
                return Card.plain("aleph", Idx.fin(Impl.finite(d)), sign);
            }
            return make("aleph", "plain", tail);
        }

        tail = match1(low, BETH_TAIL_RE[0]);
        if (tail === null && low === "beth") {
            return Card.plain("beth", Idx.fin(ZERO), sign);
        }
        if (tail !== null) {
            const d = subDigitValue(tail);
            if (d !== null && d >= 0) {
                return Card.plain("beth", Idx.fin(Impl.finite(d)), sign);
            }
            return make("beth", "plain", tail);
        }

        let both = firstMatch(low, FGH_CALL_RE);
        if (both !== null) {
            const parts = splitArgs2(both);
            if (parts[1] === null) {
                return null;
            }
            return Fgh.create(Idx.fromToken(parts[0], depth),
                Impl.parseString(parts[1], depth + 1));
        }
        let pair = FGH_SHORT_RE.exec(low);
        if (pair !== null) {
            return Fgh.create(Idx.fromToken(pair[1], depth),
                Impl.parseString(pair[2], depth + 1));
        }

        both = firstMatch(low, HARDY_CALL_RE);
        if (both !== null) {
            const parts = Hyper.splitArgs(both);
            if (parts === null || parts.length < 2 || parts.length > 3) {
                return null;
            }
            const seed = parts[2] !== undefined && parts[2] !== ""
                ? Impl.parseString(parts[2], depth + 1) : null;
            return Fgh.hardy(Idx.fromToken(parts[0], depth),
                Impl.parseString(parts[1], depth + 1), seed);
        }
        pair = HARDY_SHORT_RE.exec(low);
        if (pair !== null) {
            return Fgh.hardy(Idx.fromToken(pair[1], depth),
                Impl.parseString(pair[2], depth + 1));
        }
        return null;
    };

    // BEAF linear arrays and arrow chains --------------------------------------
    // A linear array is an array of positive integers. The first two entries are
    // exact here ({a, b} = a^b) and the third runs on the hyper ladder this
    // library already models, so {a, b, c} = a ↑^c b and one arrow is
    // exponentiation, two arrows tetration, and so on. Trailing 1s drop out of
    // the array, which is the s(#,1) = s(#) rule. Four entries and above need
    // the planar rules, whose growth passes every tier here, so they return
    // LIMIT.

    Beaf = {};

    // The arrow separator glyph, U+2192; an arrow chain may spell it as bytes
    // 226 134 146, and it reads as the plain "->" separator.
    const BEAF_ARROW_GLYPH = "→";

    Beaf.eval = function (entries) {
        let n = entries.length;
        while (n > 0) {
            const last = entries[n - 1];
            if (last.kind !== "finite" || last.n !== 1) {
                break;
            }
            n = n - 1;
        }
        if (n === 0) {
            return ONE;
        } else if (n === 1) {
            return Impl.copy(entries[0]);
        } else if (n > 3) {
            return CAP;
        }
        const a = entries[0];
        const b = entries[1];
        if (n === 2) {
            return Impl.powValues(a, b);
        }
        const c = entries[2];
        if (c.kind !== "finite") {
            // A count no double can hold is a hyper level past the ladder.
            return c.sign < 0 ? NAN : CAP;
        }
        if (c.n < 0 || c.n !== numfloor(c.n)) {
            return NAN;
        }
        return Impl.hyperValue(c.n + 2, a, b);
    };

    // Split "a->b->c" and "a->->b" into the entries and the number of arrows
    // between them. A run of k arrows between two entries is the three-entry
    // array {a, b, k}; k = 1 keeps the plain {a, b} power.
    function BEAF_splitArrowChain(t) {
        const parts = [];
        const runs = [];
        let start = 0;
        let i = 0;
        const n = t.length;
        while (i < n) {
            if (t.charCodeAt(i) === 45 && t.charCodeAt(i + 1) === 62) {
                parts.push(t.slice(start, i));
                let k = 0;
                do {
                    k = k + 1;
                    i = i + 2;
                } while (t.charCodeAt(i) === 45 && t.charCodeAt(i + 1) === 62);
                runs.push(k);
                start = i;
            } else {
                i = i + 1;
            }
        }
        parts.push(t.slice(start));
        return [parts, runs];
    }

    Beaf.parse = function (s, depth) {
        if (typeof s !== "string") {
            return null;
        }
        let t = stripSpace(s);
        if (t === "") {
            return null;
        }
        if (t.indexOf(BEAF_ARROW_GLYPH) !== -1) {
            t = t.split(BEAF_ARROW_GLYPH).join("->");
        }
        let raw;
        let count = 0;
        if (t.slice(0, 1) === "{") {
            if (t.slice(-1) !== "}") {
                return NAN;
            }
            raw = Hyper.splitArgs(t.slice(1, -1));
            if (raw === null) {
                return NAN;
            }
            count = raw.length;
        } else {
            const chain = BEAF_splitArrowChain(t);
            const parts = chain[0];
            const runs = chain[1];
            if (parts.length < 2) {
                return null;
            }
            if (parts.length === 2) {
                raw = [parts[0], parts[1], toStr(runs[0])];
                count = 3;
            } else {
                for (let i = 0; i < runs.length; i++) {
                    if (runs[i] !== 1) {
                        return NAN;
                    }
                }
                raw = parts;
                count = parts.length;
            }
        }

        const entries = [];
        for (let i = 0; i < count; i++) {
            const tok = raw[i];
            if (tok === "") {
                return NAN;
            }
            const v = Impl.parseString(tok, (depth || 0) + 1);
            if (v.kind === "nan") {
                return NAN;
            }
            entries[i] = v;
        }
        return Beaf.eval(entries);
    };

    // Only a plain hyper expression at an integer level is exactly an array:
    // coefficients, powers and offsets have no array form.
    Beaf.toText = function (v) {
        if (v.kind !== "hyper" || v.sign < 0 || v.p !== 1 || v.coef !== 1 || v.off !== 0) {
            return null;
        }
        const level = v.level;
        if (level < 3 || level !== numfloor(level)) {
            return null;
        }
        if (!Beaf.isEntryValue(v.base) || !Beaf.isEntryValue(v.arg)) {
            return null;
        }
        const period = level - 2;
        if (period === 1) {
            return "{" + Named.numberText(v.base.n) + ", " + Named.numberText(v.arg.n) + "}";
        }
        return "{" + Named.numberText(v.base.n) + ", "
            + Named.numberText(v.arg.n) + ", " + Named.numberText(period) + "}";
    };

    Beaf.isEntryValue = function (v) {
        return v.kind === "finite" && v.n >= 0 && v.n === numfloor(v.n)
            && v.n < 1e15;
    };

    // Hyper-E ------------------------------------------------------------------
    // Hyper-E notation writes a × 10^b as "aEb", and a run of hyperions after it
    // repeats the E operator: "aEb#k" sits k-1 layers above a × 10^b, so "E100#2"
    // is a googolplex and "E100#100" is a grangol. A leading E with no left
    // argument means 1E, and a run of leading E's repeats it, which makes "ee100"
    // another spelling of "E100#2". Two or more hyperions lift the ladder by a
    // whole level each, so those runs are read as the hyper operation at level
    // h+3 over base 10 with the hyperion count as its argument; at that point the
    // head of the spelling no longer decides the size, which is how the notation
    // behaves once the iteration count itself is what grows.

    HyperE = {};

    // Read the hyperion run that starts at `from` and return its last index.
    HyperE.runEnd = function (t, from) {
        let last = from;
        while (last + 1 < t.length && t.charCodeAt(last + 1) === 35) {
            last = last + 1;
        }
        return last;
    };

    HyperE.eval = function (a, b, hyperions, count) {
        if (hyperions >= 2) {
            return Impl.hyperValue(hyperions + 3, TEN, count);
        }
        let base = Impl.powValues(TEN, b);
        if (!(a.kind === "finite" && a.n === 1)) {
            base = Impl.mulValues(a, base);
        }
        if (hyperions === 0) {
            return base;
        }
        return Impl.layerAdd(base, Impl.subValues(count, ONE));
    };

    HyperE.parse = function (s, depth) {
        if (typeof s !== "string") {
            return null;
        }
        let t = stripSpace(s);
        if (t === "") {
            return null;
        }
        depth = depth || 0;

        let head = t;
        let hyperions = 0;
        let countTok = null;
        const sep = t.indexOf("#");
        if (sep !== -1) {
            const last = HyperE.runEnd(t, sep);
            head = t.slice(0, sep);
            hyperions = last - sep + 1;
            countTok = t.slice(last + 1);
            if (countTok.indexOf("#") !== -1) {
                // Two separate runs need the full extended-E recursion.
                return NAN;
            }
        }

        let a;
        let b;
        const lead = head.charCodeAt(0);
        if (lead === 69 || lead === 101) {
            let i = 0;
            let reps = 0;
            while (i < head.length) {
                const c = head.charCodeAt(i);
                if (c !== 69 && c !== 101) {
                    break;
                }
                reps = reps + 1;
                i = i + 1;
            }
            const body = head.slice(i);
            if (body === "" || !HyperE.isOperandStart(body.charCodeAt(0))) {
                return null;
            }
            b = Impl.parseString(body, depth + 1);
            if (b.kind === "nan") {
                return NAN;
            }
            a = ONE;
            for (let r = 1; r < reps; r = r + 1) {
                b = Impl.powValues(TEN, b);
            }
        } else {
            let mid = -1;
            for (let i = 0; i < head.length; i++) {
                const c = head.charCodeAt(i);
                if (c === 69 || c === 101) {
                    mid = i;
                    break;
                }
            }
            const bTok = mid === -1 ? "" : head.slice(mid + 1);
            if (bTok === "") {
                return NAN;
            }
            const aTok = head.slice(0, mid);
            a = aTok === "" ? ONE : Impl.parseString(aTok, depth + 1);
            b = Impl.parseString(bTok, depth + 1);
            if (a.kind === "nan" || b.kind === "nan") {
                return NAN;
            }
        }

        let count;
        if (hyperions === 0) {
            count = ONE;
        } else if (countTok === "") {
            count = Impl.finite(hyperions + 1);
        } else {
            count = Impl.parseString(countTok, depth + 1);
            if (count.kind === "nan") {
                return NAN;
            }
            if ((count.kind === "finite" && count.n < 0) || Impl.signOf(count) < 0) {
                return NAN;
            }
            if (count.kind === "finite" && count.n !== numfloor(count.n)) {
                return NAN;
            }
        }
        return HyperE.eval(a, b, hyperions, count);
    };

    // A Hyper-E operand has to start with a digit, a sign or a decimal point;
    // anything else is an ordinary spelling that merely begins with "e".
    HyperE.isOperandStart = function (byte) {
        if (byte === null || byte === undefined || isnan(byte)) {
            return false;
        }
        return (byte >= 48 && byte <= 57) || byte === 46 || byte === 43 || byte === 45;
    };

    // Only the compact forms are exact here: a plain double, and a finite-rank
    // tower whose top the canonical form already keeps in [1, 10). Named, hyper,
    // cardinal and hierarchy values have no Hyper-E reading, so they fall back to
    // the default formatter.
    HyperE.toText = function (v) {
        if (v.kind === "finite") {
            const n = v.n;
            if (n < 1e15) {
                return n === 0 ? "0" : null;
            }
            let exp = numfloor(log10(n));
            let mant = n / pow10(exp);
            if (mant >= 10) {
                exp = exp + 1;
                mant = mant / 10;
            } else if (mant < 1) {
                exp = exp - 1;
                mant = mant * 10;
            }
            if (mant === 1) {
                return "E" + Named.numberText(exp);
            }
            return Named.numberText(mant) + "E" + Named.numberText(exp);
        }
        if (v.kind !== "tower" || v.sign < 0 || !Rank.isFinite(v.rank)) {
            return null;
        }
        const h = Rank.finiteValue(v.rank);
        if (h < 1 || h !== numfloor(h) || h > 1e15) {
            return null;
        }
        return "E" + Named.numberText(v.m) + "#" + Named.numberText(h);
    };

    // Named hyperoperation families -------------------------------------------
    // The -ote grid names the ordinal-indexed hyperoperations x{α}y. A family
    // code is the Cantor-normal-form digits of α read in descending ω-power
    // order, so h10 is level ω, h11 is ω+1, h21 is ω·2+1, h100 is ω², hww is ω^ω
    // and hepsl is ε₀. The ω-rows evaluate exactly: rule 3, x{λ}y = x{λ[y]}x,
    // turns a limit level into a finite one whose index is computable, so
    // aperiote(x, y) is x{y}x — the hyper operation at level y+2 — and
    // expande(x, 2) is aperiote(x, x). The recursion is run to its end and stops
    // at LIMIT as soon as a level or an operand leaves the double range, which is
    // why expande(10, 2) is H(12, 10, 10) while expande(10, 3) is LIMIT: the
    // second step needs a level drawn from a value, not from a double. Levels at
    // ω² and above are outside the (ω·a + b) rows, so those families return only
    // the collapses that hold at every level below ε₀: count 1 gives x, base 1
    // gives 1, and base 2 with an integer count of at least 2 gives 4.

    Grid = {};

    // a = coefficient of ω, b = finite offset; both absent for the higher rows.
    Grid.SPECS = [
        { name: "aperiote", short: "aper", code: "h10", a: 1, b: 0, level: "ω" },
        { name: "expande", short: "expa", code: "h11", a: 1, b: 1, level: "ω+1" },
        { name: "multiexpande", short: "muea", code: "h12", a: 1, b: 2, level: "ω+2" },
        { name: "powerexpande", short: "poea", code: "h13", a: 1, b: 3, level: "ω+3" },
        { name: "aperioexpande", short: "apea", code: "h20", a: 2, b: 0, level: "ω·2" },
        { name: "explode", short: "expl", code: "h21", a: 2, b: 1, level: "ω·2+1" },
        { name: "multiexplode", short: "muel", code: "h22", a: 2, b: 2, level: "ω·2+2" },
        { name: "aperioexplode", short: "apel", code: "h30", a: 3, b: 0, level: "ω·3" },
        { name: "detonate", short: "deto", code: "h31", a: 3, b: 1, level: "ω·3+1" },
        { name: "aperiodetonate", short: "apdt", code: "h40", a: 4, b: 0, level: "ω·4" },
        { name: "aperionate", short: "apeo", code: "h100", level: "ω²" },
        { name: "megote", short: "mego", code: "h101", level: "ω²+1" },
        { name: "multimegote", short: "mume", code: "h102", level: "ω²+2" },
        { name: "aperimegote", short: "apmg", code: "h110", level: "ω²+ω" },
        { name: "megoexpande", short: "mgea", code: "h111", level: "ω²+ω+1" },
        { name: "aperimegoexpande", short: "apme", code: "h120", level: "ω²+ω·2" },
        { name: "megoaperionate", short: "mgao", code: "h200", level: "ω²·2" },
        { name: "gigote", short: "gigo", code: "h201", level: "ω²·2+1" },
        { name: "aperigigote", short: "apgg", code: "h210", level: "ω²·2+ω" },
        { name: "gigoaperionate", short: "ggap", code: "h300", level: "ω²·3" },
        { name: "aperiatote", short: "apat", code: "h1000", level: "ω³" },
        { name: "powiainate", short: "pwan", code: "h1001", level: "ω³+1" },
        { name: "expandainate", short: "epan", code: "h1010", level: "ω³+ω" },
        { name: "megodainate", short: "mgan", code: "h1100", level: "ω³+ω²" },
        { name: "powiairate", short: "pwar", code: "h2000", level: "ω³·2" },
        { name: "aperioguate", short: "apgu", code: "h10000", level: "ω⁴" },
        { name: "iterate", short: "iter", code: "hww", level: "ω^ω" },
        { name: "itermult", short: "itmu", code: "hw01", level: "ω^ω+1" },
        { name: "cuboiter", short: "cube", code: "hwx2", level: "ω^ω·2" },
        { name: "expoiter", short: "expo", code: "hwa1", level: "ω^(ω+1)" },
        { name: "trioterate", short: "tria", code: "hwm2", level: "ω^(ω·2)" },
        { name: "trixxate", short: "trix", code: "hwp2", level: "ω^(ω²)" },
        { name: "aperixxate", short: "apix", code: "hwpw", level: "ω^(ω^ω)" },
        { name: "epsilonate", short: "epsl", code: "hepsl", level: "ε₀" },
    ];

    Grid.BY_TOKEN = nilMap();
    for (let i = 0; i < Grid.SPECS.length; i++) {
        const spec = Grid.SPECS[i];
        Grid.BY_TOKEN[spec.name] = spec;
        Grid.BY_TOKEN[spec.short] = spec;
        Grid.BY_TOKEN[spec.code] = spec;
    }

    // x{ω·a + b}y, unfolded by rules 2 and 3 until the level is finite.
    Grid.atLevel = function (a, b, x, y, frames) {
        if (frames[0] > 64) {
            return CAP;
        }
        frames[0] = frames[0] + 1;
        if (y.kind === "finite" && y.n === 1) {
            return Impl.copy(x);
        }
        if (b > 0) {
            const inner = Grid.atLevel(a, b, x, Impl.subValues(y, ONE), frames);
            if (inner.kind === "nan") {
                return NAN;
            }
            return Grid.atLevel(a, b - 1, x, inner, frames);
        }
        if (a === 1) {
            // Rule 3 at ω: x{ω}y = x{y}x, a finite level under the double ceiling.
            if (y.kind !== "finite" || y.n > 1e306) {
                return CAP;
            }
            return Impl.hyperValue(y.n + 2, x, x);
        }
        // (ω·a)[y] = ω·(a-1) + y, so the offset becomes the count y and the
        // operand becomes the base.
        if (y.kind !== "finite" || y.n > 64) {
            return CAP;
        }
        return Grid.atLevel(a - 1, y.n, x, x, frames);
    };

    Grid.eval = function (spec, x, y) {
        if (x.kind === "nan" || y.kind === "nan") {
            return NAN;
        }
        if (x.kind === "cap") {
            return x.sign < 0 ? NAN : CAP;
        }
        if (Impl.isZero(x)) {
            return ZERO;
        }
        if (x.kind === "finite" && x.n === 1) {
            return ONE;
        }
        if (y.kind !== "finite") {
            if (y.kind === "cap" && y.sign > 0) {
                return CAP;
            }
            return NAN;
        }
        if (y.n < 1 || y.n !== numfloor(y.n)) {
            return NAN;
        }
        if (y.n === 1) {
            return Impl.copy(x);
        }
        if (spec.a === undefined || spec.a === null) {
            // Outside the ω-rows only the exact collapses are values.
            if (x.kind === "finite" && x.n === 2) {
                return Impl.finite(4);
            }
            return CAP;
        }
        return Grid.atLevel(spec.a, spec.b, x, y, [0]);
    };

    // "expande(10,2)", "h11(10,2)", "epsl(3,2)" and every other registry token.
    Grid.parse = function (s, depth) {
        const tok = match1(s, /^([A-Za-z0-9_]+)\(/);
        if (tok === null) {
            return null;
        }
        const spec = Grid.BY_TOKEN[lowerText(tok)];
        if (spec === undefined) {
            return null;
        }
        const inner = match1(s, /^[A-Za-z0-9_]+\((.*)\)$/);
        if (inner === null) {
            return NAN;
        }
        const parts = Hyper.splitArgs(inner);
        if (parts === null || parts.length !== 2) {
            return NAN;
        }
        const x = Impl.parseString(parts[0], (depth || 0) + 1);
        const y = Impl.parseString(parts[1], (depth || 0) + 1);
        return Grid.eval(spec, x, y);
    };

    // Returns [rank, flag].
    Impl.rankHandleOf = function (v) {
        if (v.kind === "fgh") {
            const ord = v.idx.cls === "ord";
            if (v.mode === "hardy") {
                // H_alpha never outruns f_alpha, so at one handle the hierarchy
                // value keeps its rank and the Hardy value sits below it.
                return [ord ? v.idx.rank : Rank.TOP, ord ? 1 : 3];
            }
            return [ord ? v.idx.rank : Rank.TOP, ord ? 2 : 4];
        }
        return [v.rank, 0];
    };

    // Tier 3 holds infinite-rank towers and formal hierarchy values together.
    // A tower and an f value with the same rank handle order by that handle, and
    // the hierarchy value wins the tie: f_alpha closes over the tower ladder at
    // alpha instead of sitting inside it. The handle flag carries that order, with
    // a Hardy value at the same index below the f value it is bounded by.
    Impl.cmpTier3Positive = function (a, b) {
        const ha = Impl.rankHandleOf(a);
        const hb = Impl.rankHandleOf(b);
        const rc = Rank.compare(ha[0], hb[0]);
        if (rc !== 0) {
            return rc;
        }
        if (ha[1] !== hb[1]) {
            return ha[1] < hb[1] ? -1 : 1;
        }
        if (a.kind === "tower") {
            if (a.m === b.m) {
                return 0;
            }
            return a.m < b.m ? -1 : 1;
        }
        return Fgh.comparePositive(a, b);
    };

    Impl.tierOf = function (v) {
        if (v.kind === "hyper") {
            return Hyper.anchorOf(v) !== null ? 2 : 1.5;
        } else if (v.kind === "named") {
            return 2;
        } else if (v.kind === "fgh") {
            return 3;
        } else if (v.kind === "card") {
            return 4;
        } else if (v.kind === "cap") {
            return 5;
        } else if (v.kind === "tower" && !Rank.isFinite(v.rank)) {
            return 3;
        }
        return 1;
    };

    // Order inside the named band. Plain named values are their own anchor;
    // an anchored hyper value ranks above an equal anchor, and anchors are
    // compared before the hyper structure.
    Impl.compareBand2Positive = function (a, b) {
        const aa = a.kind === "named" ? a : Hyper.anchorOf(a);
        const ab = b.kind === "named" ? b : Hyper.anchorOf(b);
        if (aa === null) {
            return ab === null ? 0 : -1;
        } else if (ab === null) {
            return 1;
        }
        const c = Named.compareBase(aa, ab);
        if (c !== 0) {
            return c;
        }
        if (a.kind === "named" && b.kind === "named") {
            return Named.compareMag(a, b);
        } else if (a.kind === "hyper" && b.kind === "hyper") {
            return Hyper.compareMag(a, b);
        }
        if (a.kind === "hyper") {
            return Impl.compareHyperNamed(a, b);
        }
        return -Impl.compareHyperNamed(b, a);
    };

    // Compare an anchored H(level, base, arg) with a named value of the same
    // constant. H(3, B, k) is B^k, so it is a fixed power of B and compares
    // by exponent; a constant inside the argument (B^B, 2^B, B^^B) or any
    // level above 3 outgrows every fixed power of B.
    Impl.compareHyperNamed = function (h, n) {
        if (h.arg.kind === "finite") {
            if (h.arg.n === 0) {
                return -1;
            } else if (h.arg.n === 1) {
                return Impl.compare(h.base, n);
            }
        }
        if (h.level > 3) {
            return 1;
        }
        if (h.base.kind === "finite") {
            return h.base.n >= 1 ? 1 : -1;
        }
        if (h.base.kind === "named" && Named.compareBase(h.base, n) === 0) {
            if (h.arg.kind !== "finite") {
                return 1;
            }
            const e = h.base.p * h.arg.n;
            const ep = n.p;
            // Logs avoid overflow when p or the count is huge.
            const le = e > 0 ? (Math.log(h.base.p) + Math.log(h.arg.n)) : -Infinity;
            const ln = Math.log(ep);
            if (le !== ln) {
                return le < ln ? -1 : 1;
            }
            const lc = Math.log(h.coef) + h.arg.n * Math.log(h.base.coef);
            const lnc = Math.log(n.coef);
            if (lc !== lnc) {
                return lc < lnc ? -1 : 1;
            }
            if (h.off !== n.off) {
                return h.off < n.off ? -1 : 1;
            }
            return 0;
        }
        return 1;
    };

    Impl.cmpPositive = function (a, b) {
        const ta = Impl.tierOf(a);
        const tb = Impl.tierOf(b);
        if (ta !== tb) {
            return ta < tb ? -1 : 1;
        }
        if (ta === 1.5) {
            return Hyper.compareMag(a, b);
        }
        if (ta === 2) {
            return Impl.compareBand2Positive(a, b);
        }
        if (ta === 3) {
            return Impl.cmpTier3Positive(a, b);
        }
        if (ta === 4) {
            return Card.compareDefinite(a, b);
        }
        const af = a.kind === "finite";
        const bf = b.kind === "finite";
        if (af && bf) {
            if (a.n === b.n) {
                return 0;
            }
            return a.n < b.n ? -1 : 1;
        } else if (af) {
            return -1;
        } else if (bf) {
            return 1;
        }
        const rc = Rank.compare(a.rank, b.rank);
        if (rc !== 0) {
            return rc;
        }
        if (a.m === b.m) {
            return 0;
        }
        return a.m < b.m ? -1 : 1;
    };

    // Returns null when either side is NaN.
    Impl.compare = function (a, b) {
        if (a.kind === "nan" || b.kind === "nan") {
            return null;
        }
        if (a.kind === "finite" && b.kind === "finite") {
            if (a.n === b.n) {
                return 0;
            }
            return a.n < b.n ? -1 : 1;
        }
        if (a.kind === "cap" || b.kind === "cap") {
            const ca = a.kind === "cap";
            const cb = b.kind === "cap";
            if (ca && cb) {
                if (a.sign === b.sign) {
                    return 0;
                }
                return a.sign > b.sign ? 1 : -1;
            } else if (ca) {
                return a.sign;
            }
            return -b.sign;
        }
        const sa = Impl.signOf(a);
        const sb = Impl.signOf(b);
        if (sa === 0 && sb === 0) {
            return 0;
        } else if (sa === 0) {
            return sb > 0 ? -1 : 1;
        } else if (sb === 0) {
            return sa > 0 ? 1 : -1;
        }
        if (sa !== sb) {
            return sa > sb ? 1 : -1;
        }
        // Same-sign fast paths avoid allocating magnitude copies. Ordered by
        // kind so the common same-family comparisons stay allocation-free.
        const ka = a.kind;
        const kb = b.kind;
        if (ka === "card" || kb === "card") {
            let mag;
            if (ka === "card" && kb === "card") {
                mag = Card.compareMag(a, b);
            } else {
                // A cardinal is an infinite ordinal and every other value this
                // library holds models a finite integer, so the cardinal wins.
                mag = ka === "card" ? 1 : -1;
            }
            if (mag === null) {
                return null;
            }
            return sa < 0 ? -mag : mag;
        }
        if (ka === "fgh" || kb === "fgh") {
            // The hierarchy compare reads the level index and the argument only,
            // never the outer sign, so the signs resolved above are enough.
            const mag = Impl.cmpPositive(a, b);
            return sa < 0 ? -mag : mag;
        }
        if (ka === "named") {
            if (kb === "named") {
                const mag = Named.compareMag(a, b);
                return sa < 0 ? -mag : mag;
            } else if (kb === "tower") {
                const order = Rank.isFinite(b.rank) ? 1 : -1;
                return sa < 0 ? -order : order;
            } else if (kb === "hyper") {
                const mag = Impl.compareBand2Positive(a, b);
                return sa < 0 ? -mag : mag;
            }
            return sa;
        } else if (kb === "named") {
            if (ka === "tower") {
                const order = Rank.isFinite(a.rank) ? -1 : 1;
                return sa < 0 ? -order : order;
            } else if (ka === "hyper") {
                const mag = Impl.compareBand2Positive(a, b);
                return sa < 0 ? -mag : mag;
            }
            return -sa;
        }
        if (ka === "tower" && kb === "tower") {
            let rc = Rank.compare(a.rank, b.rank);
            if (rc === 0) {
                if (a.m === b.m) {
                    return 0;
                }
                rc = a.m < b.m ? -1 : 1;
            }
            return sa < 0 ? -rc : rc;
        }
        if (ka === "hyper") {
            if (kb === "hyper") {
                const mag = Hyper.compareMag(a, b);
                return sa < 0 ? -mag : mag;
            } else if (kb === "tower") {
                const order = Rank.isFinite(b.rank) ? 1 : -1;
                return sa < 0 ? -order : order;
            }
            return sa;
        } else if (kb === "hyper") {
            if (ka === "tower") {
                const order = Rank.isFinite(a.rank) ? -1 : 1;
                return sa < 0 ? -order : order;
            }
            return -sa;
        }
        let mag = Impl.cmpPositive(Impl.magnitude(a), Impl.magnitude(b));
        if (sa < 0) {
            mag = -mag;
        }
        return mag;
    };

    // Values never change after construction, so an already-positive operand is
    // its own magnitude. Returning it avoids a copy in every compare, add and min
    // -max path that asks for magnitudes of positive inputs.
    Impl.magnitude = function (v) {
        if (v.kind === "finite") {
            if (v.n > 0) {
                return v;
            } else if (v.n === 0) {
                return ZERO;
            }
            return Impl.finite(-v.n);
        }
        if (v.kind === "nan") {
            return v;
        }
        if (v.sign > 0) {
            return v;
        }
        if (v.kind === "tower") {
            return Impl.newValue({ kind: "tower", sign: 1, rank: v.rank, m: v.m });
        }
        if (v.kind === "named") {
            return Named.withSign(v, 1);
        } else if (v.kind === "hyper") {
            return Hyper.withSign(v, 1);
        } else if (v.kind === "card") {
            return Card.withSign(v, 1);
        } else if (v.kind === "fgh") {
            return Fgh.withSign(v, 1);
        } else if (v.kind === "cap") {
            return CAP;
        }
        return v;
    };

    Impl.maxPositive = function (a, b) {
        return Impl.cmpPositive(a, b) >= 0 ? a : b;
    };

    ZERO = Impl.newValue({ kind: "finite", n: 0 });
    ONE = Impl.newValue({ kind: "finite", n: 1 });
    TEN = Impl.newValue({ kind: "finite", n: 10 });
    NAN = Impl.newValue({ kind: "nan" });
    CAP = Impl.newValue({ kind: "cap", sign: 1 });
    MAX_TOWER = Impl.newValue({ kind: "tower", sign: 1, rank: Rank.TOP, m: 9.999999999 });
    NEG_MAX_TOWER = Impl.newValue({ kind: "tower", sign: -1, rank: Rank.TOP, m: 9.999999999 });
    NEG_CAP = Impl.newValue({ kind: "cap", sign: -1 });
    GRAHAM = Named.new("GRAHAM", undefined, 1, 1, 1, 0);
    TREE3 = Named.new("TREE", 3, 1, 1, 1, 0);
    TREE4 = Named.new("TREE", 4, 1, 1, 1, 0);
    SSCG2 = Impl.fromLog10Value(Impl.finite(SSCG2_LOG10));
    SSCG3 = Named.new("SSCG", 3, 1, 1, 1, 0);
    SSCG4 = Named.new("SSCG", 4, 1, 1, 1, 0);
    LOADER = Named.new("LOADER", 5, 1, 1, 1, 0);
    BB5 = Impl.finite(4098);
    BB6 = Named.new("BB", 6, 1, 1, 1, 0);
    RAYO = Named.new("RAYO", RAYO_INDEX, 1, 1, 1, 0);
    FISH7 = Named.new("FISH7", 7, 1, 1, 1, 0);
    ALEPH0 = Card.plain("aleph", Idx.fin(ZERO), 1);
    ALEPH1 = Card.plain("aleph", Idx.fin(ONE), 1);
    ALEPH2 = Card.plain("aleph", Idx.fin(Impl.finite(2)), 1);
    ALEPH3 = Card.plain("aleph", Idx.fin(Impl.finite(3)), 1);
    ALEPH_OMEGA = Card.plain("aleph", Idx.ord(Rank.OMEGA), 1);
    BETH0 = Card.plain("beth", Idx.fin(ZERO), 1);
    BETH1 = Card.plain("beth", Idx.ord(Rank.addFinite(Rank.ZERO, 1)), 1);
    ALEPH_FP1 = Card.fixed("aleph", Idx.fin(ONE), 1);

    // Family indices also accept ordinal spellings, and asValue("omega") is
    // NaN while TREE(omega) is a legal formal value, so the raw argument is
    // resolved here. Finite ranks stay on the value path: TREE("1") must
    // remain Friedman's 1.
    Impl.indexSource = function (n) {
        if (typeof n === "string" || (typeof n === "object" && n !== null && !Impl.isZuba(n))) {
            const r = Impl.rankFromAny(n);
            if (r !== null && !Rank.isFinite(r)) {
                return Idx.ord(r);
            }
        }
        return Impl.asValue(n);
    };

    // A non-double index keeps the value formal: TREE(TREE(3)) and TREE(omega)
    // are named values inside the TREE band, ordered by their index.
    Impl.treeValue = function (n) {
        if (n.kind !== "finite") {
            return Named.new("TREE", n, 1, 1, 1, 0);
        }
        const idx = n.n;
        if (isnan(idx) || idx !== Math.floor(idx) || idx < 1) {
            return NAN;
        }
        if (idx === 1) {
            return ONE;
        } else if (idx === 2) {
            // Friedman's values: TREE(1) = 1, TREE(2) = 3, TREE(3) is the huge one.
            return Impl.finite(3);
        }
        return Named.new("TREE", idx, 1, 1, 1, 0);
    };

    Impl.sscgValue = function (n) {
        if (n.kind !== "finite") {
            return Named.new("SSCG", n, 1, 1, 1, 0);
        }
        const idx = n.n;
        if (isnan(idx) || idx !== Math.floor(idx) || idx < 0) {
            return NAN;
        }
        if (idx === 0) {
            return Impl.finite(2);
        } else if (idx === 1) {
            return Impl.finite(5);
        } else if (idx === 2) {
            return Impl.copy(SSCG2);
        }
        return Named.new("SSCG", idx, 1, 1, 1, 0);
    };

    Impl.loaderValue = function (n) {
        if (n.kind !== "finite") {
            return Named.new("LOADER", n, 1, 1, 1, 0);
        }
        const idx = n.n;
        if (isnan(idx) || idx !== Math.floor(idx) || idx < 0) {
            return NAN;
        }
        if (idx === 0) {
            return Impl.finite(99);
        }
        return Named.new("LOADER", idx, 1, 1, 1, 0);
    };

    Impl.bbValue = function (n) {
        if (n.kind !== "finite") {
            return Named.new("BB", n, 1, 1, 1, 0);
        }
        const idx = n.n;
        if (isnan(idx) || idx !== Math.floor(idx) || idx < 0) {
            return NAN;
        }
        if (idx === 0) {
            return ZERO;
        } else if (idx === 1) {
            return ONE;
        } else if (idx === 2) {
            return Impl.finite(4);
        } else if (idx === 3) {
            return Impl.finite(6);
        } else if (idx === 4) {
            return Impl.finite(13);
        } else if (idx === 5) {
            return BB5;
        }
        return Named.new("BB", idx, 1, 1, 1, 0);
    };

    // Rayo(n) is the smallest number above everything nameable in first-order
    // set theory with at most n symbols; Rayo's number is Rayo(10^100).
    // Indices below the googol-symbol anchor are not guaranteed to be
    // mega-scale, so the named band starts at RAYO_INDEX instead of
    // mis-ranking small Rayo values.
    Impl.rayoValue = function (n) {
        if (n.kind !== "finite") {
            return Named.new("RAYO", n, 1, 1, 1, 0);
        }
        const idx = n.n;
        if (isnan(idx) || idx !== Math.floor(idx) || idx < RAYO_INDEX) {
            return NAN;
        }
        if (idx === RAYO_INDEX) {
            return Impl.copy(RAYO);
        }
        return Named.new("RAYO", idx, 1, 1, 1, 0);
    };

    // Fish numbers 1-6 sit below Rayo's number and their place among TREE,
    // LOADER and BB is not established here, so only Fish number 7 is modeled.
    Impl.fishValue = function (n) {
        if (n.kind !== "finite") {
            return NAN;
        }
        if (n.n !== 7) {
            return NAN;
        }
        return Impl.copy(FISH7);
    };

    const ACK_TWO = Impl.finite(2);
    const ACK_THREE = Impl.finite(3);
    const ACK_HEAD = nilMap();
    ACK_HEAD.ack = true;
    ACK_HEAD.ackermann = true;

    // A(0,n) = n+1 and A(m,n) = H_m(2, n+3) - 3 for m >= 1, so the whole
    // Ackermann ladder rides the existing hyperoperation model instead of
    // adding a kind of its own. Small levels come out exact (A(4,1) = 65533);
    // a level past the exact window stays a formal H value, so the function
    // never saturates.
    Impl.ackermannValue = function (m, n) {
        const mv = Impl.asValue(m);
        if (mv.kind !== "finite") {
            return NAN;
        }
        const mi = mv.n;
        if (!isfinite(mi) || mi !== numfloor(mi) || mi < 0) {
            return NAN;
        }
        const nv = Impl.asValue(n);
        if (nv.kind === "nan" || Impl.signOf(nv) < 0) {
            return NAN;
        }
        if (mi === 0) {
            return Impl.addValues(nv, ONE);
        }
        const h = Impl.hyperValue(mi, ACK_TWO, Impl.addValues(nv, ACK_THREE));
        if (h.kind === "nan") {
            return NAN;
        }
        return Impl.subValues(h, ACK_THREE);
    };

    Impl.parseAck = function (s, depth) {
        const t = stripSpace(lowerText(s));
        const call = Named.splitCall(t);
        if (call === null) {
            return null;
        }
        const head = call[0];
        const inner = call[1];
        if (head === null || inner === "" || !ACK_HEAD[head]) {
            return null;
        }
        const parts = Hyper.splitArgs(inner);
        if (parts === null || parts.length !== 2) {
            return null;
        }
        const d = (depth === undefined || depth === null ? 0 : depth) + 1;
        return Impl.ackermannValue(Impl.parseString(parts[0], d), Impl.parseString(parts[1], d));
    };


    // Arithmetic ------------------------------------------------------------

    Impl.signedMagnitude = function (sign, mag) {
        if (sign > 0) {
            return mag;
        }
        if (Impl.isZero(mag)) {
            return ZERO;
        }
        if (mag.kind === "cap") {
            return sign > 0 ? CAP : NEG_CAP;
        } else if (mag.kind === "named") {
            return Named.withSign(mag, sign);
        }
        return Impl.negate(mag);
    };

    Impl.magAdd = function (a, b) {
        const la = Impl.log10Value(a);
        const lb = Impl.log10Value(b);
        if (la.kind === "finite" && lb.kind === "finite") {
            const hi = Math.max(la.n, lb.n);
            const lo = Math.min(la.n, lb.n);
            let s;
            if (hi - lo > 16) {
                s = hi;
            } else {
                s = hi + log10(1 + pow10(lo - hi));
            }
            return Impl.fromLog10Value(Impl.finite(s));
        }
        return Impl.maxPositive(a, b);
    };

    Impl.magSub = function (a, b) {
        if (Impl.cmpPositive(a, b) === 0) {
            return ZERO;
        }
        if (a.kind === "finite" && b.kind === "finite") {
            const v = a.n - b.n;
            if (v > 0 && isfinite(v)) {
                return Impl.finite(v);
            }
        }
        const la = Impl.log10Value(a);
        const lb = Impl.log10Value(b);
        if (la.kind === "finite" && lb.kind === "finite") {
            const diff = lb.n - la.n;
            if (diff > 0) {
                return ZERO;
            }
            const ratio = pow10(diff);
            if (ratio >= 1) {
                return ZERO;
            }
            const s = la.n + log10(1 - ratio);
            if (s === -Infinity) {
                return ZERO;
            }
            return Impl.fromLog10Value(Impl.finite(s));
        }
        return a;
    };

    Impl.magMul = function (a, b) {
        if (Impl.isZero(a) || Impl.isZero(b)) {
            return ZERO;
        }
        if (Impl.tierOf(a) >= 3 || Impl.tierOf(b) >= 3) {
            // Above the finite bands a product is the larger factor; this keeps
            // hierarchy values ordered by tier instead of falling through the
            // logarithm, which has no answer for them.
            return Impl.maxPositive(a, b);
        }
        const af = a.kind === "finite";
        const bf = b.kind === "finite";
        if (af && bf) {
            const p = a.n * b.n;
            if (isfinite(p)) {
                return Impl.finite(p);
            }
            return Impl.fromLog10Value(Impl.finite(log10(a.n) + log10(b.n)));
        }
        if (af || bf) {
            const f = af ? a : b;
            const t = af ? b : a;
            if (f.n === 1) {
                return t;
            }
            const lt = Impl.log10Value(t);
            const lf = log10(f.n);
            if (lt.kind === "tower") {
                return t;
            }
            return Impl.fromLog10Value(Impl.finite(lt.n + lf));
        }
        const la = Impl.log10Value(a);
        const lb = Impl.log10Value(b);
        if (la.kind === "finite" && lb.kind === "finite") {
            return Impl.fromLog10Value(Impl.finite(la.n + lb.n));
        }
        if (la.kind === "tower" && lb.kind === "tower") {
            return Impl.maxPositive(a, b);
        } else if (la.kind === "tower") {
            return a;
        }
        return b;
    };

    Impl.magDiv = function (a, b) {
        if (Impl.isZero(b)) {
            return NAN;
        }
        if (Impl.isZero(a)) {
            return ZERO;
        }
        if (Impl.tierOf(a) >= 3 || Impl.tierOf(b) >= 3) {
            const c = Impl.cmpPositive(a, b);
            if (c === 0) {
                return ONE;
            } else if (c > 0) {
                return a;
            }
            return ZERO;
        }
        const af = a.kind === "finite";
        const bf = b.kind === "finite";
        if (af && bf) {
            const q = a.n / b.n;
            if (isfinite(q) && q > 0) {
                return Impl.finite(q);
            }
            return Impl.fromLog10Value(Impl.finite(log10(a.n) - log10(b.n)));
        }
        const la = Impl.log10Value(a);
        const lb = Impl.log10Value(b);
        if (la.kind === "finite" && lb.kind === "finite") {
            return Impl.fromLog10Value(Impl.finite(la.n - lb.n));
        } else if (la.kind === "tower" && lb.kind === "tower") {
            const cmp = Impl.cmpPositive(la, lb);
            if (cmp === 0) {
                return ONE;
            } else if (cmp > 0) {
                // The ratio is beyond tower precision; returning the larger
                // operand keeps ordering monotone instead of collapsing to 1.
                return a;
            }
            return ZERO;
        } else if (la.kind === "tower") {
            return a;
        }
        return ZERO;
    };

    Impl.addValues = function (a, b) {
        if (a.kind === "nan" || b.kind === "nan") {
            return NAN;
        }
        if (a.kind === "finite" && b.kind === "finite") {
            const s = a.n + b.n;
            if (isfinite(s)) {
                return Impl.finite(s);
            }
        }
        if (a.kind === "cap" || b.kind === "cap") {
            const ca = a.kind === "cap";
            const cb = b.kind === "cap";
            if (ca && cb) {
                if (a.sign === b.sign) {
                    return a.sign > 0 ? CAP : NEG_CAP;
                }
                // Formal bound: LIMIT - LIMIT is zero by convention.
                return ZERO;
            }
            const c = ca ? a : b;
            return c.sign > 0 ? CAP : NEG_CAP;
        }
        const sa = Impl.signOf(a);
        const sb = Impl.signOf(b);
        if (sa === 0) {
            return Impl.copy(b);
        } else if (sb === 0) {
            return Impl.copy(a);
        }
        if (a.kind === "card" || b.kind === "card") {
            return Card.addValues(a, b);
        }
        const an = a.kind === "named";
        const bn = b.kind === "named";
        if (an || bn) {
            if (an && bn) {
                return Named.addValues(a, b);
            }
            const nv = an ? a : b;
            const other = an ? b : a;
            if (other.kind === "tower" && !Rank.isFinite(other.rank)) {
                return Impl.copy(other);
            } else if (other.kind === "finite") {
                return Named.addFinite(nv, other.n);
            } else if (other.kind === "hyper") {
                // Named plus a band value: the larger magnitude dominates at
                // tier resolution, so TREE3 + H(100, TREE3, 2) keeps the hyper.
                const cmp = Impl.compareBand2Positive(nv, other);
                if (cmp === 0) {
                    return ZERO;
                }
                return Impl.copy(cmp > 0 ? nv : other);
            }
            return Impl.copy(nv);
        }
        const ah = a.kind === "hyper";
        const bh = b.kind === "hyper";
        if (ah || bh) {
            if (ah && bh) {
                return Hyper.addValues(a, b);
            }
            const hv = ah ? a : b;
            const other = ah ? b : a;
            if (other.kind === "tower" && !Rank.isFinite(other.rank)) {
                return Impl.copy(other);
            } else if (other.kind === "finite") {
                return Hyper.addFinite(hv, other.n);
            }
            return Impl.copy(hv);
        }
        if (a.kind === "tower" && b.kind === "tower") {
            // Two towers combine by absorbing the smaller one unless both are
            // rank-2, where a factor of two can still move the mantissa. This
            // skips magnitude copies and two log/parts round trips.
            const fa = Rank.isFinite(a.rank);
            const fb = Rank.isFinite(b.rank);
            const tight = fa && fb && Rank.finiteValue(a.rank) <= 2
                && Rank.finiteValue(b.rank) <= 2;
            if (!tight) {
                let rc = Rank.compare(a.rank, b.rank);
                if (rc === 0) {
                    if (a.m === b.m) {
                        return sa === sb ? Impl.copy(a) : ZERO;
                    }
                    rc = a.m < b.m ? -1 : 1;
                }
                return Impl.copy(rc > 0 ? a : b);
            }
        }
        const ma = Impl.magnitude(a);
        const mb = Impl.magnitude(b);
        if (sa === sb) {
            return Impl.signedMagnitude(sa, Impl.magAdd(ma, mb));
        }
        const cmp = Impl.cmpPositive(ma, mb);
        if (cmp === 0) {
            return ZERO;
        } else if (cmp > 0) {
            return Impl.signedMagnitude(sa, Impl.magSub(ma, mb));
        }
        return Impl.signedMagnitude(sb, Impl.magSub(mb, ma));
    };

    Impl.subValues = function (a, b) {
        if (a.kind === "nan" || b.kind === "nan") {
            return NAN;
        }
        if (a.kind === "finite" && b.kind === "finite") {
            const d = a.n - b.n;
            if (isfinite(d)) {
                return Impl.finite(d);
            }
        }
        return Impl.addValues(a, Impl.negate(b));
    };

    Impl.mulValues = function (a, b) {
        if (a.kind === "nan" || b.kind === "nan") {
            return NAN;
        }
        if (a.kind === "finite" && b.kind === "finite") {
            const p = a.n * b.n;
            if (isfinite(p)) {
                return Impl.finite(p);
            }
        }
        const sa = Impl.signOf(a);
        const sb = Impl.signOf(b);
        if (sa === 0 || sb === 0) {
            return ZERO;
        }
        if (a.kind === "cap" || b.kind === "cap") {
            const sign = sa * sb;
            return sign > 0 ? CAP : NEG_CAP;
        }
        if (a.kind === "card" || b.kind === "card") {
            return Card.mulValues(a, b);
        }
        const an = a.kind === "named";
        const bn = b.kind === "named";
        if (an || bn) {
            if (an && bn) {
                return Named.mul(a, b);
            }
            const nv = an ? a : b;
            const other = an ? b : a;
            if (other.kind === "tower" && !Rank.isFinite(other.rank)) {
                return Impl.signedMagnitude(sa * sb, Impl.magnitude(other));
            } else if (other.kind === "finite") {
                return Named.mulFinite(nv, other.n);
            } else if (other.kind === "hyper") {
                // Products stay in the band of the larger factor; the smaller
                // factor is below the band's resolution.
                const big = Impl.compareBand2Positive(nv, other) >= 0 ? nv : other;
                return Impl.signedMagnitude(sa * sb, Impl.magnitude(big));
            }
            return Named.withSign(nv, sa * sb);
        }
        const ah = a.kind === "hyper";
        const bh = b.kind === "hyper";
        if (ah || bh) {
            if (ah && bh) {
                return Hyper.mul(a, b);
            }
            const hv = ah ? a : b;
            const other = ah ? b : a;
            if (other.kind === "finite") {
                return Hyper.mulFinite(hv, other.n);
            } else if (other.kind === "tower") {
                return Impl.signedMagnitude(sa * sb, Impl.magnitude(other));
            }
            return Hyper.withSign(hv, sa * sb);
        }
        const mag = Impl.magMul(Impl.magnitude(a), Impl.magnitude(b));
        return Impl.signedMagnitude(sa * sb, mag);
    };

    Impl.divValues = function (a, b) {
        if (a.kind === "nan" || b.kind === "nan") {
            return NAN;
        }
        if (b.kind === "finite" && b.n === 0) {
            return NAN;
        }
        if (a.kind === "finite" && b.kind === "finite") {
            const q = a.n / b.n;
            if (isfinite(q)) {
                return Impl.finite(q);
            }
        }
        if (a.kind === "cap" && b.kind === "cap") {
            return ONE;
        } else if (a.kind === "cap") {
            const sign = Impl.signOf(a) * Impl.signOf(b);
            return sign > 0 ? CAP : NEG_CAP;
        } else if (b.kind === "cap") {
            return ZERO;
        }
        const sa = Impl.signOf(a);
        const sb = Impl.signOf(b);
        if (sa === 0) {
            return ZERO;
        }
        if (a.kind === "card" || b.kind === "card") {
            return Card.divValues(a, b);
        }
        if (a.kind === "fgh" || b.kind === "fgh") {
            // A formal hierarchy value has no logarithm, so the ratio follows the
            // comparison: equal levels give 1, the larger operand absorbs the
            // division and the smaller side collapses to zero.
            const c = Impl.cmpPositive(Impl.magnitude(a), Impl.magnitude(b));
            if (c === 0) {
                return ONE;
            } else if (c > 0) {
                return Impl.signedMagnitude(sa * sb, Impl.magnitude(a));
            }
            return ZERO;
        }
        const ah = a.kind === "hyper";
        const bh = b.kind === "hyper";
        if (ah || bh) {
            if (ah && bh) {
                return Hyper.div(a, b);
            } else if (ah) {
                if (b.kind === "finite") {
                    return Hyper.mulFinite(a, 1 / b.n);
                } else if (b.kind === "tower" && Rank.isFinite(b.rank)) {
                    return Impl.copy(a);
                } else if (b.kind === "named") {
                    const cmp = Impl.compareBand2Positive(a, b);
                    if (cmp > 0) {
                        return Impl.signedMagnitude(sa * sb, Impl.magnitude(a));
                    }
                }
                return ZERO;
            }
            if (a.kind === "named") {
                const cmp = Impl.compareBand2Positive(a, b);
                if (cmp > 0) {
                    return Impl.signedMagnitude(sa * sb, Impl.magnitude(a));
                }
                return ZERO;
            } else if (a.kind === "tower" && !Rank.isFinite(a.rank)) {
                return Impl.signedMagnitude(sa * sb, Impl.magnitude(a));
            }
            return ZERO;
        }
        const an = a.kind === "named";
        const bn = b.kind === "named";
        if (an || bn) {
            if (an && bn) {
                return Named.div(a, b);
            }
            if (an) {
                if (b.kind === "finite") {
                    return Named.mulFinite(a, 1 / b.n);
                } else if (b.kind === "tower" && !Rank.isFinite(b.rank)) {
                    return ZERO;
                }
                return Impl.copy(a);
            }
            if (a.kind === "finite" || Rank.isFinite(a.rank)) {
                // A finite value divided by a named-mega value is far below
                // the smallest double this library can represent.
                return ZERO;
            }
            return Impl.signedMagnitude(sa * sb, Impl.magnitude(a));
        }
        const mag = Impl.magDiv(Impl.magnitude(a), Impl.magnitude(b));
        return Impl.signedMagnitude(sa * sb, mag);
    };

    Impl.magPow = function (a, b) {
        const la = Impl.log10Value(a);
        if (la.kind === "nan") {
            return NAN;
        } else if (Impl.isZero(la)) {
            return ONE;
        }
        return Impl.fromLog10Value(Impl.mulValues(la, b));
    };

    Impl.powValues = function (a, b) {
        if (a.kind === "nan" || b.kind === "nan") {
            return NAN;
        }
        const sb = Impl.signOf(b);
        if (sb === 0) {
            return ONE;
        }
        const sa = Impl.signOf(a);
        if (sa === 0) {
            if (sb > 0) {
                return ZERO;
            }
            return NAN;
        }
        if (b.kind === "cap") {
            if (a.kind === "finite") {
                if (a.n === 1) {
                    return ONE;
                } else if (a.n === -1) {
                    return NAN;
                } else if (Math.abs(a.n) < 1) {
                    return ZERO;
                } else if (a.n < 0) {
                    return NAN;
                }
            }
            return CAP;
        }
        if (a.kind === "cap") {
            if (sb < 0) {
                return ZERO;
            }
            if (a.sign < 0) {
                if (b.kind !== "finite" || b.n !== Math.floor(b.n)) {
                    return NAN;
                }
                return Math.abs(b.n) % 2 === 1 ? NEG_CAP : CAP;
            }
            return CAP;
        }
        if (a.kind === "card" || b.kind === "card") {
            const v = Card.powValues(a, b);
            if (v !== null) {
                return v;
            }
        }

        if (a.kind === "finite" && b.kind === "finite") {
            const v = Math.pow(a.n, b.n);
            if (isfinite(v)) {
                return Impl.finite(v);
            }
            if (a.n < 0 && b.n !== Math.floor(b.n)) {
                return NAN;
            }
        }

        if (sb < 0) {
            return Impl.divValues(ONE, Impl.powValues(a, Impl.negate(b)));
        }

        if (b.kind === "tower" && !Rank.isFinite(b.rank)
            && (a.kind === "named" || a.kind === "hyper")) {
            // A finite megascale base to a transfinite exponent stays a tower.
            if (sa < 0) {
                return NAN;
            }
            return Impl.fromLog10Value(Impl.copy(b));
        }

        if (a.kind === "hyper" || b.kind === "hyper") {
            if (a.kind === "hyper" && b.kind === "finite") {
                const mag = Hyper.pow(Impl.magnitude(a), b.n);
                if (sa < 0) {
                    if (b.n !== Math.floor(b.n)) {
                        return NAN;
                    }
                    const odd = Math.abs(b.n) % 2 === 1;
                    return Impl.signedMagnitude(odd ? -1 : 1, mag);
                }
                return mag;
            }
            if (a.kind === "finite") {
                if (a.n === 1) {
                    return ONE;
                } else if (a.n === -1) {
                    return NAN;
                } else if (Math.abs(a.n) < 1) {
                    return ZERO;
                }
            }
            if (sa < 0) {
                // The parity of a non-finite exponent is not representable here.
                return NAN;
            }
            // A non-finite exponent makes a finite base impossible to
            // double-expand, so keep the power as an anchored expression.
            if (Hyper.eligible(a) && Hyper.eligible(b)) {
                return Hyper.new(3, a, b);
            }
            return CAP;
        }

        if (a.kind === "named") {
            if (b.kind === "named"
                || (b.kind === "tower" && Rank.isFinite(b.rank))) {
                if (sa < 0) {
                    return NAN;
                }
                if (Hyper.eligible(a) && Hyper.eligible(b)) {
                    return Hyper.new(3, a, b);
                }
                return CAP;
            }
            if (b.kind !== "finite") {
                return CAP;
            }
            const mag = Named.pow(Impl.magnitude(a), b.n);
            if (sa < 0) {
                if (b.n !== Math.floor(b.n)) {
                    return NAN;
                }
                const odd = Math.abs(b.n) % 2 === 1;
                return Impl.signedMagnitude(odd ? -1 : 1, mag);
            }
            return mag;
        }

        if (b.kind === "named") {
            if (a.kind === "finite") {
                if (a.n === 1) {
                    return ONE;
                } else if (a.n === -1) {
                    return NAN;
                } else if (Math.abs(a.n) < 1) {
                    return ZERO;
                } else if (a.n < 0) {
                    return NAN;
                }
            } else if (sa < 0) {
                return NAN;
            }
            if (Hyper.eligible(a) && Hyper.eligible(b)) {
                return Hyper.new(3, a, b);
            }
            if (a.kind === "tower") {
                // An infinite tower to a finite mega exponent is still a
                // tower: the exponent shifts the rank by one, not to LIMIT.
                return Impl.signedMagnitude(1, Impl.magPow(Impl.magnitude(a), Impl.magnitude(b)));
            }
            return CAP;
        }

        if (sa < 0) {
            if (b.kind !== "finite" || b.n !== Math.floor(b.n)) {
                return NAN;
            }
            const mag = Impl.magPow(Impl.magnitude(a), Impl.magnitude(b));
            const odd = Math.abs(b.n) % 2 === 1;
            return Impl.signedMagnitude(odd ? -1 : 1, mag);
        }

        if (a.kind === "finite" && b.kind === "finite") {
            const v = Math.pow(a.n, b.n);
            if (isfinite(v) && v > 0) {
                return Impl.finite(v);
            }
        }

        return Impl.magPow(a, b);
    };

    Impl.tetrateValue = function (x, count) {
        if (x.kind === "nan") {
            return NAN;
        }
        if (Impl.signOf(x) <= 0 && !Impl.isZero(x)) {
            return NAN;
        }
        const sx = Impl.signOf(x);
        if (sx === 0) {
            return Impl.isZero(count) ? ONE : ZERO;
        }
        if (x.kind === "finite" && x.n === 1) {
            return ONE;
        }

        let n;
        if (count.kind === "finite") {
            n = count.n;
            if (n < 0) {
                return NAN;
            }
            if (n < 1) {
                return ONE;
            }
            n = Math.floor(n);
        } else if (count.kind === "named" || count.kind === "hyper"
            || (count.kind === "tower" && Rank.isFinite(count.rank))) {
            // A finite count too large to iterate is still a finite height.
            if (Hyper.eligible(x) && Hyper.eligible(count)) {
                return Hyper.new(4, x, count);
            }
            return CAP;
        } else {
            // A transfinite iteration count is past every finite tower height.
            const parts = Impl.partsFromPositive(Impl.magnitude(x));
            if (parts === null) {
                // A named or hyper base has no tower mantle; height omega is
                // still an ordinary infinite tower, never LIMIT.
                return Impl.fromParts(Rank.OMEGA, 9);
            }
            return Impl.fromParts(Rank.add(Rank.OMEGA, parts[0]), parts[1]);
        }

        if (n === 0) {
            return ONE;
        } else if (n === 1) {
            return Impl.copy(x);
        }
        if (x.kind === "named" || x.kind === "hyper") {
            // A named base dwarfs the range where iterated powers stay a plain
            // tower; keep the tetration itself as an anchored finite value.
            if (Hyper.eligible(x) && Hyper.eligible(count)) {
                return Hyper.new(4, x, count);
            }
            return CAP;
        }

        let y = x;
        let steps = 1;
        const limit = Math.min(n, 32);
        while (steps < limit) {
            y = Impl.powValues(x, y);
            steps = steps + 1;
            if (y.kind === "cap") {
                return CAP;
            }
        }

        if (n > steps) {
            const parts = Impl.partsFromPositive(Impl.magnitude(y));
            if (parts !== null && y.kind === "tower") {
                return Impl.fromParts(Rank.addFinite(parts[0], n - steps), parts[1]);
            }
            // Slow-converging bases below 2 stay finite for a long time.
            while (steps < Math.min(n, 128)) {
                y = Impl.powValues(x, y);
                steps = steps + 1;
                if (y.kind === "cap") {
                    return CAP;
                }
            }
            return y;
        }
        return y;
    };

    Impl.pentateValue = function (x, count) {
        const finiteCount = count.kind === "finite";
        if (!finiteCount) {
            const finiteHeight = count.kind === "named" || count.kind === "hyper"
                || (count.kind === "tower" && Rank.isFinite(count.rank));
            if (finiteHeight) {
                if (Hyper.eligible(x) && Hyper.eligible(count)) {
                    return Hyper.new(5, x, count);
                }
                return CAP;
            }
            return Impl.fromParts(Rank.OMEGA, 9);
        }
        const n = Math.floor(count.n);
        if (n < 0) {
            return NAN;
        } else if (n === 0) {
            return ONE;
        } else if (n === 1) {
            return Impl.copy(x);
        }
        if (n > 8) {
            if (Hyper.eligible(x) && Hyper.eligible(count)) {
                return Hyper.new(5, x, count);
            }
            return CAP;
        }
        if (x.kind === "named" || x.kind === "hyper") {
            if (Hyper.eligible(x) && Hyper.eligible(count)) {
                return Hyper.new(5, x, count);
            }
            return CAP;
        }
        let y = x;
        for (let i = 2; i <= n; i++) {
            y = Impl.tetrateValue(x, y);
            if (y.kind === "cap") {
                return CAP;
            }
            if (y.kind === "hyper") {
                if (Hyper.eligible(x)) {
                    return Hyper.new(5, x, count);
                }
                return CAP;
            }
        }
        return y;
    };

    // Conversion, formatting, serialization ---------------------------------

    Impl.asValue = function (v) {
        if (Impl.isZuba(v)) {
            return v;
        }
        return ZubaNum.new(v);
    };

    Impl.formatNumber = function (n) {
        if (n !== n) {
            return "NaN";
        }
        if (n === Infinity) {
            return "Infinity";
        } else if (n === -Infinity) {
            return "-Infinity";
        }
        const a = Math.abs(n);
        if (a !== 0 && (a < 1e-4 || a >= 1e15)) {
            return formatG(n, 6);
        }
        if (n === Math.floor(n)) {
            return formatFixed(n, 0);
        }
        return formatG(n, 10);
    };

    Impl.formatMantissa = function (m) {
        if (m === Math.floor(m)) {
            return formatFixed(m, 0);
        }
        return formatG(m, 15);
    };

    Impl.format = function (v, style) {
        if (v.kind === "nan") {
            return "NaN";
        } else if (v.kind === "cap") {
            return v.sign > 0 ? "LIMIT" : "-LIMIT";
        } else if (v.kind === "named") {
            return Named.format(v);
        } else if (v.kind === "hyper") {
            if (style === "nest") {
                const nest = Impl.nestInfo(v);
                // Only a chain with a real nested node gets shorter: H(4,2,2) would
                // rewrite to H(5,2,2) and then to H(6,2,2) forever, so a depth-1
                // value prints as itself and the rewrite is not re-applied.
                if (nest !== null && nest.depth > 1) {
                    return Impl.format(Impl.nestValue(nest.level, nest.base, nest.count));
                }
            }
            return Hyper.format(v);
        } else if (v.kind === "card") {
            return Card.format(v);
        } else if (v.kind === "fgh") {
            return Fgh.format(v);
        } else if (v.kind === "finite") {
            return Impl.formatNumber(v.n);
        }

        const sign = v.sign < 0 ? "-" : "";
        const mant = Impl.formatMantissa(v.m);
        const rank = v.rank;
        if (style === "rank" || !Rank.isFinite(rank)) {
            return sign + "T(" + Rank.toString(rank) + ", " + mant + ")";
        }
        const h = Rank.finiteValue(rank);
        if (h <= 4) {
            let out = sign;
            for (let i = 0; i < h; i++) {
                out = out + "10^";
            }
            return out + mant;
        }
        return sign + "T(" + Rank.toString(rank) + ", " + mant + ")";
    };

    // Rank atom spellings. Greek glyphs are listed in both cases because the
    // lowercasing is byte-wise and leaves UTF-8 sequences untouched. The psi
    // spellings are the collapsing-function names of the same ordinals:
    // psi(Omega) = eps0, psi(Omega^2) = Gamma_0, psi(Omega^omega) = SVO,
    // psi(Omega^Omega) = BHO, and the Buchholz ladder above it.
    const RANK_ALIASES = nilMap();
    const rankAlias = (atom, ...names) => {
        for (let i = 0; i < names.length; i++) {
            RANK_ALIASES[names[i]] = atom;
        }
    };
    rankAlias({ k: "omega" }, "ω", "Ω", "omega", "w");
    rankAlias({ k: "phi", n: 1 }, "ε₀", "ε0", "epsilon0", "eps0", "epsilon", "ψ(Ω)");
    rankAlias({ k: "phi", n: 2 }, "ζ₀", "ζ0", "zeta0", "zeta");
    rankAlias({ k: "phi", n: 3 }, "η₀", "η0", "eta0", "eta");
    rankAlias({ k: "gamma" }, "γ₀", "Γ₀", "γ0", "gamma0", "gamma",
        "fefermanschutte", "fs", "ψ(Ω^2)", "ψ(Ω²)");
    rankAlias({ k: "gamma_omega" }, "γω", "Γω", "gammaomega");
    rankAlias({ k: "svo" }, "svo", "smallveblen", "smallveblenordinal",
        "φ(1@ω)", "ψ(Ω^ω)");
    rankAlias({ k: "lvo" }, "lvo", "largeveblen", "largeveblenordinal", "φ(1@(1@ω))");
    rankAlias({ k: "bho" }, "bho", "bachmannhoward", "bachmannhowardordinal", "ψ(Ω^Ω)");
    rankAlias({ k: "sbo" }, "sbo", "smallbuchholz", "smallbuchholzordinal",
        "ψ(Ω^(Ω^ω))");
    rankAlias({ k: "lbo" }, "lbo", "largebuchholz", "largebuchholzordinal",
        "ψ(Ω^(Ω^Ω))");
    rankAlias({ k: "tfb" }, "tfb", "takeutifefermanbuchholz");
    rankAlias({ k: "ebho" }, "ebho", "extendedbuchholz", "extendedbuchholzordinal");
    rankAlias({ k: "weak_inv" }, "i", "wi", "inaccessible", "weakinaccessible",
        "weaklyinaccessible");
    rankAlias({ k: "weak_mahlo" }, "m", "wm", "mahlo", "weakmahlo", "weaklymahlo");
    rankAlias({ k: "weak_compact" }, "k", "wc", "weakcompact", "weaklycompact");

    // string.lower is byte-based and leaves UTF-8 sequences untouched, so Γ
    // survives as Γ and the alias table has to carry both Greek cases itself.
    Impl.parseRankAtom = function (name) {
        // Whitespace, hyphens and underscores carry no meaning in a rank
        // spelling, so they are stripped once here instead of being enumerated
        // in every alias.
        const low = lowerText(name).replace(SPACE_RE, "").replace(/[-_]/g, "");
        const atom = RANK_ALIASES[low];
        if (atom !== undefined) {
            return atom;
        }

        const n = match1(low, /^φ\(([0-9]+)\)$/)
            || match1(low, /^φ\(([0-9]+),0\)$/)
            || match1(low, /^phi\(([0-9]+)\)$/)
            || match1(low, /^phi\(([0-9]+),0\)$/);
        if (n !== null) {
            return { k: "phi", n: Math.max(1, tonumber(n) || 1) };
        }

        const g = match1(low, /^γ([0-9]+)$/)
            || match1(low, /^Γ([0-9]+)$/)
            || match1(low, /^gamma([0-9]+)$/);
        if (g !== null) {
            return { k: "gamma", n: Math.max(0, tonumber(g) || 0) };
        }
        return null;
    };

    Impl.parseRankString = function (s) {
        if (typeof s !== "string") {
            return null;
        }
        s = ltrimSpace(rtrimSpace(s));
        if (s === "" || s.charAt(0) === "+" || s.charAt(s.length - 1) === "+"
            || s.indexOf("++") !== -1) {
            return null;
        }
        const parts = [];
        for (const part of s.split("+")) {
            if (part.length > 0) {
                parts.push(stripSpace(part));
            }
        }
        if (parts.length === 0) {
            return null;
        }

        const terms = [];
        let fin = 0;
        for (let i = 0; i < parts.length; i++) {
            const part = parts[i];
            // The UTF-8 middle dot is normalised to '*' before matching so a
            // coefficient count can be read off either spelling.
            const normalized = part.split("·").join("*");
            let name = part;
            let count = 1;
            const star = /^(.*?)\*([0-9]+)$/.exec(normalized);
            if (star !== null) {
                name = star[1];
                count = tonumber(star[2]);
                if (!isfinite(count) || count < 1) {
                    return null;
                }
            }
            const atom = Impl.parseRankAtom(name);
            if (atom !== null) {
                terms.push({ k: atom.k, n: atom.n, c: Math.floor(count) });
            } else {
                const f = tonumberNil(name);
                if (f === undefined || i !== parts.length - 1) {
                    return null;
                }
                fin = f;
            }
        }

        return Rank.normalize({ _rank: true, terms, fin });
    };

    // Suffix and name spellings --------------------------------------------
    // Short-scale game suffixes and classical -illion names are display/parse
    // helpers only. They map onto the same finite doubles and towers as any
    // other spelling; nothing new is added to the value model.

    const Suffix = {};

    // Short-scale game marks. The first ten tiers are the game convention and
    // irreducibly arbitrary, so those ten stay typed; every tier above composes.
    // The tens marks are spelled so no composed mark can collide with a bare
    // one (Sex/Sep/Oct/Non against Sx/Sp/Oc/No), which keeps the table
    // one-to-one for parsing. The short ladder covers tier 99 (10^297); past
    // that toSuffix falls back to plain format and the -illion register carries
    // the names.
    const SHORT_BASE = ["K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No"];
    const SHORT_ONES = ["", "U", "D", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No"];
    const SHORT_TENS = ["Dc", "Vg", "Tc", "Qd", "Qu", "Sex", "Sep", "Oct", "Non"];
    Suffix.MAX_TIER = 99;

    Suffix.SHORT = nilMap();
    for (let tier = 1; tier <= 10; tier++) {
        Suffix.SHORT[3 * tier] = SHORT_BASE[tier - 1];
    }
    for (let tier = 11; tier <= Suffix.MAX_TIER; tier++) {
        const ten = numfloor((tier - 1) / 10);
        const one = (tier - 1) % 10;
        Suffix.SHORT[3 * tier] = SHORT_ONES[one] + SHORT_TENS[ten - 1];
    }

    Suffix.SHORT_EXP = nilMap();
    for (const exp of Object.keys(Suffix.SHORT)) {
        Suffix.SHORT_EXP[lowerText(Suffix.SHORT[exp])] = Number(exp);
    }

    // Composed name ladders ------------------------------------------------
    // The -illion and -plex ladders are built from roots by the loops below
    // rather than typed entry by entry, and both stop at Suffix.CAP: the root
    // there is 100,000,000 and its group form reads "mehect" ("me" = the
    // millions marker carrying "hect" = 100), so the top of the -illion ladder
    // is "mehectillion" (10^300,000,003) and the top of the -plex ladder is
    // "googolmehectaplex" (tower height 100,000,002). Naming stops there on
    // purpose; the value model reaches far past it. 10^(3*10^333+3) is a number
    // this library builds, prints and orders, it simply has no name in the
    // ladder, and past the cap toName gives null while a spelled name parses
    // as NaN.
    Suffix.CAP = 100000000;

    // The -illion register names 10^(3i) for a ladder index i, so i = 1 is
    // "thousand", i = 11 is "decillion" and the Latin root of a composed name is
    // always one less than its index. The ten irregular marks stay typed.
    const ILLION_MARK = [
        "thousand", "million", "billion", "trillion", "quadrillion",
        "quintillion", "sextillion", "septillion", "octillion", "nonillion",
    ];
    const ILLION_ONES = ["", "un", "duo", "tre", "quattuor", "quin", "sex",
        "septen", "octo", "non"];
    const ILLION_TENS = ["", "dec", "vigint", "trigint", "quadragint",
        "quinquagint", "sexagint", "septuagint", "octogint", "nonagint"];
    const ILLION_HUND = ["", "cent", "ducent", "trecent", "quadringent",
        "quingent", "sescent", "septingent", "octingent", "nongent"];

    // The -plex register is the ordinal series: k = 1 is "googolplex", k = 2 is
    // "googolduplex" and k = 11 is "googolundeciplex", so a composed stem carries
    // the root of k itself. Its ten marks are the distributive forms.
    const PLEX_MARK = ["", "du", "tri", "quadri", "quinti", "sexti", "septi",
        "octi", "noni"];
    const PLEX_ONES = ILLION_ONES;
    const PLEX_TENS = ["", "deci", "viginti", "triginti", "quadraginti",
        "quinquaginti", "sexaginti", "septuaginti", "octoginti", "nonaginti"];
    const PLEX_HUND = ["", "centi", "ducenti", "trecenti", "quadringenti",
        "quingenti", "sescenti", "septingenti", "octingenti", "nongenti"];

    const VOWELS = nilMap();
    VOWELS.a = true;
    VOWELS.e = true;
    VOWELS.i = true;
    VOWELS.o = true;
    VOWELS.u = true;
    const GROUP_HUNDRED = "hect";

    // A hundreds root and a consonant onset take the Latin "o" connective
    // ("centoduovigint"); everywhere else roots butt together ("octooctogint",
    // "nonnonagint"). One documented convention - not every connective variant
    // in the literature is reproduced, and this library always writes and reads
    // this one.
    function joinRoot(head, tail) {
        if (tail === "") {
            return head;
        }
        if (head === "") {
            return tail;
        }
        if (VOWELS[tail.charAt(0)] === true
            || VOWELS[head.charAt(head.length - 1)] === true) {
            return head + tail;
        }
        return head + "o" + tail;
    }

    // One 0..999 root group written hundreds-first, the classical order: 121 is
    // cent+un+vigint, 19 takes the "novem" form before "dec", 333 is
    // trecent+o+tre+trigint, 1e8 is "mehect" after the group pass below.
    function rootGroup(r, ones, tens, hund) {
        if (r <= 0) {
            return "";
        }
        const hundred = numfloor(r / 100);
        const ten = numfloor(r / 10) % 10;
        const one = r % 10;
        let unit = ones[one];
        if (ten === 1 && one === 9) {
            unit = "novem";
        }
        return joinRoot(hund[hundred], unit + tens[ten]);
    }

    // A group multiplier carries the hundreds form "hect" at exactly 100; the
    // other 1..999 readings reuse rootGroup.
    function multText(m, ones, tens, hund) {
        if (m === 100) {
            return GROUP_HUNDRED;
        }
        return rootGroup(m, ones, tens, hund);
    }

    // The three root slots of a ladder coordinate, marker-first:
    //   millions  -> "meg" at 1, otherwise "me" + its multiplier ("mehect" = 100)
    //   thousands -> "mil" at 1, otherwise "mil" + its multiplier
    //   units     -> the plain 0..999 group
    // A units group that follows a marker takes an "i" connective. That
    // connective is what keeps the composition one-to-one: without it "mil" +
    // 500 would read the same for 1,500 and for 500,000, and "me" + 2 the same
    // for 2,000,000 and for 1,000,002. No root begins with "i", so the
    // connective is never absorbed.
    function ladderStem(r, ones, tens, hund) {
        if (r === undefined || r === null || isnan(r) || r < 0
            || r > Suffix.CAP || r % 1 !== 0) {
            return undefined;
        }
        const millions = numfloor(r / 1000000);
        const thousands = numfloor(r / 1000) % 1000;
        const rest = r % 1000;
        let stem = "";
        if (millions > 0) {
            stem = millions === 1 ? "meg"
                : "me" + multText(millions, ones, tens, hund);
        }
        if (thousands > 0) {
            stem += thousands === 1 ? "mil"
                : "mil" + multText(thousands, ones, tens, hund);
        }
        if (rest > 0) {
            if (stem !== "") {
                stem += "i";
            }
            stem += rootGroup(rest, ones, tens, hund);
        } else if (stem === "") {
            stem = rootGroup(rest, ones, tens, hund);
        }
        return stem;
    }

    // Lazily filled memos in both directions: the ladders are endless in
    // principle, so only the names a game actually asks for cost a string, and
    // a refused lookup is remembered too rather than re-derived on every parse.
    const illionNames = nilMap();
    const illionIndexes = nilMap();
    const plexNames = nilMap();
    const plexIndexes = nilMap();

    Suffix.illionName = function (i) {
        const hit = illionNames[i];
        if (hit !== undefined) {
            return hit === false ? undefined : hit;
        }
        let out;
        if (i !== undefined && i !== null && i % 1 === 0 && i >= 1
            && i <= Suffix.CAP + 1) {
            if (i <= 10) {
                out = ILLION_MARK[i - 1];
            } else {
                const stem = ladderStem(i - 1, ILLION_ONES, ILLION_TENS, ILLION_HUND);
                if (stem !== undefined) {
                    out = stem + "illion";
                }
            }
        }
        illionNames[i] = out === undefined ? false : out;
        return out;
    };

    Suffix.plexName = function (k) {
        const hit = plexNames[k];
        if (hit !== undefined) {
            return hit === false ? undefined : hit;
        }
        let out;
        if (k !== undefined && k !== null && k % 1 === 0 && k >= 1 && k <= Suffix.CAP) {
            let stem;
            if (k <= 9) {
                stem = PLEX_MARK[k - 1];
            } else {
                stem = ladderStem(k, PLEX_ONES, PLEX_TENS, PLEX_HUND);
            }
            if (stem !== undefined) {
                // An ordinal stem runs straight into "plex"; a consonant ending
                // takes the "a" that reads "mehectaplex".
                if (stem === "") {
                    out = "googolplex";
                } else if (VOWELS[stem.charAt(stem.length - 1)] === true) {
                    out = "googol" + stem + "plex";
                } else {
                    out = "googol" + stem + "aplex";
                }
            }
        }
        plexNames[k] = out === undefined ? false : out;
        return out;
    };

    // Reading names back ----------------------------------------------------
    // The reverse scans roots the composer could have written and then
    // regenerates the name, accepting an index only when the spelling matches
    // character for character. A wrong boundary guess therefore cannot yield a
    // wrong index, and the two directions cannot drift apart.

    // Every reading of a 0..99 span, not the first one that fits: several roots
    // can start the same letters ("tre" inside "trigint", "non" inside
    // "nonagint"), and the caller decides which reading is real by regenerating
    // the name.
    function lowVals(text, ones, tens, into) {
        if (into === undefined) {
            into = [];
        }
        if (text === "") {
            into.push(0);
            return into;
        }
        const unit = [0];
        const unitLen = [0];
        for (let u = 1; u <= 9; u++) {
            const root = ones[u];
            if (root !== "" && text.startsWith(root)) {
                unit.push(u);
                unitLen.push(root.length);
            }
        }
        if (text.startsWith("novem")) {
            unit.push(9);
            unitLen.push(5);
        }
        for (let i = 0; i < unit.length; i++) {
            const rest = text.slice(unitLen[i]);
            if (rest === "") {
                into.push(unit[i]);
            } else {
                for (let t = 1; t <= 9; t++) {
                    if (rest === tens[t]) {
                        into.push(t * 10 + unit[i]);
                    }
                }
            }
        }
        return into;
    }

    // Readings of a whole 0..999 group: a plain 0..99 span, or a hundreds root
    // plus its low span with the "o" connective present or absent, and "hect"
    // alone.
    function groupVals(text, ones, tens, hund, into) {
        if (into === undefined) {
            into = [];
        }
        if (text === "") {
            into.push(0);
            return into;
        }
        if (text === GROUP_HUNDRED) {
            into.push(100);
        }
        lowVals(text, ones, tens, into);
        for (let h = 1; h <= 9; h++) {
            const root = hund[h];
            if (root !== "" && text.startsWith(root)) {
                const rest = text.slice(root.length);
                const tails = [rest];
                if (rest.charAt(0) === "o") {
                    tails.push(rest.slice(1));
                }
                for (let j = 0; j < tails.length; j++) {
                    const lows = lowVals(tails[j], ones, tens, []);
                    for (let i = 0; i < lows.length; i++) {
                        into.push(h * 100 + lows[i]);
                    }
                }
            }
        }
        return into;
    }

    // All coordinates whose stem text could be the given stem. The slots are
    // tried in the order the composer writes them, and a units group is read
    // both with and without its leading "i" connective.
    function stemRoots(stem, ones, tens, hund, limit) {
        const out = [];
        const seen = nilMap();
        const n = stem.length;

        function add(value) {
            if (value !== undefined && value >= 0 && value <= limit
                && seen[value] !== true) {
                seen[value] = true;
                out.push(value);
            }
        }

        function read(a, acc, milLeft) {
            if (a > n) {
                return;
            }
            if (a === n) {
                add(acc);
                return;
            }
            const text = stem.slice(a);
            const vals = groupVals(text, ones, tens, hund, []);
            for (let i = 0; i < vals.length; i++) {
                add(acc + vals[i]);
            }
            if (text.charAt(0) === "i") {
                const held = groupVals(text.slice(1), ones, tens, hund, []);
                for (let i = 0; i < held.length; i++) {
                    add(acc + held[i]);
                }
            }
            if (milLeft && text.startsWith("mil")) {
                read(a + 3, acc + 1000, false);
                for (let stop = a + 3; stop < n; stop++) {
                    const mult = groupVals(stem.slice(a + 3, stop + 1),
                        ones, tens, hund, []);
                    for (let i = 0; i < mult.length; i++) {
                        if (mult[i] >= 2 && mult[i] <= 999) {
                            read(stop + 1, acc + mult[i] * 1000, false);
                        }
                    }
                }
            }
        }

        read(0, 0, true);
        if (stem.startsWith("meg")) {
            read(3, 1000000, true);
        }
        if (stem.startsWith("me")) {
            for (let stop = 2; stop < n; stop++) {
                const mult = groupVals(stem.slice(2, stop + 1), ones, tens, hund, []);
                for (let i = 0; i < mult.length; i++) {
                    const m = mult[i];
                    if (m >= 2 && m <= 100) {
                        read(stop + 1, m * 1000000, true);
                    }
                }
            }
        }
        return out;
    }

    const ILLION_ROOT_LIMIT = Suffix.CAP;

    // The doubled-l spelling ("millillion", "millicentillion") is what most
    // printed tables use, while this composer writes "milillion" and
    // "milicentillion". The extra "l" is folded out and the grammar retried, so
    // both readings reach the same index; the "-iaplex" shape drops the "a" as
    // well, so both folds are tried. A name that already is "million" is a typed
    // mark and never gets here, and a name without "milli" in it produces no
    // alternate at all.
    function milAlternates(name) {
        if (name.indexOf("milli") === -1) {
            return null;
        }
        return [name.split("milli").join("mili"), name.split("millia").join("mila")];
    }

    function retryMil(name, stemIndex) {
        const alts = milAlternates(name);
        if (alts === null) {
            return undefined;
        }
        for (let j = 0; j < alts.length; j++) {
            const hit = stemIndex(alts[j]);
            if (hit !== undefined) {
                return hit;
            }
        }
        return undefined;
    }

    // Roots the composer could have written, then regenerate and accept an index
    // only when the spelling matches character for character, so the two
    // directions cannot drift apart.
    function illionStemIndex(name) {
        if (!name.endsWith("illion")) {
            return undefined;
        }
        const stem = name.slice(0, name.length - 6);
        const roots = stemRoots(stem, ILLION_ONES, ILLION_TENS, ILLION_HUND,
            ILLION_ROOT_LIMIT);
        for (let i = 0; i < roots.length; i++) {
            const index = roots[i] + 1;
            if (Suffix.illionName(index) === name) {
                return index;
            }
        }
        return undefined;
    }

    Suffix.illionIndexOf = function (name) {
        const hit = illionIndexes[name];
        if (hit !== undefined) {
            return hit === false ? undefined : hit;
        }
        let out;
        for (let i = 0; i < ILLION_MARK.length; i++) {
            if (ILLION_MARK[i] === name) {
                out = i + 1;
                break;
            }
        }
        if (out === undefined) {
            out = illionStemIndex(name);
            if (out === undefined) {
                out = retryMil(name, illionStemIndex);
            }
        }
        illionIndexes[name] = out === undefined ? false : out;
        return out;
    };

    function plexStemIndex(name) {
        if (name.length < 10 || !name.startsWith("googol") || !name.endsWith("plex")) {
            return undefined;
        }
        const stem = name.slice(6, name.length - 4);
        const tails = [stem];
        if (stem.charAt(stem.length - 1) === "a") {
            tails.push(stem.slice(0, stem.length - 1));
        }
        for (let j = 0; j < tails.length; j++) {
            const roots = stemRoots(tails[j], PLEX_ONES, PLEX_TENS, PLEX_HUND,
                Suffix.CAP);
            for (let i = 0; i < roots.length; i++) {
                const k = roots[i];
                if (k >= 10 && Suffix.plexName(k) === name) {
                    return k;
                }
            }
        }
        return undefined;
    }

    Suffix.plexIndexOf = function (name) {
        const hit = plexIndexes[name];
        if (hit !== undefined) {
            return hit === false ? undefined : hit;
        }
        let out;
        // The nine distributive marks are typed, so they read back through the
        // forward generator rather than through the root grammar.
        for (let k = 1; k <= 9; k++) {
            if (Suffix.plexName(k) === name) {
                out = k;
                break;
            }
        }
        if (out === undefined) {
            out = plexStemIndex(name);
            if (out === undefined) {
                out = retryMil(name, plexStemIndex);
            }
        }
        plexIndexes[name] = out === undefined ? false : out;
        return out;
    };

    // The typed tables these ladders replaced stay readable as views, so a game
    // that indexes them directly keeps working and only pays for the rows it
    // uses. Rows are 1-based, matching the ladder index: ILLION[1] is
    // "thousand" and PLEX[1] is "googolplex".
    function ladderView(nameAt) {
        const cache = nilMap();
        return new Proxy(cache, {
            get(target, key) {
                if (typeof key === "string" && /^[1-9][0-9]*$/.test(key)) {
                    const hit = target[key];
                    if (hit !== undefined) {
                        return hit;
                    }
                    const name = nameAt(Number(key));
                    if (name === undefined) {
                        return undefined;
                    }
                    target[key] = name;
                    return name;
                }
                return target[key];
            },
            has(target, key) {
                if (typeof key === "string" && /^[1-9][0-9]*$/.test(key)) {
                    return nameAt(Number(key)) !== undefined;
                }
                return key in target;
            },
        });
    }

    Suffix.ILLION = ladderView(Suffix.illionName);
    Suffix.PLEX = ladderView(Suffix.plexName);

    // log10 of the value an -illion index names, following the two tiers the
    // ladder doc describes. Writing f(n) = 10^(3n+3), an index i has N = i - 1
    // roots split into a meg-groups of ILLION_TIER plus a tail: while a is zero
    // the exponent is the flat 3*i, and from a = 1 the prefix multiplies instead
    // of adding. a = 1 is the fixed point that leaves the whole meg- family at
    // its old value. Tier 2 stays inside a plain double at the cap, so the value
    // lands on the compact tower ladder and no new kind is needed.
    const ILLION_TIER = 1000000;

    Suffix.illionExp = function (i) {
        if (typeof i !== "number" || !isfinite(i) || i % 1 !== 0 || i < 1
            || i > Suffix.CAP + 1) {
            return undefined;
        }
        const n = i - 1;
        const a = numfloor(n / ILLION_TIER);
        if (a === 0) {
            return 3 * i;
        }
        const inner = pow10OfText("1", 3 * a + 3);
        if (!isfinite(inner)) {
            return undefined;
        }
        return 3 * (inner + (n - a * ILLION_TIER)) + 3;
    };

    // Index straight to value, the exact partner of illionName. A caller walking
    // the ladder by index should never have to spell a name and then invert one.
    Suffix.illionValue = function (i) {
        const exp = Suffix.illionExp(i);
        if (exp === undefined) {
            return undefined;
        }
        if (exp <= 306) {
            const mag = pow10OfText("1", exp);
            if (!isfinite(mag)) {
                return undefined;
            }
            return Impl.finite(mag);
        }
        return Impl.fromLog10Value(Impl.finite(exp));
    };

    // Power tower of height k + 2, so k = 1 is googolplex = 10^(10^100). The
    // height goes in directly rather than iterating the powers.
    Suffix.plexValue = function (k) {
        if (typeof k !== "number" || !isfinite(k) || k % 1 !== 0 || k < 1
            || k > Suffix.CAP) {
            return undefined;
        }
        return Impl.fromParts(Rank.addFinite(Rank.ZERO, k + 2), 2);
    };

    // Reading a value back to a ladder index, which is what lets a magnitude
    // built as fromLog10(3e303) name itself "mehectillion" instead of falling
    // back to format. The exponent a tower reports has already been snapped to
    // the representation grid, so it is good only to a few units in the last
    // place and cannot be inverted exactly: candidates come from it loosely and
    // each one is confirmed by comparing values, which is where the ladder is
    // exact. Past a = 4 the double has no room for a tail at all, so the
    // zero-tail row is the only candidate that can confirm, and that is honest
    // because every merged index holds that one value.
    Suffix.illionIndexOfValue = function (x) {
        const lv = Impl.log10Value(x);
        if (lv.kind !== "finite") {
            return undefined;
        }
        const e = lv.n;
        if (!isfinite(e) || e < 3) {
            return undefined;
        }
        function confirm(i) {
            if (i === undefined || i === null || i < 1 || i > Suffix.CAP + 1) {
                return undefined;
            }
            const probe = Suffix.illionValue(i);
            if (probe !== undefined && Impl.compare(probe, x) === 0) {
                return i;
            }
            return undefined;
        }
        // Tier 1 and the a = 1 step share the flat reading e = 3i, so the plain
        // inversion is tried first and only the value decides.
        const hit = confirm(Math.floor(e / 3 + 0.5));
        if (hit !== undefined) {
            return hit;
        }
        const m = e / 3 - 1;
        if (m < ILLION_TIER) {
            return undefined;
        }
        const k = Math.floor(log10(m) + 0.5);
        if ((k - 3) % 3 !== 0) {
            return undefined;
        }
        const a = (k - 3) / 3;
        if (a < 1 || a * ILLION_TIER > Suffix.CAP) {
            return undefined;
        }
        const base = pow10OfText("1", k);
        if (!isfinite(base)) {
            return undefined;
        }
        const head = a * ILLION_TIER + 1;
        const zero = confirm(head);
        if (zero !== undefined) {
            return zero;
        }
        const tail = Math.floor(m - base + 0.5);
        if (tail < 1 || tail >= ILLION_TIER) {
            return undefined;
        }
        return confirm(head + tail);
    };

    Suffix.fixed = function (c, decimals) {
        const want = tonumberNil(decimals);
        decimals = numfloor(want === undefined ? 2 : want);
        if (decimals < 0) {
            decimals = 0;
        } else if (decimals > 12) {
            decimals = 12;
        }
        let s = formatFixed(c, decimals);
        if (s.indexOf(".") !== -1) {
            s = s.replace(/0+$/, "").replace(/\.$/, "");
        }
        return s;
    };

    Suffix.scaleOf = function (n) {
        let tier = numfloor(log10(n) / 3);
        if (tier < 1) {
            tier = 1;
        }
        return tier;
    };

    Suffix.shortValue = function (t) {
        const m = /^([0-9.]+)[ \t\r\n\f\v]*([A-Za-z]+)$/.exec(t);
        if (m === null) {
            return null;
        }
        const exp = Suffix.SHORT_EXP[lowerText(m[2])];
        if (exp === undefined) {
            return null;
        }
        const coef = tonumber(m[1]);
        if (!isfinite(coef) || coef < 0) {
            return null;
        }
        const mag = pow10OfText(m[1], exp);
        if (!isfinite(mag)) {
            const lv = log10(coef) + exp;
            if (!isfinite(lv)) {
                return null;
            }
            return Impl.fromLog10Value(Impl.finite(lv));
        }
        return Impl.finite(mag);
    };

    Suffix.nameValue = function (t) {
        t = rtrimSpace(ltrimSpace(lowerText(t).replace(SPACE_RE, " ")));
        if (t === "") {
            return null;
        }
        let coef = 1;
        let name = t;
        const m = /^([0-9.]+)[ \t\r\n\f\v]*(.+)$/.exec(t);
        if (m !== null) {
            const c = tonumber(m[1]);
            if (!isfinite(c) || c <= 0) {
                return null;
            }
            coef = c;
            name = m[2];
        }
        if (name === "googol") {
            const mag = coef * 1e100;
            if (!isfinite(mag)) {
                return null;
            }
            return Impl.finite(mag);
        }
        const plex = Suffix.plexIndexOf(name);
        if (plex !== undefined) {
            // A -plex is a power tower of height plex + 2 whose top is the
            // googol exponent, so the height goes in directly; iterating the
            // powers would spin a hundred million times at the cap.
            let v = Impl.fromParts(Rank.addFinite(Rank.ZERO, plex + 2), 2);
            if (coef !== 1) {
                v = Impl.mulValues(Impl.finite(coef), v);
            }
            return v;
        }
        const index = Suffix.illionIndexOf(name);
        if (index !== undefined) {
            const exp = Suffix.illionExp(index);
            if (exp === undefined) {
                return null;
            }
            if (exp <= 306) {
                const mag = pow10OfText(m === null ? "1" : m[1], exp);
                if (!isfinite(mag)) {
                    return null;
                }
                return Impl.finite(mag);
            }
            // Past the double window the exponent itself is what is known, so
            // the value is built from it and lands on the compact tower ladder.
            const lv = exp + log10(coef);
            if (!isfinite(lv)) {
                return null;
            }
            return Impl.fromLog10Value(Impl.finite(lv));
        }
        return null;
    };

    // The arrow separator glyph, U+2192, marking an arrow-chain spelling.
    const PARSE_ARROW_GLYPH = "→";
    // The up arrow glyph, U+2191. A run of two or more of them (or of ASCII
    // carets) is Knuth's hyperoperator mark, and it is a different character
    // from the U+2192 separator above, so the two never overlap.
    const UP_ARROW_GLYPH = "↑";
    const UP_ARROW_PAIR = UP_ARROW_GLYPH + UP_ARROW_GLYPH;
    const CARET_PAIR = "^^";

    Impl.parseString = function (s, depth) {
        if (typeof s !== "string") {
            return NAN;
        }
        depth = depth === undefined ? 0 : depth;
        if (depth > 64) {
            return NAN;
        }
        // Only pay for the two trims when whitespace is actually present;
        // most spellings reaching here are already tight.
        const lead = s.charCodeAt(0);
        if (!isNaN(lead) && lead <= 32) {
            s = ltrimSpace(s);
        }
        const tail = s.charCodeAt(s.length - 1);
        if (!isNaN(tail) && tail <= 32) {
            s = rtrimSpace(s);
        }
        if (s === "e" || s === "E") {
            return Impl.finite(E_CONST);
        }
        // Array and arrow-chain spellings are unambiguous: a leading brace or an
        // arrow separator anywhere in the text routes them to the array parser.
        // The same two leading code units also feed the cardinal gate below, so
        // they are read once here.
        const b1 = s.charCodeAt(0);
        const b2 = s.charCodeAt(1);
        if (b1 === 123 || s.indexOf("->") !== -1
            || s.indexOf(PARSE_ARROW_GLYPH) !== -1) {
            const bv = Beaf.parse(s, depth);
            if (bv !== null) {
                return bv;
            }
        }
        // Hyper-E spellings are marked by a hyperion run anywhere in the text or
        // by a leading E, so one scan plus the code unit already read routes them.
        if (s.indexOf("#") !== -1 || b1 === 69 || b1 === 101) {
            const ev = HyperE.parse(s, depth);
            if (ev !== null) {
                return ev;
            }
        }
        // The -ote families are looked up by whole tokens, so a leading letter is
        // enough to try them and numeric spellings never reach the lookup.
        if ((b1 >= 97 && b1 <= 122) || (b1 >= 65 && b1 <= 90)) {
            const gv = Grid.parse(s, depth);
            if (gv !== null) {
                return gv;
            }
        }
        // Cardinal spellings start with a glyph, "al" (aleph/alpeh), "be" (beth),
        // "fg"/"f_" (fast-growing) or "ha"/"h_" (Hardy), so two code unit reads
        // route them here and keep the named parser away from subscript text. The
        // alphabet forms are matched with the other spellings further down as a
        // fallback.
        // The glyph test is the U+2000..U+2FFF block, the code points whose UTF-8
        // encoding starts with the single lead byte 226 that holds ℵ and ℶ.
        if ((b1 >= 0x2000 && b1 <= 0x2FFF)
            || (b1 === 97 && b2 === 108) || (b1 === 65 && b2 === 76)
            || (b1 === 98 && b2 === 101) || (b1 === 66 && b2 === 69)
            || (b1 === 102 && (b2 === 103 || b2 === 95))
            || (b1 === 70 && (b2 === 71 || b2 === 95))
            || (b1 === 104 && (b2 === 97 || b2 === 95))
            || (b1 === 72 && (b2 === 65 || b2 === 95))) {
            const cv = Card.parse(s, depth);
            if (cv !== null) {
                return cv;
            }
        }
        // Named spellings always start with a letter the gate class covers; skip
        // that parser for the overwhelmingly common numeric inputs.
        if (NAMED_GATE_RE.test(s)) {
            const named = Named.parse(s, depth);
            if (named !== null) {
                return named;
            }
        }
        // ack(m,n) / ackermann(m,n). The ladder is H_m(2, n+3) - 3, so the
        // spelling resolves straight to a value instead of to a named family.
        if (/[Aa][Cc][Kk]/.test(s)) {
            const av = Impl.parseAck(s, depth);
            if (av !== null) {
                return av;
            }
        }
        // Knuth up-arrows: a run of two or more markers is a hyperoperation
        // whose level is the run length plus two, so "3^^3" is level 4 and
        // "2^^^3" is level 5. The scan only runs when the text carries a run of
        // carets or up arrows, so ordinary spellings pay nothing for it and a
        // single caret never triggers it. It sits after the named and ack gates
        // and before the H(...) and numeric paths, which is what lets
        // "TREE(3)^^2" read as level 4 with base TREE(3).
        if (s.indexOf(CARET_PAIR) !== -1 || s.indexOf(UP_ARROW_PAIR) !== -1) {
            const uv = Impl.parseUpArrows(s, depth);
            if (uv !== null) {
                return uv;
            }
        }
        // A trailing "!" is the factorial of everything before it. Only one
        // marker is consumed, so "10!!" is not a double factorial and stays
        // unparseable.
        if (s.charAt(s.length - 1) === "!" && s.charAt(s.length - 2) !== "!") {
            return Impl.factorialValue(Impl.parseString(s.slice(0, s.length - 1), depth + 1));
        }
        // H(level, base, arg) spellings carry commas and nested parentheses,
        // so they must be handled before the numeric comma stripping below.
        if (/[Hh]\(/.test(s)) {
            const hv = Hyper.parse(s);
            if (hv !== null) {
                return hv;
            }
        }
        // Numeric-first inputs skip the remaining spelling checks once
        // tonumber accepts them. The result is cached so the final check does
        // not parse the same string twice.
        const first = s.charCodeAt(0);
        let exact = NaN;
        let exactKnown = false;
        if (!isNaN(first) && ((first >= 48 && first <= 57) || first === 46)) {
            if (s.indexOf(",") !== -1) {
                s = s.split(",").join("");
            }
            exact = tonumber(s);
            exactKnown = true;
            if (isfinite(exact)) {
                return Impl.finite(exact);
            }
        } else if (first === 43 || first === 45) {
            exact = tonumber(s);
            exactKnown = true;
            if (isfinite(exact)) {
                return Impl.finite(exact);
            }
        }
        const low = lowerText(s);
        if (low === "nan") {
            return NAN;
        } else if (low === "limit" || low === "+limit" || low === "max" || low === "+max"
            || low === "inf" || low === "+inf" || low === "infinity" || low === "+infinity") {
            return CAP;
        } else if (low === "-limit" || low === "-max" || low === "-inf" || low === "-infinity") {
            return NEG_CAP;
        }
        // The alphabet forms are the fallback for spellings the leading
        // code unit gate above did not route here.
        if (low.indexOf("aleph") !== -1 || low.indexOf("alpeh") !== -1
            || low.indexOf("beth") !== -1 || low.indexOf("fgh") !== -1
            || low.indexOf("f_") === 0) {
            const cv = Card.parse(low, depth);
            if (cv !== null) {
                return cv;
            }
        }

        let sign = 1;
        let signedValue = false;
        if (s.charAt(0) === "+") {
            s = s.slice(1);
            signedValue = true;
        } else if (s.charAt(0) === "-") {
            sign = -1;
            s = s.slice(1);
            signedValue = true;
        }

        const tw = /^[Tt]\((.*),[ \t\r\n\f\v]*([+-]?[0-9.]+)[ \t\r\n\f\v]*\)$/.exec(s);
        if (tw !== null) {
            const r = Impl.parseRankString(tw[1]);
            const mant = tonumber(tw[2]);
            if (r === null || isnan(mant)) {
                return NAN;
            }
            return Impl.canonical(sign, r, mant);
        }

        if (s.indexOf(",") !== -1) {
            s = s.split(",").join("");
            exactKnown = false;
        }
        if (signedValue) {
            exactKnown = false;
        }
        if (!exactKnown) {
            exact = tonumber(s);
        }
        if (isfinite(exact)) {
            return Impl.finite(sign * exact);
        }

        const sci = /^([0-9.]+)[eE]([+-]?[0-9]+)$/.exec(s);
        if (sci !== null) {
            const m = tonumber(sci[1]);
            const e = tonumber(sci[2]);
            if (isnan(m)) {
                return NAN;
            }
            if (m === 0) {
                return ZERO;
            }
            if (isNaN(e)) {
                return sign > 0 ? CAP : NEG_CAP;
            }
            const lv = log10(m) + e;
            if (!isfinite(lv)) {
                if (lv === Infinity) {
                    return sign > 0 ? CAP : NEG_CAP;
                }
                return ZERO;
            }
            const v = Impl.fromLog10Value(Impl.finite(lv));
            return sign > 0 ? v : Impl.negate(v);
        }

        const inner = match1(s, /^10\^(.+)$/);
        if (inner !== null) {
            const exponent = Impl.parseString(inner, depth + 1);
            if (exponent.kind === "nan") {
                return NAN;
            }
            const v = Impl.fromLog10Value(exponent);
            return sign > 0 ? v : Impl.negate(v);
        }

        // Short-scale suffixes and -illion/googol names ("2.5M", "1.5 million",
        // "googolplex"). These never overlap with numeric tonumber inputs.
        let spelled = Suffix.nameValue(s);
        if (spelled === null) {
            spelled = Suffix.shortValue(s);
        }
        if (spelled !== null) {
            return sign > 0 ? spelled : Impl.negate(spelled);
        }

        const n = tonumber(s);
        if (!isfinite(n)) {
            return NAN;
        }
        return Impl.finite(sign * n);
    };

    // Splits a spelling on the first run of two or more up-arrow markers. The
    // run length k names hyperoperation level k + 2, and both halves are
    // ordinary spellings again, which is how "3^^3^^3" reads the right side
    // first without this function knowing anything about a second run. An empty
    // side, or an operand the hyperoperation band cannot hold, is nan: the
    // marker was real but the application is not.
    Impl.parseUpArrows = function (s, depth) {
        let i = 0;
        while (i + 1 < s.length) {
            const c = s.charAt(i);
            if ((c === "^" || c === UP_ARROW_GLYPH) && s.charAt(i + 1) === c) {
                let k = 2;
                while (i + k < s.length && s.charAt(i + k) === c) {
                    k = k + 1;
                }
                const left = Impl.parseString(s.slice(0, i), depth + 1);
                const right = Impl.parseString(s.slice(i + k), depth + 1);
                if (left.kind === "nan" || right.kind === "nan") {
                    return NAN;
                }
                if (!Hyper.eligible(left) || !Hyper.eligible(right)) {
                    return NAN;
                }
                return Impl.hyperValue(k + 2, left, right);
            }
            i = i + 1;
        }
        return null;
    };

    Impl.toTable = function (v) {
        if (v.kind === "nan") {
            return { __zuba: 1, kind: "nan" };
        } else if (v.kind === "cap") {
            return { __zuba: 1, kind: "cap", sign: v.sign };
        } else if (v.kind === "finite") {
            return { __zuba: 1, kind: "finite", n: v.n };
        } else if (v.kind === "named") {
            let nx = null;
            if (v.nx !== undefined && v.nx !== null) {
                nx = [];
                for (let i = 0; i < v.nx.length; i++) {
                    nx[i] = Impl.toTable(v.nx[i]);
                }
            }
            return {
                __zuba: 1,
                kind: "named",
                sign: v.sign,
                family: v.family,
                n: v.n,
                idx: (v.idx !== undefined && v.idx !== null) ? Idx.toTable(v.idx) : null,
                nx,
                pow: v.p,
                coef: v.coef,
                off: v.off,
            };
        } else if (v.kind === "hyper") {
            return {
                __zuba: 1,
                kind: "hyper",
                sign: v.sign,
                level: v.level,
                base: Impl.toTable(v.base),
                arg: Impl.toTable(v.arg),
                pow: v.p,
                coef: v.coef,
                off: v.off,
            };
        } else if (v.kind === "tower") {
            return {
                __zuba: 1,
                kind: "tower",
                sign: v.sign,
                rank: Rank.toTable(v.rank),
                m: v.m,
            };
        } else if (v.kind === "card") {
            return Card.toTable(v);
        } else if (v.kind === "fgh") {
            return Fgh.toTable(v);
        }
        return { __zuba: 1, kind: "nan" };
    };

    Impl.fromTable = function (t) {
        if (t === null || typeof t !== "object" || t.__zuba !== 1) {
            return NAN;
        }
        if (t.kind === "nan") {
            return NAN;
        } else if (t.kind === "cap") {
            let sign = tonumberNil(t.sign);
            if (sign === undefined) {
                sign = 1;
            }
            return sign < 0 ? NEG_CAP : CAP;
        } else if (t.kind === "finite") {
            const n = tonumberNil(t.n);
            if (n === undefined) {
                return NAN;
            }
            return Impl.finite(n);
        } else if (t.kind === "named") {
            let index = t.n;
            if (t.idx !== undefined && t.idx !== null) {
                index = Idx.fromTable(t.idx);
                if (index === null) {
                    return NAN;
                }
            }
            let nx = null;
            if (t.nx !== undefined && t.nx !== null) {
                if (typeof t.nx !== "object") {
                    return NAN;
                }
                nx = [];
                for (let i = 0; i < t.nx.length; i++) {
                    nx[i] = Impl.fromTable(t.nx[i]);
                    if (nx[i].kind === "nan") {
                        return NAN;
                    }
                }
            }
            return Named.new(t.family, index, t.sign, t.pow, t.coef, t.off, nx);
        } else if (t.kind === "hyper") {
            const level = tonumberNil(t.level);
            const base = Impl.fromTable(t.base);
            const arg = Impl.fromTable(t.arg);
            if (level === undefined || base.kind === "nan" || arg.kind === "nan") {
                return NAN;
            }
            return Hyper.new(level, base, arg, t.sign, t.pow, t.coef, t.off);
        } else if (t.kind === "tower") {
            const rank = Rank.fromTable(t.rank);
            const m = tonumberNil(t.m);
            let sign = tonumberNil(t.sign);
            if (sign === undefined) {
                sign = 1;
            }
            if (rank === null || m === undefined) {
                return NAN;
            }
            return Impl.canonical(sign, rank, m);
        } else if (t.kind === "card") {
            return Card.fromTable(t);
        } else if (t.kind === "fgh") {
            return Fgh.fromTable(t);
        }
        return NAN;
    };

    Impl.toNumber = function (v) {
        if (v.kind === "finite") {
            return v.n;
        } else if (v.kind === "tower") {
            return v.sign > 0 ? Infinity : -Infinity;
        } else if (v.kind === "named" || v.kind === "hyper") {
            return v.sign > 0 ? Infinity : -Infinity;
        } else if (v.kind === "card") {
            return v.sign > 0 ? Infinity : -Infinity;
        } else if (v.kind === "fgh") {
            return v.sign > 0 ? Infinity : -Infinity;
        } else if (v.kind === "cap") {
            return v.sign > 0 ? Infinity : -Infinity;
        }
        return NaN;
    };

    Impl.getRank = function (v) {
        if (v.kind === "tower") {
            return Rank.copy(v.rank);
        } else if (v.kind === "fgh") {
            return Rank.copy(Fgh.rankOf(v));
        } else if (v.kind === "card") {
            return Rank.copy(Rank.TOP);
        } else if (v.kind === "cap") {
            return Rank.copy(Rank.TOP);
        } else if (v.kind === "finite") {
            const r = Impl.slogPartsFromFinite(Math.abs(v.n));
            if (r !== null) {
                return r[0];
            }
        }
        return Rank.copy(Rank.ZERO);
    };

    Impl.getMantissa = function (v) {
        if (v.kind === "tower") {
            return v.m;
        } else if (v.kind === "named" || v.kind === "hyper") {
            return 1;
        } else if (v.kind === "card") {
            return 1;
        } else if (v.kind === "fgh") {
            return Impl.getMantissa(v.arg);
        } else if (v.kind === "finite") {
            const r = Impl.slogPartsFromFinite(Math.abs(v.n));
            if (r !== null) {
                return r[1];
            }
            return Math.abs(v.n);
        } else if (v.kind === "cap") {
            return 9.999999999;
        }
        return 0;
    };

    // Nesting ---------------------------------------------------------------
    // A nest chain is one hyperoperation fed its own result:
    // H(level, base, H(level, base, ... H(level, base, base))). Applying
    // H(level, base, .) to the seed base depth times is exactly
    // H(level+1, base, depth+1) for every level >= 1, so a deep chain can be
    // carried and printed as one value instead of a tree of them. The
    // innermost argument has to be the base for the identity to hold, and a
    // power, coefficient or offset on any link makes the value something
    // other than a plain chain.

    Impl.nestInfo = function (v) {
        if (!(v !== null && typeof v === "object") || v.kind !== "hyper" || v.sign < 0) {
            return null;
        }
        if (v.p !== 1 || v.coef !== 1 || v.off !== 0) {
            return null;
        }
        const level = v.level;
        const base = v.base;
        let depth = 1;
        let node = v.arg;
        while (node.kind === "hyper" && node.sign > 0 && node.level === level
            && node.p === 1 && node.coef === 1 && node.off === 0
            && Impl.compare(node.base, base) === 0) {
            depth = depth + 1;
            node = node.arg;
        }
        if (Impl.compare(node, base) !== 0) {
            return null;
        }
        return { level: level, base: Impl.copy(base), depth: depth, count: depth + 1 };
    };

    // The same chain written with Knuth up-arrows: a depth-1 chain at level 4
    // or above is base^^..^arg, and the run length is the level minus two. Only
    // plain chains of two finite operands print, so a powered, offset or deeper
    // chain, a level that is just exponentiation, and any transfinite operand
    // give null rather than a spelling that would not read back.
    Impl.toArrowText = function (v) {
        const info = Impl.nestInfo(v);
        if (info === null || info.depth !== 1 || info.level < 4) {
            return null;
        }
        const arg = v.arg;
        if (info.base.kind !== "finite" || arg.kind !== "finite") {
            return null;
        }
        return Impl.formatNumber(info.base.n) + "^".repeat(info.level - 2)
            + Impl.formatNumber(arg.n);
    };

    Impl.nestValue = function (level, base, count) {
        level = tonumber(level);
        if (!isfinite(level) || level !== numfloor(level) || level < 1) {
            return NAN;
        }
        const b = Impl.asValue(base);
        const c = Impl.asValue(count);
        if (b.kind === "nan" || c.kind === "nan") {
            return NAN;
        }
        return Impl.hyperValue(level + 1, b, c);
    };

    const NEST_SCALE_NAMES = nilMap();
    NEST_SCALE_NAMES[1] = "finite";
    NEST_SCALE_NAMES[1.5] = "hyper";
    NEST_SCALE_NAMES[2] = "named";
    NEST_SCALE_NAMES[3] = "ordinal";
    NEST_SCALE_NAMES[4] = "cardinal";
    NEST_SCALE_NAMES[5] = "limit";

    // How many whole units of cost fit inside budget, and what is left over,
    // so a game loop can price an upgrade at any scale the library models and
    // still print an answer. precise says whether count and remainder are the
    // true integers: that needs both sides to be doubles inside MAX_SAFE.
    // Above that, and across scales, div follows the library's absorption
    // convention - TREE(4) / TREE(3) is TREE(4), not a ratio - so exact then
    // describes the model rather than the real quotient. Returns null when
    // budget or cost is NaN or cost is not positive.
    Impl.spend = function (budget, cost) {
        const b = Impl.asValue(budget);
        const c = Impl.asValue(cost);
        if (b.kind === "nan" || c.kind === "nan" || Impl.signOf(c) <= 0) {
            return null;
        }
        const precise = b.kind === "finite" && c.kind === "finite"
            && Math.abs(b.n) <= MAX_SAFE && Math.abs(c.n) <= MAX_SAFE;
        if (Impl.signOf(b) <= 0) {
            return {
                count: Impl.copy(ZERO),
                remainder: Impl.copy(b),
                exact: Impl.isZero(b),
                scale: "finite",
                precise: precise,
            };
        }
        const count = floor(Impl.divValues(b, c));
        const rem = Impl.subValues(b, Impl.mulValues(count, c));
        const scale = NEST_SCALE_NAMES[Impl.tierOf(count)];
        return {
            count: count,
            remainder: rem,
            exact: Impl.isZero(rem),
            scale: scale === undefined ? "finite" : scale,
            precise: precise,
        };
    };

    // Factorial and digit count ---------------------------------------------

    // Above this the digit count of n itself stops being exact, so the loop
    // product is out of reach and only Stirling's series is used.
    const FACTORIAL_MAX = 1e15;

    // n! for a non-negative integer. The product loop is exact through 170,
    // which is where 170! still fits a double; past it the series gives ln(n!)
    // and the value is rebuilt from that logarithm, because the integer itself
    // has no finite representation left. Anything else is nan: a fraction, a
    // negative, a non-finite kind, and every spelling the parser cannot read.
    Impl.factorialValue = function (v) {
        if (v === null || typeof v !== "object" || v.kind !== "finite") {
            return NAN;
        }
        const n = v.n;
        if (n < 0 || n > FACTORIAL_MAX || n !== numfloor(n)) {
            return NAN;
        }
        if (n <= 170) {
            let p = 1;
            for (let k = 2; k <= n; k++) {
                p = p * k;
            }
            return Impl.finite(p);
        }
        const lnFact = (n + 0.5) * Math.log(n) - n
            + 0.5 * Math.log(2 * Math.PI)
            + 1 / (12 * n) - 1 / (360 * n * n * n) + 1 / (1260 * n * n * n * n * n);
        return Impl.fromLog10Value(Impl.finite(lnFact / LN10));
    };

    // How many decimal digits the integer part of |v| has. A double is counted
    // from its own logarithm and then corrected against the exact powers of
    // ten, because log10's last unit can land on the wrong side of one: without
    // the correction 1e23 and above come back one digit short. A tower is
    // already past the point where the integer can be held, so its digit count
    // is read off the logarithm, and the named, hyper, cardinal and hierarchy
    // kinds have no digit count in this model at all.
    Impl.digitsValue = function (v) {
        if (v === null || typeof v !== "object") {
            return NAN;
        }
        if (v.kind === "finite") {
            const n = v.n;
            if (n === 0) {
                return ONE;
            }
            const a = Math.abs(n);
            let e = numfloor(log10(a));
            const hi = Math.pow(10, e + 1);
            if (a < Math.pow(10, e)) {
                e = e - 1;
            } else if (a >= hi) {
                e = e + 1;
            }
            const k = e + 1;
            // A value below 1 has no integer part to count, so it still
            // prints as the single digit 0.
            return Impl.finite(k > 1 ? k : 1);
        } else if (v.kind === "tower" || v.kind === "cap") {
            const lv = Impl.log10Value(v);
            if (lv.kind === "nan") {
                return NAN;
            }
            // The digit count of a value this large is its own logarithm, so
            // only a finite logarithm is floored; a tower keeps its layers.
            const fl = lv.kind === "finite" ? Impl.finite(numfloor(lv.n)) : Impl.copy(lv);
            return Impl.addValues(fl, ONE);
        }
        return NAN;
    };


    Impl.slogValue = function (v) {
        if (v.kind === "nan" || v.kind === "cap") {
            return CAP;
        }
        if (Impl.signOf(v) <= 0) {
            return NAN;
        }
        const parts = Impl.partsFromPositive(Impl.magnitude(v));
        if (parts === null) {
            return NAN;
        }
        const rank = parts[0];
        const m = parts[1];
        if (Rank.isFinite(rank)) {
            return Impl.finite(Rank.finiteValue(rank) + (m - 1) / 9);
        }
        return CAP;
    };

    Impl.logBase = function (v, base) {
        const lv = Impl.log10Value(v);
        const lb = Impl.log10Value(base);
        if (lv.kind === "nan" || lb.kind === "nan") {
            return NAN;
        }
        return Impl.divValues(lv, lb);
    };

    Impl.lnValue = function (v) {
        return Impl.mulValues(Impl.log10Value(v), Impl.finite(LN10));
    };

    Impl.expValue = function (v) {
        if (v.kind === "card") {
            // e^kappa = 2^kappa for an infinite cardinal, so the beth ladder
            // gives the answer directly.
            if (v.sign > 0) {
                return Card.powerSet(v);
            }
            return ZERO;
        }
        if (v.kind === "named" || (v.kind === "hyper" && Hyper.anchorOf(v) !== null)) {
            // exp(v) is e^v, so it stays finite inside v's band like any power.
            return Impl.powValues(Impl.finite(E_CONST), v);
        }
        if (v.kind === "hyper") {
            return v.sign > 0 ? CAP : ZERO;
        }
        return Impl.fromLog10Value(Impl.mulValues(v, Impl.finite(1 / LN10)));
    };

    Impl.rootValue = function (v, n) {
        return Impl.powValues(v, Impl.divValues(ONE, Impl.asValue(n)));
    };

    Impl.hyperValue = function (level, a, b) {
        level = tonumberNil(level);
        if (level === undefined || level < 0) {
            return NAN;
        }
        if (a.kind === "nan" || b.kind === "nan") {
            return NAN;
        }
        level = Math.floor(level);
        if (level === 0) {
            return Impl.addValues(a, ONE);
        } else if (level === 1) {
            return Impl.addValues(a, b);
        } else if (level === 2) {
            return Impl.mulValues(a, b);
        } else if (level === 3) {
            return Impl.powValues(a, b);
        } else if (level === 4) {
            return Impl.tetrateValue(a, b);
        } else if (level === 5) {
            return Impl.pentateValue(a, b);
        }
        // Base identities hold at every level >= 3, even above the modelled range.
        if (b.kind === "finite") {
            if (b.n === 0) {
                return ONE;
            } else if (b.n === 1) {
                return Impl.copy(a);
            } else if (b.n < 0) {
                return NAN;
            }
        }
        if (a.kind === "finite" && b.kind === "finite") {
            if (a.n === 1) {
                return ONE;
            } else if (a.n === 2 && b.n === 2) {
                // 2 ↑^n 2 = 4 at every level >= 3. Larger counts keep growing.
                return Impl.finite(4);
            }
        }
        if (a.kind === "finite" && a.n === 1) {
            return ONE;
        }
        if (b.kind !== "finite") {
            // Finite-tier counts stay finite; transfinite counts still land in
            // the tower tier instead of saturating at LIMIT.
            if (Hyper.eligible(a) && Hyper.eligible(b)) {
                return Hyper.new(level, a, b);
            }
            if (b.kind === "tower" && !Rank.isFinite(b.rank)) {
                return Impl.fromParts(Rank.OMEGA, 9);
            }
            return CAP;
        }
        if (level <= 12 && b.n <= 8) {
            let y = a;
            let done = true;
            for (let i = 2; i <= Math.floor(b.n); i++) {
                y = Impl.hyperValue(level - 1, a, y);
                if (y.kind === "cap" || y.kind === "hyper") {
                    done = false;
                    break;
                } else if (y.kind === "nan") {
                    return NAN;
                }
            }
            if (done) {
                return y;
            }
        }
        // Beyond the exact window the application itself is the finite value.
        if (Hyper.eligible(a) && Hyper.eligible(b)) {
            return Hyper.new(level, a, b);
        }
        return CAP;
    };

    // Rank lifts ------------------------------------------------------------

    // Returns [rank, mantissa] for the lift helpers.
    Impl.valuePartsForLift = function (v) {
        const mag = Impl.magnitude(v);
        const parts = Impl.partsFromPositive(mag);
        if (parts === null) {
            if (mag.kind === "finite") {
                return [Rank.ZERO, Math.abs(mag.n)];
            }
            return [Rank.ZERO, 1];
        }
        return parts;
    };

    Impl.lift = function (v, atomRank) {
        if (v.kind === "nan") {
            return NAN;
        } else if (v.kind === "cap") {
            return v.sign > 0 ? CAP : NEG_CAP;
        } else if (v.kind === "named") {
            // Lifting adds ordinal tower layers; a named value is already
            // past the tower ladder, so the result saturates at LIMIT.
            return CAP;
        } else if (Impl.isZero(v)) {
            return ZERO;
        }
        const sign = Impl.signOf(v);
        const parts = Impl.valuePartsForLift(v);
        return Impl.canonical(sign, Rank.add(atomRank, parts[0]), parts[1]);
    };

    Impl.layerAdd = function (v, n) {
        if (v.kind === "nan") {
            return NAN;
        } else if (v.kind === "cap") {
            return v.sign > 0 ? CAP : NEG_CAP;
        }
        const nv = Impl.asValue(n);
        // Zero (or clamped-negative) layers are the identity at every scale.
        // Falling through would cap a named value and would round-trip a
        // finite one via valuePartsForLift's log10, coming back smaller.
        if (nv.kind === "finite" && nv.n <= 0) {
            return Impl.copy(v);
        }
        if (v.kind === "named") {
            return CAP;
        } else if (Impl.isZero(v)) {
            return ZERO;
        }
        const sign = Impl.signOf(v);
        const parts = Impl.valuePartsForLift(v);
        if (nv.kind === "finite") {
            return Impl.canonical(sign, Rank.addFinite(parts[0], nv.n), parts[1]);
        } else if (nv.kind === "cap") {
            return CAP;
        }
        return Impl.canonical(sign, Rank.add(Rank.OMEGA, parts[0]), parts[1]);
    };

    Impl.rankFromAny = function (r) {
        if (typeof r === "number") {
            return Rank.addFinite(Rank.ZERO, r);
        } else if (typeof r === "string") {
            const k = r.toLowerCase();
            if (k === "0" || k === "zero") {
                return Rank.copy(Rank.ZERO);
            } else if (k === "1" || k === "one") {
                return Rank.addFinite(Rank.ZERO, 1);
            } else if (k === "omega" || k === "w" || k === "ω") {
                return Rank.copy(Rank.OMEGA);
            } else if (k === "epsilon0" || k === "epsilon_0" || k === "eps0" || k === "ε0" || k === "ε₀") {
                return Rank.copy(Rank.EPS0);
            } else if (k === "zeta0" || k === "zeta_0" || k === "ζ0" || k === "ζ₀") {
                return Rank.copy(Rank.ZETA0);
            } else if (k === "eta0" || k === "eta_0" || k === "η0" || k === "η₀") {
                return Rank.copy(Rank.ETA0);
            } else if (k === "gamma0" || k === "gamma_0" || k === "γ0" || k === "Γ₀") {
                return Rank.copy(Rank.GAMMA0);
            } else if (k === "svo") {
                return Rank.copy(Rank.SVO);
            } else if (k === "lvo") {
                return Rank.copy(Rank.LVO);
            }
            return Impl.parseRankString(r);
        } else if (r !== null && typeof r === "object") {
            if (r._rank) {
                return Rank.normalize(r);
            }
            if (r.terms !== undefined && r.terms !== null) {
                return Rank.normalize({ terms: r.terms, fin: r.fin === undefined ? 0 : r.fin });
            }
        }
        return null;
    };

    // ZubaNum.Rank: ordinal helpers exposed alongside the value API.
    const RankAPI = {};

    RankAPI.phi = function (n) {
        const x = tonumberNil(n);
        return Rank.normalize({
            terms: [{ k: "phi", n: Math.max(1, numfloor(x === undefined ? 1 : x)), c: 1 }],
            fin: 0,
        });
    };

    // Gamma_n: the Feferman-Schutte family above Gamma_0, up to the ceiling.
    RankAPI.gamma = function (n) {
        const x = tonumberNil(n);
        return Rank.normalize({
            terms: [{ k: "gamma", n: Math.max(0, numfloor(x === undefined ? 0 : x)), c: 1 }],
            fin: 0,
        });
    };

    RankAPI.add = function (a, b) {
        const ra = Impl.rankFromAny(a);
        const rb = Impl.rankFromAny(b);
        if (ra === null || rb === null) {
            return null;
        }
        return Rank.add(ra, rb);
    };

    RankAPI.succ = function (a) {
        const ra = Impl.rankFromAny(a);
        return ra === null ? null : Rank.succ(ra);
    };

    RankAPI.pred = function (a) {
        const ra = Impl.rankFromAny(a);
        return ra === null ? null : Rank.pred(ra);
    };

    RankAPI.compare = function (a, b) {
        const ra = Impl.rankFromAny(a);
        const rb = Impl.rankFromAny(b);
        if (ra === null || rb === null) {
            return null;
        }
        return Rank.compare(ra, rb);
    };

    RankAPI.toString = function (a) {
        const ra = Impl.rankFromAny(a);
        return ra === null ? "?" : Rank.toString(ra);
    };

    RankAPI.toTable = function (a) {
        const ra = Impl.rankFromAny(a);
        return ra === null ? null : Rank.toTable(ra);
    };

    RankAPI.fromTable = (t) => Rank.fromTable(t);

    RankAPI.finite = (n) => Rank.addFinite(Rank.ZERO, n);

    RankAPI.isFinite = function (a) {
        const ra = Impl.rankFromAny(a);
        return ra !== null && Rank.isFinite(ra);
    };

    RankAPI.isLimit = function (a) {
        const ra = Impl.rankFromAny(a);
        return ra !== null && Rank.isLimit(ra);
    };

    RankAPI.zero = Rank.ZERO;
    RankAPI.one = Rank.addFinite(Rank.ZERO, 1);
    RankAPI.omega = Rank.OMEGA;
    RankAPI.epsilon0 = Rank.EPS0;
    RankAPI.zeta0 = Rank.ZETA0;
    RankAPI.eta0 = Rank.ETA0;
    RankAPI.gamma0 = Rank.GAMMA0;
    RankAPI.svo = Rank.SVO;
    RankAPI.lvo = Rank.LVO;

    // Public API ------------------------------------------------------------
    // Every function below reads as ZubaNum.fn(a, b) and, because values are
    // created with the namespace as their prototype, as a:fn(b). The wrapper
    // installed after this section routes the method form back here.

    function ZubaNum_new(v) {
        if (v === undefined || v === null) {
            return NAN;
        }
        const t = typeof v;
        if (t === "number") {
            return Impl.finite(v);
        } else if (t === "string") {
            return Impl.parseString(v);
        } else if (t === "object" || t === "function") {
            if (Impl.isZuba(v)) {
                return Impl.copy(v);
            }
            if (v.__zuba === 1) {
                return Impl.fromTable(v);
            }
        }
        return NAN;
    }

    function fromNumber(n) {
        if (typeof n !== "number") {
            n = tonumberNil(n);
        }
        if (n === undefined) {
            return NAN;
        }
        return Impl.finite(n);
    }

    function fromString(s) {
        if (typeof s === "number") {
            return Impl.finite(s);
        }
        return Impl.parseString(s);
    }

    function toSuffix(v, decimals) {
        const x = Impl.asValue(v);
        if (x.kind !== "finite") {
            return Impl.format(x);
        }
        let n = x.n;
        const neg = n < 0;
        if (neg) {
            n = -n;
        }
        if (n < 1000) {
            return Impl.formatNumber(neg ? -n : n);
        }
        let tier = Suffix.scaleOf(n);
        let text = Suffix.fixed(n / pow10(3 * tier), decimals);
        if (tonumber(text) >= 1000 && Suffix.SHORT[3 * (tier + 1)] !== undefined) {
            tier = tier + 1;
            text = Suffix.fixed(n / pow10(3 * tier), decimals);
        }
        const abbr = Suffix.SHORT[3 * tier];
        if (abbr === undefined) {
            return Impl.formatNumber(neg ? -n : n);
        }
        return (neg ? "-" : "") + text + abbr;
    }

    function fromSuffix(s) {
        if (typeof s === "number") {
            return Impl.finite(s);
        }
        if (typeof s !== "string") {
            return NAN;
        }
        let t = rtrimSpace(ltrimSpace(s));
        let sign = 1;
        if (t.charAt(0) === "+") {
            t = t.slice(1);
        } else if (t.charAt(0) === "-") {
            sign = -1;
            t = t.slice(1);
        }
        const v = Suffix.shortValue(t);
        if (v === null) {
            return NAN;
        }
        return sign < 0 ? Impl.negate(v) : v;
    }

    function toName(v, decimals) {
        const x = Impl.asValue(v);
        if (x.kind === "finite") {
            let n = x.n;
            const neg = n < 0;
            if (neg) {
                n = -n;
            }
            if (n === 1e100) {
                return (neg ? "-" : "") + "googol";
            }
            if (n < 1000) {
                return null;
            }
            let tier = Suffix.scaleOf(n);
            let text = Suffix.fixed(n / pow10(3 * tier), decimals);
            if (tonumber(text) >= 1000) {
                tier = tier + 1;
                text = Suffix.fixed(n / pow10(3 * tier), decimals);
            }
            const name = Suffix.illionName(tier);
            if (name === undefined) {
                return null;
            }
            if (text === "1") {
                return (neg ? "-" : "") + name;
            }
            return (neg ? "-" : "") + text + " " + name;
        } else if (x.kind === "tower") {
            const prefix = x.sign < 0 ? "-" : "";
            const h = Rank.finiteValue(x.rank);
            if (h !== null && x.m === 2) {
                const name = Suffix.plexName(h - 2);
                if (name !== undefined) {
                    return prefix + name;
                }
            }
            if (x.sign < 0 || h === null) {
                return null;
            }
            // An illion keeps its spelling however large its index grows, in
            // either tier, so a tower built from centillion upward - or from
            // mehectillion - names itself instead of falling back to scientific
            // format. Past the cap the exponent is not one the ladder produces,
            // and null means "use format".
            const index = Suffix.illionIndexOfValue(x);
            if (index === undefined) {
                return null;
            }
            const illio = Suffix.illionName(index);
            if (illio === undefined) {
                return null;
            }
            return prefix + illio;
        }
        return null;
    }

    function fromName(s) {
        if (typeof s !== "string") {
            return NAN;
        }
        let t = rtrimSpace(ltrimSpace(s));
        let sign = 1;
        if (t.charAt(0) === "+") {
            t = t.slice(1);
        } else if (t.charAt(0) === "-") {
            sign = -1;
            t = t.slice(1);
        }
        const v = Suffix.nameValue(t);
        if (v === null) {
            return NAN;
        }
        return sign < 0 ? Impl.negate(v) : v;
    }

    const fromTable = (t) => Impl.fromTable(t);

    function fromRank(rank, m, sign) {
        const r = Impl.rankFromAny(rank);
        if (r === null) {
            return NAN;
        }
        let mant = (m === undefined || m === null) ? 1 : tonumberNil(m);
        if (mant === undefined) {
            return NAN;
        }
        return Impl.canonical(orDefault(sign, 1), r, mant);
    }

    const fromLog10 = (n) => Impl.fromLog10Value(Impl.asValue(n));
    const toLog10 = (v) => Impl.log10Value(Impl.asValue(v));
    const clone = (v) => Impl.copy(Impl.asValue(v));

    // Constants
    ZubaNum.ZERO = ZERO;
    ZubaNum.ONE = ONE;
    ZubaNum.TEN = TEN;
    ZubaNum.NAN = NAN;
    ZubaNum.GRAHAM = GRAHAM;
    ZubaNum.TREE3 = TREE3;
    ZubaNum.TREE4 = TREE4;
    ZubaNum.SSCG2 = SSCG2;
    ZubaNum.SSCG3 = SSCG3;
    ZubaNum.SSCG4 = SSCG4;
    ZubaNum.LOADER = LOADER;
    ZubaNum.BB5 = BB5;
    ZubaNum.BB6 = BB6;
    ZubaNum.RAYO = RAYO;
    ZubaNum.FISH7 = FISH7;
    ZubaNum.LIMIT = CAP;
    ZubaNum.MAX = CAP;
    ZubaNum.INFINITY = CAP;
    ZubaNum.NEG_LIMIT = NEG_CAP;
    ZubaNum.MIN = NEG_CAP;
    ZubaNum.MAX_TOWER = MAX_TOWER;
    ZubaNum.NEG_MAX_TOWER = NEG_MAX_TOWER;
    ZubaNum.MAX_SAFE = MAX_SAFE;
    ZubaNum.ALEPH0 = ALEPH0;
    ZubaNum.ALEPH1 = ALEPH1;
    ZubaNum.ALEPH2 = ALEPH2;
    ZubaNum.ALEPH3 = ALEPH3;
    ZubaNum.ALEPH_OMEGA = ALEPH_OMEGA;
    ZubaNum.BETH0 = BETH0;
    ZubaNum.BETH1 = BETH1;
    ZubaNum.ALEPH_FIXED1 = ALEPH_FP1;

    const tree = (n) => Impl.treeValue(Impl.indexSource(n));
    const sscg = (n) => Impl.sscgValue(Impl.indexSource(n));
    const loader = (n) => Impl.loaderValue(Impl.indexSource(n));
    const bb = (n) => Impl.bbValue(Impl.indexSource(n));

    // Every named constant comes from a family factory. Z.RAYO is
    // Z.rayo(1e100) (Rayo's number is Rayo(10^100)) and Z.FISH7 is Z.fish(7).
    function rayo(n) {
        if (n === undefined || n === null) {
            return Impl.copy(RAYO);
        }
        return Impl.rayoValue(Impl.indexSource(n));
    }

    function fish(n) {
        if (n === undefined || n === null) {
            return Impl.copy(FISH7);
        }
        return Impl.fishValue(Impl.asValue(n));
    }

    const fish7 = () => Impl.copy(FISH7);

    // Comparison
    const cmp = (a, b) => Impl.compare(Impl.asValue(a), Impl.asValue(b));

    function eq(a, b) {
        return Impl.compare(Impl.asValue(a), Impl.asValue(b)) === 0;
    }

    function ne(a, b) {
        const c = Impl.compare(Impl.asValue(a), Impl.asValue(b));
        return c === null || c !== 0;
    }

    function lt(a, b) {
        const c = Impl.compare(Impl.asValue(a), Impl.asValue(b));
        return c !== null && c < 0;
    }

    function lte(a, b) {
        const c = Impl.compare(Impl.asValue(a), Impl.asValue(b));
        return c !== null && c <= 0;
    }

    function gt(a, b) {
        const c = Impl.compare(Impl.asValue(a), Impl.asValue(b));
        return c !== null && c > 0;
    }

    function gte(a, b) {
        const c = Impl.compare(Impl.asValue(a), Impl.asValue(b));
        return c !== null && c >= 0;
    }

    function minMaxCompare(a, b) {
        const c = Impl.compare(a, b);
        if (c !== null) {
            return c;
        }
        // ZFC cannot order some cardinal pairs, but min and max still have to
        // return one of them, so the deterministic subscript ordering decides.
        if (a.kind === "card" && b.kind === "card") {
            return Card.compareDefinite(Impl.magnitude(a), Impl.magnitude(b));
        }
        return null;
    }

    function min(a, b) {
        const c = minMaxCompare(Impl.asValue(a), Impl.asValue(b));
        if (c === null) {
            return NAN;
        }
        return c <= 0 ? Impl.asValue(a) : Impl.asValue(b);
    }

    function max(a, b) {
        const c = minMaxCompare(Impl.asValue(a), Impl.asValue(b));
        if (c === null) {
            return NAN;
        }
        return c >= 0 ? Impl.asValue(a) : Impl.asValue(b);
    }

    // Folds over any number of arguments, starting from the identity of the
    // operation, so the empty folds are exactly sum() = 0 and product() = 1.
    function sum(...args) {
        let acc = ZERO;
        for (let i = 0; i < args.length; i++) {
            acc = Impl.addValues(acc, Impl.asValue(args[i]));
        }
        return acc;
    }

    function product(...args) {
        let acc = ONE;
        for (let i = 0; i < args.length; i++) {
            acc = Impl.mulValues(acc, Impl.asValue(args[i]));
        }
        return acc;
    }

    // v held between lo and hi. An inverted band has no reading, so it is nan
    // rather than a silently swapped pair of bounds.
    function clamp(v, lo, hi) {
        const x = Impl.asValue(v);
        const a = Impl.asValue(lo);
        const b = Impl.asValue(hi);
        if (x.kind === "nan" || a.kind === "nan" || b.kind === "nan") {
            return NAN;
        }
        const c = Impl.compare(a, b);
        if (c === null || c > 0) {
            return NAN;
        }
        return min(max(x, a), b);
    }

    // Predicates and introspection
    const isNaNValue = (v) => Impl.asValue(v).kind === "nan";
    const isFiniteKind = (v) => {
        const x = Impl.asValue(v);
        if (x.kind === "finite" || x.kind === "named" || x.kind === "hyper") {
            return true;
        }
        return x.kind === "tower" && Rank.isFinite(x.rank);
    };
    const isTower = (v) => Impl.asValue(v).kind === "tower";
    const isNamed = (v) => Impl.asValue(v).kind === "named";
    const isHyper = (v) => Impl.asValue(v).kind === "hyper";
    const isCap = (v) => Impl.asValue(v).kind === "cap";
    const isZero = (v) => Impl.isZero(Impl.asValue(v));
    const isZubaPublic = (v) => Impl.isZuba(v);

    // Returns [level, base, arg], or null for any other kind.
    function getHyper(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "hyper") {
            return null;
        }
        return [x.level, Impl.copy(x.base), Impl.copy(x.arg)];
    }

    // Named constant whose band an H(level, base, arg) value is ordered
    // inside. Plain finite-tier hyper values have no anchor.
    function getAnchor(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "hyper") {
            return null;
        }
        const anchor = Hyper.anchorOf(x);
        return anchor === null ? null : Impl.copy(anchor);
    }

    function getKind(v) {
        const k = Impl.asValue(v).kind;
        return k === undefined ? "nan" : k;
    }

    function getSign(v) {
        const s = Impl.signOf(Impl.asValue(v));
        return s === null || s === undefined ? 0 : s;
    }

    function getFamily(v) {
        const value = Impl.asValue(v);
        if (value.kind === "named") {
            return value.family;
        }
        if (value.kind === "card") {
            return value.op === "beth" ? "BETH" : "ALEPH";
        }
        if (value.kind === "fgh") {
            return value.mode === "hardy" ? "HARDY" : "FGH";
        }
        return null;
    }

    // Arithmetic
    const add = (a, b) => Impl.addValues(Impl.asValue(a), Impl.asValue(b));
    const sub = (a, b) => Impl.subValues(Impl.asValue(a), Impl.asValue(b));
    const mul = (a, b) => Impl.mulValues(Impl.asValue(a), Impl.asValue(b));
    const div = (a, b) => Impl.divValues(Impl.asValue(a), Impl.asValue(b));
    const neg = (v) => Impl.negate(Impl.asValue(v));

    function abs(v) {
        const x = Impl.asValue(v);
        const s = Impl.signOf(x);
        if (s === null || s === undefined) {
            return NAN;
        } else if (s < 0) {
            return Impl.negate(x);
        }
        return Impl.copy(x);
    }

    const pow = (a, b) => Impl.powValues(Impl.asValue(a), Impl.asValue(b));

    function mod(a, b) {
        const x = Impl.asValue(a);
        const y = Impl.asValue(b);
        if (x.kind === "nan" || y.kind === "nan") {
            return NAN;
        }
        if (y.kind === "cap") {
            return x.kind === "cap" ? ZERO : Impl.copy(x);
        }
        if (x.kind === "cap") {
            return NAN;
        }
        if (y.kind === "finite" && y.n === 0) {
            return NAN;
        }
        if (x.kind === "finite" && y.kind === "finite") {
            return Impl.finite(floorMod(x.n, y.n));
        }
        const c = Impl.compare(x, y);
        if (c === null) {
            return NAN;
        }
        if (c < 0) {
            return Impl.copy(x);
        } else if (c === 0) {
            return ZERO;
        }
        // Above tower precision the remainder is below representable resolution.
        return ZERO;
    }

    function floor(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "finite") {
            return Impl.copy(x);
        }
        return Impl.finite(Math.floor(x.n));
    }

    function ceil(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "finite") {
            return Impl.copy(x);
        }
        return Impl.finite(Math.ceil(x.n));
    }

    function round(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "finite") {
            return Impl.copy(x);
        }
        if (x.n >= 0) {
            return Impl.finite(Math.floor(x.n + 0.5));
        }
        return Impl.finite(Math.ceil(x.n - 0.5));
    }

    const succ = (v) => Impl.addValues(Impl.asValue(v), ONE);
    const pred = (v) => Impl.subValues(Impl.asValue(v), ONE);

    // n! for a non-negative integer, exact through 170! and Stirling above it.
    // Fractions, negatives and anything the finite band cannot hold are nan,
    // and fromString reads the same operation from a trailing "!".
    const factorial = (v) => Impl.factorialValue(Impl.asValue(v));

    // Decimal digit count of the integer part of |v|, or nan where the value
    // has no digit count in this model.
    const digits = (v) => Impl.digitsValue(Impl.asValue(v));

    // Exponentials, logs, roots
    const log10Of = (v) => Impl.log10Value(Impl.asValue(v));
    const ln = (v) => Impl.lnValue(Impl.asValue(v));

    function log(v, base) {
        const x = Impl.asValue(v);
        if (base === undefined || base === null) {
            return Impl.log10Value(x);
        }
        return logBase(x, base);
    }

    function logBase(v, base) {
        const b = Impl.asValue(base);
        if (b.kind !== "finite" || b.n <= 0 || b.n === 1) {
            return NAN;
        }
        return Impl.logBase(Impl.asValue(v), b);
    }

    const exp = (v) => Impl.expValue(Impl.asValue(v));
    const sqrt = (v) => root(v, 2);

    function root(v, n) {
        const x = Impl.asValue(v);
        const k = Impl.asValue(n);
        if (k.kind === "nan" || x.kind === "nan" || (k.kind === "finite" && k.n === 0)) {
            return NAN;
        }
        if (Impl.signOf(x) < 0 && k.kind === "finite"
            && k.n === Math.floor(k.n) && Math.abs(k.n) % 2 === 1) {
            return Impl.negate(Impl.rootValue(Impl.negate(x), k));
        }
        return Impl.rootValue(x, k);
    }

    const slog = (v) => Impl.slogValue(Impl.asValue(v));

    // Hyperoperations and lifts
    const tetrate = (v, count) => Impl.tetrateValue(Impl.asValue(v), Impl.asValue(count));
    const pentation = (v, count) => Impl.pentateValue(Impl.asValue(v), Impl.asValue(count));

    function hyperoperation(level, a, b) {
        const lv = tonumberNil(level);
        if (lv === undefined) {
            return NAN;
        }
        return Impl.hyperValue(lv, Impl.asValue(a), Impl.asValue(b));
    }

    function arrow(a, b, arrows) {
        let n = (arrows === undefined || arrows === null) ? 2 : tonumberNil(arrows);
        if (n === undefined || n < 0) {
            return NAN;
        }
        return Impl.hyperValue(Math.floor(n) + 2, Impl.asValue(a), Impl.asValue(b));
    }

    function liftPublic(v, rank) {
        const r = Impl.rankFromAny(rank);
        if (r === null) {
            return NAN;
        }
        return Impl.lift(Impl.asValue(v), r);
    }

    const layerAddPublic = (v, n) => Impl.layerAdd(Impl.asValue(v), Impl.asValue(n));
    const omegaTower = (v) => Impl.lift(Impl.asValue(v), Rank.OMEGA);
    const epsilonTower = (v) => Impl.lift(Impl.asValue(v), Rank.EPS0);
    const zetaTower = (v) => Impl.lift(Impl.asValue(v), Rank.ZETA0);
    const etaTower = (v) => Impl.lift(Impl.asValue(v), Rank.ETA0);
    const phiTower = (v, n) => Impl.lift(Impl.asValue(v), RankAPI.phi(n));
    const gammaTower = (v) => Impl.lift(Impl.asValue(v), Rank.GAMMA0);
    const svoTower = (v) => Impl.lift(Impl.asValue(v), Rank.SVO);
    const lvoTower = (v) => Impl.lift(Impl.asValue(v), Rank.LVO);
    const gammaOmegaTower = (v) => Impl.lift(Impl.asValue(v), Rank.GAMMA_OMEGA);
    const bhoTower = (v) => Impl.lift(Impl.asValue(v), Rank.BHO);
    const sboTower = (v) => Impl.lift(Impl.asValue(v), Rank.SBO);
    const lboTower = (v) => Impl.lift(Impl.asValue(v), Rank.LBO);
    const tfbTower = (v) => Impl.lift(Impl.asValue(v), Rank.TFB);
    const ebhoTower = (v) => Impl.lift(Impl.asValue(v), Rank.EBHO);
    const weakInaccessibleTower = (v) => Impl.lift(Impl.asValue(v), Rank.WEAK_INV);
    const weakMahloTower = (v) => Impl.lift(Impl.asValue(v), Rank.WEAK_MAHLO);
    const weakCompactTower = (v) => Impl.lift(Impl.asValue(v), Rank.WEAK_COMPACT);

    // Introspection and conversion
    const getRank = (v) => Impl.getRank(Impl.asValue(v));
    const getMantissa = (v) => Impl.getMantissa(Impl.asValue(v));
    const toNumber = (v) => Impl.toNumber(Impl.asValue(v));
    const toTable = (v) => Impl.toTable(Impl.asValue(v));

    // toJSON returns a plain object by default; asString gives JSON text
    // through JSON.stringify.
    function toJSON(v, asString) {
        const data = Impl.toTable(Impl.asValue(v));
        if (asString) {
            try {
                return JSON.stringify(data);
            } catch (e) {
                return data;
            }
        }
        return data;
    }

    function fromJSON(data) {
        if (typeof data === "string") {
            let decoded;
            try {
                decoded = JSON.parse(data);
            } catch (e) {
                return NAN;
            }
            data = decoded;
        }
        return Impl.fromTable(data);
    }

    const format = (v, style) => Impl.format(Impl.asValue(v), style);
    const parse = (s) => Impl.parseString(s);

    // Ackermann --------------------------------------------------------------

    // A(0,n) = n+1 and A(m,n) = H_m(2, n+3) - 3 for m >= 1, which the
    // hyperoperation band already models, so every level is either exact or a
    // formal H value instead of a saturated ceiling.
    function ackermann(m, n) {
        return Impl.ackermannValue(m, n);
    }

    // Family registry --------------------------------------------------------

    // Build any registered family by name, including one added at runtime. The
    // extra arguments after the index belong to families declared with params > 1.
    function family(name, index, ...extra) {
        if (typeof name !== "string") {
            return NAN;
        }
        const key = upperText(stripSpace(name));
        const spec = Named.SPEC[key];
        if (spec === undefined) {
            return NAN;
        }
        if (extra.length !== (spec.params || 1) - 1) {
            return NAN;
        }
        return Named.make(key, index, extra);
    }

    // Register a named family. One row drives construction, ordering, formatting,
    // parsing and the exported factory, so a caller-supplied giant behaves exactly
    // like the built-in ones. Returns the canonical name, or null and a reason.
    function defineFamily(spec) {
        if (spec === null || typeof spec !== "object") {
            return [null, "spec must be a table"];
        }
        if (typeof spec.name !== "string") {
            return [null, "name must be a string"];
        }
        const name = upperText(stripSpace(spec.name));
        if (!/^[A-Z][A-Z0-9_]*$/.test(name)) {
            return [null, "name must start with a letter and use letters, digits or _"];
        }
        if (Named.SPEC[name] !== undefined) {
            return [null, "family " + name + " is already defined"];
        }
        const band = tonumberNil(spec.band);
        if (band === undefined || !isfinite(band) || band <= 0 || band !== numfloor(band)) {
            return [null, "band must be a positive integer"];
        }
        const bandKeys = Object.keys(Named.BASE_ORDER);
        for (let i = 0; i < bandKeys.length; i++) {
            if (Named.BASE_ORDER[bandKeys[i]] === band) {
                return [null, "band " + band + " is already used by " + bandKeys[i]];
            }
        }
        const prefix = orDefault(spec.prefix, name);
        if (typeof prefix !== "string" || !/^[A-Za-z0-9]+$/.test(prefix)) {
            return [null, "prefix must be letters or digits"];
        }
        const params = (spec.params === undefined || spec.params === null)
            ? 1 : tonumberNil(spec.params);
        if (params === undefined || !isfinite(params) || params !== numfloor(params)
            || params < 1 || params > 8) {
            return [null, "params must be an integer from 1 to 8"];
        }
        const index = (spec.index === undefined || spec.index === null)
            ? "integer" : spec.index;
        if (index !== "none" && index !== "integer" && index !== "unbounded"
            && index !== "fixed") {
            return [null, "index must be none, integer, unbounded or fixed"];
        }
        if (index === "none" && params > 1) {
            return [null, "a multi-parameter family needs an index"];
        }
        const min = (spec.min === undefined || spec.min === null)
            ? 0 : tonumberNil(spec.min);
        if (min === undefined || !isfinite(min) || min !== numfloor(min)) {
            return [null, "min must be an integer"];
        }
        const row = {
            family: name,
            band: band,
            index: index,
            min: min,
            params: params,
            prefix: prefix,
            defined: true,
        };
        if (index === "fixed") {
            const fixed = tonumberNil(spec.fixed);
            if (fixed === undefined || !isfinite(fixed) || fixed !== numfloor(fixed)
                || fixed < min) {
                return [null, "fixed must be an integer at or above min"];
            }
            row.fixed = fixed;
            row.default = fixed;
        }
        if (spec.default !== undefined && spec.default !== null) {
            const d = tonumberNil(spec.default);
            if (d === undefined || !isfinite(d) || d !== numfloor(d) || d < min) {
                return [null, "default must be an integer at or above min"];
            }
            row.default = d;
        }
        const aliasList = [];
        if (spec.aliases !== undefined && spec.aliases !== null) {
            if (typeof spec.aliases !== "object") {
                return [null, "aliases must be a list of strings"];
            }
            // A bare spelling carries no arguments, so only a one-parameter family
            // can have one.
            if (params > 1) {
                return [null, "aliases need params = 1"];
            }
            if (row.default === undefined && index !== "none") {
                return [null, "aliases need a default index"];
            }
            for (let i = 0; i < spec.aliases.length; i++) {
                let a = spec.aliases[i];
                if (typeof a !== "string") {
                    return [null, "aliases must be a list of strings"];
                }
                a = lowerText(stripSpace(a));
                if (!/^[a-z0-9_.]+$/.test(a)) {
                    return [null, "alias must be lowercase letters, digits, _ or ."];
                }
                if (Named.ALIASES[a] !== undefined) {
                    return [null, "alias " + a + " is already taken"];
                }
                aliasList.push(a);
            }
        }
        let heads = spec.call;
        if (heads === undefined || heads === null) {
            heads = [lowerText(prefix)];
        } else if (typeof heads !== "object") {
            return [null, "call must be a string or a list of strings"];
        }
        const callList = [];
        for (let i = 0; i < heads.length; i++) {
            let h = heads[i];
            if (typeof h !== "string") {
                return [null, "call must be a string or a list of strings"];
            }
            h = lowerText(stripSpace(h));
            if (!/^[a-z0-9_]+$/.test(h)) {
                return [null, "call spelling must be lowercase letters or digits"];
            }
            if (Named.CALL[h] !== undefined) {
                return [null, "call spelling " + h + " is already taken"];
            }
            callList.push(h);
        }
        let factory = null;
        if (spec.factory !== undefined && spec.factory !== null) {
            if (typeof spec.factory !== "string") {
                return [null, "factory must be a string"];
            }
            factory = stripSpace(spec.factory);
            if (!/^[a-z][A-Za-z0-9]*$/.test(factory)) {
                return [null, "factory must start with a lowercase letter"];
            }
            if (ZubaNum[factory] !== undefined) {
                return [null, "factory " + factory + " is already taken"];
            }
        }
        // Validation is finished, so the row and its spellings land together.
        Named.FAMILIES.push(row);
        Named.FAMILIES.sort(function (x, y) {
            return x.band < y.band ? -1 : (x.band > y.band ? 1 : 0);
        });
        Named.SPEC[name] = row;
        Named.BASE_ORDER[name] = band;
        const callFloor = row.fixed === undefined ? min : row.fixed;
        for (let i = 0; i < aliasList.length; i++) {
            Named.ALIASES[aliasList[i]] = [name, row.default];
            Named.widenGate(aliasList[i]);
        }
        for (let i = 0; i < callList.length; i++) {
            Named.CALL[callList[i]] = [name, callFloor];
            Named.widenGate(callList[i]);
        }
        Named.widenGate(prefix);
        if (factory !== null) {
            ZubaNum[factory] = function (ix, ...fx) {
                if (fx.length !== params - 1) {
                    return NAN;
                }
                return Named.make(name, ix, fx);
            };
        }
        return [name];
    }

    function familyInfo(name) {
        if (typeof name !== "string") {
            return null;
        }
        const spec = Named.SPEC[upperText(stripSpace(name))];
        if (spec === undefined) {
            return null;
        }
        const aliases = [];
        const calls = [];
        const aliasKeys = Object.keys(Named.ALIASES);
        for (let i = 0; i < aliasKeys.length; i++) {
            const target = Named.ALIASES[aliasKeys[i]];
            if (target[0] === spec.family) {
                aliases.push(aliasKeys[i]);
            }
        }
        const callKeys = Object.keys(Named.CALL);
        for (let i = 0; i < callKeys.length; i++) {
            const target = Named.CALL[callKeys[i]];
            if (target[0] === spec.family) {
                calls.push(callKeys[i]);
            }
        }
        aliases.sort();
        calls.sort();
        return {
            family: spec.family,
            band: spec.band,
            index: spec.index,
            min: spec.min,
            params: spec.params || 1,
            prefix: spec.prefix || spec.family,
            default: spec.default,
            fixed: spec.fixed,
            aliases: aliases,
            call: calls,
        };
    }

    // Every registered family, ordered by band.
    function families() {
        const out = [];
        for (let i = 0; i < Named.FAMILIES.length; i++) {
            out[i] = familyInfo(Named.FAMILIES[i].family);
        }
        return out;
    }

    // Cardinals and the fast-growing hierarchy -------------------------------

    function aleph(idx) {
        if (idx === undefined || idx === null) {
            return Impl.copy(ALEPH0);
        }
        const i = Idx.fromArg(idx);
        if (i === null) {
            return NAN;
        }
        return Card.plain("aleph", i, 1);
    }

    function beth(idx) {
        if (idx === undefined || idx === null) {
            return Impl.copy(BETH0);
        }
        const i = Idx.fromArg(idx);
        if (i === null) {
            return NAN;
        }
        return Card.plain("beth", i, 1);
    }

    function fixedPointOf(op, n) {
        const i = Idx.fromArg((n === undefined || n === null) ? 1 : n);
        if (i === null) {
            return NAN;
        }
        return Card.fixed(op, i, 1);
    }

    function alephFixed(n) {
        return fixedPointOf("aleph", n);
    }

    function bethFixed(n) {
        return fixedPointOf("beth", n);
    }

    function cardSucc(v) {
        return Card.cardSucc(Impl.asValue(v));
    }

    function fgh(alpha, n) {
        const i = Idx.fromArg(alpha);
        if (i === null) {
            return NAN;
        }
        const k = Impl.asValue(n);
        if (k.kind === "nan") {
            return NAN;
        }
        return Fgh.create(i, k);
    }

    // Hardy hierarchy value H_alpha(n + base). A finite level is exact addition;
    // a transfinite level stays formal and orders below f_alpha at the same index.
    function hardy(alpha, n, base) {
        const i = Idx.fromArg(alpha);
        if (i === null) {
            return NAN;
        }
        return Fgh.hardy(i, Impl.asValue(n), base);
    }

    function isHardy(v) {
        return v !== null && typeof v === "object"
            && v.kind === "fgh" && v.mode === "hardy";
    }

    function isCard(v) {
        return v !== null && typeof v === "object" && v.kind === "card";
    }

    function isFgh(v) {
        return v !== null && typeof v === "object"
            && v.kind === "fgh" && v.mode !== "hardy";
    }

    // op, mode, index table, sign. mode is "plain" for aleph_alpha / beth_alpha
    // and "fp" for the n-th fixed point of that ladder.
    function getCard(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "card") {
            return null;
        }
        return [x.op, x.mode, Idx.toTable(x.idx), x.sign];
    }

    // index table, argument, sign, mode. mode is null for a fast-growing f value
    // and "hardy" for an H value.
    function getFgh(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "fgh") {
            return null;
        }
        return [Idx.toTable(x.idx), Impl.copy(x.arg), x.sign, x.mode];
    }

    // 1 finite, 1.5 plain hyper band, 2 named mega, 3 hierarchy and infinite-rank
    // towers, 4 cardinals, 5 LIMIT.
    function tierOf(v) {
        const value = Impl.asValue(v);
        if (value.kind === "nan") {
            return null;
        }
        return Impl.tierOf(value);
    }

    // Nesting ----------------------------------------------------------------

    // H(level, base, .) applied count times to the seed base. That chain is
    // exactly H(level+1, base, count) for every level >= 1, so a nest of any
    // depth costs one value: nest(3, 2, 3) is 2^(2^2) = 16 and nest(6, 2, 100)
    // is a single H(7, 2, 100).
    function nest(level, base, count) {
        return Impl.nestValue(level, base, count);
    }

    // The chain a hyper value is, or null when it is not one. A power,
    // coefficient or offset on any link breaks it, and so does an innermost
    // argument that is not the base: H(3, 2, H(3, 2, 5)) grows from 5, not from 2.
    function nestInfo(v) {
        return Impl.nestInfo(Impl.asValue(v));
    }

    // Number of nested links, or 0 for anything that is not a nest chain.
    function nestDepth(v) {
        const info = Impl.nestInfo(Impl.asValue(v));
        return info === null ? 0 : info.depth;
    }

    // A plain depth-1 chain at level 4 or above, printed with Knuth up-arrows:
    // H(4, 3, 3) is "3^^3". Everything else - a deeper chain, a powered link, a
    // level that is only exponentiation, a transfinite operand - has no honest
    // arrow spelling, so it returns null instead of a rounded approximation.
    function toArrow(v) {
        return Impl.toArrowText(Impl.asValue(v));
    }

    function spend(budget, cost) {
        return Impl.spend(budget, cost);
    }

    // BEAF linear arrays and Hyper-E -----------------------------------------

    // Accepts the entries as arguments, as one array table, or as one spelling:
    // "{10, 10, 3}", "10->->10", "3->3->3".
    function beaf(...args) {
        if (args.length === 0) {
            return ONE;
        }
        const first = args[0];
        if (args.length === 1 && typeof first === "string") {
            const parsed = Beaf.parse(first);
            if (parsed !== null) {
                return parsed;
            }
        }
        let list = args;
        if (args.length === 1 && first !== null && typeof first === "object"
            && !Impl.isZuba(first)) {
            list = first;
        }
        const entries = [];
        for (let i = 0; i < list.length; i++) {
            const v = Impl.asValue(list[i]);
            if (v.kind === "nan") {
                return NAN;
            }
            entries[i] = v;
        }
        return Beaf.eval(entries);
    }

    function toBEAF(v) {
        const x = Impl.asValue(v);
        const text = Beaf.toText(x);
        if (text === null) {
            return Impl.format(x);
        }
        return text;
    }

    // fromHyperE reads "100E100", "E100#2", "E100##100" and the bare "ee100"
    // forms, and fromString routes the same spellings; toHyperE writes the
    // compact E-form of a value, falling back to the default formatter where the
    // notation has no reading. hyperE(a, b, hyperions, count) builds a x 10^b
    // followed by a run of hyperions applied count times.
    function fromHyperE(s) {
        const parsed = HyperE.parse(s);
        if (parsed === null) {
            return NAN;
        }
        return parsed;
    }

    function toHyperE(v) {
        const x = Impl.asValue(v);
        const text = HyperE.toText(x);
        if (text === null) {
            return Impl.format(x);
        }
        return text;
    }

    function hyperE(a, b, hyperions, count) {
        const h = (hyperions === undefined || hyperions === null)
            ? 0 : tonumberNil(hyperions);
        if (h === undefined || h < 0 || h !== numfloor(h) || h > 1e6) {
            return NAN;
        }
        const av = Impl.asValue(a);
        const bv = Impl.asValue(b);
        if (av.kind === "nan" || bv.kind === "nan") {
            return NAN;
        }
        let cv;
        if (count === undefined || count === null) {
            cv = Impl.finite(h + 1);
        } else {
            cv = Impl.asValue(count);
            if (cv.kind === "nan" || (cv.kind === "finite" && cv.n < 0)
                || Impl.signOf(cv) < 0) {
                return NAN;
            }
            if (cv.kind === "finite" && cv.n !== numfloor(cv.n)) {
                return NAN;
            }
        }
        return HyperE.eval(av, bv, h, cv);
    }

    function hyperFamily(familyName, x, y) {
        const spec = typeof familyName === "string"
            ? Grid.BY_TOKEN[lowerText(familyName)] : null;
        if (spec === null || spec === undefined) {
            return NAN;
        }
        return Grid.eval(spec, Impl.asValue(x), Impl.asValue(y));
    }

    function API_gridFactory(entry) {
        return function (x, y) {
            return Grid.eval(entry, Impl.asValue(x), Impl.asValue(y));
        };
    }

    // The -ote family grid: every registry token is callable as a factory, so
    // expande(10, 2), h11(10, 2) and hyperFamily("expande", 10, 2) are the same
    // value. Level ω is aperiote, ω+1 is expande, and the codes read as the
    // Cantor-normal-form digits of the level. Each name, alias and code is a
    // two-argument constructor, so these factories are installed directly rather
    // than through the value-method dispatch used by the operators above.
    const API_GRID_FACTORIES = nilMap();
    for (let i = 0; i < Grid.SPECS.length; i++) {
        const spec = Grid.SPECS[i];
        API_GRID_FACTORIES[spec.name] = API_gridFactory(spec);
        API_GRID_FACTORIES[spec.short] = API_gridFactory(spec);
        API_GRID_FACTORIES[spec.code] = API_gridFactory(spec);
    }

    RankAPI.fromString = (s) => Impl.rankFromAny(s);
    RankAPI.fromAny = (r) => Impl.rankFromAny(r);
    RankAPI.ceiling = Rank.TOP;
    RankAPI.ZERO = Rank.ZERO;
    RankAPI.OMEGA = Rank.OMEGA;
    RankAPI.EPS0 = Rank.EPS0;
    RankAPI.ZETA0 = Rank.ZETA0;
    RankAPI.ETA0 = Rank.ETA0;
    RankAPI.GAMMA0 = Rank.GAMMA0;
    RankAPI.GAMMA_OMEGA = Rank.GAMMA_OMEGA;
    RankAPI.SVO = Rank.SVO;
    RankAPI.LVO = Rank.LVO;
    RankAPI.BHO = Rank.BHO;
    RankAPI.SBO = Rank.SBO;
    RankAPI.LBO = Rank.LBO;
    RankAPI.TFB = Rank.TFB;
    RankAPI.EBHO = Rank.EBHO;
    RankAPI.WEAK_INV = Rank.WEAK_INV;
    RankAPI.WEAK_MAHLO = Rank.WEAK_MAHLO;
    RankAPI.WEAK_COMPACT = Rank.WEAK_COMPACT;
    RankAPI.TOP = Rank.TOP;

    // Operator-style helpers, reachable under fixed names for game code.
    const meta = {
        add: (a, b) => Impl.addValues(Impl.asValue(a), Impl.asValue(b)),
        sub: (a, b) => Impl.subValues(Impl.asValue(a), Impl.asValue(b)),
        mul: (a, b) => Impl.mulValues(Impl.asValue(a), Impl.asValue(b)),
        div: (a, b) => Impl.divValues(Impl.asValue(a), Impl.asValue(b)),
        mod: (a, b) => mod(a, b),
        pow: (a, b) => Impl.powValues(Impl.asValue(a), Impl.asValue(b)),
        unm: (a) => Impl.negate(Impl.asValue(a)),
        eq: (a, b) => Impl.compare(Impl.asValue(a), Impl.asValue(b)) === 0,
        lt: (a, b) => {
            const c = Impl.compare(Impl.asValue(a), Impl.asValue(b));
            return c !== null && c < 0;
        },
        le: (a, b) => {
            const c = Impl.compare(Impl.asValue(a), Impl.asValue(b));
            return c !== null && c <= 0;
        },
        tostring: (a) => Impl.format(Impl.asValue(a)),
        concat: (a, b) => {
            const sa = Impl.isZuba(a) ? Impl.format(a) : String(a);
            const sb = Impl.isZuba(b) ? Impl.format(b) : String(b);
            return sa + sb;
        },
    };
    // v2.2 support additions -------------------------------------------------
    // These sit on top of the existing value model; none of them add a kind.
    // Every helper answers NaN (or null for the string helpers) when it cannot
    // answer exactly, so a game never reads a wrong number off a fast path.

    function intValueOf(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "finite" || x.n % 1 !== 0) {
            return undefined;
        }
        return Math.abs(x.n);
    }

    // The remainder here is the IEEE one, so the loop stays exact for
    // integer-valued doubles past the 2^53 window, where a quotient-based mod
    // would round and lose the factor the answer depends on.
    function euclid(m, n) {
        while (n > 0) {
            const r = m % n;
            m = n;
            n = r;
        }
        return m;
    }

    function gcd(a, b) {
        const m = intValueOf(a);
        const n = intValueOf(b);
        if (m === undefined || n === undefined) {
            return NAN;
        }
        return Impl.finite(euclid(m, n));
    }

    function lcm(a, b) {
        const m = intValueOf(a);
        const n = intValueOf(b);
        if (m === undefined || n === undefined) {
            return NAN;
        }
        if (m === 0 || n === 0) {
            return ZERO;
        }
        const q = m / euclid(m, n);
        const out = q * n;
        if (isfinite(out) && out <= MAX_SAFE) {
            return Impl.finite(out);
        }
        // Past the integer window the quotient stays exact in log space.
        return Impl.fromLog10Value(Impl.finite(log10(q) + log10(n)));
    }

    function cbrt(v) {
        return root(v, 3);
    }

    // Gamma for finite x, accurate to roughly 1e-15 relative. Integers take the
    // multiplication path so factorials come out exact; anything else is shifted
    // up to the anchor with the recurrence and closed with Stirling's series,
    // and the reflection formula covers x below a half. Poles give NaN.
    const GAMMA_ANCHOR = 20;
    const HALF_LOG_2PI = 0.9189385332046727;

    function gammaNumber(x) {
        if (x < 0.5) {
            return Math.PI / (Math.sin(Math.PI * x) * gammaNumber(1 - x));
        }
        if (x % 1 === 0) {
            let acc = 1;
            for (let k = 2; k <= x - 1; k++) {
                acc *= k;
            }
            return acc;
        }
        let y = x;
        let prod = 1;
        while (y < GAMMA_ANCHOR) {
            prod *= y;
            y += 1;
        }
        const y2 = y * y;
        const ln = (y - 0.5) * Math.log(y) - y + HALF_LOG_2PI
            + 1 / (12 * y) - 1 / (360 * y * y2) + 1 / (1260 * y * y2 * y2)
            - 1 / (1680 * y * y2 * y2 * y2);
        return Math.exp(ln - Math.log(prod));
    }

    function gamma(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "finite") {
            return NAN;
        }
        if (x.n <= 0 && x.n % 1 === 0) {
            return NAN;
        }
        if (x.n > 171.6) {
            // 171! is the last factorial a double carries, so above it the
            // answer travels in log space on Stirling's series instead of
            // overflowing.
            const ln = (x.n - 0.5) * Math.log(x.n) - x.n + HALF_LOG_2PI
                + 1 / (12 * x.n) - 1 / (360 * x.n * x.n * x.n);
            const lg = ln / LN10;
            if (!isfinite(lg)) {
                return CAP;
            }
            return Impl.fromLog10Value(Impl.finite(lg));
        }
        const g = gammaNumber(x.n);
        if (!isfinite(g)) {
            return NAN;
        }
        return Impl.finite(g);
    }

    function lambertW(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "finite" || x.n < -0.36787944117144233) {
            return NAN;
        }
        let w = x.n < 1 ? x.n : (Math.log(x.n) - Math.log(Math.log(x.n) + 1));
        for (let i = 0; i < 24; i++) {
            const ew = Math.exp(w);
            const denom = w * ew + ew;
            if (denom === 0) {
                break;
            }
            const w2 = w - (w * ew - x.n) / denom;
            const delta = Math.abs(w2 - w);
            w = w2;
            if (delta <= 1e-15 * Math.max(1, Math.abs(w))) {
                break;
            }
        }
        return Impl.finite(w);
    }

    function finiteNumber(v) {
        const x = Impl.asValue(v);
        if (x.kind !== "finite") {
            return undefined;
        }
        return x.n;
    }

    function sin(v) {
        const n = finiteNumber(v);
        return n === undefined ? NAN : Impl.finite(Math.sin(n));
    }

    function cos(v) {
        const n = finiteNumber(v);
        return n === undefined ? NAN : Impl.finite(Math.cos(n));
    }

    function tan(v) {
        const n = finiteNumber(v);
        if (n === undefined) {
            return NAN;
        }
        const t = Math.tan(n);
        return isfinite(t) ? Impl.finite(t) : NAN;
    }

    function asin(v) {
        const n = finiteNumber(v);
        if (n === undefined || n < -1 || n > 1) {
            return NAN;
        }
        return Impl.finite(Math.asin(n));
    }

    function acos(v) {
        const n = finiteNumber(v);
        if (n === undefined || n < -1 || n > 1) {
            return NAN;
        }
        return Impl.finite(Math.acos(n));
    }

    function atan(v) {
        const n = finiteNumber(v);
        return n === undefined ? NAN : Impl.finite(Math.atan(n));
    }

    function atan2(y, x) {
        const ny = finiteNumber(y);
        const nx = finiteNumber(x);
        if (ny === undefined || nx === undefined) {
            return NAN;
        }
        return Impl.finite(Math.atan2(ny, nx));
    }

    // Interpolation and sampling in log space, which is where idle-game scales
    // actually live. lerpLog(1e3, 1e9, 0.5) is 1e6, not 5e8.
    function lerpLog(a, b, t) {
        const x = Impl.asValue(a);
        const y = Impl.asValue(b);
        const frac = tonumber(t);
        if (!isfinite(frac) || Impl.signOf(x) <= 0 || Impl.signOf(y) <= 0) {
            return NAN;
        }
        const lx = Impl.log10Value(x);
        const ly = Impl.log10Value(y);
        if (lx.kind !== "finite" || ly.kind !== "finite") {
            return NAN;
        }
        return Impl.fromLog10Value(Impl.finite(lx.n + (ly.n - lx.n) * frac));
    }

    function randLin(a, b) {
        const lo = Impl.asValue(a);
        const hi = Impl.asValue(b);
        if (lo.kind !== "finite" || hi.kind !== "finite") {
            return NAN;
        }
        return Impl.finite(lo.n + (hi.n - lo.n) * Math.random());
    }

    function randLog(a, b) {
        return lerpLog(a, b, Math.random());
    }

    // Geometric series, the shape every idle-game cost curve uses. count is the
    // number of terms and terms are 1-based.
    function geoTerm(first, ratio, count) {
        const f = Impl.asValue(first);
        const r = Impl.asValue(ratio);
        const k = intValueOf(count);
        if (f.kind === "nan" || r.kind === "nan" || k === undefined || k < 1) {
            return NAN;
        }
        if (k === 1) {
            return Impl.copy(f);
        }
        return Impl.mulValues(f, Impl.powValues(r, Impl.finite(k - 1)));
    }

    function geoSum(first, ratio, count) {
        const f = Impl.asValue(first);
        const r = Impl.asValue(ratio);
        const k = intValueOf(count);
        if (f.kind === "nan" || r.kind === "nan" || k === undefined || k < 0) {
            return NAN;
        }
        if (k === 0) {
            return ZERO;
        }
        if (r.kind === "finite" && r.n === 1) {
            return Impl.mulValues(f, Impl.finite(k));
        }
        const power = Impl.powValues(r, Impl.finite(k));
        const numer = Impl.mulValues(f, Impl.subValues(power, ONE));
        return Impl.divValues(numer, Impl.subValues(r, ONE));
    }

    // The inverse of geoSum: how many terms a budget buys. Exact for finite
    // inputs, and log-space algebra keeps it working when the budget is a tower.
    function geoCount(first, ratio, budget) {
        const f = Impl.asValue(first);
        const r = Impl.asValue(ratio);
        const t = Impl.asValue(budget);
        if (f.kind === "nan" || r.kind === "nan" || t.kind === "nan") {
            return NAN;
        }
        if (Impl.signOf(t) <= 0 || Impl.signOf(f) <= 0) {
            return ZERO;
        }
        if (r.kind === "finite" && r.n === 1) {
            return floor(Impl.divValues(t, f));
        }
        const growth = Impl.subValues(r, ONE);
        const scaled = Impl.addValues(ONE, Impl.mulValues(t, Impl.divValues(growth, f)));
        const count = Impl.divValues(Impl.log10Value(scaled), Impl.log10Value(r));
        return floor(count);
    }

    // Alphabet notation: tier 1 is "A", 26 is "Z", 27 is "AA". It pairs with the
    // suffix ladder, so "A" is 10^3, "Z" is 10^78 and a tier beyond the short
    // marks keeps naming values without bound.
    const LETTER_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    function lettersForTier(tier) {
        const parts = [];
        while (tier > 0) {
            const rem = (tier - 1) % 26;
            parts.push(LETTER_ALPHABET.charAt(rem));
            tier = numfloor((tier - 1) / 26);
        }
        return parts.reverse().join("");
    }

    function toLetters(v) {
        const x = Impl.asValue(v);
        if (x.kind === "nan") {
            return null;
        }
        const lv = Impl.log10Value(Impl.magnitude(x));
        if (lv.kind !== "finite" || lv.n < 3) {
            return null;
        }
        const tier = numfloor(lv.n / 3);
        if (tier < 1 || tier > 1e15) {
            return null;
        }
        return (Impl.signOf(x) < 0 ? "-" : "") + lettersForTier(tier);
    }

    function fromLetters(s) {
        if (typeof s !== "string") {
            return NAN;
        }
        let t = rtrimSpace(ltrimSpace(s));
        const neg = t.charAt(0) === "-";
        if (neg) {
            t = t.slice(1);
        }
        if (t === "" || t.length > 12) {
            return NAN;
        }
        let tier = 0;
        for (let i = 0; i < t.length; i++) {
            const idx = LETTER_ALPHABET.indexOf(upperText(t.charAt(i)));
            if (idx === -1) {
                return NAN;
            }
            tier = tier * 26 + idx + 1;
        }
        const exp = 3 * tier;
        if (exp <= 306) {
            const mag = pow10OfText("1", exp);
            return Impl.finite(neg ? -mag : mag);
        }
        const v = Impl.fromLog10Value(Impl.finite(exp));
        return neg ? Impl.negate(v) : v;
    }

    // A Graham-shaped ladder in this library's own convention: g_n is 3 joined
    // to 3 by n arrows, so g_1 = 27, g_2 = 3^^3, g_64 = 3 with 64 arrows. The
    // real Graham sequence feeds each term's size back in as the next term's
    // arrow count, which no representation here can hold, so this ladder is a
    // growing family of its own. It also orders below the named GRAHAM constant:
    // named values sit in a higher band than plain hyper values, so comparing
    // the two follows the band rules rather than measuring one against the other.
    function graham(n) {
        const raw = tonumber(n);
        if (isnan(raw) || raw < 1) {
            return NAN;
        }
        const k = numfloor(raw);
        const three = Impl.finite(3);
        if (k === 1) {
            return Impl.powValues(three, Impl.finite(3));
        }
        return Impl.hyperValue(k + 2, three, three);
    }

    function describeValue(x) {
        const k = x.kind;
        if (k === "finite") {
            return "finite " + Impl.format(x);
        }
        if (k === "tower") {
            const h = Rank.finiteValue(x.rank);
            if (h !== null) {
                return "tower height " + formatFixed(h, 0) + " mantissa "
                    + formatG(x.m, 15) + " sign " + formatFixed(x.sign, 0);
            }
            return "tower rank " + Rank.toString(x.rank);
        }
        if (k === "cap") {
            return "LIMIT";
        }
        if (k === "nan") {
            return "NaN";
        }
        return k + " " + Impl.format(x);
    }

    // Why do these two order the way they do? Tiers decide first, then the order
    // inside the tier, so this names the tier pair when they differ.
    function explain(a, b) {
        const x = Impl.asValue(a);
        const y = Impl.asValue(b);
        if (x.kind === "nan" || y.kind === "nan") {
            return "NaN is unordered with every value, including itself";
        }
        const c = Impl.compare(x, y);
        const verdict = c < 0 ? "<" : (c > 0 ? ">" : "=");
        const tx = Impl.tierOf(x);
        const ty = Impl.tierOf(y);
        const basis = tx !== ty
            ? "tier " + tx + " vs tier " + ty + " decides it"
            : "both tier " + tx + ", so the order inside the tier decides it";
        return describeValue(x) + " " + verdict + " " + describeValue(y)
            + " (" + basis + ")";
    }

    // Compact save spelling, one byte of tag instead of a serialized table.
    //   1f<number>  finite        1t<height>,<mantissa>,<sign>  finite-rank tower
    //   1l          LIMIT         1n  NaN       1p<spelling>    anything else
    // The leading 1 is the format version, so an old save can be told apart.
    ZubaNum.SAVE_VERSION = 1;

    function toSave(v) {
        const x = Impl.asValue(v);
        if (x.kind === "finite") {
            return "1f" + formatG(x.n, 17);
        }
        if (x.kind === "cap") {
            return "1l";
        }
        if (x.kind === "nan") {
            return "1n";
        }
        if (x.kind === "tower") {
            const h = Rank.finiteValue(x.rank);
            if (h !== null) {
                return "1t" + formatFixed(h, 0) + "," + formatG(x.m, 17) + ","
                    + formatFixed(x.sign, 0);
            }
        }
        return "1p" + Impl.format(x);
    }

    function fromSave(s) {
        if (typeof s !== "string" || s.length < 2 || s.charAt(0) !== "1") {
            return NAN;
        }
        const tag = s.charAt(1);
        const body = s.slice(2);
        if (tag === "f") {
            const n = tonumber(body);
            if (!isfinite(n)) {
                return NAN;
            }
            return Impl.finite(n);
        }
        if (tag === "l") {
            return CAP;
        }
        if (tag === "n") {
            return NAN;
        }
        if (tag === "t") {
            const m = /^(-?[\d.]+),(-?[\d.]+),(-?\d+)$/.exec(body);
            if (m === null) {
                return NAN;
            }
            const height = tonumber(m[1]);
            const mant = tonumber(m[2]);
            const sgn = tonumber(m[3]);
            if (!isfinite(height) || !isfinite(mant) || !isfinite(sgn)
                || height < 0 || (sgn !== 1 && sgn !== -1)) {
                return NAN;
            }
            return Impl.canonical(sgn, Rank.addFinite(Rank.ZERO, height), mant);
        }
        if (tag === "p") {
            return Impl.parseString(body);
        }
        return NAN;
    }

    // Public ladder access, so a game can walk the series without holding a
    // value for every row. Names come back null past the cap and for a spelling
    // the composer would never write.
    function illionName(i) {
        const out = Suffix.illionName(i);
        return out === undefined ? null : out;
    }

    function plexName(k) {
        const out = Suffix.plexName(k);
        return out === undefined ? null : out;
    }

    function illionIndex(name) {
        if (typeof name !== "string") {
            return null;
        }
        const out = Suffix.illionIndexOf(lowerText(name));
        return out === undefined ? null : out;
    }

    function plexIndex(name) {
        if (typeof name !== "string") {
            return null;
        }
        const out = Suffix.plexIndexOf(lowerText(name));
        return out === undefined ? null : out;
    }

    // The value behind a ladder name, so a game can walk the series by index
    // without ever spelling a name and inverting one. Keeping the two tiers
    // separate matters above a = 4, where neighbours share one log10 but
    // illionValue still knows which row it was asked for.
    function illionValue(i) {
        const out = Suffix.illionValue(i);
        return out === undefined ? null : out;
    }

    function plexValue(k) {
        const out = Suffix.plexValue(k);
        return out === undefined ? null : out;
    }

    function illionExp(i) {
        const out = Suffix.illionExp(i);
        return out === undefined ? null : out;
    }

    // Views rather than tables: indexing one composes the name on demand, so a
    // hundred million possible names cost nothing until a caller asks for one.
    ZubaNum.ILLION = Suffix.ILLION;
    ZubaNum.PLEX = Suffix.PLEX;
    ZubaNum.LADDER_CAP = Suffix.CAP;

    // Wiring --------------------------------------------------------------
    // Names are installed on the namespace itself, so a value created by
    // Object.create(ZubaNum) reaches every function through its prototype:
    // the method form `x.add(1)` and the static form `Z.add(x, 1)` share one
    // implementation.

    const EXPORTS = {
        new: ZubaNum_new,
        fromNumber, fromString, toSuffix, fromSuffix, toName, fromName,
        fromTable, fromRank, fromLog10, toLog10, clone,
        tree, sscg, loader, bb, rayo, fish, fish7,
        ackermann, family, defineFamily, familyInfo, families,
        aleph, beth, cardSucc, alephFixed, bethFixed, fgh, hardy,
        isCard, isFgh, isHardy, getCard, getFgh, tierOf,
        beaf, toBEAF, hyperE, fromHyperE, toHyperE, hyperFamily,
        nest, nestInfo, nestDepth, spend,
        toArrow, factorial, digits, sum, product, clamp,
        gcd, lcm, cbrt, gamma, lambertW,
        sin, cos, tan, asin, acos, atan, atan2,
        lerpLog, randLin, randLog, geoTerm, geoSum, geoCount,
        toLetters, fromLetters, graham, explain, toSave, fromSave,
        illionName, plexName, illionIndex, plexIndex, illionValue, plexValue,
        illionExp,
        cmp, eq, ne, lt, lte, gt, gte, min, max,
        isNaN: isNaNValue, isFinite: isFiniteKind, isTower, isNamed, isHyper,
        isCap, isZero, isZuba: isZubaPublic,
        getHyper, getAnchor, getKind, getSign, getFamily,
        add, sub, mul, div, neg, abs, pow, mod, floor, ceil, round, succ, pred,
        log10: log10Of, ln, log, logBase, exp, sqrt, root, slog,
        tetrate, pentation, hyperoperation, arrow,
        lift: liftPublic, layerAdd: layerAddPublic,
        omegaTower, epsilonTower, zetaTower, etaTower, phiTower,
        gammaTower, svoTower, lvoTower, gammaOmegaTower, bhoTower, sboTower,
        lboTower, tfbTower, ebhoTower, weakInaccessibleTower, weakMahloTower,
        weakCompactTower,
        getRank, getMantissa, toNumber, toTable, toJSON, fromJSON, format, parse,
        // Alternate spellings.
        compare: cmp, le: lte, ge: gte, isNan: isNaNValue, negate: neg,
        power: pow, isMega: isNamed, isCeiling: isCap,
        hyper: hyperoperation, serialize: toJSON, deserialize: fromJSON,
        ack: ackermann, nextCardinal: cardSucc,
    };

    // The grid family factories (aperiote / expande / ... with each name, alias
    // and code) are two-argument constructors, so they are installed with the
    // same spelling set the registry table carries.
    Object.assign(EXPORTS, API_GRID_FACTORIES);

    for (const key of Object.keys(EXPORTS)) {
        const raw = EXPORTS[key];
        ZubaNum[key] = function (...args) {
            if (this !== ZubaNum && Impl.isZuba(this)) {
                args.unshift(this);
            }
            return raw.apply(null, args);
        };
    }

    ZubaNum.Rank = RankAPI;
    ZubaNum.Ordinal = RankAPI;

    // Operator-style helpers, also reachable straight off the namespace.
    ZubaNum.meta = meta;
    ZubaNum.__add = meta.add;
    ZubaNum.__sub = meta.sub;
    ZubaNum.__mul = meta.mul;
    ZubaNum.__div = meta.div;
    ZubaNum.__mod = meta.mod;
    ZubaNum.__pow = meta.pow;
    ZubaNum.__unm = meta.unm;
    ZubaNum.__eq = meta.eq;
    ZubaNum.__lt = meta.lt;
    ZubaNum.__le = meta.le;
    ZubaNum.__tostring = meta.tostring;
    ZubaNum.__concat = meta.concat;

    // String and numeric coercion. `String(v)` / `${v}` print the formatted
    // value; `+v` / `v * 2` collapse to the nearest double (Infinity for
    // values above the finite range), matching ZubaNum.toNumber.
    ZubaNum.toString = function (v, style) {
        if (this === ZubaNum) {
            return v === undefined ? ZubaNum.NAME : format(v, style);
        }
        if (Impl.isZuba(this)) {
            return format(this, v);
        }
        return format(v, style);
    };

    ZubaNum.valueOf = function () {
        if (this === ZubaNum || !Impl.isZuba(this)) {
            return NaN;
        }
        return Impl.toNumber(this);
    };

    ZubaNum[Symbol.toPrimitive] = function (hint) {
        if (this === ZubaNum || !Impl.isZuba(this)) {
            return hint === "string" ? ZubaNum.NAME : NaN;
        }
        if (hint === "string") {
            return Impl.format(this);
        }
        return Impl.toNumber(this);
    };

    // `instanceof` would otherwise compare against ZubaNum.prototype, which
    // is not the prototype of values; brand checks are the source of truth.
    Object.defineProperty(ZubaNum, Symbol.hasInstance, {
        configurable: true,
        value: (v) => Impl.isZuba(v),
    });
    ZubaNum[Symbol.toStringTag] = ZubaNum.NAME;

    // Freeze shared constants so accidental field writes cannot corrupt the
    // library's canonical zero/nan/cap values or the ordinal constants.
    const valueConstants = [
        ZERO, ONE, TEN, NAN, CAP, NEG_CAP, MAX_TOWER, NEG_MAX_TOWER,
        GRAHAM, TREE3, TREE4, SSCG2, SSCG3, SSCG4, LOADER, BB5, BB6,
        RAYO, FISH7,
        ALEPH0, ALEPH1, ALEPH2, ALEPH3, ALEPH_OMEGA, ALEPH_FP1,
        BETH0, BETH1,
    ];
    for (let i = 0; i < valueConstants.length; i++) {
        Object.freeze(valueConstants[i]);
    }
    const rankConstants = [
        Rank.ZERO, Rank.OMEGA, Rank.EPS0, Rank.ZETA0, Rank.ETA0,
        Rank.GAMMA0, Rank.GAMMA_OMEGA, Rank.SVO, Rank.LVO, Rank.BHO,
        Rank.SBO, Rank.LBO, Rank.TFB, Rank.EBHO, Rank.WEAK_INV,
        Rank.WEAK_MAHLO, Rank.WEAK_COMPACT, RankAPI.one,
    ];
    for (let i = 0; i < rankConstants.length; i++) {
        const r = rankConstants[i];
        for (let j = 0; j < r.terms.length; j++) {
            Object.freeze(r.terms[j]);
        }
        Object.freeze(r.terms);
        Object.freeze(r);
    }

    return ZubaNum;
});
