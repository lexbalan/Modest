
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
@str1 = private constant [3 x i8] [i8 37, i8 99, i8 0]
@str2 = private constant [4 x i8] [i8 37, i8 120, i8 10, i8 0]
@str3 = private constant [3 x i8] [i8 37, i8 99, i8 0]
@str4 = private constant [6 x i8] [i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str6 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
%Key = type [8 x %Word32];
%State = type [16 x %Word32];
%Block = type [16 x %Word32];
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

define internal void @chacha20Block(%Block* %0, %State %__state) {
	%state = alloca %State
	%2 = zext i8 16 to %Nat32
	store %State %__state, %State* %state
	%3 = alloca %State, align 1
	%4 = load %State, %State* %state
	%5 = zext i8 16 to %Nat32
	store %State %4, %State* %3	; working copy
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
	%10 = getelementptr %State, %State* %3, %Int32 0, %Int32 0
	%11 = load %Word32, %Word32* %10
	%12 = getelementptr %State, %State* %3, %Int32 0, %Int32 4
	%13 = load %Word32, %Word32* %12
	%14 = getelementptr %State, %State* %3, %Int32 0, %Int32 8
	%15 = load %Word32, %Word32* %14
	%16 = getelementptr %State, %State* %3, %Int32 0, %Int32 12
	%17 = load %Word32, %Word32* %16; alloca memory for return value
	%18 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %18, %Word32 %11, %Word32 %13, %Word32 %15, %Word32 %17)
	%19 = load [4 x %Word32], [4 x %Word32]* %18
	%20 = zext i8 4 to %Nat32
	store [4 x %Word32] %19, [4 x %Word32]* %9
	%21 = getelementptr %State, %State* %3, %Int32 0, %Int32 0
	%22 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%23 = load %Word32, %Word32* %22
	store %Word32 %23, %Word32* %21
	%24 = getelementptr %State, %State* %3, %Int32 0, %Int32 4
	%25 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%26 = load %Word32, %Word32* %25
	store %Word32 %26, %Word32* %24
	%27 = getelementptr %State, %State* %3, %Int32 0, %Int32 8
	%28 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%29 = load %Word32, %Word32* %28
	store %Word32 %29, %Word32* %27
	%30 = getelementptr %State, %State* %3, %Int32 0, %Int32 12
	%31 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%32 = load %Word32, %Word32* %31
	store %Word32 %32, %Word32* %30
	%33 = getelementptr %State, %State* %3, %Int32 0, %Int32 1
	%34 = load %Word32, %Word32* %33
	%35 = getelementptr %State, %State* %3, %Int32 0, %Int32 5
	%36 = load %Word32, %Word32* %35
	%37 = getelementptr %State, %State* %3, %Int32 0, %Int32 9
	%38 = load %Word32, %Word32* %37
	%39 = getelementptr %State, %State* %3, %Int32 0, %Int32 13
	%40 = load %Word32, %Word32* %39; alloca memory for return value
	%41 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %41, %Word32 %34, %Word32 %36, %Word32 %38, %Word32 %40)
	%42 = load [4 x %Word32], [4 x %Word32]* %41
	%43 = zext i8 4 to %Nat32
	store [4 x %Word32] %42, [4 x %Word32]* %9
	%44 = getelementptr %State, %State* %3, %Int32 0, %Int32 1
	%45 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%46 = load %Word32, %Word32* %45
	store %Word32 %46, %Word32* %44
	%47 = getelementptr %State, %State* %3, %Int32 0, %Int32 5
	%48 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%49 = load %Word32, %Word32* %48
	store %Word32 %49, %Word32* %47
	%50 = getelementptr %State, %State* %3, %Int32 0, %Int32 9
	%51 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%52 = load %Word32, %Word32* %51
	store %Word32 %52, %Word32* %50
	%53 = getelementptr %State, %State* %3, %Int32 0, %Int32 13
	%54 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%55 = load %Word32, %Word32* %54
	store %Word32 %55, %Word32* %53
	%56 = getelementptr %State, %State* %3, %Int32 0, %Int32 2
	%57 = load %Word32, %Word32* %56
	%58 = getelementptr %State, %State* %3, %Int32 0, %Int32 6
	%59 = load %Word32, %Word32* %58
	%60 = getelementptr %State, %State* %3, %Int32 0, %Int32 10
	%61 = load %Word32, %Word32* %60
	%62 = getelementptr %State, %State* %3, %Int32 0, %Int32 14
	%63 = load %Word32, %Word32* %62; alloca memory for return value
	%64 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %64, %Word32 %57, %Word32 %59, %Word32 %61, %Word32 %63)
	%65 = load [4 x %Word32], [4 x %Word32]* %64
	%66 = zext i8 4 to %Nat32
	store [4 x %Word32] %65, [4 x %Word32]* %9
	%67 = getelementptr %State, %State* %3, %Int32 0, %Int32 2
	%68 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%69 = load %Word32, %Word32* %68
	store %Word32 %69, %Word32* %67
	%70 = getelementptr %State, %State* %3, %Int32 0, %Int32 6
	%71 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%72 = load %Word32, %Word32* %71
	store %Word32 %72, %Word32* %70
	%73 = getelementptr %State, %State* %3, %Int32 0, %Int32 10
	%74 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%75 = load %Word32, %Word32* %74
	store %Word32 %75, %Word32* %73
	%76 = getelementptr %State, %State* %3, %Int32 0, %Int32 14
	%77 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%78 = load %Word32, %Word32* %77
	store %Word32 %78, %Word32* %76
	%79 = getelementptr %State, %State* %3, %Int32 0, %Int32 3
	%80 = load %Word32, %Word32* %79
	%81 = getelementptr %State, %State* %3, %Int32 0, %Int32 7
	%82 = load %Word32, %Word32* %81
	%83 = getelementptr %State, %State* %3, %Int32 0, %Int32 11
	%84 = load %Word32, %Word32* %83
	%85 = getelementptr %State, %State* %3, %Int32 0, %Int32 15
	%86 = load %Word32, %Word32* %85; alloca memory for return value
	%87 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %87, %Word32 %80, %Word32 %82, %Word32 %84, %Word32 %86)
	%88 = load [4 x %Word32], [4 x %Word32]* %87
	%89 = zext i8 4 to %Nat32
	store [4 x %Word32] %88, [4 x %Word32]* %9
	%90 = getelementptr %State, %State* %3, %Int32 0, %Int32 3
	%91 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%92 = load %Word32, %Word32* %91
	store %Word32 %92, %Word32* %90
	%93 = getelementptr %State, %State* %3, %Int32 0, %Int32 7
	%94 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%95 = load %Word32, %Word32* %94
	store %Word32 %95, %Word32* %93
	%96 = getelementptr %State, %State* %3, %Int32 0, %Int32 11
	%97 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%98 = load %Word32, %Word32* %97
	store %Word32 %98, %Word32* %96
	%99 = getelementptr %State, %State* %3, %Int32 0, %Int32 15
	%100 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%101 = load %Word32, %Word32* %100
	store %Word32 %101, %Word32* %99


	; diagonal rounds
	%102 = getelementptr %State, %State* %3, %Int32 0, %Int32 0
	%103 = load %Word32, %Word32* %102
	%104 = getelementptr %State, %State* %3, %Int32 0, %Int32 5
	%105 = load %Word32, %Word32* %104
	%106 = getelementptr %State, %State* %3, %Int32 0, %Int32 10
	%107 = load %Word32, %Word32* %106
	%108 = getelementptr %State, %State* %3, %Int32 0, %Int32 15
	%109 = load %Word32, %Word32* %108; alloca memory for return value
	%110 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %110, %Word32 %103, %Word32 %105, %Word32 %107, %Word32 %109)
	%111 = load [4 x %Word32], [4 x %Word32]* %110
	%112 = zext i8 4 to %Nat32
	store [4 x %Word32] %111, [4 x %Word32]* %9
	%113 = getelementptr %State, %State* %3, %Int32 0, %Int32 0
	%114 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%115 = load %Word32, %Word32* %114
	store %Word32 %115, %Word32* %113
	%116 = getelementptr %State, %State* %3, %Int32 0, %Int32 5
	%117 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%118 = load %Word32, %Word32* %117
	store %Word32 %118, %Word32* %116
	%119 = getelementptr %State, %State* %3, %Int32 0, %Int32 10
	%120 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%121 = load %Word32, %Word32* %120
	store %Word32 %121, %Word32* %119
	%122 = getelementptr %State, %State* %3, %Int32 0, %Int32 15
	%123 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%124 = load %Word32, %Word32* %123
	store %Word32 %124, %Word32* %122
	%125 = getelementptr %State, %State* %3, %Int32 0, %Int32 1
	%126 = load %Word32, %Word32* %125
	%127 = getelementptr %State, %State* %3, %Int32 0, %Int32 6
	%128 = load %Word32, %Word32* %127
	%129 = getelementptr %State, %State* %3, %Int32 0, %Int32 11
	%130 = load %Word32, %Word32* %129
	%131 = getelementptr %State, %State* %3, %Int32 0, %Int32 12
	%132 = load %Word32, %Word32* %131; alloca memory for return value
	%133 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %133, %Word32 %126, %Word32 %128, %Word32 %130, %Word32 %132)
	%134 = load [4 x %Word32], [4 x %Word32]* %133
	%135 = zext i8 4 to %Nat32
	store [4 x %Word32] %134, [4 x %Word32]* %9
	%136 = getelementptr %State, %State* %3, %Int32 0, %Int32 1
	%137 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%138 = load %Word32, %Word32* %137
	store %Word32 %138, %Word32* %136
	%139 = getelementptr %State, %State* %3, %Int32 0, %Int32 6
	%140 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%141 = load %Word32, %Word32* %140
	store %Word32 %141, %Word32* %139
	%142 = getelementptr %State, %State* %3, %Int32 0, %Int32 11
	%143 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%144 = load %Word32, %Word32* %143
	store %Word32 %144, %Word32* %142
	%145 = getelementptr %State, %State* %3, %Int32 0, %Int32 12
	%146 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%147 = load %Word32, %Word32* %146
	store %Word32 %147, %Word32* %145
	%148 = getelementptr %State, %State* %3, %Int32 0, %Int32 2
	%149 = load %Word32, %Word32* %148
	%150 = getelementptr %State, %State* %3, %Int32 0, %Int32 7
	%151 = load %Word32, %Word32* %150
	%152 = getelementptr %State, %State* %3, %Int32 0, %Int32 8
	%153 = load %Word32, %Word32* %152
	%154 = getelementptr %State, %State* %3, %Int32 0, %Int32 13
	%155 = load %Word32, %Word32* %154; alloca memory for return value
	%156 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %156, %Word32 %149, %Word32 %151, %Word32 %153, %Word32 %155)
	%157 = load [4 x %Word32], [4 x %Word32]* %156
	%158 = zext i8 4 to %Nat32
	store [4 x %Word32] %157, [4 x %Word32]* %9
	%159 = getelementptr %State, %State* %3, %Int32 0, %Int32 2
	%160 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%161 = load %Word32, %Word32* %160
	store %Word32 %161, %Word32* %159
	%162 = getelementptr %State, %State* %3, %Int32 0, %Int32 7
	%163 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%164 = load %Word32, %Word32* %163
	store %Word32 %164, %Word32* %162
	%165 = getelementptr %State, %State* %3, %Int32 0, %Int32 8
	%166 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%167 = load %Word32, %Word32* %166
	store %Word32 %167, %Word32* %165
	%168 = getelementptr %State, %State* %3, %Int32 0, %Int32 13
	%169 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%170 = load %Word32, %Word32* %169
	store %Word32 %170, %Word32* %168
	%171 = getelementptr %State, %State* %3, %Int32 0, %Int32 3
	%172 = load %Word32, %Word32* %171
	%173 = getelementptr %State, %State* %3, %Int32 0, %Int32 4
	%174 = load %Word32, %Word32* %173
	%175 = getelementptr %State, %State* %3, %Int32 0, %Int32 9
	%176 = load %Word32, %Word32* %175
	%177 = getelementptr %State, %State* %3, %Int32 0, %Int32 14
	%178 = load %Word32, %Word32* %177; alloca memory for return value
	%179 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %179, %Word32 %172, %Word32 %174, %Word32 %176, %Word32 %178)
	%180 = load [4 x %Word32], [4 x %Word32]* %179
	%181 = zext i8 4 to %Nat32
	store [4 x %Word32] %180, [4 x %Word32]* %9
	%182 = getelementptr %State, %State* %3, %Int32 0, %Int32 3
	%183 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%184 = load %Word32, %Word32* %183
	store %Word32 %184, %Word32* %182
	%185 = getelementptr %State, %State* %3, %Int32 0, %Int32 4
	%186 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%187 = load %Word32, %Word32* %186
	store %Word32 %187, %Word32* %185
	%188 = getelementptr %State, %State* %3, %Int32 0, %Int32 9
	%189 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%190 = load %Word32, %Word32* %189
	store %Word32 %190, %Word32* %188
	%191 = getelementptr %State, %State* %3, %Int32 0, %Int32 14
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
	%203 = getelementptr %State, %State* %3, %Int32 0, %Int32 %202
	%204 = load %Word32, %Word32* %203
	%205 = bitcast %Word32 %204 to %Nat32
	%206 = load %Int32, %Int32* %197
	%207 = getelementptr %State, %State* %state, %Int32 0, %Int32 %206
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
	store [16 x %Word32] %214, %Block* %0
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
define internal void @makeState(%State* %0, %Key* %key, %Word32 %counter, [3 x %Word32]* %nonce) {
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
	%64 = bitcast [16 x %Word32]* %62 to %State*
; -- end cons_composite_from_composite_by_value --
	%65 = load %State, %State* %64
	%66 = zext i8 16 to %Nat32
	store %State %65, %State* %0
	ret void
}

