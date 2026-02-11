
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
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [6 x i8] [i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str2 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str3 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
%Key = type [8 x %Word32];
define internal %Word32 @rotl32(%Word32 %x, %Nat32 %n) {
	%1 = bitcast %Nat32 %n to %Word32
	%2 = shl %Word32 %x, %1
	%3 = sub %Nat32 32, %n
	%4 = bitcast %Nat32 %3 to %Word32
	%5 = lshr %Word32 %x, %4
	%6 = or %Word32 %2, %5
	ret %Word32 %6
}

define internal void @quarterRound([4 x %Word32]* %0, %Word32 %a, %Word32 %b, %Word32 %c, %Word32 %d) {
	%2 = alloca %Word32, align 4
	store %Word32 %a, %Word32* %2
	%3 = alloca %Word32, align 4
	store %Word32 %b, %Word32* %3
	%4 = alloca %Word32, align 4
	store %Word32 %c, %Word32* %4
	%5 = alloca %Word32, align 4
	store %Word32 %d, %Word32* %5
	%6 = load %Word32, %Word32* %2
	%7 = bitcast %Word32 %6 to %Nat32
	%8 = load %Word32, %Word32* %3
	%9 = bitcast %Word32 %8 to %Nat32
	%10 = add %Nat32 %7, %9
	%11 = bitcast %Nat32 %10 to %Word32
	store %Word32 %11, %Word32* %2
	%12 = load %Word32, %Word32* %5
	%13 = load %Word32, %Word32* %2
	%14 = xor %Word32 %12, %13
	%15 = call %Word32 @rotl32(%Word32 %14, %Nat32 16)
	store %Word32 %15, %Word32* %5
	%16 = load %Word32, %Word32* %4
	%17 = bitcast %Word32 %16 to %Nat32
	%18 = load %Word32, %Word32* %5
	%19 = bitcast %Word32 %18 to %Nat32
	%20 = add %Nat32 %17, %19
	%21 = bitcast %Nat32 %20 to %Word32
	store %Word32 %21, %Word32* %4
	%22 = load %Word32, %Word32* %3
	%23 = load %Word32, %Word32* %4
	%24 = xor %Word32 %22, %23
	%25 = call %Word32 @rotl32(%Word32 %24, %Nat32 12)
	store %Word32 %25, %Word32* %3
	%26 = load %Word32, %Word32* %2
	%27 = bitcast %Word32 %26 to %Nat32
	%28 = load %Word32, %Word32* %3
	%29 = bitcast %Word32 %28 to %Nat32
	%30 = add %Nat32 %27, %29
	%31 = bitcast %Nat32 %30 to %Word32
	store %Word32 %31, %Word32* %2
	%32 = load %Word32, %Word32* %5
	%33 = load %Word32, %Word32* %2
	%34 = xor %Word32 %32, %33
	%35 = call %Word32 @rotl32(%Word32 %34, %Nat32 8)
	store %Word32 %35, %Word32* %5
	%36 = load %Word32, %Word32* %4
	%37 = bitcast %Word32 %36 to %Nat32
	%38 = load %Word32, %Word32* %5
	%39 = bitcast %Word32 %38 to %Nat32
	%40 = add %Nat32 %37, %39
	%41 = bitcast %Nat32 %40 to %Word32
	store %Word32 %41, %Word32* %4
	%42 = load %Word32, %Word32* %3
	%43 = load %Word32, %Word32* %4
	%44 = xor %Word32 %42, %43
	%45 = call %Word32 @rotl32(%Word32 %44, %Nat32 7)
	store %Word32 %45, %Word32* %3
	%46 = load %Word32, %Word32* %2
	%47 = load %Word32, %Word32* %3
	%48 = load %Word32, %Word32* %4
	%49 = load %Word32, %Word32* %5
	%50 = load %Word32, %Word32* %2
	%51 = insertvalue [4 x %Word32] zeroinitializer, %Word32 %50, 0
	%52 = load %Word32, %Word32* %3
	%53 = insertvalue [4 x %Word32] %51, %Word32 %52, 1
	%54 = load %Word32, %Word32* %4
	%55 = insertvalue [4 x %Word32] %53, %Word32 %54, 2
	%56 = load %Word32, %Word32* %5
	%57 = insertvalue [4 x %Word32] %55, %Word32 %56, 3
; -- cons_composite_from_composite_by_value --
	%58 = alloca [4 x %Word32]
	%59 = zext i8 4 to %Nat32
	store [4 x %Word32] %57, [4 x %Word32]* %58
	%60 = bitcast [4 x %Word32]* %58 to [4 x %Word32]*
; -- end cons_composite_from_composite_by_value --
	%61 = load [4 x %Word32], [4 x %Word32]* %60
	%62 = zext i8 4 to %Nat32
	store [4 x %Word32] %61, [4 x %Word32]* %0
	ret void
}

define internal void @chacha20Block([16 x %Word32]* %0, [16 x %Word32] %__state) {
	%state = alloca [16 x %Word32]
	%2 = zext i8 16 to %Nat32
	store [16 x %Word32] %__state, [16 x %Word32]* %state
	%3 = alloca [16 x %Word32], align 1
	%4 = load [16 x %Word32], [16 x %Word32]* %state
	%5 = zext i8 16 to %Nat32
	store [16 x %Word32] %4, [16 x %Word32]* %3	; working copy
	%6 = alloca %Int32, align 4
	store %Int32 0, %Int32* %6
; while_1
	br label %again_1
again_1:
	%7 = load %Int32, %Int32* %6
	%8 = icmp slt %Int32 %7, 10
	br %Bool %8 , label %body_1, label %break_1
body_1:
	%9 = alloca [4 x %Word32], align 1

	; column rounds
	%10 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 0
	%11 = load %Word32, %Word32* %10
	%12 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 4
	%13 = load %Word32, %Word32* %12
	%14 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 8
	%15 = load %Word32, %Word32* %14
	%16 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 12
	%17 = load %Word32, %Word32* %16; alloca memory for return value
	%18 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %18, %Word32 %11, %Word32 %13, %Word32 %15, %Word32 %17)
	%19 = load [4 x %Word32], [4 x %Word32]* %18
	%20 = zext i8 4 to %Nat32
	store [4 x %Word32] %19, [4 x %Word32]* %9
	%21 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 0
	%22 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%23 = load %Word32, %Word32* %22
	store %Word32 %23, %Word32* %21
	%24 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 4
	%25 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%26 = load %Word32, %Word32* %25
	store %Word32 %26, %Word32* %24
	%27 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 8
	%28 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%29 = load %Word32, %Word32* %28
	store %Word32 %29, %Word32* %27
	%30 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 12
	%31 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%32 = load %Word32, %Word32* %31
	store %Word32 %32, %Word32* %30
	%33 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 1
	%34 = load %Word32, %Word32* %33
	%35 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 5
	%36 = load %Word32, %Word32* %35
	%37 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 9
	%38 = load %Word32, %Word32* %37
	%39 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 13
	%40 = load %Word32, %Word32* %39; alloca memory for return value
	%41 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %41, %Word32 %34, %Word32 %36, %Word32 %38, %Word32 %40)
	%42 = load [4 x %Word32], [4 x %Word32]* %41
	%43 = zext i8 4 to %Nat32
	store [4 x %Word32] %42, [4 x %Word32]* %9
	%44 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 1
	%45 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%46 = load %Word32, %Word32* %45
	store %Word32 %46, %Word32* %44
	%47 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 5
	%48 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%49 = load %Word32, %Word32* %48
	store %Word32 %49, %Word32* %47
	%50 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 9
	%51 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%52 = load %Word32, %Word32* %51
	store %Word32 %52, %Word32* %50
	%53 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 13
	%54 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%55 = load %Word32, %Word32* %54
	store %Word32 %55, %Word32* %53
	%56 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 2
	%57 = load %Word32, %Word32* %56
	%58 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 6
	%59 = load %Word32, %Word32* %58
	%60 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 10
	%61 = load %Word32, %Word32* %60
	%62 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 14
	%63 = load %Word32, %Word32* %62; alloca memory for return value
	%64 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %64, %Word32 %57, %Word32 %59, %Word32 %61, %Word32 %63)
	%65 = load [4 x %Word32], [4 x %Word32]* %64
	%66 = zext i8 4 to %Nat32
	store [4 x %Word32] %65, [4 x %Word32]* %9
	%67 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 2
	%68 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%69 = load %Word32, %Word32* %68
	store %Word32 %69, %Word32* %67
	%70 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 6
	%71 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%72 = load %Word32, %Word32* %71
	store %Word32 %72, %Word32* %70
	%73 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 10
	%74 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%75 = load %Word32, %Word32* %74
	store %Word32 %75, %Word32* %73
	%76 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 14
	%77 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%78 = load %Word32, %Word32* %77
	store %Word32 %78, %Word32* %76
	%79 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 3
	%80 = load %Word32, %Word32* %79
	%81 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 7
	%82 = load %Word32, %Word32* %81
	%83 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 11
	%84 = load %Word32, %Word32* %83
	%85 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 15
	%86 = load %Word32, %Word32* %85; alloca memory for return value
	%87 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %87, %Word32 %80, %Word32 %82, %Word32 %84, %Word32 %86)
	%88 = load [4 x %Word32], [4 x %Word32]* %87
	%89 = zext i8 4 to %Nat32
	store [4 x %Word32] %88, [4 x %Word32]* %9
	%90 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 3
	%91 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%92 = load %Word32, %Word32* %91
	store %Word32 %92, %Word32* %90
	%93 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 7
	%94 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%95 = load %Word32, %Word32* %94
	store %Word32 %95, %Word32* %93
	%96 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 11
	%97 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%98 = load %Word32, %Word32* %97
	store %Word32 %98, %Word32* %96
	%99 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 15
	%100 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%101 = load %Word32, %Word32* %100
	store %Word32 %101, %Word32* %99


	; diagonal rounds
	%102 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 0
	%103 = load %Word32, %Word32* %102
	%104 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 5
	%105 = load %Word32, %Word32* %104
	%106 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 10
	%107 = load %Word32, %Word32* %106
	%108 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 15
	%109 = load %Word32, %Word32* %108; alloca memory for return value
	%110 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %110, %Word32 %103, %Word32 %105, %Word32 %107, %Word32 %109)
	%111 = load [4 x %Word32], [4 x %Word32]* %110
	%112 = zext i8 4 to %Nat32
	store [4 x %Word32] %111, [4 x %Word32]* %9
	%113 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 0
	%114 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%115 = load %Word32, %Word32* %114
	store %Word32 %115, %Word32* %113
	%116 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 5
	%117 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%118 = load %Word32, %Word32* %117
	store %Word32 %118, %Word32* %116
	%119 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 10
	%120 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%121 = load %Word32, %Word32* %120
	store %Word32 %121, %Word32* %119
	%122 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 15
	%123 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%124 = load %Word32, %Word32* %123
	store %Word32 %124, %Word32* %122
	%125 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 1
	%126 = load %Word32, %Word32* %125
	%127 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 6
	%128 = load %Word32, %Word32* %127
	%129 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 11
	%130 = load %Word32, %Word32* %129
	%131 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 12
	%132 = load %Word32, %Word32* %131; alloca memory for return value
	%133 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %133, %Word32 %126, %Word32 %128, %Word32 %130, %Word32 %132)
	%134 = load [4 x %Word32], [4 x %Word32]* %133
	%135 = zext i8 4 to %Nat32
	store [4 x %Word32] %134, [4 x %Word32]* %9
	%136 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 1
	%137 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%138 = load %Word32, %Word32* %137
	store %Word32 %138, %Word32* %136
	%139 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 6
	%140 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%141 = load %Word32, %Word32* %140
	store %Word32 %141, %Word32* %139
	%142 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 11
	%143 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%144 = load %Word32, %Word32* %143
	store %Word32 %144, %Word32* %142
	%145 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 12
	%146 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%147 = load %Word32, %Word32* %146
	store %Word32 %147, %Word32* %145
	%148 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 2
	%149 = load %Word32, %Word32* %148
	%150 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 7
	%151 = load %Word32, %Word32* %150
	%152 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 8
	%153 = load %Word32, %Word32* %152
	%154 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 13
	%155 = load %Word32, %Word32* %154; alloca memory for return value
	%156 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %156, %Word32 %149, %Word32 %151, %Word32 %153, %Word32 %155)
	%157 = load [4 x %Word32], [4 x %Word32]* %156
	%158 = zext i8 4 to %Nat32
	store [4 x %Word32] %157, [4 x %Word32]* %9
	%159 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 2
	%160 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%161 = load %Word32, %Word32* %160
	store %Word32 %161, %Word32* %159
	%162 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 7
	%163 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%164 = load %Word32, %Word32* %163
	store %Word32 %164, %Word32* %162
	%165 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 8
	%166 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%167 = load %Word32, %Word32* %166
	store %Word32 %167, %Word32* %165
	%168 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 13
	%169 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%170 = load %Word32, %Word32* %169
	store %Word32 %170, %Word32* %168
	%171 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 3
	%172 = load %Word32, %Word32* %171
	%173 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 4
	%174 = load %Word32, %Word32* %173
	%175 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 9
	%176 = load %Word32, %Word32* %175
	%177 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 14
	%178 = load %Word32, %Word32* %177; alloca memory for return value
	%179 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %179, %Word32 %172, %Word32 %174, %Word32 %176, %Word32 %178)
	%180 = load [4 x %Word32], [4 x %Word32]* %179
	%181 = zext i8 4 to %Nat32
	store [4 x %Word32] %180, [4 x %Word32]* %9
	%182 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 3
	%183 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%184 = load %Word32, %Word32* %183
	store %Word32 %184, %Word32* %182
	%185 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 4
	%186 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%187 = load %Word32, %Word32* %186
	store %Word32 %187, %Word32* %185
	%188 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 9
	%189 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%190 = load %Word32, %Word32* %189
	store %Word32 %190, %Word32* %188
	%191 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 14
	%192 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%193 = load %Word32, %Word32* %192
	store %Word32 %193, %Word32* %191
	%194 = load %Int32, %Int32* %6
	%195 = add %Int32 %194, 1
	store %Int32 %195, %Int32* %6
	br label %again_1
