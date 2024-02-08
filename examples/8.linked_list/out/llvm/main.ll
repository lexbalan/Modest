
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
declare i8* @malloc(%SizeT %size)
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
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




%FposT = type opaque
%FILE = type opaque

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
    %1 = call i8* (%SizeT) @malloc(%SizeT 8)
    %2 = bitcast i8* %1 to i64*
    store i64 %x, i64* %2
    %3 = bitcast i64* %2 to i8*
    %4 = call %Node* (%List*, i8*) @linked_list_insert(%List* %list, i8* %3)
    ret void
}



define void @list_print_forward(%List* %list) {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*))
    %2 = call %Node* (%List*) @linked_list_first_get(%List* %list)
    %3 = alloca %Node*
    store %Node* %2, %Node** %3
    br label %again_1
again_1:
    %4 = load %Node*, %Node** %3
    %5 = icmp ne %Node* %4, null
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load %Node*, %Node** %3
    %7 = call i8* (%Node*) @linked_list_node_link_get(%Node* %6)
    %8 = bitcast i8* %7 to i32*
    %9 = load i32, i32* %8
    %10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str2 to [0 x i8]*), i32 %9)
    %11 = load %Node*, %Node** %3
    %12 = call %Node* (%Node*) @linked_list_node_next_get(%Node* %11)
    store %Node* %12, %Node** %3
    br label %again_1
break_1:
    ret void
}



define void @list_print_backward(%List* %list) {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str3 to [0 x i8]*))
    %2 = call %Node* (%List*) @linked_list_last_get(%List* %list)
    %3 = alloca %Node*
    store %Node* %2, %Node** %3
    br label %again_1
again_1:
    %4 = load %Node*, %Node** %3
    %5 = icmp ne %Node* %4, null
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load %Node*, %Node** %3
    %7 = call i8* (%Node*) @linked_list_node_link_get(%Node* %6)
    %8 = bitcast i8* %7 to i32*
    %9 = load i32, i32* %8
    %10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str4 to [0 x i8]*), i32 %9)
    %11 = load %Node*, %Node** %3
    %12 = call %Node* (%Node*) @linked_list_node_prev_get(%Node* %11)
    store %Node* %12, %Node** %3
    br label %again_1
break_1:
    ret void
}

define %Int @main() {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*))
    %2 = call %List* () @linked_list_create()
    %3 = icmp eq %List* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
    ret %Int 1
    br label %endif_0
endif_0:
    ; add some Nat64 values to list
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 0)
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 10)
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 20)
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 30)
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 40)
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 50)
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 60)
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 70)
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 80)
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 90)
    call void (%List*, i64) @nat64_list_insert(%List* %2, i64 100)
    ; print list size
    %6 = call i32 (%List*) @linked_list_size_get(%List* %2)
    %7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str7 to [0 x i8]*), i32 %6)
    ; print list forward
    call void (%List*) @list_print_forward(%List* %2)
    ; print list backward
    call void (%List*) @list_print_backward(%List* %2)
    ret %Int 0
}


