// libc/ctype.m

pragma do_not_include
pragma module_nodecorate
pragma c_include "ctype.h"

include "ctypes64"


public func isascii (x: Int) -> Bool
public func iscntrl (x: Int) -> Bool
public func isblank (x: Int) -> Bool
public func isdigit (x: Int) -> Bool
public func isxdigit (x: Int) -> Bool
public func isalpha (x: Int) -> Bool
public func isalnum (x: Int) -> Bool
public func isgraph (x: Int) -> Bool
public func isprint (x: Int) -> Bool
public func ispunct (x: Int) -> Bool
public func isspace (x: Int) -> Bool
public func isupper (x: Int) -> Bool
public func islower (x: Int) -> Bool

public func toascii (x: Int) -> Int
public func toupper (x: Int) -> Int
public func tolower (x: Int) -> Int

