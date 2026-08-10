
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


; MODULE: literal

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
; -- print imports 'literal' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'literal' --
; -- strings --
@.str1 = private constant [34 x i8] [i8 116, i8 32, i8 61, i8 32, i8 37, i8 117, i8 44, i8 32, i8 102, i8 32, i8 61, i8 32, i8 37, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 49, i8 32, i8 97, i8 110, i8 100, i8 32, i8 48, i8 10, i8 0]
@.str2 = private constant [26 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 98, i8 111, i8 111, i8 108, i8 101, i8 97, i8 110, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 115, i8 10, i8 0]
@.str3 = private constant [21 x i8] [i8 110, i8 32, i8 61, i8 32, i8 37, i8 100, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str4 = private constant [28 x i8] [i8 98, i8 105, i8 103, i8 32, i8 61, i8 32, i8 37, i8 100, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 49, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 10, i8 0]
@.str5 = private constant [24 x i8] [i8 108, i8 101, i8 97, i8 100, i8 32, i8 61, i8 32, i8 37, i8 100, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 49, i8 48, i8 10, i8 0]
@.str6 = private constant [26 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 105, i8 110, i8 116, i8 101, i8 103, i8 101, i8 114, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 115, i8 10, i8 0]
@.str7 = private constant [22 x i8] [i8 98, i8 32, i8 61, i8 32, i8 37, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 50, i8 53, i8 53, i8 10, i8 0]
@.str8 = private constant [26 x i8] [i8 108, i8 111, i8 119, i8 101, i8 114, i8 32, i8 61, i8 32, i8 37, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 50, i8 53, i8 53, i8 10, i8 0]
@.str9 = private constant [24 x i8] [i8 119, i8 32, i8 61, i8 32, i8 37, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 54, i8 53, i8 53, i8 51, i8 53, i8 10, i8 0]
@.str10 = private constant [23 x i8] [i8 122, i8 101, i8 114, i8 111, i8 32, i8 61, i8 32, i8 37, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 48, i8 10, i8 0]
@.str11 = private constant [22 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 104, i8 101, i8 120, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 115, i8 10, i8 0]
@.str12 = private constant [43 x i8] [i8 105, i8 109, i8 97, i8 120, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 57, i8 50, i8 50, i8 51, i8 51, i8 55, i8 50, i8 48, i8 51, i8 54, i8 56, i8 53, i8 52, i8 55, i8 55, i8 53, i8 56, i8 48, i8 55, i8 10, i8 0]
@.str13 = private constant [44 x i8] [i8 105, i8 109, i8 105, i8 110, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 45, i8 57, i8 50, i8 50, i8 51, i8 51, i8 55, i8 50, i8 48, i8 51, i8 54, i8 56, i8 53, i8 52, i8 55, i8 55, i8 53, i8 56, i8 48, i8 56, i8 10, i8 0]
@.str14 = private constant [42 x i8] [i8 110, i8 109, i8 97, i8 120, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 44, i8 32, i8 104, i8 109, i8 97, i8 120, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 101, i8 113, i8 117, i8 97, i8 108, i8 10, i8 0]
@.str15 = private constant [41 x i8] [i8 101, i8 120, i8 97, i8 99, i8 116, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 57, i8 48, i8 48, i8 55, i8 49, i8 57, i8 57, i8 50, i8 53, i8 52, i8 55, i8 52, i8 48, i8 57, i8 57, i8 51, i8 10, i8 0]
@.str16 = private constant [45 x i8] [i8 101, i8 120, i8 97, i8 99, i8 116, i8 32, i8 45, i8 32, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 57, i8 48, i8 48, i8 55, i8 49, i8 57, i8 57, i8 50, i8 53, i8 52, i8 55, i8 52, i8 48, i8 57, i8 57, i8 50, i8 10, i8 0]
@.str17 = private constant [34 x i8] [i8 119, i8 105, i8 100, i8 101, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 52, i8 50, i8 57, i8 52, i8 57, i8 54, i8 55, i8 50, i8 57, i8 54, i8 10, i8 0]
@.str18 = private constant [32 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 108, i8 97, i8 114, i8 103, i8 101, i8 32, i8 105, i8 110, i8 116, i8 101, i8 103, i8 101, i8 114, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 115, i8 10, i8 0]
@.str19 = private constant [25 x i8] [i8 104, i8 97, i8 108, i8 102, i8 32, i8 61, i8 32, i8 37, i8 102, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 48, i8 46, i8 53, i8 10, i8 0]
@.str20 = private constant [32 x i8] [i8 109, i8 105, i8 120, i8 101, i8 100, i8 32, i8 61, i8 32, i8 37, i8 102, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 49, i8 48, i8 50, i8 52, i8 46, i8 48, i8 54, i8 50, i8 53, i8 10, i8 0]
@.str21 = private constant [25 x i8] [i8 102, i8 51, i8 50, i8 32, i8 61, i8 32, i8 37, i8 102, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 48, i8 46, i8 50, i8 53, i8 10, i8 0]
@.str22 = private constant [25 x i8] [i8 102, i8 54, i8 52, i8 32, i8 61, i8 32, i8 37, i8 102, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 48, i8 46, i8 50, i8 53, i8 10, i8 0]
@.str23 = private constant [27 x i8] [i8 119, i8 104, i8 111, i8 108, i8 101, i8 32, i8 61, i8 32, i8 37, i8 102, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 52, i8 50, i8 46, i8 48, i8 10, i8 0]
@.str24 = private constant [27 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 114, i8 97, i8 116, i8 105, i8 111, i8 110, i8 97, i8 108, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 115, i8 10, i8 0]
@.str25 = private constant [4 x i8] [i8 97, i8 98, i8 99, i8 0]
@.str26 = private constant [4 x i8] [i8 97, i8 98, i8 99, i8 0]
@.str27 = private constant [24 x i8] [i8 39, i8 97, i8 98, i8 99, i8 39, i8 32, i8 97, i8 110, i8 100, i8 32, i8 34, i8 97, i8 98, i8 99, i8 34, i8 32, i8 100, i8 105, i8 102, i8 102, i8 101, i8 114, i8 10, i8 0]
@.str28 = private constant [6 x i8] [i8 104, i8 101, i8 108, i8 108, i8 111, i8 0]
@.str29 = private constant [35 x i8] [i8 115, i8 116, i8 114, i8 108, i8 101, i8 110, i8 40, i8 34, i8 104, i8 101, i8 108, i8 108, i8 111, i8 34, i8 41, i8 32, i8 61, i8 32, i8 37, i8 122, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 53, i8 10, i8 0]
@.str30 = private constant [6 x i8] [i8 104, i8 101, i8 108, i8 108, i8 111, i8 0]
@.str31 = private constant [4 x i8] [i8 72, i8 105, i8 33, i8 0]
@.str32 = private constant [4 x i8] [i8 72, i8 105, i8 33, i8 0]
@.str33 = private constant [24 x i8] [i8 101, i8 115, i8 99, i8 32, i8 61, i8 32, i8 37, i8 115, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 72, i8 105, i8 33, i8 10, i8 0]
@.str34 = private constant [32 x i8] [i8 99, i8 104, i8 97, i8 114, i8 115, i8 32, i8 61, i8 32, i8 37, i8 117, i8 32, i8 37, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 55, i8 50, i8 32, i8 49, i8 48, i8 53, i8 10, i8 0]
@.str35 = private constant [21 x i8] [i8 99, i8 32, i8 61, i8 32, i8 37, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 54, i8 53, i8 10, i8 0]
@.str36 = private constant [25 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 115, i8 116, i8 114, i8 105, i8 110, i8 103, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 115, i8 10, i8 0]
@.str37 = private constant [38 x i8] [i8 97, i8 32, i8 61, i8 32, i8 91, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 93, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 91, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@.str38 = private constant [30 x i8] [i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 111, i8 102, i8 40, i8 97, i8 41, i8 32, i8 61, i8 32, i8 37, i8 117, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 51, i8 10, i8 0]
@.str39 = private constant [38 x i8] [i8 122, i8 32, i8 61, i8 32, i8 91, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 93, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 91, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 93, i8 10, i8 0]
@.str40 = private constant [24 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 115, i8 10, i8 0]
@.str41 = private constant [33 x i8] [i8 112, i8 32, i8 61, i8 32, i8 123, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 125, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 123, i8 49, i8 48, i8 44, i8 32, i8 50, i8 48, i8 125, i8 10, i8 0]
@.str42 = private constant [31 x i8] [i8 101, i8 32, i8 61, i8 32, i8 123, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 125, i8 44, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 123, i8 48, i8 44, i8 32, i8 48, i8 125, i8 10, i8 0]
@.str43 = private constant [25 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 115, i8 10, i8 0]
@.str44 = private constant [14 x i8] [i8 112, i8 32, i8 105, i8 115, i8 32, i8 110, i8 111, i8 116, i8 32, i8 110, i8 105, i8 108, i8 10, i8 0]
@.str45 = private constant [34 x i8] [i8 112, i8 32, i8 105, i8 115, i8 32, i8 110, i8 105, i8 108, i8 32, i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 116, i8 97, i8 107, i8 105, i8 110, i8 103, i8 32, i8 97, i8 110, i8 32, i8 97, i8 100, i8 100, i8 114, i8 101, i8 115, i8 115, i8 10, i8 0]
@.str46 = private constant [21 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 110, i8 105, i8 108, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 10, i8 0]
@.str47 = private constant [17 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 58, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 10, i8 0]
@.str48 = private constant [17 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 10, i8 0]
; -- endstrings --
%Point = type {
	%Int32,
	%Int32
};

define internal %Bool @testBoolean() {
	%1 = alloca %Bool, align 1
	store %Bool 1, %Bool* %1
	%2 = alloca %Bool, align 1
	store %Bool 0, %Bool* %2
; if_0
	%3 = load %Bool, %Bool* %1
	%4 = xor %Bool %3, 1
	%5 = load %Bool, %Bool* %2
	%6 = or %Bool %4, %5
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = load %Bool, %Bool* %1
	%8 = zext %Bool %7 to %Word32
	%9 = load %Bool, %Bool* %2
	%10 = zext %Bool %9 to %Word32
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @.str1 to [0 x i8]*), %Word32 %8, %Word32 %10)
	ret %Bool 0
	br label %endif_0
endif_0:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str2 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testInteger() {
	%1 = alloca %Int32, align 4
	store %Int32 42, %Int32* %1
; if_0
	%2 = load %Int32, %Int32* %1
	%3 = icmp ne %Int32 %2, 42
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = load %Int32, %Int32* %1
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str3 to [0 x i8]*), %Int32 %4)
	ret %Bool 0
	br label %endif_0
