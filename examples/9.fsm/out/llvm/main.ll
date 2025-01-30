
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

; MODULE: main

; -- print includes --
; from included ctypes64
%ctypes64_Str = type %Str8;
%ctypes64_Char = type %Char8;
%ctypes64_ConstChar = type %ctypes64_Char;
%ctypes64_SignedChar = type %Int8;
%ctypes64_UnsignedChar = type %Int8;
%ctypes64_Short = type %Int16;
%ctypes64_UnsignedShort = type %Int16;
%ctypes64_Int = type %Int32;
%ctypes64_UnsignedInt = type %Int32;
%ctypes64_LongInt = type %Int64;
%ctypes64_UnsignedLongInt = type %Int64;
%ctypes64_Long = type %Int64;
%ctypes64_UnsignedLong = type %Int64;
%ctypes64_LongLong = type %Int64;
%ctypes64_UnsignedLongLong = type %Int64;
%ctypes64_LongLongInt = type %Int64;
%ctypes64_UnsignedLongLongInt = type %Int64;
%ctypes64_Float = type double;
%ctypes64_Double = type double;
%ctypes64_LongDouble = type double;
%ctypes64_SizeT = type %ctypes64_UnsignedLongInt;
%ctypes64_SSizeT = type %ctypes64_LongInt;
%ctypes64_IntPtrT = type %Int64;
%ctypes64_PtrDiffT = type i8*;
%ctypes64_OffT = type %Int64;
%ctypes64_USecondsT = type %Int32;
%ctypes64_PIDT = type %Int32;
%ctypes64_UIDT = type %Int32;
%ctypes64_GIDT = type %Int32;
; from included stdio
%stdio_File = type %Int8;
%stdio_FposT = type %Int8;
%stdio_CharStr = type %ctypes64_Str;
%stdio_ConstCharStr = type %stdio_CharStr;
declare %ctypes64_Int @fclose(%stdio_File* %f)
declare %ctypes64_Int @feof(%stdio_File* %f)
declare %ctypes64_Int @ferror(%stdio_File* %f)
declare %ctypes64_Int @fflush(%stdio_File* %f)
declare %ctypes64_Int @fgetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %stdio_File* @fopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode)
declare %ctypes64_SizeT @fread(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %ctypes64_SizeT @fwrite(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %stdio_File* @freopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode, %stdio_File* %f)
declare %ctypes64_Int @fseek(%stdio_File* %f, %ctypes64_LongInt %offset, %ctypes64_Int %whence)
declare %ctypes64_Int @fsetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %ctypes64_LongInt @ftell(%stdio_File* %f)
declare %ctypes64_Int @remove(%stdio_ConstCharStr* %fname)
declare %ctypes64_Int @rename(%stdio_ConstCharStr* %old_filename, %stdio_ConstCharStr* %new_filename)
declare void @rewind(%stdio_File* %f)
declare void @setbuf(%stdio_File* %f, %stdio_CharStr* %buf)
declare %ctypes64_Int @setvbuf(%stdio_File* %f, %stdio_CharStr* %buf, %ctypes64_Int %mode, %ctypes64_SizeT %size)
declare %stdio_File* @tmpfile()
declare %stdio_CharStr* @tmpnam(%stdio_CharStr* %str)
declare %ctypes64_Int @printf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @scanf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @fprintf(%stdio_File* %f, %ctypes64_Str* %format, ...)
declare %ctypes64_Int @fscanf(%stdio_File* %f, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sscanf(%stdio_ConstCharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sprintf(%stdio_CharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @vfprintf(%stdio_File* %f, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vprintf(%stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsprintf(%stdio_CharStr* %str, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsnprintf(%stdio_CharStr* %str, %ctypes64_SizeT %n, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @__vsnprintf_chk(%stdio_CharStr* %dest, %ctypes64_SizeT %len, %ctypes64_Int %flags, %ctypes64_SizeT %dstlen, %stdio_ConstCharStr* %format, i8* %arg)
declare %ctypes64_Int @fgetc(%stdio_File* %f)
declare %ctypes64_Int @fputc(%ctypes64_Int %char, %stdio_File* %f)
declare %stdio_CharStr* @fgets(%stdio_CharStr* %str, %ctypes64_Int %n, %stdio_File* %f)
declare %ctypes64_Int @fputs(%stdio_ConstCharStr* %str, %stdio_File* %f)
declare %ctypes64_Int @getc(%stdio_File* %f)
declare %ctypes64_Int @getchar()
declare %stdio_CharStr* @gets(%stdio_CharStr* %str)
declare %ctypes64_Int @putc(%ctypes64_Int %char, %stdio_File* %f)
declare %ctypes64_Int @putchar(%ctypes64_Int %char)
declare %ctypes64_Int @puts(%stdio_ConstCharStr* %str)
declare %ctypes64_Int @ungetc(%ctypes64_Int %char, %stdio_File* %f)
declare void @perror(%stdio_ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --
; -- 2
; ?? delay ??
; from included time
%time_TimeT = type %Int32;
%time_ClockT = type %ctypes64_UnsignedLong;
%time_StructTM = type {
	%ctypes64_Int,
	%ctypes64_Int,
	%ctypes64_Int,
	%ctypes64_Int,
	%ctypes64_Int,
	%ctypes64_Int,
	%ctypes64_Int,
	%ctypes64_Int,
	%ctypes64_Int,
	%ctypes64_LongInt,
	%ctypes64_ConstChar*
};

declare %time_ClockT @clock()
declare %ctypes64_Double @difftime(%time_TimeT %end, %time_TimeT %beginning)
declare %time_TimeT @mktime(%time_StructTM* %timeptr)
declare %time_TimeT @time(%time_TimeT* %timer)
declare %ctypes64_Char* @asctime(%time_StructTM* %timeptr)
declare %ctypes64_Char* @ctime(%time_TimeT* %timer)
declare %time_StructTM* @gmtime(%time_TimeT* %timer)
declare %time_StructTM* @localtime(%time_TimeT* %timer)
declare %ctypes64_SizeT @strftime(%ctypes64_Char* %ptr, %ctypes64_SizeT %maxsize, %ctypes64_ConstChar* %format, %time_StructTM* %timeptr)
declare %time_StructTM* @localtime_s(%time_TimeT* %timer, %time_StructTM* %tmptr)
declare %time_StructTM* @localtime_r(%time_TimeT* %timer, %time_StructTM* %tmptr)
; from import
declare void @delay_us(%Int64 %us)
declare void @delay_ms(%Int64 %ms)
declare void @delay_sec(%Int64 %s)
; end from import
; ?? fsm ??
; from import
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

declare %Str8* @fsm_state_no_name(%fsm_FSM* %fsm, %Int32 %state_no)
declare void @fsm_switch(%fsm_FSM* %fsm, %Int32 %state)
declare void @fsm_run(%fsm_FSM* %fsm)
; end from import
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [10 x i8] [i8 111, i8 102, i8 102, i8 95, i8 108, i8 111, i8 111, i8 112, i8 10, i8 0]
@str2 = private constant [9 x i8] [i8 111, i8 110, i8 95, i8 108, i8 111, i8 111, i8 112, i8 10, i8 0]
@str3 = private constant [22 x i8] [i8 98, i8 101, i8 97, i8 99, i8 111, i8 110, i8 95, i8 101, i8 110, i8 116, i8 114, i8 121, i8 32, i8 102, i8 114, i8 111, i8 109, i8 32, i8 37, i8 115, i8 10, i8 0]
@str4 = private constant [13 x i8] [i8 98, i8 101, i8 97, i8 99, i8 111, i8 110, i8 95, i8 108, i8 111, i8 111, i8 112, i8 10, i8 0]
@str5 = private constant [19 x i8] [i8 98, i8 101, i8 97, i8 99, i8 111, i8 110, i8 95, i8 101, i8 120, i8 105, i8 116, i8 32, i8 116, i8 111, i8 32, i8 37, i8 115, i8 10, i8 0]
; -- endstrings --

; This is flashlight final state machine example
; (just for compiler test and language demonstration)

;@attribute("c_no_print")
;import "lightfood/main"
;@attribute("c_no_print")

;$pragma c_include "./ff_main.h"
@cnt = internal global %Int8 zeroinitializer


;
; State Off
;
define internal void @off_entry(%fsm_FSM* %x) {
	;printf("off_entry\n")
	ret void
}

define internal void @off_loop(%fsm_FSM* %x) {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*))
	%2 = load %Int8, %Int8* @cnt
	%3 = icmp ult %Int8 %2, 10
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = load %Int8, %Int8* @cnt
	%5 = add %Int8 %4, 1
	store %Int8 %5, %Int8* @cnt
	br label %endif_0
else_0:
	store %Int8 0, %Int8* @cnt
	call void @fsm_switch(%fsm_FSM* %x, %Int32 1)
	br label %endif_0
endif_0:
	ret void
}

define internal void @off_exit(%fsm_FSM* %x) {
	;printf("off_exit\n")
	ret void
}



;
; State On
;
define internal void @on_entry(%fsm_FSM* %x) {
	;printf("on_entry\n")
	ret void
}

define internal void @on_loop(%fsm_FSM* %x) {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([9 x i8]* @str2 to [0 x i8]*))
	%2 = load %Int8, %Int8* @cnt
	%3 = icmp ult %Int8 %2, 10
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = load %Int8, %Int8* @cnt
	%5 = add %Int8 %4, 1
	store %Int8 %5, %Int8* @cnt
	br label %endif_0
else_0:
	store %Int8 0, %Int8* @cnt
	call void @fsm_switch(%fsm_FSM* %x, %Int32 2)
	br label %endif_0
endif_0:
	ret void
}

define internal void @on_exit(%fsm_FSM* %x) {
	;printf("on_exit\n")
	ret void
}



;
; State Beacon
;
define internal void @beacon_entry(%fsm_FSM* %x) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %x, %Int32 0, %Int32 1
	%2 = load %Int32, %Int32* %1
	%3 = call %Str8* @fsm_state_no_name(%fsm_FSM* %x, %Int32 %2)
	%4 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str3 to [0 x i8]*), %Str8* %3)
	ret void
}

define internal void @beacon_loop(%fsm_FSM* %x) {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([13 x i8]* @str4 to [0 x i8]*))
	%2 = load %Int8, %Int8* @cnt
	%3 = icmp ult %Int8 %2, 10
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = load %Int8, %Int8* @cnt
	%5 = add %Int8 %4, 1
	store %Int8 %5, %Int8* @cnt
	br label %endif_0
else_0:
	store %Int8 0, %Int8* @cnt
	call void @fsm_switch(%fsm_FSM* %x, %Int32 0)
	br label %endif_0
endif_0:
	ret void
}

define internal void @beacon_exit(%fsm_FSM* %x) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %x, %Int32 0, %Int32 2
	%2 = load %Int32, %Int32* %1
	%3 = call %Str8* @fsm_state_no_name(%fsm_FSM* %x, %Int32 %2)
	%4 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([19 x i8]* @str5 to [0 x i8]*), %Str8* %3)
	ret void
}

