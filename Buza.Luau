--[[
    buza - the analysis companion to ZubaNum.

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
]]

local ZubaNum

if script ~= nil then
    -- In Studio this ModuleScript sits under ZubaNum, so its parent is the
    -- core module itself.
    ZubaNum = require(script.Parent.ZubaNum)
else
    ZubaNum = require("./ZubaNum")
end

local Buza = {}

Buza.VERSION = "1.0.0"
Buza.ZubaNum = ZubaNum

local NAN = ZubaNum.NAN
local ZERO = ZubaNum.ZERO
local ONE = ZubaNum.ONE
local TEN = ZubaNum.fromNumber(10)

local LOG10_E = 0.4342944819032518
local HALF_LOG_2PI = 0.9189385332046727
local PI = math.pi
local DOUBLE_LOG_MAX = 709.782712893384

-- Series anchor. At 30 the next Stirling term is near 1e-19, below one unit in
-- the last place of the logarithm it corrects, so the truncation is free.
local ANCHOR = 30
local SERIES_STOP = 1e-17
local TINY = 1e-300
local LOOP_LIMIT = 100000

local function isDouble(n)
    return type(n) == "number" and n == n and n < math.huge and n > -math.huge
end

-- The argument as a double, or nil when it does not fit in one. Values that
-- are infinite, named, cardinal or NaN answer nil too, which is what sends a
-- caller to the tower branch.
local function doubleOf(v)
    if ZubaNum.getKind(v) ~= "finite" then
        return nil
    end
    local n = ZubaNum.toNumber(v)
    return isDouble(n) and n or nil
end

local function isPositiveScale(v)
    local kind = ZubaNum.getKind(v)
    if kind == "finite" then
        return ZubaNum.toNumber(v) > 0
    end
    return (kind == "tower" or kind == "cap") and ZubaNum.getSign(v) > 0
end

local function whole(n)
    return n % 1 == 0
end

--------------------------------------------------------------------------------
-- gamma
--------------------------------------------------------------------------------

-- ln|Gamma(x)| for a double x. The shifted Stirling path carries everything
-- from a half upward; the reflection formula covers below a half, which is
-- also the branch that reaches the negative side.
local function logGammaNumber(x)
    if x ~= x or x == math.huge or x == -math.huge then
        return nil
    end
    if x <= 0 and whole(x) then
        return nil
    end
    if x < 0.5 then
        local s = math.abs(math.sin(PI * x))
        if s == 0 then
            return nil
        end
        local up = logGammaNumber(1 - x)
        if up == nil then
            return nil
        end
        return math.log(PI / s) - up
    end
    local y = x
    local logProd = 0
    while y < ANCHOR do
        logProd = logProd + math.log(y)
        y = y + 1
    end
    local y2 = y * y
    local series = 1 / (12 * y) - 1 / (360 * y * y2) + 1 / (1260 * y * y2 * y2)
        - 1 / (1680 * y * y2 * y2 * y2) + 1 / (1188 * y * y2 * y2 * y2 * y2)
    return (y - 0.5) * math.log(y) - y + HALF_LOG_2PI + series - logProd
end

-- psi(x) for a double x, on the same shifted-series shape. The reflection
-- psi(x) = psi(1 - x) + pi / tan(pi x) covers the negative side.
local function digammaNumber(x)
    if x ~= x or x == math.huge or x == -math.huge then
        return nil
    end
    if x <= 0 and whole(x) then
        return nil
    end
    if x < 0 then
        local t = math.tan(PI * x)
        if t == 0 then
            return nil
        end
        local up = digammaNumber(1 - x)
        if up == nil then
            return nil
        end
        return up + PI / t
    end
    local y = x
    local acc = 0
    while y < ANCHOR do
        acc = acc - 1 / y
        y = y + 1
    end
    local y2 = y * y
    local series = -1 / (12 * y2) + 1 / (120 * y2 * y2) - 1 / (252 * y2 * y2 * y2)
        + 1 / (240 * y2 * y2 * y2 * y2) - 1 / (132 * y2 * y2 * y2 * y2 * y2)
    return math.log(y) - 1 / (2 * y) + series + acc
end

