
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

; -- SOURCE: src/main.cm

@str1 = private constant [14 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 87, i8 111, i8 114, i8 108, i8 100, i8 33, i8 10, i8 0]
@str2 = private constant [17 x i8] [i8 99, i8 111, i8 100, i8 101, i8 32, i8 105, i8 110, i8 116, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@str3 = private constant [15 x i8] [i8 99, i8 111, i8 100, i8 101, i8 32, i8 114, i8 115, i8 116, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str4 = private constant [19 x i8] [i8 98, i8 105, i8 116, i8 115, i8 95, i8 102, i8 111, i8 114, i8 95, i8 105, i8 110, i8 116, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [8 x i8] [i8 105, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [10 x i8] [i8 105, i8 105, i8 105, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [12 x i8] [i8 114, i8 101, i8 115, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 120, i8 10, i8 0]
@str8 = private constant [12 x i8] [i8 116, i8 111, i8 116, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 105, i8 10, i8 0]
@str9 = private constant [13 x i8] [i8 114, i8 101, i8 115, i8 50, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 120, i8 10, i8 0]
@str10 = private constant [15 x i8] [i8 114, i8 101, i8 115, i8 117, i8 108, i8 116, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 120, i8 10, i8 0]
@str11 = private constant [14 x i8] [i8 68, i8 69, i8 67, i8 32, i8 112, i8 111, i8 115, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str12 = private constant [11 x i8] [i8 82, i8 69, i8 83, i8 84, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str13 = private constant [14 x i8] [i8 70, i8 76, i8 84, i8 32, i8 61, i8 32, i8 37, i8 48, i8 56, i8 108, i8 108, i8 120, i8 10, i8 0]
@str14 = private constant [9 x i8] [i8 102, i8 50, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]



%Flt64 = type i64


define i64 @pack(i64 %dat, i8 %pos) {
    %1 = zext i8 %pos to i64
    %2 = shl i64 %1, 58
    %3 = or i64 %dat, %2
    ret i64 %3
}

define void @set_bit(i64* %x, i8 %n) {
    %1 = load i64, i64* %x
    %2 = zext i8 %n to i64
    %3 = shl i64 1, %2
    %4 = or i64 %1, %3
    store i64 %4, i64* %x
    ret void
}

define i8 @bits_for_int_value(i64 %i) {
    %1 = alloca i64
    store i64 %i, i64* %1
    %2 = alloca i8
    store i8 1, i8* %2
    %3 = alloca i64
    store i64 1, i64* %3
    br label %again_1
again_1:
    %4 = load i64, i64* %1
    %5 = load i64, i64* %3
    %6 = icmp ugt i64 %4, %5
    br i1 %6 , label %body_1, label %break_1
body_1:
    %7 = load i64, i64* %3
    %8 = shl i64 %7, 1
    %9 = add i64 %8, 1
    store i64 %9, i64* %3
    %10 = load i8, i8* %2
    %11 = add i8 %10, 1
    store i8 %11, i8* %2
    br label %again_1
break_1:
    %12 = load i8, i8* %2
    ret i8 %12
}



define i64 @code(double %x) {
    %1 = fptoui double %x to i64
    %2 = uitofp i64 %1 to double
    %3 = fsub double %x, %2
    %4 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str1 to [0 x i8]*))
    %5 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str2 to [0 x i8]*), i64 %1)
    %6 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str3 to [0 x i8]*), double %3)
    %7 = call i8 (i64) @bits_for_int_value(i64 %1)
    %8 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str4 to [0 x i8]*), i8 %7)
    %9 = sub i8 58, %7
    %10 = alloca i64
    store i64 0, i64* %10
    %11 = alloca double
    store double %3, double* %11
    %12 = alloca i32
    store i32 0, i32* %12
    br label %again_1
again_1:
    %13 = load double, double* %11
    %14 = fcmp one double %13, 0.0
    %15 = load i32, i32* %12
    %16 = icmp slt i32 %15, 64
    %17 = and i1 %14, %16
    br i1 %17 , label %body_1, label %break_1
body_1:
    br label %again_2
again_2:
    %18 = load double, double* %11
    %19 = fcmp olt double %18, 1.0
    br i1 %19 , label %body_2, label %break_2
