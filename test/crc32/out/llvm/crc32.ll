
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
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
%__VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)



%CPU.Word = type i64
define weak i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU.Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU.Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %7
	%9 = load %CPU.Word, %CPU.Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %10
	%12 = load %CPU.Word, %CPU.Word* %11
	%13 = icmp ne %CPU.Word %9, %12
	br i1 %13 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%15 = load i64, i64* %4
	%16 = add i64 %15, 1
	store i64 %16, i64* %4
	br label %again_1
break_1:
	%17 = urem i64 %len, 8
	%18 = load i64, i64* %4
	%19 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU.Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU.Word* %22 to [0 x i8]*
	store i64 0, i64* %4
	br label %again_2
again_2:
	%24 = load i64, i64* %4
	%25 = icmp ult i64 %24, %17
	br i1 %25 , label %body_2, label %break_2
body_2:
	%26 = load i64, i64* %4
	%27 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %26
	%28 = load i8, i8* %27
	%29 = load i64, i64* %4
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %23, i32 0, i64 %29
	%31 = load i8, i8* %30
	%32 = icmp ne i8 %28, %31
	br i1 %32 , label %then_1, label %endif_1
then_1:
	ret i1 0
	br label %endif_1
endif_1:
	%34 = load i64, i64* %4
	%35 = add i64 %34, 1
	store i64 %35, i64* %4
	br label %again_2
break_2:
	ret i1 1
}

; MODULE: crc32

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Int8;
%Short = type %Int16;
%UnsignedShort = type %Int16;
%Int = type %Int32;
%UnsignedInt = type %Int32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Int64;
%Long = type %Int64;
%UnsignedLong = type %Int64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Int64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Int64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Int64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Int32;
%PIDT = type %Int32;
%UIDT = type %Int32;
%GIDT = type %Int32;
; from included stdio
%File = type %Int8;
%FposT = type %Int8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare %Int @vprintf(%ConstCharStr* %format, i8* %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, i8* %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, i8* %arg)
declare %Int @fgetc(%File* %f)
declare %Int @fputc(%Int %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %File* %f)
declare %Int @fputs(%ConstCharStr* %str, %File* %f)
declare %Int @getc(%File* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %File* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %File* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'crc32' --
; -- 0
; -- end print imports 'crc32' --
; -- strings --
@str1 = private constant [24 x i8] [i8 67, i8 82, i8 67, i8 91, i8 37, i8 48, i8 50, i8 88, i8 93, i8 32, i8 61, i8 32, i8 37, i8 48, i8 56, i8 120, i8 44, i8 32, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
; -- endstrings --

;include "libc/ctypes64"
;include "libc/stdio"

;
;  Name  : CRC-32
;  Poly  : 0x04C11DB7    xxor32 + xxor26 + xxor23 + xxor22 + xxor16 + xxor12 + xxor11
;                       + xxor10 + xxor8 + xxor7 + xxor5 + xxor4 + xxor2 + x + 1
;  Init  : 0xFFFFFFFF
;  Revert: true
;  XorOut: 0xFFFFFFFF
;  Check : 0xCBF43926 ("123456789")
;  MaxLen: 268 435 455 байт (2 147 483 647 бит) - обнаружение
;   одинарных, двойных, пакетных и всех нечетных ошибок
;
define %Word32 @crc32_run([0 x %Word8]* %buf, %Int32 %len) {
	%1 = alloca [256 x %Word32], align 1
	%2 = alloca %Word32, align 4

	;
	; create table before
	;
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	%4 = load %Int32, %Int32* %3
	%5 = icmp ult %Int32 %4, 256
	br %Bool %5 , label %body_1, label %break_1
body_1:
	%6 = load %Int32, %Int32* %3
	%7 = bitcast %Int32 %6 to %Word32
	store %Word32 %7, %Word32* %2
	%8 = alloca %Int32, align 4
	store %Int32 0, %Int32* %8
	br label %again_2
again_2:
	%9 = load %Int32, %Int32* %8
	%10 = icmp ult %Int32 %9, 8
	br %Bool %10 , label %body_2, label %break_2
body_2:
	%11 = load %Word32, %Word32* %2
	%12 = and %Word32 %11, 1
	%13 = icmp ne %Word32 %12, 0
	br %Bool %13 , label %then_0, label %else_0
then_0:
	%14 = load %Word32, %Word32* %2
	%15 = zext i8 1 to %Word32
	%16 = lshr %Word32 %14, %15
	%17 = xor %Word32 %16, 3988292384
	store %Word32 %17, %Word32* %2
	br label %endif_0
else_0:
	%18 = load %Word32, %Word32* %2
	%19 = zext i8 1 to %Word32
	%20 = lshr %Word32 %18, %19
	store %Word32 %20, %Word32* %2
	br label %endif_0
endif_0:
	%21 = load %Int32, %Int32* %8
	%22 = add %Int32 %21, 1
	store %Int32 %22, %Int32* %8
	br label %again_2
break_2:
	%23 = load %Int32, %Int32* %3
	%24 = getelementptr [256 x %Word32], [256 x %Word32]* %1, %Int32 0, %Int32 %23
	%25 = load %Word32, %Word32* %2
	store %Word32 %25, %Word32* %24
	%26 = load %Int32, %Int32* %3
	%27 = add %Int32 %26, 1
	store %Int32 %27, %Int32* %3
	br label %again_1
break_1:

	;
	; calculate CRC32
	;
	store %Word32 4294967295, %Word32* %2
	store %Int32 0, %Int32* %3
	br label %again_3
again_3:
	%28 = load %Int32, %Int32* %3
	%29 = icmp ult %Int32 %28, %len
	br %Bool %29 , label %body_3, label %break_3
body_3:
	; 1
	%30 = load %Int32, %Int32* %3
	%31 = getelementptr [0 x %Word8], [0 x %Word8]* %buf, %Int32 0, %Int32 %30
	%32 = load %Word8, %Word8* %31
	%33 = zext %Word8 %32 to %Word32
	%34 = load %Word32, %Word32* %2
	%35 = xor %Word32 %34, %33
	%36 = and %Word32 %35, 255
	%37 = load %Int32, %Int32* %3
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str1 to [0 x i8]*), %Int32 %37, %Word32 %33, %Word32 %36)
	; 2
	%39 = trunc %Word32 %36 to %Int8
	%40 = getelementptr [256 x %Word32], [256 x %Word32]* %1, %Int32 0, %Int8 %39
	%41 = load %Word32, %Word32* %2
	%42 = zext i8 8 to %Word32
	%43 = lshr %Word32 %41, %42
	%44 = load %Word32, %Word32* %40
	%45 = xor %Word32 %44, %43
	store %Word32 %45, %Word32* %2
	%46 = load %Int32, %Int32* %3
	%47 = add %Int32 %46, 1
	store %Int32 %47, %Int32* %3
	br label %again_3
break_3:
	%48 = load %Word32, %Word32* %2
	%49 = xor %Word32 %48, 4294967295
	ret %Word32 %49
}


