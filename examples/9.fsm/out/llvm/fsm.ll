
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
; from included assert
declare void @assert(%Bool %cond)
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
@str1 = private constant [52 x i8] [i8 91, i8 37, i8 115, i8 93, i8 32, i8 102, i8 115, i8 109, i8 32, i8 116, i8 105, i8 109, i8 101, i8 111, i8 117, i8 116, i8 32, i8 40, i8 37, i8 117, i8 41, i8 32, i8 111, i8 99, i8 99, i8 117, i8 114, i8 101, i8 100, i8 44, i8 32, i8 115, i8 119, i8 105, i8 116, i8 99, i8 104, i8 95, i8 116, i8 111, i8 95, i8 115, i8 116, i8 97, i8 103, i8 101, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]
@str2 = private constant [23 x i8] [i8 91, i8 37, i8 115, i8 93, i8 32, i8 35, i8 37, i8 115, i8 95, i8 37, i8 117, i8 32, i8 45, i8 62, i8 32, i8 35, i8 37, i8 115, i8 95, i8 37, i8 117, i8 10, i8 0]
@str3 = private constant [7 x i8] [i8 60, i8 110, i8 117, i8 108, i8 108, i8 62, i8 0]
; -- endstrings --
%fsm_StageId = type %Word16;
%fsm_ComplexState = type {
	%fsm_StateDesc*,
	%fsm_StageId
};

%fsm_StateServiceRoutine = type %fsm_ComplexState (%fsm_ComplexState, i8*);
%fsm_StateDesc = type {
	%Str8*,
	%Nat16,
	%fsm_StateServiceRoutine*
};

%fsm_FSM = type {
	%Str8*,
	%fsm_ComplexState,
	%fsm_ComplexState,
	i8*,
	%Nat32,
	%Bool
};

define void @fsm_init(%fsm_FSM* %self, %Str8* %id, %fsm_StateDesc* %initState, i8* %payload) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 0
	store %Str8* %id, %Str8** %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%3 = insertvalue %fsm_ComplexState zeroinitializer, %fsm_StateDesc* %initState, 0
	store %fsm_ComplexState %3, %fsm_ComplexState* %2
	%4 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%5 = insertvalue %fsm_ComplexState zeroinitializer, %fsm_StateDesc* %initState, 0
	store %fsm_ComplexState %5, %fsm_ComplexState* %4
	%6 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 3
	store i8* %payload, i8** %6
	%7 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	store %Nat32 0, %Nat32* %7
	%8 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 0, %Bool* %8
	ret void
}

define void @fsm_task(%fsm_FSM* %self) {
	; Сработал таймер-ограничитель времени нахождения в стадии?
; if_0
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	%2 = load %Bool, %Bool* %1
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	; Clear timer & Switch to next stage
	%3 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 0, %Bool* %3
	%4 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%5 = call %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* %self)
	store %fsm_ComplexState %5, %fsm_ComplexState* %4
	%6 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 0
	%7 = load %Str8*, %Str8** %6
	%8 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2, %Int32 1
	%9 = load %fsm_StageId, %fsm_StageId* %8
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([52 x i8]* @str1 to [0 x i8]*), %Str8* %7, %Nat32 0, %fsm_StageId %9)
	br label %endif_0
endif_0:

	; Есть запрос на смену состояния?
; if_1
	%11 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%12 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%13 = bitcast %fsm_ComplexState* %11 to i8*
	%14 = bitcast %fsm_ComplexState* %12 to i8*
	%15 = call i1 (i8*, i8*, i64) @memeq(i8* %13, i8* %14, %Int64 16)
	%16 = icmp eq %Bool %15, 0
	br %Bool %16 , label %then_1, label %endif_1
