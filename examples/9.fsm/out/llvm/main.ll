
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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8
%Char = type i8
%ConstChar = type %Char
%SignedChar = type i8
%UnsignedChar = type i8
%Short = type i16
%UnsignedShort = type i16
%Int = type i32
%UnsignedInt = type i32
%LongInt = type i64
%UnsignedLongInt = type i64
%Long = type i64
%UnsignedLong = type i64
%LongLong = type i64
%UnsignedLongLong = type i64
%LongLongInt = type i64
%UnsignedLongLongInt = type i64
%Float = type double
%Double = type double
%LongDouble = type double


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FILE = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%FILE* %f)
declare %Int @feof(%FILE* %f)
declare %Int @ferror(%FILE* %f)
declare %Int @fflush(%FILE* %f)
declare %Int @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare %Int @fseek(%FILE* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%FILE* %f, %FposT* %pos)
declare %LongInt @ftell(%FILE* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare %Int @setvbuf(%FILE* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%FILE* %stream, %Str* %format, ...)
declare %Int @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare %Int @fgetc(%FILE* %f)
declare %Int @fputc(%Int %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %FILE* %f)
declare %Int @fputs(%ConstCharStr* %str, %FILE* %f)
declare %Int @getc(%FILE* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %FILE* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)


; -- SOURCE: /Users/alexbalan/p/Modest/examples/9.fsm/src/fsm.hm




%FSM_Proc = type void (%FSM*)*
%FSM_StateDesc = type {
	[8 x i8], 
	%FSM_Proc, 
	%FSM_Proc, 
	%FSM_Proc
}



%UInt32 = type i32
%FSM = type {
	[8 x i8], 
	%UInt32, 
	%UInt32, 
	%UInt32, 
	[16 x %FSM_StateDesc]
}


declare %Str8* @fsm_state_no_name(%FSM* %fsm, i32 %state_no)
declare void @fsm_switch(%FSM* %fsm, i32 %state)
declare void @fsm_run(%FSM* %fsm)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/lightfood/delay.hm



declare void @delay_us(i64 %us)
declare void @delay_ms(i64 %ms)
declare void @delay_s(i64 %s)


; -- SOURCE: src/main.cm

@str1 = private constant [10 x i8] [i8 111, i8 102, i8 102, i8 95, i8 108, i8 111, i8 111, i8 112, i8 10, i8 0]
@str2 = private constant [9 x i8] [i8 111, i8 110, i8 95, i8 108, i8 111, i8 111, i8 112, i8 10, i8 0]
@str3 = private constant [22 x i8] [i8 98, i8 101, i8 97, i8 99, i8 111, i8 110, i8 95, i8 101, i8 110, i8 116, i8 114, i8 121, i8 32, i8 102, i8 114, i8 111, i8 109, i8 32, i8 37, i8 115, i8 10, i8 0]
@str4 = private constant [13 x i8] [i8 98, i8 101, i8 97, i8 99, i8 111, i8 110, i8 95, i8 108, i8 111, i8 111, i8 112, i8 10, i8 0]
@str5 = private constant [19 x i8] [i8 98, i8 101, i8 97, i8 99, i8 111, i8 110, i8 95, i8 101, i8 120, i8 105, i8 116, i8 32, i8 116, i8 111, i8 32, i8 37, i8 115, i8 10, i8 0]








@cnt = global i8 zeroinitializer


define void @off_entry(%FSM* %fsm) {
	;printf("off_entry\n")
	ret void
}

define void @off_loop(%FSM* %fsm) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*))
	%2 = load i8, i8* @cnt
	%3 = icmp ult i8 %2, 10
	br i1 %3 , label %then_0, label %else_0
then_0:
	%4 = load i8, i8* @cnt
	%5 = add i8 %4, 1
	store i8 %5, i8* @cnt
	br label %endif_0
