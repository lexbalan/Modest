
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8;
%Char = type i8;
%ConstChar = type i8;
%SignedChar = type i8;
%UnsignedChar = type i8;
%Short = type i16;
%UnsignedShort = type i16;
%Int = type i32;
%UnsignedInt = type i32;
%LongInt = type i64;
%UnsignedLongInt = type i64;
%Long = type i64;
%UnsignedLong = type i64;
%LongLong = type i64;
%UnsignedLongLong = type i64;
%LongLongInt = type i64;
%UnsignedLongLongInt = type i64;
%Float = type double;
%Double = type double;
%LongDouble = type double;


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%SocklenT = type i32;
%SizeT = type i64;
%SSizeT = type i64;
%IntptrT = type i64;
%PtrdiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PidT = type i32;
%UidT = type i32;
%GidT = type i32;


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdlib.hm



declare void @abort()
declare i32 @abs(i32 %x)
declare i32 @atexit(void ()* %x)
declare double @atof([0 x i8]* %nptr)
declare i32 @atoi([0 x i8]* %nptr)
declare i64 @atol([0 x i8]* %nptr)
declare i8* @calloc(i64 %num, i64 %size)
declare void @exit(i32 %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare i64 @labs(i64 %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(i64 %size)
declare i32 @system([0 x i8]* %string)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str;
%ConstCharStr = type %CharStr;


declare i32 @fclose(%File* %f)
declare i32 @feof(%File* %f)
declare i32 @ferror(%File* %f)
declare i32 @fflush(%File* %f)
declare i32 @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %File* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare i32 @fseek(%File* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%File* %f, %FposT* %pos)
declare i64 @ftell(%File* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare i32 @setvbuf(%File* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%File* %stream, %Str* %format, ...)
declare i32 @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare i32 @vprintf(%ConstCharStr* %format, i8* %args)
declare i32 @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare i32 @vsnprintf(%CharStr* %str, i64 %n, %ConstCharStr* %format, i8* %args)
declare i32 @__vsnprintf_chk(%CharStr* %dest, i64 %len, i32 %flags, i64 %dstlen, %ConstCharStr* %format, i8* %arg)
declare i32 @fgetc(%File* %f)
declare i32 @fputc(i32 %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %File* %f)
declare i32 @fputs(%ConstCharStr* %str, %File* %f)
declare i32 @getc(%File* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %File* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %File* %f)
declare void @perror(%ConstCharStr* %str)


; -- SOURCE: /Users/alexbalan/p/Modest/examples/8.linked_list/src/linked_list.hm



%List = type opaque
%Node = type opaque

declare %List* @linked_list_create()
declare i32 @linked_list_size_get(%List* %list)
declare %Node* @linked_list_first_node_get(%List* %list)
declare %Node* @linked_list_last_node_get(%List* %list)
declare %Node* @linked_list_node_create()
declare %Node* @linked_list_node_prev_get(%Node* %node)
declare %Node* @linked_list_node_next_get(%Node* %node)
declare i8* @linked_list_node_data_get(%Node* %node)
declare %Node* @linked_list_node_get(%List* %list, i32 %pos)
declare %Node* @linked_list_node_insert(%List* %list, i32 %pos, %Node* %new_node)
declare %Node* @linked_list_node_append(%List* %list, %Node* %new_node)
declare %Node* @linked_list_insert(%List* %list, i32 %pos, i8* %data)
declare %Node* @linked_list_append(%List* %list, i8* %data)


; -- SOURCE: src/main.cm

@str1 = private constant [21 x i8] [i8 108, i8 105, i8 115, i8 116, i8 95, i8 112, i8 114, i8 105, i8 110, i8 116, i8 95, i8 102, i8 111, i8 114, i8 119, i8 97, i8 114, i8 100, i8 58, i8 10, i8 0]
@str2 = private constant [8 x i8] [i8 118, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str3 = private constant [22 x i8] [i8 108, i8 105, i8 115, i8 116, i8 95, i8 112, i8 114, i8 105, i8 110, i8 116, i8 95, i8 98, i8 97, i8 99, i8 107, i8 119, i8 97, i8 114, i8 100, i8 58, i8 10, i8 0]
@str4 = private constant [8 x i8] [i8 118, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str5 = private constant [21 x i8] [i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 32, i8 108, i8 105, i8 115, i8 116, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str6 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 108, i8 105, i8 115, i8 116, i8 0]
@str7 = private constant [22 x i8] [i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 32, i8 108, i8 105, i8 115, i8 116, i8 32, i8 115, i8 105, i8 122, i8 101, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@str8 = private constant [37 x i8] [i8 10, i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 95, i8 108, i8 105, i8 115, i8 116, i8 95, i8 110, i8 111, i8 100, i8 101, i8 95, i8 103, i8 101, i8 116, i8 40, i8 108, i8 105, i8 115, i8 116, i8 44, i8 32, i8 110, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str9 = private constant [19 x i8] [i8 110, i8 111, i8 100, i8 101, i8 32, i8 37, i8 105, i8 32, i8 110, i8 111, i8 116, i8 32, i8 101, i8 120, i8 105, i8 115, i8 116, i8 10, i8 0]
@str10 = private constant [15 x i8] [i8 108, i8 105, i8 115, i8 116, i8 40, i8 37, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str11 = private constant [43 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str12 = private constant [19 x i8] [i8 110, i8 111, i8 100, i8 101, i8 32, i8 37, i8 105, i8 32, i8 110, i8 111, i8 116, i8 32, i8 101, i8 120, i8 105, i8 115, i8 116, i8 10, i8 0]
@str13 = private constant [15 x i8] [i8 108, i8 105, i8 115, i8 116, i8 40, i8 37, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str14 = private constant [43 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]




define void @nat32_list_insert(%List* %list, i32 %x) {
	; alloc memory for Nat32 value
	%1 = call i8* @malloc(i64 4)
	%2 = bitcast i8* %1 to i32*
	store i32 %x, i32* %2
	%3 = bitcast i32* %2 to i8*
	%4 = call %Node* @linked_list_append(%List* %list, i8* %3)
	ret void
}



define void @list_print_forward(%List* %list) {
	%1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*))
	%2 = alloca %Node*, align 8
	%3 = call %Node* @linked_list_first_node_get(%List* %list)
	store %Node* %3, %Node** %2
	br label %again_1
again_1:
	%4 = load %Node*, %Node** %2
	%5 = icmp ne %Node* %4, null
	br i1 %5 , label %body_1, label %break_1
body_1:
	%6 = load %Node*, %Node** %2
	%7 = call i8* @linked_list_node_data_get(%Node* %6)
	%8 = bitcast i8* %7 to i32*
	%9 = load i32, i32* %8
	%10 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str2 to [0 x i8]*), i32 %9)
	%11 = load %Node*, %Node** %2
	%12 = call %Node* @linked_list_node_next_get(%Node* %11)
	store %Node* %12, %Node** %2
	br label %again_1
break_1:
	ret void
}



define void @list_print_backward(%List* %list) {
	%1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str3 to [0 x i8]*))
	%2 = alloca %Node*, align 8
	%3 = call %Node* @linked_list_last_node_get(%List* %list)
	store %Node* %3, %Node** %2
	br label %again_1
again_1:
	%4 = load %Node*, %Node** %2
	%5 = icmp ne %Node* %4, null
	br i1 %5 , label %body_1, label %break_1
body_1:
	%6 = load %Node*, %Node** %2
	%7 = call i8* @linked_list_node_data_get(%Node* %6)
	%8 = bitcast i8* %7 to i32*
	%9 = load i32, i32* %8
	%10 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str4 to [0 x i8]*), i32 %9)
	%11 = load %Node*, %Node** %2
	%12 = call %Node* @linked_list_node_prev_get(%Node* %11)
	store %Node* %12, %Node** %2
	br label %again_1
break_1:
	ret void
}

define i32 @main() {
	%1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*))
	%2 = call %List* @linked_list_create()
	%3 = icmp eq %List* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	%4 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
	ret i32 1
	br label %endif_0
endif_0:
	; add some Nat32 values to list
	call void @nat32_list_insert(%List* %2, i32 0)
	call void @nat32_list_insert(%List* %2, i32 10)
	call void @nat32_list_insert(%List* %2, i32 20)
	call void @nat32_list_insert(%List* %2, i32 30)
	call void @nat32_list_insert(%List* %2, i32 40)
	call void @nat32_list_insert(%List* %2, i32 50)
	call void @nat32_list_insert(%List* %2, i32 60)
	call void @nat32_list_insert(%List* %2, i32 70)
	call void @nat32_list_insert(%List* %2, i32 80)
	call void @nat32_list_insert(%List* %2, i32 90)
	call void @nat32_list_insert(%List* %2, i32 100)
	; print list size
	%6 = call i32 @linked_list_size_get(%List* %2)
	%7 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str7 to [0 x i8]*), i32 %6)
	; print list forward
	call void @list_print_forward(%List* %2)
	; print list backward
	call void @list_print_backward(%List* %2)
	%8 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str8 to [0 x i8]*))
	; test linked_list_node_get
	%9 = alloca i32, align 4
	store i32 0, i32* %9
	br label %again_1
