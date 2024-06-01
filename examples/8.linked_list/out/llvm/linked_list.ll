
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
%PointerToConst = type i8*


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(%SizeT %size)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, %PointerToConst %src, %SizeT %len)
declare i8* @memmove(i8* %dst, %PointerToConst %source, %SizeT %n)
declare %Int @memcmp(i8* %ptr1, i8* %ptr2, %SizeT %num)
declare void @free(i8* %ptr)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)


declare %Int @ftruncate(%Int %fd, %OffT %size)
















declare %Int @creat(%Str* %path, %ModeT %mode)
declare %Int @open(%Str* %path, %Int %oflags)
declare %Int @read(%Int %fd, i8* %buf, i32 %len)
declare %Int @write(%Int %fd, i8* %buf, i32 %len)
declare %OffT @lseek(%Int %fd, %OffT %offset, %Int %whence)
declare %Int @close(%Int %fd)
declare void @exit(%Int %rc)


declare %DIR* @opendir(%Str* %name)
declare %Int @closedir(%DIR* %dir)


declare %Str* @getcwd(%Str* %buf, %SizeT %size)
declare %Str* @getenv(%Str* %name)


declare void @bzero(i8* %s, %SizeT %n)


declare void @bcopy(i8* %src, i8* %dst, %SizeT %n)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare %Int @setvbuf(%File* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %stream, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


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


; -- SOURCE: /Users/alexbalan/p/Modest/examples/8.linked_list/src/linked_list.hm




; -- SOURCE: src/linked_list.cm

@str1 = private constant [19 x i8] [i8 110, i8 111, i8 100, i8 101, i8 95, i8 105, i8 110, i8 115, i8 101, i8 114, i8 116, i8 95, i8 114, i8 105, i8 103, i8 104, i8 116, i8 10, i8 0]



%Node = type {
	%Node*, 
	%Node*, 
	i8*
}

%List = type {
	%Node*, 
	%Node*, 
	i32
}


define %List* @linked_list_create() {
	%1 = call i8* (%SizeT) @malloc(%SizeT 24)
	%2 = bitcast i8* %1 to %List*
	%3 = icmp eq %List* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret %List* null
	br label %endif_0
endif_0:
	store %List zeroinitializer, %List* %2
	ret %List* %2
}

define i32 @linked_list_size_get(%List* %list) {
	%1 = icmp eq %List* %list, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret i32 0
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%4 = load i32, i32* %3
	ret i32 %4
}

define %Node* @linked_list_first_node_get(%List* %list) {
	%1 = icmp eq %List* %list, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	%4 = load %Node*, %Node** %3
	ret %Node* %4
}

define %Node* @linked_list_last_node_get(%List* %list) {
	%1 = icmp eq %List* %list, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%4 = load %Node*, %Node** %3
	ret %Node* %4
}

define %Node* @linked_list_node_create() {
	%1 = call i8* (%SizeT) @malloc(%SizeT 24)
	%2 = bitcast i8* %1 to %Node*
	%3 = icmp eq %Node* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	store %Node zeroinitializer, %Node* %2
	ret %Node* %2
}

define %Node* @linked_list_node_next_get(%Node* %node) {
	%1 = icmp eq %Node* %node, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 0
	%4 = load %Node*, %Node** %3
	ret %Node* %4
}

define %Node* @linked_list_node_prev_get(%Node* %node) {
	%1 = icmp eq %Node* %node, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 1
	%4 = load %Node*, %Node** %3
	ret %Node* %4
}

define i8* @linked_list_node_data_get(%Node* %node) {
	%1 = icmp eq %Node* %node, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret i8* null
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 2
	%4 = load i8*, i8** %3
	ret i8* %4
}

define void @node_insert_right(%Node* %left, %Node* %new_right) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*))
	%2 = getelementptr inbounds %Node, %Node* %left, i32 0, i32 0
	%3 = load %Node*, %Node** %2
	%4 = getelementptr inbounds %Node, %Node* %left, i32 0, i32 0
	store %Node* %new_right, %Node** %4
	%5 = icmp ne %Node* %3, null
	br i1 %5 , label %then_0, label %endif_0
then_0:
	%6 = getelementptr inbounds %Node, %Node* %3, i32 0, i32 1
	store %Node* %new_right, %Node** %6
	br label %endif_0
endif_0:
	%7 = getelementptr inbounds %Node, %Node* %new_right, i32 0, i32 0
	store %Node* %3, %Node** %7
	%8 = getelementptr inbounds %Node, %Node* %new_right, i32 0, i32 1
	store %Node* %left, %Node** %8
	ret void
}



