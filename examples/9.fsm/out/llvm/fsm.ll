
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
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

; MODULE: fsm

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
; -- print imports 'fsm' --
; -- 0
; -- end print imports 'fsm' --
; -- strings --
@str1 = private constant [12 x i8] [i8 102, i8 115, i8 109, i8 58, i8 58, i8 114, i8 117, i8 110, i8 40, i8 41, i8 10, i8 0]
@str2 = private constant [10 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 37, i8 115, i8 10, i8 0]
@str3 = private constant [9 x i8] [i8 101, i8 120, i8 105, i8 116, i8 32, i8 37, i8 115, i8 10, i8 0]
; -- endstrings --
%fsm_Handler = type void (%fsm_FSM*);
%fsm_StateDesc = type {
	[8 x %Char8],
	%fsm_Handler*,
	%fsm_Handler*,
	%fsm_Handler*
};

%fsm_States = type [16 x %fsm_StateDesc];
%fsm_FSM = type {
	[8 x %Char8],
	%Nat32,
	%Nat32,
	%Nat32,
	%fsm_States
};

define %Str8* @fsm_state_no_name(%fsm_FSM* %fsm, %Nat32 %state_no) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 4
	%2 = bitcast %Nat32 %state_no to %Nat32
	%3 = getelementptr %fsm_States, %fsm_States* %1, %Int32 0, %Nat32 %2
	%4 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %3, %Int32 0, %Int32 0
	%5 = bitcast [8 x %Char8]* %4 to %Str8*
	ret %Str8* %5
}

define void @fsm_switch(%fsm_FSM* %fsm, %Nat32 %state) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 2
	store %Nat32 %state, %Nat32* %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	store %Nat32 2, %Nat32* %2
	ret void
}

define void @fsm_run(%fsm_FSM* %fsm) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*))
; if_0
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	%3 = load %Nat32, %Nat32* %2
	%4 = icmp eq %Nat32 %3, 0
	br %Bool %4 , label %then_0, label %else_0
then_0:
	%5 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 2
	%6 = load %Nat32, %Nat32* %5
	%7 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 4
	%8 = bitcast %Nat32 %6 to %Nat32
	%9 = getelementptr %fsm_States, %fsm_States* %7, %Int32 0, %Nat32 %8
; if_1
	br %Bool 1 , label %then_1, label %endif_1
then_1:
	%10 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %9, %Int32 0, %Int32 0
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str2 to [0 x i8]*), [8 x %Char8]* %10)
	br label %endif_1
endif_1:
; if_2
	%12 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %9, %Int32 0, %Int32 1
	%13 = load %fsm_Handler*, %fsm_Handler** %12
	%14 = icmp ne %fsm_Handler* %13, null
	br %Bool %14 , label %then_2, label %endif_2
then_2:
	%15 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %9, %Int32 0, %Int32 1
	%16 = load %fsm_Handler*, %fsm_Handler** %15
	call void %16(%fsm_FSM* %fsm)
	br label %endif_2
endif_2:
	%17 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1
	store %Nat32 %6, %Nat32* %17
	%18 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	store %Nat32 1, %Nat32* %18
	br label %endif_0
else_0:
; if_3
	%19 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	%20 = load %Nat32, %Nat32* %19
	%21 = icmp eq %Nat32 %20, 1
	br %Bool %21 , label %then_3, label %else_3
then_3:
	%22 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1
	%23 = load %Nat32, %Nat32* %22
	%24 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 4
	%25 = bitcast %Nat32 %23 to %Nat32
	%26 = getelementptr %fsm_States, %fsm_States* %24, %Int32 0, %Nat32 %25
; if_4
	%27 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %26, %Int32 0, %Int32 2
	%28 = load %fsm_Handler*, %fsm_Handler** %27
	%29 = icmp ne %fsm_Handler* %28, null
	br %Bool %29 , label %then_4, label %endif_4
then_4:
	%30 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %26, %Int32 0, %Int32 2
	%31 = load %fsm_Handler*, %fsm_Handler** %30
	call void %31(%fsm_FSM* %fsm)
	br label %endif_4
endif_4:
	br label %endif_3
else_3:
; if_5
	%32 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	%33 = load %Nat32, %Nat32* %32
	%34 = icmp eq %Nat32 %33, 2
	br %Bool %34 , label %then_5, label %endif_5
then_5:
	%35 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1
	%36 = load %Nat32, %Nat32* %35
	%37 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 4
	%38 = bitcast %Nat32 %36 to %Nat32
	%39 = getelementptr %fsm_States, %fsm_States* %37, %Int32 0, %Nat32 %38
; if_6
	br %Bool 1 , label %then_6, label %endif_6
then_6:
	%40 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %39, %Int32 0, %Int32 0
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str3 to [0 x i8]*), [8 x %Char8]* %40)
	br label %endif_6
endif_6:
; if_7
	%42 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %39, %Int32 0, %Int32 3
	%43 = load %fsm_Handler*, %fsm_Handler** %42
	%44 = icmp ne %fsm_Handler* %43, null
	br %Bool %44 , label %then_7, label %endif_7
then_7:
	%45 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %39, %Int32 0, %Int32 3
	%46 = load %fsm_Handler*, %fsm_Handler** %45
	call void %46(%fsm_FSM* %fsm)
	br label %endif_7
endif_7:
	%47 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 3
	store %Nat32 0, %Nat32* %47
	br label %endif_5
endif_5:
	br label %endif_3
endif_3:
	br label %endif_0
endif_0:
	ret void
}


