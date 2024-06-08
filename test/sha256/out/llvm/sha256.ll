
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
%PtrToConst = type i8*


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
declare i8* @memcpy(i8* %dst, %PtrToConst %src, %SizeT %len)
declare i8* @memmove(i8* %dst, %PtrToConst %source, %SizeT %n)
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/sha256.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/sha256.cm




%Context = type {
	[64 x i8], 
	i32, 
	i64, 
	[8 x i32]
}


define i32 @rotleft(i32 %a, i32 %b) {
	%1 = shl i32 %a, %b
	%2 = sub i32 32, %b
	%3 = lshr i32 %a, %2
	%4 = or i32 %1, %3
	ret i32 %4
}

define i32 @rotright(i32 %a, i32 %b) {
	%1 = lshr i32 %a, %b
	%2 = sub i32 32, %b
	%3 = shl i32 %a, %2
	%4 = or i32 %1, %3
	ret i32 %4
}

define i32 @ch(i32 %x, i32 %y, i32 %z) {
	%1 = and i32 %x, %y
	%2 = xor i32 %x, -1
	%3 = and i32 %2, %z
	%4 = xor i32 %1, %3
	ret i32 %4
}

define i32 @maj(i32 %x, i32 %y, i32 %z) {
	%1 = and i32 %x, %y
	%2 = and i32 %x, %z
	%3 = and i32 %y, %z
	%4 = xor i32 %2, %3
	%5 = xor i32 %1, %4
	ret i32 %5
}

define i32 @ep0(i32 %x) {
	%1 = call i32 (i32, i32) @rotright(i32 %x, i32 2)
	%2 = call i32 (i32, i32) @rotright(i32 %x, i32 13)
	%3 = call i32 (i32, i32) @rotright(i32 %x, i32 22)
	%4 = xor i32 %2, %3
	%5 = xor i32 %1, %4
	ret i32 %5
}

define i32 @ep1(i32 %x) {
	%1 = call i32 (i32, i32) @rotright(i32 %x, i32 6)
	%2 = call i32 (i32, i32) @rotright(i32 %x, i32 11)
	%3 = call i32 (i32, i32) @rotright(i32 %x, i32 25)
	%4 = xor i32 %2, %3
	%5 = xor i32 %1, %4
	ret i32 %5
}

define i32 @sig0(i32 %x) {
	%1 = call i32 (i32, i32) @rotright(i32 %x, i32 7)
	%2 = call i32 (i32, i32) @rotright(i32 %x, i32 18)
	%3 = lshr i32 %x, 3
	%4 = xor i32 %2, %3
	%5 = xor i32 %1, %4
	ret i32 %5
}

define i32 @sig1(i32 %x) {
	%1 = call i32 (i32, i32) @rotright(i32 %x, i32 17)
	%2 = call i32 (i32, i32) @rotright(i32 %x, i32 19)
	%3 = lshr i32 %x, 10
	%4 = xor i32 %2, %3
	%5 = xor i32 %1, %4
	ret i32 %5
}


@initalState = constant [8 x i32] [
	i32 1779033703,
	i32 3144134277,
	i32 1013904242,
	i32 2773480762,
	i32 1359893119,
	i32 2600822924,
	i32 528734635,
	i32 1541459225
]

define void @sha256_contextInit(%Context* %ctx) {
	%1 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%2 = insertvalue [8 x i32] zeroinitializer, i32 1779033703, 0
	%3 = insertvalue [8 x i32] %2, i32 3144134277, 1
	%4 = insertvalue [8 x i32] %3, i32 1013904242, 2
	%5 = insertvalue [8 x i32] %4, i32 2773480762, 3
	%6 = insertvalue [8 x i32] %5, i32 1359893119, 4
	%7 = insertvalue [8 x i32] %6, i32 2600822924, 5
	%8 = insertvalue [8 x i32] %7, i32 528734635, 6
	%9 = insertvalue [8 x i32] %8, i32 1541459225, 7
	store [8 x i32] %9, [8 x i32]* %1
	ret void
}


