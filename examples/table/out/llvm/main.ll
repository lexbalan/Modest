
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
%Float16 = type half
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
%Float = type %Float32;
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
; from included stdlib
declare void @abort()
declare %Int @abs(%Int %x)
declare %Int @atexit(void ()* %x)
declare %Double @atof([0 x %ConstChar]* %nptr)
declare %Int @atoi([0 x %ConstChar]* %nptr)
declare %LongInt @atol([0 x %ConstChar]* %nptr)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare void @exit(%Int %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare %LongInt @labs(%LongInt %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(%SizeT %size)
declare %Int @system([0 x %ConstChar]* %string)
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare [0 x %Char]* @strncpy([0 x %Char]* %dst, [0 x %ConstChar]* %src, %SizeT %n)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"

; from import "table"
%table_Row = type [0 x %Str8*];
%table_Table = type {
	%table_Row*,
	[0 x %table_Row]*,
	%Nat32,
	%Nat32,
	%Bool
};

declare void @table_print(%table_Table* %table)

; end from import "table"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [2 x i8] [i8 35, i8 0]
@.str2 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 48, i8 0]
@.str3 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 49, i8 0]
@.str4 = private constant [2 x i8] [i8 48, i8 0]
@.str5 = private constant [5 x i8] [i8 65, i8 108, i8 101, i8 102, i8 0]
@.str6 = private constant [6 x i8] [i8 66, i8 101, i8 116, i8 104, i8 97, i8 0]
@.str7 = private constant [2 x i8] [i8 49, i8 0]
@.str8 = private constant [6 x i8] [i8 67, i8 108, i8 111, i8 99, i8 107, i8 0]
@.str9 = private constant [6 x i8] [i8 68, i8 101, i8 112, i8 116, i8 104, i8 0]
@.str10 = private constant [2 x i8] [i8 50, i8 0]
@.str11 = private constant [6 x i8] [i8 69, i8 97, i8 114, i8 116, i8 104, i8 0]
@.str12 = private constant [6 x i8] [i8 70, i8 105, i8 103, i8 104, i8 116, i8 0]
@.str13 = private constant [2 x i8] [i8 35, i8 0]
@.str14 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 48, i8 0]
@.str15 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 49, i8 0]
@.str16 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 50, i8 0]
@.str17 = private constant [2 x i8] [i8 48, i8 0]
@.str18 = private constant [5 x i8] [i8 65, i8 108, i8 101, i8 102, i8 0]
@.str19 = private constant [6 x i8] [i8 66, i8 101, i8 116, i8 104, i8 97, i8 0]
@.str20 = private constant [6 x i8] [i8 67, i8 108, i8 111, i8 99, i8 107, i8 0]
@.str21 = private constant [2 x i8] [i8 49, i8 0]
@.str22 = private constant [6 x i8] [i8 68, i8 101, i8 112, i8 116, i8 104, i8 0]
@.str23 = private constant [5 x i8] [i8 69, i8 109, i8 109, i8 97, i8 0]
@.str24 = private constant [5 x i8] [i8 70, i8 114, i8 101, i8 101, i8 0]
@.str25 = private constant [2 x i8] [i8 50, i8 0]
@.str26 = private constant [4 x i8] [i8 73, i8 110, i8 107, i8 0]
@.str27 = private constant [6 x i8] [i8 74, i8 117, i8 108, i8 105, i8 97, i8 0]
@.str28 = private constant [8 x i8] [i8 75, i8 101, i8 121, i8 119, i8 111, i8 114, i8 100, i8 0]
@.str29 = private constant [2 x i8] [i8 51, i8 0]
@.str30 = private constant [6 x i8] [i8 85, i8 108, i8 116, i8 114, i8 97, i8 0]
@.str31 = private constant [6 x i8] [i8 86, i8 105, i8 100, i8 101, i8 111, i8 0]
@.str32 = private constant [5 x i8] [i8 87, i8 111, i8 114, i8 100, i8 0]
@.str33 = private constant [2 x i8] [i8 10, i8 0]
@.str34 = private constant [2 x i8] [i8 10, i8 0]
@.str35 = private constant [2 x i8] [i8 10, i8 0]
@.str36 = private constant [2 x i8] [i8 10, i8 0]
@.str37 = private constant [2 x i8] [i8 10, i8 0]
; -- endstrings --
@table_header0 = internal global [3 x %Str8*] [
	%Str8* bitcast ([2 x i8]* @.str1 to [0 x i8]*),
	%Str8* bitcast ([8 x i8]* @.str2 to [0 x i8]*),
	%Str8* bitcast ([8 x i8]* @.str3 to [0 x i8]*)
]
@tableData0 = internal global [3 x [3 x %Str8*]] [
	[3 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @.str4 to [0 x i8]*),
		%Str8* bitcast ([5 x i8]* @.str5 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str6 to [0 x i8]*)
	],
	[3 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @.str7 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str8 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str9 to [0 x i8]*)
	],
	[3 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @.str10 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str11 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str12 to [0 x i8]*)
	]
]
@table_header1 = internal global [4 x %Str8*] [
	%Str8* bitcast ([2 x i8]* @.str13 to [0 x i8]*),
	%Str8* bitcast ([8 x i8]* @.str14 to [0 x i8]*),
	%Str8* bitcast ([8 x i8]* @.str15 to [0 x i8]*),
	%Str8* bitcast ([8 x i8]* @.str16 to [0 x i8]*)
]
@tableData1 = internal global [4 x [4 x %Str8*]] [
	[4 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @.str17 to [0 x i8]*),
		%Str8* bitcast ([5 x i8]* @.str18 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str19 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str20 to [0 x i8]*)
	],
	[4 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @.str21 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str22 to [0 x i8]*),
		%Str8* bitcast ([5 x i8]* @.str23 to [0 x i8]*),
		%Str8* bitcast ([5 x i8]* @.str24 to [0 x i8]*)
	],
	[4 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @.str25 to [0 x i8]*),
		%Str8* bitcast ([4 x i8]* @.str26 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str27 to [0 x i8]*),
		%Str8* bitcast ([8 x i8]* @.str28 to [0 x i8]*)
	],
	[4 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @.str29 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str30 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @.str31 to [0 x i8]*),
		%Str8* bitcast ([5 x i8]* @.str32 to [0 x i8]*)
	]
]
@table00 = internal global %table_Table {
	%table_Row* null,
	[0 x %table_Row]* @tableData0,
	%Nat32 3,
	%Nat32 3,
	%Bool 0
}
@table01 = internal global %table_Table {
	%table_Row* @table_header0,
	[0 x %table_Row]* @tableData0,
	%Nat32 3,
	%Nat32 3,
	%Bool 0
}
@table02 = internal global %table_Table {
	%table_Row* null,
	[0 x %table_Row]* @tableData0,
	%Nat32 3,
	%Nat32 3,
	%Bool 1
}
@table03 = internal global %table_Table {
	%table_Row* @table_header0,
	[0 x %table_Row]* @tableData0,
	%Nat32 3,
	%Nat32 3,
	%Bool 1
}
@table10 = internal global %table_Table {
	%table_Row* @table_header1,
	[0 x %table_Row]* @tableData1,
	%Nat32 4,
	%Nat32 4,
	%Bool 1
}
define %Int32 @main() {
	call void @table_print(%table_Table* @table00)
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str33 to [0 x i8]*))
	call void @table_print(%table_Table* @table01)
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str34 to [0 x i8]*))
	call void @table_print(%table_Table* @table02)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str35 to [0 x i8]*))
	call void @table_print(%table_Table* @table03)
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str36 to [0 x i8]*))
	call void @table_print(%table_Table* @table10)
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str37 to [0 x i8]*))
	ret %Int32 0
}


