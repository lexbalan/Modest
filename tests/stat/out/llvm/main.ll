
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
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
%__VA_List = type i8*
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

; MODULE: main

; -- print includes --

%Str = type %Str8;
%Char = type i8;
%ConstChar = type %Char;
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
%SocklenT = type i32;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntptrT = type i64;
%PtrdiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PidT = type i32;
%UidT = type i32;
%GidT = type i32;

%File = type i8;
%FposT = type i8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;


declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare %Int @vprintf(%ConstCharStr* %format, i8* %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, i8* %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, i8* %arg)
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

%TimeT = type i32;
%ClockT = type %UnsignedLong;
%Struct_tm = type {
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%LongInt, 
	%ConstChar*
};


declare %ClockT @clock()
declare %Double @difftime(%TimeT %end, %TimeT %beginning)
declare %TimeT @mktime(%Struct_tm* %timeptr)
declare %TimeT @time(%TimeT* %timer)
declare %Char* @asctime(%Struct_tm* %timeptr)
declare %Char* @ctime(%TimeT* %timer)
declare %Struct_tm* @gmtime(%TimeT* %timer)
declare %Struct_tm* @localtime(%TimeT* %timer)
declare %SizeT @strftime(%Char* %ptr, %SizeT %maxsize, %ConstChar* %format, %Struct_tm* %timeptr)

%DevT = type i32;
%InoT = type i64;
%ModeT = type i16;
%NLinkT = type i16;
%UIDT = type i32;
%GIDT = type i32;
%BlkSizeT = type i32;
%BlkCntT = type i64;
%DarwinIno64T = type i64;
%DarwinTimeT = type i64;
%Timespec = type {
	%DarwinTimeT, 
	%Long
};

%Stat = type {
	%DevT, 
	%ModeT, 
	%NLinkT, 
	%DarwinIno64T, 
	%UIDT, 
	%GIDT, 
	%DevT, 
	%Timespec, 
	%Timespec, 
	%Timespec, 
	%Timespec, 
	%OffT, 
	%BlkCntT, 
	%BlkSizeT, 
	i32, 
	i32, 
	i32, 
	[2 x i64]
};



declare %Int @"\01_stat"([0 x %ConstChar]* %path, %Stat* %stat)
define i1 @s_ISDIR(%ModeT %m) {
	%1 = and %ModeT %m, 61440
	%2 = icmp eq %ModeT %1, 16384
	ret i1 %2
}

define i1 @s_ISCHR(%ModeT %m) {
	%1 = and %ModeT %m, 61440
	%2 = icmp eq %ModeT %1, 8192
	ret i1 %2
}

define i1 @s_ISBLK(%ModeT %m) {
	%1 = and %ModeT %m, 61440
	%2 = icmp eq %ModeT %1, 24576
	ret i1 %2
}

define i1 @s_ISREG(%ModeT %m) {
	%1 = and %ModeT %m, 61440
	%2 = icmp eq %ModeT %1, 32768
	ret i1 %2
}

define i1 @s_ISFIFO(%ModeT %m) {
	%1 = and %ModeT %m, 61440
	%2 = icmp eq %ModeT %1, 4096
	ret i1 %2
}

define i1 @s_ISLNK(%ModeT %m) {
	%1 = and %ModeT %m, 61440
	%2 = icmp eq %ModeT %1, 40960
	ret i1 %2
}

define i1 @s_ISSOCK(%ModeT %m) {
	%1 = and %ModeT %m, 61440
	%2 = icmp eq %ModeT %1, 49152
	ret i1 %2
}

define i1 @s_ISWHT(%ModeT %m) {
	%1 = and %ModeT %m, 61440
	%2 = icmp eq %ModeT %1, 57344
	ret i1 %2
}

; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
@str1 = private constant [13 x i8] [i8 115, i8 116, i8 97, i8 116, i8 40, i8 34, i8 37, i8 115, i8 34, i8 41, i8 58, i8 10, i8 0]
@str2 = private constant [9 x i8] [i8 77, i8 97, i8 107, i8 101, i8 102, i8 105, i8 108, i8 101, i8 0]
@str3 = private constant [9 x i8] [i8 77, i8 97, i8 107, i8 101, i8 102, i8 105, i8 108, i8 101, i8 0]
@str4 = private constant [12 x i8] [i8 115, i8 116, i8 97, i8 116, i8 32, i8 101, i8 114, i8 114, i8 111, i8 114, i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 32, i8 100, i8 101, i8 118, i8 105, i8 99, i8 101, i8 58, i8 32, i8 37, i8 120, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 32, i8 105, i8 110, i8 111, i8 100, i8 101, i8 58, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@str7 = private constant [10 x i8] [i8 32, i8 85, i8 73, i8 68, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@str8 = private constant [10 x i8] [i8 32, i8 71, i8 73, i8 68, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@str9 = private constant [11 x i8] [i8 32, i8 114, i8 100, i8 101, i8 118, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@str10 = private constant [14 x i8] [i8 32, i8 98, i8 108, i8 107, i8 115, i8 105, i8 122, i8 101, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@str11 = private constant [15 x i8] [i8 32, i8 98, i8 108, i8 111, i8 99, i8 107, i8 115, i8 58, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@str12 = private constant [19 x i8] [i8 32, i8 115, i8 105, i8 122, i8 101, i8 58, i8 32, i8 37, i8 108, i8 108, i8 100, i8 32, i8 98, i8 121, i8 116, i8 101, i8 115, i8 10, i8 0]
@str13 = private constant [14 x i8] [i8 32, i8 110, i8 108, i8 105, i8 110, i8 107, i8 115, i8 58, i8 32, i8 37, i8 104, i8 117, i8 10, i8 0]
@str14 = private constant [11 x i8] [i8 32, i8 112, i8 101, i8 114, i8 109, i8 58, i8 32, i8 37, i8 111, i8 10, i8 0]


define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str1 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @str2 to [0 x i8]*))
	%2 = alloca %Stat, align 8
	%3 = bitcast %Stat* %2 to %Stat*
	%4 = call %Int @"\01_stat"([0 x %ConstChar]* bitcast ([9 x i8]* @str3 to [0 x i8]*), %Stat* %3)
	%5 = icmp slt %Int %4, 0
	br i1 %5 , label %then_0, label %endif_0
then_0:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str4 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	%8 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 0
	%9 = load %DevT, %DevT* %8
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), %DevT %9)
	%11 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 3
	%12 = load %DarwinIno64T, %DarwinIno64T* %11
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*), %DarwinIno64T %12)
	%14 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 4
	%15 = load %UIDT, %UIDT* %14
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str7 to [0 x i8]*), %UIDT %15)
	%17 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 5
	%18 = load %GIDT, %GIDT* %17
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str8 to [0 x i8]*), %GIDT %18)
	%20 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 6
	%21 = load %DevT, %DevT* %20
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str9 to [0 x i8]*), %DevT %21)
	%23 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 13
	%24 = load %BlkSizeT, %BlkSizeT* %23
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str10 to [0 x i8]*), %BlkSizeT %24)
	%26 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 12
	%27 = load %BlkCntT, %BlkCntT* %26
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str11 to [0 x i8]*), %BlkCntT %27)
	%29 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 11
	%30 = load %OffT, %OffT* %29
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str12 to [0 x i8]*), %OffT %30)
	%32 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 2
	%33 = load %NLinkT, %NLinkT* %32
	%34 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str13 to [0 x i8]*), %NLinkT %33)
	%35 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 1
	%36 = load %ModeT, %ModeT* %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str14 to [0 x i8]*), %ModeT %36)
	%38 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 7
	%39 = load %Timespec, %Timespec* %38
	%40 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 8
	%41 = load %Timespec, %Timespec* %40
	; UNIX filesystems have no creation time for files.
	; The ctime is the last time the file metadata (inode) was changed
	%42 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 9
	%43 = load %Timespec, %Timespec* %42
	ret %Int 0
}


