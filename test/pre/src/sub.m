

import "sub2"
$pragma c_include "./sub2.h"
//$pragma not_included

// this c_alias - not worked!
@property("c_alias", "int")
export type Int Int32

export let subName = "SubName"
export let default = Int 5


@inline
export func div(a: Int, b: Int) -> Int {
	return a / b
}


