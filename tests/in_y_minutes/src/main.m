// tests/in_y_minutes/src/main.m
//
// Modest in Y minutes — a fast tour of the language.
// Full reference: docs/CHEATSHEET.md

// This is a line comment. There are no block comments.

include "libc/ctypes64"  // Int32, Nat32, Float64, ... — type aliases
include "libc/stdio"     // printf
include "libc/math"      // sqrt

// `include` pastes a module's names directly into scope — used for C
// bindings and library modules. `import "mymodule"` instead requires a
// `mymodule.` prefix on every name it brings in (see docs/lang).


// --- Types ------------------------------------------------------------------
//
// PascalCase for types, camelCase for everything else. Base types: Bool,
// IntX/NatX/WordX (8/16/32/64/128 — signed/unsigned/bitwise), CharX (8/16/32),
// FloatX (32/64), Str8/Str16/Str32 (= []CharX), Int/Nat/Word (target width).

// directive type binds a new name to an existing type,
// but does not create a distinct type. For distinct types, use `@branded` annotation (newtype idiom).
type Point = {
	x: Float64
	y: Float64
}

// newtype: distinct from Float64, not just an alias
type Meters = @branded Float64

// enum idiom — Modest has no `enum` keyword
type Color = @branded Nat8
const colorRed   = Color 0
const colorGreen = Color 1
const colorBlue  = Color 2

// function type
// You cannot create a variable of a function type directly,
// but you can create a pointer to a function type.
type Action = () -> Unit


// --- Functions ----------------------------------------------------------------

@inline
func distance (a: Point, b: Point) -> Float64 {
	let dx = a.x - b.x
	let dy = a.y - b.y
	return sqrt(dx*dx + dy*dy)
}


func sum (n: Int32) -> Int32 {
	var total: Int32 = 0
	var i: Int32 = 0
	while i < n {
		total = total + i
		++i
	}
	return total
}


func announce: Action {
	printf("modest says hi\n")
}


func main () -> Int {
	// literals carry a compile-time type, resolved at the use site
	let n = 42       // Integer  -> converts to IntX / NatX / WordX / FloatX / CharX
	let pi = 3.14159  // Rational -> converts to FloatX
	var i32: Int32 = n
	var f64: Float64 = pi

	// var / let / const
	var counter = 10                    // var: concrete type (Integer -> default Int here)
	counter = 20                        // mutable
	let fixed = 30                      // let: immutable, function-local only
	@immutable var locked: Int32 = 40   // var, frozen after init

	// value construction — Modest has no casts, only explicit construction
	var w: Word64 = Word64 1 << 63
	var asInt: Int64 = Int64 w          // WordX -> IntX, same width, safe
	printf("w = %llx -> asInt = %lld\n", w, asInt)

	var height = Meters 1.8
	printf("height = %f\n", Float64 height)

	// strings & characters
	let greeting: *Str8 = "Hello, Modest!"
	let initial: Char8 = "M"
	printf("%s (starts with %c)\n", greeting, initial)

	// arrays & slices — arrays are value types: passed/returned/assigned by value
	var arr: [5]Int32 = [1, 2, 3, 4, 5]
	var slice = arr[1:3]  // sub-array [2, 3]
	var i: Nat32 = 0
	while i < lengthof(arr) {
		printf("%d ", arr[i])
		++i
	}
	printf("\n")

	// records & pointers
	let origin = Point {x = 0.0, y = 0.0}
	let corner = Point {x = 3.0, y = 4.0}
	printf("distance = %f\n", distance(origin, corner))

	var p = corner
	var pp = &p
	pp.x = 99.0  // auto-deref field write through pointer
	printf("p.x = %f\n", p.x)

	// enum idiom
	var c = colorGreen
	if c == colorGreen {
		printf("color is green\n")
	}

	// bitwise ops — Word* types only; Int*/Nat* have no bitwise ops
	var u: Word32 = 0x0f
	var v: Word32 = 0x33
	printf("u | v = %x\n", u | v)

	// while / again (= continue)
	var k = 0
	while k < 5 {
		++k
		if k == 3 {
			again  // skip the print for k == 3
		}
		printf("k = %d\n", k)
	}

	// while / break
	var j = 0
	while 1 > 0 {
		if j == 2 {
			break
		}
		printf("j = %d\n", j)
		++j
	}

	// logical ops: and / or / not (no &&, ||, !)
	if i32 > 0 and not (counter < 0) {
		printf("logic works\n")
	}

	// function pointers
	var cb: *Action = &announce
	cb()

	// sizeof / lengthof
	printf("sizeof(Point) = %lu\n", sizeof(Point))
	printf("sum(0..5) = %d\n", sum(5))

	return 0
}