endif_0:
	%7 = alloca %Int32, align 4
	store %Int32 1000000, %Int32* %7
; if_1
	%8 = load %Int32, %Int32* %7
	%9 = icmp ne %Int32 %8, 1000000
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = load %Int32, %Int32* %7
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @.str4 to [0 x i8]*), %Int32 %10)
	ret %Bool 0
	br label %endif_1
endif_1:
	%13 = alloca %Int32, align 4
	store %Int32 10, %Int32* %13
; if_2
	%14 = load %Int32, %Int32* %13
	%15 = icmp ne %Int32 %14, 10
	br %Bool %15 , label %then_2, label %endif_2
then_2:
	%16 = load %Int32, %Int32* %13
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str5 to [0 x i8]*), %Int32 %16)
	ret %Bool 0
	br label %endif_2
endif_2:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str6 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testHex() {
	%1 = alloca %Nat32, align 4
	store %Nat32 255, %Nat32* %1
; if_0
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ne %Nat32 %2, 255
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = load %Nat32, %Nat32* %1
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str7 to [0 x i8]*), %Nat32 %4)
	ret %Bool 0
	br label %endif_0
endif_0:
	%7 = alloca %Nat32, align 4
	store %Nat32 255, %Nat32* %7
; if_1
	%8 = load %Nat32, %Nat32* %7
	%9 = load %Nat32, %Nat32* %1
	%10 = icmp ne %Nat32 %8, %9
	br %Bool %10 , label %then_1, label %endif_1