then_1:
	%17 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%18 = load %fsm_ComplexState, %fsm_ComplexState* %17
	%19 = alloca %fsm_ComplexState
	store %fsm_ComplexState %18, %fsm_ComplexState* %19
	%20 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%21 = load %fsm_ComplexState, %fsm_ComplexState* %20
	%22 = alloca %fsm_ComplexState
	store %fsm_ComplexState %21, %fsm_ComplexState* %22
	%23 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 0
	%24 = load %Str8*, %Str8** %23
	%25 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %19, %Int32 0, %Int32 0
	%26 = load %fsm_StateDesc*, %fsm_StateDesc** %25
	%27 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %26, %Int32 0, %Int32 0
	%28 = load %Str8*, %Str8** %27
	%29 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %19, %Int32 0, %Int32 1
	%30 = load %fsm_StageId, %fsm_StageId* %29
	%31 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %22, %Int32 0, %Int32 0
	%32 = load %fsm_StateDesc*, %fsm_StateDesc** %31
	%33 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %32, %Int32 0, %Int32 0
	%34 = load %Str8*, %Str8** %33
	%35 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %22, %Int32 0, %Int32 1
	%36 = load %fsm_StageId, %fsm_StageId* %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str2 to [0 x i8]*), %Str8* %24, %Str8* %28, %fsm_StageId %30, %Str8* %34, %fsm_StageId %36)
	%38 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%39 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%40 = load %fsm_ComplexState, %fsm_ComplexState* %39
	store %fsm_ComplexState %40, %fsm_ComplexState* %38
	br label %endif_1
endif_1:

	; Usual routine
	%41 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1, %Int32 0
	%42 = load %fsm_StateDesc*, %fsm_StateDesc** %41
	%43 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %42, %Int32 0, %Int32 2
	%44 = load %fsm_StateServiceRoutine*, %fsm_StateServiceRoutine** %43
	%45 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%46 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%47 = load %fsm_ComplexState, %fsm_ComplexState* %46
	%48 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 3
	%49 = load i8*, i8** %48
	%50 = call %fsm_ComplexState %44(%fsm_ComplexState %47, i8* %49)
	store %fsm_ComplexState %50, %fsm_ComplexState* %45
	ret void
}

define void @fsm_tick(%fsm_FSM* %self) {
; if_0
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ugt %Nat32 %2, 0
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	%5 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	%6 = load %Nat32, %Nat32* %5
	%7 = sub %Nat32 %6, 1
	store %Nat32 %7, %Nat32* %4
; if_1
	%8 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	%9 = load %Nat32, %Nat32* %8
	%10 = icmp eq %Nat32 %9, 0
	br %Bool %10 , label %then_1, label %endif_1
then_1:
	%11 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 1, %Bool* %11
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define %fsm_ComplexState @fsm_cmdSwitchState(%fsm_FSM* %self, %fsm_StateDesc* %state) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	store %Nat32 0, %Nat32* %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 0, %Bool* %2
	%3 = insertvalue %fsm_ComplexState zeroinitializer, %fsm_StateDesc* %state, 0
	ret %fsm_ComplexState %3
}

define %fsm_ComplexState @fsm_cmdSwitchStage(%fsm_FSM* %self, %Word16 %stage) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	store %Nat32 0, %Nat32* %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 0, %Bool* %2
	%3 = alloca %fsm_ComplexState, align 16
	%4 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
; -- cons_composite_from_composite_by_adr --
	%5 = bitcast %fsm_ComplexState* %4 to %fsm_ComplexState*
	%6 = load %fsm_ComplexState, %fsm_ComplexState* %5
; -- end cons_composite_from_composite_by_adr --
	store %fsm_ComplexState %6, %fsm_ComplexState* %3
	%7 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %3, %Int32 0, %Int32 1
	%8 = bitcast %Word16 %stage to %fsm_StageId
	store %fsm_StageId %8, %fsm_StageId* %7
; -- cons_composite_from_composite_by_adr --
	%9 = bitcast %fsm_ComplexState* %3 to %fsm_ComplexState*
	%10 = load %fsm_ComplexState, %fsm_ComplexState* %9
; -- end cons_composite_from_composite_by_adr --
	ret %fsm_ComplexState %10
}

define %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* %self) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	store %Nat32 0, %Nat32* %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 0, %Bool* %2
	%3 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
; -- cons_composite_from_composite_by_adr --
	%4 = bitcast %fsm_ComplexState* %3 to %fsm_ComplexState*
	%5 = load %fsm_ComplexState, %fsm_ComplexState* %4