break_1:

	; add original state
	%196 = alloca [16 x %Word32], align 1
	%197 = alloca %Int32, align 4
	store %Int32 0, %Int32* %197
; while_2
	br label %again_2
again_2:
	%198 = load %Int32, %Int32* %197
	%199 = icmp slt %Int32 %198, 16
	br %Bool %199 , label %body_2, label %break_2
body_2:
	%200 = load %Int32, %Int32* %197
	%201 = getelementptr [16 x %Word32], [16 x %Word32]* %196, %Int32 0, %Int32 %200
	%202 = load %Int32, %Int32* %197
	%203 = getelementptr [16 x %Word32], [16 x %Word32]* %3, %Int32 0, %Int32 %202
	%204 = load %Word32, %Word32* %203
	%205 = bitcast %Word32 %204 to %Nat32
	%206 = load %Int32, %Int32* %197
	%207 = getelementptr [16 x %Word32], [16 x %Word32]* %state, %Int32 0, %Int32 %206
	%208 = load %Word32, %Word32* %207
	%209 = bitcast %Word32 %208 to %Nat32
	%210 = add %Nat32 %205, %209
	%211 = bitcast %Nat32 %210 to %Word32
	store %Word32 %211, %Word32* %201
	%212 = load %Int32, %Int32* %197
	%213 = add %Int32 %212, 1
	store %Int32 %213, %Int32* %197
	br label %again_2