then_1:
	%11 = load %Nat32, %Nat32* %7
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str8 to [0 x i8]*), %Nat32 %11)
	ret %Bool 0
	br label %endif_1
endif_1:
	%14 = alloca %Nat32, align 4
	store %Nat32 65535, %Nat32* %14
; if_2
	%15 = load %Nat32, %Nat32* %14
	%16 = icmp ne %Nat32 %15, 65535
	br %Bool %16 , label %then_2, label %endif_2
then_2:
	%17 = load %Nat32, %Nat32* %14
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str9 to [0 x i8]*), %Nat32 %17)
	ret %Bool 0
	br label %endif_2
endif_2:
	%20 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %20
; if_3
	%21 = load %Nat32, %Nat32* %20
	%22 = icmp ne %Nat32 %21, 0
	br %Bool %22 , label %then_3, label %endif_3
then_3:
	%23 = load %Nat32, %Nat32* %20
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str10 to [0 x i8]*), %Nat32 %23)
	ret %Bool 0
	br label %endif_3
endif_3:
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str11 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testLarge() {
	%1 = alloca %Int64, align 8
	store %Int64 9223372036854775807, %Int64* %1
; if_0
	%2 = load %Int64, %Int64* %1
	%3 = sub %Int64 %2, 1
	%4 = icmp ne %Int64 %3, 9223372036854775806
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = load %Int64, %Int64* %1
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @.str12 to [0 x i8]*), %Int64 %5)
	ret %Bool 0
	br label %endif_0
