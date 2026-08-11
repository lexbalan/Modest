// std.m

pragma do_not_include

include "libc/stdio"
include "libc/stdlib"


//$if (__target.intWidth == 32)
public type Byte = Word8
public type Int = Int32
public type Nat = Nat32
//public type Size = Nat32
//public type SSize = Int32
//public type Address = Nat32
//$elseif (__target.intWidth == 64)
//type Int Int64
//type Nat Nat64
//$else
//@error ("bad __target.intWidth")
//$endif


public func assert (cond: Bool, msg: *Str8) -> Unit {
	if not cond {
		printf("assert: %s", msg)
		exit(1)
	}
}


