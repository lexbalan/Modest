
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
%VA_List = type i8*
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
; -- print imports --
; -- end print imports --
; -- strings --
@str1 = private constant [14 x i8] [i8 109, i8 101, i8 109, i8 99, i8 111, i8 112, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [10 x i8] [i8 76, i8 69, i8 78, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str3 = private constant [18 x i8] [i8 102, i8 105, i8 114, i8 115, i8 116, i8 110, i8 97, i8 109, i8 101, i8 32, i8 61, i8 32, i8 39, i8 37, i8 115, i8 39, i8 10, i8 0]
@str4 = private constant [17 x i8] [i8 108, i8 97, i8 115, i8 116, i8 110, i8 97, i8 109, i8 101, i8 32, i8 61, i8 32, i8 39, i8 37, i8 115, i8 39, i8 10, i8 0]
@str5 = private constant [10 x i8] [i8 97, i8 103, i8 101, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --

%main_Object = type {
	[32 x %Char8],
	[32 x %Char8],
	%Int32
};


define internal void @memcopy(i8* %dst, i8* %src, %Int32 %len) {
	; not worked now!
	;([len]Word8 dst) = ([len]Word8 src)
	ret void
}


define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str1 to [0 x i8]*))
	%2 = alloca %main_Object, align 4
	%3 = alloca %main_Object, align 4
	; -- STMT ASSIGN ARRAY --
	%4 = getelementptr inbounds %main_Object, %main_Object* %2, %Int32 0, %Int32 0
	; -- start vol eval --
	%5 = zext i6 32 to %Int32
	; -- end vol eval --
	%6 = insertvalue [32 x %Char8] zeroinitializer, %Char8 74, 0
	%7 = insertvalue [32 x %Char8] %6, %Char8 111, 1
	%8 = insertvalue [32 x %Char8] %7, %Char8 104, 2
	%9 = insertvalue [32 x %Char8] %8, %Char8 110, 3
	%10 = insertvalue [32 x %Char8] %9, %Char8 0, 4
	%11 = insertvalue [32 x %Char8] %10, %Char8 0, 5
	%12 = insertvalue [32 x %Char8] %11, %Char8 0, 6
	%13 = insertvalue [32 x %Char8] %12, %Char8 0, 7
	%14 = insertvalue [32 x %Char8] %13, %Char8 0, 8
	%15 = insertvalue [32 x %Char8] %14, %Char8 0, 9
	%16 = insertvalue [32 x %Char8] %15, %Char8 0, 10
	%17 = insertvalue [32 x %Char8] %16, %Char8 0, 11
	%18 = insertvalue [32 x %Char8] %17, %Char8 0, 12
	%19 = insertvalue [32 x %Char8] %18, %Char8 0, 13
	%20 = insertvalue [32 x %Char8] %19, %Char8 0, 14
	%21 = insertvalue [32 x %Char8] %20, %Char8 0, 15
	%22 = insertvalue [32 x %Char8] %21, %Char8 0, 16
	%23 = insertvalue [32 x %Char8] %22, %Char8 0, 17
	%24 = insertvalue [32 x %Char8] %23, %Char8 0, 18
	%25 = insertvalue [32 x %Char8] %24, %Char8 0, 19
	%26 = insertvalue [32 x %Char8] %25, %Char8 0, 20
	%27 = insertvalue [32 x %Char8] %26, %Char8 0, 21
	%28 = insertvalue [32 x %Char8] %27, %Char8 0, 22
	%29 = insertvalue [32 x %Char8] %28, %Char8 0, 23
	%30 = insertvalue [32 x %Char8] %29, %Char8 0, 24
	%31 = insertvalue [32 x %Char8] %30, %Char8 0, 25
	%32 = insertvalue [32 x %Char8] %31, %Char8 0, 26
	%33 = insertvalue [32 x %Char8] %32, %Char8 0, 27
	%34 = insertvalue [32 x %Char8] %33, %Char8 0, 28
	%35 = insertvalue [32 x %Char8] %34, %Char8 0, 29
	%36 = insertvalue [32 x %Char8] %35, %Char8 0, 30
	%37 = insertvalue [32 x %Char8] %36, %Char8 0, 31
	store [32 x %Char8] %37, [32 x %Char8]* %4
	; -- STMT ASSIGN ARRAY --
	%38 = getelementptr inbounds %main_Object, %main_Object* %2, %Int32 0, %Int32 1
	; -- start vol eval --
	%39 = zext i6 32 to %Int32
	; -- end vol eval --
	%40 = insertvalue [32 x %Char8] zeroinitializer, %Char8 68, 0
	%41 = insertvalue [32 x %Char8] %40, %Char8 111, 1
	%42 = insertvalue [32 x %Char8] %41, %Char8 101, 2
	%43 = insertvalue [32 x %Char8] %42, %Char8 0, 3
	%44 = insertvalue [32 x %Char8] %43, %Char8 0, 4
	%45 = insertvalue [32 x %Char8] %44, %Char8 0, 5
	%46 = insertvalue [32 x %Char8] %45, %Char8 0, 6
	%47 = insertvalue [32 x %Char8] %46, %Char8 0, 7
	%48 = insertvalue [32 x %Char8] %47, %Char8 0, 8
	%49 = insertvalue [32 x %Char8] %48, %Char8 0, 9
	%50 = insertvalue [32 x %Char8] %49, %Char8 0, 10
	%51 = insertvalue [32 x %Char8] %50, %Char8 0, 11
	%52 = insertvalue [32 x %Char8] %51, %Char8 0, 12
	%53 = insertvalue [32 x %Char8] %52, %Char8 0, 13
	%54 = insertvalue [32 x %Char8] %53, %Char8 0, 14
	%55 = insertvalue [32 x %Char8] %54, %Char8 0, 15
	%56 = insertvalue [32 x %Char8] %55, %Char8 0, 16
	%57 = insertvalue [32 x %Char8] %56, %Char8 0, 17
	%58 = insertvalue [32 x %Char8] %57, %Char8 0, 18
	%59 = insertvalue [32 x %Char8] %58, %Char8 0, 19
	%60 = insertvalue [32 x %Char8] %59, %Char8 0, 20
	%61 = insertvalue [32 x %Char8] %60, %Char8 0, 21
	%62 = insertvalue [32 x %Char8] %61, %Char8 0, 22
	%63 = insertvalue [32 x %Char8] %62, %Char8 0, 23
	%64 = insertvalue [32 x %Char8] %63, %Char8 0, 24
	%65 = insertvalue [32 x %Char8] %64, %Char8 0, 25
	%66 = insertvalue [32 x %Char8] %65, %Char8 0, 26
	%67 = insertvalue [32 x %Char8] %66, %Char8 0, 27
	%68 = insertvalue [32 x %Char8] %67, %Char8 0, 28
	%69 = insertvalue [32 x %Char8] %68, %Char8 0, 29
	%70 = insertvalue [32 x %Char8] %69, %Char8 0, 30
	%71 = insertvalue [32 x %Char8] %70, %Char8 0, 31
	store [32 x %Char8] %71, [32 x %Char8]* %38
	%72 = getelementptr inbounds %main_Object, %main_Object* %2, %Int32 0, %Int32 2
	store %Int32 30, %Int32* %72
	%73 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str2 to [0 x i8]*), %Int32 68)
	%74 = load %main_Object, %main_Object* %2
	store %main_Object %74, %main_Object* %3
	%75 = getelementptr inbounds %main_Object, %main_Object* %3, %Int32 0, %Int32 0
	%76 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str3 to [0 x i8]*), [32 x %Char8]* %75)
	%77 = getelementptr inbounds %main_Object, %main_Object* %3, %Int32 0, %Int32 1
	%78 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str4 to [0 x i8]*), [32 x %Char8]* %77)
	%79 = getelementptr inbounds %main_Object, %main_Object* %3, %Int32 0, %Int32 2
	%80 = load %Int32, %Int32* %79
	%81 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str5 to [0 x i8]*), %Int32 %80)
	ret %Int 0
}