endif_0:
	%8 = alloca %Int64, align 8
	%9 = sub i64 0, 9223372036854775808
	store %Int64 %9, %Int64* %8
; if_1
	%10 = load %Int64, %Int64* %8
	%11 = add %Int64 %10, 1
	%12 = sub i64 0, 9223372036854775807
	%13 = icmp ne %Int64 %11, %12
	br %Bool %13 , label %then_1, label %endif_1
then_1:
	%14 = load %Int64, %Int64* %8
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @.str13 to [0 x i8]*), %Int64 %14)
	ret %Bool 0
	br label %endif_1
endif_1:
	%17 = alloca %Nat64, align 8
	store %Nat64 18446744073709551615, %Nat64* %17
	%18 = alloca %Nat64, align 8
	store %Nat64 18446744073709551615, %Nat64* %18
; if_2
	%19 = load %Nat64, %Nat64* %17
	%20 = load %Nat64, %Nat64* %18
	%21 = icmp ne %Nat64 %19, %20
	br %Bool %21 , label %then_2, label %endif_2
then_2:
	%22 = load %Nat64, %Nat64* %17
	%23 = load %Nat64, %Nat64* %18
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([42 x i8]* @.str14 to [0 x i8]*), %Nat64 %22, %Nat64 %23)
	ret %Bool 0
	br label %endif_2
endif_2:
	%26 = alloca %Int64, align 8
	store %Int64 9007199254740993, %Int64* %26
; if_3
	%27 = load %Int64, %Int64* %26
	%28 = icmp eq %Int64 %27, 9007199254740992
	br %Bool %28 , label %then_3, label %endif_3
