
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

; print includes

%Str = type %Str8;
%Char = type i8;
%ConstChar = type %Char;
%SignedChar = type i8;
%UnsignedChar = type i8;
%Short = type i16;
%UnsignedShort = type i16;
%Int = type i32;
%UnsignedInt = type i32;
%LongInt = type i64;
%UnsignedLongInt = type i64;
%Long = type i64;
%UnsignedLong = type i64;
%LongLong = type i64;
%UnsignedLongLong = type i64;
%LongLongInt = type i64;
%UnsignedLongLongInt = type i64;
%Float = type double;
%Double = type double;
%LongDouble = type double;


%SocklenT = type i32;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntptrT = type i64;
%PtrdiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PidT = type i32;
%UidT = type i32;
%GidT = type i32;


%File = type i8;
%FposT = type i8;
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
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)
declare %Int @setvbuf(%File* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %stream, %Str* %format, ...)
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

define i8 @utf32_to_utf8(i32 %c, [4 x i8]* %buf) {
	%1 = bitcast i32 %c to i32
	%2 = icmp ule i32 %1, 127
	br i1 %2 , label %then_0, label %else_0
then_0:
	%3 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 0
	%4 = trunc i32 %1 to i8
	store i8 %4, i8* %3
	ret i8 1
	br label %endif_0
else_0:
	%6 = icmp ule i32 %1, 2047
	br i1 %6 , label %then_1, label %else_1
then_1:
	%7 = lshr i32 %1, 6
	%8 = and i32 %7, 31
	%9 = lshr i32 %1, 0
	%10 = and i32 %9, 63
	%11 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 0
	%12 = or i32 192, %8
	%13 = trunc i32 %12 to i8
	store i8 %13, i8* %11
	%14 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 1
	%15 = or i32 128, %10
	%16 = trunc i32 %15 to i8
	store i8 %16, i8* %14
	ret i8 2
	br label %endif_1
else_1:
	%18 = icmp ule i32 %1, 65535
	br i1 %18 , label %then_2, label %else_2
then_2:
	%19 = lshr i32 %1, 12
	%20 = and i32 %19, 15
	%21 = lshr i32 %1, 6
	%22 = and i32 %21, 63
	%23 = lshr i32 %1, 0
	%24 = and i32 %23, 63
	%25 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 0
	%26 = or i32 224, %20
	%27 = trunc i32 %26 to i8
	store i8 %27, i8* %25
	%28 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 1
	%29 = or i32 128, %22
	%30 = trunc i32 %29 to i8
	store i8 %30, i8* %28
	%31 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 2
	%32 = or i32 128, %24
	%33 = trunc i32 %32 to i8
	store i8 %33, i8* %31
	ret i8 3
	br label %endif_2
else_2:
	%35 = icmp ule i32 %1, 1114111
	br i1 %35 , label %then_3, label %endif_3
then_3:
	%36 = lshr i32 %1, 18
	%37 = and i32 %36, 7
	%38 = lshr i32 %1, 12
	%39 = and i32 %38, 63
	%40 = lshr i32 %1, 6
	%41 = and i32 %40, 63
	%42 = lshr i32 %1, 0
	%43 = and i32 %42, 63
	%44 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 0
	%45 = or i32 240, %37
	%46 = trunc i32 %45 to i8
	store i8 %46, i8* %44
	%47 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 1
	%48 = or i32 128, %39
	%49 = trunc i32 %48 to i8
	store i8 %49, i8* %47
	%50 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 2
	%51 = or i32 128, %41
	%52 = trunc i32 %51 to i8
	store i8 %52, i8* %50
	%53 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 3
	%54 = or i32 128, %43
	%55 = trunc i32 %54 to i8
	store i8 %55, i8* %53
	ret i8 4
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret i8 0
}

