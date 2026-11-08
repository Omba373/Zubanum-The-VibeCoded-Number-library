--!nonstrict
--!optimize 2
--[[
    ZubaNum v2.3.0
    A Roblox Luau big-number library with a finite
    TREE(3)/SSCG(3)/LOADER/BB/RAYO/FISH7 tier, unbounded family indices,
    Ackermann's function, a caller-extensible family registry, transfinite
    cardinals, the fast-growing and Hardy hierarchies, BEAF arrays, Hyper-E
    and the -ote family grid, hyper-nesting compression, composed -illion and
    -plex ladders that run to a stated cap, ordinal ranks past LVO up to the
    weakly compact ceiling, and a formal LIMIT ceiling.

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
        Z.hyperoperation(100, 2, 2)     -- 4
        Z.hyperoperation(100, 4, 2)     -- H(100, 4, 2), finite
        Z.hyperoperation(100, H, 2)     -- H(100, H(100, 4, 2), 2)
        Z.hyperoperation(100, TREE3, 2) -- H(100, TREE(3), 2), finite
    H(level, base, arg) is the application itself when the tower cannot be
    expanded in compact form. The plain band sits above every finite-rank
    tower and below every named-mega value; ordering inside it is level,
    then base, then arg, then power/coefficient/offset. As with the
    TREE/SSCG/BB bands, that ordering is a convention, not a proof. A named
    operand anchors the result inside that constant's band: H(100, TREE(3), 2)
    is above every plain TREE(3) value and below TREE(4), SSCG(3) and the
    later families. Infinite-rank towers and LIMIT still saturate.

    SSCG is Friedman's simple subcubic graph sequence:
        SSCG(0) = 2
        SSCG(1) = 5
        SSCG(2) = 3*2^(3*2^95) - 8  (~10^(3.5775e28), a finite tower here)
        SSCG(3) > TREE(3)           (named tier, above TREE(3))
    In the named tier each sequence has its own order band: TREE(n) uses
    band 1000 and SSCG(n) uses band 2000, so every named SSCG value ranks
    above every named TREE value (SSCG(3) dwarfs iterated TREE), while each
    sequence stays strictly increasing in its own index.

    Loader's number is the output of Ralph Loader's loader.c, a 512-byte
    entry in the 2001 ICFP programming contest. It is D^5(99), where D is
    Loader's function: D(k) accumulates the values of terminating programs
    in the calculus of constructions that fit in the encoded size k. The
    result is a finite integer that exceeds TREE(3) and SCG(13). The named
    tier gives it band 3000, above TREE (1000) and SSCG (2000).
        Z.loader(n) = D^n(99) is the Loader iteration ladder:
        Z.loader(0) = 99
        Z.loader(1) = D(99)
        ...
        Z.loader(5) = LOADER
        Z.loader(6) = D^6(99), etc.
    Loader values are named for n >= 1 and strictly increase with n. The
    iteration ladder is the computable extension of Loader's function; like
    all cross-family ordering here, it is a band convention, not a proof.

    Busy Beaver is Rado's Sigma(n): the maximum number of 1s an n-state,
    2-symbol Turing machine can write before halting. It is uncomputable and
    grows faster than every computable function, yet every Sigma(n) is a
    finite integer: Sigma(0..5) = 0, 1, 4, 6, 13, 4098, and Sigma(6) is
    still unknown. Z.bb(n) keeps the known small values as ordinary doubles
    and represents BB(6) and larger indices as named values. The named tier
    gives BB band 4000, above TREE (1000), SSCG (2000) and LOADER (3000).
    Whether an unknown BB(n) really exceeds a given Loader value is not
    settled; as with every cross-family band, the ordering here is a
    convention, not a proof.

    Rayo's number is the least positive integer greater than every positive
    integer nameable by a first-order set-theory expression of at most a
    googol (10^100) symbols. It is finite but uncomputable, and it outgrows
    the Busy Beaver values at feasible indices. Fish number 7 is
    F_7^63(10^100), a 63-fold iteration built on an extension of Rayo's
    function, so it is larger than Rayo's number. The named tier gives RAYO
    band 5000 and FISH7 band 6000, above BB (4000). Both are finite, so
    both stay below the infinite-rank towers and LIMIT. The band order is
    a convention; Rayo > BB(10^100) holds by definition and Fish 7 > Rayo
    by construction.

    Cardinals are the v1.8 tier. Z.aleph(x) is aleph_x and Z.beth(x) is
    beth_x for any index x this library can name, so the subscript keeps the
    full range of the value model:
        Z.aleph()               -- aleph_0, the first infinite cardinal
        Z.aleph(1) / Z.aleph(100)
        Z.aleph("rayo(1e100)")  -- a cardinal indexed by a named-mega value
        Z.aleph(Z.omega)        -- aleph_omega, indexed by an ordinal
        Z.aleph(Z.aleph(1))     -- aleph indexed by a cardinal
        Z.alephFixed(1)         -- the first aleph fixed point, aleph_k = k
    Subscripts are ordered fin < ord < card < fp: every finite value (double,
    tower, hyper or named constant) is below every infinite ordinal, every
    rank up to LVO is countable and therefore below omega_1, and a fixed
    point closes the ladder beneath it. That is why
    aleph(1e3003) < aleph(rayo) < aleph(omega) < aleph(aleph(1)): the first
    two are indexed by huge but finite integers, the third by the ordinal
    omega and the last by a cardinal.
    Z.cardSucc / Z.nextCardinal give the least cardinal above an argument,
    and Z.getCard returns op, mode, index and sign. Successor stays strict
    wherever the index can move: aleph(rayo) becomes aleph(RAYO+1). Where the
    index has already saturated the mantissa grid - aleph of 10^3003 - the
    subscript cannot change, so cardSucc returns the same cardinal, exactly
    as Z.succ returns 1e400 unchanged.

    Cardinal arithmetic follows ZFC and deliberately collapses: for infinite
    kappa and any smaller lambda, kappa + lambda = kappa * lambda = kappa,
    kappa - lambda = kappa when kappa is the larger, kappa / lambda = kappa
    for finite lambda, and kappa^n = kappa for finite n >= 1. 2^kappa is the
    power set, so 2^aleph_0 = beth_1 and exp(aleph_0) = beth_1. Exponent
    towers of cardinals use max(a, powerSet(b)). Cardinal comparisons return
    false for Z.eq/lt/gte where ZFC decides nothing, such as aleph_1 against
    beth_1 or aleph_omega against beth_0; the formatting of those values is
    unaffected and min/max fall back to the subscript convention so a game
    loop never sees NaN.

    Family indices are unbounded: TREE(TREE(3)), BB(RAYO) and TREE(ω) are legal
    named values, ordered by the same subscript ladder the cardinal subscripts
    use, so Z.rayo("1e3003") is RAYO(1e+3003) instead of NaN. An integer index
    keeps the numeric field and stays allocation-free; anything else becomes a
    formal subscript. Indices below a family's minimum and spellings that cannot
    be read - LIMIT, garbage text, non-integers - stay rejected, and the
    cardinal subscripts are unchanged: aleph("1e3003") is aleph of the finite
    integer 10^3003, and aleph(rayo()) is aleph of a named-mega value.

    Z.ackermann(m, n), alias Z.ack, is Ackermann's function on the identity
    A(0,n) = n+1 and A(m,n) = H_m(2, n+3) - 3 for m >= 1, so it is exact
    wherever the hyperoperation band is exact - A(3,3) is 61, A(4,1) is 65533 -
    and a level past that window stays a formal H value instead of saturating:
    A(100,100) is H(100, 2, 103)-3. n may be any non-negative value including
    TREE(3); m must be a non-negative integer because a hyperoperation level has
    to be a number. fromString reads ack(4,2) and ackermann(4,2).

    Z.defineFamily{...} registers a caller-supplied giant so it behaves like a
    built-in one. A single row supplies the band, the index rule, the parameter
    count, the display prefix and the accepted spellings, and construction,
    ordering, formatting, parsing, serialization and the exported factory all
    read that row:
        Z.defineFamily({ name = "quark", band = 7000, prefix = "QK",
                         params = 3, index = "unbounded", min = 0,
                         factory = "quark" })
        Z.quark(2, 5, Z.tree(3))    -- QK(2,5,TREE(3))
        Z.fromString("qk(2,5,3)")   -- call spelling is the lowercase prefix
    params > 1 gives a family several arguments, ordered left to right after
    the index, and every argument is a full value, so a registered family
    reaches the scales the built-in ones do. A bare alias needs a default index
    and a one-parameter family. Registration is all-or-nothing: it returns the
    canonical name, or nil and the reason - a taken name, band, alias, call
    spelling or factory, a non-integer band/params/min, an unknown index rule,
    or a multi-parameter family declared with index = "none". Z.families()
    lists every family in band order, Z.familyInfo(name) returns one row, and
    Z.family(name, index, ...) builds any family by name.

    Z.nest(level, base, count) compresses a repeated hyperoperation chain:
    applying H_level(base, .) to its own base count times is exactly
    H_{level+1}(base, count), so Z.nest(3, 2, 4) is 65536 and
    Z.nest(13, 3, Z.tree(3)) stays formal. level must be an integer >= 1,
    while base and count accept any value. Z.nestInfo(v) reads an existing
    chain back as { level, base, depth, count } and returns nil unless v is a
    plain positive chain whose innermost argument is the base itself, so a
    powered or differently seeded chain does not qualify. Z.nestDepth(v) is
    the depth alone, 0 when there is none, and Z.format(v, "nest") rewrites a
    chain of depth 2 or more to its compressed spelling. Compression is a
    read-only view: a chain and its compressed form are the same number, but
    the structural comparator ranks the compressed one higher, so nestInfo is
    verified by re-iterating the chain rather than by comparing against it.

    Z.spend(budget, cost) answers "how many of these fit in that" across every
    scale at once. It returns { count, remainder, exact, scale, precise }, or
    nil when cost is not a positive value, so a game loop can price an upgrade
    in TREE(3) against a wallet in googolplexes without a tier check:
        Z.spend(Z.tree(4), Z.tree(3))   -- count = TREE(4), scale = "named"
        Z.spend(Z.LIMIT, 5)             -- count = LIMIT,   scale = "limit"
    count is floor(budget / cost) and remainder is budget - count * cost, both
    full ZubaNum values, and neither input is mutated. scale names the tier
    count landed in - finite, hyper, named, ordinal, cardinal or limit - while
    precise is true only when both operands are finite and inside the 2^53
    window, because above it floor and the product round back and the
    remainder stops meaning anything.

    The fast-growing hierarchy is Z.fgh(alpha, n): f_0(n) = n + 1,    f_1(n) = 2n, f_2(n) = n * 2^n and, for a finite level a >= 3,
    f_a(n) = H(a + 1, n, n), so f_3(3) = 7625597484987 and f_4(3) is a tower.
    An infinite or non-integer level stays formal and keeps (level, argument)
    inside tier 3, ordered by the level's rank and then the argument, so
    f_omega(100) > f_12(100) > f_3(3) and every hierarchy value stays below
    the cardinals. Z.fgh(Z.aleph(1), 3) is legal and displays as f(aleph_1)(3).
    Spellings include fgh(omega,100), fg(omega,100) and f_omega(100).

    The Hardy hierarchy is Z.hardy(alpha, n, base): H_0(x) = x + base,
    H_{a+1}(x) = H_a(x + 1) and H_l(x) = H_{l[x]}(x), so a finite level is
    plain addition - Z.hardy(3, 10) is 13 and Z.hardy("omega", 100) stays
    formal in tier 3. base shifts the seed function and folds into the
    argument, so it never becomes a separate field. H_alpha is bounded by
    f_alpha, and at one index the Hardy value orders below the hierarchy
    value, so Z.lt(Z.hardy("omega", 100), Z.fgh("omega", 100)) is true.
    Spellings include hardy(omega,100), hardy(omega,100,5) and h_omega(100).

    The named hyperoperation families are the -ote grid of ordinal-indexed
    hyperoperations x{α}y: aperiote(aper, h10) is level ω, expande(expa, h11)
    is ω+1, multiexpande h12, powerexpande h13, aperioexpande h20, explode
    h21, multiexplode h22, aperioexplode h30, detonate h31, aperiodetonate
    h40, aperionate h100, megote h101, multimegote h102, aperimegote h110,
    megoexpande h111, aperimegoexpande h120, megoaperionate h200, gigote h201,
    aperigigote h210, gigoaperionate h300, aperiatote h1000, powiainate h1001,
    expandainate h1010, megodainate h1100, powiairate h2000, aperioguate
    h10000, iterate (iter, hww) ω^ω, itermult (itmu, hw01) ω^ω+1, cuboiter
    (cube, hwx2) ω^ω·2, expoiter (expo, hwa1) ω^(ω+1), trioterate (tria,
    hwm2) ω^(ω·2), trixxate (trix, hwp2) ω^(ω²), aperixxate (apix, hwpw)
    ω^(ω^ω) and epsilonate (epsl, hepsl) ε₀. A code is the Cantor-normal-form digits of α, so h21 reads as ω·2+1
    and h111 as ω²+ω+1. Each name, alias and code is a factory - Z.expande,
    Z.h11, Z.hyperFamily("expande", x, y) - and fromString reads the same
    spellings. Rule 3, x{λ}y = x{λ[y]}x, makes the ω-rows exact wherever the
    level it produces is still a double: Z.aperiote(3, 2) is 3^^3,
    Z.aperiote(10, 2) is 10^^10 and Z.expande(10, 2) is H(12, 10, 10), while a
    step that would need a level drawn from a value - expande(10, 3),
    explode(10, 2) - is LIMIT. Above the ω-rows the exact collapses remain:
    count 1 returns the base, base 1 returns 1, and base 2 with an integer
    count of at least 2 returns 4, because 2{α}2 = 4 at every level under ε₀;
    everything else in those rows is LIMIT.

    Suffix and name helpers cover the game-style short scale and the
    classical -illion scale:
        Z.toSuffix(1.5e9)           -- "1.5B"
        Z.fromSuffix("2.5M")        -- 2500000
        Z.toName(1.23e21)           -- "1.23 sextillion"
        Z.fromName("googolplex")    -- 10^googol, a finite tower
    K/M/B/T through Vg (10^3..10^63) and thousand..vigintillion are
    supported, plus googol (10^100) and googolplex..googoldeciplex.
    Z.toName returns nil when no traditional name exists; Z.toSuffix falls
    back to ordinary formatting outside its table. fromString understands
    both spellings, so Z.new("1.5M") and Z.new("googolplex") work.

    Roblox usage:
        local Z = require(game.ReplicatedStorage.Zubanum)
        local x = Z.new("1e308")
        local tower = Z.tetrate(10, 9e15)
        local hyper = Z.hyperoperation(100, 4, 2)      -- H(100, 4, 2)
        local array = Z.beaf(10, 10, 2)                -- {10,10,2} = 10^^10
        local chain = Z.fromString("3->3->3")          -- {3,3,3} = 3↑↑↑3
        local ape = Z.aperiote(3, 2)                   -- 3{2}3 = 3^^3
        local exp = Z.fromString("h11(10,2)")          -- expande = H(12,10,10)
        local grangol = Z.fromHyperE("E100#100")       -- a 100-layer E ladder
        local plex = Z.fromHyperE("E100#2")            -- googolplex
        print(Z.eq(plex, Z.fromName("googolplex")))    -- true
        local tree = Z.TREE3
        local sscg = Z.SSCG3
        local loader = Z.LOADER
        local bb = Z.BB6
        local rayo = Z.rayo(1e100)                     -- Rayo's number
        local rayo2 = Z.rayo(2e100)                    -- RAYO(2e+100)
        local fish = Z.fish(7)                         -- Fish number 7
        print(Z.eq(rayo, Z.RAYO), Z.eq(fish, Z.FISH7)) -- true  true
        print(Z.lt(sscg, loader), Z.lt(loader, bb), Z.lt(bb, rayo))
        print(Z.lt(rayo, rayo2), Z.lt(rayo2, fish))
        print(Z.lt(fish, Z.omegaTower(1)))
        print(Z.toString(Z.add(Z.mul(tree, 2), 1)))   -- 2·TREE(3)+1
        print(Z.toString(Z.pow(tree, 2)))             -- TREE(3)^2
        print(Z.toString(Z.hyperoperation(100, tree, 2))) -- H(100, TREE(3), 2)
        print(Z.toString(Z.add(loader, 1)))           -- D^5(99)+1
        print(Z.toString(Z.add(bb, 1)))               -- BB(6)+1
        print(Z.toString(Z.add(rayo, 1)))             -- RAYO+1
        print(Z.toSuffix(1.5e9))                      -- 1.5B
        print(Z.toName(Z.fromName("googolplex")))     -- googolplex
        print(Z.toString(Z.LIMIT))                    -- LIMIT
        print(Z.add(Z.mul(x, 10), 1))

    Core API -- usable as Z.fn(a, b) or a:fn(b):
        construct : new fromNumber fromString fromTable fromJSON fromRank fromLog10
                    tree(n) sscg(n) loader(n) bb(n) rayo(n) fish(n) fish7()
        spelling  : toSuffix fromSuffix toName fromName
        arithmetic: add sub mul div mod pow neg abs floor ceil round min max
                    sum(...) product(...) clamp(v,lo,hi) factorial(v) digits(v)
        compare   : cmp eq ne lt lte gt gte isZero isFinite isTower isNamed
                    isHyper isCap isNaN
        logs      : log10 ln log logBase exp sqrt root slog
        hyper     : tetrate pentation arrow(a,b,arrows) hyperoperation(level,a,b)
                    toArrow(v) nest(level,base,count) nestInfo(v) nestDepth(v)
                    beaf(...) toBEAF(v)
                    hyperE(a,b,hyperions,count) fromHyperE(s) toHyperE(v)
                    hyperFamily(name,x,y) plus the 34 -ote names, aliases and
                    h-codes as factories (aperiote ... epsilonate)
        lifts     : omegaTower epsilonTower zetaTower etaTower phiTower(v,n)
                    gammaTower svoTower lvoTower layerAdd lift
        infinite  : aleph(x) beth(x) alephFixed(n) bethFixed(n) cardSucc(v)
                    fgh(alpha,n) hardy(alpha,n,base) getCard getFgh
                    isCard isFgh isHardy
        ranks     : getRank getMantissa fromRank, plus Z.Rank ordinal helpers
        output    : format toString toNumber getKind getSign getFamily getHyper
                    getAnchor toTable fromTable toJSON fromJSON
        constants : ZERO ONE TEN NAN GRAHAM TREE3 TREE4 SSCG2 SSCG3 SSCG4
                    LOADER BB5 BB6 RAYO FISH7 LIMIT MAX INFINITY NEG_LIMIT
                    MIN MAX_TOWER NEG_MAX_TOWER

    Roblox DataStore:
        local save = x:toJSON()      -- plain table
        local y = Z.fromJSON(save)
        local s = x:toJSON(true)     -- JSON string when HttpService is available

    Notes:
    * Addition/multiplication/division stay in exact doubles while the result
      fits a double, then continue in log/tower space.
    * At extreme ranks a relative change below the mantissa grid (1e-14) is
      unrepresentable, so e.g. x * 2 can equal x. That is inherent to compact
      tower notation.
    * Named arithmetic is exact for +1/-1 offsets, finite coefficients and
      finite powers of one base. Mixing GRAHAM with TREE(n), SSCG(n) or
      D^n(99), or named bases with different indices, absorbs the smaller
      scale; that difference is below tier resolution. log10/slog of a named
      value return NaN because the logarithm is itself mega-scale and has no
      tower slot. exp is just e^v, so it stays anchored and finite
      (H(3, e, TREE(3))). An Euler's-number base prints as the literal e,
      and fromString/fromTable/fromJSON read "e" back as that same double,
      so anchored exp expressions roundtrip exactly.
    * Hyperoperations, tetration, pentation and powers with a named base,
      count or exponent keep a finite anchored expression:
      H(100, TREE(3), 2), H(4, 10, TREE(3)), H(5, TREE(3), 2) and
      H(3, TREE(3), TREE(3)). An anchored value sits inside its anchor's
      band, above the plain constant and below the next index/family, so
      centating TREE(3) stays below TREE(4) and SSCG(3). RAYO, the rayo(n)
      ladder and FISH7 keep their band order and none of these operations
      becomes LIMIT.
    * SSCG(2) is the exact integer 3*2^(3*2^95)-8, but the -8 offset is far
      below tower mantissa resolution, so Z.sscg(2) stores 10^(3.5775e28)
      as a finite tower. SSCG(0)=2 and SSCG(1)=5 are ordinary doubles;
      SSCG(n) for n>=3 is named, with SSCG(3) above TREE(3).
    * Loader's number LOADER = D^5(99) is named and finite. Z.loader(n)
      gives the iteration ladder D^n(99): n=0 is 99, n=1 is D(99), ...,
      n=5 is LOADER, and higher n extends the ladder. D^n(99) is not the
      same function as D(n) applied directly to an arbitrary argument; the
      library models the standard iteration used to define Loader's number.
    * The TREE, SSCG, LOADER, BB, RAYO and FISH7 families occupy separate
      bands: every named SSCG value ranks above every named TREE value,
      every LOADER value ranks above every SSCG value, every BB value ranks
      above every LOADER value, RAYO ranks above every BB value and FISH7
      ranks above RAYO. Each family is strictly increasing in its own index.
      Within a family the index dominates the power and coefficient
      (TREE(4) > TREE(3)^2). Comparisons across families follow that band
      convention rather than a proof.
    * Rayo's number is Rayo(10^100): the smallest number above everything
      nameable in first-order set theory with at most a googol symbols.
      Z.rayo(n) is the family factory: Z.rayo() and Z.rayo(1e100) both return
      Z.RAYO, and Z.rayo(n) for n > 1e100 is a Rayo-scale value above RAYO.
      Indices below the googol-symbol anchor are not guaranteed to be
      mega-scale, so Z.rayo(n) is NaN for n < 1e100 instead of mis-ranking a
      small value above BB(6). Z.FISH7 = Z.fish(7) = Z.fish7() is Fish number
      7, F_7^63(10^100). Fish's own order is F1 < F2 < F3 < F5 < F6 < F4 <
      F7, and only F7 is above Rayo's number, so Z.fish(n) for n = 1..6 is
      NaN: those values sit below RAYO and their place among TREE, LOADER and
      BB is not established here. Both constants are uncomputable giants
      ordered by band convention, and both are finite, so they stay below the
      infinite-rank towers and LIMIT.
    * Z.toSuffix and Z.toName are display helpers: they never change the
      value, only its spelling. Z.toSuffix covers K..Vg (10^3..10^63) and
      falls back to ordinary formatting outside that range. Z.toName covers
      thousand..vigintillion, googol and googolplex..googoldeciplex, and
      returns nil for values without a traditional name. Z.fromString
      accepts both forms, plus names with a leading coefficient
      ("2.5 million"); a coefficient on a plex name is absorbed at tower
      resolution, so 2*googolplex equals googolplex.
    * The busy beaver function is uncomputable, but the library treats each
      Sigma(n) as a finite value: Z.bb(0..5) returns 0, 1, 4, 6, 13 and
      4098, while Z.bb(n) for n >= 6 is named BB(n). BB(6) sits above
      LOADER by band convention; since Sigma(6) is unknown, that ordering
      is a modeling choice, not a theorem. Every BB value is finite, so all
      of them stay below the infinite-rank towers and LIMIT.
    * Hyper values are finite and never format as LIMIT. Repeated
      hyperoperations keep growing structurally: H(100,4,2) + 1 keeps an
      offset, *2 keeps a coefficient, ^2 keeps a power, and applying the
      same operation again nests a new H inside the base. A named base,
      count or exponent turns the operation into an anchored H(...) inside
      that constant's band instead of saturating. Z.getHyper(x) returns
      level, base and arg; Z.log10 of a hyper value is NaN, Z.exp is finite
      for named and anchored values and saturates for a plain hyper, because
      the logarithm/exponential is itself outside the compact model.
    * BEAF linear arrays share that ladder: {a, b} = a^b and
      {a, b, c} = a ↑^c b, so c is two below the hyper level, and trailing
      1s drop out ({10,10,1} is {10,10}). Z.beaf takes the entries as
      arguments, as one table or as one spelling, and fromString reads
      "{10,10,2}", "10->->10" and "3->3->3" (one arrow is exponentiation,
      two arrows tetration, matching Z.arrow). An array of four or more
      entries needs the planar rules, which grow past every tier here, so it
      is LIMIT, and so is a period drawn from the infinite tiers. Any finite
      period, however large, stays a formal hyper level. A negative or
      fractional period is not an array, so it is NaN. Z.toBEAF(v) prints
      the array form for a plain integer H(...) and falls back to the
      ordinary spelling for everything else, because an exact small result
      such as 3^^3 has no unique array form.
    * Hyper-E is the same ladder written the way idle games store it: "aEb"
      is a × 10^b, so "E100" is a googol and "2.5E45" is a plain double, while
      a run of hyperions repeats the operator — "E100#2" is a googolplex and
      "E100#100" a grangol, both exact tower values. A leading E means 1E, and
      "ee100" repeats it, so it spells "E100#2" again. Two hyperions and above
      raise the whole operation one level per hyperion, so "E100##100" is read
      as the pentation-level form H(5, 10, 100) and the head of the spelling
      no longer decides the size; a second separate run, as in "E100#2#3", is
      not modelled and is NaN, and a fractional or negative count is NaN too.
      Z.hyperE(a, b, hyperions, count) builds the same value without a string,
      and Z.toHyperE(v) prints the E-form of a double or a finite-rank tower
      and falls back to the ordinary spelling for everything else. Because a
      canonical tower keeps its top in [1, 10), "E100#2" prints as "E2#3":
      both spellings compare equal and roundtrip exactly.
    * LIMIT is a formal bound. LIMIT + LIMIT = LIMIT and LIMIT - LIMIT = 0
      by convention, like a saturation constant, but no finite value is ever
      converted into LIMIT by comparison or by a finite hyperoperation.
    * isFinite means "mathematically finite": finite doubles, finite-rank
      towers, finite hyper values and named-mega values are finite;
      infinite-rank towers, cardinals, hierarchy values and LIMIT are not.
    * Luau only runs comparison metamethods when both operands are ZubaNum
      values. Use Z.eq/Z.lt/... against raw numbers: `x < 5` errors and
      `x == 5` is false. Arithmetic metamethods do accept raw numbers.
    * Ordinal ranks are formal tower heights; logs at limit ranks are
      order-preserving approximations.
    * Value fields (kind/sign/rank/m/n/family/p/coef/off) are internal; use
      the getters.

    What is new in v2.0.0
    * Ordinal ranks past LVO: BHO, SBO, LBO, TFB, EBHO and the weakly
      inaccessible, weakly Mahlo and weakly compact ceilings. The collapsing
      spellings fold into the same ladder - psi(Omega) is epsilon_0,
      psi(Omega^2) is Gamma_0 and psi(Omega^Omega) is exactly BHO - while
      phi(a,b) stays below Gamma_0 and a three-argument Veblen form is not
      modelled. A rank built above the weakly compact ceiling saturates to
      LIMIT instead of wrapping back into the ladder.
    * Unbounded family indices, so TREE(TREE(3)), BB(RAYO) and TREE(ω) are
      legal named values instead of NaN. An integer index still keeps the
      numeric field, so the common path allocates nothing.
    * Z.ackermann / Z.ack on the identity A(0,n) = n+1 and
      A(m,n) = H_m(2, n+3) - 3, exact inside the hyperoperation window and
      formal past it. It is deliberately not a named family: A(6,6) sits
      between Graham's number and TREE(3), so no band placement would be
      truthful.
    * Z.defineFamily / Z.family / Z.familyInfo / Z.families, a registry that
      lets a caller add their own giant with its own band, index rule and
      spellings, and multi-argument support for any family declaring
      params > 1. Registration is all-or-nothing and reports the reason it
      refused.
    * Z.nest / Z.nestInfo / Z.nestDepth and Z.format(v, "nest"), which
      compress a repeated chain H_l(b, H_l(b, H_l(b, b))) into the single
      H_{l+1}(b, count) it already equals. The rewrite is a read-only view,
      never applied at construction.
    * Z.spend(budget, cost), one cross-scale "how many of these fit in that"
      answer carrying the tier the count landed in and a precise flag that is
      honest about the 2^53 window.
    * Z.layerAdd(v, 0) is now the exact identity at every scale. It used to
      cap a named value and to shrink a finite one on the way through its
      rank's log10, so Z.hyperE(10, 100, 1, 1) came back below 1e+101.

    What is new in v2.1.0
    * Knuth up-arrows are read directly: a run of two or more carets, or of
      two or more up-arrow glyphs, splits the spelling at its first run and
      k markers become hyperoperation level k + 2, so "3^^3" is H(4,3,3) and
      "2^^^3" is H(5,2,3). Each side is parsed recursively, so "3^^3^^3" is
      H(4, 3, 3^^3) and "10^3^^2" is H(4, 1000, 2). An empty side is NaN,
      which is why "^^3" and "3^^" are NaN, and a single caret never takes
      this path. The gate runs only when a run is actually present, and it
      sits behind the notation parsers, so "TREE(3)^^2" - not a legal named
      spelling - is read as the anchored H(4, TREE(3), 2).
    * Z.toArrow(v) prints the arrow form of a value that is exactly one
      plain chain H(l, b, b) with both operands doubles, so toArrow of
      H(6,3,3) is "3^^^^3". It returns nil for everything else, including
      the chains that expand to a double or a tower ("3^^3", "10^^3") and
      any value with a power, coefficient, offset or a non-finite operand.
    * Z.factorial(v), alias of the trailing "!" spelling, is exact for
      n <= 170, where the product still fits a double, and continues with
      Stirling's series above it, so 1000! is a tower rather than NaN. Only
      a non-negative integer double up to 1e15 qualifies; negatives,
      fractions, named values, LIMIT and NaN give NaN, and so does "10!!",
      because only a single trailing marker is a factorial.
    * Z.digits(v) counts the decimal digits of the integer part of |v|: a
      finite value is measured against exact powers of ten, so 999 gives 3
      and 1000 gives 4, a tower or LIMIT gives floor(log10 v) + 1, and the
      scales whose logarithm the library refuses to invent - named, hyper,
      cardinal, hierarchy and NaN - give NaN.
    * Z.sum(...) and Z.product(...) fold any number of arguments, and
      Z.clamp(v, lo, hi) bounds one. With no arguments sum is 0 and product
      is 1, the identities of their operators. clamp is NaN when any side is
      NaN or when lo is above hi, so a mis-ordered range cannot pass values
      through silently.

    What is new in v2.2.0
    * The -illion and -plex ladders are composed from Latin roots instead of
      typed out line by line. A root is written as a meg- group, a mil- group
      and a units group joined by an "i" connective, so a hundred million
      names come from three tables and a loop. All twenty-one illion and ten
      plex spellings the library typed before come back character for
      character, and the sweep both ways is unique: 1,500 is "miliquingent"
      while 500,000 is "milquingent", 1,000,002 is "megiun" while 2,000,000 is
      "meduo". ZubaNum.ILLION and ZubaNum.PLEX generate on index and cache
      what is asked for.
    * The ladders stop at ZubaNum.LADDER_CAP = 1e8, so the top names are
      "mehectillion" and "googolmehectaplex", the latter the tower of height
      1e8 + 2. Past the cap illionName and plexName return nil and the
      spellings read back as NaN rather than wrapping around.
    * ZubaNum.illionName(i), plexName(k), illionIndex(name), plexIndex(name),
      illionValue(i) and plexValue(k)
      are public, and toSuffix and toName now run through the same generators,
      so naming reaches past the old 1e66 stop and a tower whose log10 is an
      exact multiple of three prints its -illion name. A value in between -
      10^(3*10^333+3) - stays computable and orderable with no name of its own.
    * New helpers, all of them honest about what they cannot do: gcd and lcm
      on integer-valued operands (math.fmod keeps the Euclid loop exact past
      2^53, and lcm leaves log space when the product does not fit), cbrt,
      gamma (exact factorials to 170!, Stirling above it), lambertW, the six
      trig functions and atan2, lerpLog for a geometric middle, randLin and
      randLog, geoTerm/geoSum/geoCount for series costs, Game Letter Notation
      in toLetters/fromLetters, graham(n) as a ZubaNum-shaped arrow ladder,
      explain(a, b) to say why two values order the way they do, and
      toSave/fromSave for a compact versioned string next to toJSON.
    * Powers of ten inside name and suffix parsing are spelled out and handed
      to tonumber instead of multiplied into place, so a value read back from
      its own spelling lands on the same double the plain "1e126" text gives.

    What is new in v2.3.0
    * The -illion ladder is nested, so the list orders itself. Writing f(n) =
      10^(3n+3), illion index i has N = i - 1 roots, split as N = a*1e6 + t
      into a meg-groups and a tail. For a = 0 the exponent stays 3*i, which is
      every name below millillion and exactly the v2.2 reading. From a = 1 the
      exponent is 3*(f(a) + t) + 3, so the me- prefix multiplies instead of
      adding. a = 1 is the fixed point that keeps the whole meg- family
      unchanged: megillion is still 10^3000003. Two steps up, mehectillion
      (a = 100) is 10^(3*10^303+3), which sorts above googolplex and below
      googolduplex, and the ladder as a whole now runs from thousand past the
      -plex entries it used to sit under.
    * Because every tier-2 exponent is at most 3*10^303+3, it still fits a
      plain double, so no new value kind is needed. ZubaNum.illionValue(i) and
      ZubaNum.plexValue(k) return the exact value behind a name, and
      illionName(i) keeps composing names for any i within the cap. Tails
      closer than one ULP of 10^(3a+3) merge when read through log10; that
      starts at a = 5 and is why a ladder walk should ask for illionValue(i)
      rather than subtract two exponents.
    * Spelling: "millillion" and "millicentillion" now read back like the
      printed tables that use them, alongside the composed "milillion" and
      "milicentillion" the root loop writes. "million" is untouched.
    * A name still carries no arithmetic: "10^(3*10^303+3)" does not parse, and
      the ladder rows are reached by illionValue(i), by fromLog10(3e303), or by
      the spelling "mehectillion" - all three give the same value and name
      themselves the same way.
]]

local ZubaNum = {}
ZubaNum.__index = ZubaNum
ZubaNum.VERSION = "2.3.0"
ZubaNum.NAME = "ZubaNum"
ZubaNum.CEILING = "finite TREE(3), SSCG(3), LOADER, BB(6), RAYO, FISH7 / cardinals / ranks up to WC / LIMIT ceiling"

local LN10 = math.log(10)
local E_CONST = math.exp(1)
-- Rayo's number is Rayo(10^100), the smallest number above everything
-- nameable in first-order set theory with at most a googol symbols.
local RAYO_INDEX = 1e100
local MAX_DOUBLE = 1.7976931348623157e308
local LOG10_MAX_DOUBLE = math.log(MAX_DOUBLE) / LN10
local MAX_SAFE = 9007199254740991
-- Mantissas are snapped to a 1e-14 grid. This keeps values produced by
-- different routes (parse, log/pow, add) canonically identical without
-- erasing the low-order bits that carry meaningful tower-scale differences.
local MANTISSA_SCALE = 1e14
-- log10(SSCG(2)) = log10(3*2^(3*2^95) - 8), rounded to double precision.
-- The -8 offset is ~1e-29 in log10 space and cannot affect a double.
local SSCG2_LOG10 = 3.5775080127201285e28

local function isnan(x)
    return x ~= x
end

local function isfinite(x)
    return x == x and x ~= math.huge and x ~= -math.huge
end

local log10 = math.log10
if log10 == nil then
    log10 = function(x)
        return math.log(x) / LN10
    end
end

local function pow10(x)
    return 10 ^ x
end

-- Where a decimal lands on a double is the parser's decision, so a spelled
-- coefficient and exponent go to tonumber together instead of being multiplied
-- into place: the product of two approximations can sit a ULP away from the
-- same value written as text, and name or suffix round trips show that up.
local function pow10OfText(digits, exp)
    return tonumber(digits .. "e" .. math.floor(exp))
end

local function snapSignificant(x, digits)
    if x == 0 or not isfinite(x) then
        return x
    end
    local sign = x < 0 and -1 or 1
    x = math.abs(x)
    local e = math.floor(log10(x))
    local scale = 10 ^ (digits - 1 - e)
    if not isfinite(scale) or scale == 0 then
        return sign * x
    end
    x = math.floor(x * scale + 0.5) / scale
    return sign * x
end

local function numfloor(x)
    if x >= 0 then
        return math.floor(x)
    end
    return math.ceil(x)
end

-- Ordinal ranks ------------------------------------------------------------
-- A rank is a sum of atoms with positive integer coefficients, sorted
-- descending, plus a trailing finite offset. Atom order:
-- omega < phi(1,0)=epsilon_0 < phi(2,0)=zeta_0 < phi(3,0)=eta_0
--       < phi(n,0) < Gamma_0 < SVO < LVO.
-- This is a deliberately small, canonical fragment of ordinal arithmetic.
-- It is closed under the operations ZubaNum needs: ordinal +, successor,
-- predecessor where defined, and comparison.

local Rank = {}