then_3:
	%29 = load %Int64, %Int64* %26
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([41 x i8]* @.str15 to [0 x i8]*), %Int64 %29)
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	%32 = load %Int64, %Int64* %26
	%33 = sub %Int64 %32, 1
	%34 = icmp ne %Int64 %33, 9007199254740992
	br %Bool %34 , label %then_4, label %endif_4
then_4:
	%35 = load %Int64, %Int64* %26
	%36 = sub %Int64 %35, 1
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([45 x i8]* @.str16 to [0 x i8]*), %Int64 %36)
	ret %Bool 0
	br label %endif_4
endif_4:
	%39 = alloca %Nat64, align 8
	store %Nat64 4294967296, %Nat64* %39
; if_5
	%40 = load %Nat64, %Nat64* %39
	%41 = icmp ne %Nat64 %40, 4294967296
	br %Bool %41 , label %then_5, label %endif_5
then_5:
	%42 = load %Nat64, %Nat64* %39
	%43 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @.str17 to [0 x i8]*), %Nat64 %42)
	ret %Bool 0
	br label %endif_5
endif_5:
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str18 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testRational() {
	%1 = alloca %Float64, align 8
	store %Float64 0.5000000000000000, %Float64* %1
; if_0
	%2 = load %Float64, %Float64* %1
	%3 = fcmp one %Float64 %2, 0.5000000000000000
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = load %Float64, %Float64* %1
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str19 to [0 x i8]*), %Float64 %4)
	ret %Bool 0
	br label %endif_0
endif_0:
	%7 = alloca %Float64, align 8
	store %Float64 1024.0625000000000000, %Float64* %7
; if_1
	%8 = load %Float64, %Float64* %7
	%9 = fcmp one %Float64 %8, 1024.0625000000000000
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = load %Float64, %Float64* %7
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str20 to [0 x i8]*), %Float64 %10)
	ret %Bool 0
	br label %endif_1
endif_1:
	%13 = alloca %Float32, align 4
	store %Float32 0.2500000000000000, %Float32* %13
	%14 = alloca %Float64, align 8
	store %Float64 0.2500000000000000, %Float64* %14
; if_2
	%15 = load %Float32, %Float32* %13
	%16 = fcmp one %Float32 %15, 0.2500000000000000
	br %Bool %16 , label %then_2, label %endif_2
then_2:
	%17 = load %Float32, %Float32* %13
	%18 = fpext %Float32 %17 to %Float64
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str21 to [0 x i8]*), %Float64 %18)
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%21 = load %Float64, %Float64* %14
	%22 = fcmp one %Float64 %21, 0.2500000000000000
	br %Bool %22 , label %then_3, label %endif_3
then_3:
	%23 = load %Float64, %Float64* %14
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str22 to [0 x i8]*), %Float64 %23)
	ret %Bool 0
	br label %endif_3
endif_3:
	%26 = alloca %Float64, align 8
	store %Float64 42.0000000000000000, %Float64* %26
; if_4
	%27 = load %Float64, %Float64* %26
	%28 = fcmp one %Float64 %27, 42.0000000000000000
	br %Bool %28 , label %then_4, label %endif_4
then_4:
	%29 = load %Float64, %Float64* %26
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str23 to [0 x i8]*), %Float64 %29)
	ret %Bool 0
	br label %endif_4
endif_4:
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str24 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testString() {
	%1 = alloca %Str8*, align 8
	store %Str8* bitcast ([4 x i8]* @.str25 to [0 x i8]*), %Str8** %1
	%2 = alloca %Str8*, align 8
	store %Str8* bitcast ([4 x i8]* @.str26 to [0 x i8]*), %Str8** %2
; if_0
	%3 = load %Str8*, %Str8** %1
	%4 = load %Str8*, %Str8** %2
	%5 = call %Int @strcmp(%Str8* %3, %Str8* %4)
	%6 = icmp ne %Int %5, 0
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str27 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%9 = call %SizeT @strlen([0 x %ConstChar]* bitcast ([6 x i8]* @.str28 to [0 x i8]*))
	%10 = icmp ne %SizeT %9, 5
	br %Bool %10 , label %then_1, label %endif_1
then_1:
	%11 = call %SizeT @strlen([0 x %ConstChar]* bitcast ([6 x i8]* @.str30 to [0 x i8]*))
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @.str29 to [0 x i8]*), %SizeT %11)
	ret %Bool 0
	br label %endif_1