@k = constant [64 x i32] [
	i32 1116352408,
	i32 1899447441,
	i32 3049323471,
	i32 3921009573,
	i32 961987163,
	i32 1508970993,
	i32 2453635748,
	i32 2870763221,
	i32 3624381080,
	i32 310598401,
	i32 607225278,
	i32 1426881987,
	i32 1925078388,
	i32 2162078206,
	i32 2614888103,
	i32 3248222580,
	i32 3835390401,
	i32 4022224774,
	i32 264347078,
	i32 604807628,
	i32 770255983,
	i32 1249150122,
	i32 1555081692,
	i32 1996064986,
	i32 2554220882,
	i32 2821834349,
	i32 2952996808,
	i32 3210313671,
	i32 3336571891,
	i32 3584528711,
	i32 113926993,
	i32 338241895,
	i32 666307205,
	i32 773529912,
	i32 1294757372,
	i32 1396182291,
	i32 1695183700,
	i32 1986661051,
	i32 2177026350,
	i32 2456956037,
	i32 2730485921,
	i32 2820302411,
	i32 3259730800,
	i32 3345764771,
	i32 3516065817,
	i32 3600352804,
	i32 4094571909,
	i32 275423344,
	i32 430227734,
	i32 506948616,
	i32 659060556,
	i32 883997877,
	i32 958139571,
	i32 1322822218,
	i32 1537002063,
	i32 1747873779,
	i32 1955562222,
	i32 2024104815,
	i32 2227730452,
	i32 2361852424,
	i32 2428436474,
	i32 2756734187,
	i32 3204031479,
	i32 3329325298
]