-- Ordinal atoms in ascending order. omega and phi(n,0) share the first bucket
-- and are separated by n. gamma is the Feferman-Schutte family: Gamma_0 is the
-- Feferman-Schutte ordinal, Gamma_n its successors, Gamma_omega their limit.
-- Above LVO runs the collapsing ladder BHO = psi(Omega^Omega), the small and
-- large Buchholz ordinals, TFB and extended Buchholz, then the weak
-- large-cardinal ordinals I, M and K, which is the rank ceiling.
local ATOM_ORDER = {
    omega = 1, phi = 1, gamma = 2, gamma_omega = 3, svo = 4, lvo = 5,
    bho = 6, sbo = 7, lbo = 8, tfb = 9, ebho = 10,
    weak_inv = 11, weak_mahlo = 12, weak_compact = 13,
}

local ATOM_NAMES = {
    gamma_omega = "Γω", svo = "SVO", lvo = "LVO", bho = "BHO", sbo = "SBO",
    lbo = "LBO", tfb = "TFB", ebho = "EBHO", weak_inv = "WI",
    weak_mahlo = "WM", weak_compact = "WC",
}

local function atomOrder(a)
    local k = a.k
    local bucket = ATOM_ORDER[k]
    if bucket == nil then
        return 0, 0
    end
    if k == "phi" then
        return bucket, math.max(1, numfloor(a.n or 1))
    elseif k == "gamma" then
        return bucket, math.max(0, numfloor(a.n or 0))
    end
    return bucket, 0
end

function Rank.atomCmp(a, b)
    local ab, al = atomOrder(a)
    local bb, bl = atomOrder(b)
    if ab ~= bb then
        return ab < bb and -1 or 1
    end
    if al ~= bl then
        return al < bl and -1 or 1
    end
    return 0
end

function Rank.copyTerm(t)
    return { k = t.k, n = t.n, c = t.c }
end