endif_1:
	%14 = alloca %Str8*, align 8
	store %Str8* bitcast ([4 x i8]* @.str31 to [0 x i8]*), %Str8** %14
; if_2
	%15 = load %Str8*, %Str8** %14
	%16 = call %Int @strcmp(%Str8* %15, [0 x %ConstChar]* bitcast ([4 x i8]* @.str32 to [0 x i8]*))
	%17 = icmp ne %Int %16, 0
	br %Bool %17 , label %then_2, label %endif_2
then_2:
	%18 = load %Str8*, %Str8** %14
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str33 to [0 x i8]*), %Str8* %18)
	ret %Bool 0
	br label %endif_2
endif_2:
	%21 = alloca [2 x %Char8], align 1
	%22 = insertvalue [2 x %Char8] zeroinitializer, %Char8 72, 0
	%23 = insertvalue [2 x %Char8] %22, %Char8 105, 1
	%24 = zext i8 2 to %Nat32
	store [2 x %Char8] %23, [2 x %Char8]* %21
; if_3
	%25 = getelementptr [2 x %Char8], [2 x %Char8]* %21, %Int32 0, %Int32 0
	%26 = load %Char8, %Char8* %25
	%27 = icmp ne %Char8 %26, 72
	%28 = getelementptr [2 x %Char8], [2 x %Char8]* %21, %Int32 0, %Int32 1
	%29 = load %Char8, %Char8* %28
	%30 = icmp ne %Char8 %29, 105
	%31 = or %Bool %27, %30
	br %Bool %31 , label %then_3, label %endif_3
then_3:
	%32 = getelementptr [2 x %Char8], [2 x %Char8]* %21, %Int32 0, %Int32 0
	%33 = load %Char8, %Char8* %32
	%34 = zext %Char8 %33 to %Word32
	%35 = getelementptr [2 x %Char8], [2 x %Char8]* %21, %Int32 0, %Int32 1
	%36 = load %Char8, %Char8* %35
	%37 = zext %Char8 %36 to %Word32
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str34 to [0 x i8]*), %Word32 %34, %Word32 %37)
	ret %Bool 0
	br label %endif_3
endif_3:
	%40 = alloca %Char8, align 1
	store %Char8 65, %Char8* %40
; if_4
	%41 = load %Char8, %Char8* %40
	%42 = icmp ne %Char8 %41, 65
	br %Bool %42 , label %then_4, label %endif_4
then_4:
	%43 = load %Char8, %Char8* %40
	%44 = zext %Char8 %43 to %Word32
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str35 to [0 x i8]*), %Word32 %44)
	ret %Bool 0
	br label %endif_4
endif_4:
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str36 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testArray() {
	%1 = alloca [3 x %Int32], align 4
	%2 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%3 = insertvalue [3 x %Int32] %2, %Int32 2, 1
	%4 = insertvalue [3 x %Int32] %3, %Int32 3, 2
	%5 = zext i8 3 to %Nat32
	store [3 x %Int32] %4, [3 x %Int32]* %1
; if_0
	%6 = getelementptr [3 x %Int32], [3 x %Int32]* %1, %Int32 0, %Int32 0
	%7 = load %Int32, %Int32* %6
	%8 = icmp ne %Int32 %7, 1
	%9 = getelementptr [3 x %Int32], [3 x %Int32]* %1, %Int32 0, %Int32 1
	%10 = load %Int32, %Int32* %9
	%11 = icmp ne %Int32 %10, 2
	%12 = getelementptr [3 x %Int32], [3 x %Int32]* %1, %Int32 0, %Int32 2
	%13 = load %Int32, %Int32* %12
	%14 = icmp ne %Int32 %13, 3
	%15 = or %Bool %11, %14
	%16 = or %Bool %8, %15
	br %Bool %16 , label %then_0, label %endif_0
then_0:
	%17 = getelementptr [3 x %Int32], [3 x %Int32]* %1, %Int32 0, %Int32 0
	%18 = load %Int32, %Int32* %17
	%19 = getelementptr [3 x %Int32], [3 x %Int32]* %1, %Int32 0, %Int32 1
	%20 = load %Int32, %Int32* %19
	%21 = getelementptr [3 x %Int32], [3 x %Int32]* %1, %Int32 0, %Int32 2
	%22 = load %Int32, %Int32* %21
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @.str37 to [0 x i8]*), %Int32 %18, %Int32 %20, %Int32 %22)
	ret %Bool 0
	br label %endif_0
