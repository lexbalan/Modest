
//pragma do_not_include

import "./mod1"
import "./mod2"


const privateConst = false


const lenn = 10


type X = {
	public y: *Y
}

type Y = {
	public x: Int32
}


public type Librarian = @public {
	name: *Str8
	name2: [lenn]Char8
}

public func printf (s: *Str8, ...) -> Unit {
	//
}
