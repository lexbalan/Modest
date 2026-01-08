
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
; -- 1
; from included assert
declare void @assert(%Bool %cond)

; from import "fsm"
%fsm_StateServiceRoutine = type %fsm_ComplexState (%fsm_ComplexState, i8*);
%fsm_StateDesc = type {
	%Str8*,
	%Nat16,
	%fsm_StateServiceRoutine*
};

%fsm_StageId = type %Word16;
%fsm_ComplexState = type {
	%fsm_StateDesc*,
	%fsm_StageId
};

%fsm_FSM = type {
	%Str8*,
	%fsm_StateServiceRoutine*,
	%fsm_StateServiceRoutine*,
	%fsm_ComplexState,
	%fsm_ComplexState,
	i8*,
	%Nat32,
	%Nat32,
	%Bool
};

declare void @fsm_init(%fsm_FSM* %self, %Str8* %id, %fsm_StateDesc* %initState, i8* %payload)
declare void @fsm_task(%fsm_FSM* %self)
declare void @fsm_task_1ms(%fsm_FSM* %self)
declare %fsm_ComplexState @fsm_cmdSwitchState(%fsm_FSM* %self, %fsm_StateDesc* %state)
declare %fsm_ComplexState @fsm_cmdSwitchStage(%fsm_FSM* %self, %Word16 %stage)
declare %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* %self)
declare %fsm_ComplexState @fsm_cmdNextStageLimited(%fsm_FSM* %self, %Nat32 %t)
declare %fsm_ComplexState @fsm_cmdPrevStage(%fsm_FSM* %self)
declare %fsm_ComplexState @fsm_getComplexState(%fsm_FSM %fsm)
declare %fsm_StateDesc* @fsm_getState(%fsm_FSM %fsm)
declare %fsm_StageId @fsm_getStage(%fsm_FSM %fsm)
declare void @fsm_setAnyPre(%fsm_FSM* %self, %fsm_StateServiceRoutine* %anyPre)
declare void @fsm_setAnyPost(%fsm_FSM* %self, %fsm_StateServiceRoutine* %anyPost)
declare %Str8* @fsm_getCurrentStateName(%fsm_FSM* %fsm)

; end from import "fsm"
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [7 x i8] [i8 115, i8 116, i8 97, i8 116, i8 101, i8 48, i8 0]
@str2 = private constant [7 x i8] [i8 115, i8 116, i8 97, i8 116, i8 101, i8 49, i8 0]
@str3 = private constant [7 x i8] [i8 115, i8 116, i8 97, i8 116, i8 101, i8 50, i8 0]
@str4 = private constant [6 x i8] [i8 70, i8 83, i8 77, i8 95, i8 48, i8 0]
; -- endstrings --
@fsm0 = internal global %fsm_FSM zeroinitializer
@state0 = internal global %fsm_StateDesc {
	%Str8* bitcast ([7 x i8]* @str1 to [0 x i8]*),
	%Nat16 4,
	%fsm_ComplexState (%fsm_ComplexState, i8*)* @routine0
}
@state1 = internal global %fsm_StateDesc {
	%Str8* bitcast ([7 x i8]* @str2 to [0 x i8]*),
	%Nat16 4,
	%fsm_ComplexState (%fsm_ComplexState, i8*)* @routine1
}
@state2 = internal global %fsm_StateDesc {
	%Str8* bitcast ([7 x i8]* @str3 to [0 x i8]*),
	%Nat16 4,
	%fsm_ComplexState (%fsm_ComplexState, i8*)* @routine2
}
define internal %fsm_ComplexState @routine0(%fsm_ComplexState %state, i8* %payload) {
; if_0
	%1 = extractvalue %fsm_ComplexState %state, 1
	%2 = zext i8 0 to %fsm_StageId
	%3 = icmp eq %fsm_StageId %1, %2
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = call %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* @fsm0)
	ret %fsm_ComplexState %4
	br label %endif_0
else_0:
; if_1
	%6 = extractvalue %fsm_ComplexState %state, 1
	%7 = zext i8 1 to %fsm_StageId
	%8 = icmp eq %fsm_StageId %6, %7
	br %Bool %8 , label %then_1, label %else_1
then_1:
	%9 = call %fsm_ComplexState @fsm_cmdNextStageLimited(%fsm_FSM* @fsm0, %Nat32 2000)
	ret %fsm_ComplexState %9
	br label %endif_1
else_1:
; if_2
	%11 = extractvalue %fsm_ComplexState %state, 1
	%12 = zext i8 2 to %fsm_StageId
	%13 = icmp eq %fsm_StageId %11, %12
	br %Bool %13 , label %then_2, label %else_2
then_2:
	; just stay
	br label %endif_2
else_2:
; if_3
	%14 = extractvalue %fsm_ComplexState %state, 1
	%15 = zext i8 3 to %fsm_StageId
	%16 = icmp eq %fsm_StageId %14, %15
	br %Bool %16 , label %then_3, label %endif_3
