
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

; MODULE: queue

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
; end print includes
; -- strings --


define i32 @next(i32 %x) {
	%1 = icmp slt i32 %x, 3
	br i1 %1 , label %then_0, label %endif_0
then_0:
	%2 = add i32 %x, 1
	ret i32 %2
	br label %endif_0
endif_0:
	ret i32 0
}



%Queue = type {
	[4 x %Byte], 
	i32, 
	i32, 
	i32
};


define void @init(%Queue* %q) {
	; -- STMT ASSIGN ARRAY --
	%1 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 0
	; -- start vol eval --
	%2 = zext i3 4 to i32
	; -- end vol eval --
	; -- ZERO
	%3 = mul i32 %2, 1
	%4 = bitcast [4 x %Byte]* %1 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %4, i8 0, i32 %3, i1 0)
	%5 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 3
	store i32 0, i32* %5
	%6 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 1
	store i32 0, i32* %6
	%7 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 2
	store i32 0, i32* %7
	ret void
}

define i32 @getSize(%Queue* %q) {
	%1 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 3
	%2 = load i32, i32* %1
	ret i32 %2
}

define i1 @isEmpty(%Queue* %q) {
	%1 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 3
	%2 = load i32, i32* %1
	%3 = icmp eq i32 %2, 0
	ret i1 %3
}

define i1 @isFull(%Queue* %q) {
	%1 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 3
	%2 = load i32, i32* %1
	%3 = icmp eq i32 %2, 4
	ret i1 %3
}

define i1 @put(%Queue* %q, %Byte %b) {
	%1 = bitcast %Queue* %q to %Queue*
	%2 = call i1 @isFull(%Queue* %1)
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%4 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 0
	%5 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = getelementptr inbounds [4 x %Byte], [4 x %Byte]* %4, i32 0, i32 %6
	store %Byte %b, %Byte* %7
	%8 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 1
	%9 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 1
	%10 = load i32, i32* %9
	%11 = call i32 @next(i32 %10)
	store i32 %11, i32* %8
	%12 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 3
	%13 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 3
	%14 = load i32, i32* %13
	%15 = add i32 %14, 1
	store i32 %15, i32* %12
	ret i1 1
}

define %Byte @get(%Queue* %q) {
	%1 = bitcast %Queue* %q to %Queue*
	%2 = call i1 @isEmpty(%Queue* %1)
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret %Byte 0
	br label %endif_0
endif_0:
	%4 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 0
	%5 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 2
	%6 = load i32, i32* %5
	%7 = getelementptr inbounds [4 x %Byte], [4 x %Byte]* %4, i32 0, i32 %6
	%8 = load %Byte, %Byte* %7
	%9 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 2
	%10 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 2
	%11 = load i32, i32* %10
	%12 = call i32 @next(i32 %11)
	store i32 %12, i32* %9
	%13 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 3
	%14 = getelementptr inbounds %Queue, %Queue* %q, i32 0, i32 3
	%15 = load i32, i32* %14
	%16 = sub i32 %15, 1
	store i32 %16, i32* %13
	ret %Byte %8
}


