
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

; MODULE: fsm

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
@str1 = private constant [12 x i8] [i8 102, i8 115, i8 109, i8 58, i8 58, i8 114, i8 117, i8 110, i8 40, i8 41, i8 10, i8 0]
@str2 = private constant [10 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 37, i8 115, i8 10, i8 0]
@str3 = private constant [9 x i8] [i8 101, i8 120, i8 105, i8 116, i8 32, i8 37, i8 115, i8 10, i8 0]
; -- endstrings --

; Вынужден добавлять export тк иначе не идет в хедер к структуре
; Короче, проблема зависимостей тяжело зависла в воздухе
%fsm_Handler = type void (%fsm_FSM*)*;
%fsm_StateDesc = type {
	[8 x %Char8],
	%fsm_Handler,
	%fsm_Handler,
	%fsm_Handler
};

%fsm_FSM = type {
	[8 x %Char8],
	%Int32,
	%Int32,
	%Int32,
	[16 x %fsm_StateDesc]
};

define %Str8* @fsm_state_no_name(%fsm_FSM* %fsm, %Int32 %state_no) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 4
	%2 = getelementptr [16 x %fsm_StateDesc], [16 x %fsm_StateDesc]* %1, %Int32 0, %Int32 %state_no
	%3 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %2, %Int32 0, %Int32 0
	%4 = bitcast [8 x %Char8]* %3 to %Str8*
	ret %Str8* %4
}

define void @fsm_switch(%fsm_FSM* %fsm, %Int32 %state) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 2
	store %Int32 %state, %Int32* %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	store %Int32 2, %Int32* %2
	ret void
}

define void @fsm_run(%fsm_FSM* %fsm) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*))
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	%3 = load %Int32, %Int32* %2
	%4 = icmp eq %Int32 %3, 0
	br %Bool %4 , label %then_0, label %else_0
then_0:
	%5 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 2
	%6 = load %Int32, %Int32* %5
	%7 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 4
	%8 = getelementptr [16 x %fsm_StateDesc], [16 x %fsm_StateDesc]* %7, %Int32 0, %Int32 %6
	br %Bool 1 , label %then_1, label %endif_1
then_1:
	%9 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %8, %Int32 0, %Int32 0
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str2 to [0 x i8]*), [8 x %Char8]* %9)
	br label %endif_1
endif_1:
	%11 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %8, %Int32 0, %Int32 1
	%12 = load %fsm_Handler, %fsm_Handler* %11
	%13 = icmp ne %fsm_Handler %12, null
	br %Bool %13 , label %then_2, label %endif_2
then_2:
	%14 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %8, %Int32 0, %Int32 1
	%15 = load %fsm_Handler, %fsm_Handler* %14
	call void %15(%fsm_FSM* %fsm)
	br label %endif_2
endif_2:
	%16 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1
	store %Int32 %6, %Int32* %16
	%17 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	store %Int32 1, %Int32* %17
	br label %endif_0
else_0:
	%18 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	%19 = load %Int32, %Int32* %18
	%20 = icmp eq %Int32 %19, 1
	br %Bool %20 , label %then_3, label %else_3
then_3:
	%21 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1
	%22 = load %Int32, %Int32* %21
	%23 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 4
	%24 = getelementptr [16 x %fsm_StateDesc], [16 x %fsm_StateDesc]* %23, %Int32 0, %Int32 %22
	%25 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %24, %Int32 0, %Int32 2
	%26 = load %fsm_Handler, %fsm_Handler* %25
	%27 = icmp ne %fsm_Handler %26, null
	br %Bool %27 , label %then_4, label %endif_4
then_4:
	%28 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %24, %Int32 0, %Int32 2
	%29 = load %fsm_Handler, %fsm_Handler* %28
	call void %29(%fsm_FSM* %fsm)
	br label %endif_4
endif_4:
	br label %endif_3
else_3:
	%30 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	%31 = load %Int32, %Int32* %30
	%32 = icmp eq %Int32 %31, 2
	br %Bool %32 , label %then_5, label %endif_5
then_5:
	%33 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1
	%34 = load %Int32, %Int32* %33
	%35 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 4
	%36 = getelementptr [16 x %fsm_StateDesc], [16 x %fsm_StateDesc]* %35, %Int32 0, %Int32 %34
	br %Bool 1 , label %then_6, label %endif_6
then_6:
	%37 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %36, %Int32 0, %Int32 0
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str3 to [0 x i8]*), [8 x %Char8]* %37)
	br label %endif_6
endif_6:
	%39 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %36, %Int32 0, %Int32 3
	%40 = load %fsm_Handler, %fsm_Handler* %39
	%41 = icmp ne %fsm_Handler %40, null
	br %Bool %41 , label %then_7, label %endif_7
then_7:
	%42 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %36, %Int32 0, %Int32 3
	%43 = load %fsm_Handler, %fsm_Handler* %42
	call void %43(%fsm_FSM* %fsm)
	br label %endif_7
endif_7:
	%44 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	store %Int32 0, %Int32* %44
	br label %endif_5
endif_5:
	br label %endif_3
endif_3:
	br label %endif_0
endif_0:
	ret void
}


