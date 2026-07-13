// tests/1.hello_world/src/main.m

pragma unsafe

include "libc/ctypes64"
include "libc/stdio"

@cinclude("./lib/lib.h")
import "./lib/lib"
@cinclude("./lib/mod1.h")
import "./lib/mod1"
@cinclude("./lib/mod2.h")
import "./lib/mod2"

//pragma c_include "./lib/lib.h"
//pragma c_include "./lib/mod1.h"
//pragma c_include "./lib/mod2.h"


func main () -> Int {
	lib.printf("hi!\n")

	var librarian: lib.Librarian
	var m1: mod1.Mod
	var m2: mod2.Mod

	printf("mod1.modName = '%s'\n", *Str8 mod1.modName)
	printf("mod2.modName = '%s'\n", *Str8 mod2.modName)

	return 0
}

