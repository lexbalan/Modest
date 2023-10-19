
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type [0 x i8]
%Char = type i8
%ConstChar = type i8
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
%SizeT = type i64
%SSizeT = type i64

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]
%ConstCharStr = type [0 x i8]


declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr*, %ConstCharStr*)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr*, %ConstCharStr*, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr*)
declare i32 @rename(%ConstCharStr*, %ConstCharStr*)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr*)


declare i32 @setvbuf(%FILE*, %CharStr*, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr*)
declare i32 @printf(%ConstCharStr*, ...)
declare i32 @scanf(%ConstCharStr*, ...)
declare i32 @fprintf(%FILE*, %Str*, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr*, ...)
declare i32 @sscanf(%ConstCharStr*, %ConstCharStr*, ...)
declare i32 @sprintf(%CharStr*, %ConstCharStr*, ...)


declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr* @fgets(%CharStr*, i32, %FILE*)
declare i32 @fputs(%ConstCharStr*, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr*)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr*)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr*)

; -- SOURCE: /Users/alexbalan/p/Modest/examples/9.fsm/src/fsm.hm




%FSM_Proc = type void(%FSM*)*
%FSM_Empty = type {
}

%FSM_StateDesc = type {
	[8 x i8],
	%FSM_Proc,
	%FSM_Proc,
	%FSM_Proc
}



%UInt32 = type i32
%FSM = type {
	[8 x i8],
	i32,
	i32,
	i32,
	[16 x %FSM_StateDesc]
}


declare [0 x i8]* @fsm_state_no_name(%FSM*, i32)
declare void @fsm_switch(%FSM*, i32)
declare void @fsm_run(%FSM*)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/fastfood/main.hm



declare void @ff_memzero(i8*, i64)
declare void @ff_memcpy(i8*, i8*, i64)
declare i64 @ff_cstrlen([0 x i8]*)
declare void @delay_us(i64)
declare void @delay_ms(i64)
declare void @delay_s(i64)
declare void @delay(i64)
declare void @ff_print_hex_n32(i32, i8)
declare void @ff_print_hex_n64(i64, i8)
declare void @ff_print_hex_n128(i128, i8)

; -- SOURCE: src/main.cm

@str1.c8 = private constant [10 x i8] c"off_loop\0A\00"
@str2.c8 = private constant [9 x i8] c"on_loop\0A\00"
@str3.c8 = private constant [22 x i8] c"beacon_entry from %s\0A\00"
@str4.c8 = private constant [13 x i8] c"beacon_loop\0A\00"
@str5.c8 = private constant [19 x i8] c"beacon_exit to %s\0A\00"




@cnt = global i8 zeroinitializer


define void @off_entry(%FSM* %fsm) {
;printf("off_entry\n")
    ret void
}

define void @off_loop(%FSM* %fsm) {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* @str1.c8)
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
    %6 = bitcast %FSM* %fsm to %FSM*
    call void(%FSM*, i32) @fsm_switch (%FSM* %6, i32 1)
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
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* @str2.c8)
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
    %6 = bitcast %FSM* %fsm to %FSM*
    call void(%FSM*, i32) @fsm_switch (%FSM* %6, i32 2)
    br label %endif_0
endif_0:
    ret void
}

define void @on_exit(%FSM* %fsm) {
;printf("on_exit\n")
    ret void
}



define void @beacon_entry(%FSM* %fsm) {
    %1 = bitcast %FSM* %fsm to %FSM*
    %2 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 1
    %3 = load i32, i32* %2
    %4 = call [0 x i8]*(%FSM*, i32) @fsm_state_no_name (%FSM* %1, i32 %3)
    %5 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* @str3.c8, [0 x i8]* %4)
    ret void
}

define void @beacon_loop(%FSM* %fsm) {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* @str4.c8)
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
    %6 = bitcast %FSM* %fsm to %FSM*
    call void(%FSM*, i32) @fsm_switch (%FSM* %6, i32 0)
    br label %endif_0
endif_0:
    ret void
}

define void @beacon_exit(%FSM* %fsm) {
    %1 = bitcast %FSM* %fsm to %FSM*
    %2 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 2
    %3 = load i32, i32* %2
    %4 = call [0 x i8]*(%FSM*, i32) @fsm_state_no_name (%FSM* %1, i32 %3)
    %5 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* @str5.c8, [0 x i8]* %4)
    ret void
}


@fsm = global %FSM {
  [8 x i8] [
    i8 70,
    i8 108,
    i8 97,
    i8 115,
    i8 104,
    i8 zeroinitializer,
    i8 zeroinitializer,
    i8 zeroinitializer
  ],
  i32 0,
  i32 0,
  i32 0,
  [16 x %FSM_StateDesc] [
    %FSM_StateDesc {
      [8 x i8] [
        i8 79,
        i8 102,
        i8 102,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer
      ],
      void(%FSM*)* @off_entry,
      void(%FSM*)* @off_loop,
      void(%FSM*)* @off_exit
    },
    %FSM_StateDesc {
      [8 x i8] [
        i8 79,
        i8 110,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer
      ],
      void(%FSM*)* @on_entry,
      void(%FSM*)* @on_loop,
      void(%FSM*)* @on_exit
    },
    %FSM_StateDesc {
      [8 x i8] [
        i8 66,
        i8 101,
        i8 97,
        i8 99,
        i8 111,
        i8 110,
        i8 zeroinitializer,
        i8 zeroinitializer
      ],
      void(%FSM*)* @beacon_entry,
      void(%FSM*)* @beacon_loop,
      void(%FSM*)* @beacon_exit
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

define i32 @main() {
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %1 = bitcast %FSM* @fsm to %FSM*
    call void(%FSM*) @fsm_run (%FSM* %1)
    call void(i64) @delay (i64 500000)
    br label %again_1
break_1:
    ret i32 0
}


