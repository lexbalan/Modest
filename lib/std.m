// std.m

$pragma do_not_include

//$if (__target.intWidth == 32)
type Byte = Word8
type Int = Int32
type Nat = Nat32
type Size = Nat32
type SSize = Int32
type Address = Nat32
//$elseif (__target.intWidth == 64)
//type Int Int64
//type Nat Nat64
//$else
//@error ("bad __target.intWidth")
//$endif