function Rank.copy(r)
    local terms = table.create(#r.terms)
    for i = 1, #r.terms do
        terms[i] = Rank.copyTerm(r.terms[i])
    end
    return { _rank = true, terms = terms, fin = r.fin }
end

function Rank.normalize(r)
    local src = r.terms or {}
    local terms = {}
    for i = 1, #src do
        local t = src[i]
        local c = numfloor(tonumber(t.c) or 0)
        if c > 0 and t.k ~= nil then
            terms[#terms + 1] = { k = t.k, n = t.n, c = c }
        end
    end
    table.sort(terms, function(a, b)
        local cmp = Rank.atomCmp(a, b)
        if cmp ~= 0 then
            return cmp > 0
        end
        return a.c > b.c
    end)
    local merged = {}
    for i = 1, #terms do
        local t = terms[i]
        local last = merged[#merged]
        if last ~= nil and Rank.atomCmp(last, t) == 0 then
            last.c = last.c + t.c
        else
            merged[#merged + 1] = t
        end
    end
    local fin = tonumber(r.fin) or 0
    if not isfinite(fin) or fin < 0 then
        fin = 0
    end
    fin = numfloor(fin)
    return { _rank = true, terms = merged, fin = fin }
end

function Rank.isZero(r)
    return #r.terms == 0 and r.fin == 0
end

function Rank.isFinite(r)
    return #r.terms == 0
end

function Rank.finiteValue(r)
    if #r.terms == 0 then
        return r.fin
    end
    return nil
end

function Rank.isLimit(r)
    return #r.terms > 0 and r.fin == 0
end

function Rank.addFinite(r, n)
    local out = Rank.copy(r)
    local v = tonumber(n) or 0
    if not isfinite(v) then
        v = 0
    end
    out.fin = out.fin + numfloor(v)
    if out.fin < 0 then
        out.fin = 0
    end
    return out
end

function Rank.succ(r)
    return Rank.addFinite(r, 1)
end

function Rank.pred(r)
    if r.fin > 0 then
        local out = Rank.copy(r)
        out.fin = out.fin - 1
        return out
    end
    -- Limit ranks have no predecessor in this notation; callers use this
    -- only for a coarse logarithm, so returning the limit itself is safe.
    return Rank.copy(r)
end

function Rank.add(a, b)
    if Rank.isZero(b) then
        return Rank.copy(a)
    end
    if Rank.isZero(a) then
        return Rank.copy(b)
    end

    local firstB = b.terms[1]
    if firstB == nil then
        return Rank.addFinite(a, b.fin)
    end

    local terms = {}
    local keep = #a.terms
    while keep > 0 and Rank.atomCmp(a.terms[keep], firstB) < 0 do
        keep = keep - 1
    end
    for i = 1, keep do
        terms[i] = Rank.copyTerm(a.terms[i])
    end

    for i = 1, #b.terms do
        local t = b.terms[i]
        local last = terms[#terms]
        if last ~= nil and Rank.atomCmp(last, t) == 0 then
            last.c = last.c + t.c
        else
            terms[#terms + 1] = Rank.copyTerm(t)
        end
    end

    return Rank.normalize({ _rank = true, terms = terms, fin = b.fin })
end

function Rank.compare(a, b)
    if a == b then
        -- Ranks are immutable, so a shared table is the cheapest equality.
        return 0
    end
    local ta, tb = a.terms, b.terms
    local na, nb = #ta, #tb
    local shared = na < nb and na or nb
    local i = 1
    while i <= shared do
        local x, y = ta[i], tb[i]
        local cmp = Rank.atomCmp(x, y)
        if cmp ~= 0 then
            return cmp
        end
        if x.c ~= y.c then
            return x.c < y.c and -1 or 1
        end
        i = i + 1
    end
    if na > nb then
        return 1
    end
    if nb > na then
        return -1
    end
    if a.fin ~= b.fin then
        return a.fin < b.fin and -1 or 1
    end
    return 0
end

function Rank.eq(a, b)
    return Rank.compare(a, b) == 0
end

function Rank.withinCeiling(r)
    -- The representable rank space is exactly [0, TOP]. Anything above the
    -- ceiling (TOP+1, TOP*2, or a larger atom) saturates to the LIMIT sentinel.
    return Rank.compare(r, Rank.TOP) <= 0
end

function Rank.atomName(t)
    if t.k == "omega" then
        return "ω"
    elseif t.k == "phi" then
        local n = math.max(1, numfloor(t.n or 1))
        if n == 1 then
            return "ε₀"
        elseif n == 2 then
            return "ζ₀"
        elseif n == 3 then
            return "η₀"
        end
        return "φ(" .. tostring(n) .. ",0)"
    elseif t.k == "gamma" then
        local n = math.max(0, numfloor(t.n or 0))
        if n == 0 then
            return "Γ₀"
        end
        return "Γ" .. tostring(n)
    end
    local named = ATOM_NAMES[t.k]
    if named ~= nil then
        return named
    end
    return "?"
end

function Rank.toString(r)
    if #r.terms == 0 then
        return tostring(r.fin)
    end
    local parts = {}
    for i = 1, #r.terms do
        local t = r.terms[i]
        local name = Rank.atomName(t)
        if t.c > 1 then
            name = name .. "·" .. tostring(t.c)
        end
        parts[#parts + 1] = name
    end
    if r.fin > 0 then
        parts[#parts + 1] = tostring(r.fin)
    end
    return table.concat(parts, "+")
end

function Rank.toTable(r)
    local terms = {}
    for i = 1, #r.terms do
        local t = r.terms[i]
        terms[i] = { k = t.k, n = t.n, c = t.c }
    end
    return { __zubarank = 1, terms = terms, fin = r.fin }
end

function Rank.fromTable(t)
    if type(t) ~= "table" then
        return nil
    end
    if t.__zubarank ~= 1 then
        return nil
    end
    return Rank.normalize({ _rank = true, terms = t.terms or {}, fin = t.fin or 0 })
end

local function atomRank(k, n)
    return Rank.normalize({ terms = { { k = k, n = n, c = 1 } }, fin = 0 })
end

Rank.ZERO = { _rank = true, terms = {}, fin = 0 }
Rank.OMEGA = atomRank("omega")
Rank.EPS0 = atomRank("phi", 1)
Rank.ZETA0 = atomRank("phi", 2)
Rank.ETA0 = atomRank("phi", 3)
Rank.GAMMA0 = atomRank("gamma")
Rank.GAMMA_OMEGA = atomRank("gamma_omega")
Rank.SVO = atomRank("svo")
Rank.LVO = atomRank("lvo")
Rank.BHO = atomRank("bho")
Rank.SBO = atomRank("sbo")
Rank.LBO = atomRank("lbo")
Rank.TFB = atomRank("tfb")
Rank.EBHO = atomRank("ebho")
Rank.WEAK_INV = atomRank("weak_inv")
Rank.WEAK_MAHLO = atomRank("weak_mahlo")
Rank.WEAK_COMPACT = atomRank("weak_compact")
Rank.TOP = Rank.WEAK_COMPACT

-- Values -------------------------------------------------------------------
-- finite : ordinary Lua double, |n| <= MAX_DOUBLE
-- tower  : sign * T(rank, m), where T(0,m)=m and T(h+1,m)=10^T(h,m)
-- fgh    : sign * f_alpha(arg), a fast-growing-hierarchy level above the
--          tower ladder it closes over; mode "hardy" stores H_alpha(arg),
--          the Hardy value bounded by that f_alpha
-- card   : sign * aleph_alpha / beth_alpha, or a fixed point of one ladder
-- cap    : LIMIT, the formal ceiling sentinel
-- nan    : invalid operation

local Impl = {}
local ZERO, ONE, TEN, NAN, CAP, NEG_CAP, MAX_TOWER, NEG_MAX_TOWER
local GRAHAM, TREE3, TREE4, SSCG2, SSCG3, SSCG4, LOADER, BB5, BB6, RAYO, FISH7
local ALEPH0, ALEPH1, ALEPH2, ALEPH3, ALEPH_OMEGA, BETH0, BETH1, ALEPH_FP1
local Named, Hyper, Idx, Card, Fgh, Beaf, HyperE, Grid

function Impl.isZuba(v)
    return type(v) == "table" and getmetatable(v) == ZubaNum
end

function Impl.isNan(v)
    return type(v) == "table" and v.kind == "nan"
end

function Impl.isCap(v)
    return type(v) == "table" and v.kind == "cap"
end

function Impl.isZero(v)
    return type(v) == "table" and v.kind == "finite" and v.n == 0
end

function Impl.finite(n)
    if isnan(n) then
        return NAN
    end
    if n == 0 then
        return ZERO
    end
    if n == math.huge then
        return CAP
    end
    if n == -math.huge then
        return NEG_CAP
    end
    return setmetatable({ kind = "finite", n = n }, ZubaNum)
end

function Impl.maxTower()
    return MAX_TOWER
end

function Impl.negativeMax()
    return NEG_MAX_TOWER
end

function Impl.copy(v)
    if v.kind == "finite" then
        return Impl.finite(v.n)
    elseif v.kind == "tower" then
        return setmetatable({
            kind = "tower",
            sign = v.sign,
            rank = Rank.copy(v.rank),
            m = v.m,
        }, ZubaNum)
    elseif v.kind == "named" then
        return Named.copy(v)
    elseif v.kind == "hyper" then
        return Hyper.copy(v)
    elseif v.kind == "card" then
        return Card.copy(v)
    elseif v.kind == "fgh" then
        return Fgh.copy(v)
    end
    return v
end

function Impl.signOf(v)
    if v.kind == "finite" then
        if v.n > 0 then
            return 1
        elseif v.n < 0 then
            return -1
        end
        return 0
    elseif v.kind == "tower" or v.kind == "named" or v.kind == "hyper"
        or v.kind == "card" or v.kind == "fgh" then
        return v.sign
    elseif v.kind == "cap" then
        return v.sign
    end
    return nil
end

function Impl.negate(v)
    if v.kind == "nan" then
        return NAN
    elseif v.kind == "cap" then
        return v.sign > 0 and NEG_CAP or CAP
    elseif v.kind == "named" then
        return Named.withSign(v, -v.sign)
    elseif v.kind == "hyper" then
        return Hyper.withSign(v, -v.sign)
    elseif v.kind == "card" then
        return Card.withSign(v, -v.sign)
    elseif v.kind == "fgh" then
        return Fgh.withSign(v, -v.sign)
    elseif v.kind == "tower" then
        local out = Impl.copy(v)
        out.sign = -out.sign
        return out
    elseif v.kind == "finite" then
        return Impl.finite(-v.n)
    end
    return NAN
end

function Impl.canonical(sign, rank, m)
    if sign == 0 or isnan(m) then
        return NAN
    end
    if rank == nil then
        rank = Rank.ZERO
    end
    if not isfinite(m) then
        if m == math.huge then
            return sign > 0 and CAP or NEG_CAP
        end
        return NAN
    end
    if m < 0 then
        m = -m
        sign = -sign
    end
    if sign == 0 or m == 0 then
        return ZERO
    end
    if sign > 0 then
        sign = 1
    else
        sign = -1
    end

    if Rank.isZero(rank) then
        return Impl.finite(sign * m)
    end

    local guard = 0
    while m < 1 and guard < 8 do
        m = pow10(m)
        rank = Rank.pred(rank)
        guard = guard + 1
    end
    while m >= 10 and guard < 16 do
        m = log10(m)
        rank = Rank.succ(rank)
        guard = guard + 1
    end
    if not isfinite(m) then
        return sign > 0 and CAP or NEG_CAP
    end
    if m < 1 then
        m = 1
    elseif m >= 10 then
        return sign > 0 and CAP or NEG_CAP
    end

    local snapped = math.floor(m * MANTISSA_SCALE + 0.5) / MANTISSA_SCALE
    if snapped >= 10 then
        rank = Rank.succ(rank)
        m = 1
    else
        m = snapped
    end

    if not Rank.withinCeiling(rank) then
        return sign > 0 and CAP or NEG_CAP
    end

    if Rank.isFinite(rank) then
        local h = Rank.finiteValue(rank)
        if h == 0 then
            return Impl.finite(sign * m)
        elseif h == 1 then
            local v = pow10(m)
            if isfinite(v) then
                local sv = snapSignificant(v, 15)
                if isfinite(sv) then
                    v = sv
                end
                return Impl.finite(sign * v)
            end
        elseif h == 2 then
            local e = pow10(m)
            if isfinite(e) and e <= LOG10_MAX_DOUBLE then
                local v = pow10(e)
                if isfinite(v) then
                    local sv = snapSignificant(v, 15)
                    if isfinite(sv) then
                        v = sv
                    end
                    return Impl.finite(sign * v)
                end
            end
        end
    end

    return setmetatable({
        kind = "tower",
        sign = sign,
        rank = rank,
        m = m,
    }, ZubaNum)
end

function Impl.fromParts(rank, m)
    return Impl.canonical(1, rank, m)
end

function Impl.slogPartsFromFinite(n)
    if not isfinite(n) or n <= 0 then
        return nil
    end
    local h = 0
    local x = n
    while x >= 10 and h < 8 do
        x = log10(x)
        h = h + 1
    end
    if x < 1 then
        return nil
    end
    return Rank.addFinite(Rank.ZERO, h), x
end

function Impl.partsFromPositive(v)
    if v.kind == "tower" then
        if v.sign < 0 then
            return nil
        end
        return v.rank, v.m
    elseif v.kind == "finite" then
        if v.n <= 0 then
            return nil
        end
        return Impl.slogPartsFromFinite(v.n)
    end
    return nil
end

function Impl.fromLog10Value(v)
    if v.kind == "nan" then
        return NAN
    elseif v.kind == "cap" then
        return CAP
    elseif v.kind == "finite" then
        local n = v.n
        if n < -324 then
            return ZERO
        elseif n <= LOG10_MAX_DOUBLE then
            local mag = pow10(n)
            if isfinite(mag) then
                return Impl.finite(mag)
            end
            return CAP
        end
        local rank, m = Impl.slogPartsFromFinite(n)
        if rank == nil then
            return NAN
        end
        return Impl.fromParts(Rank.succ(rank), m)
    elseif v.kind == "tower" then
        if v.sign < 0 then
            return ZERO
        end
        return Impl.fromParts(Rank.succ(v.rank), v.m)
    end
    return NAN
end

function Impl.log10Value(v)
    if v.kind == "nan" then
        return NAN
    elseif v.kind == "cap" then
        return MAX_TOWER
    elseif v.kind == "named" or v.kind == "hyper" then
        -- log10 of a named-mega or hyper-scale value is itself out of reach;
        -- the compact tower ladder has no slot for it.
        return NAN
    elseif v.kind == "finite" then
        local n = v.n
        if n > 0 then
            return Impl.finite(log10(n))
        elseif n == 0 then
            return NAN
        end
        return NAN
    elseif v.kind == "tower" then
        if v.sign < 0 then
            return NAN
        end
        local lower = Rank.pred(v.rank)
        local out = Impl.fromParts(lower, v.m)
        if out.kind == "finite" then
            local r = numfloor(out.n + 0.5)
            -- Mantissa rounding loses the exact exponent of 10^n towers.
            if math.abs(out.n - r) <= 1e-12 * math.max(1, math.abs(r)) then
                return Impl.finite(r)
            end
        end
        return out
    end
    return NAN
end

-- Named-mega tier ----------------------------------------------------------
-- Graham's number, TREE(3), SSCG(3) and Loader's number are finite integers,
-- but they dwarf any compact tower this library can write with double-precision
-- heights. They get their own tier: above every finite-rank tower, below every
-- infinite-rank tower.
-- A magnitude is coef * B^pow + off, where B is the named base and
-- coef/pow/off are finite doubles. Cross-family products and quotients are
-- dominated by the larger base; the smaller factor is below tier resolution.

Named = {}

local COEF_MAX = 1e308

-- One registry describes every named family: cross-family band, index rule,
-- canonical spellings and factory name. Construction, ordering, formatting,
-- parsing and the exported factories all read this table, so a family is
-- declared once instead of appearing in several if-chains.
Named.FAMILIES = {
    { family = "GRAHAM", band = 100,  index = "none" },
    { family = "TREE",   band = 1000, index = "unbounded", min = 3, prefix = "TREE" },
    { family = "SSCG",   band = 2000, index = "unbounded", min = 3, prefix = "SSCG" },
    { family = "LOADER", band = 3000, index = "unbounded", min = 1, prefix = "D" },
    { family = "BB",     band = 4000, index = "unbounded", min = 1, prefix = "BB" },
    { family = "RAYO",   band = 5000, index = "unbounded", min = RAYO_INDEX, prefix = "RAYO", default = RAYO_INDEX },
    { family = "FISH7",  band = 6000, index = "fixed", fixed = 7 },
}
Named.BASE_ORDER = {}
Named.SPEC = {}
for i = 1, #Named.FAMILIES do
    local spec = Named.FAMILIES[i]
    Named.BASE_ORDER[spec.family] = spec.band
    Named.SPEC[spec.family] = spec
end

-- Exact base spellings resolve with one lookup instead of walking the
-- per-family pattern chain. Family prefixes with arguments ("BB(6)",
-- "rayo(2e100)") still use the patterns below.
Named.ALIASES = {
    graham = { "GRAHAM", nil },
    ["graham'snumber"] = { "GRAHAM", nil },
    grahamsnumber = { "GRAHAM", nil },
    g = { "GRAHAM", nil },
    tree = { "TREE", 3 },
    sscg = { "SSCG", 3 },
    loader = { "LOADER", 5 },
    ["loader'snumber"] = { "LOADER", 5 },
    loadersnumber = { "LOADER", 5 },
    bb = { "BB", 6 },
    busybeaver = { "BB", 6 },
    busybeavernumber = { "BB", 6 },
    rayo = { "RAYO", RAYO_INDEX },
    ["rayo'snumber"] = { "RAYO", RAYO_INDEX },
    rayosnumber = { "RAYO", RAYO_INDEX },
    rayonumber = { "RAYO", RAYO_INDEX },
    fish7 = { "FISH7", 7 },
    fishnumber7 = { "FISH7", 7 },
    fishno7 = { "FISH7", 7 },
    ["fishno.7"] = { "FISH7", 7 },
    f7 = { "FISH7", 7 },
}

-- Characters that can start a named spelling. parseString skips the named
-- parser for numeric input by testing this class, so registering a family
-- widens it instead of leaving the new prefix unparsable.
local NAMED_GATE = "[gGtTsSlLdDbBrRfF]"
Named.GATE = NAMED_GATE

function Named.widenGate(text)
    local extra = ""
    for i = 1, #text do
        local c = text:sub(i, i)
        if c:match("%a") then
            local up, lo = c:upper(), c:lower()
            if NAMED_GATE:find(up, 1, true) == nil and extra:find(up, 1, true) == nil then
                extra = extra .. up
            end
            if up ~= lo and NAMED_GATE:find(lo, 1, true) == nil
                and extra:find(lo, 1, true) == nil then
                extra = extra .. lo
            end
        end
    end
    if extra ~= "" then
        NAMED_GATE = "[" .. NAMED_GATE:sub(2, -2) .. extra .. "]"
        Named.GATE = NAMED_GATE
    end
end

function Named.baseOrder(v)
    return Named.BASE_ORDER[v.family] or 1000
end

-- Extra arguments of a multi-parameter family, kept as values so every scale
-- is legal. Single-index families leave nx nil and never touch these paths.
function Named.argsText(v)
    local nx = v.nx
    if nx == nil then
        return Named.indexText(v)
    end
    local parts = { Named.indexText(v) }
    for i = 1, #nx do
        parts[i + 1] = Impl.format(nx[i])
    end
    return table.concat(parts, ",")
end

function Named.argsCmp(a, b)
    local xa, xb = a.nx, b.nx
    if xa == nil or xb == nil then
        if xa == xb then
            return 0
        end
        return xa == nil and -1 or 1
    end
    local n = #xa < #xb and #xa or #xb
    for i = 1, n do
        local c = Impl.compare(xa[i], xb[i])
        if c ~= nil and c ~= 0 then
            return c
        end
    end
    if #xa == #xb then
        return 0
    end
    return #xa < #xb and -1 or 1
end

function Named.argsEq(a, b)
    return Named.argsCmp(a, b) == 0
end

function Named.baseName(v)
    if v.family == "GRAHAM" then
        return "GRAHAM"
    end
    if v.family == "LOADER" then
        if v.n == 1 then
            return "D(99)"
        end
        return "D^" .. Named.indexText(v) .. "(99)"
    end
    if v.family == "BB" then
        return "BB(" .. Named.indexText(v) .. ")"
    end
    if v.family == "RAYO" then
        if v.n == RAYO_INDEX then
            return "RAYO"
        end
        return "RAYO(" .. Named.indexText(v) .. ")"
    end
    if v.family == "FISH7" then
        return "FISH7"
    end
    local spec = Named.SPEC[v.family]
    local prefix = spec ~= nil and spec.prefix or v.family
    return prefix .. "(" .. Named.argsText(v) .. ")"
end

function Named.copy(v)
    return setmetatable({
        kind = "named",
        sign = v.sign,
        family = v.family,
        n = v.n,
        idx = v.idx,
        nx = v.nx,
        p = v.p,
        coef = v.coef,
        off = v.off,
        band = v.band,
    }, ZubaNum)
end

function Named.withSign(v, sign)
    local out = Named.copy(v)
    out.sign = sign < 0 and -1 or 1
    return out
end

function Named.normalize(family, n, sign, pow, coef, off, idx, nx)
    sign = sign < 0 and -1 or 1
    if coef ~= coef or pow ~= pow or off ~= off then
        return NAN
    end
    if not isfinite(pow) or pow <= 0 then
        return sign > 0 and CAP or NEG_CAP
    end
    if not isfinite(coef) or coef <= 0 then
        if coef == 0 then
            if not isfinite(off) or off == 0 then
                return ZERO
            end
            return Impl.finite(sign * off)
        end
        return sign > 0 and CAP or NEG_CAP
    end
    if coef > COEF_MAX then
        coef = COEF_MAX
    end
    if not isfinite(off) then
        off = 0
    end
    return setmetatable({
        kind = "named",
        sign = sign,
        family = family,
        n = n,
        idx = idx,
        nx = nx,
        p = pow,
        coef = coef,
        off = off,
        band = Named.BASE_ORDER[family] or 1000,
    }, ZubaNum)
end

-- Family indices are unbounded: TREE(TREE(3)), BB(RAYO) and TREE(ω) are legal
-- named values. An index that is a plain integer keeps the numeric field so
-- the common case stays allocation-free; anything else is stored as a
-- subscript and ordered through the ladder the cardinal subscripts use.
function Named.indexArg(spec, n)
    local min = spec.min or 0
    if n == nil then
        -- Only a missing index falls back to the family default; an index that
        -- cannot be read (LIMIT, garbage text) stays rejected.
        local d = spec.default
        if d == nil or not isfinite(d) or d ~= math.floor(d) or d < min then
            return nil, nil
        end
        return d, nil
    end
    local num = tonumber(n)
    if num ~= nil then
        if isfinite(num) and num == math.floor(num) and num >= min then
            return num, nil
        end
        return nil, nil
    end
    local idx = Idx.fromArg(n)
    if idx == nil then
        return nil, nil
    end
    if idx.cls == "fin" and idx.v.kind == "finite" then
        local v = idx.v.n
        if isfinite(v) and v == math.floor(v) and v >= min then
            return v, nil
        end
        return nil, nil
    end
    if Idx.compare(idx, Idx.fin(Impl.finite(min))) < 0 then
        return nil, nil
    end
    return nil, idx
end

function Named.new(family, n, sign, pow, coef, off, nx)
    local spec = Named.SPEC[family]
    if spec == nil then
        return NAN
    end
    local idx = nil
    if spec.index == "none" then
        n = nil
    elseif spec.index == "fixed" then
        n = n == nil and spec.fixed or tonumber(n)
        if n ~= spec.fixed then
            return NAN
        end
    elseif spec.index == "integer" then
        n = tonumber(n)
        if n == nil and spec.default ~= nil then
            n = spec.default
        end
        if n == nil or not isfinite(n) or n ~= math.floor(n) or n < spec.min then
            return NAN
        end
    elseif type(n) == "table" and n.cls ~= nil then
        -- An already-resolved subscript: fromTable and the value builders.
        idx = n
        n = nil
        if Idx.compare(idx, Idx.fin(Impl.finite(spec.min or 0))) < 0 then
            return NAN
        end
    else
        n, idx = Named.indexArg(spec, n)
        if n == nil and idx == nil then
            return NAN
        end
    end
    local args = nil
    local want = (spec.params or 1) - 1
    if want > 0 then
        if type(nx) ~= "table" or #nx ~= want then
            return NAN
        end
        args = {}
        for i = 1, want do
            local a = nx[i]
            if not Impl.isZuba(a) or a.kind == "nan" then
                return NAN
            end
            args[i] = Impl.copy(a)
        end
    elseif nx ~= nil then
        return NAN
    end
    sign = tonumber(sign) or 1
    pow = tonumber(pow) or 1
    coef = tonumber(coef) or 1
    off = tonumber(off) or 0
    if not isfinite(pow) or pow <= 0 or not isfinite(coef) or coef <= 0
        or not isfinite(off) then
        return NAN
    end
    return Named.normalize(family, n, sign, pow, coef, off, idx, args)
end

-- Factory entry point: resolves raw arguments the way the built-in families
-- do, so a registered family accepts the same index and value spellings.
function Named.make(family, index, args, sign, pow, coef, off)
    local spec = Named.SPEC[family]
    if spec == nil then
        return NAN
    end
    local ix = index
    if ix ~= nil and type(ix) ~= "number" then
        ix = Impl.indexSource(ix)
    end
    local nx = nil
    local want = (spec.params or 1) - 1
    if want > 0 then
        if type(args) ~= "table" then
            return NAN
        end
        nx = {}
        for i = 1, want do
            local a = Impl.asValue(args[i])
            if a.kind == "nan" then
                return NAN
            end
            nx[i] = a
        end
    end
    return Named.new(family, ix, sign, pow, coef, off, nx)
end

function Named.indexOf(v)
    if v.n ~= nil then
        return v.n
    end
    return v.idx
end

function Named.indexText(v)
    if v.n ~= nil then
        return Named.numberText(v.n)
    end
    if v.idx ~= nil then
        return Idx.toString(v.idx)
    end
    return ""
end

-- Ordering two indices of the same family. Integer indices compare numerically
-- without allocating; a formal subscript goes through the Idx ladder, where any
-- integer index sits below every non-integer one.
function Named.indexCmp(a, b)
    local na, nb = a.n, b.n
    if na ~= nil and nb ~= nil then
        if na == nb then
            return 0
        end
        return na < nb and -1 or 1
    end
    local ia, ib = a.idx, b.idx
    if ia == nil then
        if na == nil then
            return ib == nil and 0 or -1
        end
        ia = Idx.fin(Impl.finite(na))
    elseif ib == nil and nb == nil then
        return 1
    end
    if ib == nil then
        ib = Idx.fin(Impl.finite(nb))
    end
    return Idx.compare(ia, ib)
end

function Named.indexEq(a, b)
    if a.n ~= nil or b.n ~= nil then
        return a.n == b.n
    end
    if a.idx == nil or b.idx == nil then
        return a.idx == b.idx
    end
    return Idx.compare(a.idx, b.idx) == 0
end

function Named.compareMag(a, b)
    -- Same-family comparisons are the common case; skip the band check.
    if a.family ~= b.family then
        local oa = a.band or Named.BASE_ORDER[a.family] or 1000
        local ob = b.band or Named.BASE_ORDER[b.family] or 1000
        return oa < ob and -1 or 1
    end
    local c = Named.indexCmp(a, b)
    if c ~= 0 then
        return c
    end
    c = Named.argsCmp(a, b)
    if c ~= 0 then
        return c
    end
    if a.p ~= b.p then
        return a.p < b.p and -1 or 1
    end
    if a.coef ~= b.coef then
        return a.coef < b.coef and -1 or 1
    end
    if a.off ~= b.off then
        return a.off < b.off and -1 or 1
    end
    return 0
end

-- Identity of the underlying constant, ignoring coef, power and offset:
-- TREE(3) and 5·TREE(3)^2 share the same base.
function Named.compareBase(a, b)
    if a.family ~= b.family then
        local oa = a.band or Named.BASE_ORDER[a.family] or 1000
        local ob = b.band or Named.BASE_ORDER[b.family] or 1000
        return oa < ob and -1 or 1
    end
    local c = Named.indexCmp(a, b)
    if c ~= 0 then
        return c
    end
    return Named.argsCmp(a, b)
end

function Named.magAdd(a, b)
    if a.family == b.family and a.p == b.p and Named.indexEq(a, b)
        and Named.argsEq(a, b) then
        return Named.normalize(a.family, a.n, 1, a.p, a.coef + b.coef, a.off + b.off, a.idx, a.nx)
    end
    return Named.compareMag(a, b) >= 0 and Named.copy(a) or Named.copy(b)
end

function Named.magSub(a, b)
    if a.family == b.family and a.p == b.p and Named.indexEq(a, b)
        and Named.argsEq(a, b) then
        local coef = a.coef - b.coef
        local off = a.off - b.off
        if coef <= 0 then
            if off <= 0 then
                return ZERO
            end
            return Impl.finite(off)
        end
        return Named.normalize(a.family, a.n, 1, a.p, coef, off, a.idx, a.nx)
    end
    return Named.copy(a)
end

function Named.addValues(a, b)
    if a.sign == b.sign then
        return Impl.signedMagnitude(a.sign, Named.magAdd(a, b))
    end
    local cmp = Named.compareMag(a, b)
    if cmp == 0 then
        return ZERO
    elseif cmp > 0 then
        return Impl.signedMagnitude(a.sign, Named.magSub(a, b))
    end
    return Impl.signedMagnitude(b.sign, Named.magSub(b, a))
end

function Named.addFinite(v, n)
    local off = v.off + v.sign * n
    if not isfinite(off) then
        return Named.copy(v)
    end
    return Named.normalize(v.family, v.n, v.sign, v.p, v.coef, off, v.idx, v.nx)
end

function Named.mulFinite(v, n)
    local sign = v.sign
    if n < 0 then
        sign = -sign
        n = -n
    end
    local coef = v.coef * n
    if coef > COEF_MAX then
        coef = COEF_MAX
    end
    local off = v.off * n
    if not isfinite(off) then
        off = 0
    end
    return Named.normalize(v.family, v.n, sign, v.p, coef, off, v.idx, v.nx)
end

function Named.mul(a, b)
    local sign = a.sign * b.sign
    if a.family == b.family and Named.indexEq(a, b) and Named.argsEq(a, b) then
        return Named.normalize(a.family, a.n, sign, a.p + b.p, a.coef * b.coef, 0, a.idx, a.nx)
    end
    local big = Named.compareMag(a, b) >= 0 and a or b
    return Named.withSign(big, sign)
end

function Named.div(a, b)
    local sign = a.sign * b.sign
    if a.family == b.family and Named.indexEq(a, b) and Named.argsEq(a, b) then
        local pow = a.p - b.p
        if pow > 0 then
            return Named.normalize(a.family, a.n, sign, pow, a.coef / b.coef, 0, a.idx, a.nx)
        elseif pow == 0 then
            local q = a.coef / b.coef
            if not isfinite(q) then
                return sign > 0 and CAP or NEG_CAP
            end
            return Impl.finite(sign * q)
        end
        return ZERO
    end
    local cmp = Named.compareMag(a, b)
    if cmp == 0 then
        return ONE
    elseif cmp > 0 then
        return Named.withSign(a, sign)
    end
    return ZERO
end

function Named.pow(v, exponent)
    if exponent == 1 then
        return Named.copy(v)
    end
    local pow = v.p * exponent
    local coef = v.coef ^ exponent
    if not isfinite(pow) or pow <= 0 or not isfinite(coef) or coef <= 0 then
        if coef ~= coef or pow == 0 then
            return NAN
        end
        return v.sign > 0 and CAP or NEG_CAP
    end
    if coef > COEF_MAX then
        coef = COEF_MAX
    end
    return Named.normalize(v.family, v.n, v.sign, pow, coef, 0, v.idx, v.nx)
end

function Named.numberText(n)
    if n == math.floor(n) and math.abs(n) < 1e15 then
        return string.format("%.0f", n)
    end
    local s = string.format("%.15g", n)
    if tonumber(s) ~= n then
        s = string.format("%.17g", n)
    end
    return s
end

function Named.format(v)
    local base = Named.baseName(v)
    if v.p ~= 1 then
        base = base .. "^" .. Named.numberText(v.p)
    end
    local body
    if v.coef ~= 1 then
        body = Named.numberText(v.coef) .. "·" .. base
    else
        body = base
    end
    if v.off > 0 then
        body = body .. "+" .. Named.numberText(v.off)
    elseif v.off < 0 then
        body = body .. "-" .. Named.numberText(-v.off)
    end
    if v.sign < 0 then
        if v.coef == 1 and v.p == 1 and v.off == 0 then
            return "-" .. body
        end
        return "-(" .. body .. ")"
    end
    return body
end

-- "prefix(index)" spellings and the smallest index each one accepts. The index
-- may itself carry parentheses (TREE(TREE(3))), so the matching close paren is
-- found by scanning instead of by a pattern.
local CALL_FAMILY = {
    tree = { "TREE", 1 },
    sscg = { "SSCG", 0 },
    bb = { "BB", 0 },
    busybeaver = { "BB", 0 },
    loader = { "LOADER", 0 },
    rayo = { "RAYO", RAYO_INDEX },
    fish = { "FISH7", 7 },
}

local function splitCall(name)
    if name:sub(-1) ~= ")" then
        return nil
    end
    local open = name:find("(", 1, true)
    if open == nil then
        return nil
    end
    local depth = 0
    for i = open, #name do
        local c = name:sub(i, i)
        if c == "(" then
            depth = depth + 1
        elseif c == ")" then
            depth = depth - 1
            if depth == 0 then
                if i ~= #name then
                    return nil
                end
                return name:sub(1, open - 1), name:sub(open + 1, i - 1)
            end
        end
    end
    return nil
end

-- Exposed so a registered family can add its own call spelling, and so the
-- Ackermann parser can reuse the balanced-paren scan.
Named.CALL = CALL_FAMILY
Named.splitCall = splitCall

-- Resolve an index spelling: a plain integer stays numeric, anything else
-- becomes a formal subscript. Returns family, index, subscript or nil.
local function resolveIndex(family, lo, text, depth)
    local n = tonumber(text)
    if n == nil then
        local idx = Idx.fromToken(text, depth or 0)
        if idx == nil then
            return nil
        end
        if idx.cls == "fin" and idx.v.kind == "finite" then
            n = idx.v.n
        else
            return family, nil, idx
        end
    end
    if not isfinite(n) or n ~= math.floor(n) or n < lo then
        return nil
    end
    return family, n
end

-- "F(a,b,...)" for a family declared with several parameters. Every argument
-- after the first is a full value, so a multi-parameter family reaches the
-- same scales the single-index ones do.
local function resolveArgs(call, inner, depth)
    local family = call[1]
    local spec = Named.SPEC[family]
    local want = spec ~= nil and (spec.params or 1) or 1
    local parts = Hyper.splitArgs(inner)
    if parts == nil or #parts ~= want then
        return nil
    end
    local fam, n, nidx = resolveIndex(family, call[2], parts[1], depth)
    if fam == nil then
        return nil
    end
    local nx = nil
    if want > 1 then
        nx = {}
        local d = (depth or 0) + 1
        for i = 2, want do
            local v = Impl.parseString(parts[i], d)
            if v.kind == "nan" then
                return nil
            end
            nx[i - 1] = v
        end
    end
    return fam, n, nidx, nx
end

function Named.parseBase(name, depth)
    local alias = Named.ALIASES[name]
    if alias ~= nil then
        return alias[1], alias[2]
    end
    if name == "d(99)" then
        return "LOADER", 1
    end
    local head, inner = splitCall(name)
    if head ~= nil then
        local call = CALL_FAMILY[head]
        if call ~= nil and inner ~= "" then
            local spec = Named.SPEC[call[1]]
            if spec ~= nil and (spec.params or 1) > 1 then
                return resolveArgs(call, inner, depth)
            end
            if call[1] == "RAYO" and tonumber(inner) == nil then
                -- Accept the canonical spelling rayo(10^100).
                local base, e = inner:match("^([%d%.]+)%^([%d%.]+)$")
                local p = base ~= nil and tonumber(base) == 10 and tonumber(e) or nil
                if p ~= nil then
                    local n = 10 ^ p
                    if isfinite(n) and n == math.floor(n) and n >= RAYO_INDEX then
                        return "RAYO", n
                    end
                end
            end
            return resolveIndex(call[1], call[2], inner, depth)
        end
    end
    -- D^k(99) and Dk(99): k may be any index spelling, so it is scanned rather
    -- than matched, and the "(99)" seed is what the closing paren belongs to.
    if name:sub(1, 1) == "d" and name:sub(-4) == "(99)" then
        local k = name:sub(2, -5)
        if k:sub(1, 1) == "^" then
            k = k:sub(2)
        end
        if k ~= "" then
            return resolveIndex("LOADER", 0, k, depth)
        end
    end
    local lidx = name:match("^loader([%deE%+%-%.]+)$")
    if lidx ~= nil then
        local n = tonumber(lidx)
        if n == nil or not isfinite(n) or n ~= math.floor(n) or n < 0 then
            return nil
        end
        return "LOADER", n
    end
    local bidx = name:match("^bb([%deE%+%-%.]+)$")
        or name:match("^busybeaver([%deE%+%-%.]+)$")
    if bidx ~= nil then
        local n = tonumber(bidx)
        if n == nil or not isfinite(n) or n ~= math.floor(n) or n < 0 then
            return nil
        end
        return "BB", n
    end
    local idx = name:match("^tree([%deE%+%-%.]+)$")
    if idx ~= nil then
        local n = tonumber(idx)
        if n == nil or not isfinite(n) or n ~= math.floor(n) or n < 1 then
            return nil
        end
        return "TREE", n
    end
    local sidx = name:match("^sscg([%deE%+%-%.]+)$")
    if sidx ~= nil then
        local n = tonumber(sidx)
        if n == nil or not isfinite(n) or n ~= math.floor(n) or n < 0 then
            return nil
        end
        return "SSCG", n
    end
    return nil
end

function Named.parse(s, pd)
    if type(s) ~= "string" then
        return nil
    end
    local t = s:lower():gsub("%s+", "")
    t = t:gsub("·", "*")
    if t == "" then
        return nil
    end
    local sign = 1
    if t:sub(1, 1) == "+" then
        t = t:sub(2)
    elseif t:sub(1, 1) == "-" then
        sign = -1
        t = t:sub(2)
    end
    if t:sub(1, 1) == "(" and t:sub(-1) == ")" then
        t = t:sub(2, -2)
    end
    local depth = 0
    local cut = nil
    for i = 1, #t do
        local c = t:sub(i, i)
        if c == "(" then
            depth = depth + 1
        elseif c == ")" then
            depth = depth - 1
            if depth < 0 then
                return nil
            end
        elseif depth == 0 and (c == "+" or c == "-") and i > 1
            and t:sub(i - 1, i - 1) ~= "e" then
            cut = i
        end
    end
    if depth ~= 0 then
        return nil
    end
    local off = 0
    if cut ~= nil then
        off = tonumber(t:sub(cut))
        if off == nil or not isfinite(off) then
            return nil
        end
        t = t:sub(1, cut - 1)
    end
    local coef = 1
    local star = t:find("*", 1, true)
    if star ~= nil then
        coef = tonumber(t:sub(1, star - 1))
        if coef == nil or not isfinite(coef) or coef <= 0 then
            return nil
        end
        t = t:sub(star + 1)
    end
    local pow = 1
    local baseStr, powStr = t:match("^(.-)%^([%deE%+%-%.]+)$")
    if baseStr ~= nil then
        pow = tonumber(powStr)
        if pow == nil or not isfinite(pow) or pow <= 0 then
            return nil
        end
        t = baseStr
    end
    local family, n, nidx, nx = Named.parseBase(t, pd)
    if family == nil then
        return nil
    end
    if nidx == nil and nx == nil then
        if family == "TREE" and n < 3 then
            -- Friedman's small cases: TREE(1) = 1, TREE(2) = 3.
            if coef ~= 1 or pow ~= 1 or off ~= 0 then
                return nil
            end
            local small = n == 1 and ONE or Impl.finite(3)
            return sign < 0 and Impl.negate(small) or Impl.copy(small)
        end
        if family == "SSCG" and n < 3 then
            -- SSCG(0) = 2, SSCG(1) = 5, SSCG(2) is a finite tower.
            if coef ~= 1 or pow ~= 1 or off ~= 0 then
                return nil
            end
            local small = Impl.sscgValue(Impl.finite(n))
            return sign < 0 and Impl.negate(small) or Impl.copy(small)
        end
        if family == "LOADER" and n == 0 then
            -- D^0(99) is zero iterations of D: the seed itself.
            if coef ~= 1 or pow ~= 1 or off ~= 0 then
                return nil
            end
            return Impl.finite(sign * 99)
        end
        if family == "BB" and n < 6 then
            -- Rado's known cases: BB(0..5) = 0, 1, 4, 6, 13, 4098.
            if coef ~= 1 or pow ~= 1 or off ~= 0 then
                return nil
            end
            local small = Impl.bbValue(Impl.finite(n))
            return sign < 0 and Impl.negate(small) or Impl.copy(small)
        end
    end
    return Named.new(family, nidx ~= nil and nidx or n, sign, pow, coef, off, nx)
end

-- Finite hyperoperation band -----------------------------------------------
-- Hyperoperations above tetration outgrow doubles and compact towers long
-- before they stop being finite integers, so they must not turn into LIMIT or
-- into infinite-rank towers. Levels 3+ keep a structural finite value
-- H(level, base, arg) shaped like a named magnitude: coef * H^p + off.
-- Without a named operand the band sits above every finite-rank tower and
-- below every named-mega value; ordering inside it is level, then base, then
-- arg, then power/coefficient/offset. With a named operand the value is
-- anchored inside that constant's band (above the plain constant, below the
-- next index/family), because a hyperoperation on a named integer is still
-- far below the next named giant. As with the TREE/SSCG/BB bands, the
-- ordering is a modelling convention, not a proof about arbitrary
-- hyperoperations.

Hyper = {}

local HYPER_COEF_MAX = 1e308

-- Hyper operands must be non-negative finite-tier values: a double, another
-- hyper value, a positive finite-rank tower, or a positive named constant.
-- Infinite-rank towers and LIMIT already sit above the model and saturate.
function Hyper.eligible(v)
    if type(v) ~= "table" then
        return false
    end
    if v.kind == "finite" then
        return Impl.signOf(v) >= 0
    elseif v.kind == "hyper" then
        return v.sign > 0
    elseif v.kind == "named" then
        return v.sign > 0
    elseif v.kind == "tower" then
        return v.sign > 0 and Rank.isFinite(v.rank)
    end
    return false
end

-- Greatest named constant mentioned in a hyper expression, or nil when the
-- value is a plain finite-tier H(...). The anchor decides which named band
-- the value belongs to.
function Hyper.anchorOf(v)
    if type(v) ~= "table" then
        return nil
    end
    if v.kind == "named" then
        return v.sign > 0 and v or nil
    end
    if v.kind ~= "hyper" then
        return nil
    end
    local a = Hyper.anchorOf(v.base)
    local b = Hyper.anchorOf(v.arg)
    if a == nil then
        return b
    elseif b == nil then
        return a
    end
    return Named.compareBase(a, b) >= 0 and a or b
end

function Hyper.copy(v)
    return setmetatable({
        kind = "hyper",
        sign = v.sign,
        level = v.level,
        base = Impl.copy(v.base),
        arg = Impl.copy(v.arg),
        p = v.p,
        coef = v.coef,
        off = v.off,
    }, ZubaNum)
end

function Hyper.withSign(v, sign)
    local out = Hyper.copy(v)
    out.sign = sign < 0 and -1 or 1
    return out
end

function Hyper.normalize(level, base, arg, sign, pow, coef, off)
    sign = sign < 0 and -1 or 1
    if coef ~= coef or pow ~= pow or off ~= off then
        return NAN
    end
    if not isfinite(pow) or pow <= 0 then
        return sign > 0 and CAP or NEG_CAP
    end
    if not isfinite(coef) or coef <= 0 then
        if coef == 0 then
            if not isfinite(off) or off == 0 then
                return ZERO
            end
            return Impl.finite(sign * off)
        end
        return sign > 0 and CAP or NEG_CAP
    end
    if coef > HYPER_COEF_MAX then
        coef = HYPER_COEF_MAX
    end
    if not isfinite(off) then
        off = 0
    end
    return setmetatable({
        kind = "hyper",
        sign = sign,
        level = level,
        base = base,
        arg = arg,
        p = pow,
        coef = coef,
        off = off,
    }, ZubaNum)
end

function Hyper.new(level, base, arg, sign, pow, coef, off)
    level = tonumber(level)
    if level == nil or not isfinite(level) or level ~= math.floor(level) or level < 3 then
        return NAN
    end
    if not Impl.isZuba(base) or not Impl.isZuba(arg) then
        return NAN
    end
    if not Hyper.eligible(base) or not Hyper.eligible(arg) then
        return NAN
    end
    sign = tonumber(sign) or 1
    pow = tonumber(pow) or 1
    coef = tonumber(coef) or 1
    off = tonumber(off) or 0
    if not isfinite(pow) or pow <= 0 or not isfinite(coef) or coef <= 0
        or not isfinite(off) then
        return NAN
    end
    return Hyper.normalize(level, Impl.copy(base), Impl.copy(arg), sign, pow, coef, off)
end

function Hyper.sameStruct(a, b)
    if a.level ~= b.level then
        return false
    end
    return Impl.compare(a.base, b.base) == 0 and Impl.compare(a.arg, b.arg) == 0
end

-- True when target is a proper base/arg subexpression of v.
local function hyperContains(v, target)
    if type(v) ~= "table" or v.kind ~= "hyper" then
        return false
    end
    if Impl.compare(v.base, target) == 0 or Impl.compare(v.arg, target) == 0 then
        return true
    end
    return hyperContains(v.base, target) or hyperContains(v.arg, target)
end

-- Applying a hyperoperation with base > 1 to target as its argument grows
-- past target (2^X > X, c^c > c, exp of a hyper value above it). A target
-- inside the base only counts for counts above 1: sqrt(X) is smaller.
local function hyperGrowsAbove(v, target)
    if v.base.kind == "finite" then
        if v.base.n <= 1 then
            return false
        end
    elseif Impl.signOf(v.base) <= 0 then
        return false
    end
    if Impl.compare(v.arg, target) == 0 or hyperContains(v.arg, target) then
        return true
    end
    if Impl.compare(v.base, target) == 0 or hyperContains(v.base, target) then
        return v.arg.kind ~= "finite" or v.arg.n > 1
    end
    return false
end

function Hyper.compareMag(a, b)
    -- A named anchor outranks the structural order: everything anchored on
    -- TREE(3) is below everything anchored on TREE(4), whatever the levels.
    local aa = Hyper.anchorOf(a)
    local ab = Hyper.anchorOf(b)
    if aa ~= nil or ab ~= nil then
        if aa == nil then
            return -1
        elseif ab == nil then
            return 1
        end
        local ac = Named.compareMag(aa, ab)
        if ac ~= 0 then
            return ac
        end
    end
    -- A value fed into another hyperoperation outranks its own argument:
    -- exp(centation) is above the centation it exponentiates.
    if hyperGrowsAbove(a, b) then
        return 1
    elseif hyperGrowsAbove(b, a) then
        return -1
    end
    -- Higher hyper levels dominate: centation beats any fixed power or power
    -- tower of the same constant.
    if a.level ~= b.level then
        return a.level < b.level and -1 or 1
    end
    -- At one level a constant in the argument grows with the constant itself
    -- (2^c, c^c), so it outranks a fixed power of it (c^k) whose argument is
    -- still a plain count.
    local abase = Hyper.anchorOf(a.base)
    local bbase = Hyper.anchorOf(b.base)
    local aarg = Hyper.anchorOf(a.arg)
    local barg = Hyper.anchorOf(b.arg)
    if aarg ~= nil and barg == nil and bbase ~= nil then
        return 1
    elseif barg ~= nil and aarg == nil and abase ~= nil then
        return -1
    end
    local c = Impl.compare(a.base, b.base)
    if c ~= 0 then
        return c
    end
    c = Impl.compare(a.arg, b.arg)
    if c ~= 0 then
        return c
    end
    if a.p ~= b.p then
        return a.p < b.p and -1 or 1
    end
    if a.coef ~= b.coef then
        return a.coef < b.coef and -1 or 1
    end
    if a.off ~= b.off then
        return a.off < b.off and -1 or 1
    end
    return 0
end

function Hyper.magAdd(a, b)
    if Hyper.sameStruct(a, b) then
        return Hyper.normalize(a.level, Impl.copy(a.base), Impl.copy(a.arg), 1,
            a.p, a.coef + b.coef, a.off + b.off)
    end
    return Hyper.compareMag(a, b) >= 0 and Hyper.copy(a) or Hyper.copy(b)
end

function Hyper.magSub(a, b)
    if Hyper.sameStruct(a, b) then
        local coef = a.coef - b.coef
        local off = a.off - b.off
        if coef <= 0 then
            if off <= 0 then
                return ZERO
            end
            return Impl.finite(off)
        end
        return Hyper.normalize(a.level, Impl.copy(a.base), Impl.copy(a.arg), 1,
            a.p, coef, off)
    end
    return Hyper.copy(a)
end

function Hyper.addValues(a, b)
    if a.sign == b.sign then
        return Impl.signedMagnitude(a.sign, Hyper.magAdd(a, b))
    end
    local cmp = Hyper.compareMag(a, b)
    if cmp == 0 then
        return ZERO
    elseif cmp > 0 then
        return Impl.signedMagnitude(a.sign, Hyper.magSub(a, b))
    end
    return Impl.signedMagnitude(b.sign, Hyper.magSub(b, a))
end

function Hyper.addFinite(v, n)
    local off = v.off + v.sign * n
    if not isfinite(off) then
        return Hyper.copy(v)
    end
    return Hyper.normalize(v.level, Impl.copy(v.base), Impl.copy(v.arg), v.sign,
        v.p, v.coef, off)
end

function Hyper.mulFinite(v, n)
    local sign = v.sign
    if n < 0 then
        sign = -sign
        n = -n
    end
    local coef = v.coef * n
    if coef > HYPER_COEF_MAX then
        coef = HYPER_COEF_MAX
    end
    local off = v.off * n
    if not isfinite(off) then
        off = 0
    end
    return Hyper.normalize(v.level, Impl.copy(v.base), Impl.copy(v.arg), sign,
        v.p, coef, off)
end

function Hyper.mul(a, b)
    local sign = a.sign * b.sign
    if Hyper.sameStruct(a, b) then
        return Hyper.normalize(a.level, Impl.copy(a.base), Impl.copy(a.arg), sign,
            a.p + b.p, a.coef * b.coef, 0)
    end
    local big = Hyper.compareMag(a, b) >= 0 and a or b
    return Hyper.withSign(big, sign)
end

function Hyper.div(a, b)
    local sign = a.sign * b.sign
    if Hyper.sameStruct(a, b) then
        local pow = a.p - b.p
        if pow > 0 then
            return Hyper.normalize(a.level, Impl.copy(a.base), Impl.copy(a.arg), sign,
                pow, a.coef / b.coef, 0)
        elseif pow == 0 then
            local q = a.coef / b.coef
            if not isfinite(q) then
                return sign > 0 and CAP or NEG_CAP
            end
            return Impl.finite(sign * q)
        end
        return ZERO
    end
    local cmp = Hyper.compareMag(a, b)
    if cmp == 0 then
        return ONE
    elseif cmp > 0 then
        return Hyper.withSign(a, sign)
    end
    return ZERO
end

function Hyper.pow(v, exponent)
    if exponent == 1 then
        return Hyper.copy(v)
    end
    local pow = v.p * exponent
    local coef = v.coef ^ exponent
    if not isfinite(pow) or pow <= 0 or not isfinite(coef) or coef <= 0 then
        if coef ~= coef or pow == 0 then
            return NAN
        end
        return v.sign > 0 and CAP or NEG_CAP
    end
    if coef > HYPER_COEF_MAX then
        coef = HYPER_COEF_MAX
    end
    return Hyper.normalize(v.level, Impl.copy(v.base), Impl.copy(v.arg), v.sign,
        pow, coef, 0)
end

function Hyper.format(v)
    -- exp() results anchor on Euler's number; print it exactly so the
    -- decimal rounding of the double cannot break a string roundtrip.
    local baseText
    if v.base.kind == "finite" and v.base.n == E_CONST then
        baseText = "e"
    else
        baseText = Impl.format(v.base)
    end
    local base = "H(" .. Named.numberText(v.level) .. ", "
        .. baseText .. ", " .. Impl.format(v.arg) .. ")"
    if v.p ~= 1 then
        base = base .. "^" .. Named.numberText(v.p)
    end
    local body
    if v.coef ~= 1 then
        body = Named.numberText(v.coef) .. "·" .. base
    else
        body = base
    end
    if v.off > 0 then
        body = body .. "+" .. Named.numberText(v.off)
    elseif v.off < 0 then
        body = body .. "-" .. Named.numberText(-v.off)
    end
    if v.sign < 0 then
        if v.coef == 1 and v.p == 1 and v.off == 0 then
            return "-" .. body
        end
        return "-(" .. body .. ")"
    end
    return body
end

function Hyper.splitArgs(s)
    local depth = 0
    local start = 1
    local out = {}
    for i = 1, #s do
        local c = s:sub(i, i)
        if c == "(" then
            depth = depth + 1
        elseif c == ")" then
            depth = depth - 1
            if depth < 0 then
                return nil
            end
        elseif c == "," and depth == 0 then
            out[#out + 1] = s:sub(start, i - 1)
            start = i + 1
        end
    end
    if depth ~= 0 then
        return nil
    end
    out[#out + 1] = s:sub(start)
    return out
end

function Hyper.parse(s)
    if type(s) ~= "string" then
        return nil
    end
    local t = s:lower():gsub("%s+", "")
    t = t:gsub("·", "*")
    if t == "" then
        return nil
    end
    local sign = 1
    if t:sub(1, 1) == "+" then
        t = t:sub(2)
    elseif t:sub(1, 1) == "-" then
        sign = -1
        t = t:sub(2)
    end
    if t:sub(1, 1) == "(" and t:sub(-1) == ")" then
        t = t:sub(2, -2)
    end
    local depth = 0
    local cut = nil
    for i = 1, #t do
        local c = t:sub(i, i)
        if c == "(" then
            depth = depth + 1
        elseif c == ")" then
            depth = depth - 1
            if depth < 0 then
                return nil
            end
        elseif depth == 0 and (c == "+" or c == "-") and i > 1
            and t:sub(i - 1, i - 1) ~= "e" then
            cut = i
        end
    end
    if depth ~= 0 then
        return nil
    end
    local off = 0
    if cut ~= nil then
        off = tonumber(t:sub(cut))
        if off == nil or not isfinite(off) then
            return nil
        end
        t = t:sub(1, cut - 1)
    end
    local coef = 1
    local star = t:find("*", 1, true)
    if star ~= nil then
        coef = tonumber(t:sub(1, star - 1))
        if coef == nil or not isfinite(coef) or coef <= 0 then
            return nil
        end
        t = t:sub(star + 1)
    end
    local pow = 1
    local baseStr, powStr = t:match("^(.-)%^([%deE%+%-%.]+)$")
    if baseStr ~= nil then
        pow = tonumber(powStr)
        if pow == nil or not isfinite(pow) or pow <= 0 then
            return nil
        end
        t = baseStr
    end
    if t:sub(1, 1) ~= "h" or t:sub(2, 2) ~= "(" or t:sub(-1) ~= ")" then
        return nil
    end
    local args = Hyper.splitArgs(t:sub(3, -2))
    if args == nil or #args ~= 3 then
        return nil
    end
    local level = tonumber(args[1])
    if level == nil or not isfinite(level) or level ~= math.floor(level) or level < 3 then
        return nil
    end
    local baseV = Impl.parseString(args[2])
    local argV = Impl.parseString(args[3])
    if baseV.kind == "nan" or argV.kind == "nan" then
        return nil
    end
    local out = Hyper.new(level, baseV, argV, sign, pow, coef, off)
    if out.kind == "nan" then
        return nil
    end
    return out
end

-- Cardinals, fixed points and the fast-growing hierarchy -------------------
-- The infinite tier. A card value is an initial ordinal: aleph_alpha,
-- beth_alpha, or the n-th fixed point of one of those ladders. Every other
-- ZubaNum value models a finite integer, so it is always a *finite*
-- subscript: aleph(rayo(1e100)) stays below aleph(omega) because Rayo's
-- number, huge as it is, is still a natural number.
--
-- Index classes, in increasing order:
--   fin  - finite ordinal: doubles, hyper band values and named-mega values
--   ord  - countable ordinal from the rank fragment (omega ... LVO)
--   card - a cardinal used as a subscript, e.g. aleph(aleph(1))
--   fp   - fixed point of the aleph or beth ladder
-- fin < ord because every finite value is below every infinite ordinal, and
-- ord < card because every rank in the fragment is countable, hence below
-- the first uncountable cardinal. A fixed point closes the ladder below it,
-- so it sits above every index drawn from that ladder.
--
-- f_0(n) = n + 1, f_1(n) = 2n, f_2(n) = n * 2^n and f_{a+1}(n) = f_a^(n+1)(n).
-- A finite level expands into the hyper band this library already models, so
-- only transfinite levels stay formal: f_alpha(n) with an ordinal index is
-- ordered inside tier 3 by that index.

Idx = {}

local IDX_CLASS = { fin = 1, ord = 2, card = 3, fp = 4 }
local ALEPH_GLYPH = string.char(226, 132, 181)
local BETH_GLYPH = string.char(226, 132, 182)
local SUBSCRIPTS = {}
for i = 0, 9 do
    SUBSCRIPTS[i] = string.char(226, 130, 128 + i)
end

function Idx.opGlyph(op)
    return op == "beth" and BETH_GLYPH or ALEPH_GLYPH
end

function Idx.fin(v)
    return { cls = "fin", v = Impl.magnitude(v) }
end

function Idx.ord(r)
    return { cls = "ord", rank = Rank.copy(r) }
end

function Idx.cardOf(op, inner)
    return { cls = "card", op = op, idx = inner }
end

function Idx.fpOf(op, inner)
    return { cls = "fp", op = op, idx = inner }
end

-- A cardinal subscript is an ordinal, not a tower height, so it is not capped
-- by the ranking ceiling: aleph_(LVO+1) is legal even though no tower rises
-- that far.
function Idx.fromRank(r)
    if r == nil then
        return nil
    end
    if Rank.isFinite(r) then
        return Idx.fin(Impl.finite(Rank.finiteValue(r)))
    end
    return Idx.ord(r)
end

function Idx.copy(i)
    if i.cls == "fin" then
        return { cls = "fin", v = Impl.copy(i.v) }
    elseif i.cls == "ord" then
        return { cls = "ord", rank = Rank.copy(i.rank) }
    end
    return { cls = i.cls, op = i.op, idx = Idx.copy(i.idx) }
end

function Idx.isZero(i)
    return i.cls == "fin" and Impl.isZero(i.v)
end

-- Reading a ZubaNum value as an ordinal subscript. Everything finite stays a
-- finite index; an infinite-rank tower contributes its rank, which is exactly
-- the ordinal this library can name; cardinals become cardinal indices.
function Idx.fromValue(v)
    if not Impl.isZuba(v) or v.kind == "nan" or v.kind == "cap" then
        return nil
    end
    if Impl.signOf(v) < 0 then
        return nil
    end
    if v.kind == "card" then
        if v.mode == "fp" then
            return Idx.fpOf(v.op, v.idx)
        end
        return Idx.cardOf(v.op, v.idx)
    elseif v.kind == "fgh" then
        if v.idx.cls ~= "ord" then
            return nil
        end
        return Idx.ord(v.idx.rank)
    elseif v.kind == "tower" then
        if Rank.isFinite(v.rank) then
            return Idx.fin(v)
        end
        return Idx.ord(v.rank)
    end
    return Idx.fin(v)
end

function Idx.compare(a, b)
    local ca, cb = IDX_CLASS[a.cls], IDX_CLASS[b.cls]
    if ca ~= cb then
        return ca < cb and -1 or 1
    end
    if a.cls == "fin" then
        return Impl.cmpPositive(a.v, b.v)
    elseif a.cls == "ord" then
        return Rank.compare(a.rank, b.rank)
    end
    local c = Idx.compare(a.idx, b.idx)
    if c ~= 0 then
        return c
    end
    if a.op == b.op then
        return 0
    end
    -- Inside a subscript the model keeps the two ladders interleaved with
    -- aleph below beth, matching aleph_alpha <= beth_alpha.
    return a.op == "aleph" and -1 or 1
end

function Idx.compareLadder(opA, modeA, idxA, opB, modeB, idxB)
    -- Same ordering as comparing cardOf/fpOf wrappers, without building them.
    local ca = IDX_CLASS[modeA == "fp" and "fp" or "card"]
    local cb = IDX_CLASS[modeB == "fp" and "fp" or "card"]
    if ca ~= cb then
        return ca < cb and -1 or 1
    end
    local c = Idx.compare(idxA, idxB)
    if c ~= 0 then
        return c
    end
    if opA == opB then
        return 0
    end
    return opA == "aleph" and -1 or 1
end

function Idx.succ(i)
    if i.cls == "fin" then
        return Idx.fin(Impl.addValues(i.v, ONE))
    elseif i.cls == "ord" then
        return Idx.ord(Rank.succ(i.rank))
    end
    local inner = Idx.succ(i.idx)
    if inner == nil then
        return nil
    end
    return { cls = i.cls, op = i.op, idx = inner }
end

function Idx.subText(i)
    if i.cls ~= "fin" then
        return nil
    end
    local v = i.v
    if v.kind ~= "finite" or v.n < 0 or v.n > 999 or v.n ~= math.floor(v.n) then
        return nil
    end
    local digits = tostring(math.floor(v.n))
    local out = {}
    for k = 1, #digits do
        local d = tonumber(digits:sub(k, k))
        if d == nil then
            return nil
        end
        out[#out + 1] = SUBSCRIPTS[d]
    end
    return table.concat(out)
end

function Idx.toString(i)
    if i.cls == "fin" then
        local sub = Idx.subText(i)
        if sub ~= nil then
            return sub
        end
        return Impl.format(i.v)
    elseif i.cls == "ord" then
        return Rank.toString(i.rank)
    elseif i.cls == "card" then
        return Idx.opGlyph(i.op) .. Idx.tail(i.idx)
    end
    return Idx.opGlyph(i.op) .. "*" .. Idx.tail(i.idx)
end

-- Text that follows a glyph: subscript digits for small finite indices, an
-- underscore plus rank for ordinals, parentheses for structured ones.
function Idx.tail(i)
    local sub = Idx.subText(i)
    if sub ~= nil then
        return sub
    end
    if i.cls == "ord" then
        return "_" .. Rank.toString(i.rank)
    end
    return "(" .. Idx.toString(i) .. ")"
end

function Idx.toTable(i)
    if i.cls == "fin" then
        return { cls = "fin", v = Impl.toTable(i.v) }
    elseif i.cls == "ord" then
        return { cls = "ord", rank = Rank.toTable(i.rank) }
    end
    return { cls = i.cls, op = i.op, idx = Idx.toTable(i.idx) }
end

function Idx.fromTable(t)
    if type(t) ~= "table" then
        return nil
    end
    if t.cls == "fin" then
        local v = Impl.fromTable(t.v)
        if v.kind == "nan" or Impl.signOf(v) < 0 then
            return nil
        end
        return Idx.fin(v)
    elseif t.cls == "ord" then
        local r = Rank.fromTable(t.rank)
        if r == nil then
            return nil
        end
        return Idx.ord(r)
    elseif t.cls == "card" or t.cls == "fp" then
        if t.op ~= "aleph" and t.op ~= "beth" then
            return nil
        end
        local inner = Idx.fromTable(t.idx)
        if inner == nil then
            return nil
        end
        return { cls = t.cls, op = t.op, idx = inner }
    end
    return nil
end

-- Reading an index from a spelling: rank atoms first (omega, eps0, "1+1"),
-- then any ordinary numeric or named value as a finite subscript.
function Idx.fromToken(tok, depth)
    if tok == nil or tok == "" then
        return Idx.fin(ZERO)
    end
    -- A pure numeric spelling is always a value subscript: rank parsing would
    -- swallow "1e3003" as a finite rank and clamp its out-of-range mantissa to 0.
    local r = nil
    if tonumber(tok) == nil then
        r = Impl.parseRankString(tok)
    end
    if r ~= nil then
        return Idx.fromRank(r)
    end
    local v = Impl.parseString(tok, depth + 1)
    if v.kind == "nan" then
        return nil
    end
    return Idx.fromValue(v)
end

-- Reading an index from a call argument: rank tables and rank spellings give
-- an ordinal index, anything else is read as a value and classified.
function Idx.fromArg(x)
    if x == nil then
        return Idx.fin(ZERO)
    end
    if type(x) == "table" and not Impl.isZuba(x) then
        return Idx.fromRank(Impl.rankFromAny(x))
    end
    if type(x) == "string" then
        local r = Impl.rankFromAny(x)
        if r ~= nil and not Rank.isFinite(r) then
            return Idx.ord(r)
        end
    end
    local v = Impl.asValue(x)
    if v.kind == "nan" then
        return nil
    end
    return Idx.fromValue(v)
end

Card = {}

function Card.copy(v)
    return setmetatable({
        kind = "card",
        sign = v.sign,
        op = v.op,
        mode = v.mode,
        idx = Idx.copy(v.idx),
    }, ZubaNum)
end

function Card.withSign(v, sign)
    -- The magnitude helpers collapse to ordinary values (0, 1, the ceiling),
    -- so only a real cardinal is copied and re-signed.
    if v.kind ~= "card" then
        if v.kind == "cap" then
            return sign < 0 and NEG_CAP or CAP
        end
        return v
    end
    local out = Card.copy(v)
    out.sign = sign < 0 and -1 or 1
    return out
end

-- aleph_alpha / beth_alpha. aleph applied to a fixed point of the same ladder
-- is that fixed point, so the two spellings collapse to one value.
function Card.plain(op, idx, sign)
    if idx == nil or (op ~= "aleph" and op ~= "beth") then
        return NAN
    end
    sign = (tonumber(sign) or 1) < 0 and -1 or 1
    if idx.cls == "fp" and idx.op == op then
        return Card.fixed(op, idx.idx, sign)
    end
    return setmetatable({
        kind = "card",
        sign = sign,
        op = op,
        mode = "plain",
        idx = Idx.copy(idx),
    }, ZubaNum)
end

-- The n-th fixed point of the aleph (or beth) ladder.
function Card.fixed(op, idx, sign)
    if idx == nil or (op ~= "aleph" and op ~= "beth") then
        return NAN
    end
    sign = (tonumber(sign) or 1) < 0 and -1 or 1
    if Idx.isZero(idx) then
        -- The zeroth rung of the ladder is where the fixed-point search starts,
        -- so it names the base cardinal rather than a fixed point.
        return Card.plain(op, Idx.copy(idx), sign)
    end
    return setmetatable({
        kind = "card",
        sign = sign,
        op = op,
        mode = "fp",
        idx = Idx.copy(idx),
    }, ZubaNum)
end

function Card.fpIndex(v)
    return Idx.fpOf(v.op, v.idx)
end

-- Ordering. Provably decidable pairs give -1/0/1; pairs whose order really is
-- independent of ZFC give nil, which reads back as "incomparable" everywhere.
function Card.compareMag(a, b)
    if a.mode == "plain" and b.mode == "plain" then
        if a.op == b.op then
            return Idx.compare(a.idx, b.idx)
        end
        local c = Idx.compare(a.idx, b.idx)
        if c == 0 then
            if Idx.isZero(a.idx) and Idx.isZero(b.idx) then
                return 0
            end
            return nil
        end
        -- aleph_alpha <= beth_alpha, so a smaller subscript is decisive only
        -- when the aleph side is the smaller one.
        if a.op == "aleph" then
            if c < 0 then
                return -1
            end
            return nil
        end
        if c > 0 then
            return 1
        end
        return nil
    end
    if a.mode == "fp" and b.mode == "fp" then
        local c = Idx.compare(a.idx, b.idx)
        if c ~= 0 then
            return c
        end
        if a.op == b.op then
            return 0
        end
        return nil
    end
    local plain, fp
    if a.mode == "fp" then
        fp, plain = a, b
    else
        plain, fp = a, b
    end
    local c
    if plain.op == fp.op then
        c = Idx.compare(plain.idx, Card.fpIndex(fp))
    elseif plain.op == "aleph" then
        c = Idx.compare(plain.idx, Card.fpIndex(fp))
        if c > 0 then
            c = nil
        end
    else
        c = nil
    end
    if c == nil then
        return nil
    end
    if plain == a then
        return c
    end
    return -c
end

function Card.comparePositive(a, b)
    return Card.compareMag(a, b)
end

-- Arithmetic has to pick a side even where ZFC cannot decide the order, so it
-- uses this total reading: the subscript decides, and an equal subscript ties
-- toward the upper (beth / fixed-point) ladder.
function Card.compareDefinite(a, b)
    return Idx.compareLadder(a.op, a.mode, a.idx, b.op, b.mode, b.idx)
end

-- 2^kappa, read as the next rung of the beth ladder. Under GCH this is the
-- successor cardinal; without it the library still gives the beth value, which
-- is the bound ZFC actually proves for the power set of an aleph.
function Card.powerSet(k)
    local i = Idx.succ(k.idx)
    if i == nil then
        return CAP
    end
    if k.mode == "fp" then
        return Card.fixed("beth", i, 1)
    end
    return Card.plain("beth", i, 1)
end

function Card.magPow(a, b)
    if b.kind ~= "card" then
        if Impl.isZero(b) then
            return ONE
        end
        return Card.copy(a)
    end
    -- k^lambda is at least k and at least 2^lambda, and equals 2^lambda once
    -- the exponent reaches the base, so the model returns the larger bound.
    local ps = Card.powerSet(b)
    if Card.compareDefinite(ps, a) >= 0 then
        return ps
    end
    return Card.copy(a)
end

function Card.cardSucc(v)
    if v.kind == "card" then
        local i = Idx.succ(v.idx)
        if i == nil then
            return CAP
        end
        if v.mode == "fp" then
            return Card.fixed(v.op, i, v.sign)
        end
        return Card.plain(v.op, i, v.sign)
    end
    if v.kind == "nan" then
        return NAN
    end
    if v.kind == "cap" then
        return CAP
    end
    if v.kind == "finite" and v.n >= 0 and v.n <= MAX_SAFE then
        return Impl.finite(math.floor(v.n) + 1)
    end
    -- Every other value this library holds is a finite integer, so the next
    -- cardinal above it is the first infinite one.
    return Card.copy(ALEPH0)
end

-- Signed cardinal operations. Every non-card operand is a finite integer, so
-- it is absorbed by the cardinal unless the exponent position says otherwise.
function Card.addValues(a, b)
    if a.kind ~= "card" then
        return Card.copy(b)
    elseif b.kind ~= "card" then
        return Card.copy(a)
    end
    if a.sign == b.sign then
        -- κ + λ is the larger cardinal, so one compare decides the result and
        -- a single copy builds it.
        return Card.copy(Card.compareDefinite(a, b) >= 0 and a or b)
    end
    local c = Card.compareDefinite(a, b)
    if c == 0 then
        return ZERO
    end
    -- Opposite signs cancel into subtraction: the larger magnitude keeps its
    -- own sign.
    return Card.copy(c > 0 and a or b)
end

function Card.mulValues(a, b)
    local sign = Impl.signOf(a) * Impl.signOf(b)
    if a.kind ~= "card" then
        return Card.withSign(b, sign)
    elseif b.kind ~= "card" then
        return Card.withSign(a, sign)
    end
    return Card.withSign(Card.compareDefinite(a, b) >= 0 and a or b, sign)
end

function Card.divValues(a, b)
    local sign = Impl.signOf(a) * Impl.signOf(b)
    if a.kind == "card" and b.kind == "card" then
        local c = Card.compareDefinite(a, b)
        if c == 0 then
            return ONE
        elseif c > 0 then
            return Card.withSign(a, sign)
        end
        return ZERO
    end
    if a.kind == "card" then
        -- Dividing by a finite integer leaves an infinite cardinal alone.
        return Card.withSign(a, sign)
    end
    return ZERO
end

function Card.powValues(a, b)
    if b.kind == "card" then
        if a.kind == "card" then
            return Card.withSign(Card.magPow(Impl.magnitude(a), Impl.magnitude(b)), 1)
        end
        if Impl.signOf(a) < 0 then
            -- The parity of a cardinal exponent is not representable.
            return NAN
        end
        local ab = Impl.magnitude(a)
        if ab.kind == "finite" then
            if ab.n == 1 then
                return ONE
            elseif ab.n < 1 then
                return ZERO
            end
        end
        -- k^kappa = 2^kappa for every finite k >= 2.
        return Card.powerSet(b)
    end
    if a.kind ~= "card" then
        return nil
    end
    if Impl.isZero(b) then
        return ONE
    end
    if Impl.signOf(b) < 0 then
        -- 1 / kappa is smaller than every cardinal this model can name.
        return ZERO
    end
    if a.sign < 0 then
        if b.kind ~= "finite" or b.n ~= math.floor(b.n) then
            -- The parity of a non-integer exponent is not representable.
            return NAN
        end
        if math.abs(b.n) % 2 == 0 then
            return Card.withSign(a, 1)
        end
        return Card.copy(a)
    end
    return Card.copy(a)
end

function Card.format(v)
    local glyph = Idx.opGlyph(v.op)
    local body
    if v.mode == "fp" then
        body = glyph .. "*" .. Idx.tail(v.idx)
    else
        body = glyph .. Idx.tail(v.idx)
    end
    if v.sign < 0 then
        return "-" .. body
    end
    return body
end

function Card.toTable(v)
    return {
        __zuba = 1,
        kind = "card",
        sign = v.sign,
        op = v.op,
        mode = v.mode,
        idx = Idx.toTable(v.idx),
    }
end

function Card.fromTable(t)
    local idx = Idx.fromTable(t.idx)
    if idx == nil then
        return NAN
    end
    if t.mode == "fp" then
        return Card.fixed(t.op, idx, t.sign)
    end
    return Card.plain(t.op, idx, t.sign)
end

Fgh = {}

function Fgh.copy(v)
    return setmetatable({
        kind = "fgh",
        sign = v.sign,
        mode = v.mode,
        idx = Idx.copy(v.idx),
        arg = Impl.copy(v.arg),
    }, ZubaNum)
end

function Fgh.withSign(v, sign)
    local out = Fgh.copy(v)
    out.sign = sign < 0 and -1 or 1
    return out
end

-- Finite levels expand into the value model; a level that is not a plain
-- integer stays formal and is ordered by its own index.
function Fgh.expand(alpha, n)
    if alpha.kind ~= "finite" then
        return nil
    end
    local a = numfloor(alpha.n)
    if a < 0 or not isfinite(a) or a ~= alpha.n then
        return nil
    end
    if a == 0 then
        return Impl.addValues(n, ONE)
    elseif a == 1 then
        return Impl.mulValues(n, Impl.finite(2))
    elseif a == 2 then
        return Impl.mulValues(n, Impl.powValues(Impl.finite(2), n))
    end
    return Impl.hyperValue(a + 1, n, n)
end

function Fgh.create(idx, arg)
    if idx == nil or not Impl.isZuba(arg) or arg.kind == "nan" then
        return NAN
    end
    if Impl.signOf(arg) < 0 then
        return NAN
    end
    if idx.cls == "fin" then
        local expanded = Fgh.expand(idx.v, arg)
        if expanded ~= nil then
            return expanded
        end
    end
    return setmetatable({
        kind = "fgh",
        sign = 1,
        idx = Idx.copy(idx),
        arg = Impl.magnitude(arg),
    }, ZubaNum)
end

-- Hardy hierarchy: H_0(x) = x, H_{a+1}(x) = H_a(x + 1), H_l(x) = H_{l[x]}(x).
-- A finite level is plain addition, which the value model holds exactly, so
-- only transfinite levels stay formal. The hierarchy is relativised to the
-- seed function x -> x + base, which shifts every level by the same amount,
-- so base folds into the argument instead of becoming a third field.
function Fgh.hardy(idx, arg, base)
    if idx == nil or not Impl.isZuba(arg) or arg.kind == "nan" then
        return NAN
    end
    local seed = arg
    if base ~= nil then
        local b = Impl.asValue(base)
        if b.kind == "nan" then
            return NAN
        end
        seed = Impl.addValues(arg, b)
    end
    if Impl.signOf(seed) < 0 then
        return NAN
    end
    if idx.cls == "fin" then
        local k = idx.v
        if k.kind ~= "finite" or k.n < 0 or k.n ~= numfloor(k.n) or not isfinite(k.n) then
            return NAN
        end
        return Impl.addValues(seed, k)
    end
    return setmetatable({
        kind = "fgh",
        mode = "hardy",
        sign = 1,
        idx = Idx.copy(idx),
        arg = Impl.magnitude(seed),
    }, ZubaNum)
end

function Fgh.rankOf(v)
    if v.idx.cls == "ord" then
        return v.idx.rank
    end
    return Rank.TOP
end

function Fgh.comparePositive(a, b)
    local ic = Idx.compare(a.idx, b.idx)
    if ic ~= 0 then
        return ic
    end
    return Impl.compare(a.arg, b.arg)
end

function Fgh.format(v)
    local head = v.mode == "hardy" and "H" or "f"
    local body = head .. Idx.tail(v.idx) .. "(" .. Impl.format(v.arg) .. ")"
    if v.sign < 0 then
        return "-" .. body
    end
    return body
end

function Fgh.toTable(v)
    return {
        __zuba = 1,
        kind = "fgh",
        sign = v.sign,
        mode = v.mode,
        idx = Idx.toTable(v.idx),
        arg = Impl.toTable(v.arg),
    }
end

function Fgh.fromTable(t)
    local idx = Idx.fromTable(t.idx)
    local arg = Impl.fromTable(t.arg)
    if idx == nil or arg.kind == "nan" then
        return NAN
    end
    if t.mode == "hardy" then
        return Fgh.hardy(idx, arg)
    end
    return Fgh.create(idx, arg)
end

-- Split "name(a, b)" into the argument strings, respecting one level of
-- nesting so a nested rank spelling may itself contain a comma.
local function splitArgs(inner)
    local depth = 0
    for i = 1, #inner do
        local ch = inner:sub(i, i)
        if ch == "(" then
            depth = depth + 1
        elseif ch == ")" then
            depth = depth - 1
        elseif ch == "," and depth == 0 then
            return inner:sub(1, i - 1), inner:sub(i + 1)
        end
    end
    return inner, nil
end

-- Subscript digits are three-byte UTF-8 sequences, so the byte test rejects
-- ordinary spellings without building a substring per candidate.
local function subDigitValue(tok)
    local ascii = tonumber(tok)
    if ascii ~= nil then
        return ascii
    end
    local n = #tok
    if n == 0 or n % 3 ~= 0 then
        return nil
    end
    local value = 0
    for i = 1, n, 3 do
        if tok:byte(i) ~= 226 or tok:byte(i + 1) ~= 130 then
            return nil
        end
        local d = tok:byte(i + 2) - 128
        if d < 0 or d > 9 then
            return nil
        end
        value = value * 10 + d
    end
    return value
end

-- Spellings: aleph(...), aleph_5, aleph5, aleph(omega), alephfixed(2),
-- beth(...), fgh(omega, 100), f_omega(100) and the glyph forms.
--
-- A depth-zero sign splits an additive remainder from the cardinal head, so
-- "aleph(omega)+1" folds through cardinal arithmetic instead of failing.
local CARDINAL_HEADS = { ale = true, alp = true, bet = true, fgh = true, har = true }

local function splitCardinalOffset(low)
    local head = low:sub(1, 3)
    if not CARDINAL_HEADS[head] and not (low:sub(1, 1) == "f" and low:sub(2, 2) == "_")
        and not (low:sub(1, 1) == "h" and low:sub(2, 2) == "_") then
        return nil
    end
    local depth = 0
    for i = 2, #low do
        local b = low:byte(i)
        if b == 40 then
            depth = depth + 1
        elseif b == 41 then
            depth = depth - 1
        elseif depth == 0 and (b == 43 or b == 45) then
            return low:sub(1, i - 1), b == 43 and "+" or "-", low:sub(i + 1)
        end
    end
    return nil
end

function Card.parse(s, depth)
    if type(s) ~= "string" then
        return nil
    end
    local t = s
    -- Each gsub builds a new string, so pay for them only when the spelling
    -- actually carries whitespace or a cardinal glyph.
    if t:find("%s") ~= nil then
        t = (t:gsub("%s+", ""))
    end
    if t:byte(1) == 226 or t:find(ALEPH_GLYPH) ~= nil or t:find(BETH_GLYPH) ~= nil then
        t = (t:gsub(ALEPH_GLYPH, "aleph"))
        t = (t:gsub(BETH_GLYPH, "beth"))
    end
    local sign = 1
    if t:sub(1, 1) == "-" then
        sign = -1
        t = t:sub(2)
    elseif t:sub(1, 1) == "+" then
        t = t:sub(2)
    end
    local low = t:lower()

    local headTok, offsetOp, offsetTok = splitCardinalOffset(low)
    if headTok ~= nil and offsetTok ~= "" then
        local head = Card.parse(headTok, depth)
        if head ~= nil and head.kind ~= "nan" then
            local rest = Impl.parseString(offsetTok, depth + 1)
            if offsetOp == "+" then
                return Impl.addValues(head, rest)
            end
            return Impl.subValues(head, rest)
        end
    end

    local function make(op, mode, tok)
        local idx = Idx.fromToken(tok, depth)
        if idx == nil then
            return NAN
        end
        local v
        if mode == "fp" then
            v = Card.fixed(op, idx, sign)
        else
            v = Card.plain(op, idx, sign)
        end
        return v
    end

    local tok = low:match("^alephfixed%((.-)%)$")
        or low:match("^aleph_fix%((.-)%)$")
        or low:match("^aleph_fixed%((.-)%)$")
        or low:match("^aleph_fp%((.-)%)$")
        or low:match("^alpehfixed%((.-)%)$")
    if tok ~= nil then
        return make("aleph", "fp", tok)
    end
    tok = low:match("^bethfixed%((.-)%)$")
        or low:match("^beth_fix%((.-)%)$")
        or low:match("^beth_fixed%((.-)%)$")
        or low:match("^beth_fp%((.-)%)$")
    if tok ~= nil then
        return make("beth", "fp", tok)
    end

    tok = low:match("^aleph%((.-)%)$") or low:match("^alpeh%((.-)%)$")
    if tok ~= nil then
        return make("aleph", "plain", tok)
    end
    tok = low:match("^beth%((.-)%)$")
    if tok ~= nil then
        return make("beth", "plain", tok)
    end

    if low == "aleph" or low == "alpeh" or low:gsub("[%-_]", "") == "alephnull" then
        return Card.plain("aleph", Idx.fin(ZERO), sign)
    end
    local tail = low:match("^aleph[_=]?(.+)$") or low:match("^alpeh[_=]?(.+)$")
    if tail ~= nil then
        local d = subDigitValue(tail)
        if d ~= nil and d >= 0 then
            return Card.plain("aleph", Idx.fin(Impl.finite(d)), sign)
        end
        return make("aleph", "plain", tail)
    end

    tail = low:match("^beth[_=]?(.+)$")
    if tail == nil and low == "beth" then
        return Card.plain("beth", Idx.fin(ZERO), sign)
    end
    if tail ~= nil then
        local d = subDigitValue(tail)
        if d ~= nil and d >= 0 then
            return Card.plain("beth", Idx.fin(Impl.finite(d)), sign)
        end
        return make("beth", "plain", tail)
    end

    local both = low:match("^fgh%((.-)%)$") or low:match("^fg%((.-)%)$")
    if both ~= nil then
        local aTok, nTok = splitArgs(both)
        if nTok == nil then
            return nil
        end
        return Fgh.create(Idx.fromToken(aTok, depth), Impl.parseString(nTok, depth + 1))
    end
    local aTok, nTok = low:match("^f_([^%(]+)%((.-)%)$")
    if aTok ~= nil then
        return Fgh.create(Idx.fromToken(aTok, depth), Impl.parseString(nTok, depth + 1))
    end

    both = low:match("^hardy%((.-)%)$")
    if both ~= nil then
        local parts = Hyper.splitArgs(both)
        if parts == nil or #parts < 2 or #parts > 3 then
            return nil
        end
        local seed = parts[3] ~= nil and parts[3] ~= "" and Impl.parseString(parts[3], depth + 1) or nil
        return Fgh.hardy(Idx.fromToken(parts[1], depth),
            Impl.parseString(parts[2], depth + 1), seed)
    end
    aTok, nTok = low:match("^h_([^%(]+)%((.-)%)$")
    if aTok ~= nil then
        return Fgh.hardy(Idx.fromToken(aTok, depth), Impl.parseString(nTok, depth + 1))
    end
    return nil
end

-- BEAF linear arrays and arrow chains --------------------------------------
-- A linear array is an array of positive integers. The first two entries are
-- exact here ({a, b} = a^b) and the third runs on the hyper ladder the module
-- already models, so {a, b, c} = a ↑^c b and one arrow is exponentiation,
-- two arrows tetration, and so on. Trailing 1s drop out of the array, which
-- is the s(#,1) = s(#) rule. Four entries and above need the planar rules,
-- whose growth passes every tier in this library, so they return LIMIT.

Beaf = {}

local ARROW_GLYPH = string.char(226, 134, 146)

function Beaf.eval(entries)
    local n = #entries
    while n > 0 do
        local last = entries[n]
        if last.kind ~= "finite" or last.n ~= 1 then
            break
        end
        n = n - 1
    end
    if n == 0 then
        return ONE
    elseif n == 1 then
        return Impl.copy(entries[1])
    elseif n > 3 then
        return CAP
    end
    local a, b = entries[1], entries[2]
    if n == 2 then
        return Impl.powValues(a, b)
    end
    local c = entries[3]
    if c.kind ~= "finite" then
        -- A count no double can hold is a hyper level past the ladder.
        return c.sign < 0 and NAN or CAP
    end
    if c.n < 0 or c.n ~= numfloor(c.n) then
        return NAN
    end
    return Impl.hyperValue(c.n + 2, a, b)
end

-- Split "a->b->c" and "a->->b" into the entries and the number of arrows
-- between them. A run of k arrows between two entries is the three-entry
-- array {a, b, k}; k = 1 keeps the plain {a, b} power.
local function splitArrowChain(t)
    local parts, runs = {}, {}
    local start, i = 1, 1
    local n = #t
    while i <= n do
        if t:byte(i) == 45 and t:byte(i + 1) == 62 then
            parts[#parts + 1] = t:sub(start, i - 1)
            local k = 0
            repeat
                k = k + 1
                i = i + 2
            until t:byte(i) ~= 45 or t:byte(i + 1) ~= 62
            runs[#runs + 1] = k
            start = i
        else
            i = i + 1
        end
    end
    parts[#parts + 1] = t:sub(start)
    return parts, runs
end

function Beaf.parse(s, depth)
    if type(s) ~= "string" then
        return nil
    end
    local t = s
    if t:find("%s") ~= nil then
        t = (t:gsub("%s+", ""))
    end
    if t == "" then
        return nil
    end
    if t:find(ARROW_GLYPH, 1, true) ~= nil then
        t = (t:gsub(ARROW_GLYPH, "->"))
    end
    local raw
    local count = 0
    if t:sub(1, 1) == "{" then
        if t:sub(-1) ~= "}" then
            return NAN
        end
        raw = Hyper.splitArgs(t:sub(2, -2))
        if raw == nil then
            return NAN
        end
        count = #raw
    else
        local parts, runs = splitArrowChain(t)
        if #parts < 2 then
            return nil
        end
        if #parts == 2 then
            raw = { parts[1], parts[2], tostring(runs[1]) }
            count = 3
        else
            for i = 1, #runs do
                if runs[i] ~= 1 then
                    return NAN
                end
            end
            raw = parts
            count = #parts
        end
    end

    local entries = {}
    for i = 1, count do
        local tok = raw[i]
        if tok == "" then
            return NAN
        end
        local v = Impl.parseString(tok, (depth or 0) + 1)
        if v.kind == "nan" then
            return NAN
        end
        entries[i] = v
    end
    return Beaf.eval(entries)
end

-- Only a plain hyper expression at an integer level is exactly an array:
-- coefficients, powers and offsets have no array form.
function Beaf.toText(v)
    if v.kind ~= "hyper" or v.sign < 0 or v.p ~= 1 or v.coef ~= 1 or v.off ~= 0 then
        return nil
    end
    local level = v.level
    if level < 3 or level ~= numfloor(level) then
        return nil
    end
    if not Beaf.isEntryValue(v.base) or not Beaf.isEntryValue(v.arg) then
        return nil
    end
    local period = level - 2
    if period == 1 then
        return "{" .. Named.numberText(v.base.n) .. ", " .. Named.numberText(v.arg.n) .. "}"
    end
    return "{" .. Named.numberText(v.base.n) .. ", "
        .. Named.numberText(v.arg.n) .. ", " .. Named.numberText(period) .. "}"
end

function Beaf.isEntryValue(v)
    return v.kind == "finite" and v.n >= 0 and v.n == numfloor(v.n)
        and v.n < 1e15
end

-- Hyper-E ------------------------------------------------------------------
-- Hyper-E notation writes a × 10^b as "aEb", and a run of hyperions after it
-- repeats the E operator: "aEb#k" sits k-1 layers above a × 10^b, so "E100#2"
-- is a googolplex and "E100#100" is a grangol. A leading E with no left
-- argument means 1E, and a run of leading E's repeats it, which makes "ee100"
-- another spelling of "E100#2". Two or more hyperions lift the ladder by a
-- whole level each, so those runs are read as the hyper operation at level
-- h+3 over base 10 with the hyperion count as its argument; at that point the
-- head of the spelling no longer decides the size, which is how the notation
-- behaves once the iteration count itself is what grows.

HyperE = {}

-- Read the hyperion run that starts at `from` and return its last byte.
function HyperE.runEnd(t, from)
    local last = from
    local n = #t
    while last + 1 <= n and t:byte(last + 1) == 35 do
        last = last + 1
    end
    return last
end

function HyperE.eval(a, b, hyperions, count)
    if hyperions >= 2 then
        return Impl.hyperValue(hyperions + 3, TEN, count)
    end
    local base = Impl.powValues(TEN, b)
    if not (a.kind == "finite" and a.n == 1) then
        base = Impl.mulValues(a, base)
    end
    if hyperions == 0 then
        return base
    end
    return Impl.layerAdd(base, Impl.subValues(count, ONE))
end

function HyperE.parse(s, depth)
    if type(s) ~= "string" then
        return nil
    end
    local t = s
    if t:find("%s") ~= nil then
        t = (t:gsub("%s+", ""))
    end
    if t == "" then
        return nil
    end
    depth = depth or 0

    local head = t
    local hyperions = 0
    local countTok = nil
    local sep = t:find("#", 1, true)
    if sep ~= nil then
        local last = HyperE.runEnd(t, sep)
        head = t:sub(1, sep - 1)
        hyperions = last - sep + 1
        countTok = t:sub(last + 1)
        if countTok:find("#", 1, true) ~= nil then
            -- Two separate runs need the full extended-E recursion.
            return NAN
        end
    end

    local a, b
    local lead = head:byte(1)
    if lead == 69 or lead == 101 then
        local i = 1
        local reps = 0
        while i <= #head do
            local c = head:byte(i)
            if c ~= 69 and c ~= 101 then
                break
            end
            reps = reps + 1
            i = i + 1
        end
        local body = head:sub(i)
        local nextByte = body:byte(1)
        if body == "" or not HyperE.isOperandStart(nextByte) then
            return nil
        end
        b = Impl.parseString(body, depth + 1)
        if b.kind == "nan" then
            return NAN
        end
        a = ONE
        for _ = 1, reps - 1 do
            b = Impl.powValues(TEN, b)
        end
    else
        local mid
        for i = 1, #head do
            local c = head:byte(i)
            if c == 69 or c == 101 then
                mid = i
                break
            end
        end
        local bTok = mid == nil and "" or head:sub(mid + 1)
        if bTok == "" then
            return NAN
        end
        local aTok = head:sub(1, mid - 1)
        a = aTok == "" and ONE or Impl.parseString(aTok, depth + 1)
        b = Impl.parseString(bTok, depth + 1)
        if a.kind == "nan" or b.kind == "nan" then
            return NAN
        end
    end

    local count
    if hyperions == 0 then
        count = ONE
    elseif countTok == "" then
        count = Impl.finite(hyperions + 1)
    else
        count = Impl.parseString(countTok, depth + 1)
        if count.kind == "nan" then
            return NAN
        end
        if (count.kind == "finite" and count.n < 0) or Impl.signOf(count) < 0 then
            return NAN
        end
        if count.kind == "finite" and count.n ~= numfloor(count.n) then
            return NAN
        end
    end
    return HyperE.eval(a, b, hyperions, count)
end

-- A Hyper-E operand has to start with a digit, a sign or a decimal point;
-- anything else is an ordinary spelling that merely begins with "e".
function HyperE.isOperandStart(byte)
    if byte == nil then
        return false
    end
    return (byte >= 48 and byte <= 57) or byte == 46 or byte == 43 or byte == 45
end

-- Only the compact forms are exact here: a plain double, and a finite-rank
-- tower whose top the canonical form already keeps in [1, 10). Named, hyper,
-- cardinal and hierarchy values have no Hyper-E reading, so they fall back to
-- the default formatter.
function HyperE.toText(v)
    if v.kind == "finite" then
        local n = v.n
        if n < 1e15 then
            return n == 0 and "0" or nil
        end
        local exp = numfloor(math.log10(n))
        local mant = n / pow10(exp)
        if mant >= 10 then
            exp = exp + 1
            mant = mant / 10
        elseif mant < 1 then
            exp = exp - 1
            mant = mant * 10
        end
        if mant == 1 then
            return "E" .. Named.numberText(exp)
        end
        return Named.numberText(mant) .. "E" .. Named.numberText(exp)
    end
    if v.kind ~= "tower" or v.sign < 0 or not Rank.isFinite(v.rank) then
        return nil
    end
    local h = Rank.finiteValue(v.rank)
    if h < 1 or h ~= numfloor(h) or h > 1e15 then
        return nil
    end
    return "E" .. Named.numberText(v.m) .. "#" .. Named.numberText(h)
end

-- Named hyperoperation families -------------------------------------------
-- The -ote grid names the ordinal-indexed hyperoperations x{α}y. A family
-- code is the Cantor-normal-form digits of α read in descending ω-power
-- order, so h10 is level ω, h11 is ω+1, h21 is ω·2+1, h100 is ω², hww is ω^ω
-- and hepsl is ε₀. The ω-rows evaluate exactly: rule 3, x{λ}y = x{λ[y]}x,
-- turns a limit level into a finite one whose index is computable, so
-- aperiote(x, y) is x{y}x — the hyper operation at level y+2 — and
-- expande(x, 2) is aperiote(x, x). The recursion is run to its end and stops
-- at LIMIT as soon as a level or an operand leaves the double range, which is
-- why expande(10, 2) is H(12, 10, 10) while expande(10, 3) is LIMIT: the
-- second step needs a level drawn from a value, not from a double. Levels at
-- ω² and above are outside the (ω·a + b) rows, so those families return only
-- the collapses that hold at every level below ε₀: count 1 gives x, base 1
-- gives 1, and base 2 with an integer count of at least 2 gives 4.

Grid = {}

-- a = coefficient of ω, b = finite offset; both nil for the higher rows.
Grid.SPECS = {
    { name = "aperiote", short = "aper", code = "h10", a = 1, b = 0, level = "ω" },
    { name = "expande", short = "expa", code = "h11", a = 1, b = 1, level = "ω+1" },
    { name = "multiexpande", short = "muea", code = "h12", a = 1, b = 2, level = "ω+2" },
    { name = "powerexpande", short = "poea", code = "h13", a = 1, b = 3, level = "ω+3" },
    { name = "aperioexpande", short = "apea", code = "h20", a = 2, b = 0, level = "ω·2" },
    { name = "explode", short = "expl", code = "h21", a = 2, b = 1, level = "ω·2+1" },
    { name = "multiexplode", short = "muel", code = "h22", a = 2, b = 2, level = "ω·2+2" },
    { name = "aperioexplode", short = "apel", code = "h30", a = 3, b = 0, level = "ω·3" },
    { name = "detonate", short = "deto", code = "h31", a = 3, b = 1, level = "ω·3+1" },
    { name = "aperiodetonate", short = "apdt", code = "h40", a = 4, b = 0, level = "ω·4" },
    { name = "aperionate", short = "apeo", code = "h100", level = "ω²" },
    { name = "megote", short = "mego", code = "h101", level = "ω²+1" },
    { name = "multimegote", short = "mume", code = "h102", level = "ω²+2" },
    { name = "aperimegote", short = "apmg", code = "h110", level = "ω²+ω" },
    { name = "megoexpande", short = "mgea", code = "h111", level = "ω²+ω+1" },
    { name = "aperimegoexpande", short = "apme", code = "h120", level = "ω²+ω·2" },
    { name = "megoaperionate", short = "mgao", code = "h200", level = "ω²·2" },
    { name = "gigote", short = "gigo", code = "h201", level = "ω²·2+1" },
    { name = "aperigigote", short = "apgg", code = "h210", level = "ω²·2+ω" },
    { name = "gigoaperionate", short = "ggap", code = "h300", level = "ω²·3" },
    { name = "aperiatote", short = "apat", code = "h1000", level = "ω³" },
    { name = "powiainate", short = "pwan", code = "h1001", level = "ω³+1" },
    { name = "expandainate", short = "epan", code = "h1010", level = "ω³+ω" },
    { name = "megodainate", short = "mgan", code = "h1100", level = "ω³+ω²" },
    { name = "powiairate", short = "pwar", code = "h2000", level = "ω³·2" },
    { name = "aperioguate", short = "apgu", code = "h10000", level = "ω⁴" },
    { name = "iterate", short = "iter", code = "hww", level = "ω^ω" },
    { name = "itermult", short = "itmu", code = "hw01", level = "ω^ω+1" },
    { name = "cuboiter", short = "cube", code = "hwx2", level = "ω^ω·2" },
    { name = "expoiter", short = "expo", code = "hwa1", level = "ω^(ω+1)" },
    { name = "trioterate", short = "tria", code = "hwm2", level = "ω^(ω·2)" },
    { name = "trixxate", short = "trix", code = "hwp2", level = "ω^(ω²)" },
    { name = "aperixxate", short = "apix", code = "hwpw", level = "ω^(ω^ω)" },
    { name = "epsilonate", short = "epsl", code = "hepsl", level = "ε₀" },
}

Grid.BY_TOKEN = {}
for i = 1, #Grid.SPECS do
    local spec = Grid.SPECS[i]
    Grid.BY_TOKEN[spec.name] = spec
    Grid.BY_TOKEN[spec.short] = spec
    Grid.BY_TOKEN[spec.code] = spec
end

-- x{ω·a + b}y, unfolded by rules 2 and 3 until the level is finite.
function Grid.atLevel(a, b, x, y, frames)
    if frames[1] > 64 then
        return CAP
    end
    frames[1] = frames[1] + 1
    if y.kind == "finite" and y.n == 1 then
        return Impl.copy(x)
    end
    if b > 0 then
        local inner = Grid.atLevel(a, b, x, Impl.subValues(y, ONE), frames)
        if inner.kind == "nan" then
            return NAN
        end
        return Grid.atLevel(a, b - 1, x, inner, frames)
    end
    if a == 1 then
        -- Rule 3 at ω: x{ω}y = x{y}x, a finite level under the double ceiling.
        if y.kind ~= "finite" or y.n > 1e306 then
            return CAP
        end
        return Impl.hyperValue(y.n + 2, x, x)
    end
    -- (ω·a)[y] = ω·(a-1) + y, so the offset becomes the count y and the
    -- operand becomes the base.
    if y.kind ~= "finite" or y.n > 64 then
        return CAP
    end
    return Grid.atLevel(a - 1, y.n, x, x, frames)
end

function Grid.eval(spec, x, y)
    if x.kind == "nan" or y.kind == "nan" then
        return NAN
    end
    if x.kind == "cap" then
        return x.sign < 0 and NAN or CAP
    end
    if Impl.isZero(x) then
        return ZERO
    end
    if x.kind == "finite" and x.n == 1 then
        return ONE
    end
    if y.kind ~= "finite" then
        if y.kind == "cap" and y.sign > 0 then
            return CAP
        end
        return NAN
    end
    if y.n < 1 or y.n ~= numfloor(y.n) then
        return NAN
    end
    if y.n == 1 then
        return Impl.copy(x)
    end
    if spec.a == nil then
        -- Outside the ω-rows only the exact collapses are values.
        if x.kind == "finite" and x.n == 2 then
            return Impl.finite(4)
        end
        return CAP
    end
    return Grid.atLevel(spec.a, spec.b, x, y, { 0 })
end

-- "expande(10,2)", "h11(10,2)", "epsl(3,2)" and every other registry token.
function Grid.parse(s, depth)
    local tok = s:match("^([%a%d_]+)%(")
    if tok == nil then
        return nil
    end
    local spec = Grid.BY_TOKEN[tok:lower()]
    if spec == nil then
        return nil
    end
    local inner = s:match("^[%a%d_]+%((.*)%)$")
    if inner == nil then
        return NAN
    end
    local parts = Hyper.splitArgs(inner)
    if parts == nil or #parts ~= 2 then
        return NAN
    end
    local x = Impl.parseString(parts[1], (depth or 0) + 1)
    local y = Impl.parseString(parts[2], (depth or 0) + 1)
    return Grid.eval(spec, x, y)
end

function Impl.rankHandleOf(v)
    if v.kind == "fgh" then
        local ord = v.idx.cls == "ord"
        if v.mode == "hardy" then
            -- H_alpha never outruns f_alpha, so at one handle the hierarchy
            -- value keeps its rank and the Hardy value sits below it.
            return ord and v.idx.rank or Rank.TOP, ord and 1 or 3
        end
        return ord and v.idx.rank or Rank.TOP, ord and 2 or 4
    end
    return v.rank, 0
end

-- Tier 3 holds infinite-rank towers and formal hierarchy values together.
-- A tower and an f value with the same rank handle order by that handle, and
-- the hierarchy value wins the tie: f_alpha closes over the tower ladder at
-- alpha instead of sitting inside it. The handle flag carries that order, with
-- a Hardy value at the same index below the f value it is bounded by.
function Impl.cmpTier3Positive(a, b)
    local ra, fa = Impl.rankHandleOf(a)
    local rb, fb = Impl.rankHandleOf(b)
    local rc = Rank.compare(ra, rb)
    if rc ~= 0 then
        return rc
    end
    if fa ~= fb then
        return fa < fb and -1 or 1
    end
    if a.kind == "tower" then
        if a.m == b.m then
            return 0
        end
        return a.m < b.m and -1 or 1
    end
    return Fgh.comparePositive(a, b)
end

function Impl.tierOf(v)
    if v.kind == "hyper" then
        return Hyper.anchorOf(v) ~= nil and 2 or 1.5
    elseif v.kind == "named" then
        return 2
    elseif v.kind == "fgh" then
        return 3
    elseif v.kind == "card" then
        return 4
    elseif v.kind == "cap" then
        return 5
    elseif v.kind == "tower" and not Rank.isFinite(v.rank) then
        return 3
    end
    return 1
end

-- Order inside the named band. Plain named values are their own anchor;
-- an anchored hyper value ranks above an equal anchor, and anchors are
-- compared before the hyper structure.
function Impl.compareBand2Positive(a, b)
    local aa = a.kind == "named" and a or Hyper.anchorOf(a)
    local ab = b.kind == "named" and b or Hyper.anchorOf(b)
    if aa == nil then
        return ab == nil and 0 or -1
    elseif ab == nil then
        return 1
    end
    local c = Named.compareBase(aa, ab)
    if c ~= 0 then
        return c
    end
    if a.kind == "named" and b.kind == "named" then
        return Named.compareMag(a, b)
    elseif a.kind == "hyper" and b.kind == "hyper" then
        return Hyper.compareMag(a, b)
    end
    if a.kind == "hyper" then
        return Impl.compareHyperNamed(a, b)
    end
    return -Impl.compareHyperNamed(b, a)
end

-- Compare an anchored H(level, base, arg) with a named value of the same
-- constant. H(3, B, k) is B^k, so it is a fixed power of B and compares by
-- exponent; a constant inside the argument (B^B, 2^B, B^^B) or any level
-- above 3 outgrows every fixed power of B.
function Impl.compareHyperNamed(h, n)
    if h.arg.kind == "finite" then
        if h.arg.n == 0 then
            return -1
        elseif h.arg.n == 1 then
            return Impl.compare(h.base, n)
        end
    end
    if h.level > 3 then
        return 1
    end
    if h.base.kind == "finite" then
        return h.base.n >= 1 and 1 or -1
    end
    if h.base.kind == "named" and Named.compareBase(h.base, n) == 0 then
        if h.arg.kind ~= "finite" then
            return 1
        end
        local e = h.base.p * h.arg.n
        local ep = n.p
        -- Logs avoid overflow when p or the count is huge.
        local le = e > 0 and (math.log(h.base.p) + math.log(h.arg.n)) or -math.huge
        local ln = math.log(ep)
        if le ~= ln then
            return le < ln and -1 or 1
        end
        local lc = math.log(h.coef) + h.arg.n * math.log(h.base.coef)
        local lnc = math.log(n.coef)
        if lc ~= lnc then
            return lc < lnc and -1 or 1
        end
        if h.off ~= n.off then
            return h.off < n.off and -1 or 1
        end
        return 0
    end
    return 1
end

function Impl.cmpPositive(a, b)
    local ta = Impl.tierOf(a)
    local tb = Impl.tierOf(b)
    if ta ~= tb then
        return ta < tb and -1 or 1
    end
    if ta == 1.5 then
        return Hyper.compareMag(a, b)
    end
    if ta == 2 then
        return Impl.compareBand2Positive(a, b)
    end
    if ta == 3 then
        return Impl.cmpTier3Positive(a, b)
    end
    if ta == 4 then
        return Card.compareDefinite(a, b)
    end
    local af = a.kind == "finite"
    local bf = b.kind == "finite"
    if af and bf then
        if a.n == b.n then
            return 0
        end
        return a.n < b.n and -1 or 1
    elseif af then
        return -1
    elseif bf then
        return 1
    end
    local rc = Rank.compare(a.rank, b.rank)
    if rc ~= 0 then
        return rc
    end
    if a.m == b.m then
        return 0
    end
    return a.m < b.m and -1 or 1
end

function Impl.compare(a, b)
    if a.kind == "nan" or b.kind == "nan" then
        return nil
    end
    if a.kind == "finite" and b.kind == "finite" then
        if a.n == b.n then
            return 0
        end
        return a.n < b.n and -1 or 1
    end
    if a.kind == "cap" or b.kind == "cap" then
        local ca = a.kind == "cap"
        local cb = b.kind == "cap"
        if ca and cb then
            if a.sign == b.sign then
                return 0
            end
            return a.sign > b.sign and 1 or -1
        elseif ca then
            return a.sign
        end
        return -b.sign
    end
    local sa = Impl.signOf(a)
    local sb = Impl.signOf(b)
    if sa == 0 and sb == 0 then
        return 0
    elseif sa == 0 then
        return sb > 0 and -1 or 1
    elseif sb == 0 then
        return sa > 0 and 1 or -1
    end
    if sa ~= sb then
        return sa > sb and 1 or -1
    end
    -- Same-sign fast paths avoid allocating magnitude copies. Ordered by
    -- kind so the common same-family comparisons stay allocation-free.
    local ka = a.kind
    local kb = b.kind
    if ka == "card" or kb == "card" then
        local mag
        if ka == "card" and kb == "card" then
            mag = Card.compareMag(a, b)
        else
            -- A cardinal is an infinite ordinal and every other value this
            -- library holds models a finite integer, so the cardinal wins.
            mag = ka == "card" and 1 or -1
        end
        if mag == nil then
            return nil
        end
        return sa < 0 and -mag or mag
    end
    if ka == "fgh" or kb == "fgh" then
        -- The hierarchy compare reads the level index and the argument only,
        -- never the outer sign, so the signs resolved above are enough.
        local mag = Impl.cmpPositive(a, b)
        return sa < 0 and -mag or mag
    end
    if ka == "named" then
        if kb == "named" then
            local mag = Named.compareMag(a, b)
            return sa < 0 and -mag or mag
        elseif kb == "tower" then
            local order = Rank.isFinite(b.rank) and 1 or -1
            return sa < 0 and -order or order
        elseif kb == "hyper" then
            local mag = Impl.compareBand2Positive(a, b)
            return sa < 0 and -mag or mag
        end
        return sa
    elseif kb == "named" then
        if ka == "tower" then
            local order = Rank.isFinite(a.rank) and -1 or 1
            return sa < 0 and -order or order
        elseif ka == "hyper" then
            local mag = Impl.compareBand2Positive(a, b)
            return sa < 0 and -mag or mag
        end
        return -sa
    end
    if ka == "tower" and kb == "tower" then
        local rc = Rank.compare(a.rank, b.rank)
        if rc == 0 then
            if a.m == b.m then
                return 0
            end
            rc = a.m < b.m and -1 or 1
        end
        return sa < 0 and -rc or rc
    end
    if ka == "hyper" then
        if kb == "hyper" then
            local mag = Hyper.compareMag(a, b)
            return sa < 0 and -mag or mag
        elseif kb == "tower" then
            local order = Rank.isFinite(b.rank) and 1 or -1
            return sa < 0 and -order or order
        end
        return sa
    elseif kb == "hyper" then
        if ka == "tower" then
            local order = Rank.isFinite(a.rank) and -1 or 1
            return sa < 0 and -order or order
        end
        return -sa
    end
    local mag = Impl.cmpPositive(Impl.magnitude(a), Impl.magnitude(b))
    if sa < 0 then
        mag = -mag
    end
    return mag
end

-- Values never change after construction, so an already-positive operand is
-- its own magnitude. Returning it avoids a copy in every compare, add and min
-- -max path that asks for magnitudes of positive inputs.
function Impl.magnitude(v)
    if v.kind == "finite" then
        if v.n > 0 then
            return v
        elseif v.n == 0 then
            return ZERO
        end
        return Impl.finite(-v.n)
    end
    if v.kind == "nan" then
        return v
    end
    if v.sign > 0 then
        return v
    end
    if v.kind == "tower" then
        return setmetatable({
            kind = "tower",
            sign = 1,
            rank = v.rank,
            m = v.m,
        }, ZubaNum)
    end
    if v.kind == "named" then
        return Named.withSign(v, 1)
    elseif v.kind == "hyper" then
        return Hyper.withSign(v, 1)
    elseif v.kind == "card" then
        return Card.withSign(v, 1)
    elseif v.kind == "fgh" then
        return Fgh.withSign(v, 1)
    elseif v.kind == "cap" then
        return CAP
    end
    return v
end

function Impl.maxPositive(a, b)
    if Impl.cmpPositive(a, b) >= 0 then
        return a
    end
    return b
end

ZERO = setmetatable({ kind = "finite", n = 0 }, ZubaNum)
ONE = setmetatable({ kind = "finite", n = 1 }, ZubaNum)
TEN = setmetatable({ kind = "finite", n = 10 }, ZubaNum)
NAN = setmetatable({ kind = "nan" }, ZubaNum)
CAP = setmetatable({ kind = "cap", sign = 1 }, ZubaNum)
MAX_TOWER = setmetatable({
    kind = "tower",
    sign = 1,
    rank = Rank.TOP,
    m = 9.999999999,
}, ZubaNum)
NEG_MAX_TOWER = setmetatable({
    kind = "tower",
    sign = -1,
    rank = Rank.TOP,
    m = 9.999999999,
}, ZubaNum)
NEG_CAP = setmetatable({ kind = "cap", sign = -1 }, ZubaNum)
GRAHAM = Named.new("GRAHAM", nil, 1, 1, 1, 0)
TREE3 = Named.new("TREE", 3, 1, 1, 1, 0)
TREE4 = Named.new("TREE", 4, 1, 1, 1, 0)
SSCG2 = Impl.fromLog10Value(Impl.finite(SSCG2_LOG10))
SSCG3 = Named.new("SSCG", 3, 1, 1, 1, 0)
SSCG4 = Named.new("SSCG", 4, 1, 1, 1, 0)
LOADER = Named.new("LOADER", 5, 1, 1, 1, 0)
BB5 = Impl.finite(4098)
BB6 = Named.new("BB", 6, 1, 1, 1, 0)
RAYO = Named.new("RAYO", RAYO_INDEX, 1, 1, 1, 0)
FISH7 = Named.new("FISH7", 7, 1, 1, 1, 0)
ALEPH0 = Card.plain("aleph", Idx.fin(ZERO), 1)
ALEPH1 = Card.plain("aleph", Idx.fin(ONE), 1)
ALEPH2 = Card.plain("aleph", Idx.fin(Impl.finite(2)), 1)
ALEPH3 = Card.plain("aleph", Idx.fin(Impl.finite(3)), 1)
ALEPH_OMEGA = Card.plain("aleph", Idx.ord(Rank.OMEGA), 1)
BETH0 = Card.plain("beth", Idx.fin(ZERO), 1)
BETH1 = Card.plain("beth", Idx.ord(Rank.addFinite(Rank.ZERO, 1)), 1)
ALEPH_FP1 = Card.fixed("aleph", Idx.fin(ONE), 1)

-- Family indices also accept ordinal spellings, and asValue("omega") is NaN
-- while TREE(ω) is a legal formal value, so the raw argument is resolved here.
-- Finite ranks stay on the value path: TREE("1") must remain Friedman's 1.
function Impl.indexSource(n)
    if type(n) == "string" or (type(n) == "table" and not Impl.isZuba(n)) then
        local r = Impl.rankFromAny(n)
        if r ~= nil and not Rank.isFinite(r) then
            return Idx.ord(r)
        end
    end
    return Impl.asValue(n)
end

-- A non-double index keeps the value formal: TREE(TREE(3)) and TREE(ω) are
-- named values inside the TREE band, ordered by their index.
function Impl.treeValue(n)
    if n.kind ~= "finite" then
        return Named.new("TREE", n, 1, 1, 1, 0)
    end
    local idx = n.n
    if idx ~= idx or idx ~= math.floor(idx) or idx < 1 then
        return NAN
    end
    if idx == 1 then
        return ONE
    elseif idx == 2 then
        -- Friedman's values: TREE(1) = 1, TREE(2) = 3, TREE(3) is the huge one.
        return Impl.finite(3)
    end
    return Named.new("TREE", idx, 1, 1, 1, 0)
end

function Impl.sscgValue(n)
    if n.kind ~= "finite" then
        return Named.new("SSCG", n, 1, 1, 1, 0)
    end
    local idx = n.n
    if idx ~= idx or idx ~= math.floor(idx) or idx < 0 then
        return NAN
    end
    if idx == 0 then
        return Impl.finite(2)
    elseif idx == 1 then
        return Impl.finite(5)
    elseif idx == 2 then
        return Impl.copy(SSCG2)
    end
    return Named.new("SSCG", idx, 1, 1, 1, 0)
end

function Impl.loaderValue(n)
    if n.kind ~= "finite" then
        return Named.new("LOADER", n, 1, 1, 1, 0)
    end
    local idx = n.n
    if idx ~= idx or idx ~= math.floor(idx) or idx < 0 then
        return NAN
    end
    if idx == 0 then
        return Impl.finite(99)
    end
    return Named.new("LOADER", idx, 1, 1, 1, 0)
end

function Impl.bbValue(n)
    if n.kind ~= "finite" then
        return Named.new("BB", n, 1, 1, 1, 0)
    end
    local idx = n.n
    if idx ~= idx or idx ~= math.floor(idx) or idx < 0 then
        return NAN
    end
    if idx == 0 then
        return ZERO
    elseif idx == 1 then
        return ONE
    elseif idx == 2 then
        return Impl.finite(4)
    elseif idx == 3 then
        return Impl.finite(6)
    elseif idx == 4 then
        return Impl.finite(13)
    elseif idx == 5 then
        return BB5
    end
    return Named.new("BB", idx, 1, 1, 1, 0)
end

-- Rayo(n) is the smallest number above everything nameable in first-order
-- set theory with at most n symbols; Rayo's number is Rayo(10^100). Indices
-- below the googol-symbol anchor are not guaranteed to be mega-scale, so the
-- named band starts at RAYO_INDEX instead of mis-ranking small Rayo values.
function Impl.rayoValue(n)
    if n.kind ~= "finite" then
        return Named.new("RAYO", n, 1, 1, 1, 0)
    end
    local idx = n.n
    if idx ~= idx or idx ~= math.floor(idx) or idx < RAYO_INDEX then
        return NAN
    end
    if idx == RAYO_INDEX then
        return Impl.copy(RAYO)
    end
    return Named.new("RAYO", idx, 1, 1, 1, 0)
end

-- Fish numbers 1-6 sit below Rayo's number and their place among TREE,
-- LOADER and BB is not established here, so only Fish number 7 is modeled.
function Impl.fishValue(n)
    if n.kind ~= "finite" then
        return NAN
    end
    if n.n ~= 7 then
        return NAN
    end
    return Impl.copy(FISH7)
end

local TWO = Impl.finite(2)
local THREE = Impl.finite(3)
local ACK_HEAD = { ack = true, ackermann = true }

-- A(0,n) = n+1 and A(m,n) = H_m(2, n+3) - 3 for m >= 1, so the whole Ackermann
-- ladder rides the existing hyperoperation model instead of adding a kind of
-- its own. Small levels come out exact (A(4,1) = 65533); a level past the
-- exact window stays a formal H value, so the function never saturates.
function Impl.ackermannValue(m, n)
    local mv = Impl.asValue(m)
    if mv.kind ~= "finite" then
        return NAN
    end
    local mi = mv.n
    if not isfinite(mi) or mi ~= math.floor(mi) or mi < 0 then
        return NAN
    end
    local nv = Impl.asValue(n)
    if nv.kind == "nan" or Impl.signOf(nv) < 0 then
        return NAN
    end
    if mi == 0 then
        return Impl.addValues(nv, ONE)
    end
    local h = Impl.hyperValue(mi, TWO, Impl.addValues(nv, THREE))
    if h.kind == "nan" then
        return NAN
    end
    return Impl.subValues(h, THREE)
end

function Impl.parseAck(s, depth)
    local t = (s:lower():gsub("%s+", ""))
    local head, inner = Named.splitCall(t)
    if head == nil or inner == "" or not ACK_HEAD[head] then
        return nil
    end
    local parts = Hyper.splitArgs(inner)
    if parts == nil or #parts ~= 2 then
        return nil
    end
    local d = (depth or 0) + 1
    return Impl.ackermannValue(Impl.parseString(parts[1], d),
        Impl.parseString(parts[2], d))
end

-- Arithmetic ---------------------------------------------------------------

function Impl.signedMagnitude(sign, mag)
    if sign > 0 then
        return mag
    end
    if Impl.isZero(mag) then
        return ZERO
    end
    if mag.kind == "cap" then
        return sign > 0 and CAP or NEG_CAP
    elseif mag.kind == "named" then
        return Named.withSign(mag, sign)
    end
    return Impl.negate(mag)
end

function Impl.magAdd(a, b)
    local la = Impl.log10Value(a)
    local lb = Impl.log10Value(b)
    if la.kind == "finite" and lb.kind == "finite" then
        local hi = math.max(la.n, lb.n)
        local lo = math.min(la.n, lb.n)
        local s
        if hi - lo > 16 then
            s = hi
        else
            s = hi + log10(1 + pow10(lo - hi))
        end
        return Impl.fromLog10Value(Impl.finite(s))
    end
    return Impl.maxPositive(a, b)
end

function Impl.magSub(a, b)
    if Impl.cmpPositive(a, b) == 0 then
        return ZERO
    end
    if a.kind == "finite" and b.kind == "finite" then
        local v = a.n - b.n
        if v > 0 and isfinite(v) then
            return Impl.finite(v)
        end
    end
    local la = Impl.log10Value(a)
    local lb = Impl.log10Value(b)
    if la.kind == "finite" and lb.kind == "finite" then
        local diff = lb.n - la.n
        if diff > 0 then
            return ZERO
        end
        local ratio = pow10(diff)
        if ratio >= 1 then
            return ZERO
        end
        local s = la.n + log10(1 - ratio)
        if s == -math.huge then
            return ZERO
        end
        return Impl.fromLog10Value(Impl.finite(s))
    end
    return a
end

function Impl.magMul(a, b)
    if Impl.isZero(a) or Impl.isZero(b) then
        return ZERO
    end
    if Impl.tierOf(a) >= 3 or Impl.tierOf(b) >= 3 then
        -- Above the finite bands a product is the larger factor; this keeps
        -- hierarchy values ordered by tier instead of falling through the
        -- logarithm, which has no answer for them.
        return Impl.maxPositive(a, b)
    end
    local af = a.kind == "finite"
    local bf = b.kind == "finite"
    if af and bf then
        local p = a.n * b.n
        if isfinite(p) then
            return Impl.finite(p)
        end
        local s = log10(a.n) + log10(b.n)
        return Impl.fromLog10Value(Impl.finite(s))
    end

    if af or bf then
        local f = af and a or b
        local t = af and b or a
        if f.n == 1 then
            return t
        end
        local lt = Impl.log10Value(t)
        local lf = log10(f.n)
        if lt.kind == "tower" then
            return t
        end
        local s = lt.n + lf
        return Impl.fromLog10Value(Impl.finite(s))
    end

    local la = Impl.log10Value(a)
    local lb = Impl.log10Value(b)
    if la.kind == "finite" and lb.kind == "finite" then
        return Impl.fromLog10Value(Impl.finite(la.n + lb.n))
    end
    if la.kind == "tower" and lb.kind == "tower" then
        return Impl.maxPositive(a, b)
    elseif la.kind == "tower" then
        return a
    end
    return b
end

function Impl.magDiv(a, b)
    if Impl.isZero(b) then
        return NAN
    end
    if Impl.isZero(a) then
        return ZERO
    end
    if Impl.tierOf(a) >= 3 or Impl.tierOf(b) >= 3 then
        local c = Impl.cmpPositive(a, b)
        if c == 0 then
            return ONE
        elseif c > 0 then
            return a
        end
        return ZERO
    end
    local af = a.kind == "finite"
    local bf = b.kind == "finite"
    if af and bf then
        local q = a.n / b.n
        if isfinite(q) and q > 0 then
            return Impl.finite(q)
        end
        return Impl.fromLog10Value(Impl.finite(log10(a.n) - log10(b.n)))
    end

    local la = Impl.log10Value(a)
    local lb = Impl.log10Value(b)
    if la.kind == "finite" and lb.kind == "finite" then
        return Impl.fromLog10Value(Impl.finite(la.n - lb.n))
    elseif la.kind == "tower" and lb.kind == "tower" then
        local cmp = Impl.cmpPositive(la, lb)
        if cmp == 0 then
            return ONE
        elseif cmp > 0 then
            -- The ratio is beyond tower precision; returning the larger
            -- operand keeps ordering monotone instead of collapsing to 1.
            return a
        end
        return ZERO
    elseif la.kind == "tower" then
        return a
    end
    return ZERO
end

function Impl.addValues(a, b)
    if a.kind == "nan" or b.kind == "nan" then
        return NAN
    end
    if a.kind == "finite" and b.kind == "finite" then
        local s = a.n + b.n
        if isfinite(s) then
            return Impl.finite(s)
        end
    end
    if a.kind == "cap" or b.kind == "cap" then
        local ca = a.kind == "cap"
        local cb = b.kind == "cap"
        if ca and cb then
            if a.sign == b.sign then
                return a.sign > 0 and CAP or NEG_CAP
            end
            -- Formal bound: LIMIT - LIMIT is zero by convention.
            return ZERO
        end
        local c = ca and a or b
        return c.sign > 0 and CAP or NEG_CAP
    end
    local sa = Impl.signOf(a)
    local sb = Impl.signOf(b)
    if sa == 0 then
        return Impl.copy(b)
    elseif sb == 0 then
        return Impl.copy(a)
    end
    if a.kind == "card" or b.kind == "card" then
        return Card.addValues(a, b)
    end
    local an = a.kind == "named"
    local bn = b.kind == "named"
    if an or bn then
        if an and bn then
            return Named.addValues(a, b)
        end
        local nv = an and a or b
        local other = an and b or a
        if other.kind == "tower" and not Rank.isFinite(other.rank) then
            return Impl.copy(other)
        elseif other.kind == "finite" then
            return Named.addFinite(nv, other.n)
        elseif other.kind == "hyper" then
            -- Named plus a band value: the larger magnitude dominates at
            -- tier resolution, so TREE3 + H(100, TREE3, 2) keeps the hyper.
            local cmp = Impl.compareBand2Positive(nv, other)
            if cmp == 0 then
                return ZERO
            end
            return Impl.copy(cmp > 0 and nv or other)
        end
        return Impl.copy(nv)
    end
    local ah = a.kind == "hyper"
    local bh = b.kind == "hyper"
    if ah or bh then
        if ah and bh then
            return Hyper.addValues(a, b)
        end
        local hv = ah and a or b
        local other = ah and b or a
        if other.kind == "tower" and not Rank.isFinite(other.rank) then
            return Impl.copy(other)
        elseif other.kind == "finite" then
            return Hyper.addFinite(hv, other.n)
        end
        return Impl.copy(hv)
    end
    if a.kind == "tower" and b.kind == "tower" then
        -- Two towers combine by absorbing the smaller one unless both are
        -- rank-2, where a factor of two can still move the mantissa. This
        -- skips magnitude copies and two log/parts round trips.
        local fa = Rank.isFinite(a.rank)
        local fb = Rank.isFinite(b.rank)
        local tight = fa and fb and Rank.finiteValue(a.rank) <= 2
            and Rank.finiteValue(b.rank) <= 2
        if not tight then
            local rc = Rank.compare(a.rank, b.rank)
            if rc == 0 then
                if a.m == b.m then
                    return sa == sb and Impl.copy(a) or ZERO
                end
                rc = a.m < b.m and -1 or 1
            end
            return Impl.copy(rc > 0 and a or b)
        end
    end
    local ma = Impl.magnitude(a)
    local mb = Impl.magnitude(b)
    if sa == sb then
        return Impl.signedMagnitude(sa, Impl.magAdd(ma, mb))
    end
    local cmp = Impl.cmpPositive(ma, mb)
    if cmp == 0 then
        return ZERO
    elseif cmp > 0 then
        return Impl.signedMagnitude(sa, Impl.magSub(ma, mb))
    end
    return Impl.signedMagnitude(sb, Impl.magSub(mb, ma))
end

function Impl.subValues(a, b)
    if a.kind == "nan" or b.kind == "nan" then
        return NAN
    end
    if a.kind == "finite" and b.kind == "finite" then
        local d = a.n - b.n
        if isfinite(d) then
            return Impl.finite(d)
        end
    end
    return Impl.addValues(a, Impl.negate(b))
end

function Impl.mulValues(a, b)
    if a.kind == "nan" or b.kind == "nan" then
        return NAN
    end
    if a.kind == "finite" and b.kind == "finite" then
        local p = a.n * b.n
        if isfinite(p) then
            return Impl.finite(p)
        end
    end
    local sa = Impl.signOf(a)
    local sb = Impl.signOf(b)
    if sa == 0 or sb == 0 then
        return ZERO
    end
    if a.kind == "cap" or b.kind == "cap" then
        local sign = sa * sb
        return sign > 0 and CAP or NEG_CAP
    end
    if a.kind == "card" or b.kind == "card" then
        return Card.mulValues(a, b)
    end
    local an = a.kind == "named"
    local bn = b.kind == "named"
    if an or bn then
        if an and bn then
            return Named.mul(a, b)
        end
        local nv = an and a or b
        local other = an and b or a
        if other.kind == "tower" and not Rank.isFinite(other.rank) then
            return Impl.signedMagnitude(sa * sb, Impl.magnitude(other))
        elseif other.kind == "finite" then
            return Named.mulFinite(nv, other.n)
        elseif other.kind == "hyper" then
            -- Products stay in the band of the larger factor; the smaller
            -- factor is below the band's resolution.
            local big = Impl.compareBand2Positive(nv, other) >= 0 and nv or other
            return Impl.signedMagnitude(sa * sb, Impl.magnitude(big))
        end
        return Named.withSign(nv, sa * sb)
    end
    local ah = a.kind == "hyper"
    local bh = b.kind == "hyper"
    if ah or bh then
        if ah and bh then
            return Hyper.mul(a, b)
        end
        local hv = ah and a or b
        local other = ah and b or a
        if other.kind == "finite" then
            return Hyper.mulFinite(hv, other.n)
        elseif other.kind == "tower" then
            return Impl.signedMagnitude(sa * sb, Impl.magnitude(other))
        end
        return Hyper.withSign(hv, sa * sb)
    end
    local mag = Impl.magMul(Impl.magnitude(a), Impl.magnitude(b))
    return Impl.signedMagnitude(sa * sb, mag)
end

function Impl.divValues(a, b)
    if a.kind == "nan" or b.kind == "nan" then
        return NAN
    end
    if b.kind == "finite" and b.n == 0 then
        return NAN
    end
    if a.kind == "finite" and b.kind == "finite" then
        local q = a.n / b.n
        if isfinite(q) then
            return Impl.finite(q)
        end
    end
    if a.kind == "cap" and b.kind == "cap" then
        return ONE
    elseif a.kind == "cap" then
        local sign = Impl.signOf(a) * Impl.signOf(b)
        return sign > 0 and CAP or NEG_CAP
    elseif b.kind == "cap" then
        return ZERO
    end
    local sa = Impl.signOf(a)
    local sb = Impl.signOf(b)
    if sa == 0 then
        return ZERO
    end
    if a.kind == "card" or b.kind == "card" then
        return Card.divValues(a, b)
    end
    if a.kind == "fgh" or b.kind == "fgh" then
        -- A formal hierarchy value has no logarithm, so the ratio follows the
        -- comparison: equal levels give 1, the larger operand absorbs the
        -- division and the smaller side collapses to zero.
        local c = Impl.cmpPositive(Impl.magnitude(a), Impl.magnitude(b))
        if c == 0 then
            return ONE
        elseif c > 0 then
            return Impl.signedMagnitude(sa * sb, Impl.magnitude(a))
        end
        return ZERO
    end
    local ah = a.kind == "hyper"
    local bh = b.kind == "hyper"
    if ah or bh then
        if ah and bh then
            return Hyper.div(a, b)
        elseif ah then
            if b.kind == "finite" then
                return Hyper.mulFinite(a, 1 / b.n)
            elseif b.kind == "tower" and Rank.isFinite(b.rank) then
                return Impl.copy(a)
            elseif b.kind == "named" then
                local cmp = Impl.compareBand2Positive(a, b)
                if cmp > 0 then
                    return Impl.signedMagnitude(sa * sb, Impl.magnitude(a))
                end
            end
            return ZERO
        end
        if a.kind == "named" then
            local cmp = Impl.compareBand2Positive(a, b)
            if cmp > 0 then
                return Impl.signedMagnitude(sa * sb, Impl.magnitude(a))
            end
            return ZERO
        elseif a.kind == "tower" and not Rank.isFinite(a.rank) then
            return Impl.signedMagnitude(sa * sb, Impl.magnitude(a))
        end
        return ZERO
    end
    local an = a.kind == "named"
    local bn = b.kind == "named"
    if an or bn then
        if an and bn then
            return Named.div(a, b)
        end
        if an then
            if b.kind == "finite" then
                return Named.mulFinite(a, 1 / b.n)
            elseif b.kind == "tower" and not Rank.isFinite(b.rank) then
                return ZERO
            end
            return Impl.copy(a)
        end
        if a.kind == "finite" or Rank.isFinite(a.rank) then
            -- A finite value divided by a named-mega value is far below the
            -- smallest double this library can represent.
            return ZERO
        end
        return Impl.signedMagnitude(sa * sb, Impl.magnitude(a))
    end
    local mag = Impl.magDiv(Impl.magnitude(a), Impl.magnitude(b))
    return Impl.signedMagnitude(sa * sb, mag)
end

function Impl.magPow(a, b)
    local la = Impl.log10Value(a)
    if la.kind == "nan" then
        return NAN
    elseif Impl.isZero(la) then
        return ONE
    end
    local p = Impl.mulValues(la, b)
    return Impl.fromLog10Value(p)
end

function Impl.powValues(a, b)
    if a.kind == "nan" or b.kind == "nan" then
        return NAN
    end
    local sb = Impl.signOf(b)
    if sb == 0 then
        return ONE
    end
    local sa = Impl.signOf(a)
    if sa == 0 then
        if sb > 0 then
            return ZERO
        end
        return NAN
    end
    if b.kind == "cap" then
        if a.kind == "finite" then
            if a.n == 1 then
                return ONE
            elseif a.n == -1 then
                return NAN
            elseif math.abs(a.n) < 1 then
                return ZERO
            elseif a.n < 0 then
                return NAN
            end
        end
        return CAP
    end
    if a.kind == "cap" then
        if sb < 0 then
            return ZERO
        end
        if a.sign < 0 then
            if b.kind ~= "finite" or b.n ~= math.floor(b.n) then
                return NAN
            end
            return math.abs(b.n) % 2 == 1 and NEG_CAP or CAP
        end
        return CAP
    end
    if a.kind == "card" or b.kind == "card" then
        local v = Card.powValues(a, b)
        if v ~= nil then
            return v
        end
    end

    if a.kind == "finite" and b.kind == "finite" then
        local v = a.n ^ b.n
        if isfinite(v) then
            return Impl.finite(v)
        end
        if a.n < 0 and b.n ~= math.floor(b.n) then
            return NAN
        end
    end

    if sb < 0 then
        return Impl.divValues(ONE, Impl.powValues(a, Impl.negate(b)))
    end

    if b.kind == "tower" and not Rank.isFinite(b.rank)
        and (a.kind == "named" or a.kind == "hyper") then
        -- A finite megascale base to a transfinite exponent stays a tower.
        if sa < 0 then
            return NAN
        end
        return Impl.fromLog10Value(Impl.copy(b))
    end

    if a.kind == "hyper" or b.kind == "hyper" then
        if a.kind == "hyper" and b.kind == "finite" then
            local mag = Hyper.pow(Impl.magnitude(a), b.n)
            if sa < 0 then
                if b.n ~= math.floor(b.n) then
                    return NAN
                end
                local odd = math.abs(b.n) % 2 == 1
                return Impl.signedMagnitude(odd and -1 or 1, mag)
            end
            return mag
        end
        if a.kind == "finite" then
            if a.n == 1 then
                return ONE
            elseif a.n == -1 then
                return NAN
            elseif math.abs(a.n) < 1 then
                return ZERO
            end
        end
        if sa < 0 then
            -- The parity of a non-finite exponent is not representable here.
            return NAN
        end
        -- A non-finite exponent makes a finite base impossible to double-
        -- expand, so keep the power as an anchored expression.
        if Hyper.eligible(a) and Hyper.eligible(b) then
            return Hyper.new(3, a, b)
        end
        return CAP
    end

    if a.kind == "named" then
        if b.kind == "named"
            or (b.kind == "tower" and Rank.isFinite(b.rank)) then
            if sa < 0 then
                return NAN
            end
            if Hyper.eligible(a) and Hyper.eligible(b) then
                return Hyper.new(3, a, b)
            end
            return CAP
        end
        if b.kind ~= "finite" then
            return CAP
        end
        local mag = Named.pow(Impl.magnitude(a), b.n)
        if sa < 0 then
            if b.n ~= math.floor(b.n) then
                return NAN
            end
            local odd = math.abs(b.n) % 2 == 1
            return Impl.signedMagnitude(odd and -1 or 1, mag)
        end
        return mag
    end

    if b.kind == "named" then
        if a.kind == "finite" then
            if a.n == 1 then
                return ONE
            elseif a.n == -1 then
                return NAN
            elseif math.abs(a.n) < 1 then
                return ZERO
            elseif a.n < 0 then
                return NAN
            end
        elseif sa < 0 then
            return NAN
        end
        if Hyper.eligible(a) and Hyper.eligible(b) then
            return Hyper.new(3, a, b)
        end
        if a.kind == "tower" then
            -- An infinite tower to a finite mega exponent is still a tower:
            -- the exponent shifts the rank by one, not to LIMIT.
            return Impl.signedMagnitude(1, Impl.magPow(Impl.magnitude(a), Impl.magnitude(b)))
        end
        return CAP
    end

    if sa < 0 then
        if b.kind ~= "finite" or b.n ~= math.floor(b.n) then
            return NAN
        end
        local mag = Impl.magPow(Impl.magnitude(a), Impl.magnitude(b))
        local odd = math.abs(b.n) % 2 == 1
        return Impl.signedMagnitude(odd and -1 or 1, mag)
    end

    if a.kind == "finite" and b.kind == "finite" then
        local v = a.n ^ b.n
        if isfinite(v) and v > 0 then
            return Impl.finite(v)
        end
    end

    return Impl.magPow(a, b)
end

function Impl.tetrateValue(x, count)
    if x.kind == "nan" then
        return NAN
    end
    if Impl.signOf(x) <= 0 and not Impl.isZero(x) then
        return NAN
    end
    local sx = Impl.signOf(x)
    if sx == 0 then
        return Impl.isZero(count) and ONE or ZERO
    end
    if x.kind == "finite" and x.n == 1 then
        return ONE
    end

    local n
    if count.kind == "finite" then
        n = count.n
        if n < 0 then
            return NAN
        end
        if n < 1 then
            return ONE
        end
        n = math.floor(n)
    elseif count.kind == "named" or count.kind == "hyper"
        or (count.kind == "tower" and Rank.isFinite(count.rank)) then
        -- A finite count too large to iterate is still a finite height.
        if Hyper.eligible(x) and Hyper.eligible(count) then
            return Hyper.new(4, x, count)
        end
        return CAP
    else
        -- A transfinite iteration count is past every finite tower height.
        local partsRank, partsM = Impl.partsFromPositive(Impl.magnitude(x))
        if partsRank == nil then
            -- A named or hyper base has no tower mantle; height omega is
            -- still an ordinary infinite tower, never LIMIT.
            return Impl.fromParts(Rank.OMEGA, 9)
        end
        return Impl.fromParts(Rank.add(Rank.OMEGA, partsRank), partsM)
    end

    if n == 0 then
        return ONE
    elseif n == 1 then
        return Impl.copy(x)
    end
    if x.kind == "named" or x.kind == "hyper" then
        -- A named base dwarfs the range where iterated powers stay a plain
        -- tower; keep the tetration itself as an anchored finite value.
        if Hyper.eligible(x) and Hyper.eligible(count) then
            return Hyper.new(4, x, count)
        end
        return CAP
    end

    local y = x
    local steps = 1
    local limit = math.min(n, 32)
    while steps < limit do
        y = Impl.powValues(x, y)
        steps = steps + 1
        if y.kind == "cap" then
            return CAP
        end
    end

    if n > steps then
        local rank, m = Impl.partsFromPositive(Impl.magnitude(y))
        if rank ~= nil and y.kind == "tower" then
            return Impl.fromParts(Rank.addFinite(rank, n - steps), m)
        end
        -- Slow-converging bases below 2 stay finite for a long time.
        while steps < math.min(n, 128) do
            y = Impl.powValues(x, y)
            steps = steps + 1
            if y.kind == "cap" then
                return CAP
            end
        end
        return y
    end
    return y
end

function Impl.pentateValue(x, count)
    local finiteCount = count.kind == "finite"
    if not finiteCount then
        local finiteHeight = count.kind == "named" or count.kind == "hyper"
            or (count.kind == "tower" and Rank.isFinite(count.rank))
        if finiteHeight then
            if Hyper.eligible(x) and Hyper.eligible(count) then
                return Hyper.new(5, x, count)
            end
            return CAP
        end
        return Impl.fromParts(Rank.OMEGA, 9)
    end
    local n = math.floor(count.n)
    if n < 0 then
        return NAN
    elseif n == 0 then
        return ONE
    elseif n == 1 then
        return Impl.copy(x)
    end
    if n > 8 then
        if Hyper.eligible(x) and Hyper.eligible(count) then
            return Hyper.new(5, x, count)
        end
        return CAP
    end
    if x.kind == "named" or x.kind == "hyper" then
        if Hyper.eligible(x) and Hyper.eligible(count) then
            return Hyper.new(5, x, count)
        end
        return CAP
    end
    local y = x
    for _ = 2, n do
        y = Impl.tetrateValue(x, y)
        if y.kind == "cap" then
            return CAP
        end
        if y.kind == "hyper" then
            if Hyper.eligible(x) then
                return Hyper.new(5, x, count)
            end
            return CAP
        end
    end
    return y
end

-- Conversion, formatting, serialization ------------------------------------

function Impl.asValue(v)
    if Impl.isZuba(v) then
        return v
    end
    return ZubaNum.new(v)
end

function Impl.formatNumber(n)
    if n ~= n then
        return "NaN"
    end
    if n == math.huge then
        return "Infinity"
    elseif n == -math.huge then
        return "-Infinity"
    end
    local a = math.abs(n)
    if a ~= 0 and (a < 1e-4 or a >= 1e15) then
        return string.format("%.6g", n)
    end
    if n == math.floor(n) then
        return string.format("%.0f", n)
    end
    return string.format("%.10g", n)
end

function Impl.formatMantissa(m)
    if m == math.floor(m) then
        return string.format("%.0f", m)
    end
    return string.format("%.15g", m)
end

function Impl.format(v, style)
    if v.kind == "nan" then
        return "NaN"
    elseif v.kind == "cap" then
        return v.sign > 0 and "LIMIT" or "-LIMIT"
    elseif v.kind == "named" then
        return Named.format(v)
    elseif v.kind == "hyper" then
        if style == "nest" then
            local nest = Impl.nestInfo(v)
            -- Only a chain with a real nested node gets shorter: H(4,2,2) would
            -- rewrite to H(5,2,2) and then to H(6,2,2) forever, so a depth-1
            -- value prints as itself and the rewrite is not re-applied.
            if nest ~= nil and nest.depth > 1 then
                return Impl.format(Impl.nestValue(nest.level, nest.base, nest.count))
            end
        end
        return Hyper.format(v)
    elseif v.kind == "card" then
        return Card.format(v)
    elseif v.kind == "fgh" then
        return Fgh.format(v)
    elseif v.kind == "finite" then
        return Impl.formatNumber(v.n)
    end

    local sign = v.sign < 0 and "-" or ""
    local mant = Impl.formatMantissa(v.m)
    local rank = v.rank
    if style == "rank" or not Rank.isFinite(rank) then
        return sign .. "T(" .. Rank.toString(rank) .. ", " .. mant .. ")"
    end
    local h = Rank.finiteValue(rank)
    if h <= 4 then
        local parts = {}
        for i = 1, h do
            parts[i] = "10^"
        end
        return sign .. table.concat(parts) .. mant
    end
    return sign .. "T(" .. Rank.toString(rank) .. ", " .. mant .. ")"
end

-- Rank atom spellings. Greek glyphs are listed in both cases because Lua's
-- string.lower is byte-based and leaves UTF-8 sequences untouched. The psi
-- spellings are the collapsing-function names of the same ordinals:
-- psi(Omega) = eps0, psi(Omega^2) = Gamma_0, psi(Omega^omega) = SVO,
-- psi(Omega^Omega) = BHO, and the Buchholz ladder above it.
local RANK_ALIASES = {
    ["ω"] = { k = "omega" }, ["Ω"] = { k = "omega" },
    omega = { k = "omega" }, w = { k = "omega" },

    ["ε₀"] = { k = "phi", n = 1 }, ["ε0"] = { k = "phi", n = 1 },
    epsilon0 = { k = "phi", n = 1 }, eps0 = { k = "phi", n = 1 },
    epsilon = { k = "phi", n = 1 }, ["ψ(Ω)"] = { k = "phi", n = 1 },

    ["ζ₀"] = { k = "phi", n = 2 }, ["ζ0"] = { k = "phi", n = 2 },
    zeta0 = { k = "phi", n = 2 }, zeta = { k = "phi", n = 2 },

    ["η₀"] = { k = "phi", n = 3 }, ["η0"] = { k = "phi", n = 3 },
    eta0 = { k = "phi", n = 3 }, eta = { k = "phi", n = 3 },

    ["γ₀"] = { k = "gamma" }, ["Γ₀"] = { k = "gamma" }, ["γ0"] = { k = "gamma" },
    gamma0 = { k = "gamma" }, gamma = { k = "gamma" },
    fefermanschutte = { k = "gamma" }, fs = { k = "gamma" },
    ["ψ(Ω^2)"] = { k = "gamma" }, ["ψ(Ω²)"] = { k = "gamma" },

    ["γω"] = { k = "gamma_omega" }, ["Γω"] = { k = "gamma_omega" },
    gammaomega = { k = "gamma_omega" },

    svo = { k = "svo" }, smallveblen = { k = "svo" },
    smallveblenordinal = { k = "svo" }, ["φ(1@ω)"] = { k = "svo" },
    ["ψ(Ω^ω)"] = { k = "svo" },

    lvo = { k = "lvo" }, largeveblen = { k = "lvo" },
    largeveblenordinal = { k = "lvo" }, ["φ(1@(1@ω))"] = { k = "lvo" },

    bho = { k = "bho" }, bachmannhoward = { k = "bho" },
    bachmannhowardordinal = { k = "bho" }, ["ψ(Ω^Ω)"] = { k = "bho" },

    sbo = { k = "sbo" }, smallbuchholz = { k = "sbo" },
    smallbuchholzordinal = { k = "sbo" }, ["ψ(Ω^(Ω^ω))"] = { k = "sbo" },

    lbo = { k = "lbo" }, largebuchholz = { k = "lbo" },
    largebuchholzordinal = { k = "lbo" }, ["ψ(Ω^(Ω^Ω))"] = { k = "lbo" },

    tfb = { k = "tfb" }, takeutifefermanbuchholz = { k = "tfb" },

    ebho = { k = "ebho" }, extendedbuchholz = { k = "ebho" },
    extendedbuchholzordinal = { k = "ebho" },

    i = { k = "weak_inv" }, wi = { k = "weak_inv" },
    inaccessible = { k = "weak_inv" }, weakinaccessible = { k = "weak_inv" },
    weaklyinaccessible = { k = "weak_inv" },

    m = { k = "weak_mahlo" }, wm = { k = "weak_mahlo" },
    mahlo = { k = "weak_mahlo" }, weakmahlo = { k = "weak_mahlo" },
    weaklymahlo = { k = "weak_mahlo" },

    k = { k = "weak_compact" }, wc = { k = "weak_compact" },
    weakcompact = { k = "weak_compact" }, weaklycompact = { k = "weak_compact" },
}

function Impl.parseRankAtom(name)
    -- Whitespace, hyphens and underscores carry no meaning in a rank spelling,
    -- so they are stripped once here instead of enumerated in every alias.
    local low = name:lower():gsub("%s+", ""):gsub("[-_]", "")
    local atom = RANK_ALIASES[low]
    if atom ~= nil then
        return atom
    end

    local n = low:match("^φ%((%d+)%)$")
        or low:match("^φ%((%d+),0%)$")
        or low:match("^phi%((%d+)%)$")
        or low:match("^phi%((%d+),0%)$")
    if n ~= nil then
        return { k = "phi", n = math.max(1, tonumber(n) or 1) }
    end

    local g = low:match("^γ(%d+)$")
        or low:match("^Γ(%d+)$")
        or low:match("^gamma(%d+)$")
    if g ~= nil then
        return { k = "gamma", n = math.max(0, tonumber(g) or 0) }
    end
    return nil
end

function Impl.parseRankString(s)
    if type(s) ~= "string" then
        return nil
    end
    s = s:gsub("^%s+", ""):gsub("%s+$", "")
    if s == "" or s:sub(1, 1) == "+" or s:sub(-1) == "+"
        or s:find("++", 1, true) ~= nil then
        return nil
    end
    local parts = {}
    for part in string.gmatch(s, "[^+]+") do
        parts[#parts + 1] = part:gsub("%s+", "")
    end
    if #parts == 0 then
        return nil
    end

    local terms = {}
    local fin = 0
    for i = 1, #parts do
        local part = parts[i]
        -- Normalize the UTF-8 middle dot to ASCII '*' before pattern matching;
        -- Lua patterns are byte-based and cannot put a multi-byte glyph in a set.
        local normalized = part:gsub("·", "*")
        local name, countStr = normalized:match("^(.-)%*(%d+)$")
        local count = 1
        if name ~= nil then
            count = tonumber(countStr)
            if count == nil or count < 1 then
                return nil
            end
        else
            name = part
        end
        local atom = Impl.parseRankAtom(name)
        if atom ~= nil then
            terms[#terms + 1] = { k = atom.k, n = atom.n, c = math.floor(count) }
        else
            local f = tonumber(name)
            if f == nil or i ~= #parts then
                return nil
            end
            fin = f
        end
    end

    return Rank.normalize({ _rank = true, terms = terms, fin = fin })
end

-- Suffix and name spellings ------------------------------------------------
-- Short-scale game suffixes and classical -illion names are display/parse
-- helpers only. They map onto the same finite doubles and towers as any other
-- spelling; nothing new is added to the value model.

Suffix = {}

-- Composed name ladders ------------------------------------------------------
-- The -illion and -plex ladders are built from roots by the loops below rather
-- than typed entry by entry, and both stop at Suffix.CAP: the root there is
-- 100,000,000 and its group form reads "mehect" ("me" = the millions marker
-- carrying "hect" = 100), so the top of the -illion ladder is "mehectillion" and
-- the top of the -plex ladder is "googolmehectaplex" (tower height
-- 100,000,002). Naming stops there on purpose; the value model reaches far past
-- it. 10^(3*10^333+3) is a number this library builds, prints and orders, it
-- simply has no name in the ladder, and past the cap toName gives nil while a
-- spelled name parses as NaN.
--
-- The -illion ladder runs in two tiers, because the two published -illion tables
-- disagree about what a marker does and only one of them keeps the names in
-- order. With f(n) = 10^(3n+3):
--   tier 1, no "me" marker (index below 1,000,001): the classical additive
--     composition, illion i names f(i-1) = 10^(3i). thousand = 10^3, centillion =
--     10^303, millillion = 10^3003, all as in v2.2.
--   tier 2, "me" group a >= 1 and tail T (0 <= T < 1e6): the marker nests the
--     operation, illion names f(10^(3a+3) + T). That is the Googology-Wiki
--     reading, which puts mehectillion (a = 100, T = 0) at 10^(3*10^303+3).
-- Nesting is what makes the list come out in real order: flat, the whole -illion
-- ladder topped out at 10^300,000,003, which is below googolplex = 10^(10^100),
-- so the -plex list had to start "somewhere after the cap" and the two ladders
-- crossed over each other. Nested, tier 2 runs from 10^3,000,003 up past
-- googolplex and on to 10^(3*10^303+3), and every name is where its value says it
-- should be.
-- a = 1 is the fixed point of the whole change: f(1) = 10^6 is exactly what the
-- flat "me" multiplier meant, so megillion and all 1,000,000 of its tails keep
-- the values v2.2 gave them. Only a >= 2 moves.
Suffix.CAP = 100000000
local ILLION_TIER = 1000000        -- one "me" step, i.e. the tail width

-- Short-scale marks. The first ten tiers are the game convention and
-- irreducibly arbitrary, so those ten stay typed; every tier above composes.
-- The tens marks are spelled so no composed mark can collide with a bare one
-- (Sex/Sep/Oct/Non/Qu against Sx/Sp/Oc/No/Qi), which keeps the table one-to-one
-- for parsing. The short ladder covers tier 99 (10^297); past that toSuffix
-- falls back to plain format and the -illion register carries the names.
local SHORT_BASE = { "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No" }
local SHORT_ONES = { "", "U", "D", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No" }
local SHORT_TENS = { "Dc", "Vg", "Tc", "Qd", "Qu", "Sex", "Sep", "Oct", "Non" }
Suffix.MAX_TIER = 99

Suffix.SHORT = {}
for tier = 1, 10 do
    Suffix.SHORT[3 * tier] = SHORT_BASE[tier]
end
for tier = 11, Suffix.MAX_TIER do
    local ten = math.floor((tier - 1) / 10)
    local one = (tier - 1) % 10
    Suffix.SHORT[3 * tier] = SHORT_ONES[one + 1] .. SHORT_TENS[ten]
end

Suffix.SHORT_EXP = {}
for exp, abbr in pairs(Suffix.SHORT) do
    Suffix.SHORT_EXP[abbr:lower()] = exp
end

-- The -illion register names 10^(3i) for a table index i, so i = 1 is
-- "thousand", i = 11 is "decillion" and the Latin root of a composed name is
-- always one less than its index. The ten irregular marks stay typed.
local ILLION_MARK = {
    "thousand", "million", "billion", "trillion", "quadrillion",
    "quintillion", "sextillion", "septillion", "octillion", "nonillion",
}
local ILLION_ONES = { "", "un", "duo", "tre", "quattuor", "quin", "sex", "septen", "octo", "non" }
local ILLION_TENS = { "", "dec", "vigint", "trigint", "quadragint", "quinquagint",
    "sexagint", "septuagint", "octogint", "nonagint" }
local ILLION_HUND = { "", "cent", "ducent", "trecent", "quadringent", "quingent",
    "sescent", "septingent", "octingent", "nongent" }

-- The -plex register is the ordinal series: k = 1 is "googolplex", k = 2 is
-- "googolduplex" and k = 11 is "googolundeciplex", so a composed stem carries
-- the root of k itself. Its ten marks are the distributive forms.
local PLEX_MARK = { "", "du", "tri", "quadri", "quinti", "sexti", "septi", "octi", "noni" }
local PLEX_ONES = ILLION_ONES
local PLEX_TENS = { "", "deci", "viginti", "triginti", "quadraginti", "quinquaginti",
    "sexaginti", "septuaginti", "octoginti", "nonaginti" }
local PLEX_HUND = { "", "centi", "ducenti", "trecenti", "quadringenti", "quingenti",
    "sescenti", "septingenti", "octingenti", "nongenti" }

local VOWELS = { a = true, e = true, i = true, o = true, u = true }
local GROUP_HUNDRED = "hect"

-- A hundreds root and a consonant onset take the Latin "o" connective
-- ("centoduovigint"); everywhere else roots butt together ("octooctogint",
-- "nonnonagint"). One documented convention - not every connective variant in
-- the literature is reproduced, and ZubaNum always writes and reads this one.
local function join(head, tail)
    if tail == "" then
        return head
    elseif head == "" then
        return tail
    elseif VOWELS[tail:sub(1, 1)] or VOWELS[head:sub(-1)] then
        return head .. tail
    end
    return head .. "o" .. tail
end

-- One 0..999 root group written hundreds-first, the classical order: 121 is
-- cent+un+vigint, 19 takes the "novem" form before "dec", 333 is
-- trecent+o+tre+trigint, 1e8 is "mehect" after the group pass below.
local function rootGroup(r, ones, tens, hund)
    if r <= 0 then
        return ""
    end
    local hundred = math.floor(r / 100)
    local ten = math.floor(r / 10) % 10
    local one = r % 10
    local unit = ones[one + 1]
    if ten == 1 and one == 9 then
        unit = "novem"
    end
    return join(hund[hundred + 1], unit .. tens[ten + 1])
end

-- A group multiplier carries the hundreds form "hect" at exactly 100; the
-- other 1..999 readings reuse rootGroup.
local function multText(m, ones, tens, hund)
    if m == 100 then
        return GROUP_HUNDRED
    end
    return rootGroup(m, ones, tens, hund)
end

-- The three root slots of a ladder coordinate, marker-first:
--   millions  -> "meg" at 1, otherwise "me" + its multiplier ("mehect" = 100)
--   thousands -> "mil" at 1, otherwise "mil" + its multiplier
--   units     -> the plain 0..999 group
-- A units group that follows a marker takes an "i" connective. That connective
-- is what keeps the composition one-to-one: without it "mil" + 500 would read
-- the same for 1,500 and for 500,000, and "me" + 2 the same for 2,000,000 and
-- for 1,000,002. No root begins with "i", so the connective is never absorbed.
local function ladderStem(r, ones, tens, hund)
    if r == nil or r ~= r or r < 0 or r > Suffix.CAP or r % 1 ~= 0 then
        return nil
    end
    local millions = math.floor(r / 1000000)
    local thousands = math.floor(r / 1000) % 1000
    local rest = r % 1000
    local stem = ""
    if millions > 0 then
        if millions == 1 then
            stem = "meg"
        else
            stem = "me" .. multText(millions, ones, tens, hund)
        end
    end
    if thousands > 0 then
        if thousands == 1 then
            stem = stem .. "mil"
        else
            stem = stem .. "mil" .. multText(thousands, ones, tens, hund)
        end
    end
    if rest > 0 then
        if stem ~= "" then
            stem = stem .. "i"
        end
        stem = stem .. rootGroup(rest, ones, tens, hund)
    elseif stem == "" then
        stem = rootGroup(rest, ones, tens, hund)
    end
    return stem
end

-- Lazily filled memos in both directions: the ladders are endless in
-- principle, so only the names a game actually asks for cost a string, and a
-- refused lookup is remembered too rather than re-derived on every parse.
local illionNames, illionIndexes = {}, {}
local plexNames, plexIndexes = {}, {}

function Suffix.illionName(i)
    local hit = illionNames[i]
    if hit ~= nil then
        return hit ~= false and hit or nil
    end
    local out
    if i ~= nil and i % 1 == 0 and i >= 1 and i <= Suffix.CAP + 1 then
        if i <= 10 then
            out = ILLION_MARK[i]
        else
            local stem = ladderStem(i - 1, ILLION_ONES, ILLION_TENS, ILLION_HUND)
            if stem ~= nil then
                out = stem .. "illion"
            end
        end
    end
    illionNames[i] = out ~= nil and out or false
    return out
end

function Suffix.plexName(k)
    local hit = plexNames[k]
    if hit ~= nil then
        return hit ~= false and hit or nil
    end
    local out
    if k ~= nil and k % 1 == 0 and k >= 1 and k <= Suffix.CAP then
        local stem
        if k <= 9 then
            stem = PLEX_MARK[k]
        else
            stem = ladderStem(k, PLEX_ONES, PLEX_TENS, PLEX_HUND)
        end
        if stem ~= nil then
            -- An ordinal stem runs straight into "plex"; a consonant ending
            -- takes the "a" that reads "mehectaplex".
            if stem == "" then
                out = "googolplex"
            elseif VOWELS[stem:sub(-1)] then
                out = "googol" .. stem .. "plex"
            else
                out = "googol" .. stem .. "aplex"
            end
        end
    end
    plexNames[k] = out ~= nil and out or false
    return out
end

-- Reading names back ---------------------------------------------------------
-- The reverse scans roots the composer could have written and then regenerates
-- the name, accepting an index only when the spelling matches character for
-- character. A wrong boundary guess therefore cannot yield a wrong index, and
-- the two directions cannot drift apart.

-- Every reading of a 0..99 span, not the first one that fits: several roots can
-- start the same letters ("tre" inside "trigint", "non" inside "nonagint"), and
-- the caller decides which reading is real by regenerating the name.
local function lowVals(text, ones, tens, into)
    into = into or {}
    if text == "" then
        into[#into + 1] = 0
        return into
    end
    local unit, unitLen = { 0 }, { 0 }
    for u = 1, 9 do
        local root = ones[u + 1]
        if #root > 0 and text:sub(1, #root) == root then
            unit[#unit + 1] = u
            unitLen[#unitLen + 1] = #root
        end
    end
    if text:sub(1, 5) == "novem" then
        unit[#unit + 1] = 9
        unitLen[#unitLen + 1] = 5
    end
    for i = 1, #unit do
        local rest = text:sub(unitLen[i] + 1)
        if rest == "" then
            into[#into + 1] = unit[i]
        else
            for t = 1, 9 do
                if rest == tens[t + 1] then
                    into[#into + 1] = t * 10 + unit[i]
                end
            end
        end
    end
    return into
end

-- Readings of a whole 0..999 group: a plain 0..99 span, or a hundreds root plus
-- its low span with the "o" connective present or absent, and "hect" alone.
local function groupVals(text, ones, tens, hund, into)
    into = into or {}
    if text == "" then
        into[#into + 1] = 0
        return into
    end
    if text == GROUP_HUNDRED then
        into[#into + 1] = 100
    end
    lowVals(text, ones, tens, into)
    for h = 1, 9 do
        local root = hund[h + 1]
        if #root > 0 and text:sub(1, #root) == root then
            local rest = text:sub(#root + 1)
            local tails = { rest }
            if rest:sub(1, 1) == "o" then
                tails[2] = rest:sub(2)
            end
            for j = 1, #tails do
                local lows = lowVals(tails[j], ones, tens, {})
                for i = 1, #lows do
                    into[#into + 1] = h * 100 + lows[i]
                end
            end
        end
    end
    return into
end

-- All coordinates whose stem text could be the given stem. The slots are tried
-- in the order the composer writes them, and a units group is read both with
-- and without its leading "i" connective.
local function stemRoots(stem, ones, tens, hund, limit)
    local out, seen = {}, {}
    local n = #stem
    local function add(value)
        if value ~= nil and value >= 0 and value <= limit and not seen[value] then
            seen[value] = true
            out[#out + 1] = value
        end
    end
    local function read(a, acc, milLeft)
        if a > n + 1 then
            return
        end
        if a > n then
            add(acc)
            return
        end
        local text = stem:sub(a)
        local vals = groupVals(text, ones, tens, hund, {})
        for i = 1, #vals do
            add(acc + vals[i])
        end
        if text:sub(1, 1) == "i" then
            local held = groupVals(text:sub(2), ones, tens, hund, {})
            for i = 1, #held do
                add(acc + held[i])
            end
        end
        if milLeft and text:sub(1, 3) == "mil" then
            read(a + 3, acc + 1000, false)
            for e = a + 3, n do
                local mult = groupVals(stem:sub(a + 3, e), ones, tens, hund, {})
                for i = 1, #mult do
                    if mult[i] >= 2 and mult[i] <= 999 then
                        read(e + 1, acc + mult[i] * 1000, false)
                    end
                end
            end
        end
    end
    read(1, 0, true)
    if stem:sub(1, 3) == "meg" then
        read(4, 1000000, true)
    end
    if stem:sub(1, 2) == "me" then
        for e = 3, n do
            local mult = groupVals(stem:sub(3, e), ones, tens, hund, {})
            for i = 1, #mult do
                local m = mult[i]
                if m >= 2 and m <= 100 then
                    read(e + 1, m * 1000000, true)
                end
            end
        end
    end
    return out
end

local ILLION_ROOT_LIMIT = Suffix.CAP

-- The doubled-l spelling ("millillion", "millicentillion") is what most printed
-- tables use, while this composer writes "milillion" and "milicentillion". The
-- extra "l" is folded out and the grammar retried, so both readings reach the
-- same index; the "-iaplex" shape drops the "a" as well, so both folds are
-- tried. A name that already is "million" is a typed mark and never gets here,
-- and a name without "milli" in it produces no alternate at all.
local function milAlternates(name)
    if name:find("milli", 1, true) == nil then
        return nil
    end
    return { (name:gsub("milli", "mili")), (name:gsub("millia", "mila")) }
end

local function retryMil(name, stemIndex)
    local alts = milAlternates(name)
    if alts == nil then
        return nil
    end
    for j = 1, #alts do
        local hit = stemIndex(alts[j])
        if hit ~= nil then
            return hit
        end
    end
    return nil
end

-- Roots the composer could have written, then regenerate and accept an index
-- only when the spelling matches character for character, so the two directions
-- cannot drift apart.
local function illionStemIndex(name)
    local stem = name:match("^(.-)illion$")
    if stem == nil then
        return nil
    end
    local roots = stemRoots(stem, ILLION_ONES, ILLION_TENS, ILLION_HUND, ILLION_ROOT_LIMIT)
    for i = 1, #roots do
        local index = roots[i] + 1
        if Suffix.illionName(index) == name then
            return index
        end
    end
    return nil
end

function Suffix.illionIndexOf(name)
    local hit = illionIndexes[name]
    if hit ~= nil then
        return hit ~= false and hit or nil
    end
    local out
    for i = 1, 10 do
        if ILLION_MARK[i] == name then
            out = i
            break
        end
    end
    if out == nil then
        out = illionStemIndex(name)
        if out == nil then
            out = retryMil(name, illionStemIndex)
        end
    end
    illionIndexes[name] = out ~= nil and out or false
    return out
end

local function plexStemIndex(name)
    local stem = name:match("^googol(.*)plex$")
    if stem == nil then
        return nil
    end
    local tails = { stem }
    if stem:sub(-1) == "a" then
        tails[2] = stem:sub(1, -2)
    end
    for j = 1, #tails do
        local roots = stemRoots(tails[j], PLEX_ONES, PLEX_TENS, PLEX_HUND, Suffix.CAP)
        for i = 1, #roots do
            local k = roots[i]
            if k >= 10 and Suffix.plexName(k) == name then
                return k
            end
        end
    end
    return nil
end

function Suffix.plexIndexOf(name)
    local hit = plexIndexes[name]
    if hit ~= nil then
        return hit ~= false and hit or nil
    end
    local out
    -- The nine distributive marks are typed, so they read back through the
    -- forward generator rather than through the root grammar.
    for k = 1, 9 do
        if Suffix.plexName(k) == name then
            out = k
            break
        end
    end
    if out == nil then
        out = plexStemIndex(name)
        if out == nil then
            out = retryMil(name, plexStemIndex)
        end
    end
    plexIndexes[name] = out ~= nil and out or false
    return out
end

-- The typed tables these ladders replaced stay readable as views, so a game
-- that indexes them directly keeps working and only pays for the rows it uses.
Suffix.ILLION = setmetatable({}, {
    __index = function(ladder, i)
        local name = Suffix.illionName(i)
        if name == nil then
            return nil
        end
        rawset(ladder, i, name)
        return name
    end,
})

Suffix.PLEX = setmetatable({}, {
    __index = function(ladder, k)
        local name = Suffix.plexName(k)
        if name == nil then
            return nil
        end
        rawset(ladder, k, name)
        return name
    end,
})

-- Views rather than tables: indexing one composes the name on demand, so a
-- hundred million possible names cost nothing until a caller asks for one.
ZubaNum.ILLION = Suffix.ILLION
ZubaNum.PLEX = Suffix.PLEX
ZubaNum.LADDER_CAP = Suffix.CAP

-- log10 of the value an -illion index names, following the two tiers described
-- above. Tier 2 stays inside a plain double at the cap: 3*10^303 + 3 is the
-- largest exponent the ladder ever produces, so the value lands on the compact
-- tower ladder and no new kind is needed.
function Suffix.illionExp(i)
    if i == nil or i ~= i or i % 1 ~= 0 or i < 1 or i > Suffix.CAP + 1 then
        return nil
    end
    local n = i - 1
    local a = math.floor(n / ILLION_TIER)
    if a == 0 then
        return 3 * i
    end
    local inner = pow10OfText("1", 3 * a + 3)
    if inner == nil or not isfinite(inner) then
        return nil
    end
    return 3 * (inner + (n - a * ILLION_TIER)) + 3
end

-- Index straight to value, the exact partner of illionName. A game that walks
-- the ladder by index should never have to spell a name and then invert one.
function Suffix.illionValue(i)
    local exp = Suffix.illionExp(i)
    if exp == nil then
        return nil
    end
    if exp <= 306 then
        local mag = pow10OfText("1", exp)
        if mag == nil then
            return nil
        end
        return Impl.finite(mag)
    end
    return Impl.fromLog10Value(Impl.finite(exp))
end

-- Power tower of height k + 2, so k = 1 is googolplex = 10^(10^100). The height
-- goes in directly rather than iterating the powers.
function Suffix.plexValue(k)
    if k == nil or k ~= k or k % 1 ~= 0 or k < 1 or k > Suffix.CAP then
        return nil
    end
    return Impl.fromParts(Rank.addFinite(Rank.ZERO, k + 2), 2)
end

-- Reading a value back to a ladder index, which is what lets a magnitude built
-- as fromLog10(3e303) name itself "mehectillion" instead of falling back to
-- format. The exponent a tower reports has already been snapped to the
-- representation grid, so it is good only to a few ULPs and cannot be inverted
-- exactly: candidates come from it loosely and each one is confirmed by
-- comparing values, which is where ZubaNum is exact. Past a = 4 the double has
-- no room for a tail at all, so the zero-tail row is the only candidate that can
-- confirm, and that is honest because every merged index holds that one value.
function Suffix.illionIndexOfValue(x)
    local lv = Impl.log10Value(x)
    if lv.kind ~= "finite" then
        return nil
    end
    local e = lv.n
    if e ~= e or not isfinite(e) or e < 3 then
        return nil
    end
    local function confirm(i)
        if i == nil or i < 1 or i > Suffix.CAP + 1 then
            return nil
        end
        local probe = Suffix.illionValue(i)
        if probe ~= nil and Impl.compare(probe, x) == 0 then
            return i
        end
        return nil
    end
    -- Tier 1 and the a = 1 step share the flat reading e = 3i, so the plain
    -- inversion is tried first and only the value decides.
    local hit = confirm(math.floor(e / 3 + 0.5))
    if hit ~= nil then
        return hit
    end
    local m = e / 3 - 1
    if m < ILLION_TIER then
        return nil
    end
    local k = math.floor(log10(m) + 0.5)
    if (k - 3) % 3 ~= 0 then
        return nil
    end
    local a = (k - 3) / 3
    if a < 1 or a * ILLION_TIER > Suffix.CAP then
        return nil
    end
    local base = pow10OfText("1", k)
    if base == nil then
        return nil
    end
    local head = a * ILLION_TIER + 1
    hit = confirm(head)
    if hit ~= nil then
        return hit
    end
    local tail = math.floor(m - base + 0.5)
    if tail < 1 or tail >= ILLION_TIER then
        return nil
    end
    return confirm(head + tail)
end

-- Public ladder access, so a game can walk the series without holding a value
-- for every row. Names come back nil past the cap and for a spelling the
-- composer would never write.
function ZubaNum.illionName(i)
    return Suffix.illionName(i)
end

function ZubaNum.plexName(k)
    return Suffix.plexName(k)
end

function ZubaNum.illionIndex(name)
    if type(name) ~= "string" then
        return nil
    end
    return Suffix.illionIndexOf(name:lower())
end

function ZubaNum.plexIndex(name)
    if type(name) ~= "string" then
        return nil
    end
    return Suffix.plexIndexOf(name:lower())
end

-- The value behind a ladder name. Keeping it separate from the name means a
-- game can walk the series by index without ever holding the string, and a
-- tier-2 exponent is exact here even when two neighbours share one log10.
function ZubaNum.illionValue(i)
    return Suffix.illionValue(i)
end

function ZubaNum.plexValue(k)
    return Suffix.plexValue(k)
end

function ZubaNum.illionExp(i)
    return Suffix.illionExp(i)
end

function Suffix.fixed(c, decimals)
    decimals = numfloor(tonumber(decimals) or 2)
    if decimals < 0 then
        decimals = 0
    elseif decimals > 12 then
        decimals = 12
    end
    local s = string.format("%." .. decimals .. "f", c)
    if s:find(".", 1, true) ~= nil then
        s = s:gsub("0+$", ""):gsub("%.$", "")
    end
    return s
end

function Suffix.scaleOf(n)
    local tier = numfloor(log10(n) / 3)
    if tier < 1 then
        tier = 1
    end
    return tier
end

function Suffix.shortValue(t)
    local coefStr, abbr = t:match("^([%d%.]+)%s*([%a]+)$")
    if coefStr == nil then
        return nil
    end
    local exp = Suffix.SHORT_EXP[abbr:lower()]
    if exp == nil then
        return nil
    end
    local coef = tonumber(coefStr)
    if coef == nil or not isfinite(coef) or coef < 0 then
        return nil
    end
    local mag = pow10OfText(coefStr, exp)
    if mag == nil or not isfinite(mag) then
        local lv = log10(coef) + exp
        if not isfinite(lv) then
            return nil
        end
        return Impl.fromLog10Value(Impl.finite(lv))
    end
    return Impl.finite(mag)
end

function Suffix.nameValue(t)
    t = t:lower():gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if t == "" then
        return nil
    end
    local coef = 1
    local name = t
    local coefStr, rest = t:match("^([%d%.]+)%s*(.+)$")
    if coefStr ~= nil then
        local c = tonumber(coefStr)
        if c == nil or not isfinite(c) or c <= 0 then
            return nil
        end
        coef = c
        name = rest
    end
    if name == "googol" then
        local mag = coef * 1e100
        if not isfinite(mag) then
            return nil
        end
        return Impl.finite(mag)
    end
    local plex = Suffix.plexIndexOf(name)
    if plex ~= nil then
        -- A -plex is a power tower of height plex + 2 whose top is the googol
        -- exponent, so the height goes in directly; iterating the powers would
        -- spin a hundred million times at the cap.
        local v = Impl.fromParts(Rank.addFinite(Rank.ZERO, plex + 2), 2)
        if coef ~= 1 then
            v = Impl.mulValues(Impl.finite(coef), v)
        end
        return v
    end
    local index = Suffix.illionIndexOf(name)
    if index ~= nil then
        local exp = Suffix.illionExp(index)
        if exp == nil then
            return nil
        end
        if exp <= 306 then
            local mag = pow10OfText(coefStr or "1", exp)
            if mag == nil or not isfinite(mag) then
                return nil
            end
            return Impl.finite(mag)
        end
        -- Past the double window the exponent itself is what is known, so the
        -- value is built from it and lands on the compact tower ladder.
        local lv = exp + log10(coef)
        if not isfinite(lv) then
            return nil
        end
        return Impl.fromLog10Value(Impl.finite(lv))
    end
    return nil
end

-- The Unicode UP ARROW, U+2191, as its three UTF-8 bytes: "3↑↑3" is tetration
-- the way "3^^3" is, and it is a different glyph from Beaf's RIGHT arrow U+2192
-- above, whose bytes differ only in the last position. The pair is precomputed
-- because a lone marker is not a spelling and the gate in parseString looks for
-- two of them at once.
local UP_ARROW_GLYPH = string.char(226, 134, 145)
local UP_ARROW_PAIR = UP_ARROW_GLYPH .. UP_ARROW_GLYPH

-- Splits "left <run of >= 2 identical markers> right" at the run the caller
-- already located and returns the run length with the two halves. Mixing
-- carets and glyphs inside one run is not a spelling, so the extension only
-- looks for the marker the run started with. Only the first run is claimed
-- here: a later one belongs to the right half and is handled when that half is
-- parsed again.
local function splitUpArrows(s, pos, glyph)
    local marker, step = "^", 1
    if glyph then
        marker, step = UP_ARROW_GLYPH, 3
    end
    local arrows = 2
    local endPos = pos + 2 * step
    while s:sub(endPos, endPos + step - 1) == marker do
        arrows = arrows + 1
        endPos = endPos + step
    end
    return arrows, s:sub(1, pos - 1), s:sub(endPos)
end

function Impl.parseString(s, depth)
    if type(s) ~= "string" then
        return NAN
    end
    depth = depth or 0
    if depth > 64 then
        return NAN
    end
    -- Only pay for the two gsubs when whitespace is actually present; most
    -- spellings reaching here are already tight.
    local lead = s:byte(1)
    if lead ~= nil and lead <= 32 then
        s = s:gsub("^%s+", "")
    end
    local tail = s:byte(-1)
    if tail ~= nil and tail <= 32 then
        s = s:gsub("%s+$", "")
    end
    if s == "e" or s == "E" then
        return Impl.finite(E_CONST)
    end
    -- A trailing "!" is factorial, but only when nothing else in the text uses
    -- the marker: "10!!" is not a spelling, so it falls through and is NaN. The
    -- body is parsed as a value, so "TREE(3)!" and "1e308!" read exactly as
    -- they do without the marker, and an empty body ("!") is NaN too.
    if s:byte(-1) == 33 and s:find("!", 1, true) == #s then
        return ZubaNum.factorial(Impl.parseString(s:sub(1, #s - 1), depth + 1))
    end
    -- Array and arrow-chain spellings are unambiguous: a leading brace or an
    -- arrow separator anywhere in the text routes them to the array parser.
    -- The same two bytes also feed the cardinal gate below, so they are read
    -- once here.
    local b1, b2 = s:byte(1, 2)
    if b1 == 123 or s:find("->", 1, true) ~= nil
        or s:find(ARROW_GLYPH, 1, true) ~= nil then
        local bv = Beaf.parse(s, depth)
        if bv ~= nil then
            return bv
        end
    end
    -- Hyper-E spellings are marked by a hyperion run anywhere in the text or
    -- by a leading E, so one scan plus the byte already read routes them.
    if s:find("#", 1, true) ~= nil or b1 == 69 or b1 == 101 then
        local ev = HyperE.parse(s, depth)
        if ev ~= nil then
            return ev
        end
    end
    -- The -ote families are looked up by whole tokens, so a leading letter is
    -- enough to try them and numeric spellings never reach the lookup.
    if b1 ~= nil and ((b1 >= 97 and b1 <= 122) or (b1 >= 65 and b1 <= 90)) then
        local gv = Grid.parse(s, depth)
        if gv ~= nil then
            return gv
        end
    end
    -- Cardinal spellings start with a glyph, "al" (aleph/alpeh), "be" (beth),
    -- "fg"/"f_" (fast-growing) or "ha"/"h_" (Hardy), so two byte reads route
    -- them here and keep the named parser away from subscript text. The
    -- alphabet forms are matched with the other spellings further down as a
    -- fallback.
    if b1 == 226 or (b1 == 97 and b2 == 108) or (b1 == 65 and b2 == 76)
        or (b1 == 98 and b2 == 101) or (b1 == 66 and b2 == 69)
        or (b1 == 102 and (b2 == 103 or b2 == 95))
        or (b1 == 70 and (b2 == 71 or b2 == 95))
        or (b1 == 104 and (b2 == 97 or b2 == 95))
        or (b1 == 72 and (b2 == 65 or b2 == 95)) then
        local cv = Card.parse(s, depth)
        if cv ~= nil then
            return cv
        end
    end
    -- Named spellings always start with a letter the gate class covers; skip
    -- that parser for the overwhelmingly common numeric inputs.
    if s:find(NAMED_GATE) ~= nil then
        local named = Named.parse(s, depth)
        if named ~= nil then
            return named
        end
    end
    -- ack(m,n) / ackermann(m,n). The ladder is H_m(2, n+3) - 3, so the
    -- spelling resolves straight to a value instead of to a named family.
    if s:find("[Aa][Cc][Kk]") ~= nil then
        local av = Impl.parseAck(s, depth)
        if av ~= nil then
            return av
        end
    end
    -- Knuth up-arrow runs: a run of k markers is hyperoperation level k + 2,
    -- so "3^^3" is H(4, 3, 3) and "2^^^3" is H(5, 2, 3). Two pair scans are
    -- the whole cost for ordinary inputs, and a single caret never lands here.
    -- The gate sits behind the notation parsers because they answer nil - not
    -- NaN - for a spelling they do not read, so "TREE(3)^^2" falls out of the
    -- named parser and is then taken as the arrow form of TREE(3).
    local runPos = s:find("^^", 1, true)
    local runGlyph = false
    if runPos == nil then
        runPos = s:find(UP_ARROW_PAIR, 1, true)
        runGlyph = runPos ~= nil
    end
    if runPos ~= nil then
        local arrows, leftText, rightText = splitUpArrows(s, runPos, runGlyph)
        return Impl.hyperValue(arrows + 2,
            Impl.parseString(leftText, depth + 1),
            Impl.parseString(rightText, depth + 1))
    end
    -- H(level, base, arg) spellings carry commas and nested parentheses, so
    -- they must be handled before the numeric comma stripping below.
    if s:find("[Hh]%(") ~= nil then
        local hv = Hyper.parse(s)
        if hv ~= nil then
            return hv
        end
    end
    -- Numeric-first inputs skip the remaining spelling checks once tonumber
    -- accepts them. The result is cached so the final check does not parse the
    -- same string twice.
    local first = s:byte(1)
    local exact = nil
    local exactKnown = false
    if first ~= nil and ((first >= 48 and first <= 57) or first == 46) then
        if s:find(",", 1, true) ~= nil then
            s = s:gsub(",", "")
        end
        exact = tonumber(s)
        exactKnown = true
        if exact ~= nil and isfinite(exact) then
            return Impl.finite(exact)
        end
    elseif first == 43 or first == 45 then
        exact = tonumber(s)
        exactKnown = true
        if exact ~= nil and isfinite(exact) then
            return Impl.finite(exact)
        end
    end
    local low = s:lower()
    if low == "nan" then
        return NAN
    elseif low == "limit" or low == "+limit" or low == "max" or low == "+max"
        or low == "inf" or low == "+inf" or low == "infinity" or low == "+infinity" then
        return CAP
    elseif low == "-limit" or low == "-max" or low == "-inf" or low == "-infinity" then
        return NEG_CAP
    end
    if low:find("aleph") ~= nil or low:find("alpeh") ~= nil
        or low:find("beth") ~= nil or low:find("fgh") ~= nil
        or low:find("^f_") ~= nil then
        local cv = Card.parse(low, depth)
        if cv ~= nil then
            return cv
        end
    end

    local sign = 1
    local signedValue = false
    if s:sub(1, 1) == "+" then
        s = s:sub(2)
        signedValue = true
    elseif s:sub(1, 1) == "-" then
        sign = -1
        s = s:sub(2)
        signedValue = true
    end

    local rankStr, mantStr = s:match("^[Tt]%((.*),%s*([%+%-]?[%d%.]+)%s*%)$")
    if rankStr ~= nil then
        local r = Impl.parseRankString(rankStr)
        local mant = tonumber(mantStr)
        if r == nil or mant == nil then
            return NAN
        end
        return Impl.canonical(sign, r, mant)
    end

    if s:find(",", 1, true) ~= nil then
        s = s:gsub(",", "")
        exactKnown = false
    end
    if signedValue then
        exactKnown = false
    end
    if not exactKnown then
        exact = tonumber(s)
    end
    if exact ~= nil and isfinite(exact) then
        return Impl.finite(sign * exact)
    end

    local mant, exp = s:match("^([%d%.]+)[eE]([%+%-]?%d+)$")
    if mant ~= nil and exp ~= nil then
        local m = tonumber(mant)
        local e = tonumber(exp)
        if m == nil then
            return NAN
        end
        if m == 0 then
            return ZERO
        end
        if e == nil then
            return sign > 0 and CAP or NEG_CAP
        end
        local lv = log10(m) + e
        if not isfinite(lv) then
            if lv == math.huge then
                return sign > 0 and CAP or NEG_CAP
            end
            return ZERO
        end
        local v = Impl.fromLog10Value(Impl.finite(lv))
        return sign > 0 and v or Impl.negate(v)
    end

    local inner = s:match("^10%^(.+)$")
    if inner ~= nil then
        local exponent = Impl.parseString(inner, depth + 1)
        if exponent.kind == "nan" then
            return NAN
        end
        local v = Impl.fromLog10Value(exponent)
        return sign > 0 and v or Impl.negate(v)
    end

    -- Short-scale suffixes and -illion/googol names ("2.5M", "1.5 million",
    -- "googolplex"). These never overlap with numeric tonumber inputs.
    local spelled = Suffix.nameValue(s)
    if spelled == nil then
        spelled = Suffix.shortValue(s)
    end
    if spelled ~= nil then
        return sign > 0 and spelled or Impl.negate(spelled)
    end

    local n = tonumber(s)
    if n == nil or not isfinite(n) then
        return NAN
    end
    return Impl.finite(sign * n)
end

function Impl.toTable(v)
    if v.kind == "nan" then
        return { __zuba = 1, kind = "nan" }
    elseif v.kind == "cap" then
        return { __zuba = 1, kind = "cap", sign = v.sign }
    elseif v.kind == "finite" then
        return { __zuba = 1, kind = "finite", n = v.n }
    elseif v.kind == "named" then
        local nx = nil
        if v.nx ~= nil then
            nx = {}
            for i = 1, #v.nx do
                nx[i] = Impl.toTable(v.nx[i])
            end
        end
        return {
            __zuba = 1,
            kind = "named",
            sign = v.sign,
            family = v.family,
            n = v.n,
            idx = v.idx ~= nil and Idx.toTable(v.idx) or nil,
            nx = nx,
            pow = v.p,
            coef = v.coef,
            off = v.off,
        }
    elseif v.kind == "hyper" then
        return {
            __zuba = 1,
            kind = "hyper",
            sign = v.sign,
            level = v.level,
            base = Impl.toTable(v.base),
            arg = Impl.toTable(v.arg),
            pow = v.p,
            coef = v.coef,
            off = v.off,
        }
    elseif v.kind == "tower" then
        return {
            __zuba = 1,
            kind = "tower",
            sign = v.sign,
            rank = Rank.toTable(v.rank),
            m = v.m,
        }
    elseif v.kind == "card" then
        return Card.toTable(v)
    elseif v.kind == "fgh" then
        return Fgh.toTable(v)
    end
    return { __zuba = 1, kind = "nan" }
end

function Impl.fromTable(t)
    if type(t) ~= "table" or t.__zuba ~= 1 then
        return NAN
    end
    if t.kind == "nan" then
        return NAN
    elseif t.kind == "cap" then
        local sign = tonumber(t.sign) or 1
        return sign < 0 and NEG_CAP or CAP
    elseif t.kind == "finite" then
        local n = tonumber(t.n)
        if n == nil then
            return NAN
        end
        return Impl.finite(n)
    elseif t.kind == "named" then
        local index = t.n
        if t.idx ~= nil then
            index = Idx.fromTable(t.idx)
            if index == nil then
                return NAN
            end
        end
        local nx = nil
        if t.nx ~= nil then
            if type(t.nx) ~= "table" then
                return NAN
            end
            nx = {}
            for i = 1, #t.nx do
                nx[i] = Impl.fromTable(t.nx[i])
                if nx[i].kind == "nan" then
                    return NAN
                end
            end
        end
        return Named.new(t.family, index, t.sign, t.pow, t.coef, t.off, nx)
    elseif t.kind == "hyper" then
        local level = tonumber(t.level)
        local base = Impl.fromTable(t.base)
        local arg = Impl.fromTable(t.arg)
        if level == nil or base.kind == "nan" or arg.kind == "nan" then
            return NAN
        end
        return Hyper.new(level, base, arg, t.sign, t.pow, t.coef, t.off)
    elseif t.kind == "tower" then
        local rank = Rank.fromTable(t.rank)
        local m = tonumber(t.m)
        local sign = tonumber(t.sign) or 1
        if rank == nil or m == nil then
            return NAN
        end
        return Impl.canonical(sign, rank, m)
    elseif t.kind == "card" then
        return Card.fromTable(t)
    elseif t.kind == "fgh" then
        return Fgh.fromTable(t)
    end
    return NAN
end

function Impl.toNumber(v)
    if v.kind == "finite" then
        return v.n
    elseif v.kind == "tower" then
        return v.sign > 0 and math.huge or -math.huge
    elseif v.kind == "named" or v.kind == "hyper" then
        return v.sign > 0 and math.huge or -math.huge
    elseif v.kind == "card" then
        return v.sign > 0 and math.huge or -math.huge
    elseif v.kind == "fgh" then
        return v.sign > 0 and math.huge or -math.huge
    elseif v.kind == "cap" then
        return v.sign > 0 and math.huge or -math.huge
    end
    return 0 / 0
end

function Impl.getRank(v)
    if v.kind == "tower" then
        return Rank.copy(v.rank)
    elseif v.kind == "fgh" then
        return Rank.copy(Fgh.rankOf(v))
    elseif v.kind == "card" then
        return Rank.copy(Rank.TOP)
    elseif v.kind == "cap" then
        return Rank.copy(Rank.TOP)
    elseif v.kind == "finite" then
        local r = Impl.slogPartsFromFinite(math.abs(v.n))
        if r ~= nil then
            return r
        end
    end
    return Rank.copy(Rank.ZERO)
end

function Impl.getMantissa(v)
    if v.kind == "tower" then
        return v.m
    elseif v.kind == "named" or v.kind == "hyper" then
        return 1
    elseif v.kind == "card" then
        return 1
    elseif v.kind == "fgh" then
        return Impl.getMantissa(v.arg)
    elseif v.kind == "finite" then
        local _, m = Impl.slogPartsFromFinite(math.abs(v.n))
        if m ~= nil then
            return m
        end
        return math.abs(v.n)
    elseif v.kind == "cap" then
        return 9.999999999
    end
    return 0
end

function Impl.slogValue(v)
    if v.kind == "nan" or v.kind == "cap" then
        return CAP
    end
    if Impl.signOf(v) <= 0 then
        return NAN
    end
    local rank, m = Impl.partsFromPositive(Impl.magnitude(v))
    if rank == nil then
        return NAN
    end
    if Rank.isFinite(rank) then
        local h = Rank.finiteValue(rank)
        return Impl.finite(h + (m - 1) / 9)
    end
    return CAP
end

function Impl.logBase(v, base)
    local lv = Impl.log10Value(v)
    local lb = Impl.log10Value(base)
    if lv.kind == "nan" or lb.kind == "nan" then
        return NAN
    end
    return Impl.divValues(lv, lb)
end

function Impl.lnValue(v)
    return Impl.mulValues(Impl.log10Value(v), Impl.finite(LN10))
end

function Impl.expValue(v)
    if v.kind == "card" then
        -- e^kappa = 2^kappa for an infinite cardinal, so the beth ladder
        -- gives the answer directly.
        if v.sign > 0 then
            return Card.powerSet(v)
        end
        return ZERO
    end
    if v.kind == "named" or (v.kind == "hyper" and Hyper.anchorOf(v) ~= nil) then
        -- exp(v) is e^v, so it stays finite inside v's band like any power.
        return Impl.powValues(Impl.finite(math.exp(1)), v)
    end
    if v.kind == "hyper" then
        return v.sign > 0 and CAP or ZERO
    end
    return Impl.fromLog10Value(Impl.mulValues(v, Impl.finite(1 / LN10)))
end

function Impl.rootValue(v, n)
    local inv = Impl.divValues(ONE, Impl.asValue(n))
    return Impl.powValues(v, inv)
end

function Impl.hyperValue(level, a, b)
    level = tonumber(level)
    if level == nil or level < 0 then
        return NAN
    end
    if a.kind == "nan" or b.kind == "nan" then
        return NAN
    end
    level = math.floor(level)
    if level == 0 then
        return Impl.addValues(a, ONE)
    elseif level == 1 then
        return Impl.addValues(a, b)
    elseif level == 2 then
        return Impl.mulValues(a, b)
    elseif level == 3 then
        return Impl.powValues(a, b)
    elseif level == 4 then
        return Impl.tetrateValue(a, b)
    elseif level == 5 then
        return Impl.pentateValue(a, b)
    end
    -- Base identities hold at every level >= 3, even above the modelled range.
    if b.kind == "finite" then
        if b.n == 0 then
            return ONE
        elseif b.n == 1 then
            return Impl.copy(a)
        elseif b.n < 0 then
            return NAN
        end
    end
    if a.kind == "finite" and b.kind == "finite" then
        if a.n == 1 then
            return ONE
        elseif a.n == 2 and b.n == 2 then
            -- 2 ↑^n 2 = 4 at every level >= 3. Larger counts keep growing.
            return Impl.finite(4)
        end
    end
    if a.kind == "finite" and a.n == 1 then
        return ONE
    end
    if b.kind ~= "finite" then
        -- Finite-tier counts stay finite; transfinite counts still land in
        -- the tower tier instead of saturating at LIMIT.
        if Hyper.eligible(a) and Hyper.eligible(b) then
            return Hyper.new(level, a, b)
        end
        if b.kind == "tower" and not Rank.isFinite(b.rank) then
            return Impl.fromParts(Rank.OMEGA, 9)
        end
        return CAP
    end
    if level <= 12 and b.n <= 8 then
        local y = a
        local done = true
        for _ = 2, math.floor(b.n) do
            y = Impl.hyperValue(level - 1, a, y)
            if y.kind == "cap" or y.kind == "hyper" then
                done = false
                break
            elseif y.kind == "nan" then
                return NAN
            end
        end
        if done then
            return y
        end
    end
    -- Beyond the exact window the application itself is the finite value.
    if Hyper.eligible(a) and Hyper.eligible(b) then
        return Hyper.new(level, a, b)
    end
    return CAP
end

-- Nesting ------------------------------------------------------------------

-- A nest chain is one hyperoperation fed its own result:
-- H(level, base, H(level, base, ... H(level, base, base))). Applying
-- H(level, base, .) to the seed base depth times is exactly
-- H(level+1, base, depth+1) for every level >= 1, so a deep chain can be
-- carried and printed as one value instead of a tree of them. The innermost
-- argument has to be the base for the identity to hold, and a power,
-- coefficient or offset on any link makes the value something other than a
-- plain chain.
function Impl.nestInfo(v)
    if type(v) ~= "table" or v.kind ~= "hyper" or v.sign < 0 then
        return nil
    end
    if v.p ~= 1 or v.coef ~= 1 or v.off ~= 0 then
        return nil
    end
    local level = v.level
    local base = v.base
    local depth = 1
    local node = v.arg
    while node.kind == "hyper" and node.sign > 0 and node.level == level
        and node.p == 1 and node.coef == 1 and node.off == 0
        and Impl.compare(node.base, base) == 0 do
        depth = depth + 1
        node = node.arg
    end
    if Impl.compare(node, base) ~= 0 then
        return nil
    end
    return { level = level, base = Impl.copy(base), depth = depth, count = depth + 1 }
end

function Impl.nestValue(level, base, count)
    level = tonumber(level)
    if level == nil or not isfinite(level) or level ~= math.floor(level) or level < 1 then
        return NAN
    end
    local b = Impl.asValue(base)
    local c = Impl.asValue(count)
    if b.kind == "nan" or c.kind == "nan" then
        return NAN
    end
    return Impl.hyperValue(level + 1, b, c)
end

-- Rank lifts ---------------------------------------------------------------

function Impl.valuePartsForLift(v)
    local mag = Impl.magnitude(v)
    local rank, m = Impl.partsFromPositive(mag)
    if rank == nil then
        if mag.kind == "finite" then
            return Rank.ZERO, math.abs(mag.n)
        end
        return Rank.ZERO, 1
    end
    return rank, m
end

function Impl.lift(v, atomRank)
    if v.kind == "nan" then
        return NAN
    elseif v.kind == "cap" then
        return v.sign > 0 and CAP or NEG_CAP
    elseif v.kind == "named" then
        -- Lifting adds ordinal tower layers; a named value is already past
        -- the tower ladder, so the result saturates at LIMIT.
        return CAP
    elseif Impl.isZero(v) then
        return ZERO
    end
    local sign = Impl.signOf(v)
    local rank, m = Impl.valuePartsForLift(v)
    return Impl.canonical(sign, Rank.add(atomRank, rank), m)
end

function Impl.layerAdd(v, n)
    if v.kind == "nan" then
        return NAN
    elseif v.kind == "cap" then
        return v.sign > 0 and CAP or NEG_CAP
    end
    local nv = Impl.asValue(n)
    -- Zero (or clamped-negative) layers are the identity at every scale. Falling
    -- through would cap a named value and would round-trip a finite one via
    -- valuePartsForLift's log10, coming back strictly smaller.
    if nv.kind == "finite" and nv.n <= 0 then
        return Impl.copy(v)
    end
    if v.kind == "named" then
        return CAP
    elseif Impl.isZero(v) then
        return ZERO
    end
    local sign = Impl.signOf(v)
    local rank, m = Impl.valuePartsForLift(v)
    if nv.kind == "finite" then
        return Impl.canonical(sign, Rank.addFinite(rank, nv.n), m)
    elseif nv.kind == "cap" then
        return CAP
    end
    return Impl.canonical(sign, Rank.add(Rank.OMEGA, rank), m)
end

function Impl.rankFromAny(r)
    if type(r) == "number" then
        return Rank.addFinite(Rank.ZERO, r)
    elseif type(r) == "string" then
        local k = r:lower()
        if k == "0" or k == "zero" then
            return Rank.copy(Rank.ZERO)
        elseif k == "1" or k == "one" then
            return Rank.addFinite(Rank.ZERO, 1)
        elseif k == "omega" or k == "w" or k == "ω" then
            return Rank.copy(Rank.OMEGA)
        elseif k == "epsilon0" or k == "epsilon_0" or k == "eps0" or k == "ε0" or k == "ε₀" then
            return Rank.copy(Rank.EPS0)
        elseif k == "zeta0" or k == "zeta_0" or k == "ζ0" or k == "ζ₀" then
            return Rank.copy(Rank.ZETA0)
        elseif k == "eta0" or k == "eta_0" or k == "η0" or k == "η₀" then
            return Rank.copy(Rank.ETA0)
        elseif k == "gamma0" or k == "gamma_0" or k == "γ0" or k == "Γ₀" then
            return Rank.copy(Rank.GAMMA0)
        elseif k == "svo" then
            return Rank.copy(Rank.SVO)
        elseif k == "lvo" then
            return Rank.copy(Rank.LVO)
        end
        return Impl.parseRankString(r)
    elseif type(r) == "table" then
        if r._rank then
            return Rank.normalize(r)
        end
        if r.terms ~= nil then
            return Rank.normalize({ terms = r.terms, fin = r.fin or 0 })
        end
    end
    return nil
end

local RankAPI = {}

function RankAPI.phi(n)
    return Rank.normalize({
        terms = { { k = "phi", n = math.max(1, numfloor(tonumber(n) or 1)), c = 1 } },
        fin = 0,
    })
end

-- Gamma_n: the Feferman-Schutte family above Gamma_0, up to the rank ceiling.
function RankAPI.gamma(n)
    return Rank.normalize({
        terms = { { k = "gamma", n = math.max(0, numfloor(tonumber(n) or 0)), c = 1 } },
        fin = 0,
    })
end

function RankAPI.add(a, b)
    local ra = Impl.rankFromAny(a)
    local rb = Impl.rankFromAny(b)
    if ra == nil or rb == nil then
        return nil
    end
    return Rank.add(ra, rb)
end

function RankAPI.succ(a)
    local ra = Impl.rankFromAny(a)
    return ra and Rank.succ(ra) or nil
end

function RankAPI.pred(a)
    local ra = Impl.rankFromAny(a)
    return ra and Rank.pred(ra) or nil
end

function RankAPI.compare(a, b)
    local ra = Impl.rankFromAny(a)
    local rb = Impl.rankFromAny(b)
    if ra == nil or rb == nil then
        return nil
    end
    return Rank.compare(ra, rb)
end

function RankAPI.toString(a)
    local ra = Impl.rankFromAny(a)
    return ra and Rank.toString(ra) or "?"
end

function RankAPI.toTable(a)
    local ra = Impl.rankFromAny(a)
    return ra and Rank.toTable(ra) or nil
end

function RankAPI.fromTable(t)
    return Rank.fromTable(t)
end

function RankAPI.finite(n)
    return Rank.addFinite(Rank.ZERO, n)
end

function RankAPI.isFinite(a)
    local ra = Impl.rankFromAny(a)
    return ra ~= nil and Rank.isFinite(ra)
end

function RankAPI.isLimit(a)
    local ra = Impl.rankFromAny(a)
    return ra ~= nil and Rank.isLimit(ra)
end

RankAPI.zero = Rank.ZERO
RankAPI.one = Rank.addFinite(Rank.ZERO, 1)
RankAPI.omega = Rank.OMEGA
RankAPI.epsilon0 = Rank.EPS0
RankAPI.zeta0 = Rank.ZETA0
RankAPI.eta0 = Rank.ETA0
RankAPI.gamma0 = Rank.GAMMA0
RankAPI.svo = Rank.SVO
RankAPI.lvo = Rank.LVO

-- Public API ---------------------------------------------------------------

function ZubaNum.new(v)
    if v == nil then
        return NAN
    end
    local t = type(v)
    if t == "number" then
        return Impl.finite(v)
    elseif t == "string" then
        return Impl.parseString(v)
    elseif t == "table" then
        if Impl.isZuba(v) then
            return Impl.copy(v)
        end
        if v.__zuba == 1 then
            return Impl.fromTable(v)
        end
    end
    return NAN
end

function ZubaNum.fromNumber(n)
    if type(n) ~= "number" then
        n = tonumber(n)
    end
    if n == nil then
        return NAN
    end
    return Impl.finite(n)
end

function ZubaNum.fromString(s)
    if type(s) == "number" then
        return Impl.finite(s)
    end
    return Impl.parseString(s)
end

function ZubaNum.toSuffix(v, decimals)
    local x = Impl.asValue(v)
    if x.kind ~= "finite" then
        return Impl.format(x)
    end
    local n = x.n
    local neg = n < 0
    if neg then
        n = -n
    end
    if n < 1000 then
        return Impl.formatNumber(neg and -n or n)
    end
    local tier = Suffix.scaleOf(n)
    local text = Suffix.fixed(n / pow10(3 * tier), decimals)
    if tonumber(text) >= 1000 and Suffix.SHORT[3 * (tier + 1)] ~= nil then
        tier = tier + 1
        text = Suffix.fixed(n / pow10(3 * tier), decimals)
    end
    local abbr = Suffix.SHORT[3 * tier]
    if abbr == nil then
        return Impl.formatNumber(neg and -n or n)
    end
    return (neg and "-" or "") .. text .. abbr
end

function ZubaNum.fromSuffix(s)
    if type(s) == "number" then
        return Impl.finite(s)
    end
    if type(s) ~= "string" then
        return NAN
    end
    local t = s:gsub("^%s+", ""):gsub("%s+$", "")
    local sign = 1
    if t:sub(1, 1) == "+" then
        t = t:sub(2)
    elseif t:sub(1, 1) == "-" then
        sign = -1
        t = t:sub(2)
    end
    local v = Suffix.shortValue(t)
    if v == nil then
        return NAN
    end
    return sign < 0 and Impl.negate(v) or v
end

function ZubaNum.toName(v, decimals)
    local x = Impl.asValue(v)
    if x.kind == "finite" then
        local n = x.n
        local neg = n < 0
        if neg then
            n = -n
        end
        if n == 1e100 then
            return (neg and "-" or "") .. "googol"
        end
        if n < 1000 then
            return nil
        end
        local tier = Suffix.scaleOf(n)
        local text = Suffix.fixed(n / pow10(3 * tier), decimals)
        if tonumber(text) >= 1000 then
            tier = tier + 1
            text = Suffix.fixed(n / pow10(3 * tier), decimals)
        end
        local name = Suffix.illionName(tier)
        if name == nil then
            return nil
        end
        if text == "1" then
            return (neg and "-" or "") .. name
        end
        return (neg and "-" or "") .. text .. " " .. name
    elseif x.kind == "tower" then
        local prefix = x.sign < 0 and "-" or ""
        local h = Rank.finiteValue(x.rank)
        if h ~= nil and x.m == 2 then
            local name = Suffix.plexName(h - 2)
            if name ~= nil then
                return prefix .. name
            end
        end
        if x.sign < 0 or h == nil then
            return nil
        end
        -- An illion keeps its spelling however large its index grows, in either
        -- tier, so a tower built from centillion upward - or from mehectillion -
        -- names itself instead of falling back to scientific format. Past the
        -- cap the exponent is not one the ladder produces, and nil means "use
        -- format".
        local index = Suffix.illionIndexOfValue(x)
        if index == nil then
            return nil
        end
        local name = Suffix.illionName(index)
        if name == nil then
            return nil
        end
        return prefix .. name
    end
    return nil
end

function ZubaNum.fromName(s)
    if type(s) ~= "string" then
        return NAN
    end
    local t = s:gsub("^%s+", ""):gsub("%s+$", "")
    local sign = 1
    if t:sub(1, 1) == "+" then
        t = t:sub(2)
    elseif t:sub(1, 1) == "-" then
        sign = -1
        t = t:sub(2)
    end
    local v = Suffix.nameValue(t)
    if v == nil then
        return NAN
    end
    return sign < 0 and Impl.negate(v) or v
end

function ZubaNum.fromTable(t)
    return Impl.fromTable(t)
end

function ZubaNum.fromRank(rank, m, sign)
    local r = Impl.rankFromAny(rank)
    if r == nil then
        return NAN
    end
    local mant = m == nil and 1 or tonumber(m)
    if mant == nil then
        return NAN
    end
    return Impl.canonical(sign or 1, r, mant)
end

function ZubaNum.fromLog10(n)
    return Impl.fromLog10Value(Impl.asValue(n))
end

function ZubaNum.toLog10(v)
    return Impl.log10Value(Impl.asValue(v))
end

function ZubaNum.clone(v)
    return Impl.copy(Impl.asValue(v))
end

-- Constants

ZubaNum.ZERO = ZERO
ZubaNum.ONE = ONE
ZubaNum.TEN = TEN
ZubaNum.NAN = NAN
ZubaNum.GRAHAM = GRAHAM
ZubaNum.TREE3 = TREE3
ZubaNum.TREE4 = TREE4
ZubaNum.SSCG2 = SSCG2
ZubaNum.SSCG3 = SSCG3
ZubaNum.SSCG4 = SSCG4
ZubaNum.LOADER = LOADER
ZubaNum.BB5 = BB5
ZubaNum.BB6 = BB6
ZubaNum.RAYO = RAYO
ZubaNum.FISH7 = FISH7
ZubaNum.LIMIT = CAP
ZubaNum.MAX = CAP
ZubaNum.INFINITY = CAP
ZubaNum.NEG_LIMIT = NEG_CAP
ZubaNum.MIN = NEG_CAP
ZubaNum.MAX_TOWER = MAX_TOWER
ZubaNum.NEG_MAX_TOWER = NEG_MAX_TOWER
ZubaNum.MAX_SAFE = MAX_SAFE

function ZubaNum.tree(n)
    return Impl.treeValue(Impl.indexSource(n))
end

function ZubaNum.sscg(n)
    return Impl.sscgValue(Impl.indexSource(n))
end

function ZubaNum.loader(n)
    return Impl.loaderValue(Impl.indexSource(n))
end

function ZubaNum.bb(n)
    return Impl.bbValue(Impl.indexSource(n))
end

-- Every named constant comes from a family factory. Z.RAYO is
-- Z.rayo(1e100) (Rayo's number is Rayo(10^100)) and Z.FISH7 is Z.fish(7).
function ZubaNum.rayo(n)
    if n == nil then
        return Impl.copy(RAYO)
    end
    return Impl.rayoValue(Impl.indexSource(n))
end

function ZubaNum.fish(n)
    if n == nil then
        return Impl.copy(FISH7)
    end
    return Impl.fishValue(Impl.asValue(n))
end

function ZubaNum.fish7()
    return Impl.copy(FISH7)
end

-- Ackermann's function. A(0,n) = n+1 and A(m,n) = H_m(2, n+3) - 3 for m >= 1,
-- which the hyperoperation band already models, so every level is either exact
-- or a formal H value instead of a saturated ceiling.
function ZubaNum.ackermann(m, n)
    return Impl.ackermannValue(m, n)
end

ZubaNum.ack = ZubaNum.ackermann

-- Build any registered family by name, including one added at runtime. The
-- extra arguments after the index belong to families declared with params > 1.
function ZubaNum.family(name, index, ...)
    if type(name) ~= "string" then
        return NAN
    end
    local key = (name:gsub("%s+", "")):upper()
    local spec = Named.SPEC[key]
    if spec == nil then
        return NAN
    end
    if select("#", ...) ~= (spec.params or 1) - 1 then
        return NAN
    end
    return Named.make(key, index, { ... })
end

-- Register a named family. One row drives construction, ordering, formatting,
-- parsing and the exported factory, so a caller-supplied giant behaves exactly
-- like the built-in ones. Returns the canonical name, or nil and a reason.
function ZubaNum.defineFamily(spec)
    if type(spec) ~= "table" then
        return nil, "spec must be a table"
    end
    if type(spec.name) ~= "string" then
        return nil, "name must be a string"
    end
    local name = (spec.name:gsub("%s+", "")):upper()
    if not name:match("^%u[%u%d_]*$") then
        return nil, "name must start with a letter and use letters, digits or _"
    end
    if Named.SPEC[name] ~= nil then
        return nil, "family " .. name .. " is already defined"
    end
    local band = tonumber(spec.band)
    if band == nil or not isfinite(band) or band <= 0 or band ~= math.floor(band) then
        return nil, "band must be a positive integer"
    end
    for fam, b in pairs(Named.BASE_ORDER) do
        if b == band then
            return nil, "band " .. band .. " is already used by " .. fam
        end
    end
    local prefix = spec.prefix == nil and name or spec.prefix
    if type(prefix) ~= "string" or not prefix:match("^[%a%d]+$") then
        return nil, "prefix must be letters or digits"
    end
    local params = spec.params == nil and 1 or tonumber(spec.params)
    if params == nil or not isfinite(params) or params ~= math.floor(params)
        or params < 1 or params > 8 then
        return nil, "params must be an integer from 1 to 8"
    end
    local index = spec.index == nil and "integer" or spec.index
    if index ~= "none" and index ~= "integer" and index ~= "unbounded"
        and index ~= "fixed" then
        return nil, "index must be none, integer, unbounded or fixed"
    end
    if index == "none" and params > 1 then
        return nil, "a multi-parameter family needs an index"
    end
    local min = spec.min == nil and 0 or tonumber(spec.min)
    if min == nil or not isfinite(min) or min ~= math.floor(min) then
        return nil, "min must be an integer"
    end
    local row = {
        family = name,
        band = band,
        index = index,
        min = min,
        params = params,
        prefix = prefix,
        defined = true,
    }
    if index == "fixed" then
        local fixed = tonumber(spec.fixed)
        if fixed == nil or not isfinite(fixed) or fixed ~= math.floor(fixed)
            or fixed < min then
            return nil, "fixed must be an integer at or above min"
        end
        row.fixed = fixed
        row.default = fixed
    end
    if spec.default ~= nil then
        local d = tonumber(spec.default)
        if d == nil or not isfinite(d) or d ~= math.floor(d) or d < min then
            return nil, "default must be an integer at or above min"
        end
        row.default = d
    end
    local aliasList = {}
    if spec.aliases ~= nil then
        if type(spec.aliases) ~= "table" then
            return nil, "aliases must be a list of strings"
        end
        -- A bare spelling carries no arguments, so only a one-parameter family
        -- can have one.
        if params > 1 then
            return nil, "aliases need params = 1"
        end
        if row.default == nil and index ~= "none" then
            return nil, "aliases need a default index"
        end
        for i = 1, #spec.aliases do
            local a = spec.aliases[i]
            if type(a) ~= "string" then
                return nil, "aliases must be a list of strings"
            end
            a = (a:gsub("%s+", "")):lower()
            if not a:match("^[%l%d_%.]+$") then
                return nil, "alias must be lowercase letters, digits, _ or ."
            end
            if Named.ALIASES[a] ~= nil then
                return nil, "alias " .. a .. " is already taken"
            end
            aliasList[#aliasList + 1] = a
        end
    end
    local heads = spec.call
    if heads == nil then
        heads = { prefix:lower() }
    elseif type(heads) ~= "table" then
        return nil, "call must be a string or a list of strings"
    end
    local callList = {}
    for i = 1, #heads do
        local h = heads[i]
        if type(h) ~= "string" then
            return nil, "call must be a string or a list of strings"
        end
        h = (h:gsub("%s+", "")):lower()
        if not h:match("^[%l%d_]+$") then
            return nil, "call spelling must be lowercase letters or digits"
        end
        if Named.CALL[h] ~= nil then
            return nil, "call spelling " .. h .. " is already taken"
        end
        callList[#callList + 1] = h
    end
    local factory = nil
    if spec.factory ~= nil then
        if type(spec.factory) ~= "string" then
            return nil, "factory must be a string"
        end
        factory = (spec.factory:gsub("%s+", ""))
        if not factory:match("^%l[%a%d]*$") then
            return nil, "factory must start with a lowercase letter"
        end
        if ZubaNum[factory] ~= nil then
            return nil, "factory " .. factory .. " is already taken"
        end
    end
    -- Validation is finished, so the row and its spellings land together.
    Named.FAMILIES[#Named.FAMILIES + 1] = row
    table.sort(Named.FAMILIES, function(x, y)
        return x.band < y.band
    end)
    Named.SPEC[name] = row
    Named.BASE_ORDER[name] = band
    local floor = row.fixed or min
    for i = 1, #aliasList do
        Named.ALIASES[aliasList[i]] = { name, row.default }
        Named.widenGate(aliasList[i])
    end
    for i = 1, #callList do
        Named.CALL[callList[i]] = { name, floor }
        Named.widenGate(callList[i])
    end
    Named.widenGate(prefix)
    if factory ~= nil then
        ZubaNum[factory] = function(ix, ...)
            if select("#", ...) ~= params - 1 then
                return NAN
            end
            return Named.make(name, ix, { ... })
        end
    end
    return name
end

function ZubaNum.familyInfo(name)
    if type(name) ~= "string" then
        return nil
    end
    local spec = Named.SPEC[(name:gsub("%s+", "")):upper()]
    if spec == nil then
        return nil
    end
    local aliases, calls = {}, {}
    for a, target in pairs(Named.ALIASES) do
        if target[1] == spec.family then
            aliases[#aliases + 1] = a
        end
    end
    for h, target in pairs(Named.CALL) do
        if target[1] == spec.family then
            calls[#calls + 1] = h
        end
    end
    table.sort(aliases)
    table.sort(calls)
    return {
        family = spec.family,
        band = spec.band,
        index = spec.index,
        min = spec.min,
        params = spec.params or 1,
        prefix = spec.prefix or spec.family,
        default = spec.default,
        fixed = spec.fixed,
        aliases = aliases,
        call = calls,
    }
end

-- Every registered family, ordered by band.
function ZubaNum.families()
    local out = {}
    for i = 1, #Named.FAMILIES do
        out[i] = ZubaNum.familyInfo(Named.FAMILIES[i].family)
    end
    return out
end

-- Cardinals and the fast-growing hierarchy

function ZubaNum.aleph(idx)
    if idx == nil then
        return Impl.copy(ALEPH0)
    end
    local i = Idx.fromArg(idx)
    if i == nil then
        return NAN
    end
    return Card.plain("aleph", i, 1)
end

function ZubaNum.beth(idx)
    if idx == nil then
        return Impl.copy(BETH0)
    end
    local i = Idx.fromArg(idx)
    if i == nil then
        return NAN
    end
    return Card.plain("beth", i, 1)
end

local function fixedPointOf(op, n)
    local i = Idx.fromArg(n == nil and 1 or n)
    if i == nil then
        return NAN
    end
    return Card.fixed(op, i, 1)
end

function ZubaNum.alephFixed(n)
    return fixedPointOf("aleph", n)
end

function ZubaNum.bethFixed(n)
    return fixedPointOf("beth", n)
end

function ZubaNum.cardSucc(v)
    return Card.cardSucc(Impl.asValue(v))
end

ZubaNum.nextCardinal = ZubaNum.cardSucc

function ZubaNum.fgh(alpha, n)
    local i = Idx.fromArg(alpha)
    if i == nil then
        return NAN
    end
    local k = Impl.asValue(n)
    if k.kind == "nan" then
        return NAN
    end
    return Fgh.create(i, k)
end

-- Hardy hierarchy value H_alpha(n + base). A finite level is exact addition;
-- a transfinite level stays formal and orders below f_alpha at the same index.
function ZubaNum.hardy(alpha, n, base)
    local i = Idx.fromArg(alpha)
    if i == nil then
        return NAN
    end
    return Fgh.hardy(i, Impl.asValue(n), base)
end

function ZubaNum.isHardy(v)
    return type(v) == "table" and v.kind == "fgh" and v.mode == "hardy"
end

function ZubaNum.isCard(v)
    return type(v) == "table" and v.kind == "card"
end

function ZubaNum.isFgh(v)
    return type(v) == "table" and v.kind == "fgh" and v.mode ~= "hardy"
end

-- op, mode, index table, sign. mode is "plain" for aleph_alpha / beth_alpha
-- and "fp" for the n-th fixed point of that ladder.
function ZubaNum.getCard(v)
    local x = Impl.asValue(v)
    if x.kind ~= "card" then
        return nil
    end
    return x.op, x.mode, Idx.toTable(x.idx), x.sign
end

-- index table, argument, sign, mode. mode is nil for a fast-growing f value
-- and "hardy" for an H value.
function ZubaNum.getFgh(v)
    local x = Impl.asValue(v)
    if x.kind ~= "fgh" then
        return nil
    end
    return Idx.toTable(x.idx), Impl.copy(x.arg), x.sign, x.mode
end

ZubaNum.ALEPH0 = ALEPH0
ZubaNum.ALEPH1 = ALEPH1
ZubaNum.ALEPH2 = ALEPH2
ZubaNum.ALEPH3 = ALEPH3
ZubaNum.ALEPH_OMEGA = ALEPH_OMEGA
ZubaNum.BETH0 = BETH0
ZubaNum.BETH1 = BETH1
ZubaNum.ALEPH_FIXED1 = ALEPH_FP1

-- Comparison

function ZubaNum.cmp(a, b)
    return Impl.compare(Impl.asValue(a), Impl.asValue(b))
end

ZubaNum.compare = ZubaNum.cmp

function ZubaNum.eq(a, b)
    return Impl.compare(Impl.asValue(a), Impl.asValue(b)) == 0
end

function ZubaNum.ne(a, b)
    local c = Impl.compare(Impl.asValue(a), Impl.asValue(b))
    return c == nil or c ~= 0
end

function ZubaNum.lt(a, b)
    local c = Impl.compare(Impl.asValue(a), Impl.asValue(b))
    return c ~= nil and c < 0
end

function ZubaNum.lte(a, b)
    local c = Impl.compare(Impl.asValue(a), Impl.asValue(b))
    return c ~= nil and c <= 0
end

ZubaNum.le = ZubaNum.lte

function ZubaNum.gt(a, b)
    local c = Impl.compare(Impl.asValue(a), Impl.asValue(b))
    return c ~= nil and c > 0
end

function ZubaNum.gte(a, b)
    local c = Impl.compare(Impl.asValue(a), Impl.asValue(b))
    return c ~= nil and c >= 0
end

ZubaNum.ge = ZubaNum.gte

local function minMaxCompare(a, b)
    local c = Impl.compare(a, b)
    if c ~= nil then
        return c
    end
    -- ZFC cannot order some cardinal pairs, but min and max still have to
    -- return one of them, so the deterministic subscript ordering decides.
    if a.kind == "card" and b.kind == "card" then
        return Card.compareDefinite(Impl.magnitude(a), Impl.magnitude(b))
    end
    return nil
end

function ZubaNum.min(a, b)
    local c = minMaxCompare(Impl.asValue(a), Impl.asValue(b))
    if c == nil then
        return NAN
    end
    return c <= 0 and Impl.asValue(a) or Impl.asValue(b)
end

function ZubaNum.max(a, b)
    local c = minMaxCompare(Impl.asValue(a), Impl.asValue(b))
    if c == nil then
        return NAN
    end
    return c >= 0 and Impl.asValue(a) or Impl.asValue(b)
end

-- v held inside [lo, hi]. NaN on any side is NaN, and so is an inverted
-- range: passing a value straight through would hide a swapped pair of
-- bounds rather than reporting the mistake.
function ZubaNum.clamp(v, lo, hi)
    local x = Impl.asValue(v)
    local a = Impl.asValue(lo)
    local b = Impl.asValue(hi)
    if x.kind == "nan" or a.kind == "nan" or b.kind == "nan" then
        return NAN
    end
    local order = ZubaNum.cmp(a, b)
    if order ~= nil and order > 0 then
        return NAN
    end
    return ZubaNum.min(ZubaNum.max(x, a), b)
end

function ZubaNum.isNaN(v)
    return Impl.asValue(v).kind == "nan"
end

ZubaNum.isNan = ZubaNum.isNaN

function ZubaNum.isFinite(v)
    local x = Impl.asValue(v)
    if x.kind == "finite" or x.kind == "named" or x.kind == "hyper" then
        return true
    end
    return x.kind == "tower" and Rank.isFinite(x.rank)
end

function ZubaNum.isTower(v)
    return Impl.asValue(v).kind == "tower"
end

function ZubaNum.isNamed(v)
    return Impl.asValue(v).kind == "named"
end

function ZubaNum.isHyper(v)
    return Impl.asValue(v).kind == "hyper"
end

function ZubaNum.getHyper(v)
    local x = Impl.asValue(v)
    if x.kind ~= "hyper" then
        return nil
    end
    return x.level, Impl.copy(x.base), Impl.copy(x.arg)
end

-- Named constant whose band an H(level, base, arg) value is ordered inside.
-- Plain finite-tier hyper values have no anchor.
function ZubaNum.getAnchor(v)
    local x = Impl.asValue(v)
    if x.kind ~= "hyper" then
        return nil
    end
    local anchor = Hyper.anchorOf(x)
    return anchor and Impl.copy(anchor) or nil
end

ZubaNum.isMega = ZubaNum.isNamed

function ZubaNum.isCap(v)
    return Impl.asValue(v).kind == "cap"
end

ZubaNum.isCeiling = ZubaNum.isCap

function ZubaNum.isZero(v)
    return Impl.isZero(Impl.asValue(v))
end

function ZubaNum.isZuba(v)
    return Impl.isZuba(v)
end

function ZubaNum.getKind(v)
    return Impl.asValue(v).kind or "nan"
end

function ZubaNum.getSign(v)
    return Impl.signOf(Impl.asValue(v)) or 0
end

-- 1 finite, 1.5 plain hyper band, 2 named mega, 3 hierarchy and infinite-rank
-- towers, 4 cardinals, 5 LIMIT.
function ZubaNum.tierOf(v)
    local value = Impl.asValue(v)
    if value.kind == "nan" then
        return nil
    end
    return Impl.tierOf(value)
end

function ZubaNum.getFamily(v)
    local value = Impl.asValue(v)
    if value.kind == "named" then
        return value.family
    end
    if value.kind == "card" then
        return value.op == "beth" and "BETH" or "ALEPH"
    end
    if value.kind == "fgh" then
        return value.mode == "hardy" and "HARDY" or "FGH"
    end
    return nil
end

-- Arithmetic

function ZubaNum.add(a, b)
    return Impl.addValues(Impl.asValue(a), Impl.asValue(b))
end

function ZubaNum.sub(a, b)
    return Impl.subValues(Impl.asValue(a), Impl.asValue(b))
end

function ZubaNum.mul(a, b)
    return Impl.mulValues(Impl.asValue(a), Impl.asValue(b))
end

function ZubaNum.div(a, b)
    return Impl.divValues(Impl.asValue(a), Impl.asValue(b))
end

function ZubaNum.neg(v)
    return Impl.negate(Impl.asValue(v))
end

ZubaNum.negate = ZubaNum.neg

function ZubaNum.abs(v)
    local x = Impl.asValue(v)
    local s = Impl.signOf(x)
    if s == nil then
        return NAN
    elseif s < 0 then
        return Impl.negate(x)
    end
    return Impl.copy(x)
end

function ZubaNum.pow(a, b)
    return Impl.powValues(Impl.asValue(a), Impl.asValue(b))
end

ZubaNum.power = ZubaNum.pow

function ZubaNum.mod(a, b)
    local x = Impl.asValue(a)
    local y = Impl.asValue(b)
    if x.kind == "nan" or y.kind == "nan" then
        return NAN
    end
    if y.kind == "cap" then
        return x.kind == "cap" and ZERO or Impl.copy(x)
    end
    if x.kind == "cap" then
        return NAN
    end
    if y.kind == "finite" and y.n == 0 then
        return NAN
    end
    if x.kind == "finite" and y.kind == "finite" then
        return Impl.finite(x.n % y.n)
    end
    local c = Impl.compare(x, y)
    if c == nil then
        return NAN
    end
    if c < 0 then
        return Impl.copy(x)
    elseif c == 0 then
        return ZERO
    end
    -- Above tower precision the remainder is below representable resolution.
    return ZERO
end

-- Folds any number of arguments with + and *, each starting from the identity
-- of its operator, so Z.sum() is 0, Z.product() is 1 and an empty bundle costs
-- nothing without a special case at the call site.
function ZubaNum.sum(...)
    local args = table.pack(...)
    local acc = ZERO
    for i = 1, args.n do
        acc = Impl.addValues(acc, Impl.asValue(args[i]))
    end
    return acc
end

function ZubaNum.product(...)
    local args = table.pack(...)
    local acc = ONE
    for i = 1, args.n do
        acc = Impl.mulValues(acc, Impl.asValue(args[i]))
    end
    return acc
end

-- n! for a non-negative integer double. The product is exact while it still
-- fits a double, which is every n up to 170; past that Stirling's series on
-- ln(n!) carries the value, so 1000! leaves the finite tier as a tower
-- instead of overflowing to NaN. Fractions, negatives, named values, LIMIT
-- and NaN have no factorial here and give NaN, and 1e15 is the cut-off
-- because the series itself stops being meaningful past a double's grip on n.
function ZubaNum.factorial(v)
    local x = Impl.asValue(v)
    if x.kind ~= "finite" then
        return NAN
    end
    local n = x.n
    if n < 0 or n ~= math.floor(n) or n > 1e15 then
        return NAN
    end
    if n <= 170 then
        local acc = 1
        for k = 2, n do
            acc = acc * k
        end
        return Impl.finite(acc)
    end
    local n3 = n * n * n
    local lnFact = (n + 0.5) * math.log(n) - n + 0.5 * math.log(2 * math.pi)
        + 1 / (12 * n) - 1 / (360 * n3) + 1 / (1260 * n3 * n * n)
    return Impl.fromLog10Value(Impl.finite(lnFact / LN10))
end

function ZubaNum.floor(v)
    local x = Impl.asValue(v)
    if x.kind ~= "finite" then
        return Impl.copy(x)
    end
    return Impl.finite(math.floor(x.n))
end

function ZubaNum.ceil(v)
    local x = Impl.asValue(v)
    if x.kind ~= "finite" then
        return Impl.copy(x)
    end
    return Impl.finite(math.ceil(x.n))
end

function ZubaNum.round(v)
    local x = Impl.asValue(v)
    if x.kind ~= "finite" then
        return Impl.copy(x)
    end
    if x.n >= 0 then
        return Impl.finite(math.floor(x.n + 0.5))
    end
    return Impl.finite(math.ceil(x.n - 0.5))
end

function ZubaNum.succ(v)
    return Impl.addValues(Impl.asValue(v), ONE)
end

function ZubaNum.pred(v)
    return Impl.subValues(Impl.asValue(v), ONE)
end

-- Exponentials, logs, roots

function ZubaNum.log10(v)
    return Impl.log10Value(Impl.asValue(v))
end

function ZubaNum.ln(v)
    return Impl.lnValue(Impl.asValue(v))
end

function ZubaNum.log(v, base)
    local x = Impl.asValue(v)
    if base == nil then
        return Impl.log10Value(x)
    end
    return ZubaNum.logBase(x, base)
end

function ZubaNum.logBase(v, base)
    local b = Impl.asValue(base)
    if b.kind ~= "finite" or b.n <= 0 or b.n == 1 then
        return NAN
    end
    return Impl.logBase(Impl.asValue(v), b)
end

function ZubaNum.exp(v)
    return Impl.expValue(Impl.asValue(v))
end

function ZubaNum.sqrt(v)
    return ZubaNum.root(v, 2)
end

function ZubaNum.root(v, n)
    local x = Impl.asValue(v)
    local k = Impl.asValue(n)
    if k.kind == "nan" or x.kind == "nan" or (k.kind == "finite" and k.n == 0) then
        return NAN
    end
    if Impl.signOf(x) < 0 and k.kind == "finite"
        and k.n == math.floor(k.n) and math.abs(k.n) % 2 == 1 then
        return Impl.negate(Impl.rootValue(Impl.negate(x), k))
    end
    return Impl.rootValue(x, k)
end

function ZubaNum.slog(v)
    return Impl.slogValue(Impl.asValue(v))
end

-- Decimal digits in the integer part of |v|. A double is measured against the
-- exact powers of ten instead of a logarithm, so 999 gives 3 and 1000 gives 4
-- with no rounding window. A tower and LIMIT answer floor(log10 v) + 1, and
-- the scales whose logarithm the library refuses to invent - named, hyper,
-- cardinal, hierarchy and NaN - have no digit count either.
function ZubaNum.digits(v)
    local x = Impl.asValue(v)
    if x.kind == "finite" then
        local n = math.abs(x.n)
        if n == 0 then
            return ONE
        end
        -- Counting from the logarithm alone lands a digit off at a power of
        -- ten, because the last unit can fall on either side of it, so the
        -- estimate is corrected against the exactly rounded power. Repeated
        -- multiplication is not usable as the ruler: it drifts past 10^22.
        local e = numfloor(log10(n))
        if n < pow10(e) then
            e = e - 1
        elseif n >= pow10(e + 1) then
            e = e + 1
        end
        local k = e + 1
        return Impl.finite(k > 1 and k or 1)
    elseif x.kind == "tower" or x.kind == "cap" then
        return ZubaNum.add(ZubaNum.floor(ZubaNum.log10(x)), 1)
    end
    return NAN
end

-- Hyperoperations and lifts

function ZubaNum.tetrate(v, count)
    return Impl.tetrateValue(Impl.asValue(v), Impl.asValue(count))
end

function ZubaNum.pentation(v, count)
    return Impl.pentateValue(Impl.asValue(v), Impl.asValue(count))
end

function ZubaNum.hyperoperation(level, a, b)
    local lv = tonumber(level)
    if lv == nil then
        return NAN
    end
    return Impl.hyperValue(lv, Impl.asValue(a), Impl.asValue(b))
end

ZubaNum.hyper = ZubaNum.hyperoperation

function ZubaNum.arrow(a, b, arrows)
    arrows = arrows == nil and 2 or tonumber(arrows)
    if arrows == nil or arrows < 0 then
        return NAN
    end
    return Impl.hyperValue(math.floor(arrows) + 2, Impl.asValue(a), Impl.asValue(b))
end

-- The exact Knuth spelling of a value, or nil when it has none. Only a plain
-- one-link chain H(l, b, b) whose two operands are doubles qualifies, which is
-- what nestInfo reports at depth 1, and k arrows are level k + 2. Chains that
-- expand all the way to a double or a tower, chains carrying a power,
-- coefficient or offset, anchored named chains and non-numeric operands all
-- give nil rather than a spelling that does not roundtrip.
function ZubaNum.toArrow(v)
    local x = Impl.asValue(v)
    local info = Impl.nestInfo(x)
    if info == nil or info.depth ~= 1 or info.level < 4 then
        return nil
    end
    local base = info.base
    local arg = x.arg
    if base.kind ~= "finite" or arg.kind ~= "finite" then
        return nil
    end
    return Impl.formatNumber(base.n) .. string.rep("^", info.level - 2)
        .. Impl.formatNumber(arg.n)
end

-- H(level, base, .) applied count times to the seed base. That chain is exactly
-- H(level+1, base, count) for every level >= 1, so a nest of any depth costs
-- one value: Z.nest(3, 2, 3) is 2^(2^2) = 16 and Z.nest(6, 2, 100) is a single
-- H(7, 2, 100).
function ZubaNum.nest(level, base, count)
    return Impl.nestValue(level, base, count)
end

-- The chain a hyper value is, or nil when it is not one. A power, coefficient
-- or offset on any link breaks it, and so does an innermost argument that is
-- not the base: H(3, 2, H(3, 2, 5)) grows from 5, not from 2.
function ZubaNum.nestInfo(v)
    return Impl.nestInfo(Impl.asValue(v))
end

-- Number of nested links, or 0 for anything that is not a nest chain.
function ZubaNum.nestDepth(v)
    local info = Impl.nestInfo(Impl.asValue(v))
    return info ~= nil and info.depth or 0
end

local SCALE_NAMES = {
    [1] = "finite",
    [1.5] = "hyper",
    [2] = "named",
    [3] = "ordinal",
    [4] = "cardinal",
    [5] = "limit",
}

-- How many whole units of cost fit inside budget, and what is left over, so a
-- game loop can price an upgrade at any scale the library models and still
-- print an answer. precise says whether count and remainder are the true
-- integers: that needs both sides to be doubles inside MAX_SAFE. Above that,
-- and across scales, Z.div follows the library's absorption convention -
-- TREE(4) / TREE(3) is TREE(4), not a ratio - so exact then describes the model
-- rather than the real quotient. Returns nil when budget or cost is NaN or cost
-- is not positive.
function ZubaNum.spend(budget, cost)
    local b = Impl.asValue(budget)
    local c = Impl.asValue(cost)
    if b.kind == "nan" or c.kind == "nan" or Impl.signOf(c) <= 0 then
        return nil
    end
    local precise = b.kind == "finite" and c.kind == "finite"
        and math.abs(b.n) <= MAX_SAFE and math.abs(c.n) <= MAX_SAFE
    if Impl.signOf(b) <= 0 then
        return {
            count = Impl.copy(ZERO),
            remainder = Impl.copy(b),
            exact = Impl.isZero(b),
            scale = "finite",
            precise = precise,
        }
    end
    local count = ZubaNum.floor(Impl.divValues(b, c))
    local rem = Impl.subValues(b, Impl.mulValues(count, c))
    return {
        count = count,
        remainder = rem,
        exact = Impl.isZero(rem),
        scale = SCALE_NAMES[Impl.tierOf(count)] or "finite",
        precise = precise,
    }
end

-- BEAF linear array. Accepts the entries as arguments, as one array table,
-- or as one spelling: "{10, 10, 3}", "10->->10", "3->3->3".
function ZubaNum.beaf(...)
    local args = table.pack(...)
    if args.n == 0 then
        return ONE
    end
    local first = args[1]
    if args.n == 1 and type(first) == "string" then
        local parsed = Beaf.parse(first)
        if parsed ~= nil then
            return parsed
        end
    end
    local list = args
    if args.n == 1 and type(first) == "table" and not Impl.isZuba(first) then
        list = first
    end
    local entries = {}
    for i = 1, #list do
        local v = Impl.asValue(list[i])
        if v.kind == "nan" then
            return NAN
        end
        entries[i] = v
    end
    return Beaf.eval(entries)
end

function ZubaNum.toBEAF(v)
    local x = Impl.asValue(v)
    local text = Beaf.toText(x)
    if text == nil then
        return Impl.format(x)
    end
    return text
end

-- Hyper-E. `fromHyperE` reads "100E100", "E100#2", "E100##100" and the bare
-- "ee100" forms, and `fromString` routes the same spellings; `toHyperE` writes
-- the compact E-form of a value, falling back to the default formatter where
-- the notation has no reading. `hyperE(a, b, hyperions, count)` builds a ×
-- 10^b followed by a run of `hyperions` applied `count` times.
function ZubaNum.fromHyperE(s)
    local parsed = HyperE.parse(s)
    if parsed == nil then
        return NAN
    end
    return parsed
end

function ZubaNum.toHyperE(v)
    local x = Impl.asValue(v)
    local text = HyperE.toText(x)
    if text == nil then
        return Impl.format(x)
    end
    return text
end

function ZubaNum.hyperE(a, b, hyperions, count)
    local h = hyperions == nil and 0 or tonumber(hyperions)
    if h == nil or h < 0 or h ~= numfloor(h) or h > 1e6 then
        return NAN
    end
    local av = Impl.asValue(a)
    local bv = Impl.asValue(b)
    if av.kind == "nan" or bv.kind == "nan" then
        return NAN
    end
    local cv
    if count == nil then
        cv = Impl.finite(h + 1)
    else
        cv = Impl.asValue(count)
        if cv.kind == "nan" or (cv.kind == "finite" and cv.n < 0)
            or Impl.signOf(cv) < 0 then
            return NAN
        end
        if cv.kind == "finite" and cv.n ~= numfloor(cv.n) then
            return NAN
        end
    end
    return HyperE.eval(av, bv, h, cv)
end

-- The -ote family grid: every registry token is callable as a factory, so
-- Z.expande(10, 2), Z.h11(10, 2) and Z.hyperFamily("expande", 10, 2) are the
-- same value. Level ω is aperiote, ω+1 is expande, and the codes read as the
-- Cantor-normal-form digits of the level.
function ZubaNum.hyperFamily(family, x, y)
    local spec = type(family) == "string" and Grid.BY_TOKEN[family:lower()] or nil
    if spec == nil then
        return NAN
    end
    return Grid.eval(spec, Impl.asValue(x), Impl.asValue(y))
end

for i = 1, #Grid.SPECS do
    local spec = Grid.SPECS[i]
    local function make(entry)
        return function(x, y)
            return Grid.eval(entry, Impl.asValue(x), Impl.asValue(y))
        end
    end
    ZubaNum[spec.name] = make(spec)
    ZubaNum[spec.short] = make(spec)
    ZubaNum[spec.code] = make(spec)
end

function ZubaNum.lift(v, rank)
    local r = Impl.rankFromAny(rank)
    if r == nil then
        return NAN
    end
    return Impl.lift(Impl.asValue(v), r)
end

function ZubaNum.layerAdd(v, n)
    return Impl.layerAdd(Impl.asValue(v), Impl.asValue(n))
end

function ZubaNum.omegaTower(v)
    return Impl.lift(Impl.asValue(v), Rank.OMEGA)
end

function ZubaNum.epsilonTower(v)
    return Impl.lift(Impl.asValue(v), Rank.EPS0)
end

function ZubaNum.zetaTower(v)
    return Impl.lift(Impl.asValue(v), Rank.ZETA0)
end

function ZubaNum.etaTower(v)
    return Impl.lift(Impl.asValue(v), Rank.ETA0)
end

function ZubaNum.phiTower(v, n)
    return Impl.lift(Impl.asValue(v), RankAPI.phi(n))
end

function ZubaNum.gammaTower(v)
    return Impl.lift(Impl.asValue(v), Rank.GAMMA0)
end

function ZubaNum.svoTower(v)
    return Impl.lift(Impl.asValue(v), Rank.SVO)
end

function ZubaNum.lvoTower(v)
    return Impl.lift(Impl.asValue(v), Rank.LVO)
end

-- Tower lifts at the ordinals above LVO, generated from one table so the
-- exported names stay in step with the rank ladder.
local LIFT_ATOMS = {
    { "gammaOmega", Rank.GAMMA_OMEGA }, { "bho", Rank.BHO }, { "sbo", Rank.SBO },
    { "lbo", Rank.LBO }, { "tfb", Rank.TFB }, { "ebho", Rank.EBHO },
    { "weakInaccessible", Rank.WEAK_INV }, { "weakMahlo", Rank.WEAK_MAHLO },
    { "weakCompact", Rank.WEAK_COMPACT },
}
for i = 1, #LIFT_ATOMS do
    local apiName = LIFT_ATOMS[i][1] .. "Tower"
    local atomRankValue = LIFT_ATOMS[i][2]
    ZubaNum[apiName] = function(v)
        return Impl.lift(Impl.asValue(v), atomRankValue)
    end
end

-- Introspection and conversion

function ZubaNum.getRank(v)
    return Impl.getRank(Impl.asValue(v))
end

function ZubaNum.getMantissa(v)
    return Impl.getMantissa(Impl.asValue(v))
end

function ZubaNum.toNumber(v)
    return Impl.toNumber(Impl.asValue(v))
end

function ZubaNum.toTable(v)
    return Impl.toTable(Impl.asValue(v))
end

function ZubaNum.toJSON(v, asString)
    local data = Impl.toTable(Impl.asValue(v))
    if asString then
        local ok, encoded = pcall(function()
            return game:GetService("HttpService"):JSONEncode(data)
        end)
        if ok and type(encoded) == "string" then
            return encoded
        end
    end
    return data
end

function ZubaNum.fromJSON(data)
    if type(data) == "string" then
        local ok, decoded = pcall(function()
            return game:GetService("HttpService"):JSONDecode(data)
        end)
        if not ok then
            return NAN
        end
        data = decoded
    end
    return Impl.fromTable(data)
end

ZubaNum.serialize = ZubaNum.toJSON
ZubaNum.deserialize = ZubaNum.fromJSON

function ZubaNum.format(v, style)
    return Impl.format(Impl.asValue(v), style)
end

ZubaNum.toString = ZubaNum.format

function ZubaNum.parse(s)
    return Impl.parseString(s)
end

-- Rank helpers

function RankAPI.fromString(s)
    return Impl.rankFromAny(s)
end

function RankAPI.fromAny(r)
    return Impl.rankFromAny(r)
end

RankAPI.ceiling = Rank.TOP
RankAPI.ZERO = Rank.ZERO
RankAPI.OMEGA = Rank.OMEGA
RankAPI.EPS0 = Rank.EPS0
RankAPI.ZETA0 = Rank.ZETA0
RankAPI.ETA0 = Rank.ETA0
RankAPI.GAMMA0 = Rank.GAMMA0
RankAPI.GAMMA_OMEGA = Rank.GAMMA_OMEGA
RankAPI.SVO = Rank.SVO
RankAPI.LVO = Rank.LVO
RankAPI.BHO = Rank.BHO
RankAPI.SBO = Rank.SBO
RankAPI.LBO = Rank.LBO
RankAPI.TFB = Rank.TFB
RankAPI.EBHO = Rank.EBHO
RankAPI.WEAK_INV = Rank.WEAK_INV
RankAPI.WEAK_MAHLO = Rank.WEAK_MAHLO
RankAPI.WEAK_COMPACT = Rank.WEAK_COMPACT
RankAPI.TOP = Rank.TOP

ZubaNum.Rank = RankAPI
ZubaNum.Ordinal = RankAPI

-- Metamethods

ZubaNum.__add = function(a, b)
    return Impl.addValues(Impl.asValue(a), Impl.asValue(b))
end

ZubaNum.__sub = function(a, b)
    return Impl.subValues(Impl.asValue(a), Impl.asValue(b))
end

ZubaNum.__mul = function(a, b)
    return Impl.mulValues(Impl.asValue(a), Impl.asValue(b))
end

ZubaNum.__div = function(a, b)
    return Impl.divValues(Impl.asValue(a), Impl.asValue(b))
end

ZubaNum.__mod = function(a, b)
    return ZubaNum.mod(a, b)
end

ZubaNum.__pow = function(a, b)
    return Impl.powValues(Impl.asValue(a), Impl.asValue(b))
end

ZubaNum.__unm = function(a)
    return Impl.negate(Impl.asValue(a))
end

ZubaNum.__eq = function(a, b)
    return Impl.compare(Impl.asValue(a), Impl.asValue(b)) == 0
end

ZubaNum.__lt = function(a, b)
    local c = Impl.compare(Impl.asValue(a), Impl.asValue(b))
    return c ~= nil and c < 0
end

ZubaNum.__le = function(a, b)
    local c = Impl.compare(Impl.asValue(a), Impl.asValue(b))
    return c ~= nil and c <= 0
end

ZubaNum.__tostring = function(a)
    return Impl.format(Impl.asValue(a))
end

ZubaNum.__concat = function(a, b)
    local sa = Impl.isZuba(a) and Impl.format(a) or tostring(a)
    local sb = Impl.isZuba(b) and Impl.format(b) or tostring(b)
    return sa .. sb
end

setmetatable(ZubaNum, {
    __call = function(_, v)
        return ZubaNum.new(v)
    end,
})

-- Freeze shared constants so accidental field writes cannot corrupt the
-- library's canonical zero/nan/cap values or the ordinal constants.
if table.freeze then
    local valueConstants = {
        ZERO, ONE, TEN, NAN, CAP, NEG_CAP, MAX_TOWER, NEG_MAX_TOWER,
        GRAHAM, TREE3, TREE4, SSCG2, SSCG3, SSCG4, LOADER, BB5, BB6,
        RAYO, FISH7,
        ALEPH0, ALEPH1, ALEPH2, ALEPH3, ALEPH_OMEGA, ALEPH_FP1,
        BETH0, BETH1,
    }
    for i = 1, #valueConstants do
        table.freeze(valueConstants[i])
    end
    local rankConstants = {
        Rank.ZERO, Rank.OMEGA, Rank.EPS0, Rank.ZETA0, Rank.ETA0,
        Rank.GAMMA0, Rank.GAMMA_OMEGA, Rank.SVO, Rank.LVO, Rank.BHO,
        Rank.SBO, Rank.LBO, Rank.TFB, Rank.EBHO, Rank.WEAK_INV,
        Rank.WEAK_MAHLO, Rank.WEAK_COMPACT, RankAPI.one,
    }
    for i = 1, #rankConstants do
        local r = rankConstants[i]
        for j = 1, #r.terms do
            table.freeze(r.terms[j])
        end
        table.freeze(r.terms)
        table.freeze(r)
    end
end

-- v2.2 support additions ----------------------------------------------------
-- These sit on top of the existing value model; none of them add a kind.
-- Every helper answers NaN (or nil for the string helpers) when it cannot
-- answer exactly, so a game never reads a wrong number off a fast path.

local function intValueOf(v)
    local x = Impl.asValue(v)
    if x.kind ~= "finite" or x.n % 1 ~= 0 then
        return nil
    end
    return math.abs(x.n)
end

-- math.fmod is the IEEE remainder, so the loop stays exact for integer-valued
-- doubles past the 2^53 window where "%" would round.
local function euclid(m, n)
    while n > 0 do
        local r = math.fmod(m, n)
        m, n = n, r
    end
    return m
end

function ZubaNum.gcd(a, b)
    local m, n = intValueOf(a), intValueOf(b)
    if m == nil or n == nil then
        return NAN
    end
    return Impl.finite(euclid(m, n))
end

function ZubaNum.lcm(a, b)
    local m, n = intValueOf(a), intValueOf(b)
    if m == nil or n == nil then
        return NAN
    end
    if m == 0 or n == 0 then
        return ZERO
    end
    local q = m / euclid(m, n)
    local out = q * n
    if isfinite(out) and out <= MAX_SAFE then
        return Impl.finite(out)
    end
    -- Past the integer window the quotient stays exact in log space.
    return Impl.fromLog10Value(Impl.finite(log10(q) + log10(n)))
end

function ZubaNum.cbrt(v)
    return ZubaNum.root(v, 3)
end

-- Gamma for finite x, accurate to roughly 1e-15 relative. Integers take the
-- multiplication path so factorials come out exact; anything else is shifted
-- up to 12 with the recurrence and closed with Stirling's series, and the
-- reflection formula covers x below a half. Poles give NaN.
local GAMMA_ANCHOR = 20
local HALF_LOG_2PI = 0.9189385332046727

local function gammaNumber(x)
    if x < 0.5 then
        return math.pi / (math.sin(math.pi * x) * gammaNumber(1 - x))
    end
    if x % 1 == 0 then
        local acc = 1
        for k = 2, x - 1 do
            acc = acc * k
        end
        return acc
    end
    local y = x
    local prod = 1
    while y < GAMMA_ANCHOR do
        prod = prod * y
        y = y + 1
    end
    local y2 = y * y
    local ln = (y - 0.5) * math.log(y) - y + HALF_LOG_2PI
        + 1 / (12 * y) - 1 / (360 * y * y2) + 1 / (1260 * y * y2 * y2)
        - 1 / (1680 * y * y2 * y2 * y2)
    return math.exp(ln - math.log(prod))
end

function ZubaNum.gamma(v)
    local x = Impl.asValue(v)
    if x.kind ~= "finite" then
        return NAN
    end
    if x.n <= 0 and x.n % 1 == 0 then
        return NAN
    end
    if x.n > 171.6 then
        -- 171! is the last factorial a double carries, so above it the answer
        -- travels in log space on Stirling's series instead of overflowing.
        local ln = (x.n - 0.5) * math.log(x.n) - x.n + 0.9189385332046727
            + 1 / (12 * x.n) - 1 / (360 * x.n * x.n * x.n)
        local lg = ln / math.log(10)
        if not isfinite(lg) then
            return CAP
        end
        return Impl.fromLog10Value(Impl.finite(lg))
    end
    local g = gammaNumber(x.n)
    if not isfinite(g) then
        return NAN
    end
    return Impl.finite(g)
end

function ZubaNum.lambertW(v)
    local x = Impl.asValue(v)
    if x.kind ~= "finite" or x.n < -0.36787944117144233 then
        return NAN
    end
    local w = x.n < 1 and x.n or (math.log(x.n) - math.log(math.log(x.n) + 1))
    for _ = 1, 24 do
        local ew = math.exp(w)
        local denom = w * ew + ew
        if denom == 0 then
            break
        end
        local w2 = w - (w * ew - x.n) / denom
        local delta = math.abs(w2 - w)
        w = w2
        if delta <= 1e-15 * math.max(1, math.abs(w)) then
            break
        end
    end
    return Impl.finite(w)
end

local function finiteNumber(v)
    local x = Impl.asValue(v)
    if x.kind ~= "finite" then
        return nil
    end
    return x.n
end

function ZubaNum.sin(v)
    local n = finiteNumber(v)
    return n == nil and NAN or Impl.finite(math.sin(n))
end

function ZubaNum.cos(v)
    local n = finiteNumber(v)
    return n == nil and NAN or Impl.finite(math.cos(n))
end

function ZubaNum.tan(v)
    local n = finiteNumber(v)
    if n == nil then
        return NAN
    end
    local t = math.tan(n)
    return isfinite(t) and Impl.finite(t) or NAN
end

function ZubaNum.asin(v)
    local n = finiteNumber(v)
    if n == nil or n < -1 or n > 1 then
        return NAN
    end
    return Impl.finite(math.asin(n))
end

function ZubaNum.acos(v)
    local n = finiteNumber(v)
    if n == nil or n < -1 or n > 1 then
        return NAN
    end
    return Impl.finite(math.acos(n))
end

function ZubaNum.atan(v)
    local n = finiteNumber(v)
    return n == nil and NAN or Impl.finite(math.atan(n))
end

function ZubaNum.atan2(y, x)
    local ny, nx = finiteNumber(y), finiteNumber(x)
    if ny == nil or nx == nil then
        return NAN
    end
    return Impl.finite(math.atan2(ny, nx))
end

-- Interpolation and sampling in log space, which is where idle-game scales
-- actually live. lerpLog(1e3, 1e9, 0.5) is 1e6, not 5e8.
function ZubaNum.lerpLog(a, b, t)
    local x, y = Impl.asValue(a), Impl.asValue(b)
    local frac = tonumber(t)
    if frac == nil or Impl.signOf(x) <= 0 or Impl.signOf(y) <= 0 then
        return NAN
    end
    local lx, ly = Impl.log10Value(x), Impl.log10Value(y)
    if lx.kind ~= "finite" or ly.kind ~= "finite" then
        return NAN
    end
    return Impl.fromLog10Value(Impl.finite(lx.n + (ly.n - lx.n) * frac))
end

function ZubaNum.randLin(a, b)
    local lo, hi = Impl.asValue(a), Impl.asValue(b)
    if lo.kind ~= "finite" or hi.kind ~= "finite" then
        return NAN
    end
    return Impl.finite(lo.n + (hi.n - lo.n) * math.random())
end

function ZubaNum.randLog(a, b)
    return ZubaNum.lerpLog(a, b, math.random())
end

-- Geometric series, the shape every idle-game cost curve uses. count is the
-- number of terms and terms are 1-based.
function ZubaNum.geoTerm(first, ratio, count)
    local f, r = Impl.asValue(first), Impl.asValue(ratio)
    local k = intValueOf(count)
    if f.kind == "nan" or r.kind == "nan" or k == nil or k < 1 then
        return NAN
    end
    if k == 1 then
        return Impl.copy(f)
    end
    return Impl.mulValues(f, Impl.powValues(r, Impl.finite(k - 1)))
end

function ZubaNum.geoSum(first, ratio, count)
    local f, r = Impl.asValue(first), Impl.asValue(ratio)
    local k = intValueOf(count)
    if f.kind == "nan" or r.kind == "nan" or k == nil or k < 0 then
        return NAN
    end
    if k == 0 then
        return ZERO
    end
    if r.kind == "finite" and r.n == 1 then
        return Impl.mulValues(f, Impl.finite(k))
    end
    local power = Impl.powValues(r, Impl.finite(k))
    local numer = Impl.mulValues(f, Impl.subValues(power, ONE))
    return Impl.divValues(numer, Impl.subValues(r, ONE))
end

-- The inverse of geoSum: how many terms a budget buys. Exact for finite
-- inputs, and log-space algebra keeps it working when the budget is a tower.
function ZubaNum.geoCount(first, ratio, budget)
    local f, r, t = Impl.asValue(first), Impl.asValue(ratio), Impl.asValue(budget)
    if f.kind == "nan" or r.kind == "nan" or t.kind == "nan" then
        return NAN
    end
    if Impl.signOf(t) <= 0 or Impl.signOf(f) <= 0 then
        return ZERO
    end
    if r.kind == "finite" and r.n == 1 then
        return ZubaNum.floor(Impl.divValues(t, f))
    end
    local growth = Impl.subValues(r, ONE)
    local scaled = Impl.addValues(ONE, Impl.mulValues(t, Impl.divValues(growth, f)))
    local count = Impl.divValues(Impl.log10Value(scaled), Impl.log10Value(r))
    return ZubaNum.floor(count)
end

-- Alphabet notation: tier 1 is "A", 26 is "Z", 27 is "AA". It pairs with the
-- suffix ladder, so "A" is 10^3, "Z" is 10^78 and a tier beyond the short
-- marks keeps naming values without bound.
local LETTER_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

local function lettersForTier(tier)
    local out = {}
    while tier > 0 do
        local rem = (tier - 1) % 26
        out[#out + 1] = LETTER_ALPHABET:sub(rem + 1, rem + 1)
        tier = math.floor((tier - 1) / 26)
    end
    local len = #out
    for i = 1, math.floor(len / 2) do
        out[i], out[len + 1 - i] = out[len + 1 - i], out[i]
    end
    return table.concat(out)
end

function ZubaNum.toLetters(v)
    local x = Impl.asValue(v)
    if x.kind == "nan" then
        return nil
    end
    local lv = Impl.log10Value(Impl.magnitude(x))
    if lv.kind ~= "finite" or lv.n < 3 then
        return nil
    end
    local tier = math.floor(lv.n / 3)
    if tier < 1 or tier > 1e15 then
        return nil
    end
    return (Impl.signOf(x) < 0 and "-" or "") .. lettersForTier(tier)
end

function ZubaNum.fromLetters(s)
    if type(s) ~= "string" then
        return NAN
    end
    local t = s:gsub("^%s+", ""):gsub("%s+$", "")
    local neg = t:sub(1, 1) == "-"
    if neg then
        t = t:sub(2)
    end
    if t == "" or #t > 12 then
        return NAN
    end
    local tier = 0
    for i = 1, #t do
        local idx = LETTER_ALPHABET:find(t:sub(i, i):upper(), 1, true)
        if idx == nil then
            return NAN
        end
        tier = tier * 26 + idx
    end
    local exp = 3 * tier
    if exp <= 306 then
        local mag = pow10OfText("1", exp)
        return Impl.finite(neg and -mag or mag)
    end
    local v = Impl.fromLog10Value(Impl.finite(exp))
    return neg and Impl.negate(v) or v
end

-- A Graham-shaped ladder in ZubaNum's own convention: g_n is 3 joined to 3 by
-- n arrows, so g_1 = 27, g_2 = 3^^3, g_64 = 3 with 64 arrows. The real Graham
-- sequence feeds each term's size back in as the next term's arrow count,
-- which no representation here can hold, so this ladder is a growing family of
-- its own. It also orders below the named GRAHAM constant: named values sit in
-- a higher band than plain hyper values, so comparing the two follows the band
-- rules rather than measuring one against the other.
function ZubaNum.graham(n)
    local k = tonumber(n)
    if k == nil or k ~= k or k < 1 then
        return NAN
    end
    k = math.floor(k)
    local three = Impl.finite(3)
    if k == 1 then
        return Impl.powValues(three, Impl.finite(3))
    end
    return Impl.hyperValue(k + 2, three, three)
end

local function describeValue(x)
    local k = x.kind
    if k == "finite" then
        return "finite " .. Impl.format(x)
    elseif k == "tower" then
        local h = Rank.finiteValue(x.rank)
        if h ~= nil then
            return ("tower height %d mantissa %.15g sign %d"):format(h, x.m, x.sign)
        end
        return "tower rank " .. Rank.toString(x.rank)
    elseif k == "cap" then
        return "LIMIT"
    elseif k == "nan" then
        return "NaN"
    end
    return k .. " " .. Impl.format(x)
end

-- Why do these two order the way they do? Tiers decide first, then the order
-- inside the tier, so this names the tier pair when they differ.
function ZubaNum.explain(a, b)
    local x, y = Impl.asValue(a), Impl.asValue(b)
    if x.kind == "nan" or y.kind == "nan" then
        return "NaN is unordered with every value, including itself"
    end
    local c = Impl.compare(x, y)
    local verdict = c < 0 and "<" or (c > 0 and ">" or "=")
    local tx, ty = Impl.tierOf(x), Impl.tierOf(y)
    local basis
    if tx ~= ty then
        basis = ("tier %s vs tier %s decides it"):format(tostring(tx), tostring(ty))
    else
        basis = ("both tier %s, so the order inside the tier decides it"):format(tostring(tx))
    end
    return ("%s %s %s (%s)"):format(describeValue(x), verdict, describeValue(y), basis)
end

-- Compact save spelling, one byte of tag instead of a JSON table.
--   1f<number>  finite        1t<height>,<mantissa>,<sign>  finite-rank tower
--   1l          LIMIT         1n  NaN       1p<spelling>    anything else
-- The leading 1 is the format version, so an old save can be told apart.
ZubaNum.SAVE_VERSION = 1

function ZubaNum.toSave(v)
    local x = Impl.asValue(v)
    if x.kind == "finite" then
        return "1f" .. string.format("%.17g", x.n)
    elseif x.kind == "cap" then
        return "1l"
    elseif x.kind == "nan" then
        return "1n"
    elseif x.kind == "tower" then
        local h = Rank.finiteValue(x.rank)
        if h ~= nil then
            return ("1t%d,%s,%d"):format(h, string.format("%.17g", x.m), x.sign)
        end
    end
    return "1p" .. Impl.format(x)
end

function ZubaNum.fromSave(s)
    if type(s) ~= "string" or #s < 2 or s:sub(1, 1) ~= "1" then
        return NAN
    end
    local tag = s:sub(2, 2)
    local body = s:sub(3)
    if tag == "f" then
        local n = tonumber(body)
        if n == nil or not isfinite(n) then
            return NAN
        end
        return Impl.finite(n)
    elseif tag == "l" then
        return CAP
    elseif tag == "n" then
        return NAN
    elseif tag == "t" then
        local h, m, sign = body:match("^(%-?[%d%.]+),(%-?[%d%.]+),(%-?%d+)$")
        local height = tonumber(h)
        local mant = tonumber(m)
        local sgn = tonumber(sign)
        if height == nil or mant == nil or sgn == nil or height < 0 or (sgn ~= 1 and sgn ~= -1) then
            return NAN
        end
        return Impl.canonical(sgn, Rank.addFinite(Rank.ZERO, height), mant)
    elseif tag == "p" then
        return Impl.parseString(body)
    end
    return NAN
end

return ZubaNum
