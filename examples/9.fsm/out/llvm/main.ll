
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
%Float16 = type half
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
%Float = type %Float32;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type %Int64;
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
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; from included assert
declare void @assert(%Bool %cond)

; from import "fsm"
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

declare void @fsm_init(%fsm_FSM* %self, %Str8* %id, %fsm_StateDesc* %initState, i8* %payload)
declare void @fsm_task(%fsm_FSM* %self)
declare void @fsm_tick(%fsm_FSM* %self)
declare %fsm_ComplexState @fsm_cmdSwitchState(%fsm_FSM* %self, %fsm_StateDesc* %state)
declare %fsm_ComplexState @fsm_cmdSwitchStage(%fsm_FSM* %self, %Word16 %stage)
declare %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* %self)
declare %fsm_ComplexState @fsm_cmdNextStageLimited(%fsm_FSM* %self, %Nat32 %t)
declare %fsm_ComplexState @fsm_getComplexState(%fsm_FSM %__fsm)
declare %fsm_StateDesc* @fsm_getState(%fsm_FSM %__fsm)
declare %fsm_StageId @fsm_getStage(%fsm_FSM %__fsm)
declare %Str8* @fsm_getStateName(%fsm_FSM* %fsm)

; end from import "fsm"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [7 x i8] [i8 115, i8 116, i8 97, i8 116, i8 101, i8 48, i8 0]
@.str2 = private constant [7 x i8] [i8 115, i8 116, i8 97, i8 116, i8 101, i8 49, i8 0]
@.str3 = private constant [7 x i8] [i8 115, i8 116, i8 97, i8 116, i8 101, i8 50, i8 0]
@.str4 = private constant [6 x i8] [i8 70, i8 83, i8 77, i8 95, i8 48, i8 0]
; -- endstrings --
@fsm0 = internal global %fsm_FSM zeroinitializer
@state0 = internal global %fsm_StateDesc {
	%Str8* bitcast ([7 x i8]* @.str1 to [0 x i8]*),
	%Nat16 4,
	%fsm_ComplexState (%fsm_ComplexState, i8*)* @routine0
}
@state1 = internal global %fsm_StateDesc {
	%Str8* bitcast ([7 x i8]* @.str2 to [0 x i8]*),
	%Nat16 4,
	%fsm_ComplexState (%fsm_ComplexState, i8*)* @routine1
}
@state2 = internal global %fsm_StateDesc {
	%Str8* bitcast ([7 x i8]* @.str3 to [0 x i8]*),
	%Nat16 4,
	%fsm_ComplexState (%fsm_ComplexState, i8*)* @routine2
}
define internal %fsm_ComplexState @routine0(%fsm_ComplexState %__state, i8* %payload) {
	%state = alloca %fsm_ComplexState
	store %fsm_ComplexState %__state, %fsm_ComplexState* %state
; if_0
	%1 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%2 = zext i8 0 to %fsm_StageId
	%3 = load %fsm_StageId, %fsm_StageId* %1
	%4 = icmp eq %fsm_StageId %3, %2
	br %Bool %4 , label %then_0, label %else_0
then_0:
	%5 = call %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* @fsm0)
	ret %fsm_ComplexState %5
	br label %endif_0
else_0:
; if_1
	%7 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%8 = zext i8 1 to %fsm_StageId
	%9 = load %fsm_StageId, %fsm_StageId* %7
	%10 = icmp eq %fsm_StageId %9, %8
	br %Bool %10 , label %then_1, label %else_1
then_1:
	%11 = call %fsm_ComplexState @fsm_cmdNextStageLimited(%fsm_FSM* @fsm0, %Nat32 2000)
	ret %fsm_ComplexState %11
	br label %endif_1
else_1:
; if_2
	%13 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%14 = zext i8 2 to %fsm_StageId
	%15 = load %fsm_StageId, %fsm_StageId* %13
	%16 = icmp eq %fsm_StageId %15, %14
	br %Bool %16 , label %then_2, label %else_2
then_2:
	br label %endif_2
else_2:
; if_3
	%17 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%18 = zext i8 3 to %fsm_StageId
	%19 = load %fsm_StageId, %fsm_StageId* %17
	%20 = icmp eq %fsm_StageId %19, %18
	br %Bool %20 , label %then_3, label %endif_3
then_3:
	%21 = call %fsm_ComplexState @fsm_cmdSwitchState(%fsm_FSM* @fsm0, %fsm_StateDesc* @state1)
	ret %fsm_ComplexState %21
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	%23 = load %fsm_ComplexState, %fsm_ComplexState* %state
	ret %fsm_ComplexState %23
}

