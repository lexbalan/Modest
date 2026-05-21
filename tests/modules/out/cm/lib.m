private import "builtin"
private import "./mod1"
private import "./mod2"

import "./mod1" as mod1
import "./mod2" as mod2

const privateConst: Bool = false

const lenn = 10

public type Librarian = {
	name: *Str8
	name2: [lenn]Char8
}

public func printf (s: *Str8, ...) -> Unit {
}


type X = {
	public y: *Y
}

type Y = {
	public x: Int32
}

