// libc/string.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "string.h"

include "ctypes64"


@unused_result
public func memset(mem: Ptr, c: Int, n: SizeT) -> Ptr
@unused_result
public func memcpy(dst: Ptr, src: Ptr, len: SizeT) -> Ptr
@unused_result
public func memmove(dst: Ptr, src: Ptr, n: SizeT) -> Ptr
public func memcmp(p0: Ptr, p1: Ptr, num: SizeT) -> Int
public func strncmp(s1: *[]ConstChar, s2: *[]ConstChar, n: SizeT) -> Int
public func strcmp(s1: *[]ConstChar, s2: *[]ConstChar) -> Int
@unused_result
public func strcpy(dst: *[]Char, src: *[]ConstChar) -> *[]Char
public func strlen(s: *[]ConstChar) -> SizeT
public func strcat(s1: *[]Char, s2: *[]ConstChar) -> *[]Char
public func strncat(s1: *[]Char, s2: *[]ConstChar, n: SizeT) -> *[]Char
public func strerror(error: Int) -> *[]Char

public func strcspn(str1: *Str8, str2: *Str8) -> SizeT