define internal %fsm_ComplexState @routine1(%fsm_ComplexState %__state, i8* %payload) {
	%state = alloca %fsm_ComplexState
	store %fsm_ComplexState %__state, %fsm_ComplexState* %state
; if_0
	%1 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%2 = zext i8 0 to %fsm_StageId
	%3 = load %fsm_StageId, %fsm_StageId* %1
	%4 = icmp eq %fsm_StageId %3, %2
	br %Bool %4 , label %then_0, label %else_0
then_0:
	%5 = call %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* @fsm0)
	ret %fsm_ComplexState %5
	br label %endif_0
else_0:
; if_1
	%7 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%8 = zext i8 1 to %fsm_StageId
	%9 = load %fsm_StageId, %fsm_StageId* %7
	%10 = icmp eq %fsm_StageId %9, %8
	br %Bool %10 , label %then_1, label %else_1
then_1:
	%11 = call %fsm_ComplexState @fsm_cmdNextStageLimited(%fsm_FSM* @fsm0, %Nat32 2000)
	ret %fsm_ComplexState %11
	br label %endif_1
else_1:
; if_2
	%13 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%14 = zext i8 2 to %fsm_StageId
	%15 = load %fsm_StageId, %fsm_StageId* %13
	%16 = icmp eq %fsm_StageId %15, %14
	br %Bool %16 , label %then_2, label %else_2
then_2:
	br label %endif_2
else_2:
; if_3
	%17 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%18 = zext i8 3 to %fsm_StageId
	%19 = load %fsm_StageId, %fsm_StageId* %17
	%20 = icmp eq %fsm_StageId %19, %18
	br %Bool %20 , label %then_3, label %endif_3
then_3:
	%21 = call %fsm_ComplexState @fsm_cmdSwitchState(%fsm_FSM* @fsm0, %fsm_StateDesc* @state2)
	ret %fsm_ComplexState %21
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	%23 = load %fsm_ComplexState, %fsm_ComplexState* %state
	ret %fsm_ComplexState %23
}

define internal %fsm_ComplexState @routine2(%fsm_ComplexState %__state, i8* %payload) {
	%state = alloca %fsm_ComplexState
	store %fsm_ComplexState %__state, %fsm_ComplexState* %state
; if_0
	%1 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%2 = zext i8 0 to %fsm_StageId
	%3 = load %fsm_StageId, %fsm_StageId* %1
	%4 = icmp eq %fsm_StageId %3, %2
	br %Bool %4 , label %then_0, label %else_0
then_0:
	%5 = call %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* @fsm0)
	ret %fsm_ComplexState %5
	br label %endif_0
else_0:
; if_1
	%7 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%8 = zext i8 1 to %fsm_StageId
	%9 = load %fsm_StageId, %fsm_StageId* %7
	%10 = icmp eq %fsm_StageId %9, %8
	br %Bool %10 , label %then_1, label %else_1
then_1:
	%11 = call %fsm_ComplexState @fsm_cmdNextStageLimited(%fsm_FSM* @fsm0, %Nat32 2000)
	ret %fsm_ComplexState %11
	br label %endif_1
else_1:
; if_2
	%13 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%14 = zext i8 2 to %fsm_StageId
	%15 = load %fsm_StageId, %fsm_StageId* %13
	%16 = icmp eq %fsm_StageId %15, %14
	br %Bool %16 , label %then_2, label %else_2
then_2:
	br label %endif_2
else_2:
; if_3
	%17 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%18 = zext i8 3 to %fsm_StageId
	%19 = load %fsm_StageId, %fsm_StageId* %17
	%20 = icmp eq %fsm_StageId %19, %18
	br %Bool %20 , label %then_3, label %endif_3
then_3:
	%21 = call %fsm_ComplexState @fsm_cmdSwitchState(%fsm_FSM* @fsm0, %fsm_StateDesc* @state0)
	ret %fsm_ComplexState %21
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	%23 = load %fsm_ComplexState, %fsm_ComplexState* %state
	ret %fsm_ComplexState %23
}

@timecnt = internal global %Nat32 zeroinitializer
define %Int @main() {
	call void @fsm_init(%fsm_FSM* @fsm0, %Str8* bitcast ([6 x i8]* @.str4 to [0 x i8]*), %fsm_StateDesc* @state0, i8* null)
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
; if_0
	%1 = load %Nat32, %Nat32* @timecnt
	%2 = icmp ugt %Nat32 %1, 55555
	br %Bool %2 , label %then_0, label %else_0
then_0:
	store %Nat32 0, %Nat32* @timecnt
	call void @fsm_tick(%fsm_FSM* @fsm0)
	br label %endif_0
else_0:
	%3 = load %Nat32, %Nat32* @timecnt
	%4 = add %Nat32 %3, 1
	store %Nat32 %4, %Nat32* @timecnt
	br label %endif_0
endif_0:
	call void @fsm_task(%fsm_FSM* @fsm0)
	br label %again_1
break_1:
	ret %Int 0
}