%Context = type {
	[32 x %Byte]*,
	[3 x %Word32],
	%Nat32,
	%Block,
	%Nat32
};

define internal %Context @init([32 x %Byte]* %key, [3 x %Word32] %__nonce) {
	%nonce = alloca [3 x %Word32]
	%1 = zext i8 3 to %Nat32
	store [3 x %Word32] %__nonce, [3 x %Word32]* %nonce
	%2 = insertvalue %Context zeroinitializer, [32 x %Byte]* %key, 0
	%3 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 0
	%4 = load %Word32, %Word32* %3
	%5 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 1
	%6 = load %Word32, %Word32* %5
	%7 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 2
	%8 = load %Word32, %Word32* %7
	%9 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 0
	%10 = load %Word32, %Word32* %9
	%11 = insertvalue [3 x %Word32] zeroinitializer, %Word32 %10, 0
	%12 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 1
	%13 = load %Word32, %Word32* %12
	%14 = insertvalue [3 x %Word32] %11, %Word32 %13, 1
	%15 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 2
	%16 = load %Word32, %Word32* %15
	%17 = insertvalue [3 x %Word32] %14, %Word32 %16, 2
; -- cons_composite_from_composite_by_value --
	%18 = alloca [3 x %Word32]
	%19 = zext i8 3 to %Nat32
	store [3 x %Word32] %17, [3 x %Word32]* %18
	%20 = bitcast [3 x %Word32]* %18 to [3 x %Word32]*
; -- end cons_composite_from_composite_by_value --
	%21 = load [3 x %Word32], [3 x %Word32]* %20
	%22 = insertvalue %Context %2, [3 x %Word32] %21, 1
	%23 = insertvalue %Context %22, %Nat32 64, 4
	ret %Context %23
}

