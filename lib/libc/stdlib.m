
$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "stdlib.h"

include "ctypes64"
include "ctypes"

export func abort() -> Unit
export func abs(x: Int) -> Int
export func atexit(x: *()->Unit) -> Int
export func atof(nptr: *[]ConstChar) -> Double
export func atoi(nptr: *[]ConstChar) -> Int
export func atol(nptr: *[]ConstChar) -> LongInt
export func calloc(num: SizeT, size: SizeT) -> Ptr
export func exit(x: Int) -> Unit
export func free(ptr: Ptr) -> Unit
export func getenv(name: *Str) -> *Str
export func labs(x: LongInt) -> LongInt
export func secure_getenv(name: *Str) -> *Str
export func malloc(size: SizeT) -> Ptr
export func system(string: *[]ConstChar) -> Int

