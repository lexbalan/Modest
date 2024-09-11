// libc/math.hm

$pragma do_not_include
$pragma c_include "math.h"

include "./ctypes64"


@property("value.id.c", "M_PI")
export let m_PI = 3.141592653589793238462643383279502884

@property("value.id.c", "M_E")
export let m_E =  2.718281828459045235360287471352662498


/*
 * ANSI/POSIX
 */
export func acos(x: Double) -> Double
export func asin(x: Double) -> Double
export func atan(x: Double) -> Double
export func atan2(a: Double, b: Double) -> Double
export func cos(x: Double) -> Double
export func sin(x: Double) -> Double
export func tan(x: Double) -> Double

export func cosh(x: Double) -> Double
export func sinh(x: Double) -> Double
export func tanh(x: Double) -> Double

export func exp(x: Double) -> Double
export func frexp(a: Double, i: *Int) -> Double
export func ldexp(a: Double, i: Int) -> Double
export func log(x: Double) -> Double
export func log10(x: Double) -> Double
export func modf(a: Double, b: *Double) -> Double

export func pow(a: Double, b: Double) -> Double
export func sqrt(x: Double) -> Double

export func ceil(x: Double) -> Double
export func fabs(x: Double) -> Double
export func floor(x: Double) -> Double
export func fmod(a: Double, b: Double) -> Double


/*
 * Long double versions of C99 export functions
 */
export func acosl(x: LongDouble) -> LongDouble
export func asinl(x: LongDouble) -> LongDouble
export func atanl(x: LongDouble) -> LongDouble
export func atan2l(a: LongDouble, b: LongDouble) -> LongDouble
export func cosl(x: LongDouble) -> LongDouble
export func sinl(x: LongDouble) -> LongDouble
export func tanl(x: LongDouble) -> LongDouble

export func acoshl(x: LongDouble) -> LongDouble
export func asinhl(x: LongDouble) -> LongDouble
export func atanhl(x: LongDouble) -> LongDouble
export func coshl(x: LongDouble) -> LongDouble
export func sinhl(x: LongDouble) -> LongDouble
export func tanhl(x: LongDouble) -> LongDouble

export func expl(x: LongDouble) -> LongDouble
export func exp2l(x: LongDouble) -> LongDouble
export func expm1l(x: LongDouble) -> LongDouble
export func frexpl(a: LongDouble, i: *Int) -> LongDouble
export func ilogbl(x: LongDouble) -> Int
export func ldexpl(a: LongDouble, i: Int) -> LongDouble
export func logl(x: LongDouble) -> LongDouble
export func log10l(x: LongDouble) -> LongDouble
export func log1pl(x: LongDouble) -> LongDouble
export func log2l(x: LongDouble) -> LongDouble
export func logbl(x: LongDouble) -> LongDouble
export func modfl(a: LongDouble, b: *LongDouble) -> LongDouble
export func scalbnl(a: LongDouble, i: Int) -> LongDouble
export func scalblnl(a: LongDouble, i: LongInt) -> LongDouble

export func cbrtl(x: LongDouble) -> LongDouble
export func fabsl(x: LongDouble) -> LongDouble
export func hypotl(a: LongDouble, b: LongDouble) -> LongDouble
export func powl(a: LongDouble, b: LongDouble) -> LongDouble
export func sqrtl(x: LongDouble) -> LongDouble

export func erfl(x: LongDouble) -> LongDouble
export func erfcl(x: LongDouble) -> LongDouble
export func lgammal(x: LongDouble) -> LongDouble
export func tgammal(x: LongDouble) -> LongDouble

export func ceill(x: LongDouble) -> LongDouble
export func floorl(x: LongDouble) -> LongDouble
export func nearbyintl(x: LongDouble) -> LongDouble
export func rintl(x: LongDouble) -> LongDouble
export func lrintl(x: LongDouble) -> LongInt
export func llrintl(x: LongDouble) -> LongLongInt
export func roundl(x: LongDouble) -> LongDouble
export func lroundl(x: LongDouble) -> LongInt
export func llroundl(x: LongDouble) -> LongLongInt
export func truncl(x: LongDouble) -> LongDouble

export func fmodl(a: LongDouble, b: LongDouble) -> LongDouble
export func remainderl(a: LongDouble, b: LongDouble) -> LongDouble
export func remquol(a: LongDouble, b: LongDouble, i: *Int) -> LongDouble

export func copysignl(a: LongDouble, b: LongDouble) -> LongDouble
export func nanl(x: *ConstChar) -> LongDouble
export func nextafterl(a: LongDouble, b: LongDouble) -> LongDouble
export func nexttowardl(a: LongDouble, b: LongDouble) -> LongDouble

export func fdiml(a: LongDouble, b: LongDouble) -> LongDouble
export func fmaxl(a: LongDouble, b: LongDouble) -> LongDouble
export func fminl(a: LongDouble, b: LongDouble) -> LongDouble

export func fmal(a: LongDouble, b: LongDouble, c: LongDouble) -> LongDouble


