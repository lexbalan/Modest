
//pragma do_not_include

import "./mod1"
import "./mod2"

const privateConst = false

public const lenn = 10

public type Librarian = {
	name: *Str8
	name2: [lenn]Char8
}

public func printf (s: *Str8, ...) -> Unit {
	//
}


type X = {
	public y: *Y
}

type Y = {
	public x: Int32
}
