private import "builtin"
import "./lib/lib"
include "ctypes64"
include "stdio"

import "./lib/lib" as lib

func main () -> Int {
	var librarian: Librarian
	var mod1: Mod
	var mod2: Mod
	printf("lib.mod1.modName = '%s'\n", lib.mod1.modName)
	printf("lib.mod2.modName = '%s'\n", lib.mod2.modName)
	return 0
}