; -- end cons_composite_from_composite_by_adr --
	%6 = alloca %fsm_ComplexState
	store %fsm_ComplexState %5, %fsm_ComplexState* %6
	%7 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %6, %Int32 0, %Int32 1
	%8 = load %fsm_StageId, %fsm_StageId* %7
	%9 = bitcast %fsm_StageId %8 to %Nat16
	%10 = add %Nat16 %9, 1
	;assert(nextStageIndex < state.state.nstages)
	%11 = alloca %fsm_ComplexState, align 16
; -- cons_composite_from_composite_by_adr --
	%12 = bitcast %fsm_ComplexState* %6 to %fsm_ComplexState*
	%13 = load %fsm_ComplexState, %fsm_ComplexState* %12
; -- end cons_composite_from_composite_by_adr --
	store %fsm_ComplexState %13, %fsm_ComplexState* %11
	%14 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %11, %Int32 0, %Int32 1
	%15 = bitcast %Nat16 %10 to %fsm_StageId
	store %fsm_StageId %15, %fsm_StageId* %14
; -- cons_composite_from_composite_by_adr --
	%16 = bitcast %fsm_ComplexState* %11 to %fsm_ComplexState*
	%17 = load %fsm_ComplexState, %fsm_ComplexState* %16
; -- end cons_composite_from_composite_by_adr --
	ret %fsm_ComplexState %17
}

define %fsm_ComplexState @fsm_cmdNextStageLimited(%fsm_FSM* %self, %Nat32 %t) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	store %Nat32 %t, %Nat32* %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
; -- cons_composite_from_composite_by_adr --
	%3 = bitcast %fsm_ComplexState* %2 to %fsm_ComplexState*
	%4 = load %fsm_ComplexState, %fsm_ComplexState* %3
; -- end cons_composite_from_composite_by_adr --
	%5 = alloca %fsm_ComplexState
	store %fsm_ComplexState %4, %fsm_ComplexState* %5
	%6 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %5, %Int32 0, %Int32 1
	%7 = load %fsm_StageId, %fsm_StageId* %6
	%8 = bitcast %fsm_StageId %7 to %Nat16
	%9 = add %Nat16 %8, 1
	;assert(nextStageIndex < state.state.nstages)
	%10 = alloca %fsm_ComplexState, align 16
; -- cons_composite_from_composite_by_adr --
	%11 = bitcast %fsm_ComplexState* %5 to %fsm_ComplexState*
	%12 = load %fsm_ComplexState, %fsm_ComplexState* %11
; -- end cons_composite_from_composite_by_adr --
	store %fsm_ComplexState %12, %fsm_ComplexState* %10
	%13 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %10, %Int32 0, %Int32 1
	%14 = bitcast %Nat16 %9 to %fsm_StageId
	store %fsm_StageId %14, %fsm_StageId* %13
; -- cons_composite_from_composite_by_adr --
	%15 = bitcast %fsm_ComplexState* %10 to %fsm_ComplexState*
	%16 = load %fsm_ComplexState, %fsm_ComplexState* %15
; -- end cons_composite_from_composite_by_adr --
	ret %fsm_ComplexState %16
}

define %fsm_ComplexState @fsm_getComplexState(%fsm_FSM %fsm) {
	%1 = extractvalue %fsm_FSM %fsm, 1
	ret %fsm_ComplexState %1
}

define %fsm_StateDesc* @fsm_getState(%fsm_FSM %fsm) {
	%1 = extractvalue %fsm_FSM %fsm, 1, 0
	ret %fsm_StateDesc* %1
}

define %fsm_StageId @fsm_getStage(%fsm_FSM %fsm) {
	%1 = extractvalue %fsm_FSM %fsm, 1, 1
	ret %fsm_StageId %1
}

define %Str8* @fsm_getStateName(%fsm_FSM* %fsm) {
; if_0
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1, %Int32 0
	%2 = load %fsm_StateDesc*, %fsm_StateDesc** %1
	%3 = icmp eq %fsm_StateDesc* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %Str8* bitcast ([7 x i8]* @str3 to [0 x i8]*)
	br label %endif_0
endif_0:
	%5 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1, %Int32 0
	%6 = load %fsm_StateDesc*, %fsm_StateDesc** %5
	%7 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %6, %Int32 0, %Int32 0
	%8 = load %Str8*, %Str8** %7
	ret %Str8* %8
}


