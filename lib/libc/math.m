// libc/math.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "math.h"

include "./ctypes64"


export {
	@property("value.id.c", "M_PI")
	let m_PI = 3.141592653589793238462643383279502884

	@property("value.id.c", "M_E")
	let m_E =  2.718281828459045235360287471352662498


	/*
	 * ANSI/POSIX
	 */
	func acos(x: Double) -> Double
	func asin(x: Double) -> Double
	func atan(x: Double) -> Double
	func atan2(a: Double, b: Double) -> Double
	func cos(x: Double) -> Double
	func sin(x: Double) -> Double
	func tan(x: Double) -> Double

	func cosh(x: Double) -> Double
	func sinh(x: Double) -> Double
	func tanh(x: Double) -> Double

	func exp(x: Double) -> Double
	func frexp(a: Double, i: *Int) -> Double
	func ldexp(a: Double, i: Int) -> Double
	func log(x: Double) -> Double
	func log10(x: Double) -> Double
	func modf(a: Double, b: *Double) -> Double

	func pow(a: Double, b: Double) -> Double
	func sqrt(x: Double) -> Double

	func ceil(x: Double) -> Double
	func fabs(x: Double) -> Double
	func floor(x: Double) -> Double
	func fmod(a: Double, b: Double) -> Double


	/*
	 * Long double versions of C99 functions
	 */
	func acosl(x: LongDouble) -> LongDouble
	func asinl(x: LongDouble) -> LongDouble
	func atanl(x: LongDouble) -> LongDouble
	func atan2l(a: LongDouble, b: LongDouble) -> LongDouble
	func cosl(x: LongDouble) -> LongDouble
	func sinl(x: LongDouble) -> LongDouble
	func tanl(x: LongDouble) -> LongDouble

	func acoshl(x: LongDouble) -> LongDouble
	func asinhl(x: LongDouble) -> LongDouble
	func atanhl(x: LongDouble) -> LongDouble
	func coshl(x: LongDouble) -> LongDouble
	func sinhl(x: LongDouble) -> LongDouble
	func tanhl(x: LongDouble) -> LongDouble

	func expl(x: LongDouble) -> LongDouble
	func exp2l(x: LongDouble) -> LongDouble
	func expm1l(x: LongDouble) -> LongDouble
	func frexpl(a: LongDouble, i: *Int) -> LongDouble
	func ilogbl(x: LongDouble) -> Int
	func ldexpl(a: LongDouble, i: Int) -> LongDouble
	func logl(x: LongDouble) -> LongDouble
	func log10l(x: LongDouble) -> LongDouble
	func log1pl(x: LongDouble) -> LongDouble
	func log2l(x: LongDouble) -> LongDouble
	func logbl(x: LongDouble) -> LongDouble
	func modfl(a: LongDouble, b: *LongDouble) -> LongDouble
	func scalbnl(a: LongDouble, i: Int) -> LongDouble
	func scalblnl(a: LongDouble, i: LongInt) -> LongDouble

	func cbrtl(x: LongDouble) -> LongDouble
	func fabsl(x: LongDouble) -> LongDouble
	func hypotl(a: LongDouble, b: LongDouble) -> LongDouble
	func powl(a: LongDouble, b: LongDouble) -> LongDouble
	func sqrtl(x: LongDouble) -> LongDouble

	func erfl(x: LongDouble) -> LongDouble
	func erfcl(x: LongDouble) -> LongDouble
	func lgammal(x: LongDouble) -> LongDouble
	func tgammal(x: LongDouble) -> LongDouble

	func ceill(x: LongDouble) -> LongDouble
	func floorl(x: LongDouble) -> LongDouble
	func nearbyintl(x: LongDouble) -> LongDouble
	func rintl(x: LongDouble) -> LongDouble
	func lrintl(x: LongDouble) -> LongInt
	func llrintl(x: LongDouble) -> LongLongInt
	func roundl(x: LongDouble) -> LongDouble
	func lroundl(x: LongDouble) -> LongInt
	func llroundl(x: LongDouble) -> LongLongInt
	func truncl(x: LongDouble) -> LongDouble

	func fmodl(a: LongDouble, b: LongDouble) -> LongDouble
	func remainderl(a: LongDouble, b: LongDouble) -> LongDouble
	func remquol(a: LongDouble, b: LongDouble, i: *Int) -> LongDouble

	func copysignl(a: LongDouble, b: LongDouble) -> LongDouble
	func nanl(x: *ConstChar) -> LongDouble
	func nextafterl(a: LongDouble, b: LongDouble) -> LongDouble
	func nexttowardl(a: LongDouble, b: LongDouble) -> LongDouble

	func fdiml(a: LongDouble, b: LongDouble) -> LongDouble
	func fmaxl(a: LongDouble, b: LongDouble) -> LongDouble
	func fminl(a: LongDouble, b: LongDouble) -> LongDouble

	func fmal(a: LongDouble, b: LongDouble, c: LongDouble) -> LongDouble
}

