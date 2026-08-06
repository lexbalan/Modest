
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Word256 = type i256
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Int256 = type i256
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Nat256 = type i256
%Float32 = type float
%Float64 = type double
%Fixed32 = type i32
%Fixed64 = type i64
%Size = type i64
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%__VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)


; MODULE: main

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float64;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type %Int64;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(i8* %f)
declare %Int @feof(i8* %f)
declare %Int @ferror(i8* %f)
declare %Int @fflush(i8* %f)
declare %Int @fgetpos(i8* %f, %FposT* %pos)
declare i8* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare i8* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, i8* %f)
declare %Int @fseek(i8* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(i8* %f, %FposT* %pos)
declare %LongInt @ftell(i8* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(i8* %f)
declare void @setbuf(i8* %f, %CharStr* %buf)
declare %Int @setvbuf(i8* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare i8* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(i8* %f, %Str* %format, ...)
declare %Int @fscanf(i8* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(i8* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(i8* %f)
declare %Int @fputc(%Int %char, i8* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, i8* %f)
declare %Int @fputs(%ConstCharStr* %str, i8* %f)
declare %Int @getc(i8* %f)
declare %Int @getchar()
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [13 x i8] [i8 102, i8 49, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str2 = private constant [13 x i8] [i8 102, i8 50, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str3 = private constant [13 x i8] [i8 102, i8 51, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str4 = private constant [13 x i8] [i8 102, i8 52, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str5 = private constant [14 x i8] [i8 102, i8 49, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str6 = private constant [14 x i8] [i8 102, i8 50, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str7 = private constant [14 x i8] [i8 102, i8 51, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str8 = private constant [14 x i8] [i8 102, i8 52, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --
%Type1 = type {
	%Int32
};

%Type2 = type {
	%Int32
};

%Type3 = type {
	%Int32
};



; Check by value
define internal void @f1_val(%Type1 %x) {
	%1 = extractvalue %Type1 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str1 to [0 x i8]*), %Int32 %1)
	ret void
}

define internal void @f2_val(%Type2 %x) {
	%1 = extractvalue %Type2 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str2 to [0 x i8]*), %Int32 %1)
	ret void
}

define internal void @f3_val(%Type3 %x) {
	%1 = extractvalue %Type3 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str3 to [0 x i8]*), %Int32 %1)
	ret void
}

define internal void @f4_val({%Int32} %x) {
	%1 = extractvalue {%Int32} %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str4 to [0 x i8]*), %Int32 %1)
	ret void
}



; Check by pointer
define internal void @f1_ptr(%Type1* %x) {
	%1 = getelementptr %Type1, %Type1* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str5 to [0 x i8]*), %Int32 %2)
	ret void
}

define internal void @f2_ptr(%Type2* %x) {
	%1 = getelementptr %Type2, %Type2* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str6 to [0 x i8]*), %Int32 %2)
	ret void
}

define internal void @f3_ptr(%Type3* %x) {
	%1 = getelementptr %Type3, %Type3* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str7 to [0 x i8]*), %Int32 %2)
	ret void
}

define internal void @f4_ptr({%Int32}* %x) {
	%1 = getelementptr {%Int32}, {%Int32}* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str8 to [0 x i8]*), %Int32 %2)
	ret void
}

@a = internal global %Type1 {
	%Int32 1
}
@b = internal global %Type2 {
	%Int32 2
}
@c = internal global %Type3 {
	%Int32 3
}
define internal void @test_by_value() {
	call void @f1_val(%Type1 zeroinitializer)
	call void @f2_val(%Type2 zeroinitializer)
	call void @f3_val(%Type3 zeroinitializer)
	call void @f4_val({%Int32} zeroinitializer)
	call void @f1_val(%Type1 zeroinitializer)
	call void @f2_val(%Type2 zeroinitializer)
	call void @f3_val(%Type3 zeroinitializer)
	call void @f4_val({%Int32} zeroinitializer)
	%1 = load %Type1, %Type1* @a
	call void @f1_val(%Type1 %1)
; -- cons_composite_from_composite_by_adr --
	%2 = bitcast %Type1* @a to %Type2*
	%3 = load %Type2, %Type2* %2
; -- end cons_composite_from_composite_by_adr --
	call void @f2_val(%Type2 %3)
	%4 = load %Type1, %Type1* @a
	call void @f3_val(%Type1 %4)
; -- cons_composite_from_composite_by_adr --
	%5 = bitcast %Type1* @a to {%Int32}*
	%6 = load {%Int32}, {%Int32}* %5
; -- end cons_composite_from_composite_by_adr --
	call void @f4_val({%Int32} %6)
; -- cons_composite_from_composite_by_adr --
	%7 = bitcast %Type2* @b to %Type1*
	%8 = load %Type1, %Type1* %7
; -- end cons_composite_from_composite_by_adr --
	call void @f1_val(%Type1 %8)
	%9 = load %Type2, %Type2* @b
	call void @f2_val(%Type2 %9)
; -- cons_composite_from_composite_by_adr --
	%10 = bitcast %Type2* @b to %Type3*
	%11 = load %Type3, %Type3* %10
; -- end cons_composite_from_composite_by_adr --
	call void @f3_val(%Type3 %11)
; -- cons_composite_from_composite_by_adr --
	%12 = bitcast %Type2* @b to {%Int32}*
	%13 = load {%Int32}, {%Int32}* %12
; -- end cons_composite_from_composite_by_adr --
	call void @f4_val({%Int32} %13)
	%14 = load %Type3, %Type3* @c
	call void @f1_val(%Type3 %14)
; -- cons_composite_from_composite_by_adr --
	%15 = bitcast %Type3* @c to %Type2*
	%16 = load %Type2, %Type2* %15
; -- end cons_composite_from_composite_by_adr --
	call void @f2_val(%Type2 %16)
	%17 = load %Type3, %Type3* @c
	call void @f3_val(%Type3 %17)
; -- cons_composite_from_composite_by_adr --
	%18 = bitcast %Type3* @c to {%Int32}*
	%19 = load {%Int32}, {%Int32}* %18
; -- end cons_composite_from_composite_by_adr --
	call void @f4_val({%Int32} %19)
	ret void
}

define internal void @test_by_pointer() {
	call void @f1_ptr(%Type1* @a)
	%1 = bitcast %Type1* @a to %Type2*
	call void @f2_ptr(%Type2* %1)
	call void @f3_ptr(%Type1* @a)
	%2 = bitcast %Type1* @a to {%Int32}*
	call void @f4_ptr({%Int32}* %2)
	%3 = bitcast %Type2* @b to %Type1*
	call void @f1_ptr(%Type1* %3)
	call void @f2_ptr(%Type2* @b)
	%4 = bitcast %Type2* @b to %Type3*
	call void @f3_ptr(%Type3* %4)
	%5 = bitcast %Type2* @b to {%Int32}*
	call void @f4_ptr({%Int32}* %5)
	call void @f1_ptr(%Type3* @c)
	%6 = bitcast %Type3* @c to %Type2*
	call void @f2_ptr(%Type2* %6)
	call void @f3_ptr(%Type3* @c)
	%7 = bitcast %Type3* @c to {%Int32}*
	call void @f4_ptr({%Int32}* %7)
	ret void
}

define %Int @main() {
	call void @test_by_value()
	call void @test_by_pointer()
	ret %Int 0
}