endif_0:
	%25 = alloca %Nat32, align 4
	store %Nat32 3, %Nat32* %25
; if_1
	%26 = load %Nat32, %Nat32* %25
	%27 = icmp ne %Nat32 %26, 3
	br %Bool %27 , label %then_1, label %endif_1
then_1:
	%28 = load %Nat32, %Nat32* %25
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str38 to [0 x i8]*), %Nat32 %28)
	ret %Bool 0
	br label %endif_1
endif_1:
	%31 = alloca [3 x %Int32], align 4
	%32 = zext i8 3 to %Nat32
	%33 = mul %Nat32 %32, 4
	%34 = bitcast [3 x %Int32]* %31 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %34, i8 0, %Nat32 %33, i1 0)
; if_2
	%35 = getelementptr [3 x %Int32], [3 x %Int32]* %31, %Int32 0, %Int32 0
	%36 = load %Int32, %Int32* %35
	%37 = icmp ne %Int32 %36, 0
	%38 = getelementptr [3 x %Int32], [3 x %Int32]* %31, %Int32 0, %Int32 1
	%39 = load %Int32, %Int32* %38
	%40 = icmp ne %Int32 %39, 0
	%41 = getelementptr [3 x %Int32], [3 x %Int32]* %31, %Int32 0, %Int32 2
	%42 = load %Int32, %Int32* %41
	%43 = icmp ne %Int32 %42, 0
	%44 = or %Bool %40, %43
	%45 = or %Bool %37, %44
	br %Bool %45 , label %then_2, label %endif_2
then_2:
	%46 = getelementptr [3 x %Int32], [3 x %Int32]* %31, %Int32 0, %Int32 0
	%47 = load %Int32, %Int32* %46
	%48 = getelementptr [3 x %Int32], [3 x %Int32]* %31, %Int32 0, %Int32 1
	%49 = load %Int32, %Int32* %48
	%50 = getelementptr [3 x %Int32], [3 x %Int32]* %31, %Int32 0, %Int32 2
	%51 = load %Int32, %Int32* %50
	%52 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @.str39 to [0 x i8]*), %Int32 %47, %Int32 %49, %Int32 %51)
	ret %Bool 0
	br label %endif_2
endif_2:
	%54 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str40 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testRecord() {
	%1 = alloca %Point, align 4
	%2 = insertvalue %Point zeroinitializer, %Int32 10, 0
	%3 = insertvalue %Point %2, %Int32 20, 1
	store %Point %3, %Point* %1
; if_0
	%4 = getelementptr %Point, %Point* %1, %Int32 0, %Int32 0
	%5 = load %Int32, %Int32* %4
	%6 = icmp ne %Int32 %5, 10
	%7 = getelementptr %Point, %Point* %1, %Int32 0, %Int32 1
	%8 = load %Int32, %Int32* %7
	%9 = icmp ne %Int32 %8, 20
	%10 = or %Bool %6, %9
	br %Bool %10 , label %then_0, label %endif_0
then_0:
	%11 = getelementptr %Point, %Point* %1, %Int32 0, %Int32 0
	%12 = load %Int32, %Int32* %11
	%13 = getelementptr %Point, %Point* %1, %Int32 0, %Int32 1
	%14 = load %Int32, %Int32* %13
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @.str41 to [0 x i8]*), %Int32 %12, %Int32 %14)
	ret %Bool 0
	br label %endif_0
