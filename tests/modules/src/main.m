// tests/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"

public import "./lib/lib"
pragma c_include "./lib/lib.h"


public func main () -> Int {
	var librarian: lib.Librarian
	var mod1: lib.mod1.Mod
	var mod2: lib.mod2.Mod
	printf("lib.mod1.modName = '%s'\n", lib.mod1.modName)
	printf("lib.mod2.modName = '%s'\n", lib.mod2.modName)
	return 0
}