define i8 @utf16_to_utf32([0 x i16]* %c, i32* %result) {
	%1 = getelementptr inbounds [0 x i16], [0 x i16]* %c, i32 0, i32 0
	%2 = load i16, i16* %1
	%3 = zext i16 %2 to i32
	%4 = icmp ult i32 %3, 55296
	%5 = icmp ugt i32 %3, 57343
	%6 = or i1 %4, %5
	br i1 %6 , label %then_0, label %else_0
then_0:
	%7 = bitcast i32 %3 to i32
	store i32 %7, i32* %result
	ret i8 1
	br label %endif_0
else_0:
	%9 = icmp uge i32 %3, 56320
	br i1 %9 , label %then_1, label %else_1
then_1:
	;error("Недопустимая кодовая последовательность.")
	br label %endif_1
else_1:
	%10 = alloca i32, align 4
	%11 = and i32 %3, 1023
	%12 = shl i32 %11, 10
	store i32 %12, i32* %10
	%13 = getelementptr inbounds [0 x i16], [0 x i16]* %c, i32 0, i32 1
	%14 = load i16, i16* %13
	%15 = zext i16 %14 to i32
	%16 = icmp ult i32 %15, 56320
	%17 = icmp ugt i32 %15, 57343
	%18 = or i1 %16, %17
	br i1 %18 , label %then_2, label %else_2
then_2:
	;error("Недопустимая кодовая последовательность.")
	br label %endif_2
else_2:
	%19 = load i32, i32* %10
	%20 = and i32 %15, 1023
	%21 = or i32 %19, %20
	store i32 %21, i32* %10
	%22 = load i32, i32* %10
	%23 = add i32 %22, 65536
	%24 = bitcast i32 %23 to i32
	store i32 %24, i32* %result
	ret i8 2
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret i8 0
}



define void @putchar8(i8 %c) {
	call void @utf8_putchar(i8 %c)
	ret void
}

define void @putchar16(i16 %c) {
	call void @utf16_putchar(i16 %c)
	ret void
}

define void @putchar32(i32 %c) {
	call void @utf32_putchar(i32 %c)
	ret void
}

define void @utf8_putchar(i8 %c) {
	%1 = sext i8 %c to i32
	%2 = call %Int @putchar(i32 %1)
	ret void
}

define void @utf16_putchar(i16 %c) {
	%1 = alloca [2 x i16], align 2
	%2 = getelementptr inbounds [2 x i16], [2 x i16]* %1, i32 0, i32 0
	store i16 %c, i16* %2
	%3 = getelementptr inbounds [2 x i16], [2 x i16]* %1, i32 0, i32 1
	store i16 0, i16* %3
	%4 = alloca i32, align 4
	%5 = bitcast [2 x i16]* %1 to [0 x i16]*
	%6 = call i8 @utf16_to_utf32([0 x i16]* %5, i32* %4)
	%7 = load i32, i32* %4
	call void @utf32_putchar(i32 %7)
	ret void
}

define void @utf32_putchar(i32 %c) {
	%1 = alloca [4 x i8], align 1
	%2 = call i8 @utf32_to_utf8(i32 %c, [4 x i8]* %1)
	%3 = sext i8 %2 to %Int
	%4 = alloca i32, align 4
	store i32 0, i32* %4
	br label %again_1
again_1:
	%5 = load i32, i32* %4
	%6 = icmp slt i32 %5, %3
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i32, i32* %4
	%8 = getelementptr inbounds [4 x i8], [4 x i8]* %1, i32 0, i32 %7
	%9 = load i8, i8* %8
	call void @utf8_putchar(i8 %9)
	%10 = load i32, i32* %4
	%11 = add i32 %10, 1
	store i32 %11, i32* %4
	br label %again_1
break_1:
	ret void
}

define void @utf8_puts(%Str8* %s) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%2 = load i32, i32* %1
	%3 = getelementptr inbounds %Str8, %Str8* %s, i32 0, i32 %2
	%4 = load i8, i8* %3
	%5 = icmp eq i8 %4, 0
	br i1 %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	call void @utf8_putchar(i8 %4)
	%7 = load i32, i32* %1
	%8 = add i32 %7, 1
	store i32 %8, i32* %1
	br label %again_1
break_1:
	ret void
}

define void @utf16_puts(%Str16* %s) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	; нельзя просто так взять и вызвать utf16_putchar
	; тк в строке может быть суррогатная пара UTF_16 символов
	%2 = load i32, i32* %1
	%3 = getelementptr inbounds %Str16, %Str16* %s, i32 0, i32 %2
	%4 = load i16, i16* %3
	%5 = icmp eq i16 %4, 0
	br i1 %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	%7 = alloca i32, align 4
	%8 = load i32, i32* %1
	%9 = getelementptr inbounds %Str16, %Str16* %s, i32 0, i32 %8
	%10 = bitcast i16* %9 to [0 x i16]*
	%11 = call i8 @utf16_to_utf32([0 x i16]* %10, i32* %7)
	%12 = icmp eq i8 %11, 0
	br i1 %12 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	%14 = load i32, i32* %7
	call void @utf32_putchar(i32 %14)
	%15 = load i32, i32* %1
	%16 = sext i8 %11 to i32
	%17 = add i32 %15, %16
	store i32 %17, i32* %1
	br label %again_1