define internal void @cipher(%Context* %ctx, [0 x %Byte]* %data, %Nat32 %len) {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
	%2 = alloca [0 x %Byte]*, align 8
	store [0 x %Byte]* null, [0 x %Byte]** %2
; while_1
	br label %again_1
again_1:
	%3 = load %Nat32, %Nat32* %1
	%4 = icmp ult %Nat32 %3, %len
	br %Bool %4 , label %body_1, label %break_1
body_1:
	; Нужно сгенерировать новый блок?
; if_0
	%5 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 4
	%6 = load %Nat32, %Nat32* %5
	%7 = icmp eq %Nat32 %6, 64
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	;printf("UH!\n")
	%8 = alloca %State, align 1
	%9 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%10 = load [32 x %Byte]*, [32 x %Byte]** %9
	%11 = bitcast [32 x %Byte]* %10 to %Key*
	%12 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%13 = load %Nat32, %Nat32* %12
	%14 = bitcast %Nat32 %13 to %Word32
	%15 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1; alloca memory for return value
	%16 = alloca %State
	call void @makeState(%State* %16, %Key* %11, %Word32 %14, [3 x %Word32]* %15)
	%17 = load %State, %State* %16
	%18 = zext i8 16 to %Nat32
	store %State %17, %State* %8
	%19 = zext i8 13 to %Nat32
	%20 = getelementptr %State, %State* %8, %Int32 0, %Nat32 %19
	%21 = bitcast %Word32* %20 to [3 x %Word32]*
	%22 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%23 = zext i8 0 to %Nat32
	%24 = getelementptr [3 x %Word32], [3 x %Word32]* %22, %Int32 0, %Nat32 %23
	%25 = bitcast %Word32* %24 to [3 x %Word32]*
	%26 = load [3 x %Word32], [3 x %Word32]* %25
	%27 = zext i8 3 to %Nat32
	store [3 x %Word32] %26, [3 x %Word32]* %21
	;state[13] = ctx.nonce[0]
	;state[14] = ctx.nonce[1]
	;state[15] = ctx.nonce[2]
	%28 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%29 = load %State, %State* %8; alloca memory for return value
	%30 = alloca %Block
	call void @chacha20Block(%Block* %30, %State %29)
	%31 = load %Block, %Block* %30
	%32 = zext i8 16 to %Nat32
	store %Block %31, %Block* %28
	%33 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 4
	store %Nat32 0, %Nat32* %33
	%34 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%35 = bitcast %Block* %34 to [0 x %Byte]*
	store [0 x %Byte]* %35, [0 x %Byte]** %2
	br label %endif_0
endif_0:
	%36 = load %Nat32, %Nat32* %1
	%37 = bitcast %Nat32 %36 to %Nat32
	%38 = getelementptr [0 x %Byte], [0 x %Byte]* %data, %Int32 0, %Nat32 %37
	%39 = load %Nat32, %Nat32* %1
	%40 = bitcast %Nat32 %39 to %Nat32
	%41 = getelementptr [0 x %Byte], [0 x %Byte]* %data, %Int32 0, %Nat32 %40
	%42 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 4
	%43 = load %Nat32, %Nat32* %42
	%44 = load [0 x %Byte]*, [0 x %Byte]** %2
	%45 = bitcast %Nat32 %43 to %Nat32
	%46 = getelementptr [0 x %Byte], [0 x %Byte]* %44, %Int32 0, %Nat32 %45
	%47 = load %Byte, %Byte* %41
	%48 = load %Byte, %Byte* %46
	%49 = xor %Byte %47, %48
	store %Byte %49, %Byte* %38
	%50 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 4
	%51 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 4
	%52 = load %Nat32, %Nat32* %51
	%53 = add %Nat32 %52, 1
	store %Nat32 %53, %Nat32* %50
	%54 = load %Nat32, %Nat32* %1
	%55 = add %Nat32 %54, 1
	store %Nat32 %55, %Nat32* %1
	br label %again_1
break_1:
	ret void
}

