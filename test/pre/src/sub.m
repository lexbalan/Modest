

import "sub2"
$pragma c_include "./sub2.h"
//$pragma do_not_include

/*export {
	subName
	default
}*/

// this c_alias - not worked!
//@property("id.c", "int")
export type Int Int32

export let subName = "SubName"
export let default = Int 5


export var subCnt: Int


@inline
export func div(a: Int, b: Int) -> Int {
	return a / b
}


