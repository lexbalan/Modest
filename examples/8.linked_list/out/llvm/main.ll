
target triple = "arm64-apple-darwin21.6.0"

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




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
declare i8* @malloc(i64)
declare i8* @memset(i8*, i32, i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @memcmp(i8*, i8*, i64)
declare void @free(i8*)
declare i32 @strncmp(i8*, i8*, i64)
declare i32 @strcmp(i8*, i8*)
declare i8* @strcpy(i8*, i8*)
declare i64 @strlen(i8*)


declare i32 @ftruncate(i32, i32)
















declare i32 @creat([0 x i8]*, i32)
declare i32 @open([0 x i8]*, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir([0 x i8]*)
declare i32 @closedir(%DIR*)


declare [0 x i8]* @getcwd([0 x i8]*, i64)
declare [0 x i8]* @getenv([0 x i8]*)

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]*
%ConstCharStr = type [0 x i8]*


declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr, %ConstCharStr)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr, %ConstCharStr, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr)
declare i32 @rename(%ConstCharStr, %ConstCharStr)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr)


declare i32 @setvbuf(%FILE*, %CharStr, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr @tmpnam(%CharStr)
declare i32 @printf(%ConstCharStr, ...)
declare i32 @scanf(%ConstCharStr, ...)
declare i32 @fprintf(%FILE*, [0 x i8]*, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr, ...)
declare i32 @sscanf(%ConstCharStr, %ConstCharStr, ...)
declare i32 @sprintf(%CharStr, %ConstCharStr, ...)


declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr @fgets(%CharStr, i32, %FILE*)
declare i32 @fputs(%ConstCharStr, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr @gets(%CharStr)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr)

; -- MODULE: /Users/alexbalan/p/Modest/examples/8.linked_list/src/linked_list.hm



%List = type opaque
%Node = type opaque

declare %List* @linked_list_create()
declare i32 @linked_list_size_get(%List*)
declare %Node* @linked_list_first_get(%List*)
declare %Node* @linked_list_last_get(%List*)
declare %Node* @linked_list_node_create()
declare %Node* @linked_list_node_prev_get(%Node*)
declare %Node* @linked_list_node_next_get(%Node*)
declare i8* @linked_list_node_link_get(%Node*)
declare %Node* @linked_list_insert_node(%List*, %Node*)
declare %Node* @linked_list_insert(%List*, i8*)

; -- MODULE: /Users/alexbalan/p/Modest/examples/8.linked_list/src/main.cm

@str_1 = private constant [21 x i8] c"list_print_forward:\0A\00"
@str_2 = private constant [8 x i8] c"v = %d\0A\00"
@str_3 = private constant [22 x i8] c"list_print_backward:\0A\00"
@str_4 = private constant [8 x i8] c"v = %d\0A\00"
@str_5 = private constant [21 x i8] c"linked list example\0A\00"
@str_6 = private constant [26 x i8] c"error: cannot create list\00"
@str_7 = private constant [22 x i8] c"linked list size: %d\0A\00"




define void @nat64_list_insert(%List* %list, i64 %x) {
; alloc memory for Nat64 value
    %1 = call i8*(i64) @malloc (i64 8)
    %2 = bitcast i8* %1 to i64*
    store i64 %x, i64* %2
    %3 = bitcast i64* %2 to i8*
    %4 = call %Node*(%List*, i8*) @linked_list_insert (%List* %list, i8* %3)
    ret void
}



define void @list_print_forward(%List* %list) {
    %1 = bitcast [21 x i8]* @str_1 to %ConstCharStr
    %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
    %3 = call %Node*(%List*) @linked_list_first_get (%List* %list)
    %pn = alloca %Node*
    store %Node* %3, %Node** %pn
    br label %again_1
again_1:
    %4 = load %Node*, %Node** %pn
    %5 = icmp ne %Node* %4, null
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load %Node*, %Node** %pn
    %7 = call i8*(%Node*) @linked_list_node_link_get (%Node* %6)
    %8 = bitcast i8* %7 to i32*
    %9 = bitcast [8 x i8]* @str_2 to %ConstCharStr
    %10 = load i32, i32* %8
    %11 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %9, i32 %10)
    %12 = load %Node*, %Node** %pn
    %13 = call %Node*(%Node*) @linked_list_node_next_get (%Node* %12)
    store %Node* %13, %Node** %pn
    br label %again_1
break_1:
    ret void
}



define void @list_print_backward(%List* %list) {
    %1 = bitcast [22 x i8]* @str_3 to %ConstCharStr
    %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
    %3 = call %Node*(%List*) @linked_list_last_get (%List* %list)
    %pn = alloca %Node*
    store %Node* %3, %Node** %pn
    br label %again_1
again_1:
    %4 = load %Node*, %Node** %pn
    %5 = icmp ne %Node* %4, null
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load %Node*, %Node** %pn
    %7 = call i8*(%Node*) @linked_list_node_link_get (%Node* %6)
    %8 = bitcast i8* %7 to i32*
    %9 = bitcast [8 x i8]* @str_4 to %ConstCharStr
    %10 = load i32, i32* %8
    %11 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %9, i32 %10)
    %12 = load %Node*, %Node** %pn
    %13 = call %Node*(%Node*) @linked_list_node_prev_get (%Node* %12)
    store %Node* %13, %Node** %pn
    br label %again_1
break_1:
    ret void
}

define i32 @main() {
    %1 = bitcast [21 x i8]* @str_5 to %ConstCharStr
    %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
    %3 = call %List*() @linked_list_create ()
    %4 = icmp eq %List* %3, null
    br i1 %4 , label %then_0, label %endif_0
then_0:
    %5 = bitcast [26 x i8]* @str_6 to %ConstCharStr
    %6 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %5)
    ret i32 1
    br label %endif_0
endif_0:
; add some Nat64 values to list
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 0)
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 10)
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 20)
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 30)
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 40)
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 50)
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 60)
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 70)
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 80)
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 90)
    call void(%List*, i64) @nat64_list_insert (%List* %3, i64 100)
; print list size
    %8 = call i32(%List*) @linked_list_size_get (%List* %3)
    %9 = bitcast [22 x i8]* @str_7 to %ConstCharStr
    %10 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %9, i32 %8)
; print list forward
    call void(%List*) @list_print_forward (%List* %3)
; print list backward
    call void(%List*) @list_print_backward (%List* %3)
    ret i32 0
}