@fsm0 = internal global %fsm_FSM {
	[8 x %Char8] [
		%Char8 70,
		%Char8 108,
		%Char8 97,
		%Char8 115,
		%Char8 104,
		%Char8 0,
		%Char8 0,
		%Char8 0
	],
	%Int32 0,
	%Int32 0,
	%Int32 0,
	[16 x %fsm_StateDesc] [
		%fsm_StateDesc {
			[8 x %Char8] [
				%Char8 79,
				%Char8 102,
				%Char8 102,
				%Char8 0,
				%Char8 0,
				%Char8 0,
				%Char8 0,
				%Char8 0
			],
			void (%fsm_FSM*)* @off_entry,
			void (%fsm_FSM*)* @off_loop,
			void (%fsm_FSM*)* @off_exit
		},
		%fsm_StateDesc {
			[8 x %Char8] [
				%Char8 79,
				%Char8 110,
				%Char8 0,
				%Char8 0,
				%Char8 0,
				%Char8 0,
				%Char8 0,
				%Char8 0
			],
			void (%fsm_FSM*)* @on_entry,
			void (%fsm_FSM*)* @on_loop,
			void (%fsm_FSM*)* @on_exit
		},
		%fsm_StateDesc {
			[8 x %Char8] [
				%Char8 66,
				%Char8 101,
				%Char8 97,
				%Char8 99,
				%Char8 111,
				%Char8 110,
				%Char8 0,
				%Char8 0
			],
			void (%fsm_FSM*)* @beacon_entry,
			void (%fsm_FSM*)* @beacon_loop,
			void (%fsm_FSM*)* @beacon_exit
		},
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer,
		%fsm_StateDesc zeroinitializer
	]
}
define %ctypes64_Int @main() {
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	call void @fsm_run(%fsm_FSM* @fsm0)
	call void @delay_ms(%Int64 500)
	br label %again_1
break_1:
	ret %ctypes64_Int 0
}