then_3:
	%17 = bitcast %fsm_StateDesc* @state1 to %fsm_StateDesc*
	%18 = call %fsm_ComplexState @fsm_cmdSwitchState(%fsm_FSM* @fsm0, %fsm_StateDesc* %17)
	ret %fsm_ComplexState %18
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret %fsm_ComplexState %state
}

define internal %fsm_ComplexState @routine1(%fsm_ComplexState %state, i8* %payload) {
; if_0
	%1 = extractvalue %fsm_ComplexState %state, 1
	%2 = zext i8 0 to %fsm_StageId
	%3 = icmp eq %fsm_StageId %1, %2
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = call %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* @fsm0)
	ret %fsm_ComplexState %4
	br label %endif_0
else_0:
; if_1
	%6 = extractvalue %fsm_ComplexState %state, 1
	%7 = zext i8 1 to %fsm_StageId
	%8 = icmp eq %fsm_StageId %6, %7
	br %Bool %8 , label %then_1, label %else_1
then_1:
	%9 = call %fsm_ComplexState @fsm_cmdNextStageLimited(%fsm_FSM* @fsm0, %Nat32 2000)
	ret %fsm_ComplexState %9
	br label %endif_1
else_1:
; if_2
	%11 = extractvalue %fsm_ComplexState %state, 1
	%12 = zext i8 2 to %fsm_StageId
	%13 = icmp eq %fsm_StageId %11, %12
	br %Bool %13 , label %then_2, label %else_2
then_2:
	; just stay
	br label %endif_2
else_2:
; if_3
	%14 = extractvalue %fsm_ComplexState %state, 1
	%15 = zext i8 3 to %fsm_StageId
	%16 = icmp eq %fsm_StageId %14, %15
	br %Bool %16 , label %then_3, label %endif_3
then_3:
	%17 = bitcast %fsm_StateDesc* @state2 to %fsm_StateDesc*
	%18 = call %fsm_ComplexState @fsm_cmdSwitchState(%fsm_FSM* @fsm0, %fsm_StateDesc* %17)
	ret %fsm_ComplexState %18
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret %fsm_ComplexState %state
}

define internal %fsm_ComplexState @routine2(%fsm_ComplexState %state, i8* %payload) {
; if_0
	%1 = extractvalue %fsm_ComplexState %state, 1
	%2 = zext i8 0 to %fsm_StageId
	%3 = icmp eq %fsm_StageId %1, %2
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = call %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* @fsm0)
	ret %fsm_ComplexState %4
	br label %endif_0
else_0:
; if_1
	%6 = extractvalue %fsm_ComplexState %state, 1
	%7 = zext i8 1 to %fsm_StageId
	%8 = icmp eq %fsm_StageId %6, %7
	br %Bool %8 , label %then_1, label %else_1
then_1:
	%9 = call %fsm_ComplexState @fsm_cmdNextStageLimited(%fsm_FSM* @fsm0, %Nat32 2000)
	ret %fsm_ComplexState %9
	br label %endif_1
else_1:
; if_2
	%11 = extractvalue %fsm_ComplexState %state, 1
	%12 = zext i8 2 to %fsm_StageId
	%13 = icmp eq %fsm_StageId %11, %12
	br %Bool %13 , label %then_2, label %else_2
then_2:
	; just stay
	br label %endif_2
else_2:
; if_3
	%14 = extractvalue %fsm_ComplexState %state, 1
	%15 = zext i8 3 to %fsm_StageId
	%16 = icmp eq %fsm_StageId %14, %15
	br %Bool %16 , label %then_3, label %endif_3
then_3:
	%17 = bitcast %fsm_StateDesc* @state0 to %fsm_StateDesc*
	%18 = call %fsm_ComplexState @fsm_cmdSwitchState(%fsm_FSM* @fsm0, %fsm_StateDesc* %17)
	ret %fsm_ComplexState %18
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret %fsm_ComplexState %state
}

@timecnt = internal global %Nat32 zeroinitializer
define %Int @main() {
	%1 = bitcast %fsm_StateDesc* @state0 to %fsm_StateDesc*
	call void @fsm_init(%fsm_FSM* @fsm0, %Str8* bitcast ([6 x i8]* @str4 to [0 x i8]*), %fsm_StateDesc* %1, i8* null)
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
; if_0
	%2 = load %Nat32, %Nat32* @timecnt
	%3 = icmp ugt %Nat32 %2, 55555
	br %Bool %3 , label %then_0, label %else_0
then_0:
	store %Nat32 0, %Nat32* @timecnt
	call void @fsm_task_1ms(%fsm_FSM* @fsm0)
	br label %endif_0
else_0:
	%4 = load %Nat32, %Nat32* @timecnt
	%5 = add %Nat32 %4, 1
	store %Nat32 %5, %Nat32* @timecnt
	br label %endif_0
endif_0:
	call void @fsm_task(%fsm_FSM* @fsm0)
	br label %again_1
break_1:
	ret %Int 0
}


