// libc/string.m

pragma do_not_include
pragma module_nodecorate
pragma c_include "string.h"

include "ctypes64"


public func memset (mem: Ptr, c: Int, n: SizeT) -> @unused Ptr
public func memcpy (dst: Ptr, src: Ptr, len: SizeT) -> @unused Ptr
public func memmove (dst: Ptr, src: Ptr, n: SizeT) -> @unused Ptr
public func memcmp (p0: Ptr, p1: Ptr, num: SizeT) -> Int
public func strlen (s: @cstring *[]ConstChar) -> SizeT
public func strcmp (s1: @cstring *[]ConstChar, s2: @cstring *[]ConstChar) -> Int
public func strncmp (s1: @cstring *[]ConstChar, s2: @cstring *[]ConstChar, n: SizeT) -> Int
public func strcpy (dst: @cstring *[]Char, src: @cstring *[]ConstChar) -> @unused *[]Char
public func strncpy (dst: @cstring *[]Char, src: @cstring *[]ConstChar, n: SizeT) -> @unused *[]Char
public func strcat (s1: @cstring *[]Char, s2: @cstring *[]ConstChar) -> *[]Char
public func strncat (s1: @cstring *[]Char, s2: @cstring *[]ConstChar, n: SizeT) -> *[]Char
public func strerror (error: Int) -> *[]Char

public func strcspn (str1: *Str8, str2: *Str8) -> SizeT




