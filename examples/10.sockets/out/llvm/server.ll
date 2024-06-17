
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




%Socklen_T = type i32
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64
%OffT = type i64
%PtrToConst = type i8*


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


declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, ...)


declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, ...)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, ...)
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdlib.hm



declare void @abort()
declare %Int @abs(%Int %x)
declare %Int @atexit(void ()* %x)
declare %Double @atof([0 x %ConstChar]* %nptr)
declare %Int @atoi([0 x %ConstChar]* %nptr)
declare %LongInt @atol([0 x %ConstChar]* %nptr)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare void @exit(%Int %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare %LongInt @labs(%LongInt %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(%SizeT %size)
declare %Int @system([0 x %ConstChar]* %string)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/socket.hm




%In_addr_t = type i32
%In_port_t = type i16
%Socklen_t = type i32
%Struct_sockaddr = type {
	%UnsignedShort, 
	[14 x i8]
}

%Struct_in_addr = type {
	%In_addr_t
}

%Struct_sockaddr_in = type {
	i8, 
	i8, 
	%UnsignedShort, 
	%Struct_in_addr, 
	[8 x i8]
}





















































































declare %In_addr_t @inet_addr([0 x %ConstChar]* %cp)


declare %Int @socket(%Int %domain, %Int %type, %Int %protocol)
declare %Int @bind(%Int %sockfd, %Struct_sockaddr* %addr, %Socklen_t %addrlen)
declare %Int @listen(%Int %sockfd, %Int %backlog)
declare %Int @connect(%Int %sockfd, %Struct_sockaddr* %addr, %Socklen_t %addrlen)
declare %SSizeT @send(%Int %socket, i8* %buffer, %SizeT %length, %Int %flags)
declare %SSizeT @recv(%Int %sockfd, i8* %buf, %SizeT %len, %Int %flags)


declare %Int @accept(%Int %s, %Struct_sockaddr* %addr, %Socklen_t* %addrlen)


; -- SOURCE: src/server.cm

@str1 = private constant [10 x i8] [i8 102, i8 105, i8 108, i8 101, i8 50, i8 46, i8 116, i8 120, i8 116, i8 0]
@str2 = private constant [2 x i8] [i8 119, i8 0]
@str3 = private constant [27 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 105, i8 110, i8 103, i8 32, i8 102, i8 105, i8 108, i8 101, i8 0]
@str4 = private constant [3 x i8] [i8 37, i8 115, i8 0]
@str5 = private constant [20 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 0]
@str6 = private constant [27 x i8] [i8 91, i8 43, i8 93, i8 32, i8 83, i8 101, i8 114, i8 118, i8 101, i8 114, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 100, i8 10, i8 0]
@str7 = private constant [10 x i8] [i8 49, i8 50, i8 55, i8 46, i8 48, i8 46, i8 48, i8 46, i8 49, i8 0]
@str8 = private constant [21 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 66, i8 105, i8 110, i8 100, i8 105, i8 110, i8 103, i8 0]
@str9 = private constant [25 x i8] [i8 91, i8 43, i8 93, i8 32, i8 66, i8 105, i8 110, i8 100, i8 105, i8 110, i8 103, i8 32, i8 83, i8 117, i8 99, i8 99, i8 101, i8 115, i8 115, i8 102, i8 117, i8 108, i8 108, i8 10, i8 0]
@str10 = private constant [21 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 66, i8 105, i8 110, i8 100, i8 105, i8 110, i8 103, i8 0]
@str11 = private constant [18 x i8] [i8 91, i8 43, i8 93, i8 32, i8 76, i8 105, i8 115, i8 116, i8 101, i8 110, i8 105, i8 110, i8 103, i8 46, i8 46, i8 46, i8 10, i8 0]
@str12 = private constant [34 x i8] [i8 91, i8 43, i8 93, i8 32, i8 68, i8 97, i8 116, i8 97, i8 32, i8 119, i8 114, i8 105, i8 116, i8 116, i8 101, i8 110, i8 32, i8 105, i8 110, i8 32, i8 116, i8 104, i8 101, i8 32, i8 116, i8 101, i8 120, i8 116, i8 32, i8 102, i8 105, i8 108, i8 101, i8 0]




define void @write_file(%Int %sockfd) {
	%1 = alloca [1024 x i8], align 1
	%2 = call %File* @fopen(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
	%3 = icmp eq %File* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([27 x i8]* @str3 to [0 x i8]*))
	call void @exit(%Int 1)
	br label %endif_0
endif_0:
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%4 = bitcast [1024 x i8]* %1 to i8*
	%5 = call %SSizeT @recv(%Int %sockfd, i8* %4, %SizeT 1024, %Int 0)
	%6 = icmp sle %SSizeT %5, 0
	br i1 %6 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	%8 = call %Int (%File*, %Str*, ...) @fprintf(%File* %2, %Str* bitcast ([3 x i8]* @str4 to [0 x i8]*), [1024 x i8]* %1)
	; -- STMT ASSIGN ARRAY --
	%9 = insertvalue [1024 x i8] zeroinitializer, i8 0, 0
	%10 = insertvalue [1024 x i8] %9, i8 0, 1
	%11 = insertvalue [1024 x i8] %10, i8 0, 2
	%12 = insertvalue [1024 x i8] %11, i8 0, 3
	%13 = insertvalue [1024 x i8] %12, i8 0, 4
	%14 = insertvalue [1024 x i8] %13, i8 0, 5
	%15 = insertvalue [1024 x i8] %14, i8 0, 6
	%16 = insertvalue [1024 x i8] %15, i8 0, 7
	%17 = insertvalue [1024 x i8] %16, i8 0, 8
	%18 = insertvalue [1024 x i8] %17, i8 0, 9
	%19 = insertvalue [1024 x i8] %18, i8 0, 10
	%20 = insertvalue [1024 x i8] %19, i8 0, 11
	%21 = insertvalue [1024 x i8] %20, i8 0, 12
	%22 = insertvalue [1024 x i8] %21, i8 0, 13
	%23 = insertvalue [1024 x i8] %22, i8 0, 14
	%24 = insertvalue [1024 x i8] %23, i8 0, 15
	%25 = insertvalue [1024 x i8] %24, i8 0, 16
	%26 = insertvalue [1024 x i8] %25, i8 0, 17
	%27 = insertvalue [1024 x i8] %26, i8 0, 18
	%28 = insertvalue [1024 x i8] %27, i8 0, 19
	%29 = insertvalue [1024 x i8] %28, i8 0, 20
	%30 = insertvalue [1024 x i8] %29, i8 0, 21
	%31 = insertvalue [1024 x i8] %30, i8 0, 22
	%32 = insertvalue [1024 x i8] %31, i8 0, 23
	%33 = insertvalue [1024 x i8] %32, i8 0, 24
	%34 = insertvalue [1024 x i8] %33, i8 0, 25
	%35 = insertvalue [1024 x i8] %34, i8 0, 26
	%36 = insertvalue [1024 x i8] %35, i8 0, 27
	%37 = insertvalue [1024 x i8] %36, i8 0, 28
	%38 = insertvalue [1024 x i8] %37, i8 0, 29
	%39 = insertvalue [1024 x i8] %38, i8 0, 30
	%40 = insertvalue [1024 x i8] %39, i8 0, 31
	%41 = insertvalue [1024 x i8] %40, i8 0, 32
	%42 = insertvalue [1024 x i8] %41, i8 0, 33
	%43 = insertvalue [1024 x i8] %42, i8 0, 34
	%44 = insertvalue [1024 x i8] %43, i8 0, 35
	%45 = insertvalue [1024 x i8] %44, i8 0, 36
	%46 = insertvalue [1024 x i8] %45, i8 0, 37
	%47 = insertvalue [1024 x i8] %46, i8 0, 38
	%48 = insertvalue [1024 x i8] %47, i8 0, 39
	%49 = insertvalue [1024 x i8] %48, i8 0, 40
	%50 = insertvalue [1024 x i8] %49, i8 0, 41
	%51 = insertvalue [1024 x i8] %50, i8 0, 42
	%52 = insertvalue [1024 x i8] %51, i8 0, 43
	%53 = insertvalue [1024 x i8] %52, i8 0, 44
	%54 = insertvalue [1024 x i8] %53, i8 0, 45
	%55 = insertvalue [1024 x i8] %54, i8 0, 46
	%56 = insertvalue [1024 x i8] %55, i8 0, 47
	%57 = insertvalue [1024 x i8] %56, i8 0, 48
	%58 = insertvalue [1024 x i8] %57, i8 0, 49
	%59 = insertvalue [1024 x i8] %58, i8 0, 50
	%60 = insertvalue [1024 x i8] %59, i8 0, 51
	%61 = insertvalue [1024 x i8] %60, i8 0, 52
	%62 = insertvalue [1024 x i8] %61, i8 0, 53
	%63 = insertvalue [1024 x i8] %62, i8 0, 54
	%64 = insertvalue [1024 x i8] %63, i8 0, 55
	%65 = insertvalue [1024 x i8] %64, i8 0, 56
	%66 = insertvalue [1024 x i8] %65, i8 0, 57
	%67 = insertvalue [1024 x i8] %66, i8 0, 58
	%68 = insertvalue [1024 x i8] %67, i8 0, 59
	%69 = insertvalue [1024 x i8] %68, i8 0, 60
	%70 = insertvalue [1024 x i8] %69, i8 0, 61
	%71 = insertvalue [1024 x i8] %70, i8 0, 62
	%72 = insertvalue [1024 x i8] %71, i8 0, 63
	%73 = insertvalue [1024 x i8] %72, i8 0, 64
	%74 = insertvalue [1024 x i8] %73, i8 0, 65
	%75 = insertvalue [1024 x i8] %74, i8 0, 66
	%76 = insertvalue [1024 x i8] %75, i8 0, 67
	%77 = insertvalue [1024 x i8] %76, i8 0, 68
	%78 = insertvalue [1024 x i8] %77, i8 0, 69
	%79 = insertvalue [1024 x i8] %78, i8 0, 70
	%80 = insertvalue [1024 x i8] %79, i8 0, 71
	%81 = insertvalue [1024 x i8] %80, i8 0, 72
	%82 = insertvalue [1024 x i8] %81, i8 0, 73
	%83 = insertvalue [1024 x i8] %82, i8 0, 74
	%84 = insertvalue [1024 x i8] %83, i8 0, 75
	%85 = insertvalue [1024 x i8] %84, i8 0, 76
	%86 = insertvalue [1024 x i8] %85, i8 0, 77
	%87 = insertvalue [1024 x i8] %86, i8 0, 78
	%88 = insertvalue [1024 x i8] %87, i8 0, 79
	%89 = insertvalue [1024 x i8] %88, i8 0, 80
	%90 = insertvalue [1024 x i8] %89, i8 0, 81
	%91 = insertvalue [1024 x i8] %90, i8 0, 82
	%92 = insertvalue [1024 x i8] %91, i8 0, 83
	%93 = insertvalue [1024 x i8] %92, i8 0, 84
	%94 = insertvalue [1024 x i8] %93, i8 0, 85
	%95 = insertvalue [1024 x i8] %94, i8 0, 86
	%96 = insertvalue [1024 x i8] %95, i8 0, 87
	%97 = insertvalue [1024 x i8] %96, i8 0, 88
	%98 = insertvalue [1024 x i8] %97, i8 0, 89
	%99 = insertvalue [1024 x i8] %98, i8 0, 90
	%100 = insertvalue [1024 x i8] %99, i8 0, 91
	%101 = insertvalue [1024 x i8] %100, i8 0, 92
	%102 = insertvalue [1024 x i8] %101, i8 0, 93
	%103 = insertvalue [1024 x i8] %102, i8 0, 94
	%104 = insertvalue [1024 x i8] %103, i8 0, 95
	%105 = insertvalue [1024 x i8] %104, i8 0, 96
	%106 = insertvalue [1024 x i8] %105, i8 0, 97
	%107 = insertvalue [1024 x i8] %106, i8 0, 98
	%108 = insertvalue [1024 x i8] %107, i8 0, 99
	%109 = insertvalue [1024 x i8] %108, i8 0, 100
	%110 = insertvalue [1024 x i8] %109, i8 0, 101
	%111 = insertvalue [1024 x i8] %110, i8 0, 102
	%112 = insertvalue [1024 x i8] %111, i8 0, 103
	%113 = insertvalue [1024 x i8] %112, i8 0, 104
	%114 = insertvalue [1024 x i8] %113, i8 0, 105
	%115 = insertvalue [1024 x i8] %114, i8 0, 106
	%116 = insertvalue [1024 x i8] %115, i8 0, 107
	%117 = insertvalue [1024 x i8] %116, i8 0, 108
	%118 = insertvalue [1024 x i8] %117, i8 0, 109
	%119 = insertvalue [1024 x i8] %118, i8 0, 110
	%120 = insertvalue [1024 x i8] %119, i8 0, 111
	%121 = insertvalue [1024 x i8] %120, i8 0, 112
	%122 = insertvalue [1024 x i8] %121, i8 0, 113
	%123 = insertvalue [1024 x i8] %122, i8 0, 114
	%124 = insertvalue [1024 x i8] %123, i8 0, 115
	%125 = insertvalue [1024 x i8] %124, i8 0, 116
	%126 = insertvalue [1024 x i8] %125, i8 0, 117
	%127 = insertvalue [1024 x i8] %126, i8 0, 118
	%128 = insertvalue [1024 x i8] %127, i8 0, 119
	%129 = insertvalue [1024 x i8] %128, i8 0, 120
	%130 = insertvalue [1024 x i8] %129, i8 0, 121
	%131 = insertvalue [1024 x i8] %130, i8 0, 122
	%132 = insertvalue [1024 x i8] %131, i8 0, 123
	%133 = insertvalue [1024 x i8] %132, i8 0, 124
	%134 = insertvalue [1024 x i8] %133, i8 0, 125
	%135 = insertvalue [1024 x i8] %134, i8 0, 126
	%136 = insertvalue [1024 x i8] %135, i8 0, 127
	%137 = insertvalue [1024 x i8] %136, i8 0, 128
	%138 = insertvalue [1024 x i8] %137, i8 0, 129
	%139 = insertvalue [1024 x i8] %138, i8 0, 130
	%140 = insertvalue [1024 x i8] %139, i8 0, 131
	%141 = insertvalue [1024 x i8] %140, i8 0, 132
	%142 = insertvalue [1024 x i8] %141, i8 0, 133
	%143 = insertvalue [1024 x i8] %142, i8 0, 134
	%144 = insertvalue [1024 x i8] %143, i8 0, 135
	%145 = insertvalue [1024 x i8] %144, i8 0, 136
	%146 = insertvalue [1024 x i8] %145, i8 0, 137
	%147 = insertvalue [1024 x i8] %146, i8 0, 138
	%148 = insertvalue [1024 x i8] %147, i8 0, 139
	%149 = insertvalue [1024 x i8] %148, i8 0, 140
	%150 = insertvalue [1024 x i8] %149, i8 0, 141
	%151 = insertvalue [1024 x i8] %150, i8 0, 142
	%152 = insertvalue [1024 x i8] %151, i8 0, 143
	%153 = insertvalue [1024 x i8] %152, i8 0, 144
	%154 = insertvalue [1024 x i8] %153, i8 0, 145
	%155 = insertvalue [1024 x i8] %154, i8 0, 146
	%156 = insertvalue [1024 x i8] %155, i8 0, 147
	%157 = insertvalue [1024 x i8] %156, i8 0, 148
	%158 = insertvalue [1024 x i8] %157, i8 0, 149
	%159 = insertvalue [1024 x i8] %158, i8 0, 150
	%160 = insertvalue [1024 x i8] %159, i8 0, 151
	%161 = insertvalue [1024 x i8] %160, i8 0, 152
	%162 = insertvalue [1024 x i8] %161, i8 0, 153
	%163 = insertvalue [1024 x i8] %162, i8 0, 154
	%164 = insertvalue [1024 x i8] %163, i8 0, 155
	%165 = insertvalue [1024 x i8] %164, i8 0, 156
	%166 = insertvalue [1024 x i8] %165, i8 0, 157
	%167 = insertvalue [1024 x i8] %166, i8 0, 158
	%168 = insertvalue [1024 x i8] %167, i8 0, 159
	%169 = insertvalue [1024 x i8] %168, i8 0, 160
	%170 = insertvalue [1024 x i8] %169, i8 0, 161
	%171 = insertvalue [1024 x i8] %170, i8 0, 162
	%172 = insertvalue [1024 x i8] %171, i8 0, 163
	%173 = insertvalue [1024 x i8] %172, i8 0, 164
	%174 = insertvalue [1024 x i8] %173, i8 0, 165
	%175 = insertvalue [1024 x i8] %174, i8 0, 166
	%176 = insertvalue [1024 x i8] %175, i8 0, 167
	%177 = insertvalue [1024 x i8] %176, i8 0, 168
	%178 = insertvalue [1024 x i8] %177, i8 0, 169
	%179 = insertvalue [1024 x i8] %178, i8 0, 170
	%180 = insertvalue [1024 x i8] %179, i8 0, 171
	%181 = insertvalue [1024 x i8] %180, i8 0, 172
	%182 = insertvalue [1024 x i8] %181, i8 0, 173
	%183 = insertvalue [1024 x i8] %182, i8 0, 174
	%184 = insertvalue [1024 x i8] %183, i8 0, 175
	%185 = insertvalue [1024 x i8] %184, i8 0, 176
	%186 = insertvalue [1024 x i8] %185, i8 0, 177
	%187 = insertvalue [1024 x i8] %186, i8 0, 178
	%188 = insertvalue [1024 x i8] %187, i8 0, 179
	%189 = insertvalue [1024 x i8] %188, i8 0, 180
	%190 = insertvalue [1024 x i8] %189, i8 0, 181
	%191 = insertvalue [1024 x i8] %190, i8 0, 182
	%192 = insertvalue [1024 x i8] %191, i8 0, 183
	%193 = insertvalue [1024 x i8] %192, i8 0, 184
	%194 = insertvalue [1024 x i8] %193, i8 0, 185
	%195 = insertvalue [1024 x i8] %194, i8 0, 186
	%196 = insertvalue [1024 x i8] %195, i8 0, 187
	%197 = insertvalue [1024 x i8] %196, i8 0, 188
	%198 = insertvalue [1024 x i8] %197, i8 0, 189
	%199 = insertvalue [1024 x i8] %198, i8 0, 190
	%200 = insertvalue [1024 x i8] %199, i8 0, 191
	%201 = insertvalue [1024 x i8] %200, i8 0, 192
	%202 = insertvalue [1024 x i8] %201, i8 0, 193
	%203 = insertvalue [1024 x i8] %202, i8 0, 194
	%204 = insertvalue [1024 x i8] %203, i8 0, 195
	%205 = insertvalue [1024 x i8] %204, i8 0, 196
	%206 = insertvalue [1024 x i8] %205, i8 0, 197
	%207 = insertvalue [1024 x i8] %206, i8 0, 198
	%208 = insertvalue [1024 x i8] %207, i8 0, 199
	%209 = insertvalue [1024 x i8] %208, i8 0, 200
	%210 = insertvalue [1024 x i8] %209, i8 0, 201
	%211 = insertvalue [1024 x i8] %210, i8 0, 202
	%212 = insertvalue [1024 x i8] %211, i8 0, 203
	%213 = insertvalue [1024 x i8] %212, i8 0, 204
	%214 = insertvalue [1024 x i8] %213, i8 0, 205
	%215 = insertvalue [1024 x i8] %214, i8 0, 206
	%216 = insertvalue [1024 x i8] %215, i8 0, 207
	%217 = insertvalue [1024 x i8] %216, i8 0, 208
	%218 = insertvalue [1024 x i8] %217, i8 0, 209
	%219 = insertvalue [1024 x i8] %218, i8 0, 210
	%220 = insertvalue [1024 x i8] %219, i8 0, 211
	%221 = insertvalue [1024 x i8] %220, i8 0, 212
	%222 = insertvalue [1024 x i8] %221, i8 0, 213
	%223 = insertvalue [1024 x i8] %222, i8 0, 214
	%224 = insertvalue [1024 x i8] %223, i8 0, 215
	%225 = insertvalue [1024 x i8] %224, i8 0, 216
	%226 = insertvalue [1024 x i8] %225, i8 0, 217
	%227 = insertvalue [1024 x i8] %226, i8 0, 218
	%228 = insertvalue [1024 x i8] %227, i8 0, 219
	%229 = insertvalue [1024 x i8] %228, i8 0, 220
	%230 = insertvalue [1024 x i8] %229, i8 0, 221
	%231 = insertvalue [1024 x i8] %230, i8 0, 222
	%232 = insertvalue [1024 x i8] %231, i8 0, 223
	%233 = insertvalue [1024 x i8] %232, i8 0, 224
	%234 = insertvalue [1024 x i8] %233, i8 0, 225
	%235 = insertvalue [1024 x i8] %234, i8 0, 226
	%236 = insertvalue [1024 x i8] %235, i8 0, 227
	%237 = insertvalue [1024 x i8] %236, i8 0, 228
	%238 = insertvalue [1024 x i8] %237, i8 0, 229
	%239 = insertvalue [1024 x i8] %238, i8 0, 230
	%240 = insertvalue [1024 x i8] %239, i8 0, 231
	%241 = insertvalue [1024 x i8] %240, i8 0, 232
	%242 = insertvalue [1024 x i8] %241, i8 0, 233
	%243 = insertvalue [1024 x i8] %242, i8 0, 234
	%244 = insertvalue [1024 x i8] %243, i8 0, 235
	%245 = insertvalue [1024 x i8] %244, i8 0, 236
	%246 = insertvalue [1024 x i8] %245, i8 0, 237
	%247 = insertvalue [1024 x i8] %246, i8 0, 238
	%248 = insertvalue [1024 x i8] %247, i8 0, 239
	%249 = insertvalue [1024 x i8] %248, i8 0, 240
	%250 = insertvalue [1024 x i8] %249, i8 0, 241
	%251 = insertvalue [1024 x i8] %250, i8 0, 242
	%252 = insertvalue [1024 x i8] %251, i8 0, 243
	%253 = insertvalue [1024 x i8] %252, i8 0, 244
	%254 = insertvalue [1024 x i8] %253, i8 0, 245
	%255 = insertvalue [1024 x i8] %254, i8 0, 246
	%256 = insertvalue [1024 x i8] %255, i8 0, 247
	%257 = insertvalue [1024 x i8] %256, i8 0, 248
	%258 = insertvalue [1024 x i8] %257, i8 0, 249
	%259 = insertvalue [1024 x i8] %258, i8 0, 250
	%260 = insertvalue [1024 x i8] %259, i8 0, 251
	%261 = insertvalue [1024 x i8] %260, i8 0, 252
	%262 = insertvalue [1024 x i8] %261, i8 0, 253
	%263 = insertvalue [1024 x i8] %262, i8 0, 254
	%264 = insertvalue [1024 x i8] %263, i8 0, 255
	%265 = insertvalue [1024 x i8] %264, i8 0, 256
	%266 = insertvalue [1024 x i8] %265, i8 0, 257
	%267 = insertvalue [1024 x i8] %266, i8 0, 258
	%268 = insertvalue [1024 x i8] %267, i8 0, 259
	%269 = insertvalue [1024 x i8] %268, i8 0, 260
	%270 = insertvalue [1024 x i8] %269, i8 0, 261
	%271 = insertvalue [1024 x i8] %270, i8 0, 262
	%272 = insertvalue [1024 x i8] %271, i8 0, 263
	%273 = insertvalue [1024 x i8] %272, i8 0, 264
	%274 = insertvalue [1024 x i8] %273, i8 0, 265
	%275 = insertvalue [1024 x i8] %274, i8 0, 266
	%276 = insertvalue [1024 x i8] %275, i8 0, 267
	%277 = insertvalue [1024 x i8] %276, i8 0, 268
	%278 = insertvalue [1024 x i8] %277, i8 0, 269
	%279 = insertvalue [1024 x i8] %278, i8 0, 270
	%280 = insertvalue [1024 x i8] %279, i8 0, 271
	%281 = insertvalue [1024 x i8] %280, i8 0, 272
	%282 = insertvalue [1024 x i8] %281, i8 0, 273
	%283 = insertvalue [1024 x i8] %282, i8 0, 274
	%284 = insertvalue [1024 x i8] %283, i8 0, 275
	%285 = insertvalue [1024 x i8] %284, i8 0, 276
	%286 = insertvalue [1024 x i8] %285, i8 0, 277
	%287 = insertvalue [1024 x i8] %286, i8 0, 278
	%288 = insertvalue [1024 x i8] %287, i8 0, 279
	%289 = insertvalue [1024 x i8] %288, i8 0, 280
	%290 = insertvalue [1024 x i8] %289, i8 0, 281
	%291 = insertvalue [1024 x i8] %290, i8 0, 282
	%292 = insertvalue [1024 x i8] %291, i8 0, 283
	%293 = insertvalue [1024 x i8] %292, i8 0, 284
	%294 = insertvalue [1024 x i8] %293, i8 0, 285
	%295 = insertvalue [1024 x i8] %294, i8 0, 286
	%296 = insertvalue [1024 x i8] %295, i8 0, 287
	%297 = insertvalue [1024 x i8] %296, i8 0, 288
	%298 = insertvalue [1024 x i8] %297, i8 0, 289
	%299 = insertvalue [1024 x i8] %298, i8 0, 290
	%300 = insertvalue [1024 x i8] %299, i8 0, 291
	%301 = insertvalue [1024 x i8] %300, i8 0, 292
	%302 = insertvalue [1024 x i8] %301, i8 0, 293
	%303 = insertvalue [1024 x i8] %302, i8 0, 294
	%304 = insertvalue [1024 x i8] %303, i8 0, 295
	%305 = insertvalue [1024 x i8] %304, i8 0, 296
	%306 = insertvalue [1024 x i8] %305, i8 0, 297
	%307 = insertvalue [1024 x i8] %306, i8 0, 298
	%308 = insertvalue [1024 x i8] %307, i8 0, 299
	%309 = insertvalue [1024 x i8] %308, i8 0, 300
	%310 = insertvalue [1024 x i8] %309, i8 0, 301
	%311 = insertvalue [1024 x i8] %310, i8 0, 302
	%312 = insertvalue [1024 x i8] %311, i8 0, 303
	%313 = insertvalue [1024 x i8] %312, i8 0, 304
	%314 = insertvalue [1024 x i8] %313, i8 0, 305
	%315 = insertvalue [1024 x i8] %314, i8 0, 306
	%316 = insertvalue [1024 x i8] %315, i8 0, 307
	%317 = insertvalue [1024 x i8] %316, i8 0, 308
	%318 = insertvalue [1024 x i8] %317, i8 0, 309
	%319 = insertvalue [1024 x i8] %318, i8 0, 310
	%320 = insertvalue [1024 x i8] %319, i8 0, 311
	%321 = insertvalue [1024 x i8] %320, i8 0, 312
	%322 = insertvalue [1024 x i8] %321, i8 0, 313
	%323 = insertvalue [1024 x i8] %322, i8 0, 314
	%324 = insertvalue [1024 x i8] %323, i8 0, 315
	%325 = insertvalue [1024 x i8] %324, i8 0, 316
	%326 = insertvalue [1024 x i8] %325, i8 0, 317
	%327 = insertvalue [1024 x i8] %326, i8 0, 318
	%328 = insertvalue [1024 x i8] %327, i8 0, 319
	%329 = insertvalue [1024 x i8] %328, i8 0, 320
	%330 = insertvalue [1024 x i8] %329, i8 0, 321
	%331 = insertvalue [1024 x i8] %330, i8 0, 322
	%332 = insertvalue [1024 x i8] %331, i8 0, 323
	%333 = insertvalue [1024 x i8] %332, i8 0, 324
	%334 = insertvalue [1024 x i8] %333, i8 0, 325
	%335 = insertvalue [1024 x i8] %334, i8 0, 326
	%336 = insertvalue [1024 x i8] %335, i8 0, 327
	%337 = insertvalue [1024 x i8] %336, i8 0, 328
	%338 = insertvalue [1024 x i8] %337, i8 0, 329
	%339 = insertvalue [1024 x i8] %338, i8 0, 330
	%340 = insertvalue [1024 x i8] %339, i8 0, 331
	%341 = insertvalue [1024 x i8] %340, i8 0, 332
	%342 = insertvalue [1024 x i8] %341, i8 0, 333
	%343 = insertvalue [1024 x i8] %342, i8 0, 334
	%344 = insertvalue [1024 x i8] %343, i8 0, 335
	%345 = insertvalue [1024 x i8] %344, i8 0, 336
	%346 = insertvalue [1024 x i8] %345, i8 0, 337
	%347 = insertvalue [1024 x i8] %346, i8 0, 338
	%348 = insertvalue [1024 x i8] %347, i8 0, 339
	%349 = insertvalue [1024 x i8] %348, i8 0, 340
	%350 = insertvalue [1024 x i8] %349, i8 0, 341
	%351 = insertvalue [1024 x i8] %350, i8 0, 342
	%352 = insertvalue [1024 x i8] %351, i8 0, 343
	%353 = insertvalue [1024 x i8] %352, i8 0, 344
	%354 = insertvalue [1024 x i8] %353, i8 0, 345
	%355 = insertvalue [1024 x i8] %354, i8 0, 346
	%356 = insertvalue [1024 x i8] %355, i8 0, 347
	%357 = insertvalue [1024 x i8] %356, i8 0, 348
	%358 = insertvalue [1024 x i8] %357, i8 0, 349
	%359 = insertvalue [1024 x i8] %358, i8 0, 350
	%360 = insertvalue [1024 x i8] %359, i8 0, 351
	%361 = insertvalue [1024 x i8] %360, i8 0, 352
	%362 = insertvalue [1024 x i8] %361, i8 0, 353
	%363 = insertvalue [1024 x i8] %362, i8 0, 354
	%364 = insertvalue [1024 x i8] %363, i8 0, 355
	%365 = insertvalue [1024 x i8] %364, i8 0, 356
	%366 = insertvalue [1024 x i8] %365, i8 0, 357
	%367 = insertvalue [1024 x i8] %366, i8 0, 358
	%368 = insertvalue [1024 x i8] %367, i8 0, 359
	%369 = insertvalue [1024 x i8] %368, i8 0, 360
	%370 = insertvalue [1024 x i8] %369, i8 0, 361
	%371 = insertvalue [1024 x i8] %370, i8 0, 362
	%372 = insertvalue [1024 x i8] %371, i8 0, 363
	%373 = insertvalue [1024 x i8] %372, i8 0, 364
	%374 = insertvalue [1024 x i8] %373, i8 0, 365
	%375 = insertvalue [1024 x i8] %374, i8 0, 366
	%376 = insertvalue [1024 x i8] %375, i8 0, 367
	%377 = insertvalue [1024 x i8] %376, i8 0, 368
	%378 = insertvalue [1024 x i8] %377, i8 0, 369
	%379 = insertvalue [1024 x i8] %378, i8 0, 370
	%380 = insertvalue [1024 x i8] %379, i8 0, 371
	%381 = insertvalue [1024 x i8] %380, i8 0, 372
	%382 = insertvalue [1024 x i8] %381, i8 0, 373
	%383 = insertvalue [1024 x i8] %382, i8 0, 374
	%384 = insertvalue [1024 x i8] %383, i8 0, 375
	%385 = insertvalue [1024 x i8] %384, i8 0, 376
	%386 = insertvalue [1024 x i8] %385, i8 0, 377
	%387 = insertvalue [1024 x i8] %386, i8 0, 378
	%388 = insertvalue [1024 x i8] %387, i8 0, 379
	%389 = insertvalue [1024 x i8] %388, i8 0, 380
	%390 = insertvalue [1024 x i8] %389, i8 0, 381
	%391 = insertvalue [1024 x i8] %390, i8 0, 382
	%392 = insertvalue [1024 x i8] %391, i8 0, 383
	%393 = insertvalue [1024 x i8] %392, i8 0, 384
	%394 = insertvalue [1024 x i8] %393, i8 0, 385
	%395 = insertvalue [1024 x i8] %394, i8 0, 386
	%396 = insertvalue [1024 x i8] %395, i8 0, 387
	%397 = insertvalue [1024 x i8] %396, i8 0, 388
	%398 = insertvalue [1024 x i8] %397, i8 0, 389
	%399 = insertvalue [1024 x i8] %398, i8 0, 390
	%400 = insertvalue [1024 x i8] %399, i8 0, 391
	%401 = insertvalue [1024 x i8] %400, i8 0, 392
	%402 = insertvalue [1024 x i8] %401, i8 0, 393
	%403 = insertvalue [1024 x i8] %402, i8 0, 394
	%404 = insertvalue [1024 x i8] %403, i8 0, 395
	%405 = insertvalue [1024 x i8] %404, i8 0, 396
	%406 = insertvalue [1024 x i8] %405, i8 0, 397
	%407 = insertvalue [1024 x i8] %406, i8 0, 398
	%408 = insertvalue [1024 x i8] %407, i8 0, 399
	%409 = insertvalue [1024 x i8] %408, i8 0, 400
	%410 = insertvalue [1024 x i8] %409, i8 0, 401
	%411 = insertvalue [1024 x i8] %410, i8 0, 402
	%412 = insertvalue [1024 x i8] %411, i8 0, 403
	%413 = insertvalue [1024 x i8] %412, i8 0, 404
	%414 = insertvalue [1024 x i8] %413, i8 0, 405
	%415 = insertvalue [1024 x i8] %414, i8 0, 406
	%416 = insertvalue [1024 x i8] %415, i8 0, 407
	%417 = insertvalue [1024 x i8] %416, i8 0, 408
	%418 = insertvalue [1024 x i8] %417, i8 0, 409
	%419 = insertvalue [1024 x i8] %418, i8 0, 410
	%420 = insertvalue [1024 x i8] %419, i8 0, 411
	%421 = insertvalue [1024 x i8] %420, i8 0, 412
	%422 = insertvalue [1024 x i8] %421, i8 0, 413
	%423 = insertvalue [1024 x i8] %422, i8 0, 414
	%424 = insertvalue [1024 x i8] %423, i8 0, 415
	%425 = insertvalue [1024 x i8] %424, i8 0, 416
	%426 = insertvalue [1024 x i8] %425, i8 0, 417
	%427 = insertvalue [1024 x i8] %426, i8 0, 418
	%428 = insertvalue [1024 x i8] %427, i8 0, 419
	%429 = insertvalue [1024 x i8] %428, i8 0, 420
	%430 = insertvalue [1024 x i8] %429, i8 0, 421
	%431 = insertvalue [1024 x i8] %430, i8 0, 422
	%432 = insertvalue [1024 x i8] %431, i8 0, 423
	%433 = insertvalue [1024 x i8] %432, i8 0, 424
	%434 = insertvalue [1024 x i8] %433, i8 0, 425
	%435 = insertvalue [1024 x i8] %434, i8 0, 426
	%436 = insertvalue [1024 x i8] %435, i8 0, 427
	%437 = insertvalue [1024 x i8] %436, i8 0, 428
	%438 = insertvalue [1024 x i8] %437, i8 0, 429
	%439 = insertvalue [1024 x i8] %438, i8 0, 430
	%440 = insertvalue [1024 x i8] %439, i8 0, 431
	%441 = insertvalue [1024 x i8] %440, i8 0, 432
	%442 = insertvalue [1024 x i8] %441, i8 0, 433
	%443 = insertvalue [1024 x i8] %442, i8 0, 434
	%444 = insertvalue [1024 x i8] %443, i8 0, 435
	%445 = insertvalue [1024 x i8] %444, i8 0, 436
	%446 = insertvalue [1024 x i8] %445, i8 0, 437
	%447 = insertvalue [1024 x i8] %446, i8 0, 438
	%448 = insertvalue [1024 x i8] %447, i8 0, 439
	%449 = insertvalue [1024 x i8] %448, i8 0, 440
	%450 = insertvalue [1024 x i8] %449, i8 0, 441
	%451 = insertvalue [1024 x i8] %450, i8 0, 442
	%452 = insertvalue [1024 x i8] %451, i8 0, 443
	%453 = insertvalue [1024 x i8] %452, i8 0, 444
	%454 = insertvalue [1024 x i8] %453, i8 0, 445
	%455 = insertvalue [1024 x i8] %454, i8 0, 446
	%456 = insertvalue [1024 x i8] %455, i8 0, 447
	%457 = insertvalue [1024 x i8] %456, i8 0, 448
	%458 = insertvalue [1024 x i8] %457, i8 0, 449
	%459 = insertvalue [1024 x i8] %458, i8 0, 450
	%460 = insertvalue [1024 x i8] %459, i8 0, 451
	%461 = insertvalue [1024 x i8] %460, i8 0, 452
	%462 = insertvalue [1024 x i8] %461, i8 0, 453
	%463 = insertvalue [1024 x i8] %462, i8 0, 454
	%464 = insertvalue [1024 x i8] %463, i8 0, 455
	%465 = insertvalue [1024 x i8] %464, i8 0, 456
	%466 = insertvalue [1024 x i8] %465, i8 0, 457
	%467 = insertvalue [1024 x i8] %466, i8 0, 458
	%468 = insertvalue [1024 x i8] %467, i8 0, 459
	%469 = insertvalue [1024 x i8] %468, i8 0, 460
	%470 = insertvalue [1024 x i8] %469, i8 0, 461
	%471 = insertvalue [1024 x i8] %470, i8 0, 462
	%472 = insertvalue [1024 x i8] %471, i8 0, 463
	%473 = insertvalue [1024 x i8] %472, i8 0, 464
	%474 = insertvalue [1024 x i8] %473, i8 0, 465
	%475 = insertvalue [1024 x i8] %474, i8 0, 466
	%476 = insertvalue [1024 x i8] %475, i8 0, 467
	%477 = insertvalue [1024 x i8] %476, i8 0, 468
	%478 = insertvalue [1024 x i8] %477, i8 0, 469
	%479 = insertvalue [1024 x i8] %478, i8 0, 470
	%480 = insertvalue [1024 x i8] %479, i8 0, 471
	%481 = insertvalue [1024 x i8] %480, i8 0, 472
	%482 = insertvalue [1024 x i8] %481, i8 0, 473
	%483 = insertvalue [1024 x i8] %482, i8 0, 474
	%484 = insertvalue [1024 x i8] %483, i8 0, 475
	%485 = insertvalue [1024 x i8] %484, i8 0, 476
	%486 = insertvalue [1024 x i8] %485, i8 0, 477
	%487 = insertvalue [1024 x i8] %486, i8 0, 478
	%488 = insertvalue [1024 x i8] %487, i8 0, 479
	%489 = insertvalue [1024 x i8] %488, i8 0, 480
	%490 = insertvalue [1024 x i8] %489, i8 0, 481
	%491 = insertvalue [1024 x i8] %490, i8 0, 482
	%492 = insertvalue [1024 x i8] %491, i8 0, 483
	%493 = insertvalue [1024 x i8] %492, i8 0, 484
	%494 = insertvalue [1024 x i8] %493, i8 0, 485
	%495 = insertvalue [1024 x i8] %494, i8 0, 486
	%496 = insertvalue [1024 x i8] %495, i8 0, 487
	%497 = insertvalue [1024 x i8] %496, i8 0, 488
	%498 = insertvalue [1024 x i8] %497, i8 0, 489
	%499 = insertvalue [1024 x i8] %498, i8 0, 490
	%500 = insertvalue [1024 x i8] %499, i8 0, 491
	%501 = insertvalue [1024 x i8] %500, i8 0, 492
	%502 = insertvalue [1024 x i8] %501, i8 0, 493
	%503 = insertvalue [1024 x i8] %502, i8 0, 494
	%504 = insertvalue [1024 x i8] %503, i8 0, 495
	%505 = insertvalue [1024 x i8] %504, i8 0, 496
	%506 = insertvalue [1024 x i8] %505, i8 0, 497
	%507 = insertvalue [1024 x i8] %506, i8 0, 498
	%508 = insertvalue [1024 x i8] %507, i8 0, 499
	%509 = insertvalue [1024 x i8] %508, i8 0, 500
	%510 = insertvalue [1024 x i8] %509, i8 0, 501
	%511 = insertvalue [1024 x i8] %510, i8 0, 502
	%512 = insertvalue [1024 x i8] %511, i8 0, 503
	%513 = insertvalue [1024 x i8] %512, i8 0, 504
	%514 = insertvalue [1024 x i8] %513, i8 0, 505
	%515 = insertvalue [1024 x i8] %514, i8 0, 506
	%516 = insertvalue [1024 x i8] %515, i8 0, 507
	%517 = insertvalue [1024 x i8] %516, i8 0, 508
	%518 = insertvalue [1024 x i8] %517, i8 0, 509
	%519 = insertvalue [1024 x i8] %518, i8 0, 510
	%520 = insertvalue [1024 x i8] %519, i8 0, 511
	%521 = insertvalue [1024 x i8] %520, i8 0, 512
	%522 = insertvalue [1024 x i8] %521, i8 0, 513
	%523 = insertvalue [1024 x i8] %522, i8 0, 514
	%524 = insertvalue [1024 x i8] %523, i8 0, 515
	%525 = insertvalue [1024 x i8] %524, i8 0, 516
	%526 = insertvalue [1024 x i8] %525, i8 0, 517
	%527 = insertvalue [1024 x i8] %526, i8 0, 518
	%528 = insertvalue [1024 x i8] %527, i8 0, 519
	%529 = insertvalue [1024 x i8] %528, i8 0, 520
	%530 = insertvalue [1024 x i8] %529, i8 0, 521
	%531 = insertvalue [1024 x i8] %530, i8 0, 522
	%532 = insertvalue [1024 x i8] %531, i8 0, 523
	%533 = insertvalue [1024 x i8] %532, i8 0, 524
	%534 = insertvalue [1024 x i8] %533, i8 0, 525
	%535 = insertvalue [1024 x i8] %534, i8 0, 526
	%536 = insertvalue [1024 x i8] %535, i8 0, 527
	%537 = insertvalue [1024 x i8] %536, i8 0, 528
	%538 = insertvalue [1024 x i8] %537, i8 0, 529
	%539 = insertvalue [1024 x i8] %538, i8 0, 530
	%540 = insertvalue [1024 x i8] %539, i8 0, 531
	%541 = insertvalue [1024 x i8] %540, i8 0, 532
	%542 = insertvalue [1024 x i8] %541, i8 0, 533
	%543 = insertvalue [1024 x i8] %542, i8 0, 534
	%544 = insertvalue [1024 x i8] %543, i8 0, 535
	%545 = insertvalue [1024 x i8] %544, i8 0, 536
	%546 = insertvalue [1024 x i8] %545, i8 0, 537
	%547 = insertvalue [1024 x i8] %546, i8 0, 538
	%548 = insertvalue [1024 x i8] %547, i8 0, 539
	%549 = insertvalue [1024 x i8] %548, i8 0, 540
	%550 = insertvalue [1024 x i8] %549, i8 0, 541
	%551 = insertvalue [1024 x i8] %550, i8 0, 542
	%552 = insertvalue [1024 x i8] %551, i8 0, 543
	%553 = insertvalue [1024 x i8] %552, i8 0, 544
	%554 = insertvalue [1024 x i8] %553, i8 0, 545
	%555 = insertvalue [1024 x i8] %554, i8 0, 546
	%556 = insertvalue [1024 x i8] %555, i8 0, 547
	%557 = insertvalue [1024 x i8] %556, i8 0, 548
	%558 = insertvalue [1024 x i8] %557, i8 0, 549
	%559 = insertvalue [1024 x i8] %558, i8 0, 550
	%560 = insertvalue [1024 x i8] %559, i8 0, 551
	%561 = insertvalue [1024 x i8] %560, i8 0, 552
	%562 = insertvalue [1024 x i8] %561, i8 0, 553
	%563 = insertvalue [1024 x i8] %562, i8 0, 554
	%564 = insertvalue [1024 x i8] %563, i8 0, 555
	%565 = insertvalue [1024 x i8] %564, i8 0, 556
	%566 = insertvalue [1024 x i8] %565, i8 0, 557
	%567 = insertvalue [1024 x i8] %566, i8 0, 558
	%568 = insertvalue [1024 x i8] %567, i8 0, 559
	%569 = insertvalue [1024 x i8] %568, i8 0, 560
	%570 = insertvalue [1024 x i8] %569, i8 0, 561
	%571 = insertvalue [1024 x i8] %570, i8 0, 562
	%572 = insertvalue [1024 x i8] %571, i8 0, 563
	%573 = insertvalue [1024 x i8] %572, i8 0, 564
	%574 = insertvalue [1024 x i8] %573, i8 0, 565
	%575 = insertvalue [1024 x i8] %574, i8 0, 566
	%576 = insertvalue [1024 x i8] %575, i8 0, 567
	%577 = insertvalue [1024 x i8] %576, i8 0, 568
	%578 = insertvalue [1024 x i8] %577, i8 0, 569
	%579 = insertvalue [1024 x i8] %578, i8 0, 570
	%580 = insertvalue [1024 x i8] %579, i8 0, 571
	%581 = insertvalue [1024 x i8] %580, i8 0, 572
	%582 = insertvalue [1024 x i8] %581, i8 0, 573
	%583 = insertvalue [1024 x i8] %582, i8 0, 574
	%584 = insertvalue [1024 x i8] %583, i8 0, 575
	%585 = insertvalue [1024 x i8] %584, i8 0, 576
	%586 = insertvalue [1024 x i8] %585, i8 0, 577
	%587 = insertvalue [1024 x i8] %586, i8 0, 578
	%588 = insertvalue [1024 x i8] %587, i8 0, 579
	%589 = insertvalue [1024 x i8] %588, i8 0, 580
	%590 = insertvalue [1024 x i8] %589, i8 0, 581
	%591 = insertvalue [1024 x i8] %590, i8 0, 582
	%592 = insertvalue [1024 x i8] %591, i8 0, 583
	%593 = insertvalue [1024 x i8] %592, i8 0, 584
	%594 = insertvalue [1024 x i8] %593, i8 0, 585
	%595 = insertvalue [1024 x i8] %594, i8 0, 586
	%596 = insertvalue [1024 x i8] %595, i8 0, 587
	%597 = insertvalue [1024 x i8] %596, i8 0, 588
	%598 = insertvalue [1024 x i8] %597, i8 0, 589
	%599 = insertvalue [1024 x i8] %598, i8 0, 590
	%600 = insertvalue [1024 x i8] %599, i8 0, 591
	%601 = insertvalue [1024 x i8] %600, i8 0, 592
	%602 = insertvalue [1024 x i8] %601, i8 0, 593
	%603 = insertvalue [1024 x i8] %602, i8 0, 594
	%604 = insertvalue [1024 x i8] %603, i8 0, 595
	%605 = insertvalue [1024 x i8] %604, i8 0, 596
	%606 = insertvalue [1024 x i8] %605, i8 0, 597
	%607 = insertvalue [1024 x i8] %606, i8 0, 598
	%608 = insertvalue [1024 x i8] %607, i8 0, 599
	%609 = insertvalue [1024 x i8] %608, i8 0, 600
	%610 = insertvalue [1024 x i8] %609, i8 0, 601
	%611 = insertvalue [1024 x i8] %610, i8 0, 602
	%612 = insertvalue [1024 x i8] %611, i8 0, 603
	%613 = insertvalue [1024 x i8] %612, i8 0, 604
	%614 = insertvalue [1024 x i8] %613, i8 0, 605
	%615 = insertvalue [1024 x i8] %614, i8 0, 606
	%616 = insertvalue [1024 x i8] %615, i8 0, 607
	%617 = insertvalue [1024 x i8] %616, i8 0, 608
	%618 = insertvalue [1024 x i8] %617, i8 0, 609
	%619 = insertvalue [1024 x i8] %618, i8 0, 610
	%620 = insertvalue [1024 x i8] %619, i8 0, 611
	%621 = insertvalue [1024 x i8] %620, i8 0, 612
	%622 = insertvalue [1024 x i8] %621, i8 0, 613
	%623 = insertvalue [1024 x i8] %622, i8 0, 614
	%624 = insertvalue [1024 x i8] %623, i8 0, 615
	%625 = insertvalue [1024 x i8] %624, i8 0, 616
	%626 = insertvalue [1024 x i8] %625, i8 0, 617
	%627 = insertvalue [1024 x i8] %626, i8 0, 618
	%628 = insertvalue [1024 x i8] %627, i8 0, 619
	%629 = insertvalue [1024 x i8] %628, i8 0, 620
	%630 = insertvalue [1024 x i8] %629, i8 0, 621
	%631 = insertvalue [1024 x i8] %630, i8 0, 622
	%632 = insertvalue [1024 x i8] %631, i8 0, 623
	%633 = insertvalue [1024 x i8] %632, i8 0, 624
	%634 = insertvalue [1024 x i8] %633, i8 0, 625
	%635 = insertvalue [1024 x i8] %634, i8 0, 626
	%636 = insertvalue [1024 x i8] %635, i8 0, 627
	%637 = insertvalue [1024 x i8] %636, i8 0, 628
	%638 = insertvalue [1024 x i8] %637, i8 0, 629
	%639 = insertvalue [1024 x i8] %638, i8 0, 630
	%640 = insertvalue [1024 x i8] %639, i8 0, 631
	%641 = insertvalue [1024 x i8] %640, i8 0, 632
	%642 = insertvalue [1024 x i8] %641, i8 0, 633
	%643 = insertvalue [1024 x i8] %642, i8 0, 634
	%644 = insertvalue [1024 x i8] %643, i8 0, 635
	%645 = insertvalue [1024 x i8] %644, i8 0, 636
	%646 = insertvalue [1024 x i8] %645, i8 0, 637
	%647 = insertvalue [1024 x i8] %646, i8 0, 638
	%648 = insertvalue [1024 x i8] %647, i8 0, 639
	%649 = insertvalue [1024 x i8] %648, i8 0, 640
	%650 = insertvalue [1024 x i8] %649, i8 0, 641
	%651 = insertvalue [1024 x i8] %650, i8 0, 642
	%652 = insertvalue [1024 x i8] %651, i8 0, 643
	%653 = insertvalue [1024 x i8] %652, i8 0, 644
	%654 = insertvalue [1024 x i8] %653, i8 0, 645
	%655 = insertvalue [1024 x i8] %654, i8 0, 646
	%656 = insertvalue [1024 x i8] %655, i8 0, 647
	%657 = insertvalue [1024 x i8] %656, i8 0, 648
	%658 = insertvalue [1024 x i8] %657, i8 0, 649
	%659 = insertvalue [1024 x i8] %658, i8 0, 650
	%660 = insertvalue [1024 x i8] %659, i8 0, 651
	%661 = insertvalue [1024 x i8] %660, i8 0, 652
	%662 = insertvalue [1024 x i8] %661, i8 0, 653
	%663 = insertvalue [1024 x i8] %662, i8 0, 654
	%664 = insertvalue [1024 x i8] %663, i8 0, 655
	%665 = insertvalue [1024 x i8] %664, i8 0, 656
	%666 = insertvalue [1024 x i8] %665, i8 0, 657
	%667 = insertvalue [1024 x i8] %666, i8 0, 658
	%668 = insertvalue [1024 x i8] %667, i8 0, 659
	%669 = insertvalue [1024 x i8] %668, i8 0, 660
	%670 = insertvalue [1024 x i8] %669, i8 0, 661
	%671 = insertvalue [1024 x i8] %670, i8 0, 662
	%672 = insertvalue [1024 x i8] %671, i8 0, 663
	%673 = insertvalue [1024 x i8] %672, i8 0, 664
	%674 = insertvalue [1024 x i8] %673, i8 0, 665
	%675 = insertvalue [1024 x i8] %674, i8 0, 666
	%676 = insertvalue [1024 x i8] %675, i8 0, 667
	%677 = insertvalue [1024 x i8] %676, i8 0, 668
	%678 = insertvalue [1024 x i8] %677, i8 0, 669
	%679 = insertvalue [1024 x i8] %678, i8 0, 670
	%680 = insertvalue [1024 x i8] %679, i8 0, 671
	%681 = insertvalue [1024 x i8] %680, i8 0, 672
	%682 = insertvalue [1024 x i8] %681, i8 0, 673
	%683 = insertvalue [1024 x i8] %682, i8 0, 674
	%684 = insertvalue [1024 x i8] %683, i8 0, 675
	%685 = insertvalue [1024 x i8] %684, i8 0, 676
	%686 = insertvalue [1024 x i8] %685, i8 0, 677
	%687 = insertvalue [1024 x i8] %686, i8 0, 678
	%688 = insertvalue [1024 x i8] %687, i8 0, 679
	%689 = insertvalue [1024 x i8] %688, i8 0, 680
	%690 = insertvalue [1024 x i8] %689, i8 0, 681
	%691 = insertvalue [1024 x i8] %690, i8 0, 682
	%692 = insertvalue [1024 x i8] %691, i8 0, 683
	%693 = insertvalue [1024 x i8] %692, i8 0, 684
	%694 = insertvalue [1024 x i8] %693, i8 0, 685
	%695 = insertvalue [1024 x i8] %694, i8 0, 686
	%696 = insertvalue [1024 x i8] %695, i8 0, 687
	%697 = insertvalue [1024 x i8] %696, i8 0, 688
	%698 = insertvalue [1024 x i8] %697, i8 0, 689
	%699 = insertvalue [1024 x i8] %698, i8 0, 690
	%700 = insertvalue [1024 x i8] %699, i8 0, 691
	%701 = insertvalue [1024 x i8] %700, i8 0, 692
	%702 = insertvalue [1024 x i8] %701, i8 0, 693
	%703 = insertvalue [1024 x i8] %702, i8 0, 694
	%704 = insertvalue [1024 x i8] %703, i8 0, 695
	%705 = insertvalue [1024 x i8] %704, i8 0, 696
	%706 = insertvalue [1024 x i8] %705, i8 0, 697
	%707 = insertvalue [1024 x i8] %706, i8 0, 698
	%708 = insertvalue [1024 x i8] %707, i8 0, 699
	%709 = insertvalue [1024 x i8] %708, i8 0, 700
	%710 = insertvalue [1024 x i8] %709, i8 0, 701
	%711 = insertvalue [1024 x i8] %710, i8 0, 702
	%712 = insertvalue [1024 x i8] %711, i8 0, 703
	%713 = insertvalue [1024 x i8] %712, i8 0, 704
	%714 = insertvalue [1024 x i8] %713, i8 0, 705
	%715 = insertvalue [1024 x i8] %714, i8 0, 706
	%716 = insertvalue [1024 x i8] %715, i8 0, 707
	%717 = insertvalue [1024 x i8] %716, i8 0, 708
	%718 = insertvalue [1024 x i8] %717, i8 0, 709
	%719 = insertvalue [1024 x i8] %718, i8 0, 710
	%720 = insertvalue [1024 x i8] %719, i8 0, 711
	%721 = insertvalue [1024 x i8] %720, i8 0, 712
	%722 = insertvalue [1024 x i8] %721, i8 0, 713
	%723 = insertvalue [1024 x i8] %722, i8 0, 714
	%724 = insertvalue [1024 x i8] %723, i8 0, 715
	%725 = insertvalue [1024 x i8] %724, i8 0, 716
	%726 = insertvalue [1024 x i8] %725, i8 0, 717
	%727 = insertvalue [1024 x i8] %726, i8 0, 718
	%728 = insertvalue [1024 x i8] %727, i8 0, 719
	%729 = insertvalue [1024 x i8] %728, i8 0, 720
	%730 = insertvalue [1024 x i8] %729, i8 0, 721
	%731 = insertvalue [1024 x i8] %730, i8 0, 722
	%732 = insertvalue [1024 x i8] %731, i8 0, 723
	%733 = insertvalue [1024 x i8] %732, i8 0, 724
	%734 = insertvalue [1024 x i8] %733, i8 0, 725
	%735 = insertvalue [1024 x i8] %734, i8 0, 726
	%736 = insertvalue [1024 x i8] %735, i8 0, 727
	%737 = insertvalue [1024 x i8] %736, i8 0, 728
	%738 = insertvalue [1024 x i8] %737, i8 0, 729
	%739 = insertvalue [1024 x i8] %738, i8 0, 730
	%740 = insertvalue [1024 x i8] %739, i8 0, 731
	%741 = insertvalue [1024 x i8] %740, i8 0, 732
	%742 = insertvalue [1024 x i8] %741, i8 0, 733
	%743 = insertvalue [1024 x i8] %742, i8 0, 734
	%744 = insertvalue [1024 x i8] %743, i8 0, 735
	%745 = insertvalue [1024 x i8] %744, i8 0, 736
	%746 = insertvalue [1024 x i8] %745, i8 0, 737
	%747 = insertvalue [1024 x i8] %746, i8 0, 738
	%748 = insertvalue [1024 x i8] %747, i8 0, 739
	%749 = insertvalue [1024 x i8] %748, i8 0, 740
	%750 = insertvalue [1024 x i8] %749, i8 0, 741
	%751 = insertvalue [1024 x i8] %750, i8 0, 742
	%752 = insertvalue [1024 x i8] %751, i8 0, 743
	%753 = insertvalue [1024 x i8] %752, i8 0, 744
	%754 = insertvalue [1024 x i8] %753, i8 0, 745
	%755 = insertvalue [1024 x i8] %754, i8 0, 746
	%756 = insertvalue [1024 x i8] %755, i8 0, 747
	%757 = insertvalue [1024 x i8] %756, i8 0, 748
	%758 = insertvalue [1024 x i8] %757, i8 0, 749
	%759 = insertvalue [1024 x i8] %758, i8 0, 750
	%760 = insertvalue [1024 x i8] %759, i8 0, 751
	%761 = insertvalue [1024 x i8] %760, i8 0, 752
	%762 = insertvalue [1024 x i8] %761, i8 0, 753
	%763 = insertvalue [1024 x i8] %762, i8 0, 754
	%764 = insertvalue [1024 x i8] %763, i8 0, 755
	%765 = insertvalue [1024 x i8] %764, i8 0, 756
	%766 = insertvalue [1024 x i8] %765, i8 0, 757
	%767 = insertvalue [1024 x i8] %766, i8 0, 758
	%768 = insertvalue [1024 x i8] %767, i8 0, 759
	%769 = insertvalue [1024 x i8] %768, i8 0, 760
	%770 = insertvalue [1024 x i8] %769, i8 0, 761
	%771 = insertvalue [1024 x i8] %770, i8 0, 762
	%772 = insertvalue [1024 x i8] %771, i8 0, 763
	%773 = insertvalue [1024 x i8] %772, i8 0, 764
	%774 = insertvalue [1024 x i8] %773, i8 0, 765
	%775 = insertvalue [1024 x i8] %774, i8 0, 766
	%776 = insertvalue [1024 x i8] %775, i8 0, 767
	%777 = insertvalue [1024 x i8] %776, i8 0, 768
	%778 = insertvalue [1024 x i8] %777, i8 0, 769
	%779 = insertvalue [1024 x i8] %778, i8 0, 770
	%780 = insertvalue [1024 x i8] %779, i8 0, 771
	%781 = insertvalue [1024 x i8] %780, i8 0, 772
	%782 = insertvalue [1024 x i8] %781, i8 0, 773
	%783 = insertvalue [1024 x i8] %782, i8 0, 774
	%784 = insertvalue [1024 x i8] %783, i8 0, 775
	%785 = insertvalue [1024 x i8] %784, i8 0, 776
	%786 = insertvalue [1024 x i8] %785, i8 0, 777
	%787 = insertvalue [1024 x i8] %786, i8 0, 778
	%788 = insertvalue [1024 x i8] %787, i8 0, 779
	%789 = insertvalue [1024 x i8] %788, i8 0, 780
	%790 = insertvalue [1024 x i8] %789, i8 0, 781
	%791 = insertvalue [1024 x i8] %790, i8 0, 782
	%792 = insertvalue [1024 x i8] %791, i8 0, 783
	%793 = insertvalue [1024 x i8] %792, i8 0, 784
	%794 = insertvalue [1024 x i8] %793, i8 0, 785
	%795 = insertvalue [1024 x i8] %794, i8 0, 786
	%796 = insertvalue [1024 x i8] %795, i8 0, 787
	%797 = insertvalue [1024 x i8] %796, i8 0, 788
	%798 = insertvalue [1024 x i8] %797, i8 0, 789
	%799 = insertvalue [1024 x i8] %798, i8 0, 790
	%800 = insertvalue [1024 x i8] %799, i8 0, 791
	%801 = insertvalue [1024 x i8] %800, i8 0, 792
	%802 = insertvalue [1024 x i8] %801, i8 0, 793
	%803 = insertvalue [1024 x i8] %802, i8 0, 794
	%804 = insertvalue [1024 x i8] %803, i8 0, 795
	%805 = insertvalue [1024 x i8] %804, i8 0, 796
	%806 = insertvalue [1024 x i8] %805, i8 0, 797
	%807 = insertvalue [1024 x i8] %806, i8 0, 798
	%808 = insertvalue [1024 x i8] %807, i8 0, 799
	%809 = insertvalue [1024 x i8] %808, i8 0, 800
	%810 = insertvalue [1024 x i8] %809, i8 0, 801
	%811 = insertvalue [1024 x i8] %810, i8 0, 802
	%812 = insertvalue [1024 x i8] %811, i8 0, 803
	%813 = insertvalue [1024 x i8] %812, i8 0, 804
	%814 = insertvalue [1024 x i8] %813, i8 0, 805
	%815 = insertvalue [1024 x i8] %814, i8 0, 806
	%816 = insertvalue [1024 x i8] %815, i8 0, 807
	%817 = insertvalue [1024 x i8] %816, i8 0, 808
	%818 = insertvalue [1024 x i8] %817, i8 0, 809
	%819 = insertvalue [1024 x i8] %818, i8 0, 810
	%820 = insertvalue [1024 x i8] %819, i8 0, 811
	%821 = insertvalue [1024 x i8] %820, i8 0, 812
	%822 = insertvalue [1024 x i8] %821, i8 0, 813
	%823 = insertvalue [1024 x i8] %822, i8 0, 814
	%824 = insertvalue [1024 x i8] %823, i8 0, 815
	%825 = insertvalue [1024 x i8] %824, i8 0, 816
	%826 = insertvalue [1024 x i8] %825, i8 0, 817
	%827 = insertvalue [1024 x i8] %826, i8 0, 818
	%828 = insertvalue [1024 x i8] %827, i8 0, 819
	%829 = insertvalue [1024 x i8] %828, i8 0, 820
	%830 = insertvalue [1024 x i8] %829, i8 0, 821
	%831 = insertvalue [1024 x i8] %830, i8 0, 822
	%832 = insertvalue [1024 x i8] %831, i8 0, 823
	%833 = insertvalue [1024 x i8] %832, i8 0, 824
	%834 = insertvalue [1024 x i8] %833, i8 0, 825
	%835 = insertvalue [1024 x i8] %834, i8 0, 826
	%836 = insertvalue [1024 x i8] %835, i8 0, 827
	%837 = insertvalue [1024 x i8] %836, i8 0, 828
	%838 = insertvalue [1024 x i8] %837, i8 0, 829
	%839 = insertvalue [1024 x i8] %838, i8 0, 830
	%840 = insertvalue [1024 x i8] %839, i8 0, 831
	%841 = insertvalue [1024 x i8] %840, i8 0, 832
	%842 = insertvalue [1024 x i8] %841, i8 0, 833
	%843 = insertvalue [1024 x i8] %842, i8 0, 834
	%844 = insertvalue [1024 x i8] %843, i8 0, 835
	%845 = insertvalue [1024 x i8] %844, i8 0, 836
	%846 = insertvalue [1024 x i8] %845, i8 0, 837
	%847 = insertvalue [1024 x i8] %846, i8 0, 838
	%848 = insertvalue [1024 x i8] %847, i8 0, 839
	%849 = insertvalue [1024 x i8] %848, i8 0, 840
	%850 = insertvalue [1024 x i8] %849, i8 0, 841
	%851 = insertvalue [1024 x i8] %850, i8 0, 842
	%852 = insertvalue [1024 x i8] %851, i8 0, 843
	%853 = insertvalue [1024 x i8] %852, i8 0, 844
	%854 = insertvalue [1024 x i8] %853, i8 0, 845
	%855 = insertvalue [1024 x i8] %854, i8 0, 846
	%856 = insertvalue [1024 x i8] %855, i8 0, 847
	%857 = insertvalue [1024 x i8] %856, i8 0, 848
	%858 = insertvalue [1024 x i8] %857, i8 0, 849
	%859 = insertvalue [1024 x i8] %858, i8 0, 850
	%860 = insertvalue [1024 x i8] %859, i8 0, 851
	%861 = insertvalue [1024 x i8] %860, i8 0, 852
	%862 = insertvalue [1024 x i8] %861, i8 0, 853
	%863 = insertvalue [1024 x i8] %862, i8 0, 854
	%864 = insertvalue [1024 x i8] %863, i8 0, 855
	%865 = insertvalue [1024 x i8] %864, i8 0, 856
	%866 = insertvalue [1024 x i8] %865, i8 0, 857
	%867 = insertvalue [1024 x i8] %866, i8 0, 858
	%868 = insertvalue [1024 x i8] %867, i8 0, 859
	%869 = insertvalue [1024 x i8] %868, i8 0, 860
	%870 = insertvalue [1024 x i8] %869, i8 0, 861
	%871 = insertvalue [1024 x i8] %870, i8 0, 862
	%872 = insertvalue [1024 x i8] %871, i8 0, 863
	%873 = insertvalue [1024 x i8] %872, i8 0, 864
	%874 = insertvalue [1024 x i8] %873, i8 0, 865
	%875 = insertvalue [1024 x i8] %874, i8 0, 866
	%876 = insertvalue [1024 x i8] %875, i8 0, 867
	%877 = insertvalue [1024 x i8] %876, i8 0, 868
	%878 = insertvalue [1024 x i8] %877, i8 0, 869
	%879 = insertvalue [1024 x i8] %878, i8 0, 870
	%880 = insertvalue [1024 x i8] %879, i8 0, 871
	%881 = insertvalue [1024 x i8] %880, i8 0, 872
	%882 = insertvalue [1024 x i8] %881, i8 0, 873
	%883 = insertvalue [1024 x i8] %882, i8 0, 874
	%884 = insertvalue [1024 x i8] %883, i8 0, 875
	%885 = insertvalue [1024 x i8] %884, i8 0, 876
	%886 = insertvalue [1024 x i8] %885, i8 0, 877
	%887 = insertvalue [1024 x i8] %886, i8 0, 878
	%888 = insertvalue [1024 x i8] %887, i8 0, 879
	%889 = insertvalue [1024 x i8] %888, i8 0, 880
	%890 = insertvalue [1024 x i8] %889, i8 0, 881
	%891 = insertvalue [1024 x i8] %890, i8 0, 882
	%892 = insertvalue [1024 x i8] %891, i8 0, 883
	%893 = insertvalue [1024 x i8] %892, i8 0, 884
	%894 = insertvalue [1024 x i8] %893, i8 0, 885
	%895 = insertvalue [1024 x i8] %894, i8 0, 886
	%896 = insertvalue [1024 x i8] %895, i8 0, 887
	%897 = insertvalue [1024 x i8] %896, i8 0, 888
	%898 = insertvalue [1024 x i8] %897, i8 0, 889
	%899 = insertvalue [1024 x i8] %898, i8 0, 890
	%900 = insertvalue [1024 x i8] %899, i8 0, 891
	%901 = insertvalue [1024 x i8] %900, i8 0, 892
	%902 = insertvalue [1024 x i8] %901, i8 0, 893
	%903 = insertvalue [1024 x i8] %902, i8 0, 894
	%904 = insertvalue [1024 x i8] %903, i8 0, 895
	%905 = insertvalue [1024 x i8] %904, i8 0, 896
	%906 = insertvalue [1024 x i8] %905, i8 0, 897
	%907 = insertvalue [1024 x i8] %906, i8 0, 898
	%908 = insertvalue [1024 x i8] %907, i8 0, 899
	%909 = insertvalue [1024 x i8] %908, i8 0, 900
	%910 = insertvalue [1024 x i8] %909, i8 0, 901
	%911 = insertvalue [1024 x i8] %910, i8 0, 902
	%912 = insertvalue [1024 x i8] %911, i8 0, 903
	%913 = insertvalue [1024 x i8] %912, i8 0, 904
	%914 = insertvalue [1024 x i8] %913, i8 0, 905
	%915 = insertvalue [1024 x i8] %914, i8 0, 906
	%916 = insertvalue [1024 x i8] %915, i8 0, 907
	%917 = insertvalue [1024 x i8] %916, i8 0, 908
	%918 = insertvalue [1024 x i8] %917, i8 0, 909
	%919 = insertvalue [1024 x i8] %918, i8 0, 910
	%920 = insertvalue [1024 x i8] %919, i8 0, 911
	%921 = insertvalue [1024 x i8] %920, i8 0, 912
	%922 = insertvalue [1024 x i8] %921, i8 0, 913
	%923 = insertvalue [1024 x i8] %922, i8 0, 914
	%924 = insertvalue [1024 x i8] %923, i8 0, 915
	%925 = insertvalue [1024 x i8] %924, i8 0, 916
	%926 = insertvalue [1024 x i8] %925, i8 0, 917
	%927 = insertvalue [1024 x i8] %926, i8 0, 918
	%928 = insertvalue [1024 x i8] %927, i8 0, 919
	%929 = insertvalue [1024 x i8] %928, i8 0, 920
	%930 = insertvalue [1024 x i8] %929, i8 0, 921
	%931 = insertvalue [1024 x i8] %930, i8 0, 922
	%932 = insertvalue [1024 x i8] %931, i8 0, 923
	%933 = insertvalue [1024 x i8] %932, i8 0, 924
	%934 = insertvalue [1024 x i8] %933, i8 0, 925
	%935 = insertvalue [1024 x i8] %934, i8 0, 926
	%936 = insertvalue [1024 x i8] %935, i8 0, 927
	%937 = insertvalue [1024 x i8] %936, i8 0, 928
	%938 = insertvalue [1024 x i8] %937, i8 0, 929
	%939 = insertvalue [1024 x i8] %938, i8 0, 930
	%940 = insertvalue [1024 x i8] %939, i8 0, 931
	%941 = insertvalue [1024 x i8] %940, i8 0, 932
	%942 = insertvalue [1024 x i8] %941, i8 0, 933
	%943 = insertvalue [1024 x i8] %942, i8 0, 934
	%944 = insertvalue [1024 x i8] %943, i8 0, 935
	%945 = insertvalue [1024 x i8] %944, i8 0, 936
	%946 = insertvalue [1024 x i8] %945, i8 0, 937
	%947 = insertvalue [1024 x i8] %946, i8 0, 938
	%948 = insertvalue [1024 x i8] %947, i8 0, 939
	%949 = insertvalue [1024 x i8] %948, i8 0, 940
	%950 = insertvalue [1024 x i8] %949, i8 0, 941
	%951 = insertvalue [1024 x i8] %950, i8 0, 942
	%952 = insertvalue [1024 x i8] %951, i8 0, 943
	%953 = insertvalue [1024 x i8] %952, i8 0, 944
	%954 = insertvalue [1024 x i8] %953, i8 0, 945
	%955 = insertvalue [1024 x i8] %954, i8 0, 946
	%956 = insertvalue [1024 x i8] %955, i8 0, 947
	%957 = insertvalue [1024 x i8] %956, i8 0, 948
	%958 = insertvalue [1024 x i8] %957, i8 0, 949
	%959 = insertvalue [1024 x i8] %958, i8 0, 950
	%960 = insertvalue [1024 x i8] %959, i8 0, 951
	%961 = insertvalue [1024 x i8] %960, i8 0, 952
	%962 = insertvalue [1024 x i8] %961, i8 0, 953
	%963 = insertvalue [1024 x i8] %962, i8 0, 954
	%964 = insertvalue [1024 x i8] %963, i8 0, 955
	%965 = insertvalue [1024 x i8] %964, i8 0, 956
	%966 = insertvalue [1024 x i8] %965, i8 0, 957
	%967 = insertvalue [1024 x i8] %966, i8 0, 958
	%968 = insertvalue [1024 x i8] %967, i8 0, 959
	%969 = insertvalue [1024 x i8] %968, i8 0, 960
	%970 = insertvalue [1024 x i8] %969, i8 0, 961
	%971 = insertvalue [1024 x i8] %970, i8 0, 962
	%972 = insertvalue [1024 x i8] %971, i8 0, 963
	%973 = insertvalue [1024 x i8] %972, i8 0, 964
	%974 = insertvalue [1024 x i8] %973, i8 0, 965
	%975 = insertvalue [1024 x i8] %974, i8 0, 966
	%976 = insertvalue [1024 x i8] %975, i8 0, 967
	%977 = insertvalue [1024 x i8] %976, i8 0, 968
	%978 = insertvalue [1024 x i8] %977, i8 0, 969
	%979 = insertvalue [1024 x i8] %978, i8 0, 970
	%980 = insertvalue [1024 x i8] %979, i8 0, 971
	%981 = insertvalue [1024 x i8] %980, i8 0, 972
	%982 = insertvalue [1024 x i8] %981, i8 0, 973
	%983 = insertvalue [1024 x i8] %982, i8 0, 974
	%984 = insertvalue [1024 x i8] %983, i8 0, 975
	%985 = insertvalue [1024 x i8] %984, i8 0, 976
	%986 = insertvalue [1024 x i8] %985, i8 0, 977
	%987 = insertvalue [1024 x i8] %986, i8 0, 978
	%988 = insertvalue [1024 x i8] %987, i8 0, 979
	%989 = insertvalue [1024 x i8] %988, i8 0, 980
	%990 = insertvalue [1024 x i8] %989, i8 0, 981
	%991 = insertvalue [1024 x i8] %990, i8 0, 982
	%992 = insertvalue [1024 x i8] %991, i8 0, 983
	%993 = insertvalue [1024 x i8] %992, i8 0, 984
	%994 = insertvalue [1024 x i8] %993, i8 0, 985
	%995 = insertvalue [1024 x i8] %994, i8 0, 986
	%996 = insertvalue [1024 x i8] %995, i8 0, 987
	%997 = insertvalue [1024 x i8] %996, i8 0, 988
	%998 = insertvalue [1024 x i8] %997, i8 0, 989
	%999 = insertvalue [1024 x i8] %998, i8 0, 990
	%1000 = insertvalue [1024 x i8] %999, i8 0, 991
	%1001 = insertvalue [1024 x i8] %1000, i8 0, 992
	%1002 = insertvalue [1024 x i8] %1001, i8 0, 993
	%1003 = insertvalue [1024 x i8] %1002, i8 0, 994
	%1004 = insertvalue [1024 x i8] %1003, i8 0, 995
	%1005 = insertvalue [1024 x i8] %1004, i8 0, 996
	%1006 = insertvalue [1024 x i8] %1005, i8 0, 997
	%1007 = insertvalue [1024 x i8] %1006, i8 0, 998
	%1008 = insertvalue [1024 x i8] %1007, i8 0, 999
	%1009 = insertvalue [1024 x i8] %1008, i8 0, 1000
	%1010 = insertvalue [1024 x i8] %1009, i8 0, 1001
	%1011 = insertvalue [1024 x i8] %1010, i8 0, 1002
	%1012 = insertvalue [1024 x i8] %1011, i8 0, 1003
	%1013 = insertvalue [1024 x i8] %1012, i8 0, 1004
	%1014 = insertvalue [1024 x i8] %1013, i8 0, 1005
	%1015 = insertvalue [1024 x i8] %1014, i8 0, 1006
	%1016 = insertvalue [1024 x i8] %1015, i8 0, 1007
	%1017 = insertvalue [1024 x i8] %1016, i8 0, 1008
	%1018 = insertvalue [1024 x i8] %1017, i8 0, 1009
	%1019 = insertvalue [1024 x i8] %1018, i8 0, 1010
	%1020 = insertvalue [1024 x i8] %1019, i8 0, 1011
	%1021 = insertvalue [1024 x i8] %1020, i8 0, 1012
	%1022 = insertvalue [1024 x i8] %1021, i8 0, 1013
	%1023 = insertvalue [1024 x i8] %1022, i8 0, 1014
	%1024 = insertvalue [1024 x i8] %1023, i8 0, 1015
	%1025 = insertvalue [1024 x i8] %1024, i8 0, 1016
	%1026 = insertvalue [1024 x i8] %1025, i8 0, 1017
	%1027 = insertvalue [1024 x i8] %1026, i8 0, 1018
	%1028 = insertvalue [1024 x i8] %1027, i8 0, 1019
	%1029 = insertvalue [1024 x i8] %1028, i8 0, 1020
	%1030 = insertvalue [1024 x i8] %1029, i8 0, 1021
	%1031 = insertvalue [1024 x i8] %1030, i8 0, 1022
	%1032 = insertvalue [1024 x i8] %1031, i8 0, 1023
	store [1024 x i8] %1032, [1024 x i8]* %1
	br label %again_1
break_1:
	ret void
}

define %Int @main() {
	%1 = call %Int @socket(%Int 2, %Int 1, %Int 0)
	%2 = icmp slt %Int %1, 0
	br i1 %2 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([20 x i8]* @str5 to [0 x i8]*))
	call void @exit(%Int 1)
	br label %endif_0
endif_0:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str6 to [0 x i8]*))
	%4 = alloca %Struct_sockaddr_in, align 4
	%5 = insertvalue %Struct_sockaddr_in zeroinitializer, i8 0, 0
	%6 = insertvalue %Struct_sockaddr_in %5, i8 2, 1
	%7 = insertvalue %Struct_sockaddr_in %6, %UnsignedShort 8080, 2
	%8 = call %In_addr_t @inet_addr([0 x %ConstChar]* bitcast ([10 x i8]* @str7 to [0 x i8]*))
	%9 = insertvalue %Struct_in_addr zeroinitializer, %In_addr_t %8, 0
	%10 = insertvalue %Struct_sockaddr_in %7, %Struct_in_addr %9, 3
	%11 = insertvalue [8 x i8] zeroinitializer, i8 0, 0
	%12 = insertvalue [8 x i8] %11, i8 0, 1
	%13 = insertvalue [8 x i8] %12, i8 0, 2
	%14 = insertvalue [8 x i8] %13, i8 0, 3
	%15 = insertvalue [8 x i8] %14, i8 0, 4
	%16 = insertvalue [8 x i8] %15, i8 0, 5
	%17 = insertvalue [8 x i8] %16, i8 0, 6
	%18 = insertvalue [8 x i8] %17, i8 0, 7
	%19 = insertvalue %Struct_sockaddr_in %10, [8 x i8] %18, 4
	store %Struct_sockaddr_in %19, %Struct_sockaddr_in* %4
	%20 = bitcast %Struct_sockaddr_in* %4 to i8*
	%21 = bitcast i8* %20 to %Struct_sockaddr*
	%22 = alloca %Int, align 4
	%23 = call %Int @bind(%Int %1, %Struct_sockaddr* %21, %Socklen_t 16)
	store %Int %23, %Int* %22
	%24 = load %Int, %Int* %22
	%25 = icmp slt %Int %24, 0
	br i1 %25 , label %then_1, label %endif_1
then_1:
	call void @perror(%ConstCharStr* bitcast ([21 x i8]* @str8 to [0 x i8]*))
	call void @exit(%Int 1)
	br label %endif_1
endif_1:
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str9 to [0 x i8]*))
	%27 = call %Int @listen(%Int %1, %Int 10)
	store %Int %27, %Int* %22
	%28 = load %Int, %Int* %22
	%29 = icmp ne %Int %28, 0
	br i1 %29 , label %then_2, label %endif_2
then_2:
	call void @perror(%ConstCharStr* bitcast ([21 x i8]* @str10 to [0 x i8]*))
	call void @exit(%Int 1)
	br label %endif_2
endif_2:
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str11 to [0 x i8]*))
	%31 = alloca %Socklen_t, align 4
	store %Socklen_t 16, %Socklen_t* %31
	%32 = alloca %Struct_sockaddr_in, align 4
	%33 = bitcast %Struct_sockaddr_in* %32 to i8*
	%34 = bitcast i8* %33 to %Struct_sockaddr*
	%35 = call %Int @accept(%Int %1, %Struct_sockaddr* %34, %Socklen_t* %31)
	call void @write_file(%Int %35)
	%36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str12 to [0 x i8]*))
	ret %Int 0
}


