// tests/lang/def/type/src/main.m

// alias
type Size = Nat64
type Index = Int32

// record
type Point = {x: Int32, y: Int32}
type Color = {r: Nat8, g: Nat8, b: Nat8, a: Nat8}

public type X = {
	public a: Int32
	private b: Int32
}

// nested record
type Rect = {origin: Point, size: {w: Int32, h: Int32}}

// packed record
type Header = @layout("packed") {tag: Nat8, len: Nat16}

// union
type Value = @layout("union") {i: Int64, f: Float64}

// branded
type UserId = @branded Nat32
type Email = @branded *Str8

// pointer type alias
type IntPtr = *Int32
type ConstStr = *Str8

// array type alias
type Vec3 = [3]Float32
type Matrix = [4][4]Float64

// function type
type Callback = (a: Int32) -> Int32
type Predicate = (x: Int32) -> Bool
type Action = () -> {}

func main () -> Int32 {
	return 0
}