-- log Gamma of a scale no double can hold. The answer is x log x - x, and it
-- is factored as x (log x - 1) rather than subtracted at the end: at a tower
-- the correction is far below the representation grid, so x log x lands on the
-- same point as x and the subtraction would report zero.
local function logGammaScale(v)
    return ZubaNum.mul(v, ZubaNum.sub(ZubaNum.ln(v), ONE))
end

function Buza.logGamma(v)
    local n = doubleOf(v)
    if n ~= nil then
        if n > 2.5e305 then
            local ln = (n - 0.5) * math.log(n) - n + HALF_LOG_2PI
            if isDouble(ln) then
                return ZubaNum.fromNumber(ln)
            end
        else
            local ln = logGammaNumber(n)
            if ln ~= nil then
                return ZubaNum.fromNumber(ln)
            end
            return NAN
        end
    elseif not isPositiveScale(v) then
        return NAN
    end
    return logGammaScale(v)
end

function Buza.digamma(v)
    local n = doubleOf(v)
    if n ~= nil then
        local out = digammaNumber(n)
        if out ~= nil then
            return ZubaNum.fromNumber(out)
        end
        return NAN
    end
    if not isPositiveScale(v) then
        return NAN
    end
    -- psi(x) = ln x + 1/(2x) + O(x^-2), and no correction can show once x is
    -- past a double.
    return ZubaNum.ln(v)
end

-- Regularized lower incomplete gamma P(a, x): the rising series while x is on
-- the near side of the peak, one minus the continued fraction past it.
local function lowerNumber(a, x)
    if a <= 0 or x < 0 then
        return nil
    end
    if x == 0 then
        return 0
    end
    local lg = logGammaNumber(a)
    if lg == nil then
        return nil
    end
    local head = math.exp(-x + a * math.log(x) - lg)
    if x < a + 1 then
        local term = 1 / a
        local total = term
        for n = 1, LOOP_LIMIT do
            term = term * x / (a + n)
            total = total + term
            if math.abs(term) < math.abs(total) * SERIES_STOP then
                break
            end
        end
        return total * head
    end
    local b = x + 1 - a
    local c = 1 / TINY
    local d = 1 / b
    local h = d
    for i = 1, LOOP_LIMIT do
        local an = -i * (i - a)
        b = b + 2
        d = an * d + b
        if math.abs(d) < TINY then
            d = TINY
        end
        c = b + an / c
        if math.abs(c) < TINY then
            c = TINY
        end
        d = 1 / d
        local delta = d * c
        h = h * delta
        if math.abs(delta - 1) < SERIES_STOP then
            break
        end
    end
    return 1 - head * h
end

function Buza.gammaLower(v, w)
    local a = doubleOf(v)
    local x = doubleOf(w)
    if a == nil or x == nil then
        return NAN
    end
    local out = lowerNumber(a, x)
    if out == nil then
        return NAN
    end
    return ZubaNum.fromNumber(out)
end

function Buza.gammaUpper(v, w)
    local a = doubleOf(v)
    local x = doubleOf(w)
    if a == nil or x == nil then
        return NAN
    end
    local out = lowerNumber(a, x)
    if out == nil then
        return NAN
    end
    return ZubaNum.fromNumber(1 - out)
end

function Buza.beta(v, w)
    local a = doubleOf(v)
    local b = doubleOf(w)
    if a == nil or b == nil or a <= 0 or b <= 0 then
        return NAN
    end
    local la = logGammaNumber(a)
    local lb = logGammaNumber(b)
    local lab = logGammaNumber(a + b)
    if la == nil or lb == nil or lab == nil then
        return NAN
    end
    return ZubaNum.fromNumber(math.exp(la + lb - lab))
end

--------------------------------------------------------------------------------
-- factorials
--------------------------------------------------------------------------------

-- e raised to a natural log, moved into log space when the exponent pushes the
-- answer past the double window, the way the rest of the library does it.
local function fromNaturalLog(ln)
    if ln == nil then
        return NAN
    end
    if type(ln) ~= "number" then
        return ZubaNum.exp(ln)
    end
    if not isDouble(ln) then
        return NAN
    end
    if ln < DOUBLE_LOG_MAX then
        return ZubaNum.fromNumber(math.exp(ln))
    end
    return ZubaNum.fromLog10(ln * LOG10_E)
end