again_1:
	%10 = load i32, i32* %9
	%11 = icmp sge i32 %10, -12
	br i1 %11 , label %body_1, label %break_1
body_1:
	%12 = load i32, i32* %9
	%13 = call %Node* @linked_list_node_get(%List* %2, i32 %12)
	%14 = icmp eq %Node* %13, null
	br i1 %14 , label %then_1, label %endif_1
then_1:
	%15 = load i32, i32* %9
	%16 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str9 to [0 x i8]*), i32 %15)
	%17 = load i32, i32* %9
	%18 = sub i32 %17, 1
	store i32 %18, i32* %9
	br label %again_1
	br label %endif_1
endif_1:
	%20 = call i8* @linked_list_node_data_get(%Node* %13)
	%21 = bitcast i8* %20 to i32*
	%22 = load i32, i32* %9
	%23 = load i32, i32* %21
	%24 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str10 to [0 x i8]*), i32 %22, i32 %23)
	%25 = load i32, i32* %9
	%26 = sub i32 %25, 1
	store i32 %26, i32* %9
	br label %again_1
break_1:
	%27 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @str11 to [0 x i8]*))
	store i32 0, i32* %9
	br label %again_2
again_2:
	%28 = load i32, i32* %9
	%29 = icmp sle i32 %28, 12
	br i1 %29 , label %body_2, label %break_2
