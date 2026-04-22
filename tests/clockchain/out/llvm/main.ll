
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
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports private 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports private 'main' --
; -- print imports public 'main' --
; -- end print imports public 'main' --
; -- strings --
; -- endstrings --
%CallbackData = type {
};

%ClockCallback = type void (%Clock*);
%Clock = type {
	%Clock*,
	%Nat32,
	%Bool,
	i8*,
	%ClockCallback*
};

@clockchain = internal global %Clock* zeroinitializer
define internal void @tickClock(%Clock* %self) {
; if_0
	%1 = getelementptr %Clock, %Clock* %self, %Int32 0, %Int32 1
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ugt %Nat32 %2, 0
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = getelementptr %Clock, %Clock* %self, %Int32 0, %Int32 1
	%5 = getelementptr %Clock, %Clock* %self, %Int32 0, %Int32 1
	%6 = load %Nat32, %Nat32* %5
	%7 = sub %Nat32 %6, 1
	store %Nat32 %7, %Nat32* %4
	%8 = getelementptr %Clock, %Clock* %self, %Int32 0, %Int32 2
	%9 = getelementptr %Clock, %Clock* %self, %Int32 0, %Int32 1
	%10 = load %Nat32, %Nat32* %9
	%11 = icmp eq %Nat32 %10, 0
	store %Bool %11, %Bool* %8
	br label %endif_0
endif_0:
	ret void
}

define internal void @taskClock(%Clock* %self) {
; if_0
	%1 = getelementptr %Clock, %Clock* %self, %Int32 0, %Int32 2
	%2 = load %Bool, %Bool* %1
	br %Bool %2 , label %then_0, label %endif_0
then_0:
; if_1
	%3 = getelementptr %Clock, %Clock* %self, %Int32 0, %Int32 4
	%4 = load %ClockCallback*, %ClockCallback** %3
	%5 = icmp ne %ClockCallback* %4, null
	br %Bool %5 , label %then_1, label %endif_1
then_1:
	%6 = getelementptr %Clock, %Clock* %self, %Int32 0, %Int32 4
	%7 = load %ClockCallback*, %ClockCallback** %6
	call void %7(%Clock* %self)
	br label %endif_1
endif_1:
	%8 = getelementptr %Clock, %Clock* %self, %Int32 0, %Int32 2
	%9 = getelementptr %Clock, %Clock* %self, %Int32 0, %Int32 1
	%10 = load %Nat32, %Nat32* %9
	%11 = icmp eq %Nat32 %10, 0
	store %Bool %11, %Bool* %8
	br label %endif_0
endif_0:
	ret void
}

define internal void @addClock(%Clock* %clock) {
; if_0
	%1 = load %Clock*, %Clock** @clockchain
	%2 = icmp eq %Clock* %1, null
	br %Bool %2 , label %then_0, label %else_0
then_0:
	store %Clock* %clock, %Clock** @clockchain
	br label %endif_0
else_0:
	%3 = alloca %Clock*, align 8
	%4 = load %Clock*, %Clock** @clockchain
	store %Clock* %4, %Clock** %3
; while_1
	br label %again_1
again_1:
	%5 = load %Clock*, %Clock** %3
	%6 = getelementptr %Clock, %Clock* %5, %Int32 0, %Int32 0
	%7 = load %Clock*, %Clock** %6
	%8 = icmp ne %Clock* %7, null
	br %Bool %8 , label %body_1, label %break_1
body_1:
	%9 = load %Clock*, %Clock** %3
	%10 = getelementptr %Clock, %Clock* %9, %Int32 0, %Int32 0
	%11 = load %Clock*, %Clock** %10
	store %Clock* %11, %Clock** %3
	br label %again_1
break_1:
	%12 = load %Clock*, %Clock** %3
	%13 = getelementptr %Clock, %Clock* %12, %Int32 0, %Int32 0
	store %Clock* %clock, %Clock** %13
	%14 = getelementptr %Clock, %Clock* %clock, %Int32 0, %Int32 0
	store %Clock* null, %Clock** %14
	br label %endif_0
endif_0:
	ret void
}

