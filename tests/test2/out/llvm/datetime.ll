
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Word256 = type i256
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Int256 = type i256
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Nat256 = type i256
%Float32 = type float
%Float64 = type double
%Size = type i64
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

; MODULE: datetime

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float64;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included time
%TimeT = type %Int32;
%ClockT = type %UnsignedLong;
%StructTM = type {
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
declare %TimeT @mktime(%StructTM* %timeptr)
declare %TimeT @time(%TimeT* %timer)
declare %Char* @asctime(%StructTM* %timeptr)
declare %Char* @ctime(%TimeT* %timer)
declare %StructTM* @gmtime(%TimeT* %timer)
declare %StructTM* @localtime(%TimeT* %timer)
declare %SizeT @strftime(%Char* %ptr, %SizeT %maxsize, %ConstChar* %format, %StructTM* %timeptr)
declare %StructTM* @localtime_s(%TimeT* %timer, %StructTM* %tmptr)
declare %StructTM* @localtime_r(%TimeT* %timer, %StructTM* %tmptr)
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare [0 x %Char]* @strncpy([0 x %Char]* %dst, [0 x %ConstChar]* %src, %SizeT %n)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
; from included stdio
%File = type {
};

%FposT = type %Nat8;
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
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
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
; -- end print includes --
; -- print imports 'datetime' --
; -- 0
; -- end print imports 'datetime' --
; -- strings --
@str1 = private constant [13 x i8] [i8 37, i8 100, i8 45, i8 37, i8 48, i8 50, i8 100, i8 45, i8 37, i8 48, i8 50, i8 100, i8 0]
@str2 = private constant [15 x i8] [i8 37, i8 48, i8 50, i8 100, i8 58, i8 37, i8 48, i8 50, i8 100, i8 58, i8 37, i8 48, i8 50, i8 100, i8 0]
; -- endstrings --
%datetime_Date = type {
	%Nat32,
	%Nat8,
	%Nat8
};

%datetime_Time = type {
	%Nat8,
	%Nat8,
	%Nat8
};

%datetime_DateTime = type {
	%datetime_Date,
	%datetime_Time
};

define internal %StructTM @localTimeNow() {
	%1 = alloca %TimeT, align 4
	%2 = call %TimeT @time(%TimeT* %1)
	%3 = alloca %StructTM, align 64
	%4 = call %StructTM* @localtime_r(%TimeT* %1, %StructTM* %3)
	%5 = load %StructTM, %StructTM* %3
	ret %StructTM %5
}

define %datetime_Time @datetime_timeNow() {
	%1 = call %StructTM @localTimeNow()
	%2 = alloca %StructTM
	store %StructTM %1, %StructTM* %2
	%3 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 2
	%4 = load %Int, %Int* %3
	%5 = trunc %Int %4 to %Nat8
	%6 = insertvalue %datetime_Time zeroinitializer, %Nat8 %5, 0
	%7 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 1
	%8 = load %Int, %Int* %7
	%9 = trunc %Int %8 to %Nat8
	%10 = insertvalue %datetime_Time %6, %Nat8 %9, 1
	%11 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 0
	%12 = load %Int, %Int* %11
	%13 = trunc %Int %12 to %Nat8
	%14 = insertvalue %datetime_Time %10, %Nat8 %13, 2
	ret %datetime_Time %14
}

define %datetime_Date @datetime_dateNow() {
	%1 = call %StructTM @localTimeNow()
	%2 = alloca %StructTM
	store %StructTM %1, %StructTM* %2
	%3 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 5
	%4 = load %Int, %Int* %3
	%5 = bitcast %Int %4 to %Nat32
	%6 = add %Nat32 %5, 1900
	%7 = insertvalue %datetime_Date zeroinitializer, %Nat32 %6, 0
	%8 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 4
	%9 = load %Int, %Int* %8
	%10 = trunc %Int %9 to %Nat8
	%11 = add %Nat8 %10, 1
	%12 = insertvalue %datetime_Date %7, %Nat8 %11, 1
	%13 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 3
	%14 = load %Int, %Int* %13
	%15 = trunc %Int %14 to %Nat8
	%16 = insertvalue %datetime_Date %12, %Nat8 %15, 2
	ret %datetime_Date %16
}

define %datetime_DateTime @datetime_dateTimeNow() {
	%1 = call %StructTM @localTimeNow()
	%2 = alloca %StructTM
	store %StructTM %1, %StructTM* %2
	%3 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 5
	%4 = load %Int, %Int* %3
	%5 = bitcast %Int %4 to %Nat32
	%6 = add %Nat32 %5, 1900
	%7 = insertvalue %datetime_Date zeroinitializer, %Nat32 %6, 0
	%8 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 4
	%9 = load %Int, %Int* %8
	%10 = trunc %Int %9 to %Nat8
	%11 = add %Nat8 %10, 1
	%12 = insertvalue %datetime_Date %7, %Nat8 %11, 1
	%13 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 3
	%14 = load %Int, %Int* %13
	%15 = trunc %Int %14 to %Nat8
	%16 = insertvalue %datetime_Date %12, %Nat8 %15, 2
	%17 = insertvalue %datetime_DateTime zeroinitializer, %datetime_Date %16, 0
	%18 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 2
	%19 = load %Int, %Int* %18
	%20 = trunc %Int %19 to %Nat8
	%21 = insertvalue %datetime_Time zeroinitializer, %Nat8 %20, 0
	%22 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 1
	%23 = load %Int, %Int* %22
	%24 = trunc %Int %23 to %Nat8
	%25 = insertvalue %datetime_Time %21, %Nat8 %24, 1
	%26 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 0
	%27 = load %Int, %Int* %26
	%28 = trunc %Int %27 to %Nat8
	%29 = insertvalue %datetime_Time %25, %Nat8 %28, 2
	%30 = insertvalue %datetime_DateTime %17, %datetime_Time %29, 1
	ret %datetime_DateTime %30
}

define %Nat32 @datetime_dayOfYear() {
	%1 = call %StructTM @localTimeNow()
	%2 = alloca %StructTM
	store %StructTM %1, %StructTM* %2
	%3 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 7
	%4 = load %Int, %Int* %3
	%5 = bitcast %Int %4 to %Nat32
	%6 = add %Nat32 %5, 1
	ret %Nat32 %6
}

define %Nat8 @datetime_dayOfWeek() {
	%1 = call %StructTM @localTimeNow()
	%2 = alloca %StructTM
	store %StructTM %1, %StructTM* %2
	%3 = getelementptr %StructTM, %StructTM* %2, %Int32 0, %Int32 6
	%4 = load %Int, %Int* %3
	%5 = trunc %Int %4 to %Nat8
; if_0
	%6 = icmp ugt %Nat8 %5, 0
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = sub %Nat8 %5, 1
	ret %Nat8 %7
	br label %endif_0
endif_0:
	ret %Nat8 7
}

define %Int32 @datetime_sprintDate([0 x %Char8]* %s) {
	%1 = call %datetime_DateTime @datetime_dateTimeNow()
	%2 = alloca %datetime_DateTime
	store %datetime_DateTime %1, %datetime_DateTime* %2
	%3 = getelementptr %datetime_DateTime, %datetime_DateTime* %2, %Int32 0, %Int32 0, %Int32 0
	%4 = load %Nat32, %Nat32* %3
	%5 = getelementptr %datetime_DateTime, %datetime_DateTime* %2, %Int32 0, %Int32 0, %Int32 1
	%6 = load %Nat8, %Nat8* %5
	%7 = getelementptr %datetime_DateTime, %datetime_DateTime* %2, %Int32 0, %Int32 0, %Int32 2
	%8 = load %Nat8, %Nat8* %7
	%9 = call %Int (%CharStr*, %ConstCharStr*, ...) @sprintf([0 x %Char8]* %s, %ConstCharStr* bitcast ([13 x i8]* @str1 to [0 x i8]*), %Nat32 %4, %Nat8 %6, %Nat8 %8)
	ret %Int %9
}

define %Int32 @datetime_sprintTime([0 x %Char8]* %s) {
	%1 = call %datetime_DateTime @datetime_dateTimeNow()
	%2 = alloca %datetime_DateTime
	store %datetime_DateTime %1, %datetime_DateTime* %2
	%3 = getelementptr %datetime_DateTime, %datetime_DateTime* %2, %Int32 0, %Int32 1, %Int32 0
	%4 = load %Nat8, %Nat8* %3
	%5 = getelementptr %datetime_DateTime, %datetime_DateTime* %2, %Int32 0, %Int32 1, %Int32 1
	%6 = load %Nat8, %Nat8* %5
	%7 = getelementptr %datetime_DateTime, %datetime_DateTime* %2, %Int32 0, %Int32 1, %Int32 2
	%8 = load %Nat8, %Nat8* %7
	%9 = call %Int (%CharStr*, %ConstCharStr*, ...) @sprintf([0 x %Char8]* %s, %ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*), %Nat8 %4, %Nat8 %6, %Nat8 %8)
	ret %Int %9
}

define %Int32 @datetime_sprintDateTime([0 x %Char8]* %s) {
	%1 = zext i8 0 to %Nat32
	%2 = getelementptr [0 x %Char8], [0 x %Char8]* %s, %Int32 0, %Nat32 %1
;
	%3 = bitcast %Char8* %2 to [0 x %Char8]*
	%4 = call %Int32 @datetime_sprintDate([0 x %Char8]* %3)
	%5 = getelementptr [0 x %Char8], [0 x %Char8]* %s, %Int32 0, %Int32 %4
	store %Char8 32, %Char8* %5
	%6 = add %Int32 %4, 1
	%7 = getelementptr [0 x %Char8], [0 x %Char8]* %s, %Int32 0, %Int32 %6
;
	%8 = bitcast %Char8* %7 to [0 x %Char8]*
	%9 = call %Int32 @datetime_sprintTime([0 x %Char8]* %8)
	%10 = add %Int32 %4, 1
	%11 = add %Int32 %10, %9
	%12 = getelementptr [0 x %Char8], [0 x %Char8]* %s, %Int32 0, %Int32 %11
	store %Char8 0, %Char8* %12
	%13 = add %Int32 %4, 1
	%14 = add %Int32 %13, %9
	ret %Int32 %14
}


