
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Float32 = type float
%Float64 = type double
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/utf.hm


declare i8 @utf32_to_utf8(i32 %c, [4 x i8]* %buf)
declare i8 @utf16_to_utf32([0 x i16]* %c, i32* %result)
declare void @utf8_putchar(i8 %c)
declare void @utf16_putchar(i16 %c)
declare void @utf32_putchar(i32 %c)
declare void @utf8_puts(%Str8* %s)
declare void @utf16_puts(%Str16* %s)
declare void @utf32_puts(%Str32* %s)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/lightfood/putchar.cm



define void @putchar8(i8 %c) {
	call void (i8) @utf8_putchar(i8 %c)
	ret void
}

define void @putchar16(i16 %c) {
	call void (i16) @utf16_putchar(i16 %c)
	ret void
}

define void @putchar32(i32 %c) {
	call void (i32) @utf32_putchar(i32 %c)
	ret void
}


