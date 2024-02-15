
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/sha256.cm




%SHA256_Context = type {
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



@initMagic = global [8 x i32] [
    i32 1779033703,
    i32 3144134277,
    i32 1013904242,
    i32 2773480762,
    i32 1359893119,
    i32 2600822924,
    i32 528734635,
    i32 1541459225
]

define void @sha256_contextInit(%SHA256_Context* %ctx) {
    %1 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %2 = bitcast [8 x i32]* %1 to i8*
    %3 = bitcast [8 x i32]* @initMagic to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %2, i8* %3, i32 32, i1 0)
    ret void
}


@k = global [64 x i32] [
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

define void @sha256_transform(%SHA256_Context* %ctx, [0 x i8]* %data) {
    %1 = alloca [64 x i32]
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
    %66 = alloca i32
    store i32 0, i32* %66
    %67 = alloca i32
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
    %130 = alloca [8 x i32]
    %131 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %132 = bitcast [8 x i32]* %130 to i8*
    %133 = bitcast [8 x i32]* %131 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %132, i8* %133, i32 32, i1 0)
    store i32 0, i32* %66
    br label %again_3
again_3:
    %134 = load i32, i32* %66
    %135 = icmp ult i32 %134, 64
    br i1 %135 , label %body_3, label %break_3
body_3:
    %136 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 7
    %137 = load i32, i32* %136
    %138 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
    %139 = load i32, i32* %138
    %140 = call i32 (i32) @ep1(i32 %139)
    %141 = add i32 %137, %140
    %142 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
    %143 = load i32, i32* %142
    %144 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 5
    %145 = load i32, i32* %144
    %146 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 6
    %147 = load i32, i32* %146
    %148 = call i32 (i32, i32, i32) @ch(i32 %143, i32 %145, i32 %147)
    %149 = add i32 %141, %148
    %150 = load i32, i32* %66
    %151 = getelementptr inbounds [64 x i32], [64 x i32]* @k, i32 0, i32 %150
    %152 = load i32, i32* %151
    %153 = add i32 %149, %152
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
    %171 = bitcast i32* %169 to i8*
    %172 = bitcast i32* %170 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %171, i8* %172, i32 4, i1 0)
    %173 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 6
    %174 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 5
    %175 = bitcast i32* %173 to i8*
    %176 = bitcast i32* %174 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %175, i8* %176, i32 4, i1 0)
    %177 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 5
    %178 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
    %179 = bitcast i32* %177 to i8*
    %180 = bitcast i32* %178 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %179, i8* %180, i32 4, i1 0)
    %181 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
    %182 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 3
    %183 = load i32, i32* %182
    %184 = add i32 %183, %157
    store i32 %184, i32* %181
    %185 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 3
    %186 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 2
    %187 = bitcast i32* %185 to i8*
    %188 = bitcast i32* %186 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %187, i8* %188, i32 4, i1 0)
    %189 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 2
    %190 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 1
    %191 = bitcast i32* %189 to i8*
    %192 = bitcast i32* %190 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %191, i8* %192, i32 4, i1 0)
    %193 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 1
    %194 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 0
    %195 = bitcast i32* %193 to i8*
    %196 = bitcast i32* %194 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %195, i8* %196, i32 4, i1 0)
    %197 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 0
    %198 = add i32 %157, %168
    store i32 %198, i32* %197
    %199 = load i32, i32* %66
    %200 = add i32 %199, 1
    store i32 %200, i32* %66
    br label %again_3
break_3:
    store i32 0, i32* %66
    br label %again_4
again_4:
    %201 = load i32, i32* %66
    %202 = icmp ult i32 %201, 8
    br i1 %202 , label %body_4, label %break_4
body_4:
    %203 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %204 = load i32, i32* %66
    %205 = getelementptr inbounds [8 x i32], [8 x i32]* %203, i32 0, i32 %204
    %206 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %207 = load i32, i32* %66
    %208 = getelementptr inbounds [8 x i32], [8 x i32]* %206, i32 0, i32 %207
    %209 = load i32, i32* %208
    %210 = load i32, i32* %66
    %211 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 %210
    %212 = load i32, i32* %211
    %213 = add i32 %209, %212
    store i32 %213, i32* %205
    %214 = load i32, i32* %66
    %215 = add i32 %214, 1
    store i32 %215, i32* %66
    br label %again_4
break_4:
    ret void
}

define void @sha256_update(%SHA256_Context* %ctx, [0 x i8]* %data, i32 %len) {
    %1 = alloca i32
    store i32 0, i32* %1
    br label %again_1
again_1:
    %2 = load i32, i32* %1
    %3 = icmp ult i32 %2, %len
    br i1 %3 , label %body_1, label %break_1
body_1:
    %4 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %5 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %6 = load i32, i32* %5
    %7 = getelementptr inbounds [64 x i8], [64 x i8]* %4, i32 0, i32 %6
    %8 = load i32, i32* %1
    %9 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %8
    %10 = bitcast i8* %7 to i8*
    %11 = bitcast i8* %9 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %10, i8* %11, i32 1, i1 0)
    %12 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %13 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %14 = load i32, i32* %13
    %15 = add i32 %14, 1
    store i32 %15, i32* %12
    %16 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %17 = load i32, i32* %16
    %18 = icmp eq i32 %17, 64
    br i1 %18 , label %then_0, label %endif_0