body_2:
    %20 = load double, double* %11
    %21 = fmul double %20, 2.0
    store double %21, double* %11
    %22 = load i32, i32* %12
    %23 = add i32 %22, 1
    store i32 %23, i32* %12
    br label %again_2
break_2:
    %24 = load double, double* %11
    %25 = fsub double %24, 1.0
    store double %25, double* %11
    %26 = load i32, i32* %12
    %27 = trunc i32 %26 to i8
    call void (i64*, i8) @set_bit(i64* %10, i8 %27)
    %28 = load i32, i32* %12
    %29 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str5 to [0 x i8]*), i32 %28)
    br label %again_1
break_1:
    %30 = load i32, i32* %12
    %31 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str6 to [0 x i8]*), i32 %30)
    %32 = load i64, i64* %10
    %33 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str7 to [0 x i8]*), i64 %32)
    %34 = load i32, i32* %12
    %35 = zext i32 %34 to i64
    %36 = alloca i64
    store i64 0, i64* %36
    %37 = alloca i64
    store i64 0, i64* %37
    br label %again_3
again_3:
    %38 = load i64, i64* %37
    %39 = icmp ult i64 %38, %35
    br i1 %39 , label %body_3, label %break_3
body_3:
    %40 = load i64, i64* %10
    %41 = load i64, i64* %37
    %42 = sub i64 %35, %41
    %43 = shl i64 1, %42
    %44 = and i64 %40, %43
    %45 = icmp ne i64 %44, 0
    br i1 %45 , label %then_0, label %endif_0
then_0:
    %46 = load i64, i64* %37
    %47 = shl i64 1, %46
    %48 = load i64, i64* %36
    %49 = or i64 %48, %47
    store i64 %49, i64* %36
    br label %endif_0
endif_0:
    %50 = load i64, i64* %37
    %51 = add i64 %50, 1
    store i64 %51, i64* %37
    br label %again_3
break_3:
    ; сдвигаем влево рест чтобы нам хватило места для целого
    br label %again_4
again_4:
    %52 = load i32, i32* %12
    %53 = sext i8 %9 to i32
    %54 = icmp sgt i32 %52, %53
    br i1 %54 , label %body_4, label %break_4
body_4:
    %55 = load i64, i64* %36
    %56 = lshr i64 %55, 1
    store i64 %56, i64* %36
    %57 = load i32, i32* %12
    %58 = sub i32 %57, 1
    store i32 %58, i32* %12
    br label %again_4
break_4:
    %59 = alloca i64
    %60 = zext i8 %9 to i64
    %61 = shl i64 %1, %60
    store i64 %61, i64* %59
    %62 = load i64, i64* %59
    %63 = load i64, i64* %36
    %64 = or i64 %62, %63
    store i64 %64, i64* %59
    %65 = load i64, i64* %59
    %66 = zext i8 %9 to i64
    %67 = shl i64 %66, 58
    %68 = or i64 %65, %67
    store i64 %68, i64* %59
    %69 = load i32, i32* %12
    %70 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str8 to [0 x i8]*), i32 %69)
    %71 = load i64, i64* %36
    %72 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str9 to [0 x i8]*), i64 %71)
    %73 = load i64, i64* %59
    %74 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str10 to [0 x i8]*), i64 %73)
    %75 = load i64, i64* %59
    ret i64 %75
}

define double @decode(i64 %f) {
    %1 = and i64 %f, 18158513697557839872
    %2 = lshr i64 %1, 58
    %3 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str11 to [0 x i8]*), i64 %2)
    %4 = and i64 %f, 288230376151711743
    %5 = shl i64 18446744073709551615, %2
    %6 = and i64 %4, %5
    %7 = lshr i64 %6, %2
    %8 = xor i64 %5, -1
    %9 = and i64 %4, %8
    %10 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str12 to [0 x i8]*), i64 %9)
    %11 = uitofp i64 %7 to double
    %12 = uitofp i64 %9 to double
    %13 = fadd double %12, 1.0
    %14 = fdiv double 1.0, %13
    %15 = fadd double %11, %14
    ret double %15
}

define i32 @main() {
    %1 = call i64 (double) @code(double 3.25)
    ; pos = 2
    %2 = call i64 (i64, i8) @pack(i64 4080, i8 4)
    %3 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str13 to [0 x i8]*), i64 %2)
    %4 = call double (i64) @decode(i64 %2)
    %5 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str14 to [0 x i8]*), double %4)
    ret i32 0
}