define internal void @foreachClockInChain(%Clock* %clockchain, void (%Clock*)* %handler) {
	%1 = alloca %Clock*, align 8
	store %Clock* %clockchain, %Clock** %1
; if_0
	%2 = load %Clock*, %Clock** %1
	%3 = icmp ne %Clock* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
; while_1
	br label %again_1
again_1:
	%4 = load %Clock*, %Clock** %1
	%5 = getelementptr %Clock, %Clock* %4, %Int32 0, %Int32 0
	%6 = load %Clock*, %Clock** %5
	%7 = icmp ne %Clock* %6, null
	br %Bool %7 , label %body_1, label %break_1
body_1:
	%8 = load %Clock*, %Clock** %1
	call void %handler(%Clock* %8)
	%9 = load %Clock*, %Clock** %1
	%10 = getelementptr %Clock, %Clock* %9, %Int32 0, %Int32 0
	%11 = load %Clock*, %Clock** %10
	store %Clock* %11, %Clock** %1
	br label %again_1
break_1:
	br label %endif_0
endif_0:
	ret void
}

define internal void @tickClockchain(%Clock* %clockchain) {
	call void @foreachClockInChain(%Clock* %clockchain, void (%Clock*)* @tickClock)
	ret void
}

define internal void @taskClockchain(%Clock* %clockchain) {
	call void @foreachClockInChain(%Clock* %clockchain, void (%Clock*)* @taskClock)
	ret void
}

define %Int @main() {
	%1 = alloca [3 x %Clock*], align 8
	%2 = getelementptr [3 x %Clock*], [3 x %Clock*]* %1, %Int32 0, %Int32 0
	%3 = call %Clock* @malloc(%Int32 32)
	store %Clock zeroinitializer, %Clock* %3
	store %Clock* %3, %Clock** %2
	%4 = getelementptr [3 x %Clock*], [3 x %Clock*]* %1, %Int32 0, %Int32 1
	%5 = call %Clock* @malloc(%Int32 32)
	store %Clock zeroinitializer, %Clock* %5
	store %Clock* %5, %Clock** %4
	%6 = getelementptr [3 x %Clock*], [3 x %Clock*]* %1, %Int32 0, %Int32 2
	%7 = call %Clock* @malloc(%Int32 32)
	store %Clock zeroinitializer, %Clock* %7
	store %Clock* %7, %Clock** %6
	%8 = getelementptr [3 x %Clock*], [3 x %Clock*]* %1, %Int32 0, %Int32 0
	%9 = load %Clock*, %Clock** %8
	call void @addClock(%Clock* %9)
	%10 = getelementptr [3 x %Clock*], [3 x %Clock*]* %1, %Int32 0, %Int32 1
	%11 = load %Clock*, %Clock** %10
	call void @addClock(%Clock* %11)
	%12 = getelementptr [3 x %Clock*], [3 x %Clock*]* %1, %Int32 0, %Int32 2
	%13 = load %Clock*, %Clock** %12
	call void @addClock(%Clock* %13)
	%14 = alloca %Nat32, align 4
	store %Nat32 10000, %Nat32* %14
; while_1
	br label %again_1
again_1:
	%15 = load %Nat32, %Nat32* %14
	%16 = icmp ugt %Nat32 %15, 0
	br %Bool %16 , label %body_1, label %break_1
body_1:
	%17 = load %Clock*, %Clock** @clockchain
	call void @tickClockchain(%Clock* %17)
; if_0
	%18 = load %Nat32, %Nat32* %14
	%19 = urem %Nat32 %18, 10
	%20 = icmp eq %Nat32 %19, 0
	br %Bool %20 , label %then_0, label %endif_0
then_0:
	%21 = load %Clock*, %Clock** @clockchain
	call void @taskClockchain(%Clock* %21)
	br label %endif_0
endif_0:
	%22 = load %Nat32, %Nat32* %14
	%23 = sub %Nat32 %22, 1
	store %Nat32 %23, %Nat32* %14
	br label %again_1
break_1:
	ret %Int 0
}