define void @sha256_transform(%Context* %ctx, [0 x i8]* %data) {
	%1 = alloca [64 x i32], align 4
	%2 = insertvalue [64 x i32] zeroinitializer, i32 0, 0
	%3 = insertvalue [64 x i32] %2, i32 0, 1
	%4 = insertvalue [64 x i32] %3, i32 0, 2
	%5 = insertvalue [64 x i32] %4, i32 0, 3
	%6 = insertvalue [64 x i32] %5, i32 0, 4
	%7 = insertvalue [64 x i32] %6, i32 0, 5
	%8 = insertvalue [64 x i32] %7, i32 0, 6
	%9 = insertvalue [64 x i32] %8, i32 0, 7
	%10 = insertvalue [64 x i32] %9, i32 0, 8
	%11 = insertvalue [64 x i32] %10, i32 0, 9
	%12 = insertvalue [64 x i32] %11, i32 0, 10
	%13 = insertvalue [64 x i32] %12, i32 0, 11
	%14 = insertvalue [64 x i32] %13, i32 0, 12
	%15 = insertvalue [64 x i32] %14, i32 0, 13
	%16 = insertvalue [64 x i32] %15, i32 0, 14
	%17 = insertvalue [64 x i32] %16, i32 0, 15
	%18 = insertvalue [64 x i32] %17, i32 0, 16
	%19 = insertvalue [64 x i32] %18, i32 0, 17
	%20 = insertvalue [64 x i32] %19, i32 0, 18
	%21 = insertvalue [64 x i32] %20, i32 0, 19
	%22 = insertvalue [64 x i32] %21, i32 0, 20
	%23 = insertvalue [64 x i32] %22, i32 0, 21
	%24 = insertvalue [64 x i32] %23, i32 0, 22
	%25 = insertvalue [64 x i32] %24, i32 0, 23
	%26 = insertvalue [64 x i32] %25, i32 0, 24
	%27 = insertvalue [64 x i32] %26, i32 0, 25
	%28 = insertvalue [64 x i32] %27, i32 0, 26
	%29 = insertvalue [64 x i32] %28, i32 0, 27
	%30 = insertvalue [64 x i32] %29, i32 0, 28
	%31 = insertvalue [64 x i32] %30, i32 0, 29
	%32 = insertvalue [64 x i32] %31, i32 0, 30
	%33 = insertvalue [64 x i32] %32, i32 0, 31
	%34 = insertvalue [64 x i32] %33, i32 0, 32
	%35 = insertvalue [64 x i32] %34, i32 0, 33
	%36 = insertvalue [64 x i32] %35, i32 0, 34
	%37 = insertvalue [64 x i32] %36, i32 0, 35
	%38 = insertvalue [64 x i32] %37, i32 0, 36
	%39 = insertvalue [64 x i32] %38, i32 0, 37
	%40 = insertvalue [64 x i32] %39, i32 0, 38
	%41 = insertvalue [64 x i32] %40, i32 0, 39
	%42 = insertvalue [64 x i32] %41, i32 0, 40
	%43 = insertvalue [64 x i32] %42, i32 0, 41
	%44 = insertvalue [64 x i32] %43, i32 0, 42
	%45 = insertvalue [64 x i32] %44, i32 0, 43
	%46 = insertvalue [64 x i32] %45, i32 0, 44
	%47 = insertvalue [64 x i32] %46, i32 0, 45
	%48 = insertvalue [64 x i32] %47, i32 0, 46
	%49 = insertvalue [64 x i32] %48, i32 0, 47
	%50 = insertvalue [64 x i32] %49, i32 0, 48
	%51 = insertvalue [64 x i32] %50, i32 0, 49
	%52 = insertvalue [64 x i32] %51, i32 0, 50
	%53 = insertvalue [64 x i32] %52, i32 0, 51
	%54 = insertvalue [64 x i32] %53, i32 0, 52
	%55 = insertvalue [64 x i32] %54, i32 0, 53
	%56 = insertvalue [64 x i32] %55, i32 0, 54
	%57 = insertvalue [64 x i32] %56, i32 0, 55
	%58 = insertvalue [64 x i32] %57, i32 0, 56
	%59 = insertvalue [64 x i32] %58, i32 0, 57
	%60 = insertvalue [64 x i32] %59, i32 0, 58
	%61 = insertvalue [64 x i32] %60, i32 0, 59
	%62 = insertvalue [64 x i32] %61, i32 0, 60
	%63 = insertvalue [64 x i32] %62, i32 0, 61
	%64 = insertvalue [64 x i32] %63, i32 0, 62
	%65 = insertvalue [64 x i32] %64, i32 0, 63
	store [64 x i32] %65, [64 x i32]* %1
	%66 = alloca i32, align 4
	store i32 0, i32* %66
	%67 = alloca i32, align 4
	store i32 0, i32* %67
	br label %again_1
again_1:
	%68 = load i32, i32* %66
	%69 = icmp ult i32 %68, 16
	br i1 %69 , label %body_1, label %break_1
body_1:
	%70 = load i32, i32* %67
	%71 = add i32 %70, 0
	%72 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %71
	%73 = load i8, i8* %72
	%74 = zext i8 %73 to i32
	%75 = shl i32 %74, 24
	%76 = load i32, i32* %67
	%77 = add i32 %76, 1
	%78 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %77
	%79 = load i8, i8* %78
	%80 = zext i8 %79 to i32
	%81 = shl i32 %80, 16
	%82 = load i32, i32* %67
	%83 = add i32 %82, 2
	%84 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %83
	%85 = load i8, i8* %84
	%86 = zext i8 %85 to i32
	%87 = shl i32 %86, 8
	%88 = load i32, i32* %67
	%89 = add i32 %88, 3
	%90 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %89
	%91 = load i8, i8* %90
	%92 = zext i8 %91 to i32
	%93 = shl i32 %92, 0
	%94 = or i32 %87, %93
	%95 = or i32 %81, %94
	%96 = or i32 %75, %95
	%97 = load i32, i32* %66
	%98 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %97
	store i32 %96, i32* %98
	%99 = load i32, i32* %67
	%100 = add i32 %99, 4
	store i32 %100, i32* %67
	%101 = load i32, i32* %66
	%102 = add i32 %101, 1
	store i32 %102, i32* %66
	br label %again_1
break_1:
	br label %again_2
again_2:
	%103 = load i32, i32* %66
	%104 = icmp ult i32 %103, 64
	br i1 %104 , label %body_2, label %break_2
body_2:
	%105 = load i32, i32* %66
	%106 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %105
	%107 = load i32, i32* %66
	%108 = sub i32 %107, 2
	%109 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %108
	%110 = load i32, i32* %109
	%111 = call i32 (i32) @sig1(i32 %110)
	%112 = load i32, i32* %66
	%113 = sub i32 %112, 7
	%114 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %113
	%115 = load i32, i32* %114
	%116 = add i32 %111, %115
	%117 = load i32, i32* %66
	%118 = sub i32 %117, 15
	%119 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %118
	%120 = load i32, i32* %119
	%121 = call i32 (i32) @sig0(i32 %120)
	%122 = add i32 %116, %121
	%123 = load i32, i32* %66
	%124 = sub i32 %123, 16
	%125 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %124
	%126 = load i32, i32* %125
	%127 = add i32 %122, %126
	store i32 %127, i32* %106
	%128 = load i32, i32* %66
	%129 = add i32 %128, 1
	store i32 %129, i32* %66
	br label %again_2
break_2:
	%130 = alloca [8 x i32], align 4
	%131 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%132 = load [8 x i32], [8 x i32]* %131
	store [8 x i32] %132, [8 x i32]* %130
	store i32 0, i32* %66
	br label %again_3
again_3:
	%133 = load i32, i32* %66
	%134 = icmp ult i32 %133, 64
	br i1 %134 , label %body_3, label %break_3
body_3:
	%135 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 7
	%136 = load i32, i32* %135
	%137 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
	%138 = load i32, i32* %137
	%139 = call i32 (i32) @ep1(i32 %138)
	%140 = add i32 %136, %139
	%141 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
	%142 = load i32, i32* %141
	%143 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 5
	%144 = load i32, i32* %143
	%145 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 6
	%146 = load i32, i32* %145
	%147 = call i32 (i32, i32, i32) @ch(i32 %142, i32 %144, i32 %146)
	%148 = add i32 %140, %147
	%149 = load i32, i32* %66
	%150 = getelementptr inbounds [64 x i32], [64 x i32]* @k, i32 0, i32 %149
	%151 = load i32, i32* %150
	%152 = bitcast i32 %151 to i32
	%153 = add i32 %148, %152
	%154 = load i32, i32* %66
	%155 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %154
	%156 = load i32, i32* %155
	%157 = add i32 %153, %156
	%158 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 0
	%159 = load i32, i32* %158
	%160 = call i32 (i32) @ep0(i32 %159)
	%161 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 0
	%162 = load i32, i32* %161
	%163 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 1
	%164 = load i32, i32* %163
	%165 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 2
	%166 = load i32, i32* %165
	%167 = call i32 (i32, i32, i32) @maj(i32 %162, i32 %164, i32 %166)
	%168 = add i32 %160, %167
	%169 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 7
	%170 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 6
	%171 = load i32, i32* %170
	store i32 %171, i32* %169
	%172 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 6
	%173 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 5
	%174 = load i32, i32* %173
	store i32 %174, i32* %172
	%175 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 5
	%176 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
	%177 = load i32, i32* %176
	store i32 %177, i32* %175
	%178 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
	%179 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 3
	%180 = load i32, i32* %179
	%181 = add i32 %180, %157
	store i32 %181, i32* %178
	%182 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 3
	%183 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 2
	%184 = load i32, i32* %183
	store i32 %184, i32* %182
	%185 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 2
	%186 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 1
	%187 = load i32, i32* %186
	store i32 %187, i32* %185
	%188 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 1
	%189 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 0
	%190 = load i32, i32* %189
	store i32 %190, i32* %188
	%191 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 0
	%192 = add i32 %157, %168
	store i32 %192, i32* %191
	%193 = load i32, i32* %66
	%194 = add i32 %193, 1
	store i32 %194, i32* %66
	br label %again_3
break_3:
	store i32 0, i32* %66
	br label %again_4
again_4:
	%195 = load i32, i32* %66
	%196 = icmp ult i32 %195, 8
	br i1 %196 , label %body_4, label %break_4
body_4:
	%197 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%198 = load i32, i32* %66
	%199 = getelementptr inbounds [8 x i32], [8 x i32]* %197, i32 0, i32 %198
	%200 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%201 = load i32, i32* %66
	%202 = getelementptr inbounds [8 x i32], [8 x i32]* %200, i32 0, i32 %201
	%203 = load i32, i32* %202
	%204 = load i32, i32* %66
	%205 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 %204
	%206 = load i32, i32* %205
	%207 = add i32 %203, %206
	store i32 %207, i32* %199
	%208 = load i32, i32* %66
	%209 = add i32 %208, 1
	store i32 %209, i32* %66
	br label %again_4
break_4:
	ret void
}

