$pragma do_not_include

include "ctypes64"
include "ctypes"

$pragma c_include "string.h"


@nodecorate
@attribute("value.type.to:dispensable")
export func memset(mem: Ptr, c: Int, n: SizeT) -> Ptr
@attribute("value.type.to:dispensable")
export func memcpy(dst: Ptr, src: Ptr, len: SizeT) -> Ptr
@attribute("value.type.to:dispensable")
export func memmove(dst: Ptr, src: Ptr, n: SizeT) -> Ptr
export func memcmp(p0: Ptr, p1: Ptr, num: SizeT) -> Int
export func strncmp(s1: *[]ConstChar, s2: *[]ConstChar, n: SizeT) -> Int
export func strcmp(s1: *[]ConstChar, s2: *[]ConstChar) -> Int
@attribute("value.type.to:dispensable")
export func strcpy(dst: *[]Char, src: *[]ConstChar) -> *[]Char
export func strlen(s: *[]ConstChar) -> SizeT
export func strcat(s1: *[]Char, s2: *[]ConstChar) -> *[]Char
export func strncat(s1: *[]Char, s2: *[]ConstChar, n: SizeT) -> *[]Char
export func strerror(error: Int) -> *[]Char