else_0:
	store i8 0, i8* @cnt
	call void (%FSM*, i32) @fsm_switch(%FSM* %fsm, i32 1)
	br label %endif_0
endif_0:
	ret void
}

define void @off_exit(%FSM* %fsm) {
	;printf("off_exit\n")
	ret void
}



define void @on_entry(%FSM* %fsm) {
	;printf("on_entry\n")
	ret void
}

define void @on_loop(%FSM* %fsm) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str2 to [0 x i8]*))
	%2 = load i8, i8* @cnt
	%3 = icmp ult i8 %2, 10
	br i1 %3 , label %then_0, label %else_0
then_0:
	%4 = load i8, i8* @cnt
	%5 = add i8 %4, 1
	store i8 %5, i8* @cnt
	br label %endif_0
else_0:
	store i8 0, i8* @cnt
	call void (%FSM*, i32) @fsm_switch(%FSM* %fsm, i32 2)
	br label %endif_0
endif_0:
	ret void
}

define void @on_exit(%FSM* %fsm) {
	;printf("on_exit\n")
	ret void
}



define void @beacon_entry(%FSM* %fsm) {
	%1 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 1
	%2 = load %UInt32, %UInt32* %1
	%3 = call %Str8* (%FSM*, i32) @fsm_state_no_name(%FSM* %fsm, %UInt32 %2)
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str3 to [0 x i8]*), %Str8* %3)
	ret void
}

define void @beacon_loop(%FSM* %fsm) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str4 to [0 x i8]*))
	%2 = load i8, i8* @cnt
	%3 = icmp ult i8 %2, 10
	br i1 %3 , label %then_0, label %else_0
then_0:
	%4 = load i8, i8* @cnt
	%5 = add i8 %4, 1
	store i8 %5, i8* @cnt
	br label %endif_0
else_0:
	store i8 0, i8* @cnt
	call void (%FSM*, i32) @fsm_switch(%FSM* %fsm, i32 0)
	br label %endif_0
endif_0:
	ret void
}

define void @beacon_exit(%FSM* %fsm) {
	%1 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 2
	%2 = load %UInt32, %UInt32* %1
	%3 = call %Str8* (%FSM*, i32) @fsm_state_no_name(%FSM* %fsm, %UInt32 %2)
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str5 to [0 x i8]*), %Str8* %3)
	ret void
}


@fsm = global %FSM {
	[8 x i8] [
		i8 70,
		i8 108,
		i8 97,
		i8 115,
		i8 104,
		i8 0,
		i8 0,
		i8 0
	],
	%UInt32 0,
	%UInt32 0,
	%UInt32 0,
	[16 x %FSM_StateDesc] [
		%FSM_StateDesc {
			[8 x i8] [
				i8 79,
				i8 102,
				i8 102,
				i8 0,
				i8 0,
				i8 0,
				i8 0,
				i8 0
			],
			void (%FSM*)* @off_entry,
			void (%FSM*)* @off_loop,
			void (%FSM*)* @off_exit
		},
		%FSM_StateDesc {
			[8 x i8] [
				i8 79,
				i8 110,
				i8 0,
				i8 0,
				i8 0,
				i8 0,
				i8 0,
				i8 0
			],
			void (%FSM*)* @on_entry,
			void (%FSM*)* @on_loop,
			void (%FSM*)* @on_exit
		},
		%FSM_StateDesc {
			[8 x i8] [
				i8 66,
				i8 101,
				i8 97,
				i8 99,
				i8 111,
				i8 110,
				i8 0,
				i8 0
			],
			void (%FSM*)* @beacon_entry,
			void (%FSM*)* @beacon_loop,
			void (%FSM*)* @beacon_exit
		},
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer,
		%FSM_StateDesc zeroinitializer
	]
}

define %Int @main() {
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	call void (%FSM*) @fsm_run(%FSM* @fsm)
	call void (i64) @delay_ms(i64 500)
	br label %again_1
break_1:
	ret %Int 0
}