define void @sha256_update(%Context* %ctx, [0 x i8]* %msg, i32 %msgLen) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	%2 = load i32, i32* %1
	%3 = icmp ult i32 %2, %msgLen
	br i1 %3 , label %body_1, label %break_1
body_1:
	%4 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%5 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = getelementptr inbounds [64 x i8], [64 x i8]* %4, i32 0, i32 %6
	%8 = load i32, i32* %1
	%9 = getelementptr inbounds [0 x i8], [0 x i8]* %msg, i32 0, i32 %8
	%10 = load i8, i8* %9
	store i8 %10, i8* %7
	%11 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
	%12 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
	%13 = load i32, i32* %12
	%14 = add i32 %13, 1
	store i32 %14, i32* %11
	%15 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
	%16 = load i32, i32* %15
	%17 = icmp eq i32 %16, 64
	br i1 %17 , label %then_0, label %endif_0
then_0:
	%18 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%19 = bitcast [64 x i8]* %18 to [0 x i8]*
	call void (%Context*, [0 x i8]*) @sha256_transform(%Context* %ctx, [0 x i8]* %19)
	%20 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%21 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%22 = load i64, i64* %21
	%23 = add i64 %22, 512
	store i64 %23, i64* %20
	%24 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
	store i32 0, i32* %24
	br label %endif_0
