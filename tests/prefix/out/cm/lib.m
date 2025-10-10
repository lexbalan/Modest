include "stdio"
// examples/prefix/src/lib.m

//pragma append_prefix loo

public type Nothing = record {}

public const bar = 4

public var spam: Int32 = 4

public func foo (x: Nat32) -> Unit {
	printf("foo(%d)\n", x)
}