break_2:
	%214 = load [16 x %Word32], [16 x %Word32]* %196
	%215 = zext i8 16 to %Nat32
	store [16 x %Word32] %214, [16 x %Word32]* %0
	ret void
}



; nonce = number used once
; Чтобы один и тот же ключ можно было использовать много раз.
; Если шифровать два сообщения одним ключом keystream будет одинаковым - это катастрофа
; Он НЕ секретный. Его обычно: передают вместе с сообщением
; кладут в заголовок пакета хранят рядом с ciphertext
; ⚠️ Самое важное правило: Nonce нельзя повторять с тем же ключом. Никогда.
; Важное правило: Nonce не нужно секретить. Ты можешь просто записать его в самое начало зашифрованного файла (первые 12 байт).
; Чтобы расшифровать файл, тебе понадобятся твой секретный ключ (который в голове или в сейфе) и этот Nonce
; (который прикреплен к файлу).
; Итог: Оставь Nonce открытым. Сила ChaCha20 не в секретности Nonce, а в том, что даже зная его, никто не сможет вычислить ключ.
define internal void @makeState([16 x %Word32]* %0, %Key* %key, %Word32 %counter, [3 x %Word32]* %nonce) {
	%2 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 0
	%3 = load %Word32, %Word32* %2
	%4 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 1
	%5 = load %Word32, %Word32* %4
	%6 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 2
	%7 = load %Word32, %Word32* %6
	%8 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 3
	%9 = load %Word32, %Word32* %8
	%10 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 4
	%11 = load %Word32, %Word32* %10
	%12 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 5
	%13 = load %Word32, %Word32* %12
	%14 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 6
	%15 = load %Word32, %Word32* %14
	%16 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 7
	%17 = load %Word32, %Word32* %16
	%18 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 0
	%19 = load %Word32, %Word32* %18
	%20 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 1
	%21 = load %Word32, %Word32* %20
	%22 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 2
	%23 = load %Word32, %Word32* %22
	%24 = insertvalue [16 x %Word32] zeroinitializer, %Word32 1634760805, 0
	%25 = insertvalue [16 x %Word32] %24, %Word32 857760878, 1
	%26 = insertvalue [16 x %Word32] %25, %Word32 2036477234, 2
	%27 = insertvalue [16 x %Word32] %26, %Word32 1797285236, 3
	%28 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 0
	%29 = load %Word32, %Word32* %28
	%30 = insertvalue [16 x %Word32] %27, %Word32 %29, 4
	%31 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 1
	%32 = load %Word32, %Word32* %31
	%33 = insertvalue [16 x %Word32] %30, %Word32 %32, 5
	%34 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 2
	%35 = load %Word32, %Word32* %34
	%36 = insertvalue [16 x %Word32] %33, %Word32 %35, 6
	%37 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 3
	%38 = load %Word32, %Word32* %37
	%39 = insertvalue [16 x %Word32] %36, %Word32 %38, 7
	%40 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 4
	%41 = load %Word32, %Word32* %40
	%42 = insertvalue [16 x %Word32] %39, %Word32 %41, 8
	%43 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 5
	%44 = load %Word32, %Word32* %43
	%45 = insertvalue [16 x %Word32] %42, %Word32 %44, 9
	%46 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 6
	%47 = load %Word32, %Word32* %46
	%48 = insertvalue [16 x %Word32] %45, %Word32 %47, 10
	%49 = getelementptr %Key, %Key* %key, %Int32 0, %Int32 7
	%50 = load %Word32, %Word32* %49
	%51 = insertvalue [16 x %Word32] %48, %Word32 %50, 11
	%52 = insertvalue [16 x %Word32] %51, %Word32 %counter, 12
	%53 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 0
	%54 = load %Word32, %Word32* %53
	%55 = insertvalue [16 x %Word32] %52, %Word32 %54, 13
	%56 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 1
	%57 = load %Word32, %Word32* %56
	%58 = insertvalue [16 x %Word32] %55, %Word32 %57, 14
	%59 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 2
	%60 = load %Word32, %Word32* %59
	%61 = insertvalue [16 x %Word32] %58, %Word32 %60, 15
; -- cons_composite_from_composite_by_value --
	%62 = alloca [16 x %Word32]
	%63 = zext i8 16 to %Nat32
	store [16 x %Word32] %61, [16 x %Word32]* %62
	%64 = bitcast [16 x %Word32]* %62 to [16 x %Word32]*
; -- end cons_composite_from_composite_by_value --
	%65 = load [16 x %Word32], [16 x %Word32]* %64
	%66 = zext i8 16 to %Nat32
	store [16 x %Word32] %65, [16 x %Word32]* %0
	ret void
}