body_2:
	%30 = load i32, i32* %9
	%31 = call %Node* @linked_list_node_get(%List* %2, i32 %30)
	%32 = icmp eq %Node* %31, null
	br i1 %32 , label %then_2, label %endif_2
then_2:
	%33 = load i32, i32* %9
	%34 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str12 to [0 x i8]*), i32 %33)
	%35 = load i32, i32* %9
	%36 = add i32 %35, 1
	store i32 %36, i32* %9
	br label %again_2
	br label %endif_2
endif_2:
	%38 = call i8* @linked_list_node_data_get(%Node* %31)
	%39 = bitcast i8* %38 to i32*
	%40 = load i32, i32* %9
	%41 = load i32, i32* %39
	%42 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), i32 %40, i32 %41)
	%43 = load i32, i32* %9
	%44 = add i32 %43, 1
	store i32 %44, i32* %9
	br label %again_2
break_2:
	%45 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @str14 to [0 x i8]*))
	%46 = call i8* @malloc(i64 4)
	%47 = bitcast i8* %46 to i32*
	store i32 1234, i32* %47
	%48 = bitcast i32* %47 to i8*
	%49 = call %Node* @linked_list_insert(%List* %2, i32 4, i8* %48)
	call void @list_print_forward(%List* %2)
	ret i32 0
}


