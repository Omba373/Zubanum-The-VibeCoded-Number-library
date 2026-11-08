/*
    buza v1.0.0 - the analysis companion to ZubaNum.

    ZubaNum answers "how big is this number and what is it called". buza
    answers the questions a growth loop asks next: what a gamma costs, what a
    factorial of something that is not a whole number gives, and what base
    produces a tower when it is stacked. It requires ZubaNum and adds nothing
    to it, so the core keeps its size and its version.

    Every function takes and returns a ZubaNum value, so results order against
    each other and against anything the core produces. A plain number is
    accepted anywhere a value is.

    What is in here
    * Gamma family: logGamma (ln of the magnitude of Gamma), digamma, and the
      regularized incomplete gammas gammaLower and gammaUpper.
    * Factorials: factorialDec for arguments that are not integers,
      multifactorial and doubleFactorial for stepped products, and
      fallingFactorial and risingFactorial for the Pochhammer products.
    * Roots: nthRoot for the plain root, superRoot for the base of a tower,
      and hyperRoot for either at a chosen hyperoperation level.
    * beta and binomial.

    Boundaries, stated rather than discovered by a game at run time:
    * gammaLower, gammaUpper and beta are answers in a bounded range, so an
      argument a double cannot hold gives NaN. logGamma, digamma, factorialDec,
      multifactorial and the roots do have a real answer past the double
      window, and the tower branch gives it from the leading term of the same
      series, which is truthful because the dropped terms are far below what
      the representation can distinguish.
    * logGamma is NaN at the poles of Gamma, and digamma at the same integers.
    * superRoot and hyperRoot solve for a base, need a target above 1, and stop
      with NaN when the base sits past the six log levels the search can walk.
      They are searches, so they cost a few hundred core calls per answer; the
      rest of the module is closed form.
    * multifactorial and the two Pochhammer products need a whole-number
      count. A decimal argument to a stepped product has no agreed value, so
      it gives NaN instead of inventing one; factorialDec is the decimal one.

    Accuracy comes from the same place as the core's: double arithmetic with
    each series truncated where the next term falls below one unit in the last
    place of the result. The published values were checked against an
    arbitrary-precision reference computed outside this library.
*/