then_0:
    %19 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %20 = bitcast [64 x i8]* %19 to [0 x i8]*
    call void (%SHA256_Context*, [0 x i8]*) @sha256_transform(%SHA256_Context* %ctx, [0 x i8]* %20)
    %21 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %22 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %23 = load i64, i64* %22
    %24 = add i64 %23, 512
    store i64 %24, i64* %21
    %25 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    store i32 0, i32* %25
    br label %endif_0
endif_0:
    %26 = load i32, i32* %1
    %27 = add i32 %26, 1
    store i32 %27, i32* %1
    br label %again_1
break_1:
    ret void
}

define void @sha256_final(%SHA256_Context* %ctx, [0 x i8]* %hash) {
    %1 = alloca i32
    %2 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %3 = bitcast i32* %1 to i8*
    %4 = bitcast i32* %2 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %3, i8* %4, i32 4, i1 0)
    ; Pad whatever data is left in the buffer.
    %5 = alloca i32
    store i32 64, i32* %5
    %6 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %7 = load i32, i32* %6
    %8 = icmp ult i32 %7, 56
    br i1 %8 , label %then_0, label %endif_0
then_0:
    store i32 56, i32* %5
    br label %endif_0
endif_0:
    %9 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %10 = load i32, i32* %1
    %11 = getelementptr inbounds [64 x i8], [64 x i8]* %9, i32 0, i32 %10
    store i8 128, i8* %11
    %12 = load i32, i32* %1
    %13 = add i32 %12, 1
    store i32 %13, i32* %1
    %14 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %15 = load i32, i32* %1
    %16 = getelementptr inbounds [64 x i8], [64 x i8]* %14, i32 0, i32 %15
    %17 = bitcast i8* %16 to i8*
    %18 = load i32, i32* %5
    %19 = load i32, i32* %1
    %20 = sub i32 %18, %19
    %21 = zext i32 %20 to %SizeT
    %22 = call i8* (i8*, %Int, %SizeT) @memset(i8* %17, %Int 0, %SizeT %21)
    %23 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %24 = load i32, i32* %23
    %25 = icmp uge i32 %24, 56
    br i1 %25 , label %then_1, label %endif_1
then_1:
    %26 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %27 = bitcast [64 x i8]* %26 to [0 x i8]*
    call void (%SHA256_Context*, [0 x i8]*) @sha256_transform(%SHA256_Context* %ctx, [0 x i8]* %27)
    %28 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %29 = bitcast [64 x i8]* %28 to i8*
    %30 = call i8* (i8*, %Int, %SizeT) @memset(i8* %29, %Int 0, %SizeT 56)
    br label %endif_1
endif_1:
    ; Append to the padding the total message's length in bits and transform.
    %31 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %32 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %33 = load i64, i64* %32
    %34 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %35 = load i32, i32* %34
    %36 = zext i32 %35 to i64
    %37 = mul i64 %36, 8
    %38 = add i64 %33, %37
    store i64 %38, i64* %31
    %39 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %40 = getelementptr inbounds [64 x i8], [64 x i8]* %39, i32 0, i32 63
    %41 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %42 = load i64, i64* %41
    %43 = lshr i64 %42, 0
    %44 = trunc i64 %43 to i8
    store i8 %44, i8* %40
    %45 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %46 = getelementptr inbounds [64 x i8], [64 x i8]* %45, i32 0, i32 62
    %47 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %48 = load i64, i64* %47
    %49 = lshr i64 %48, 8
    %50 = trunc i64 %49 to i8
    store i8 %50, i8* %46
    %51 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %52 = getelementptr inbounds [64 x i8], [64 x i8]* %51, i32 0, i32 61
    %53 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %54 = load i64, i64* %53
    %55 = lshr i64 %54, 16
    %56 = trunc i64 %55 to i8
    store i8 %56, i8* %52
    %57 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %58 = getelementptr inbounds [64 x i8], [64 x i8]* %57, i32 0, i32 60
    %59 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %60 = load i64, i64* %59
    %61 = lshr i64 %60, 24
    %62 = trunc i64 %61 to i8
    store i8 %62, i8* %58
    %63 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %64 = getelementptr inbounds [64 x i8], [64 x i8]* %63, i32 0, i32 59
    %65 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %66 = load i64, i64* %65
    %67 = lshr i64 %66, 32
    %68 = trunc i64 %67 to i8
    store i8 %68, i8* %64
    %69 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %70 = getelementptr inbounds [64 x i8], [64 x i8]* %69, i32 0, i32 58
    %71 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %72 = load i64, i64* %71
    %73 = lshr i64 %72, 40
    %74 = trunc i64 %73 to i8
    store i8 %74, i8* %70
    %75 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %76 = getelementptr inbounds [64 x i8], [64 x i8]* %75, i32 0, i32 57
    %77 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %78 = load i64, i64* %77
    %79 = lshr i64 %78, 48
    %80 = trunc i64 %79 to i8
    store i8 %80, i8* %76
    %81 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %82 = getelementptr inbounds [64 x i8], [64 x i8]* %81, i32 0, i32 56
    %83 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %84 = load i64, i64* %83
    %85 = lshr i64 %84, 56
    %86 = trunc i64 %85 to i8
    store i8 %86, i8* %82
    %87 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %88 = bitcast [64 x i8]* %87 to [0 x i8]*
    call void (%SHA256_Context*, [0 x i8]*) @sha256_transform(%SHA256_Context* %ctx, [0 x i8]* %88)
    ; Since this implementation uses little endian byte ordering
    ; and SHA uses big endian, reverse all the bytes
    ; when copying the final state to the output hash.
    store i32 0, i32* %1
    br label %again_1