@testKey = internal global [32 x %Byte] [
	%Byte 0,
	%Byte 1,
	%Byte 2,
	%Byte 3,
	%Byte 4,
	%Byte 5,
	%Byte 6,
	%Byte 7,
	%Byte 8,
	%Byte 9,
	%Byte 10,
	%Byte 11,
	%Byte 12,
	%Byte 13,
	%Byte 14,
	%Byte 15,
	%Byte 16,
	%Byte 17,
	%Byte 18,
	%Byte 19,
	%Byte 20,
	%Byte 21,
	%Byte 22,
	%Byte 23,
	%Byte 24,
	%Byte 25,
	%Byte 26,
	%Byte 27,
	%Byte 28,
	%Byte 29,
	%Byte 30,
	%Byte 31
]
@testNonce = internal global [12 x %Byte] [
	%Byte 0,
	%Byte 0,
	%Byte 0,
	%Byte 9,
	%Byte 0,
	%Byte 0,
	%Byte 0,
	%Byte 74,
	%Byte 0,
	%Byte 0,
	%Byte 0,
	%Byte 0
]
@testNonce2 = internal global [3 x %Word32] [
	%Word32 9,
	%Word32 74,
	%Word32 0
]
@testResult = constant [64 x %Byte] [
	%Byte 16,
	%Byte 241,
	%Byte 231,
	%Byte 228,
	%Byte 209,
	%Byte 59,
	%Byte 89,
	%Byte 21,
	%Byte 80,
	%Byte 15,
	%Byte 221,
	%Byte 31,
	%Byte 163,
	%Byte 32,
	%Byte 113,
	%Byte 196,
	%Byte 199,
	%Byte 209,
	%Byte 244,
	%Byte 199,
	%Byte 51,
	%Byte 192,
	%Byte 104,
	%Byte 3,
	%Byte 4,
	%Byte 34,
	%Byte 170,
	%Byte 154,
	%Byte 195,
	%Byte 212,
	%Byte 108,
	%Byte 78,
	%Byte 210,
	%Byte 130,
	%Byte 100,
	%Byte 70,
	%Byte 7,
	%Byte 159,
	%Byte 170,
	%Byte 9,
	%Byte 20,
	%Byte 194,
	%Byte 215,
	%Byte 5,
	%Byte 217,
	%Byte 139,
	%Byte 2,
	%Byte 162,
	%Byte 181,
	%Byte 18,
	%Byte 156,
	%Byte 209,
	%Byte 222,
	%Byte 22,
	%Byte 78,
	%Byte 185,
	%Byte 203,
	%Byte 208,
	%Byte 131,
	%Byte 232,
	%Byte 162,
	%Byte 80,
	%Byte 60,
	%Byte 78
]
@lorem1024 = constant [1024 x %Char8] [
	%Char8 76,
	%Char8 111,
	%Char8 114,
	%Char8 101,
	%Char8 109,
	%Char8 32,
	%Char8 105,
	%Char8 112,
	%Char8 115,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 100,
	%Char8 111,
	%Char8 108,
	%Char8 111,
	%Char8 114,
	%Char8 32,
	%Char8 115,
	%Char8 105,
	%Char8 116,
	%Char8 32,
	%Char8 97,
	%Char8 109,
	%Char8 101,
	%Char8 116,
	%Char8 44,
	%Char8 32,
	%Char8 99,
	%Char8 111,
	%Char8 110,
	%Char8 115,
	%Char8 101,
	%Char8 99,
	%Char8 116,
	%Char8 101,
	%Char8 116,
	%Char8 117,
	%Char8 101,
	%Char8 114,
	%Char8 32,
	%Char8 97,
	%Char8 100,
	%Char8 105,
	%Char8 112,
	%Char8 105,
	%Char8 115,
	%Char8 99,
	%Char8 105,
	%Char8 110,
	%Char8 103,
	%Char8 32,
	%Char8 101,
	%Char8 108,
	%Char8 105,
	%Char8 116,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 97,
	%Char8 110,
	%Char8 32,
	%Char8 99,
	%Char8 111,
	%Char8 109,
	%Char8 109,
	%Char8 111,
	%Char8 100,
	%Char8 111,
	%Char8 32,
	%Char8 108,
	%Char8 105,
	%Char8 103,
	%Char8 117,
	%Char8 108,
	%Char8 97,
	%Char8 32,
	%Char8 101,
	%Char8 103,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 100,
	%Char8 111,
	%Char8 108,
	%Char8 111,
	%Char8 114,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 97,
	%Char8 110,
	%Char8 32,
	%Char8 109,
	%Char8 97,
	%Char8 115,
	%Char8 115,
	%Char8 97,
	%Char8 46,
	%Char8 32,
	%Char8 67,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 115,
	%Char8 111,
	%Char8 99,
	%Char8 105,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 110,
	%Char8 97,
	%Char8 116,
	%Char8 111,
	%Char8 113,
	%Char8 117,
	%Char8 101,
	%Char8 32,
	%Char8 112,
	%Char8 101,
	%Char8 110,
	%Char8 97,
	%Char8 116,
	%Char8 105,
	%Char8 98,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 109,
	%Char8 97,
	%Char8 103,
	%Char8 110,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 100,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 112,
	%Char8 97,
	%Char8 114,
	%Char8 116,
	%Char8 117,
	%Char8 114,
	%Char8 105,
	%Char8 101,
	%Char8 110,
	%Char8 116,
	%Char8 32,
	%Char8 109,
	%Char8 111,
	%Char8 110,
	%Char8 116,
	%Char8 101,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 110,
	%Char8 97,
	%Char8 115,
	%Char8 99,
	%Char8 101,
	%Char8 116,
	%Char8 117,
	%Char8 114,
	%Char8 32,
	%Char8 114,
	%Char8 105,
	%Char8 100,
	%Char8 105,
	%Char8 99,
	%Char8 117,
	%Char8 108,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 109,
	%Char8 117,
	%Char8 115,
	%Char8 46,
	%Char8 32,
	%Char8 68,
	%Char8 111,
	%Char8 110,
	%Char8 101,
	%Char8 99,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 102,
	%Char8 101,
	%Char8 108,
	%Char8 105,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 117,
	%Char8 108,
	%Char8 116,
	%Char8 114,
	%Char8 105,
	%Char8 99,
	%Char8 105,
	%Char8 101,
	%Char8 115,
	%Char8 32,
	%Char8 110,
	%Char8 101,
	%Char8 99,
	%Char8 44,
	%Char8 32,
	%Char8 112,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 101,
	%Char8 110,
	%Char8 116,
	%Char8 101,
	%Char8 115,
	%Char8 113,
	%Char8 117,
	%Char8 101,
	%Char8 32,
	%Char8 101,
	%Char8 117,
	%Char8 44,
	%Char8 32,
	%Char8 112,
	%Char8 114,
	%Char8 101,
	%Char8 116,
	%Char8 105,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 105,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 78,
	%Char8 117,
	%Char8 108,
	%Char8 108,
	%Char8 97,
	%Char8 32,
	%Char8 99,
	%Char8 111,
	%Char8 110,
	%Char8 115,
	%Char8 101,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 116,
	%Char8 32,
	%Char8 109,
	%Char8 97,
	%Char8 115,
	%Char8 115,
	%Char8 97,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 101,
	%Char8 110,
	%Char8 105,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 68,
	%Char8 111,
	%Char8 110,
	%Char8 101,
	%Char8 99,
	%Char8 32,
	%Char8 112,
	%Char8 101,
	%Char8 100,
	%Char8 101,
	%Char8 32,
	%Char8 106,
	%Char8 117,
	%Char8 115,
	%Char8 116,
	%Char8 111,
	%Char8 44,
	%Char8 32,
	%Char8 102,
	%Char8 114,
	%Char8 105,
	%Char8 110,
	%Char8 103,
	%Char8 105,
	%Char8 108,
	%Char8 108,
	%Char8 97,
	%Char8 32,
	%Char8 118,
	%Char8 101,
	%Char8 108,
	%Char8 44,
	%Char8 32,
	%Char8 97,
	%Char8 108,
	%Char8 105,
	%Char8 113,
	%Char8 117,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 110,
	%Char8 101,
	%Char8 99,
	%Char8 44,
	%Char8 32,
	%Char8 118,
	%Char8 117,
	%Char8 108,
	%Char8 112,
	%Char8 117,
	%Char8 116,
	%Char8 97,
	%Char8 116,
	%Char8 101,
	%Char8 32,
	%Char8 101,
	%Char8 103,
	%Char8 101,
	%Char8 116,
	%Char8 44,
	%Char8 32,
	%Char8 97,
	%Char8 114,
	%Char8 99,
	%Char8 117,
	%Char8 46,
	%Char8 32,
	%Char8 73,
	%Char8 110,
	%Char8 32,
	%Char8 101,
	%Char8 110,
	%Char8 105,
	%Char8 109,
	%Char8 32,
	%Char8 106,
	%Char8 117,
	%Char8 115,
	%Char8 116,
	%Char8 111,
	%Char8 44,
	%Char8 32,
	%Char8 114,
	%Char8 104,
	%Char8 111,
	%Char8 110,
	%Char8 99,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 117,
	%Char8 116,
	%Char8 44,
	%Char8 32,
	%Char8 105,
	%Char8 109,
	%Char8 112,
	%Char8 101,
	%Char8 114,
	%Char8 100,
	%Char8 105,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 97,
	%Char8 44,
	%Char8 32,
	%Char8 118,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 110,
	%Char8 97,
	%Char8 116,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 118,
	%Char8 105,
	%Char8 116,
	%Char8 97,
	%Char8 101,
	%Char8 44,
	%Char8 32,
	%Char8 106,
	%Char8 117,
	%Char8 115,
	%Char8 116,
	%Char8 111,
	%Char8 46,
	%Char8 32,
	%Char8 78,
	%Char8 117,
	%Char8 108,
	%Char8 108,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 100,
	%Char8 105,
	%Char8 99,
	%Char8 116,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 102,
	%Char8 101,
	%Char8 108,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 101,
	%Char8 117,
	%Char8 32,
	%Char8 112,
	%Char8 101,
	%Char8 100,
	%Char8 101,
	%Char8 32,
	%Char8 109,
	%Char8 111,
	%Char8 108,
	%Char8 108,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 112,
	%Char8 114,
	%Char8 101,
	%Char8 116,
	%Char8 105,
	%Char8 117,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 73,
	%Char8 110,
	%Char8 116,
	%Char8 101,
	%Char8 103,
	%Char8 101,
	%Char8 114,
	%Char8 32,
	%Char8 116,
	%Char8 105,
	%Char8 110,
	%Char8 99,
	%Char8 105,
	%Char8 100,
	%Char8 117,
	%Char8 110,
	%Char8 116,
	%Char8 46,
	%Char8 32,
	%Char8 67,
	%Char8 114,
	%Char8 97,
	%Char8 115,
	%Char8 32,
	%Char8 100,
	%Char8 97,
	%Char8 112,
	%Char8 105,
	%Char8 98,
	%Char8 117,
	%Char8 115,
	%Char8 46,
	%Char8 32,
	%Char8 86,
	%Char8 105,
	%Char8 118,
	%Char8 97,
	%Char8 109,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 101,
	%Char8 108,
	%Char8 101,
	%Char8 109,
	%Char8 101,
	%Char8 110,
	%Char8 116,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 109,
	%Char8 112,
	%Char8 101,
	%Char8 114,
	%Char8 32,
	%Char8 110,
	%Char8 105,
	%Char8 115,
	%Char8 105,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 97,
	%Char8 110,
	%Char8 32,
	%Char8 118,
	%Char8 117,
	%Char8 108,
	%Char8 112,
	%Char8 117,
	%Char8 116,
	%Char8 97,
	%Char8 116,
	%Char8 101,
	%Char8 32,
	%Char8 101,
	%Char8 108,
	%Char8 101,
	%Char8 105,
	%Char8 102,
	%Char8 101,
	%Char8 110,
	%Char8 100,
	%Char8 32,
	%Char8 116,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 117,
	%Char8 115,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 97,
	%Char8 110,
	%Char8 32,
	%Char8 108,
	%Char8 101,
	%Char8 111,
	%Char8 32,
	%Char8 108,
	%Char8 105,
	%Char8 103,
	%Char8 117,
	%Char8 108,
	%Char8 97,
	%Char8 44,
	%Char8 32,
	%Char8 112,
	%Char8 111,
	%Char8 114,
	%Char8 116,
	%Char8 116,
	%Char8 105,
	%Char8 116,
	%Char8 111,
	%Char8 114,
	%Char8 32,
	%Char8 101,
	%Char8 117,
	%Char8 44,
	%Char8 32,
	%Char8 99,
	%Char8 111,
	%Char8 110,
	%Char8 115,
	%Char8 101,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 116,
	%Char8 32,
	%Char8 118,
	%Char8 105,
	%Char8 116,
	%Char8 97,
	%Char8 101,
	%Char8 44,
	%Char8 32,
	%Char8 101,
	%Char8 108,
	%Char8 101,
	%Char8 105,
	%Char8 102,
	%Char8 101,
	%Char8 110,
	%Char8 100,
	%Char8 32,
	%Char8 97,
	%Char8 99,
	%Char8 44,
	%Char8 32,
	%Char8 101,
	%Char8 110,
	%Char8 105,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 108,
	%Char8 105,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 108,
	%Char8 111,
	%Char8 114,
	%Char8 101,
	%Char8 109,
	%Char8 32,
	%Char8 97,
	%Char8 110,
	%Char8 116,
	%Char8 101,
	%Char8 44,
	%Char8 32,
	%Char8 100,
	%Char8 97,
	%Char8 112,
	%Char8 105,
	%Char8 98,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 105,
	%Char8 110,
	%Char8 44,
	%Char8 32,
	%Char8 118,
	%Char8 105,
	%Char8 118,
	%Char8 101,
	%Char8 114,
	%Char8 114,
	%Char8 97,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 105,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 102,
	%Char8 101,
	%Char8 117,
	%Char8 103,
	%Char8 105,
	%Char8 97,
	%Char8 116,
	%Char8 32,
	%Char8 97,
	%Char8 44,
	%Char8 32,
	%Char8 116,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 117,
	%Char8 115,
	%Char8 46,
	%Char8 32,
	%Char8 80,
	%Char8 104,
	%Char8 97,
	%Char8 115,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 118,
	%Char8 105,
	%Char8 118,
	%Char8 101,
	%Char8 114,
	%Char8 114,
	%Char8 97,
	%Char8 32,
	%Char8 110,
	%Char8 117,
	%Char8 108,
	%Char8 108,
	%Char8 97,
	%Char8 32,
	%Char8 117,
	%Char8 116,
	%Char8 32,
	%Char8 109,
	%Char8 101,
	%Char8 116,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 118,
	%Char8 97,
	%Char8 114,
	%Char8 105,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 108,
	%Char8 97,
	%Char8 111,
	%Char8 114,
	%Char8 101,
	%Char8 101,
	%Char8 116,
	%Char8 46,
	%Char8 32,
	%Char8 81,
	%Char8 117,
	%Char8 105,
	%Char8 115,
	%Char8 113,
	%Char8 117,
	%Char8 101,
	%Char8 32,
	%Char8 114,
	%Char8 117,
	%Char8 116,
	%Char8 114,
	%Char8 117,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 97,
	%Char8 110,
	%Char8 32,
	%Char8 105,
	%Char8 109,
	%Char8 112,
	%Char8 101,
	%Char8 114,
	%Char8 100,
	%Char8 105,
	%Char8 101,
	%Char8 116,
	%Char8 46,
	%Char8 32,
	%Char8 69,
	%Char8 116,
	%Char8 105,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 117,
	%Char8 108,
	%Char8 116,
	%Char8 114,
	%Char8 105,
	%Char8 99,
	%Char8 105,
	%Char8 101,
	%Char8 115,
	%Char8 32,
	%Char8 110,
	%Char8 105,
	%Char8 115,
	%Char8 105,
	%Char8 32,
	%Char8 118,
	%Char8 101,
	%Char8 108,
	%Char8 32,
	%Char8 97,
	%Char8 117,
	%Char8 103,
	%Char8 117,
	%Char8 101,
	%Char8 46,
	%Char8 32,
	%Char8 67,
	%Char8 117,
	%Char8 114,
	%Char8 97,
	%Char8 98,
	%Char8 105,
	%Char8 116,
	%Char8 117,
	%Char8 114,
	%Char8 32,
	%Char8 117,
	%Char8 108,
	%Char8 108,
	%Char8 97,
	%Char8 109,
	%Char8 99,
	%Char8 111,
	%Char8 114,
	%Char8 112,
	%Char8 101,
	%Char8 114,
	%Char8 32,
	%Char8 117,
	%Char8 108,
	%Char8 116,
	%Char8 114,
	%Char8 105,
	%Char8 99,
	%Char8 105,
	%Char8 101,
	%Char8 115,
	%Char8 32,
	%Char8 110,
	%Char8 105,
	%Char8 115,
	%Char8 105,
	%Char8 46,
	%Char8 32,
	%Char8 78,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 101,
	%Char8 103,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 100,
	%Char8 117,
	%Char8 105,
	%Char8 46,
	%Char8 32,
	%Char8 69,
	%Char8 116,
	%Char8 105,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 114,
	%Char8 104,
	%Char8 111,
	%Char8 110,
	%Char8 99,
	%Char8 117,
	%Char8 115,
	%Char8 46,
	%Char8 32,
	%Char8 77,
	%Char8 97,
	%Char8 101,
	%Char8 99,
	%Char8 101,
	%Char8 110,
	%Char8 97,
	%Char8 115,
	%Char8 32,
	%Char8 116,
	%Char8 101,
	%Char8 109,
	%Char8 112,
	%Char8 117,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 116,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 101,
	%Char8 103,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 99,
	%Char8 111,
	%Char8 110,
	%Char8 100,
	%Char8 105,
	%Char8 109,
	%Char8 101,
	%Char8 110,
	%Char8 116,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 114,
	%Char8 104,
	%Char8 111,
	%Char8 110,
	%Char8 99,
	%Char8 117,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 109,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 109,
	%Char8 112,
	%Char8 101,
	%Char8 114,
	%Char8 32,
	%Char8 108,
	%Char8 105,
	%Char8 98,
	%Char8 101,
	%Char8 114,
	%Char8 111,
	%Char8 44,
	%Char8 32,
	%Char8 115,
	%Char8 105,
	%Char8 116,
	%Char8 32,
	%Char8 97,
	%Char8 109,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 97,
	%Char8 100,
	%Char8 105,
	%Char8 112,
	%Char8 105,
	%Char8 115,
	%Char8 99,
	%Char8 105,
	%Char8 110,
	%Char8 103,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 109,
	%Char8 32,
	%Char8 110,
	%Char8 101,
	%Char8 113,
	%Char8 117,
	%Char8 101,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 100,
	%Char8 32,
	%Char8 105,
	%Char8 112,
	%Char8 115,
	%Char8 117,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 78,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 110,
	%Char8 117,
	%Char8 110,
	%Char8 99,
	%Char8 44,
	%Char8 32,
	%Char8 98,
	%Char8 108,
	%Char8 97,
	%Char8 110,
	%Char8 100,
	%Char8 105,
	%Char8 116,
	%Char8 32,
	%Char8 118,
	%Char8 101
]
@xlorem1024 = internal global [1024 x %Char8] [
	%Char8 76,
	%Char8 111,
	%Char8 114,
	%Char8 101,
	%Char8 109,
	%Char8 32,
	%Char8 105,
	%Char8 112,
	%Char8 115,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 100,
	%Char8 111,
	%Char8 108,
	%Char8 111,
	%Char8 114,
	%Char8 32,
	%Char8 115,
	%Char8 105,
	%Char8 116,
	%Char8 32,
	%Char8 97,
	%Char8 109,
	%Char8 101,
	%Char8 116,
	%Char8 44,
	%Char8 32,
	%Char8 99,
	%Char8 111,
	%Char8 110,
	%Char8 115,
	%Char8 101,
	%Char8 99,
	%Char8 116,
	%Char8 101,
	%Char8 116,
	%Char8 117,
	%Char8 101,
	%Char8 114,
	%Char8 32,
	%Char8 97,
	%Char8 100,
	%Char8 105,
	%Char8 112,
	%Char8 105,
	%Char8 115,
	%Char8 99,
	%Char8 105,
	%Char8 110,
	%Char8 103,
	%Char8 32,
	%Char8 101,
	%Char8 108,
	%Char8 105,
	%Char8 116,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 97,
	%Char8 110,
	%Char8 32,
	%Char8 99,
	%Char8 111,
	%Char8 109,
	%Char8 109,
	%Char8 111,
	%Char8 100,
	%Char8 111,
	%Char8 32,
	%Char8 108,
	%Char8 105,
	%Char8 103,
	%Char8 117,
	%Char8 108,
	%Char8 97,
	%Char8 32,
	%Char8 101,
	%Char8 103,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 100,
	%Char8 111,
	%Char8 108,
	%Char8 111,
	%Char8 114,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 97,
	%Char8 110,
	%Char8 32,
	%Char8 109,
	%Char8 97,
	%Char8 115,
	%Char8 115,
	%Char8 97,
	%Char8 46,
	%Char8 32,
	%Char8 67,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 115,
	%Char8 111,
	%Char8 99,
	%Char8 105,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 110,
	%Char8 97,
	%Char8 116,
	%Char8 111,
	%Char8 113,
	%Char8 117,
	%Char8 101,
	%Char8 32,
	%Char8 112,
	%Char8 101,
	%Char8 110,
	%Char8 97,
	%Char8 116,
	%Char8 105,
	%Char8 98,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 109,
	%Char8 97,
	%Char8 103,
	%Char8 110,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 100,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 112,
	%Char8 97,
	%Char8 114,
	%Char8 116,
	%Char8 117,
	%Char8 114,
	%Char8 105,
	%Char8 101,
	%Char8 110,
	%Char8 116,
	%Char8 32,
	%Char8 109,
	%Char8 111,
	%Char8 110,
	%Char8 116,
	%Char8 101,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 110,
	%Char8 97,
	%Char8 115,
	%Char8 99,
	%Char8 101,
	%Char8 116,
	%Char8 117,
	%Char8 114,
	%Char8 32,
	%Char8 114,
	%Char8 105,
	%Char8 100,
	%Char8 105,
	%Char8 99,
	%Char8 117,
	%Char8 108,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 109,
	%Char8 117,
	%Char8 115,
	%Char8 46,
	%Char8 32,
	%Char8 68,
	%Char8 111,
	%Char8 110,
	%Char8 101,
	%Char8 99,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 102,
	%Char8 101,
	%Char8 108,
	%Char8 105,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 117,
	%Char8 108,
	%Char8 116,
	%Char8 114,
	%Char8 105,
	%Char8 99,
	%Char8 105,
	%Char8 101,
	%Char8 115,
	%Char8 32,
	%Char8 110,
	%Char8 101,
	%Char8 99,
	%Char8 44,
	%Char8 32,
	%Char8 112,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 101,
	%Char8 110,
	%Char8 116,
	%Char8 101,
	%Char8 115,
	%Char8 113,
	%Char8 117,
	%Char8 101,
	%Char8 32,
	%Char8 101,
	%Char8 117,
	%Char8 44,
	%Char8 32,
	%Char8 112,
	%Char8 114,
	%Char8 101,
	%Char8 116,
	%Char8 105,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 105,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 78,
	%Char8 117,
	%Char8 108,
	%Char8 108,
	%Char8 97,
	%Char8 32,
	%Char8 99,
	%Char8 111,
	%Char8 110,
	%Char8 115,
	%Char8 101,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 116,
	%Char8 32,
	%Char8 109,
	%Char8 97,
	%Char8 115,
	%Char8 115,
	%Char8 97,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 101,
	%Char8 110,
	%Char8 105,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 68,
	%Char8 111,
	%Char8 110,
	%Char8 101,
	%Char8 99,
	%Char8 32,
	%Char8 112,
	%Char8 101,
	%Char8 100,
	%Char8 101,
	%Char8 32,
	%Char8 106,
	%Char8 117,
	%Char8 115,
	%Char8 116,
	%Char8 111,
	%Char8 44,
	%Char8 32,
	%Char8 102,
	%Char8 114,
	%Char8 105,
	%Char8 110,
	%Char8 103,
	%Char8 105,
	%Char8 108,
	%Char8 108,
	%Char8 97,
	%Char8 32,
	%Char8 118,
	%Char8 101,
	%Char8 108,
	%Char8 44,
	%Char8 32,
	%Char8 97,
	%Char8 108,
	%Char8 105,
	%Char8 113,
	%Char8 117,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 110,
	%Char8 101,
	%Char8 99,
	%Char8 44,
	%Char8 32,
	%Char8 118,
	%Char8 117,
	%Char8 108,
	%Char8 112,
	%Char8 117,
	%Char8 116,
	%Char8 97,
	%Char8 116,
	%Char8 101,
	%Char8 32,
	%Char8 101,
	%Char8 103,
	%Char8 101,
	%Char8 116,
	%Char8 44,
	%Char8 32,
	%Char8 97,
	%Char8 114,
	%Char8 99,
	%Char8 117,
	%Char8 46,
	%Char8 32,
	%Char8 73,
	%Char8 110,
	%Char8 32,
	%Char8 101,
	%Char8 110,
	%Char8 105,
	%Char8 109,
	%Char8 32,
	%Char8 106,
	%Char8 117,
	%Char8 115,
	%Char8 116,
	%Char8 111,
	%Char8 44,
	%Char8 32,
	%Char8 114,
	%Char8 104,
	%Char8 111,
	%Char8 110,
	%Char8 99,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 117,
	%Char8 116,
	%Char8 44,
	%Char8 32,
	%Char8 105,
	%Char8 109,
	%Char8 112,
	%Char8 101,
	%Char8 114,
	%Char8 100,
	%Char8 105,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 97,
	%Char8 44,
	%Char8 32,
	%Char8 118,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 110,
	%Char8 97,
	%Char8 116,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 118,
	%Char8 105,
	%Char8 116,
	%Char8 97,
	%Char8 101,
	%Char8 44,
	%Char8 32,
	%Char8 106,
	%Char8 117,
	%Char8 115,
	%Char8 116,
	%Char8 111,
	%Char8 46,
	%Char8 32,
	%Char8 78,
	%Char8 117,
	%Char8 108,
	%Char8 108,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 100,
	%Char8 105,
	%Char8 99,
	%Char8 116,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 102,
	%Char8 101,
	%Char8 108,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 101,
	%Char8 117,
	%Char8 32,
	%Char8 112,
	%Char8 101,
	%Char8 100,
	%Char8 101,
	%Char8 32,
	%Char8 109,
	%Char8 111,
	%Char8 108,
	%Char8 108,
	%Char8 105,
	%Char8 115,
	%Char8 32,
	%Char8 112,
	%Char8 114,
	%Char8 101,
	%Char8 116,
	%Char8 105,
	%Char8 117,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 73,
	%Char8 110,
	%Char8 116,
	%Char8 101,
	%Char8 103,
	%Char8 101,
	%Char8 114,
	%Char8 32,
	%Char8 116,
	%Char8 105,
	%Char8 110,
	%Char8 99,
	%Char8 105,
	%Char8 100,
	%Char8 117,
	%Char8 110,
	%Char8 116,
	%Char8 46,
	%Char8 32,
	%Char8 67,
	%Char8 114,
	%Char8 97,
	%Char8 115,
	%Char8 32,
	%Char8 100,
	%Char8 97,
	%Char8 112,
	%Char8 105,
	%Char8 98,
	%Char8 117,
	%Char8 115,
	%Char8 46,
	%Char8 32,
	%Char8 86,
	%Char8 105,
	%Char8 118,
	%Char8 97,
	%Char8 109,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 101,
	%Char8 108,
	%Char8 101,
	%Char8 109,
	%Char8 101,
	%Char8 110,
	%Char8 116,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 109,
	%Char8 112,
	%Char8 101,
	%Char8 114,
	%Char8 32,
	%Char8 110,
	%Char8 105,
	%Char8 115,
	%Char8 105,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 97,
	%Char8 110,
	%Char8 32,
	%Char8 118,
	%Char8 117,
	%Char8 108,
	%Char8 112,
	%Char8 117,
	%Char8 116,
	%Char8 97,
	%Char8 116,
	%Char8 101,
	%Char8 32,
	%Char8 101,
	%Char8 108,
	%Char8 101,
	%Char8 105,
	%Char8 102,
	%Char8 101,
	%Char8 110,
	%Char8 100,
	%Char8 32,
	%Char8 116,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 117,
	%Char8 115,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 97,
	%Char8 110,
	%Char8 32,
	%Char8 108,
	%Char8 101,
	%Char8 111,
	%Char8 32,
	%Char8 108,
	%Char8 105,
	%Char8 103,
	%Char8 117,
	%Char8 108,
	%Char8 97,
	%Char8 44,
	%Char8 32,
	%Char8 112,
	%Char8 111,
	%Char8 114,
	%Char8 116,
	%Char8 116,
	%Char8 105,
	%Char8 116,
	%Char8 111,
	%Char8 114,
	%Char8 32,
	%Char8 101,
	%Char8 117,
	%Char8 44,
	%Char8 32,
	%Char8 99,
	%Char8 111,
	%Char8 110,
	%Char8 115,
	%Char8 101,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 116,
	%Char8 32,
	%Char8 118,
	%Char8 105,
	%Char8 116,
	%Char8 97,
	%Char8 101,
	%Char8 44,
	%Char8 32,
	%Char8 101,
	%Char8 108,
	%Char8 101,
	%Char8 105,
	%Char8 102,
	%Char8 101,
	%Char8 110,
	%Char8 100,
	%Char8 32,
	%Char8 97,
	%Char8 99,
	%Char8 44,
	%Char8 32,
	%Char8 101,
	%Char8 110,
	%Char8 105,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 108,
	%Char8 105,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 108,
	%Char8 111,
	%Char8 114,
	%Char8 101,
	%Char8 109,
	%Char8 32,
	%Char8 97,
	%Char8 110,
	%Char8 116,
	%Char8 101,
	%Char8 44,
	%Char8 32,
	%Char8 100,
	%Char8 97,
	%Char8 112,
	%Char8 105,
	%Char8 98,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 105,
	%Char8 110,
	%Char8 44,
	%Char8 32,
	%Char8 118,
	%Char8 105,
	%Char8 118,
	%Char8 101,
	%Char8 114,
	%Char8 114,
	%Char8 97,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 105,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 102,
	%Char8 101,
	%Char8 117,
	%Char8 103,
	%Char8 105,
	%Char8 97,
	%Char8 116,
	%Char8 32,
	%Char8 97,
	%Char8 44,
	%Char8 32,
	%Char8 116,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 117,
	%Char8 115,
	%Char8 46,
	%Char8 32,
	%Char8 80,
	%Char8 104,
	%Char8 97,
	%Char8 115,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 118,
	%Char8 105,
	%Char8 118,
	%Char8 101,
	%Char8 114,
	%Char8 114,
	%Char8 97,
	%Char8 32,
	%Char8 110,
	%Char8 117,
	%Char8 108,
	%Char8 108,
	%Char8 97,
	%Char8 32,
	%Char8 117,
	%Char8 116,
	%Char8 32,
	%Char8 109,
	%Char8 101,
	%Char8 116,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 118,
	%Char8 97,
	%Char8 114,
	%Char8 105,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 108,
	%Char8 97,
	%Char8 111,
	%Char8 114,
	%Char8 101,
	%Char8 101,
	%Char8 116,
	%Char8 46,
	%Char8 32,
	%Char8 81,
	%Char8 117,
	%Char8 105,
	%Char8 115,
	%Char8 113,
	%Char8 117,
	%Char8 101,
	%Char8 32,
	%Char8 114,
	%Char8 117,
	%Char8 116,
	%Char8 114,
	%Char8 117,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 65,
	%Char8 101,
	%Char8 110,
	%Char8 101,
	%Char8 97,
	%Char8 110,
	%Char8 32,
	%Char8 105,
	%Char8 109,
	%Char8 112,
	%Char8 101,
	%Char8 114,
	%Char8 100,
	%Char8 105,
	%Char8 101,
	%Char8 116,
	%Char8 46,
	%Char8 32,
	%Char8 69,
	%Char8 116,
	%Char8 105,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 117,
	%Char8 108,
	%Char8 116,
	%Char8 114,
	%Char8 105,
	%Char8 99,
	%Char8 105,
	%Char8 101,
	%Char8 115,
	%Char8 32,
	%Char8 110,
	%Char8 105,
	%Char8 115,
	%Char8 105,
	%Char8 32,
	%Char8 118,
	%Char8 101,
	%Char8 108,
	%Char8 32,
	%Char8 97,
	%Char8 117,
	%Char8 103,
	%Char8 117,
	%Char8 101,
	%Char8 46,
	%Char8 32,
	%Char8 67,
	%Char8 117,
	%Char8 114,
	%Char8 97,
	%Char8 98,
	%Char8 105,
	%Char8 116,
	%Char8 117,
	%Char8 114,
	%Char8 32,
	%Char8 117,
	%Char8 108,
	%Char8 108,
	%Char8 97,
	%Char8 109,
	%Char8 99,
	%Char8 111,
	%Char8 114,
	%Char8 112,
	%Char8 101,
	%Char8 114,
	%Char8 32,
	%Char8 117,
	%Char8 108,
	%Char8 116,
	%Char8 114,
	%Char8 105,
	%Char8 99,
	%Char8 105,
	%Char8 101,
	%Char8 115,
	%Char8 32,
	%Char8 110,
	%Char8 105,
	%Char8 115,
	%Char8 105,
	%Char8 46,
	%Char8 32,
	%Char8 78,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 101,
	%Char8 103,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 100,
	%Char8 117,
	%Char8 105,
	%Char8 46,
	%Char8 32,
	%Char8 69,
	%Char8 116,
	%Char8 105,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 114,
	%Char8 104,
	%Char8 111,
	%Char8 110,
	%Char8 99,
	%Char8 117,
	%Char8 115,
	%Char8 46,
	%Char8 32,
	%Char8 77,
	%Char8 97,
	%Char8 101,
	%Char8 99,
	%Char8 101,
	%Char8 110,
	%Char8 97,
	%Char8 115,
	%Char8 32,
	%Char8 116,
	%Char8 101,
	%Char8 109,
	%Char8 112,
	%Char8 117,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 116,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 117,
	%Char8 115,
	%Char8 32,
	%Char8 101,
	%Char8 103,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 99,
	%Char8 111,
	%Char8 110,
	%Char8 100,
	%Char8 105,
	%Char8 109,
	%Char8 101,
	%Char8 110,
	%Char8 116,
	%Char8 117,
	%Char8 109,
	%Char8 32,
	%Char8 114,
	%Char8 104,
	%Char8 111,
	%Char8 110,
	%Char8 99,
	%Char8 117,
	%Char8 115,
	%Char8 44,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 109,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 109,
	%Char8 112,
	%Char8 101,
	%Char8 114,
	%Char8 32,
	%Char8 108,
	%Char8 105,
	%Char8 98,
	%Char8 101,
	%Char8 114,
	%Char8 111,
	%Char8 44,
	%Char8 32,
	%Char8 115,
	%Char8 105,
	%Char8 116,
	%Char8 32,
	%Char8 97,
	%Char8 109,
	%Char8 101,
	%Char8 116,
	%Char8 32,
	%Char8 97,
	%Char8 100,
	%Char8 105,
	%Char8 112,
	%Char8 105,
	%Char8 115,
	%Char8 99,
	%Char8 105,
	%Char8 110,
	%Char8 103,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 109,
	%Char8 32,
	%Char8 110,
	%Char8 101,
	%Char8 113,
	%Char8 117,
	%Char8 101,
	%Char8 32,
	%Char8 115,
	%Char8 101,
	%Char8 100,
	%Char8 32,
	%Char8 105,
	%Char8 112,
	%Char8 115,
	%Char8 117,
	%Char8 109,
	%Char8 46,
	%Char8 32,
	%Char8 78,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 113,
	%Char8 117,
	%Char8 97,
	%Char8 109,
	%Char8 32,
	%Char8 110,
	%Char8 117,
	%Char8 110,
	%Char8 99,
	%Char8 44,
	%Char8 32,
	%Char8 98,
	%Char8 108,
	%Char8 97,
	%Char8 110,
	%Char8 100,
	%Char8 105,
	%Char8 116,
	%Char8 32,
	%Char8 118,
	%Char8 101
]
define %Int @main() {
	;printf("%s\n", *Str8 hello_world)
	;var data = []Byte [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	%1 = alloca %Context, align 8
	%2 = load [3 x %Word32], [3 x %Word32]* @testNonce2
	%3 = call %Context @init([32 x %Byte]* @testKey, [3 x %Word32] %2)
; -- cons_composite_from_composite_by_value --
	%4 = alloca %Context
	store %Context %3, %Context* %4
	%5 = bitcast %Context* %4 to %Context*
; -- end cons_composite_from_composite_by_value --
	%6 = load %Context, %Context* %5
	store %Context %6, %Context* %1
	%7 = bitcast [1024 x %Char8]* @xlorem1024 to [0 x %Byte]*
	%8 = bitcast %Context* %1 to %Context*
	call void @cipher(%Context* %8, [0 x %Byte]* %7, %Nat32 1024)
	%9 = alloca %Int32, align 4
	store %Int32 0, %Int32* %9
; while_1
	br label %again_1
again_1:
	%10 = load %Int32, %Int32* %9
	%11 = icmp slt %Int32 %10, 10
	br %Bool %11 , label %body_1, label %break_1
body_1:
	%12 = load %Int32, %Int32* %9
	%13 = getelementptr [1024 x %Char8], [1024 x %Char8]* @xlorem1024, %Int32 0, %Int32 %12
	%14 = load %Char8, %Char8* %13
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str1 to [0 x i8]*), %Char8 %14)
	%16 = load %Int32, %Int32* %9
	%17 = getelementptr [1024 x %Char8], [1024 x %Char8]* @xlorem1024, %Int32 0, %Int32 %16
	%18 = load %Char8, %Char8* %17
	%19 = bitcast %Char8 %18 to %Word8
	%20 = zext %Word8 %19 to %Word32
	%21 = bitcast %Word32 %20 to %Nat32
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str2 to [0 x i8]*), %Nat32 %21)
	%23 = load %Int32, %Int32* %9
	%24 = add %Int32 %23, 1
	store %Int32 %24, %Int32* %9
	br label %again_1
