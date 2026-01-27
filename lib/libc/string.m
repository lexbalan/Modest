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
public func strcmp (s1: *[]ConstChar, s2: *[]ConstChar) -> Int
public func strncmp (s1: *[]ConstChar, s2: *[]ConstChar, n: SizeT) -> Int
public func strcpy (dst: @cstring *[]Char, src: *[]ConstChar) -> @unused *[]Char
public func strncpy (dst: *[]Char, src: *[]ConstChar, n: SizeT) -> @unused *[]Char
public func strcat (s1: *[]Char, s2: *[]ConstChar) -> *[]Char
public func strncat (s1: *[]Char, s2: *[]ConstChar, n: SizeT) -> *[]Char
public func strerror (error: Int) -> *[]Char

public func strcspn (str1: *Str8, str2: *Str8) -> SizeT




