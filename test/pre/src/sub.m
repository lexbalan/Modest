

import "sub2"
$pragma c_include "./sub2.h"
//$pragma do_not_include



// this c_alias - not worked!
//@property("id.c", "int")
public type Int Int32

public const subName = "SubName"
public const default = Int 5


public var subCnt: Int


@inline
public func div(a: Int, b: Int) -> Int {
	return a / b
}


