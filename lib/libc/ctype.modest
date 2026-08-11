// libc/ctype.m

pragma do_not_include
pragma c_include "ctype.h"
pragma prefix ""

include "ctypes64"


@extern("C", "isascii") func __isascii (x: Int) -> Int
@extern("C", "iscntrl") func __iscntrl (x: Int) -> Int
@extern("C", "isblank") func __isblank (x: Int) -> Int
@extern("C", "isdigit") func __isdigit (x: Int) -> Int
@extern("C", "isxdigit") func __isxdigit (x: Int) -> Int
@extern("C", "isalpha") func __isalpha (x: Int) -> Int
@extern("C", "isalnum") func __isalnum (x: Int) -> Int
@extern("C", "isgraph") func __isgraph (x: Int) -> Int
@extern("C", "isprint") func __isprint (x: Int) -> Int
@extern("C", "ispunct") func __ispunct (x: Int) -> Int
@extern("C", "isspace") func __isspace (x: Int) -> Int
@extern("C", "isupper") func __isupper (x: Int) -> Int
@extern("C", "islower") func __islower (x: Int) -> Int


public func isascii (x: Int) -> Bool { return __isascii(x) != 0 }
public func iscntrl (x: Int) -> Bool { return __iscntrl(x) != 0 }
public func isblank (x: Int) -> Bool { return __isblank(x) != 0 }
public func isdigit (x: Int) -> Bool { return __isdigit(x) != 0 }
public func isxdigit (x: Int) -> Bool { return __isxdigit(x) != 0 }
public func isalpha (x: Int) -> Bool { return __isalpha(x) != 0 }
public func isalnum (x: Int) -> Bool { return __isalnum(x) != 0 }
public func isgraph (x: Int) -> Bool { return __isgraph(x) != 0 }
public func isprint (x: Int) -> Bool { return __isprint(x) != 0 }
public func ispunct (x: Int) -> Bool { return __ispunct(x) != 0 }
public func isspace (x: Int) -> Bool { return __isspace(x) != 0 }
public func isupper (x: Int) -> Bool { return __isupper(x) != 0 }
public func islower (x: Int) -> Bool { return __islower(x) != 0 }

public func toascii (x: Int) -> Int
public func toupper (x: Int) -> Int
public func tolower (x: Int) -> Int