local function factorialExact(n)
    local acc = 1
    for k = 2, n do
        acc = acc * k
        if not isDouble(acc) then
            return nil
        end
    end
    return acc
end

function Buza.factorialDec(v)
    local n = doubleOf(v)
    if n ~= nil then
        if n < 0 and whole(n) then
            return NAN
        end
        if n >= 0 and whole(n) and n <= 170 then
            return ZubaNum.fromNumber(factorialExact(n))
        end
        if n > 2.5e305 then
            return ZubaNum.exp(logGammaScale(ZubaNum.add(v, 1)))
        end
        local ln = logGammaNumber(n + 1)
        if ln == nil then
            return NAN
        end
        return fromNaturalLog(ln)
    end
    if not isPositiveScale(v) then
        return NAN
    end
    return ZubaNum.exp(logGammaScale(ZubaNum.add(v, 1)))
end

-- Stepped product x (x-k) (x-2k) ... down to the last factor above zero. A
-- short product is multiplied out. A long one uses the closed form
-- k^m Gamma(m + 1 + r/k) / Gamma(1 + r/k), which is the same factors written
-- through Gamma and stays exact for whole numbers.
function Buza.multifactorial(v, w)
    local step = doubleOf(w)
    if step == nil or step < 1 or not whole(step) then
        return NAN
    end
    if step == 1 then
        return ZubaNum.clone(v)
    end
    local n = doubleOf(v)
    if n == nil then
        if not isPositiveScale(v) then
            return NAN
        end
        -- ln of the product is n ln n / k once n is past a double, with the
        -- next term far below what the tower can show.
        return ZubaNum.exp(ZubaNum.div(ZubaNum.mul(v, ZubaNum.ln(v)), step))
    end
    if n < 0 or not whole(n) then
        return NAN
    end
    local m = math.floor(n / step)
    if m <= LOOP_LIMIT then
        local acc = 1
        local at = n
        while at > 1 do
            acc = acc * at
            if not isDouble(acc) then
                break
            end
            at = at - step
        end
        if at <= 1 then
            return ZubaNum.fromNumber(acc)
        end
    end
    local r = n - m * step
    local la = logGammaNumber(m + 1 + r / step)
    local lb = logGammaNumber(1 + r / step)
    if la == nil or lb == nil then
        return NAN
    end
    return fromNaturalLog(m * math.log(step) + la - lb)
end

function Buza.doubleFactorial(v)
    return Buza.multifactorial(v, 2)
end

function Buza.fallingFactorial(v, w)
    local count = doubleOf(w)
    if count == nil or count < 0 or not whole(count) then
        return NAN
    end
    if count == 0 then
        return ONE
    end
    if count <= 1000 then
        local acc = ONE
        for i = 0, count - 1 do
            acc = ZubaNum.mul(acc, ZubaNum.sub(v, i))
        end
        return acc
    end
    local n = doubleOf(v)
    if n == nil or n < count then
        return NAN
    end
    local top = logGammaNumber(n + 1)
    local bottom = logGammaNumber(n - count + 1)
    if top == nil or bottom == nil then
        return NAN
    end
    return fromNaturalLog(top - bottom)
end

function Buza.risingFactorial(v, w)
    local count = doubleOf(w)
    if count == nil or count < 0 or not whole(count) then
        return NAN
    end
    if count == 0 then
        return ONE
    end
    if count <= 1000 then
        local acc = ONE
        for i = 0, count - 1 do
            acc = ZubaNum.mul(acc, ZubaNum.add(v, i))
        end
        return acc
    end
    return Buza.fallingFactorial(ZubaNum.add(v, count - 1), count)
end

--------------------------------------------------------------------------------
-- binomial
--------------------------------------------------------------------------------