break_1:
	%25 = alloca %Context, align 8
	%26 = load [3 x %Word32], [3 x %Word32]* @testNonce2
	%27 = call %Context @init([32 x %Byte]* @testKey, [3 x %Word32] %26)
; -- cons_composite_from_composite_by_value --
	%28 = alloca %Context
	store %Context %27, %Context* %28
	%29 = bitcast %Context* %28 to %Context*
; -- end cons_composite_from_composite_by_value --
	%30 = load %Context, %Context* %29
	store %Context %30, %Context* %25
	%31 = bitcast %Context* %25 to %Context*
	call void @cipher(%Context* %31, [0 x %Byte]* %7, %Nat32 1024)
	store %Int32 0, %Int32* %9
; while_2
	br label %again_2
again_2:
	%32 = load %Int32, %Int32* %9
	%33 = icmp slt %Int32 %32, 1024
	br %Bool %33 , label %body_2, label %break_2
body_2:
	%34 = load %Int32, %Int32* %9
	%35 = getelementptr [1024 x %Char8], [1024 x %Char8]* @xlorem1024, %Int32 0, %Int32 %34
	%36 = load %Char8, %Char8* %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str3 to [0 x i8]*), %Char8 %36)
	%38 = load %Int32, %Int32* %9
	%39 = add %Int32 %38, 1
	store %Int32 %39, %Int32* %9
	br label %again_2
