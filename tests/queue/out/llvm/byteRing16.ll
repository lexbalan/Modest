
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

; MODULE: byteRing16

; -- print includes --
; -- end print includes --
; -- print imports 'byteRing16' --
; -- 1
; ?? queue ??
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
; from import
%queue_Queue = type {
	%Int32,
	%Int32,
	%Int32,
	%Int32
};

declare void @queue_init(%queue_Queue* %q, %Int32 %capacity)
declare %Int32 @queue_capacity(%queue_Queue* %q)
declare %Int32 @queue_size(%queue_Queue* %q)
declare %Bool @queue_isEmpty(%queue_Queue* %q)
declare %Bool @queue_isFull(%queue_Queue* %q)
declare %Int32 @queue_getPutPosition(%queue_Queue* %q)
declare %Int32 @queue_getGetPosition(%queue_Queue* %q)
; end from import
; -- end print imports 'byteRing16' --
; -- strings --
; -- endstrings --
%byteRing16_Word8Ring16 = type {
	%queue_Queue,
	[16 x %Word8]
};

define void @byteRing16_init(%byteRing16_Word8Ring16* %q) {
	%1 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 0
	call void @queue_init(%queue_Queue* %1, %Int32 16)
	%2 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 1
	%3 = zext i8 16 to %Int32
	%4 = mul %Int32 %3, 1
	%5 = bitcast [16 x %Word8]* %2 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %5, i8 0, %Int32 %4, i1 0)
	ret void
}

define %Int32 @byteRing16_capacity(%byteRing16_Word8Ring16* %q) {
	%1 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 0
	%2 = call %Int32 @queue_capacity(%queue_Queue* %1)
	ret %Int32 %2
}

define %Int32 @byteRing16_size(%byteRing16_Word8Ring16* %q) {
	%1 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 0
	%2 = call %Int32 @queue_size(%queue_Queue* %1)
	ret %Int32 %2
}

define %Bool @byteRing16_isFull(%byteRing16_Word8Ring16* %q) {
	%1 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 0
	%2 = call %Bool @queue_isFull(%queue_Queue* %1)
	ret %Bool %2
}

define %Bool @byteRing16_isEmpty(%byteRing16_Word8Ring16* %q) {
	%1 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 0
	%2 = call %Bool @queue_isEmpty(%queue_Queue* %1)
	ret %Bool %2
}

define %Bool @byteRing16_put(%byteRing16_Word8Ring16* %q, %Word8 %b) {
;if queue.isFull(&q.queue) {
;		return false
;	}
	%1 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 0
	%2 = call %Int32 @queue_getPutPosition(%queue_Queue* %1)
	%3 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 1
	%4 = bitcast %Int32 %2 to %Int32
	%5 = getelementptr [16 x %Word8], [16 x %Word8]* %3, %Int32 0, %Int32 %4
	store %Word8 %b, %Word8* %5
	ret %Bool 1
}

define %Bool @byteRing16_get(%byteRing16_Word8Ring16* %q, %Word8* %b) {
	%1 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 0
	%2 = call %Bool @queue_isEmpty(%queue_Queue* %1)
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	ret %Bool 0
	br label %endif_0
endif_0:
	%4 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 0
	%5 = call %Int32 @queue_getGetPosition(%queue_Queue* %4)
	%6 = getelementptr %byteRing16_Word8Ring16, %byteRing16_Word8Ring16* %q, %Int32 0, %Int32 1
	%7 = bitcast %Int32 %5 to %Int32
	%8 = getelementptr [16 x %Word8], [16 x %Word8]* %6, %Int32 0, %Int32 %7
	%9 = load %Word8, %Word8* %8
	store %Word8 %9, %Word8* %b
	ret %Bool 1
}


