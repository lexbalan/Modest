
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





; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%OffT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(i64 %size)
declare i8* @memset(i8* %mem, i32 %c, i64 %n)
declare i8* @memcpy(i8* %dst, i8* %src, i64 %len)
declare i32 @memcmp(i8* %ptr1, i8* %ptr2, i64 %num)
declare void @free(i8* %ptr)
declare i32 @strncmp([0 x i8]* %s1, [0 x i8]* %s2, i64 %n)
declare i32 @strcmp([0 x i8]* %s1, [0 x i8]* %s2)
declare [0 x i8]* @strcpy([0 x i8]* %dst, [0 x i8]* %src)
declare i64 @strlen([0 x i8]* %s)


declare i32 @ftruncate(i32 %fd, i32 %size)
















declare i32 @creat(%Str* %path, i32 %mode)
declare i32 @open(%Str* %path, i32 %oflags)
declare i32 @read(i32 %fd, i8* %buf, i32 %len)
declare i32 @write(i32 %fd, i8* %buf, i32 %len)
declare i32 @lseek(i32 %fd, i32 %offset, i32 %whence)
declare i32 @close(i32 %fd)
declare void @exit(i32 %rc)


declare %DIR* @opendir(%Str* %name)
declare i32 @closedir(%DIR* %dir)


declare %Str* @getcwd(%Str* %buf, i64 %size)
declare %Str* @getenv(%Str* %name)


declare void @bzero(i8* %s, i64 %n)


declare void @bcopy(i8* %src, i8* %dst, i64 %n)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]
%ConstCharStr = type [0 x i8]


declare i32 @fclose(%FILE* %f)
declare i32 @feof(%FILE* %f)
declare i32 @ferror(%FILE* %f)
declare i32 @fflush(%FILE* %f)
declare i32 @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare i32 @fseek(%FILE* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%FILE* %f, %FposT* %pos)
declare i64 @ftell(%FILE* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare i32 @setvbuf(%FILE* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%FILE* %stream, %Str* %format, ...)
declare i32 @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare i32 @fgetc(%FILE* %f)
declare i32 @fputc(i32 %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %FILE* %f)
declare i32 @fputs(%ConstCharStr* %str, %FILE* %f)
declare i32 @getc(%FILE* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %FILE* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)

; -- SOURCE: /Users/alexbalan/p/Modest/examples/8.linked_list/src/linked_list.hm



%List = type opaque
%Node = type opaque

declare %List* @linked_list_create()
declare i32 @linked_list_size_get(%List* %list)
declare %Node* @linked_list_first_get(%List* %list)
declare %Node* @linked_list_last_get(%List* %list)
declare %Node* @linked_list_node_create()
declare %Node* @linked_list_node_prev_get(%Node* %node)
declare %Node* @linked_list_node_next_get(%Node* %node)
declare i8* @linked_list_node_link_get(%Node* %node)
declare %Node* @linked_list_insert_node(%List* %list, %Node* %new_node)
declare %Node* @linked_list_insert(%List* %list, i8* %link)

; -- SOURCE: src/main.cm

@str1 = private constant [21 x i8] [i8 108, i8 105, i8 115, i8 116, i8 95, i8 112, i8 114, i8 105, i8 110, i8 116, i8 95, i8 102, i8 111, i8 114, i8 119, i8 97, i8 114, i8 100, i8 58, i8 10, i8 0]
@str2 = private constant [8 x i8] [i8 118, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [22 x i8] [i8 108, i8 105, i8 115, i8 116, i8 95, i8 112, i8 114, i8 105, i8 110, i8 116, i8 95, i8 98, i8 97, i8 99, i8 107, i8 119, i8 97, i8 114, i8 100, i8 58, i8 10, i8 0]
@str4 = private constant [8 x i8] [i8 118, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [21 x i8] [i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 32, i8 108, i8 105, i8 115, i8 116, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str6 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 108, i8 105, i8 115, i8 116, i8 0]
@str7 = private constant [22 x i8] [i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 32, i8 108, i8 105, i8 115, i8 116, i8 32, i8 115, i8 105, i8 122, i8 101, i8 58, i8 32, i8 37, i8 100, i8 10, i8 0]




define void @nat64_list_insert(%List* %list, i64 %x) {
    ; alloc memory for Nat64 value
    %1 = call i8*(i64)@malloc(i64 8)
    %2 = bitcast i8* %1 to i64*
    store i64 %x, i64* %2
    %3 = bitcast i64* %2 to i8*
    %4 = call %Node*(%List*, i8*)@linked_list_insert(%List* %list, i8* %3)
    ret void
}



define void @list_print_forward(%List* %list) {
    %1 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*))
    %2 = call %Node*(%List*)@linked_list_first_get(%List* %list)
    %3 = alloca %Node*
    store %Node* %2, %Node** %3
    br label %again_1
again_1:
    %4 = load %Node*, %Node** %3
    %5 = icmp ne %Node* %4, null
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load %Node*, %Node** %3
    %7 = call i8*(%Node*)@linked_list_node_link_get(%Node* %6)
    %8 = bitcast i8* %7 to i32*
    %9 = load i32, i32* %8
    %10 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([8 x i8]* @str2 to [0 x i8]*), i32 %9)
    %11 = load %Node*, %Node** %3
    %12 = call %Node*(%Node*)@linked_list_node_next_get(%Node* %11)
    store %Node* %12, %Node** %3
    br label %again_1
break_1:
    ret void
}



define void @list_print_backward(%List* %list) {
    %1 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([22 x i8]* @str3 to [0 x i8]*))
    %2 = call %Node*(%List*)@linked_list_last_get(%List* %list)
    %3 = alloca %Node*
    store %Node* %2, %Node** %3
    br label %again_1
again_1:
    %4 = load %Node*, %Node** %3
    %5 = icmp ne %Node* %4, null
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load %Node*, %Node** %3
    %7 = call i8*(%Node*)@linked_list_node_link_get(%Node* %6)
    %8 = bitcast i8* %7 to i32*
    %9 = load i32, i32* %8
    %10 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([8 x i8]* @str4 to [0 x i8]*), i32 %9)
    %11 = load %Node*, %Node** %3
    %12 = call %Node*(%Node*)@linked_list_node_prev_get(%Node* %11)
    store %Node* %12, %Node** %3
    br label %again_1
break_1:
    ret void
}

define i32 @main() {
    %1 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*))
    %2 = call %List*()@linked_list_create()
    %3 = icmp eq %List* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
    ret i32 1
    br label %endif_0
endif_0:
    ; add some Nat64 values to list
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 0)
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 10)
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 20)
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 30)
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 40)
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 50)
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 60)
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 70)
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 80)
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 90)
    call void(%List*, i64)@nat64_list_insert(%List* %2, i64 100)
    ; print list size
    %6 = call i32(%List*)@linked_list_size_get(%List* %2)
    %7 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([22 x i8]* @str7 to [0 x i8]*), i32 %6)
    ; print list forward
    call void(%List*)@list_print_forward(%List* %2)
    ; print list backward
    call void(%List*)@list_print_backward(%List* %2)
    ret i32 0
}


