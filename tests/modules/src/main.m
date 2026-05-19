// tests/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"

import "./lib/lib"
import "./lib/mod1"
import "./lib/mod2"
pragma c_include "./lib/lib.h"
pragma c_include "./lib/mod1.h"
pragma c_include "./lib/mod2.h"



func main () -> Int {
	var librarian: lib.Librarian
	var m1: lib.mod1.Mod
	var m2: lib.mod2.Mod
	printf("mod1.modName = '%s'\n", *Str8 mod1.modName)
	printf("mod2.modName = '%s'\n", *Str8 mod2.modName)
	lib.printf("??")
	return 0
}