break_1:
	ret void
}

define void @utf32_puts(%Str32* %s) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%2 = load i32, i32* %1
	%3 = getelementptr inbounds %Str32, %Str32* %s, i32 0, i32 %2
	%4 = load i32, i32* %3
	%5 = icmp eq i32 %4, 0
	br i1 %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	call void @utf32_putchar(i32 %4)
	%7 = load i32, i32* %1
	%8 = add i32 %7, 1
	store i32 %8, i32* %1
	br label %again_1
break_1:
	ret void
}

; end print includes
; -- strings --
@str1 = private constant [7 x i8] [i8 83, i8 116, i8 114, i8 105, i8 110, i8 103, i8 0]
@str2 = private constant [9 x i16] [i16 83, i16 116, i16 114, i16 105, i16 110, i16 103, i16 45, i16 937, i16 0]
@str3 = private constant [13 x i32] [i32 83, i32 116, i32 114, i32 105, i32 110, i32 103, i32 45, i32 937, i32 32, i32 128000, i32 127881, i32 129412, i32 0]
@str4 = private constant [2 x i8] [i8 10, i8 0]
@str5 = private constant [2 x i8] [i8 10, i8 0]
@str6 = private constant [3 x i8] [i8 10, i8 10, i8 0]
@str7 = private constant [2 x i8] [i8 10, i8 0]
@str8 = private constant [2 x i8] [i8 10, i8 0]
@str9 = private constant [3 x i8] [i8 10, i8 10, i8 0]
@str10 = private constant [2 x i8] [i8 10, i8 0]
@str11 = private constant [2 x i8] [i8 10, i8 0]
@str12 = private constant [2 x i8] [i8 10, i8 0]



@string8 = global [6 x i8] [
	i8 83,
	i8 116,
	i8 114,
	i8 105,
	i8 110,
	i8 103
]
@string16 = global [8 x i16] [
	i16 83,
	i16 116,
	i16 114,
	i16 105,
	i16 110,
	i16 103,
	i16 45,
	i16 937
]
@string32 = global [12 x i32] [
	i32 83,
	i32 116,
	i32 114,
	i32 105,
	i32 110,
	i32 103,
	i32 45,
	i32 937,
	i32 32,
	i32 128000,
	i32 127881,
	i32 129412
]
@ptr_to_string8 = global [0 x i8]* bitcast ([7 x i8]* @str1 to [0 x i8]*)
@ptr_to_string16 = global [0 x i16]* bitcast ([9 x i16]* @str2 to [0 x i16]*)
@ptr_to_string32 = global [0 x i32]* bitcast ([13 x i32]* @str3 to [0 x i32]*)

define %Int @main() {
	call void @utf8_putchar(i8 65)
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str4 to [0 x i8]*))
	call void @utf16_putchar(i16 937)
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str5 to [0 x i8]*))
	call void @utf32_putchar(i32 129412)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str6 to [0 x i8]*))
	%4 = bitcast [6 x i8]* @string8 to %Str8*
	call void @utf8_puts(%Str8* %4)
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str7 to [0 x i8]*))
	%6 = bitcast [8 x i16]* @string16 to %Str16*
	call void @utf16_puts(%Str16* %6)
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str8 to [0 x i8]*))
	%8 = bitcast [12 x i32]* @string32 to %Str32*
	call void @utf32_puts(%Str32* %8)
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str9 to [0 x i8]*))
	%10 = load [0 x i8]*, [0 x i8]** @ptr_to_string8
	call void @utf8_puts([0 x i8]* %10)
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str10 to [0 x i8]*))
	%12 = load [0 x i16]*, [0 x i16]** @ptr_to_string16
	call void @utf16_puts([0 x i16]* %12)
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str11 to [0 x i8]*))
	%14 = load [0 x i32]*, [0 x i32]** @ptr_to_string32
	call void @utf32_puts([0 x i32]* %14)
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str12 to [0 x i8]*))
	ret %Int 0
}


