// libc/math.m

pragma do_not_include
pragma module_nodecorate
pragma c_include "math.h"


include "./ctypes64"


@calias("M_PI")
public const c_M_PI = 3.1415926535897932384626433832795028841971693993751058209749445923

@calias("M_E")
public const c_M_E = 2.7182818284590452353602874713526624977572470936999595749669676277


/*
 * ANSI/POSIX
 */
public func acos (x: Double) -> Double
public func asin (x: Double) -> Double
public func atan (x: Double) -> Double
public func atan2 (a: Double, b: Double) -> Double
public func cos (x: Double) -> Double
public func sin (x: Double) -> Double
public func tan (x: Double) -> Double

public func cosh (x: Double) -> Double
public func sinh (x: Double) -> Double
public func tanh (x: Double) -> Double

public func exp (x: Double) -> Double
public func frexp (a: Double, i: *Int) -> Double
public func ldexp (a: Double, i: Int) -> Double
public func log (x: Double) -> Double
public func log10 (x: Double) -> Double
public func modf (a: Double, b: *Double) -> Double

public func pow (a: Double, b: Double) -> Double
public func sqrt (x: Double) -> Double

public func ceil (x: Double) -> Double
public func fabs (x: Double) -> Double
public func floor (x: Double) -> Double
public func fmod (a: Double, b: Double) -> Double


/*
 * Long double versions of C99 functions
 */
public func acosl (x: LongDouble) -> LongDouble
public func asinl (x: LongDouble) -> LongDouble
public func atanl (x: LongDouble) -> LongDouble
public func atan2l (a: LongDouble, b: LongDouble) -> LongDouble
public func cosl (x: LongDouble) -> LongDouble
public func sinl (x: LongDouble) -> LongDouble
public func tanl (x: LongDouble) -> LongDouble

public func acoshl (x: LongDouble) -> LongDouble
public func asinhl (x: LongDouble) -> LongDouble
public func atanhl (x: LongDouble) -> LongDouble
public func coshl (x: LongDouble) -> LongDouble
public func sinhl (x: LongDouble) -> LongDouble
public func tanhl (x: LongDouble) -> LongDouble

public func expl (x: LongDouble) -> LongDouble
public func exp2l (x: LongDouble) -> LongDouble
public func expm1l (x: LongDouble) -> LongDouble
public func frexpl (a: LongDouble, i: *Int) -> LongDouble
public func ilogbl (x: LongDouble) -> Int
public func ldexpl (a: LongDouble, i: Int) -> LongDouble
public func logl (x: LongDouble) -> LongDouble
public func log10l (x: LongDouble) -> LongDouble
public func log1pl (x: LongDouble) -> LongDouble
public func log2l (x: LongDouble) -> LongDouble
public func logbl (x: LongDouble) -> LongDouble
public func modfl (a: LongDouble, b: *LongDouble) -> LongDouble
public func scalbnl (a: LongDouble, i: Int) -> LongDouble
public func scalblnl (a: LongDouble, i: LongInt) -> LongDouble

public func cbrtl (x: LongDouble) -> LongDouble
public func fabsl (x: LongDouble) -> LongDouble
public func hypotl (a: LongDouble, b: LongDouble) -> LongDouble
public func powl (a: LongDouble, b: LongDouble) -> LongDouble
public func sqrtl (x: LongDouble) -> LongDouble

public func erfl (x: LongDouble) -> LongDouble
public func erfcl (x: LongDouble) -> LongDouble
public func lgammal (x: LongDouble) -> LongDouble
public func tgammal (x: LongDouble) -> LongDouble

public func ceill (x: LongDouble) -> LongDouble
public func floorl (x: LongDouble) -> LongDouble
public func nearbyintl (x: LongDouble) -> LongDouble
public func rintl (x: LongDouble) -> LongDouble
public func lrintl (x: LongDouble) -> LongInt
public func llrintl (x: LongDouble) -> LongLongInt
public func roundl (x: LongDouble) -> LongDouble
public func lroundl (x: LongDouble) -> LongInt
public func llroundl (x: LongDouble) -> LongLongInt
public func truncl (x: LongDouble) -> LongDouble

public func fmodl (a: LongDouble, b: LongDouble) -> LongDouble
public func remainderl (a: LongDouble, b: LongDouble) -> LongDouble
public func remquol (a: LongDouble, b: LongDouble, i: *Int) -> LongDouble

public func copysignl (a: LongDouble, b: LongDouble) -> LongDouble
public func nanl (x: *ConstChar) -> LongDouble
public func nextafterl (a: LongDouble, b: LongDouble) -> LongDouble
public func nexttowardl (a: LongDouble, b: LongDouble) -> LongDouble

public func fdiml (a: LongDouble, b: LongDouble) -> LongDouble
public func fmaxl (a: LongDouble, b: LongDouble) -> LongDouble
public func fminl (a: LongDouble, b: LongDouble) -> LongDouble

public func fmal (a: LongDouble, b: LongDouble, c: LongDouble) -> LongDouble


