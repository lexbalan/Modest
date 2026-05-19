private import "builtin"
private import "./mod1"
private import "./mod2"

import "./mod1" as mod1
import "./mod2" as mod2

public type Librarian = {
	name: *Str8
}

public func printf (s: *Str8, ...) -> Unit {
}