again_1:
    %89 = load i32, i32* %1
    %90 = icmp ult i32 %89, 4
    br i1 %90 , label %body_1, label %break_1
body_1:
    %91 = load i32, i32* %1
    %92 = mul i32 %91, 8
    %93 = sub i32 24, %92
    %94 = load i32, i32* %1
    %95 = add i32 %94, 0
    %96 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %95
    %97 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %98 = getelementptr inbounds [8 x i32], [8 x i32]* %97, i32 0, i32 0
    %99 = load i32, i32* %98
    %100 = lshr i32 %99, %93
    %101 = trunc i32 %100 to i8
    store i8 %101, i8* %96
    %102 = load i32, i32* %1
    %103 = add i32 %102, 4
    %104 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %103
    %105 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %106 = getelementptr inbounds [8 x i32], [8 x i32]* %105, i32 0, i32 1
    %107 = load i32, i32* %106
    %108 = lshr i32 %107, %93
    %109 = trunc i32 %108 to i8
    store i8 %109, i8* %104
    %110 = load i32, i32* %1
    %111 = add i32 %110, 8
    %112 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %111
    %113 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %114 = getelementptr inbounds [8 x i32], [8 x i32]* %113, i32 0, i32 2
    %115 = load i32, i32* %114
    %116 = lshr i32 %115, %93
    %117 = trunc i32 %116 to i8
    store i8 %117, i8* %112
    %118 = load i32, i32* %1
    %119 = add i32 %118, 12
    %120 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %119
    %121 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %122 = getelementptr inbounds [8 x i32], [8 x i32]* %121, i32 0, i32 3
    %123 = load i32, i32* %122
    %124 = lshr i32 %123, %93
    %125 = trunc i32 %124 to i8
    store i8 %125, i8* %120
    %126 = load i32, i32* %1
    %127 = add i32 %126, 16
    %128 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %127
    %129 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %130 = getelementptr inbounds [8 x i32], [8 x i32]* %129, i32 0, i32 4
    %131 = load i32, i32* %130
    %132 = lshr i32 %131, %93
    %133 = trunc i32 %132 to i8
    store i8 %133, i8* %128
    %134 = load i32, i32* %1
    %135 = add i32 %134, 20
    %136 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %135
    %137 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %138 = getelementptr inbounds [8 x i32], [8 x i32]* %137, i32 0, i32 5
    %139 = load i32, i32* %138
    %140 = lshr i32 %139, %93
    %141 = trunc i32 %140 to i8
    store i8 %141, i8* %136
    %142 = load i32, i32* %1
    %143 = add i32 %142, 24
    %144 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %143
    %145 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %146 = getelementptr inbounds [8 x i32], [8 x i32]* %145, i32 0, i32 6
    %147 = load i32, i32* %146
    %148 = lshr i32 %147, %93
    %149 = trunc i32 %148 to i8
    store i8 %149, i8* %144
    %150 = load i32, i32* %1
    %151 = add i32 %150, 28
    %152 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %151
    %153 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %154 = getelementptr inbounds [8 x i32], [8 x i32]* %153, i32 0, i32 7
    %155 = load i32, i32* %154
    %156 = lshr i32 %155, %93
    %157 = trunc i32 %156 to i8
    store i8 %157, i8* %152
    %158 = load i32, i32* %1
    %159 = add i32 %158, 1
    store i32 %159, i32* %1
    br label %again_1
break_1:
    ret void
}



define void @sha256_doHash([0 x i8]* %msg, i32 %len, [0 x i8]* %hash) {
    %1 = alloca %SHA256_Context
    store %SHA256_Context zeroinitializer, %SHA256_Context* %1
    call void (%SHA256_Context*) @sha256_contextInit(%SHA256_Context* %1)
    call void (%SHA256_Context*, [0 x i8]*, i32) @sha256_update(%SHA256_Context* %1, [0 x i8]* %msg, i32 %len)
    call void (%SHA256_Context*, [0 x i8]*) @sha256_final(%SHA256_Context* %1, [0 x i8]* %hash)
    ret void
}