endif_0:
	%25 = load i32, i32* %1
	%26 = add i32 %25, 1
	store i32 %26, i32* %1
	br label %again_1
break_1:
	ret void
}

define void @sha256_final(%Context* %ctx, [32 x i8]* %outHash) {
	%1 = alloca i32, align 4
	%2 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
	%3 = load i32, i32* %2
	store i32 %3, i32* %1
	; Pad whatever data is left in the buffer.
	%4 = alloca i32, align 4
	store i32 64, i32* %4
	%5 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = icmp ult i32 %6, 56
	br i1 %7 , label %then_0, label %endif_0
then_0:
	store i32 56, i32* %4
	br label %endif_0
endif_0:
	%8 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%9 = load i32, i32* %1
	%10 = getelementptr inbounds [64 x i8], [64 x i8]* %8, i32 0, i32 %9
	store i8 128, i8* %10
	%11 = load i32, i32* %1
	%12 = add i32 %11, 1
	store i32 %12, i32* %1
	%13 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%14 = load i32, i32* %1
	%15 = getelementptr inbounds [64 x i8], [64 x i8]* %13, i32 0, i32 %14
	%16 = bitcast i8* %15 to i8*
	%17 = load i32, i32* %4
	%18 = load i32, i32* %1
	%19 = sub i32 %17, %18
	%20 = zext i32 %19 to %SizeT
	%21 = call i8* (i8*, %Int, %SizeT) @memset(i8* %16, %Int 0, %SizeT %20)
	%22 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
	%23 = load i32, i32* %22
	%24 = icmp uge i32 %23, 56
	br i1 %24 , label %then_1, label %endif_1
then_1:
	%25 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%26 = bitcast [64 x i8]* %25 to [0 x i8]*
	call void (%Context*, [0 x i8]*) @sha256_transform(%Context* %ctx, [0 x i8]* %26)
	%27 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%28 = bitcast [64 x i8]* %27 to i8*
	%29 = call i8* (i8*, %Int, %SizeT) @memset(i8* %28, %Int 0, %SizeT 56)
	br label %endif_1
endif_1:
	; Append to the padding the total message's length in bits and transform.
	%30 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%31 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%32 = load i64, i64* %31
	%33 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
	%34 = load i32, i32* %33
	%35 = zext i32 %34 to i64
	%36 = mul i64 %35, 8
	%37 = add i64 %32, %36
	store i64 %37, i64* %30
	%38 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%39 = getelementptr inbounds [64 x i8], [64 x i8]* %38, i32 0, i32 63
	%40 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%41 = load i64, i64* %40
	%42 = lshr i64 %41, 0
	%43 = trunc i64 %42 to i8
	store i8 %43, i8* %39
	%44 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%45 = getelementptr inbounds [64 x i8], [64 x i8]* %44, i32 0, i32 62
	%46 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%47 = load i64, i64* %46
	%48 = lshr i64 %47, 8
	%49 = trunc i64 %48 to i8
	store i8 %49, i8* %45
	%50 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%51 = getelementptr inbounds [64 x i8], [64 x i8]* %50, i32 0, i32 61
	%52 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%53 = load i64, i64* %52
	%54 = lshr i64 %53, 16
	%55 = trunc i64 %54 to i8
	store i8 %55, i8* %51
	%56 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%57 = getelementptr inbounds [64 x i8], [64 x i8]* %56, i32 0, i32 60
	%58 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%59 = load i64, i64* %58
	%60 = lshr i64 %59, 24
	%61 = trunc i64 %60 to i8
	store i8 %61, i8* %57
	%62 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%63 = getelementptr inbounds [64 x i8], [64 x i8]* %62, i32 0, i32 59
	%64 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%65 = load i64, i64* %64
	%66 = lshr i64 %65, 32
	%67 = trunc i64 %66 to i8
	store i8 %67, i8* %63
	%68 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%69 = getelementptr inbounds [64 x i8], [64 x i8]* %68, i32 0, i32 58
	%70 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%71 = load i64, i64* %70
	%72 = lshr i64 %71, 40
	%73 = trunc i64 %72 to i8
	store i8 %73, i8* %69
	%74 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%75 = getelementptr inbounds [64 x i8], [64 x i8]* %74, i32 0, i32 57
	%76 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%77 = load i64, i64* %76
	%78 = lshr i64 %77, 48
	%79 = trunc i64 %78 to i8
	store i8 %79, i8* %75
	%80 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%81 = getelementptr inbounds [64 x i8], [64 x i8]* %80, i32 0, i32 56
	%82 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
	%83 = load i64, i64* %82
	%84 = lshr i64 %83, 56
	%85 = trunc i64 %84 to i8
	store i8 %85, i8* %81
	%86 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
	%87 = bitcast [64 x i8]* %86 to [0 x i8]*
	call void (%Context*, [0 x i8]*) @sha256_transform(%Context* %ctx, [0 x i8]* %87)
	; Since this implementation uses little endian byte ordering
	; and SHA uses big endian, reverse all the bytes
	; when copying the final state to the output hash.
	store i32 0, i32* %1
	br label %again_1
again_1:
	%88 = load i32, i32* %1
	%89 = icmp ult i32 %88, 4
	br i1 %89 , label %body_1, label %break_1
body_1:
	%90 = load i32, i32* %1
	%91 = mul i32 %90, 8
	%92 = sub i32 24, %91
	%93 = load i32, i32* %1
	%94 = add i32 %93, 0
	%95 = getelementptr inbounds [32 x i8], [32 x i8]* %outHash, i32 0, i32 %94
	%96 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%97 = getelementptr inbounds [8 x i32], [8 x i32]* %96, i32 0, i32 0
	%98 = load i32, i32* %97
	%99 = lshr i32 %98, %92
	%100 = trunc i32 %99 to i8
	store i8 %100, i8* %95
	%101 = load i32, i32* %1
	%102 = add i32 %101, 4
	%103 = getelementptr inbounds [32 x i8], [32 x i8]* %outHash, i32 0, i32 %102
	%104 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%105 = getelementptr inbounds [8 x i32], [8 x i32]* %104, i32 0, i32 1
	%106 = load i32, i32* %105
	%107 = lshr i32 %106, %92
	%108 = trunc i32 %107 to i8
	store i8 %108, i8* %103
	%109 = load i32, i32* %1
	%110 = add i32 %109, 8
	%111 = getelementptr inbounds [32 x i8], [32 x i8]* %outHash, i32 0, i32 %110
	%112 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%113 = getelementptr inbounds [8 x i32], [8 x i32]* %112, i32 0, i32 2
	%114 = load i32, i32* %113
	%115 = lshr i32 %114, %92
	%116 = trunc i32 %115 to i8
	store i8 %116, i8* %111
	%117 = load i32, i32* %1
	%118 = add i32 %117, 12
	%119 = getelementptr inbounds [32 x i8], [32 x i8]* %outHash, i32 0, i32 %118
	%120 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%121 = getelementptr inbounds [8 x i32], [8 x i32]* %120, i32 0, i32 3
	%122 = load i32, i32* %121
	%123 = lshr i32 %122, %92
	%124 = trunc i32 %123 to i8
	store i8 %124, i8* %119
	%125 = load i32, i32* %1
	%126 = add i32 %125, 16
	%127 = getelementptr inbounds [32 x i8], [32 x i8]* %outHash, i32 0, i32 %126
	%128 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%129 = getelementptr inbounds [8 x i32], [8 x i32]* %128, i32 0, i32 4
	%130 = load i32, i32* %129
	%131 = lshr i32 %130, %92
	%132 = trunc i32 %131 to i8
	store i8 %132, i8* %127
	%133 = load i32, i32* %1
	%134 = add i32 %133, 20
	%135 = getelementptr inbounds [32 x i8], [32 x i8]* %outHash, i32 0, i32 %134
	%136 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%137 = getelementptr inbounds [8 x i32], [8 x i32]* %136, i32 0, i32 5
	%138 = load i32, i32* %137
	%139 = lshr i32 %138, %92
	%140 = trunc i32 %139 to i8
	store i8 %140, i8* %135
	%141 = load i32, i32* %1
	%142 = add i32 %141, 24
	%143 = getelementptr inbounds [32 x i8], [32 x i8]* %outHash, i32 0, i32 %142
	%144 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%145 = getelementptr inbounds [8 x i32], [8 x i32]* %144, i32 0, i32 6
	%146 = load i32, i32* %145
	%147 = lshr i32 %146, %92
	%148 = trunc i32 %147 to i8
	store i8 %148, i8* %143
	%149 = load i32, i32* %1
	%150 = add i32 %149, 28
	%151 = getelementptr inbounds [32 x i8], [32 x i8]* %outHash, i32 0, i32 %150
	%152 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
	%153 = getelementptr inbounds [8 x i32], [8 x i32]* %152, i32 0, i32 7
	%154 = load i32, i32* %153
	%155 = lshr i32 %154, %92
	%156 = trunc i32 %155 to i8
	store i8 %156, i8* %151
	%157 = load i32, i32* %1
	%158 = add i32 %157, 1
	store i32 %158, i32* %1
	br label %again_1
break_1:
	ret void
}

define void @sha256_doHash([0 x i8]* %msg, i32 %msgLen, [32 x i8]* %outHash) {
	%1 = alloca %Context, align 8
	store %Context zeroinitializer, %Context* %1
	call void (%Context*) @sha256_contextInit(%Context* %1)
	call void (%Context*, [0 x i8]*, i32) @sha256_update(%Context* %1, [0 x i8]* %msg, i32 %msgLen)
	call void (%Context*, [32 x i8]*) @sha256_final(%Context* %1, [32 x i8]* %outHash)
	ret void
}