-- C(n, k). A whole n at least as large as k takes the symmetry and the
-- factorial form, which keeps an integer answer whole; any other n takes the
-- rising ratio, which is the definition off the integers.
function Buza.binomial(v, w)
    local k = doubleOf(w)
    if k == nil or k < 0 or not whole(k) then
        return NAN
    end
    if k == 0 then
        return ONE
    end
    local n = doubleOf(v)
    local symmetric = nil
    if n ~= nil and n >= 0 and whole(n) then
        if k > n then
            return ZERO
        end
        if n - k < k then
            k = n - k
        end
        symmetric = true
    end
    if k <= 1000 then
        if symmetric ~= nil then
            local num = ONE
            local den = 1
            for j = 0, k - 1 do
                num = ZubaNum.mul(num, ZubaNum.sub(v, j))
                den = den * (j + 1)
            end
            return ZubaNum.div(num, den)
        end
        local acc = ONE
        for j = 0, k - 1 do
            acc = ZubaNum.mul(acc, ZubaNum.div(ZubaNum.sub(v, j), j + 1))
        end
        return acc
    end
    if n == nil or symmetric == nil then
        return NAN
    end
    local top = logGammaNumber(n + 1)
    local mid = logGammaNumber(n - k + 1)
    local bottom = logGammaNumber(k + 1)
    if top == nil or mid == nil or bottom == nil then
        return NAN
    end
    return fromNaturalLog(top - mid - bottom)
end

--------------------------------------------------------------------------------
-- roots
--------------------------------------------------------------------------------

function Buza.nthRoot(v, w)
    return ZubaNum.root(v, w)
end

-- The unknown is t = log10 of the base, searched as a ZubaNum value so the
-- answer is not limited to what a double can hold. The bracket grows by 10^t,
-- which reaches any height in a handful of steps. Each trial is compared
-- through the core's own forward operation, so the result is a fixed point of
-- the hyperoperation rather than of a private approximation.
local function pow10(v)
    return ZubaNum.pow(TEN, v)
end

local PEEL_LIMIT = 6

-- Once the bracket is past a double the search moves down the log10 chain to
-- the level where both ends are still doubles, because multiplying a tower by
-- one half is a no-op here: the finite factor falls below the grid the tower
-- sits on. Bisecting at the collapsed level would report a base that is simply
-- wrong rather than reporting no base, which is the worse failure.
local function solveBase(forward)
    local lo, hi = ZERO, ONE
    local covered = forward(hi) >= 0
    local growth = 0
    while not covered and growth < 64 do
        lo = hi
        hi = pow10(hi)
        growth = growth + 1
        covered = forward(hi) >= 0
    end
    if not covered then
        return nil
    end
    local peel = 0
    while ZubaNum.getKind(hi) ~= "finite" and peel < PEEL_LIMIT do
        lo, hi = ZubaNum.log10(lo), ZubaNum.log10(hi)
        peel = peel + 1
    end
    if ZubaNum.getKind(hi) ~= "finite" or ZubaNum.getKind(lo) ~= "finite" then
        return nil
    end
    local loN, hiN = ZubaNum.toNumber(lo), ZubaNum.toNumber(hi)
    for _ = 1, 220 do
        local mid = (loN + hiN) * 0.5
        if mid == loN or mid == hiN then
            break
        end
        local t = ZubaNum.fromNumber(mid)
        for _ = 1, peel do
            t = pow10(t)
        end
        if forward(t) < 0 then
            loN = mid
        else
            hiN = mid
        end
    end
    local t = ZubaNum.fromNumber((loN + hiN) * 0.5)
    for _ = 1, peel do
        t = pow10(t)
    end
    return pow10(t)
end

function Buza.superRoot(v, w)
    local height = doubleOf(w)
    if height == nil or height < 2 or not whole(height) then
        return NAN
    end
    if ZubaNum.getKind(v) == "nan" or ZubaNum.compare(v, ONE) <= 0 then
        return NAN
    end
    local out = solveBase(function(t)
        return ZubaNum.compare(ZubaNum.tetrate(pow10(t), height), v)
    end)
    if out == nil then
        return NAN
    end
    return out
end

function Buza.hyperRoot(v, w, level)
    local operand = doubleOf(w)
    local order = tonumber(level)
    if operand == nil or order == nil or order < 3 or not whole(order) then
        return NAN
    end
    if order == 3 then
        return ZubaNum.root(v, operand)
    end
    if operand < 2 then
        return NAN
    end
    if ZubaNum.getKind(v) == "nan" or ZubaNum.compare(v, ONE) <= 0 then
        return NAN
    end
    local out = solveBase(function(t)
        return ZubaNum.compare(ZubaNum.hyperoperation(order, pow10(t), operand), v)
    end)
    if out == nil then
        return NAN
    end
    return out
end

return Buza