define %Node* @linked_list_node_get(%List* %list, i32 %pos) {
	%1 = icmp eq %List* %list, null
	%2 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%3 = load i32, i32* %2
	%4 = icmp eq i32 %3, 0
	%5 = or i1 %1, %4
	br i1 %5 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%7 = alloca %Node*, align 8
	%8 = icmp sge i32 %pos, 0
	br i1 %8 , label %then_1, label %else_1
then_1:
	; go forward
	%9 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	%10 = load %Node*, %Node** %9
	store %Node* %10, %Node** %7
	%11 = bitcast i32 %pos to i32
	%12 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%13 = load i32, i32* %12
	%14 = icmp ugt i32 %11, %13
	br i1 %14 , label %then_2, label %endif_2
then_2:
	ret %Node* null
	br label %endif_2
endif_2:
	%16 = alloca i32, align 4
	store i32 0, i32* %16
	br label %again_1
again_1:
	%17 = load i32, i32* %16
	%18 = icmp ult i32 %17, %11
	br i1 %18 , label %body_1, label %break_1
body_1:
	%19 = load %Node*, %Node** %7
	%20 = getelementptr inbounds %Node, %Node* %19, i32 0, i32 0
	%21 = load %Node*, %Node** %20
	store %Node* %21, %Node** %7
	%22 = load i32, i32* %16
	%23 = add i32 %22, 1
	store i32 %23, i32* %16
	br label %again_1
break_1:
	br label %endif_1
else_1:
	; go backward
	%24 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%25 = load %Node*, %Node** %24
	store %Node* %25, %Node** %7
	%26 = sub i32 0, %pos
	%27 = bitcast i32 %26 to i32
	%28 = sub i32 %27, 1
	%29 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%30 = load i32, i32* %29
	%31 = icmp ugt i32 %28, %30
	br i1 %31 , label %then_3, label %endif_3
then_3:
	ret %Node* null
	br label %endif_3
endif_3:
	%33 = alloca i32, align 4
	store i32 0, i32* %33
	br label %again_2
again_2:
	%34 = load i32, i32* %33
	%35 = icmp ult i32 %34, %28
	br i1 %35 , label %body_2, label %break_2
body_2:
	%36 = load %Node*, %Node** %7
	%37 = getelementptr inbounds %Node, %Node* %36, i32 0, i32 1
	%38 = load %Node*, %Node** %37
	store %Node* %38, %Node** %7
	%39 = load i32, i32* %33
	%40 = add i32 %39, 1
	store i32 %40, i32* %33
	br label %again_2
break_2:
	br label %endif_1
endif_1:
	%41 = load %Node*, %Node** %7
	ret %Node* %41
}

define %Node* @linked_list_node_append(%List* %list, %Node* %new_node) {
	%1 = icmp eq %List* %list, null
	%2 = icmp eq %Node* %new_node, null
	%3 = or i1 %1, %2
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%6 = load %Node*, %Node** %5
	%7 = icmp eq %Node* %6, null
	br i1 %7 , label %then_1, label %else_1
then_1:
	%8 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	store %Node* %new_node, %Node** %8
	br label %endif_1
else_1:
	%9 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%10 = load %Node*, %Node** %9
	call void (%Node*, %Node*) @node_insert_right(%Node* %10, %Node* %new_node)
	br label %endif_1
endif_1:
	%11 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	store %Node* %new_node, %Node** %11
	%12 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%13 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%14 = load i32, i32* %13
	%15 = add i32 %14, 1
	store i32 %15, i32* %12
	ret %Node* %new_node
}

define %Node* @linked_list_append(%List* %list, i8* %data) {
	%1 = icmp eq %List* %list, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%3 = call %Node* () @linked_list_node_create()
	%4 = icmp eq %Node* %3, null
	br i1 %4 , label %then_1, label %endif_1
then_1:
	ret %Node* null
	br label %endif_1
endif_1:
	%6 = getelementptr inbounds %Node, %Node* %3, i32 0, i32 2
	store i8* %data, i8** %6
	%7 = call %Node* (%List*, %Node*) @linked_list_node_append(%List* %list, %Node* %3)
	%8 = icmp eq %Node* %7, null
	br i1 %8 , label %then_2, label %endif_2
then_2:
	%9 = bitcast %Node* %3 to i8*
	call void (i8*) @free(i8* %9)
	br label %endif_2
endif_2:
	ret %Node* %7
}


