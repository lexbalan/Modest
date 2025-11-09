// libc/stdlib.m

pragma do_not_include
pragma module_nodecorate
pragma c_include "stdlib.h"

include "ctypes64"


@alias("c", "EXIT_SUCCESS")
public const exitSuccess: Int = 0
@alias("c", "EXIT_FAILURE")
public const exitFailure: Int = 1


public func abort () -> Unit
public func abs (x: Int) -> Int
public func atexit (x: *()->Unit) -> Int
public func atof (nptr: *[]ConstChar) -> Double
public func atoi (nptr: *[]ConstChar) -> Int
public func atol (nptr: *[]ConstChar) -> LongInt
public func calloc (num: SizeT, size: SizeT) -> Ptr
public func exit (x: Int) -> Unit
public func free (ptr: Ptr) -> Unit
public func getenv (name: *Str) -> *Str
public func labs (x: LongInt) -> LongInt
public func secure_getenv (name: *Str) -> *Str
public func malloc (size: SizeT) -> Ptr
public func system (string: *[]ConstChar) -> Int


