
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


; -- SOURCE: src/fsm.cm

@str1 = private constant [10 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 37, i8 115, i8 10, i8 0]
@str2 = private constant [9 x i8] [i8 101, i8 120, i8 105, i8 116, i8 32, i8 37, i8 115, i8 10, i8 0]




define [0 x i8]* @fsm_state_no_name(%FSM* %fsm, i32 %state_no) {
    %1 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 4
    %2 = getelementptr inbounds [16 x %FSM_StateDesc], [16 x %FSM_StateDesc]* %1, i32 0, i32 %state_no
    %3 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %2, i32 0, i32 0
    %4 = bitcast [8 x i8]* %3 to [0 x i8]*
    ret [0 x i8]* %4
}

define void @fsm_switch(%FSM* %fsm, i32 %state) {
    %1 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 2
    store i32 %state, i32* %1
    %2 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    store i32 2, i32* %2
    ret void
}

define void @fsm_run(%FSM* %fsm) {
    %1 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    %2 = load i32, i32* %1
    %3 = icmp eq i32 %2, 0
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 2
    %5 = load i32, i32* %4
    %6 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 4
    %7 = getelementptr inbounds [16 x %FSM_StateDesc], [16 x %FSM_StateDesc]* %6, i32 0, i32 %5
    br i1 1 , label %then_1, label %endif_1
then_1:
    %8 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %7, i32 0, i32 0
    %9 = load [8 x i8], [8 x i8]* %8
    %10 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), [8 x i8] %9)
    br label %endif_1
endif_1:
    %11 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %7, i32 0, i32 1
    %12 = load %FSM_Proc, %FSM_Proc* %11
    %13 = icmp ne %FSM_Proc %12, null
    br i1 %13 , label %then_2, label %endif_2
then_2:
    %14 = bitcast %FSM* %fsm to %FSM*
    %15 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %7, i32 0, i32 1
    %16 = load %FSM_Proc, %FSM_Proc* %15
    call void(%FSM*) %16 (%FSM* %14)
    br label %endif_2
endif_2:
    %17 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 1
    store i32 %5, i32* %17
    %18 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    store i32 1, i32* %18
    br label %endif_0
else_0:
    %19 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    %20 = load i32, i32* %19
    %21 = icmp eq i32 %20, 1
    br i1 %21 , label %then_3, label %else_3
then_3:
    %22 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 4
    %23 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 1
    %24 = load i32, i32* %23
    %25 = getelementptr inbounds [16 x %FSM_StateDesc], [16 x %FSM_StateDesc]* %22, i32 0, i32 %24
    %26 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %25, i32 0, i32 2
    %27 = load %FSM_Proc, %FSM_Proc* %26
    %28 = icmp ne %FSM_Proc %27, null
    br i1 %28 , label %then_4, label %endif_4
then_4:
    %29 = bitcast %FSM* %fsm to %FSM*
    %30 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %25, i32 0, i32 2
    %31 = load %FSM_Proc, %FSM_Proc* %30
    call void(%FSM*) %31 (%FSM* %29)
    br label %endif_4
endif_4:
    br label %endif_3
else_3:
    %32 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    %33 = load i32, i32* %32
    %34 = icmp eq i32 %33, 2
    br i1 %34 , label %then_5, label %endif_5
then_5:
    %35 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 4
    %36 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 1
    %37 = load i32, i32* %36
    %38 = getelementptr inbounds [16 x %FSM_StateDesc], [16 x %FSM_StateDesc]* %35, i32 0, i32 %37
    br i1 1 , label %then_6, label %endif_6
then_6:
    %39 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %38, i32 0, i32 0
    %40 = load [8 x i8], [8 x i8]* %39
    %41 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([9 x i8]* @str2 to [0 x i8]*), [8 x i8] %40)
    br label %endif_6
endif_6:
    %42 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %38, i32 0, i32 3
    %43 = load %FSM_Proc, %FSM_Proc* %42
    %44 = icmp ne %FSM_Proc %43, null
    br i1 %44 , label %then_7, label %endif_7
then_7:
    %45 = bitcast %FSM* %fsm to %FSM*
    %46 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %38, i32 0, i32 3
    %47 = load %FSM_Proc, %FSM_Proc* %46
    call void(%FSM*) %47 (%FSM* %45)
    br label %endif_7
endif_7:
    %48 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    store i32 0, i32* %48
    br label %endif_5
endif_5:
    br label %endif_3
endif_3:
    br label %endif_0
endif_0:
    ret void
}