@testKey = constant [32 x %Word8] [
	%Word8 0,
	%Word8 1,
	%Word8 2,
	%Word8 3,
	%Word8 4,
	%Word8 5,
	%Word8 6,
	%Word8 7,
	%Word8 8,
	%Word8 9,
	%Word8 10,
	%Word8 11,
	%Word8 12,
	%Word8 13,
	%Word8 14,
	%Word8 15,
	%Word8 16,
	%Word8 17,
	%Word8 18,
	%Word8 19,
	%Word8 20,
	%Word8 21,
	%Word8 22,
	%Word8 23,
	%Word8 24,
	%Word8 25,
	%Word8 26,
	%Word8 27,
	%Word8 28,
	%Word8 29,
	%Word8 30,
	%Word8 31
]
@testNonce = constant [12 x %Word8] [
	%Word8 0,
	%Word8 0,
	%Word8 0,
	%Word8 9,
	%Word8 0,
	%Word8 0,
	%Word8 0,
	%Word8 74,
	%Word8 0,
	%Word8 0,
	%Word8 0,
	%Word8 0
]
@testResult = constant [64 x %Word8] [
	%Word8 16,
	%Word8 241,
	%Word8 231,
	%Word8 228,
	%Word8 209,
	%Word8 59,
	%Word8 89,
	%Word8 21,
	%Word8 80,
	%Word8 15,
	%Word8 221,
	%Word8 31,
	%Word8 163,
	%Word8 32,
	%Word8 113,
	%Word8 196,
	%Word8 199,
	%Word8 209,
	%Word8 244,
	%Word8 199,
	%Word8 51,
	%Word8 192,
	%Word8 104,
	%Word8 3,
	%Word8 4,
	%Word8 34,
	%Word8 170,
	%Word8 154,
	%Word8 195,
	%Word8 212,
	%Word8 108,
	%Word8 78,
	%Word8 210,
	%Word8 130,
	%Word8 100,
	%Word8 70,
	%Word8 7,
	%Word8 159,
	%Word8 170,
	%Word8 9,
	%Word8 20,
	%Word8 194,
	%Word8 215,
	%Word8 5,
	%Word8 217,
	%Word8 139,
	%Word8 2,
	%Word8 162,
	%Word8 181,
	%Word8 18,
	%Word8 156,
	%Word8 209,
	%Word8 222,
	%Word8 22,
	%Word8 78,
	%Word8 185,
	%Word8 203,
	%Word8 208,
	%Word8 131,
	%Word8 232,
	%Word8 162,
	%Word8 80,
	%Word8 60,
	%Word8 78
]
define %Int @main() {
	;printf("%s\n", *Str8 hello_world)
	%1 = alloca [32 x %Byte], align 1
	%2 = insertvalue [32 x %Byte] zeroinitializer, %Byte 1, 1
	%3 = insertvalue [32 x %Byte] %2, %Byte 2, 2
	%4 = insertvalue [32 x %Byte] %3, %Byte 3, 3
	%5 = insertvalue [32 x %Byte] %4, %Byte 4, 4
	%6 = insertvalue [32 x %Byte] %5, %Byte 5, 5
	%7 = insertvalue [32 x %Byte] %6, %Byte 6, 6
	%8 = insertvalue [32 x %Byte] %7, %Byte 7, 7
	%9 = insertvalue [32 x %Byte] %8, %Byte 8, 8
	%10 = insertvalue [32 x %Byte] %9, %Byte 9, 9
	%11 = insertvalue [32 x %Byte] %10, %Byte 10, 10
	%12 = insertvalue [32 x %Byte] %11, %Byte 11, 11
	%13 = insertvalue [32 x %Byte] %12, %Byte 12, 12
	%14 = insertvalue [32 x %Byte] %13, %Byte 13, 13
	%15 = insertvalue [32 x %Byte] %14, %Byte 14, 14
	%16 = insertvalue [32 x %Byte] %15, %Byte 15, 15
	%17 = insertvalue [32 x %Byte] %16, %Byte 16, 16
	%18 = insertvalue [32 x %Byte] %17, %Byte 17, 17
	%19 = insertvalue [32 x %Byte] %18, %Byte 18, 18
	%20 = insertvalue [32 x %Byte] %19, %Byte 19, 19
	%21 = insertvalue [32 x %Byte] %20, %Byte 20, 20
	%22 = insertvalue [32 x %Byte] %21, %Byte 21, 21
	%23 = insertvalue [32 x %Byte] %22, %Byte 22, 22
	%24 = insertvalue [32 x %Byte] %23, %Byte 23, 23
	%25 = insertvalue [32 x %Byte] %24, %Byte 24, 24
	%26 = insertvalue [32 x %Byte] %25, %Byte 25, 25
	%27 = insertvalue [32 x %Byte] %26, %Byte 26, 26
	%28 = insertvalue [32 x %Byte] %27, %Byte 27, 27
	%29 = insertvalue [32 x %Byte] %28, %Byte 28, 28
	%30 = insertvalue [32 x %Byte] %29, %Byte 29, 29
	%31 = insertvalue [32 x %Byte] %30, %Byte 30, 30
	%32 = insertvalue [32 x %Byte] %31, %Byte 31, 31
	%33 = zext i8 32 to %Nat32
	store [32 x %Byte] %32, [32 x %Byte]* %1
	%34 = alloca %Word32, align 4
	%35 = zext i8 1 to %Word32
	store %Word32 %35, %Word32* %34
	%36 = alloca [12 x %Byte], align 1
	%37 = insertvalue [12 x %Byte] zeroinitializer, %Byte 9, 3
	%38 = insertvalue [12 x %Byte] %37, %Byte 74, 7
	%39 = zext i8 12 to %Nat32
	store [12 x %Byte] %38, [12 x %Byte]* %36
	%40 = alloca [16 x %Word32], align 1
	%41 = bitcast [32 x %Byte]* %1 to %Key*
	%42 = load %Word32, %Word32* %34
	%43 = bitcast [12 x %Byte]* %36 to [3 x %Word32]*; alloca memory for return value
	%44 = alloca [16 x %Word32]
	call void @makeState([16 x %Word32]* %44, %Key* %41, %Word32 %42, [3 x %Word32]* %43)
	%45 = load [16 x %Word32], [16 x %Word32]* %44
	%46 = zext i8 16 to %Nat32
	store [16 x %Word32] %45, [16 x %Word32]* %40
	%47 = alloca [16 x %Word32], align 1
	%48 = load [16 x %Word32], [16 x %Word32]* %40; alloca memory for return value
	%49 = alloca [16 x %Word32]
	call void @chacha20Block([16 x %Word32]* %49, [16 x %Word32] %48)
	%50 = load [16 x %Word32], [16 x %Word32]* %49
	%51 = zext i8 16 to %Nat32
	store [16 x %Word32] %50, [16 x %Word32]* %47
	%52 = alloca %Int32, align 4
	store %Int32 0, %Int32* %52
; while_1
	br label %again_1
again_1:
	%53 = load %Int32, %Int32* %52
	%54 = icmp slt %Int32 %53, 16
	br %Bool %54 , label %body_1, label %break_1
body_1:
	%55 = load %Int32, %Int32* %52
	%56 = getelementptr [16 x %Word32], [16 x %Word32]* %47, %Int32 0, %Int32 %55
	%57 = load %Word32, %Word32* %56
	%58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str1 to [0 x i8]*), %Word32 %57)
	%59 = load %Int32, %Int32* %52
	%60 = add %Int32 %59, 1
	store %Int32 %60, %Int32* %52
	br label %again_1
