
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
%PtrDiffT = type i8*;
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
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
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
; -- endstrings --
@table = internal global [256 x %Word32] zeroinitializer
define void @crc32_init() {
	;var crc: Word32
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ult %Nat32 %2, 256
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = alloca %Word32, align 4
	%5 = load %Nat32, %Nat32* %1
	%6 = bitcast %Nat32 %5 to %Word32
	store %Word32 %6, %Word32* %4
	%7 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %7
; while_2
	br label %again_2
again_2:
	%8 = load %Nat32, %Nat32* %7
	%9 = icmp ult %Nat32 %8, 8
	br %Bool %9 , label %body_2, label %break_2
body_2:
; if_0
	%10 = zext i8 1 to %Word32
	%11 = load %Word32, %Word32* %4
	%12 = and %Word32 %11, %10
	%13 = zext i8 0 to %Word32
	%14 = icmp ne %Word32 %12, %13
	br %Bool %14 , label %then_0, label %else_0
then_0:
	%15 = load %Word32, %Word32* %4
	%16 = zext i8 1 to %Word32
	%17 = lshr %Word32 %15, %16
	%18 = xor %Word32 %17, 3988292384
	store %Word32 %18, %Word32* %4
	br label %endif_0
else_0:
	%19 = load %Word32, %Word32* %4
	%20 = zext i8 1 to %Word32
	%21 = lshr %Word32 %19, %20
	store %Word32 %21, %Word32* %4
	br label %endif_0
endif_0:
	%22 = load %Nat32, %Nat32* %7
	%23 = add %Nat32 %22, 1
	store %Nat32 %23, %Nat32* %7
	br label %again_2
break_2:
	%24 = load %Nat32, %Nat32* %1
	%25 = bitcast %Nat32 %24 to %Nat32
	%26 = getelementptr [256 x %Word32], [256 x %Word32]* @table, %Int32 0, %Nat32 %25
	%27 = load %Word32, %Word32* %4
	store %Word32 %27, %Word32* %26
	%28 = load %Nat32, %Nat32* %1
	%29 = add %Nat32 %28, 1
	store %Nat32 %29, %Nat32* %1
	br label %again_1
break_1:
	ret void
}

define %Word32 @crc32_run([0 x %Word8]* %buf, %Nat32 %len) {
	%1 = alloca %Word32, align 4
	store %Word32 4294967295, %Word32* %1
	%2 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %2
; while_1
	br label %again_1
again_1:
	%3 = load %Nat32, %Nat32* %2
	%4 = icmp ult %Nat32 %3, %len
	br %Bool %4 , label %body_1, label %break_1
body_1:
	; 1
	%5 = load %Nat32, %Nat32* %2
	%6 = bitcast %Nat32 %5 to %Nat32
	%7 = getelementptr [0 x %Word8], [0 x %Word8]* %buf, %Int32 0, %Nat32 %6
	%8 = load %Word8, %Word8* %7
	%9 = zext %Word8 %8 to %Word32
	%10 = load %Word32, %Word32* %1
	%11 = xor %Word32 %10, %9
	%12 = and %Word32 %11, 255
	; 2
	%13 = trunc %Word32 %12 to %Nat8
	%14 = zext %Nat8 %13 to %Nat32
	%15 = getelementptr [256 x %Word32], [256 x %Word32]* @table, %Int32 0, %Nat32 %14
	%16 = load %Word32, %Word32* %1
	%17 = zext i8 8 to %Word32
	%18 = lshr %Word32 %16, %17
	%19 = load %Word32, %Word32* %15
	%20 = xor %Word32 %19, %18
	store %Word32 %20, %Word32* %1
	%21 = load %Nat32, %Nat32* %2
	%22 = add %Nat32 %21, 1
	store %Nat32 %22, %Nat32* %2
	br label %again_1
break_1:
	%23 = load %Word32, %Word32* %1
	%24 = xor %Word32 %23, 4294967295
	ret %Word32 %24
}


