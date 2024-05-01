
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



; -- SOURCE: src/fsm.cm

@str1 = private constant [11 x i8] [i8 102, i8 115, i8 109, i8 95, i8 114, i8 117, i8 110, i8 40, i8 41, i8 10, i8 0]
@str2 = private constant [10 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 37, i8 115, i8 10, i8 0]
@str3 = private constant [9 x i8] [i8 101, i8 120, i8 105, i8 116, i8 32, i8 37, i8 115, i8 10, i8 0]




define %Str8* @fsm_state_no_name(%FSM* %fsm, i32 %state_no) {
    %1 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 4
    %2 = getelementptr inbounds [16 x %FSM_StateDesc], [16 x %FSM_StateDesc]* %1, i32 0, i32 %state_no
    %3 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %2, i32 0, i32 0
    %4 = bitcast [8 x i8]* %3 to %Str8*
    ret %Str8* %4
}

define void @fsm_switch(%FSM* %fsm, i32 %state) {
    %1 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 2
    store i32 %state, %UInt32* %1
    %2 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    store %UInt32 2, %UInt32* %2
    ret void
}

define void @fsm_run(%FSM* %fsm) {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str1 to [0 x i8]*))
    %2 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    %3 = load %UInt32, %UInt32* %2
    %4 = icmp eq %UInt32 %3, 0
    br i1 %4 , label %then_0, label %else_0
then_0:
    %5 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 2
    %6 = load %UInt32, %UInt32* %5
    %7 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 4
    %8 = getelementptr inbounds [16 x %FSM_StateDesc], [16 x %FSM_StateDesc]* %7, i32 0, %UInt32 %6
    br i1 1 , label %then_1, label %endif_1
then_1:
    %9 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %8, i32 0, i32 0
    %10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str2 to [0 x i8]*), [8 x i8]* %9)
    br label %endif_1
endif_1:
    %11 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %8, i32 0, i32 1
    %12 = load %FSM_Proc, %FSM_Proc* %11
    %13 = icmp ne %FSM_Proc %12, null
    br i1 %13 , label %then_2, label %endif_2
then_2:
    %14 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %8, i32 0, i32 1
    %15 = load %FSM_Proc, %FSM_Proc* %14
    call void (%FSM*) %15(%FSM* %fsm)
    br label %endif_2
endif_2:
    %16 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 1
    store %UInt32 %6, %UInt32* %16
    %17 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    store %UInt32 1, %UInt32* %17
    br label %endif_0
else_0:
    %18 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    %19 = load %UInt32, %UInt32* %18
    %20 = icmp eq %UInt32 %19, 1
    br i1 %20 , label %then_3, label %else_3
then_3:
    %21 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 4
    %22 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 1
    %23 = load %UInt32, %UInt32* %22
    %24 = getelementptr inbounds [16 x %FSM_StateDesc], [16 x %FSM_StateDesc]* %21, i32 0, %UInt32 %23
    %25 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %24, i32 0, i32 2
    %26 = load %FSM_Proc, %FSM_Proc* %25
    %27 = icmp ne %FSM_Proc %26, null
    br i1 %27 , label %then_4, label %endif_4
then_4:
    %28 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %24, i32 0, i32 2
    %29 = load %FSM_Proc, %FSM_Proc* %28
    call void (%FSM*) %29(%FSM* %fsm)
    br label %endif_4
endif_4:
    br label %endif_3
else_3:
    %30 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    %31 = load %UInt32, %UInt32* %30
    %32 = icmp eq %UInt32 %31, 2
    br i1 %32 , label %then_5, label %endif_5
then_5:
    %33 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 4
    %34 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 1
    %35 = load %UInt32, %UInt32* %34
    %36 = getelementptr inbounds [16 x %FSM_StateDesc], [16 x %FSM_StateDesc]* %33, i32 0, %UInt32 %35
    br i1 1 , label %then_6, label %endif_6
then_6:
    %37 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %36, i32 0, i32 0
    %38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str3 to [0 x i8]*), [8 x i8]* %37)
    br label %endif_6
endif_6:
    %39 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %36, i32 0, i32 3
    %40 = load %FSM_Proc, %FSM_Proc* %39
    %41 = icmp ne %FSM_Proc %40, null
    br i1 %41 , label %then_7, label %endif_7
then_7:
    %42 = getelementptr inbounds %FSM_StateDesc, %FSM_StateDesc* %36, i32 0, i32 3
    %43 = load %FSM_Proc, %FSM_Proc* %42
    call void (%FSM*) %43(%FSM* %fsm)
    br label %endif_7
endif_7:
    %44 = getelementptr inbounds %FSM, %FSM* %fsm, i32 0, i32 3
    store %UInt32 0, %UInt32* %44
    br label %endif_5
endif_5:
    br label %endif_3
endif_3:
    br label %endif_0
endif_0:
    ret void
}