break_1:
	%61 = bitcast [16 x %Word32]* %47 to [64 x %Byte]*
; if_0
	%62 = insertvalue [64 x %Byte] zeroinitializer, %Byte 16, 0
	%63 = insertvalue [64 x %Byte] %62, %Byte 241, 1
	%64 = insertvalue [64 x %Byte] %63, %Byte 231, 2
	%65 = insertvalue [64 x %Byte] %64, %Byte 228, 3
	%66 = insertvalue [64 x %Byte] %65, %Byte 209, 4
	%67 = insertvalue [64 x %Byte] %66, %Byte 59, 5
	%68 = insertvalue [64 x %Byte] %67, %Byte 89, 6
	%69 = insertvalue [64 x %Byte] %68, %Byte 21, 7
	%70 = insertvalue [64 x %Byte] %69, %Byte 80, 8
	%71 = insertvalue [64 x %Byte] %70, %Byte 15, 9
	%72 = insertvalue [64 x %Byte] %71, %Byte 221, 10
	%73 = insertvalue [64 x %Byte] %72, %Byte 31, 11
	%74 = insertvalue [64 x %Byte] %73, %Byte 163, 12
	%75 = insertvalue [64 x %Byte] %74, %Byte 32, 13
	%76 = insertvalue [64 x %Byte] %75, %Byte 113, 14
	%77 = insertvalue [64 x %Byte] %76, %Byte 196, 15
	%78 = insertvalue [64 x %Byte] %77, %Byte 199, 16
	%79 = insertvalue [64 x %Byte] %78, %Byte 209, 17
	%80 = insertvalue [64 x %Byte] %79, %Byte 244, 18
	%81 = insertvalue [64 x %Byte] %80, %Byte 199, 19
	%82 = insertvalue [64 x %Byte] %81, %Byte 51, 20
	%83 = insertvalue [64 x %Byte] %82, %Byte 192, 21
	%84 = insertvalue [64 x %Byte] %83, %Byte 104, 22
	%85 = insertvalue [64 x %Byte] %84, %Byte 3, 23
	%86 = insertvalue [64 x %Byte] %85, %Byte 4, 24
	%87 = insertvalue [64 x %Byte] %86, %Byte 34, 25
	%88 = insertvalue [64 x %Byte] %87, %Byte 170, 26
	%89 = insertvalue [64 x %Byte] %88, %Byte 154, 27
	%90 = insertvalue [64 x %Byte] %89, %Byte 195, 28
	%91 = insertvalue [64 x %Byte] %90, %Byte 212, 29
	%92 = insertvalue [64 x %Byte] %91, %Byte 108, 30
	%93 = insertvalue [64 x %Byte] %92, %Byte 78, 31
	%94 = insertvalue [64 x %Byte] %93, %Byte 210, 32
	%95 = insertvalue [64 x %Byte] %94, %Byte 130, 33
	%96 = insertvalue [64 x %Byte] %95, %Byte 100, 34
	%97 = insertvalue [64 x %Byte] %96, %Byte 70, 35
	%98 = insertvalue [64 x %Byte] %97, %Byte 7, 36
	%99 = insertvalue [64 x %Byte] %98, %Byte 159, 37
	%100 = insertvalue [64 x %Byte] %99, %Byte 170, 38
	%101 = insertvalue [64 x %Byte] %100, %Byte 9, 39
	%102 = insertvalue [64 x %Byte] %101, %Byte 20, 40
	%103 = insertvalue [64 x %Byte] %102, %Byte 194, 41
	%104 = insertvalue [64 x %Byte] %103, %Byte 215, 42
	%105 = insertvalue [64 x %Byte] %104, %Byte 5, 43
	%106 = insertvalue [64 x %Byte] %105, %Byte 217, 44
	%107 = insertvalue [64 x %Byte] %106, %Byte 139, 45
	%108 = insertvalue [64 x %Byte] %107, %Byte 2, 46
	%109 = insertvalue [64 x %Byte] %108, %Byte 162, 47
	%110 = insertvalue [64 x %Byte] %109, %Byte 181, 48
	%111 = insertvalue [64 x %Byte] %110, %Byte 18, 49
	%112 = insertvalue [64 x %Byte] %111, %Byte 156, 50
	%113 = insertvalue [64 x %Byte] %112, %Byte 209, 51
	%114 = insertvalue [64 x %Byte] %113, %Byte 222, 52
	%115 = insertvalue [64 x %Byte] %114, %Byte 22, 53
	%116 = insertvalue [64 x %Byte] %115, %Byte 78, 54
	%117 = insertvalue [64 x %Byte] %116, %Byte 185, 55
	%118 = insertvalue [64 x %Byte] %117, %Byte 203, 56
	%119 = insertvalue [64 x %Byte] %118, %Byte 208, 57
	%120 = insertvalue [64 x %Byte] %119, %Byte 131, 58
	%121 = insertvalue [64 x %Byte] %120, %Byte 232, 59
	%122 = insertvalue [64 x %Byte] %121, %Byte 162, 60
	%123 = insertvalue [64 x %Byte] %122, %Byte 80, 61
	%124 = insertvalue [64 x %Byte] %123, %Byte 60, 62
	%125 = insertvalue [64 x %Byte] %124, %Byte 78, 63
	%126 = alloca [64 x %Byte]
	%127 = zext i8 64 to %Nat32
	store [64 x %Byte] %125, [64 x %Byte]* %126
	%128 = bitcast [64 x %Byte]* %61 to i8*
	%129 = bitcast [64 x %Byte]* %126 to i8*
	%130 = call i1 (i8*, i8*, i64) @memeq(i8* %128, i8* %129, %Int64 64)
	%131 = icmp ne %Bool %130, 0
	br %Bool %131 , label %then_0, label %else_0
then_0:
	%132 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*))
	br label %endif_0
else_0:
	%133 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*))
	br label %endif_0
endif_0:
	ret %Int 0
}