(function (root, factory) {
    const api = factory(require("./ZubaNum.js"));
    if (typeof module === "object" && module !== null && module.exports) {
        module.exports = api;
    }
    if (typeof exports === "object" && exports !== null) {
        exports.buza = api;
    }
    if (root) {
        root.buza = api;
    }
})(typeof globalThis !== "undefined" ? globalThis
    : typeof window !== "undefined" ? window
        : typeof self !== "undefined" ? self : null, function (ZubaNum) {
    "use strict";

    const Buza = {};

    Buza.VERSION = "1.0.0";
    Buza.ZubaNum = ZubaNum;

    const NAN = ZubaNum.NAN;
    const ZERO = ZubaNum.ZERO;
    const ONE = ZubaNum.ONE;
    const TEN = ZubaNum.fromNumber(10);

    const LOG10_E = 0.4342944819032518;
    const HALF_LOG_2PI = 0.9189385332046727;
    const PI = Math.PI;
    const DOUBLE_LOG_MAX = 709.782712893384;

    // Series anchor. At 30 the next Stirling term is near 1e-19, below one unit
    // in the last place of the logarithm it corrects, so the truncation is free.
    const ANCHOR = 30;
    const SERIES_STOP = 1e-17;
    const TINY = 1e-300;
    const LOOP_LIMIT = 100000;

    function isDouble(n) {
        return typeof n === "number" && n === n && n < Infinity && n > -Infinity;
    }

    // The argument as a double, or null when it does not fit in one. Values that
    // are infinite, named, cardinal or NaN answer null too, which is what sends a
    // caller to the tower branch.
    function doubleOf(v) {
        if (ZubaNum.getKind(v) !== "finite") {
            return null;
        }
        const n = ZubaNum.toNumber(v);
        return isDouble(n) ? n : null;
    }

    function isPositiveScale(v) {
        const kind = ZubaNum.getKind(v);
        if (kind === "finite") {
            return ZubaNum.toNumber(v) > 0;
        }
        return (kind === "tower" || kind === "cap") && ZubaNum.getSign(v) > 0;
    }

    function whole(n) {
        return n % 1 === 0;
    }

    // ------------------------------------------------------------------------
    // gamma
    // ------------------------------------------------------------------------

    // ln|Gamma(x)| for a double x. The shifted Stirling path carries everything
    // from a half upward; the reflection formula covers below a half, which is
    // also the branch that reaches the negative side.
    function logGammaNumber(x) {
        if (x !== x || x === Infinity || x === -Infinity) {
            return null;
        }
        if (x <= 0 && whole(x)) {
            return null;
        }
        if (x < 0.5) {
            const s = Math.abs(Math.sin(PI * x));
            if (s === 0) {
                return null;
            }
            const up = logGammaNumber(1 - x);
            if (up === null) {
                return null;
            }
            return Math.log(PI / s) - up;
        }
        let y = x;
        let logProd = 0;
        while (y < ANCHOR) {
            logProd += Math.log(y);
            y += 1;
        }
        const y2 = y * y;
        const series = 1 / (12 * y) - 1 / (360 * y * y2) + 1 / (1260 * y * y2 * y2)
            - 1 / (1680 * y * y2 * y2 * y2) + 1 / (1188 * y * y2 * y2 * y2 * y2);
        return (y - 0.5) * Math.log(y) - y + HALF_LOG_2PI + series - logProd;
    }

    // psi(x) for a double x, on the same shifted-series shape. The reflection
    // psi(x) = psi(1 - x) + pi / tan(pi x) covers the negative side.
    function digammaNumber(x) {
        if (x !== x || x === Infinity || x === -Infinity) {
            return null;
        }
        if (x <= 0 && whole(x)) {
            return null;
        }
        if (x < 0) {
            const t = Math.tan(PI * x);
            if (t === 0) {
                return null;
            }
            const up = digammaNumber(1 - x);
            if (up === null) {
                return null;
            }
            return up + PI / t;
        }
        let y = x;
        let acc = 0;
        while (y < ANCHOR) {
            acc -= 1 / y;
            y += 1;
        }
        const y2 = y * y;
        const series = -1 / (12 * y2) + 1 / (120 * y2 * y2) - 1 / (252 * y2 * y2 * y2)
            + 1 / (240 * y2 * y2 * y2 * y2) - 1 / (132 * y2 * y2 * y2 * y2 * y2);
        return Math.log(y) - 1 / (2 * y) + series + acc;
    }

    // log Gamma of a scale no double can hold. The answer is x log x - x, and it
    // is factored as x (log x - 1) rather than subtracted at the end: at a tower
    // the correction is far below the representation grid, so x log x lands on
    // the same point as x and the subtraction would report zero.
    function logGammaScale(v) {
        return ZubaNum.mul(v, ZubaNum.sub(ZubaNum.ln(v), ONE));
    }

    Buza.logGamma = function (v) {
        const n = doubleOf(v);
        if (n !== null) {
            if (n > 2.5e305) {
                const ln = (n - 0.5) * Math.log(n) - n + HALF_LOG_2PI;
                if (isDouble(ln)) {
                    return ZubaNum.fromNumber(ln);
                }
            } else {
                const ln = logGammaNumber(n);
                if (ln !== null) {
                    return ZubaNum.fromNumber(ln);
                }
                return NAN;
            }
        } else if (!isPositiveScale(v)) {
            return NAN;
        }
        return logGammaScale(v);
    };

    Buza.digamma = function (v) {
        const n = doubleOf(v);
        if (n !== null) {
            const out = digammaNumber(n);
            if (out !== null) {
                return ZubaNum.fromNumber(out);
            }
            return NAN;
        }
        if (!isPositiveScale(v)) {
            return NAN;
        }
        // psi(x) = ln x + 1/(2x) + O(x^-2), and no correction can show once x is
        // past a double.
        return ZubaNum.ln(v);
    };

    // Regularized lower incomplete gamma P(a, x): the rising series while x is on
    // the near side of the peak, one minus the continued fraction past it.
    function lowerNumber(a, x) {
        if (a <= 0 || x < 0) {
            return null;
        }
        if (x === 0) {
            return 0;
        }
        const lg = logGammaNumber(a);
        if (lg === null) {
            return null;
        }
        const head = Math.exp(-x + a * Math.log(x) - lg);
        if (x < a + 1) {
            let term = 1 / a;
            let total = term;
            for (let n = 1; n <= LOOP_LIMIT; n++) {
                term = term * x / (a + n);
                total += term;
                if (Math.abs(term) < Math.abs(total) * SERIES_STOP) {
                    break;
                }
            }
            return total * head;
        }
        let b = x + 1 - a;
        let c = 1 / TINY;
        let d = 1 / b;
        let h = d;
        for (let i = 1; i <= LOOP_LIMIT; i++) {
            const an = -i * (i - a);
            b += 2;
            d = an * d + b;
            if (Math.abs(d) < TINY) {
                d = TINY;
            }
            c = b + an / c;
            if (Math.abs(c) < TINY) {
                c = TINY;
            }
            d = 1 / d;
            const delta = d * c;
            h *= delta;
            if (Math.abs(delta - 1) < SERIES_STOP) {
                break;
            }
        }
        return 1 - head * h;
    }

    Buza.gammaLower = function (v, w) {
        const a = doubleOf(v);
        const x = doubleOf(w);
        if (a === null || x === null) {
            return NAN;
        }
        const out = lowerNumber(a, x);
        if (out === null) {
            return NAN;
        }
        return ZubaNum.fromNumber(out);
    };

    Buza.gammaUpper = function (v, w) {
        const a = doubleOf(v);
        const x = doubleOf(w);
        if (a === null || x === null) {
            return NAN;
        }
        const out = lowerNumber(a, x);
        if (out === null) {
            return NAN;
        }
        return ZubaNum.fromNumber(1 - out);
    };

    Buza.beta = function (v, w) {
        const a = doubleOf(v);
        const b = doubleOf(w);
        if (a === null || b === null || a <= 0 || b <= 0) {
            return NAN;
        }
        const la = logGammaNumber(a);
        const lb = logGammaNumber(b);
        const lab = logGammaNumber(a + b);
        if (la === null || lb === null || lab === null) {
            return NAN;
        }
        return ZubaNum.fromNumber(Math.exp(la + lb - lab));
    };

    // ------------------------------------------------------------------------
    // factorials
    // ------------------------------------------------------------------------

    // e raised to a natural log, moved into log space when the exponent pushes
    // the answer past the double window, the way the rest of the library does.
    function fromNaturalLog(ln) {
        if (ln === null) {
            return NAN;
        }
        if (typeof ln !== "number") {
            return ZubaNum.exp(ln);
        }
        if (!isDouble(ln)) {
            return NAN;
        }
        if (ln < DOUBLE_LOG_MAX) {
            return ZubaNum.fromNumber(Math.exp(ln));
        }
        return ZubaNum.fromLog10(ln * LOG10_E);
    }

    function factorialExact(n) {
        let acc = 1;
        for (let k = 2; k <= n; k++) {
            acc *= k;
            if (!isDouble(acc)) {
                return null;
            }
        }
        return acc;
    }

    Buza.factorialDec = function (v) {
        const n = doubleOf(v);
        if (n !== null) {
            if (n < 0 && whole(n)) {
                return NAN;
            }
            if (n >= 0 && whole(n) && n <= 170) {
                return ZubaNum.fromNumber(factorialExact(n));
            }
            if (n > 2.5e305) {
                return ZubaNum.exp(logGammaScale(ZubaNum.add(v, 1)));
            }
            const ln = logGammaNumber(n + 1);
            if (ln === null) {
                return NAN;
            }
            return fromNaturalLog(ln);
        }
        if (!isPositiveScale(v)) {
            return NAN;
        }
        return ZubaNum.exp(logGammaScale(ZubaNum.add(v, 1)));
    };

    // Stepped product x (x-k) (x-2k) ... down to the last factor above zero. A
    // short product is multiplied out. A long one uses the closed form
    // k^m Gamma(m + 1 + r/k) / Gamma(1 + r/k), which is the same factors written
    // through Gamma and stays exact for whole numbers.
    Buza.multifactorial = function (v, w) {
        const step = doubleOf(w);
        if (step === null || step < 1 || !whole(step)) {
            return NAN;
        }
        if (step === 1) {
            return ZubaNum.clone(v);
        }
        const n = doubleOf(v);
        if (n === null) {
            if (!isPositiveScale(v)) {
                return NAN;
            }
            // ln of the product is n ln n / k once n is past a double, with the
            // next term far below what the tower can show.
            return ZubaNum.exp(ZubaNum.div(ZubaNum.mul(v, ZubaNum.ln(v)), step));
        }
        if (n < 0 || !whole(n)) {
            return NAN;
        }
        const m = Math.floor(n / step);
        if (m <= LOOP_LIMIT) {
            let acc = 1;
            let at = n;
            while (at > 1) {
                acc *= at;
                if (!isDouble(acc)) {
                    break;
                }
                at -= step;
            }
            if (at <= 1) {
                return ZubaNum.fromNumber(acc);
            }
        }
        const r = n - m * step;
        const la = logGammaNumber(m + 1 + r / step);
        const lb = logGammaNumber(1 + r / step);
        if (la === null || lb === null) {
            return NAN;
        }
        return fromNaturalLog(m * Math.log(step) + la - lb);
    };

    Buza.doubleFactorial = function (v) {
        return Buza.multifactorial(v, 2);
    };

    Buza.fallingFactorial = function (v, w) {
        const count = doubleOf(w);
        if (count === null || count < 0 || !whole(count)) {
            return NAN;
        }
        if (count === 0) {
            return ONE;
        }
        if (count <= 1000) {
            let acc = ONE;
            for (let i = 0; i < count; i++) {
                acc = ZubaNum.mul(acc, ZubaNum.sub(v, i));
            }
            return acc;
        }
        const n = doubleOf(v);
        if (n === null || n < count) {
            return NAN;
        }
        const top = logGammaNumber(n + 1);
        const bottom = logGammaNumber(n - count + 1);
        if (top === null || bottom === null) {
            return NAN;
        }
        return fromNaturalLog(top - bottom);
    };

    Buza.risingFactorial = function (v, w) {
        const count = doubleOf(w);
        if (count === null || count < 0 || !whole(count)) {
            return NAN;
        }
        if (count === 0) {
            return ONE;
        }
        if (count <= 1000) {
            let acc = ONE;
            for (let i = 0; i < count; i++) {
                acc = ZubaNum.mul(acc, ZubaNum.add(v, i));
            }
            return acc;
        }
        return Buza.fallingFactorial(ZubaNum.add(v, count - 1), count);
    };

    // ------------------------------------------------------------------------
    // binomial
    // ------------------------------------------------------------------------

    // C(n, k). A whole n at least as large as k takes the symmetry and the
    // factorial form, which keeps an integer answer whole; any other n takes the
    // rising ratio, which is the definition off the integers.
    Buza.binomial = function (v, w) {
        let k = doubleOf(w);
        if (k === null || k < 0 || !whole(k)) {
            return NAN;
        }
        if (k === 0) {
            return ONE;
        }
        const n = doubleOf(v);
        let symmetric = false;
        if (n !== null && n >= 0 && whole(n)) {
            if (k > n) {
                return ZERO;
            }
            if (n - k < k) {
                k = n - k;
            }
            symmetric = true;
        }
        if (k <= 1000) {
            if (symmetric) {
                let num = ONE;
                let den = 1;
                for (let j = 0; j < k; j++) {
                    num = ZubaNum.mul(num, ZubaNum.sub(v, j));
                    den *= j + 1;
                }
                return ZubaNum.div(num, den);
            }
            let acc = ONE;
            for (let j = 0; j < k; j++) {
                acc = ZubaNum.mul(acc, ZubaNum.div(ZubaNum.sub(v, j), j + 1));
            }
            return acc;
        }
        if (n === null || !symmetric) {
            return NAN;
        }
        const top = logGammaNumber(n + 1);
        const mid = logGammaNumber(n - k + 1);
        const bottom = logGammaNumber(k + 1);
        if (top === null || mid === null || bottom === null) {
            return NAN;
        }
        return fromNaturalLog(top - mid - bottom);
    };

    // ------------------------------------------------------------------------
    // roots
    // ------------------------------------------------------------------------

    Buza.nthRoot = function (v, w) {
        return ZubaNum.root(v, w);
    };

    // The unknown is t = log10 of the base, searched as a ZubaNum value so the
    // answer is not limited to what a double can hold. The bracket grows by
    // 10^t, which reaches any height in a handful of steps. Each trial is
    // compared through the core's own forward operation, so the result is a
    // fixed point of the hyperoperation rather than of a private approximation.
    function pow10(v) {
        return ZubaNum.pow(TEN, v);
    }

    const PEEL_LIMIT = 6;

    // Once the bracket is past a double the search moves down the log10 chain to
    // the level where both ends are still doubles, because multiplying a tower
    // by one half is a no-op here: the finite factor falls below the grid the
    // tower sits on. Bisecting at the collapsed level would report a base that
    // is simply wrong rather than reporting no base, which is the worse failure.
    function solveBase(forward) {
        let lo = ZERO;
        let hi = ONE;
        let covered = forward(hi) >= 0;
        let growth = 0;
        while (!covered && growth < 64) {
            lo = hi;
            hi = pow10(hi);
            growth += 1;
            covered = forward(hi) >= 0;
        }
        if (!covered) {
            return null;
        }
        let peel = 0;
        while (ZubaNum.getKind(hi) !== "finite" && peel < PEEL_LIMIT) {
            lo = ZubaNum.log10(lo);
            hi = ZubaNum.log10(hi);
            peel += 1;
        }
        if (ZubaNum.getKind(hi) !== "finite" || ZubaNum.getKind(lo) !== "finite") {
            return null;
        }
        let loN = ZubaNum.toNumber(lo);
        let hiN = ZubaNum.toNumber(hi);
        for (let i = 0; i < 220; i++) {
            const mid = (loN + hiN) * 0.5;
            if (mid === loN || mid === hiN) {
                break;
            }
            let t = ZubaNum.fromNumber(mid);
            for (let k = 0; k < peel; k++) {
                t = pow10(t);
            }
            if (forward(t) < 0) {
                loN = mid;
            } else {
                hiN = mid;
            }
        }
        let t = ZubaNum.fromNumber((loN + hiN) * 0.5);
        for (let k = 0; k < peel; k++) {
            t = pow10(t);
        }
        return pow10(t);
    }

    Buza.superRoot = function (v, w) {
        const height = doubleOf(w);
        if (height === null || height < 2 || !whole(height)) {
            return NAN;
        }
        if (ZubaNum.getKind(v) === "nan" || ZubaNum.compare(v, ONE) <= 0) {
            return NAN;
        }
        const out = solveBase(function (t) {
            return ZubaNum.compare(ZubaNum.tetrate(pow10(t), height), v);
        });
        if (out === null) {
            return NAN;
        }
        return out;
    };

    Buza.hyperRoot = function (v, w, level) {
        const operand = doubleOf(w);
        const order = Number(level);
        if (operand === null || !isDouble(order) || order < 3 || !whole(order)) {
            return NAN;
        }
        if (order === 3) {
            return ZubaNum.root(v, operand);
        }
        if (operand < 2) {
            return NAN;
        }
        if (ZubaNum.getKind(v) === "nan" || ZubaNum.compare(v, ONE) <= 0) {
            return NAN;
        }
        const out = solveBase(function (t) {
            return ZubaNum.compare(ZubaNum.hyperoperation(order, pow10(t), operand), v);
        });
        if (out === null) {
            return NAN;
        }
        return out;
    };

    return Buza;
});