endif_0:
	%17 = alloca %Point, align 4
	store %Point zeroinitializer, %Point* %17
; if_1
	%18 = getelementptr %Point, %Point* %17, %Int32 0, %Int32 0
	%19 = load %Int32, %Int32* %18
	%20 = icmp ne %Int32 %19, 0
	%21 = getelementptr %Point, %Point* %17, %Int32 0, %Int32 1
	%22 = load %Int32, %Int32* %21
	%23 = icmp ne %Int32 %22, 0
	%24 = or %Bool %20, %23
	br %Bool %24 , label %then_1, label %endif_1
then_1:
	%25 = getelementptr %Point, %Point* %17, %Int32 0, %Int32 0
	%26 = load %Int32, %Int32* %25
	%27 = getelementptr %Point, %Point* %17, %Int32 0, %Int32 1
	%28 = load %Int32, %Int32* %27
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @.str42 to [0 x i8]*), %Int32 %26, %Int32 %28)
	ret %Bool 0
	br label %endif_1
endif_1:
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str43 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testNil() {
	%1 = alloca %Int32*, align 8
	store %Int32* null, %Int32** %1
; if_0
	%2 = load %Int32*, %Int32** %1
	%3 = icmp ne %Int32* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str44 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%6 = alloca %Int32, align 4
	store %Int32 7, %Int32* %6
	store %Int32* %6, %Int32** %1
; if_1
	%7 = load %Int32*, %Int32** %1
	%8 = icmp eq %Int32* %7, null
	br %Bool %8 , label %then_1, label %endif_1
then_1:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @.str45 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str46 to [0 x i8]*))
	ret %Bool 1
}

define %Int @main() {
	%1 = alloca %Bool, align 1
	store %Bool 1, %Bool* %1
	%2 = call %Bool @testBoolean()
	%3 = load %Bool, %Bool* %1
	%4 = and %Bool %2, %3
	store %Bool %4, %Bool* %1
	%5 = call %Bool @testInteger()
	%6 = load %Bool, %Bool* %1
	%7 = and %Bool %5, %6
	store %Bool %7, %Bool* %1
	%8 = call %Bool @testHex()
	%9 = load %Bool, %Bool* %1
	%10 = and %Bool %8, %9
	store %Bool %10, %Bool* %1
	%11 = call %Bool @testLarge()
	%12 = load %Bool, %Bool* %1
	%13 = and %Bool %11, %12
	store %Bool %13, %Bool* %1
	%14 = call %Bool @testRational()
	%15 = load %Bool, %Bool* %1
	%16 = and %Bool %14, %15
	store %Bool %16, %Bool* %1
	%17 = call %Bool @testString()
	%18 = load %Bool, %Bool* %1
	%19 = and %Bool %17, %18
	store %Bool %19, %Bool* %1
	%20 = call %Bool @testArray()
	%21 = load %Bool, %Bool* %1
	%22 = and %Bool %20, %21
	store %Bool %22, %Bool* %1
	%23 = call %Bool @testRecord()
	%24 = load %Bool, %Bool* %1
	%25 = and %Bool %23, %24
	store %Bool %25, %Bool* %1
	%26 = call %Bool @testNil()
	%27 = load %Bool, %Bool* %1
	%28 = and %Bool %26, %27
	store %Bool %28, %Bool* %1
; if_0
	%29 = load %Bool, %Bool* %1
	%30 = xor %Bool %29, 1
	br %Bool %30 , label %then_0, label %endif_0
then_0:
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str47 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str48 to [0 x i8]*))
	ret %Int 0
}