break_2:
	call void @test0()
	ret %Int 0
}

define internal void @test0() {
	%1 = alloca [32 x %Byte], align 1
	%2 = load [32 x %Byte], [32 x %Byte]* @testKey
	%3 = zext i8 32 to %Nat32
	store [32 x %Byte] %2, [32 x %Byte]* %1
	%4 = alloca %Word32, align 4
	%5 = zext i8 1 to %Word32
	store %Word32 %5, %Word32* %4
	%6 = alloca [12 x %Byte], align 1
	%7 = load [12 x %Byte], [12 x %Byte]* @testNonce
	%8 = zext i8 12 to %Nat32
	store [12 x %Byte] %7, [12 x %Byte]* %6
	%9 = alloca %State, align 1
	%10 = bitcast [32 x %Byte]* %1 to %Key*
	%11 = load %Word32, %Word32* %4
	%12 = bitcast [12 x %Byte]* %6 to [3 x %Word32]*; alloca memory for return value
	%13 = alloca %State
	call void @makeState(%State* %13, %Key* %10, %Word32 %11, [3 x %Word32]* %12)
	%14 = load %State, %State* %13
	%15 = zext i8 16 to %Nat32
	store %State %14, %State* %9
	%16 = alloca %Block, align 1
	%17 = load %State, %State* %9; alloca memory for return value
	%18 = alloca %Block
	call void @chacha20Block(%Block* %18, %State %17)
	%19 = load %Block, %Block* %18
	%20 = zext i8 16 to %Nat32
	store %Block %19, %Block* %16
	%21 = alloca %Int32, align 4
	store %Int32 0, %Int32* %21
; while_1
	br label %again_1
again_1:
	%22 = load %Int32, %Int32* %21
	%23 = icmp slt %Int32 %22, 16
	br %Bool %23 , label %body_1, label %break_1
body_1:
	%24 = load %Int32, %Int32* %21
	%25 = getelementptr %Block, %Block* %16, %Int32 0, %Int32 %24
	%26 = load %Word32, %Word32* %25
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str4 to [0 x i8]*), %Word32 %26)
	%28 = load %Int32, %Int32* %21
	%29 = add %Int32 %28, 1
	store %Int32 %29, %Int32* %21
	br label %again_1
break_1:
	%30 = bitcast %Block* %16 to [64 x %Byte]*
; if_0
	%31 = bitcast [64 x %Byte]* %30 to i8*
	%32 = bitcast [64 x %Byte]* @testResult to i8*
	%33 = call i1 (i8*, i8*, i64) @memeq(i8* %31, i8* %32, %Int64 64)
	%34 = icmp ne %Bool %33, 0
	br %Bool %34 , label %then_0, label %else_0
then_0:
	%35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*))
	br label %endif_0
else_0:
	%36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str6 to [0 x i8]*))
	br label %endif_0
endif_0:
	ret void
}


