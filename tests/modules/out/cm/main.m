import "builtin"
import "./lib/lib"
import "./lib/mod1"
import "./lib/mod2"
include "ctypes64"
include "stdio"

include "libc/ctypes64"
include "libc/stdio"
import "./lib/lib" as lib
import "./lib/mod1" as mod1
import "./lib/mod2" as mod2

//pragma c_include "./lib/lib.h"
//pragma c_include "./lib/mod1.h"
//pragma c_include "./lib/mod2.h"



@nonstatic
func main () -> Int {
	var librarian: Librarian
	var m1: Mod
	var m2: Mod
	printf("mod1.modName = '%s'\n", *Str8 mod1.modName)
	printf("mod2.modName = '%s'\n", *Str8 mod2.modName)
	lib.printf("??")

	let a: Int32 = 33000
	var b: Int16 = unsafe Int16 a

	return 0
}

