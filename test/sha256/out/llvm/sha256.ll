
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
    ;ctx.state = initMagic  // not worked; FIXIT!
    %1 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %2 = bitcast [8 x i32]* %1 to i8*
    %3 = bitcast [8 x i32]* @initMagic to i8*
    %4 = call i8* (i8*, i8*, %SizeT) @memcpy(i8* %2, i8* %3, %SizeT 32)
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
    %1 = insertvalue [64 x i32] zeroinitializer, i32 0, 0
    %2 = insertvalue [64 x i32] %1, i32 0, 1
    %3 = insertvalue [64 x i32] %2, i32 0, 2
    %4 = insertvalue [64 x i32] %3, i32 0, 3
    %5 = insertvalue [64 x i32] %4, i32 0, 4
    %6 = insertvalue [64 x i32] %5, i32 0, 5
    %7 = insertvalue [64 x i32] %6, i32 0, 6
    %8 = insertvalue [64 x i32] %7, i32 0, 7
    %9 = insertvalue [64 x i32] %8, i32 0, 8
    %10 = insertvalue [64 x i32] %9, i32 0, 9
    %11 = insertvalue [64 x i32] %10, i32 0, 10
    %12 = insertvalue [64 x i32] %11, i32 0, 11
    %13 = insertvalue [64 x i32] %12, i32 0, 12
    %14 = insertvalue [64 x i32] %13, i32 0, 13
    %15 = insertvalue [64 x i32] %14, i32 0, 14
    %16 = insertvalue [64 x i32] %15, i32 0, 15
    %17 = insertvalue [64 x i32] %16, i32 0, 16
    %18 = insertvalue [64 x i32] %17, i32 0, 17
    %19 = insertvalue [64 x i32] %18, i32 0, 18
    %20 = insertvalue [64 x i32] %19, i32 0, 19
    %21 = insertvalue [64 x i32] %20, i32 0, 20
    %22 = insertvalue [64 x i32] %21, i32 0, 21
    %23 = insertvalue [64 x i32] %22, i32 0, 22
    %24 = insertvalue [64 x i32] %23, i32 0, 23
    %25 = insertvalue [64 x i32] %24, i32 0, 24
    %26 = insertvalue [64 x i32] %25, i32 0, 25
    %27 = insertvalue [64 x i32] %26, i32 0, 26
    %28 = insertvalue [64 x i32] %27, i32 0, 27
    %29 = insertvalue [64 x i32] %28, i32 0, 28
    %30 = insertvalue [64 x i32] %29, i32 0, 29
    %31 = insertvalue [64 x i32] %30, i32 0, 30
    %32 = insertvalue [64 x i32] %31, i32 0, 31
    %33 = insertvalue [64 x i32] %32, i32 0, 32
    %34 = insertvalue [64 x i32] %33, i32 0, 33
    %35 = insertvalue [64 x i32] %34, i32 0, 34
    %36 = insertvalue [64 x i32] %35, i32 0, 35
    %37 = insertvalue [64 x i32] %36, i32 0, 36
    %38 = insertvalue [64 x i32] %37, i32 0, 37
    %39 = insertvalue [64 x i32] %38, i32 0, 38
    %40 = insertvalue [64 x i32] %39, i32 0, 39
    %41 = insertvalue [64 x i32] %40, i32 0, 40
    %42 = insertvalue [64 x i32] %41, i32 0, 41
    %43 = insertvalue [64 x i32] %42, i32 0, 42
    %44 = insertvalue [64 x i32] %43, i32 0, 43
    %45 = insertvalue [64 x i32] %44, i32 0, 44
    %46 = insertvalue [64 x i32] %45, i32 0, 45
    %47 = insertvalue [64 x i32] %46, i32 0, 46
    %48 = insertvalue [64 x i32] %47, i32 0, 47
    %49 = insertvalue [64 x i32] %48, i32 0, 48
    %50 = insertvalue [64 x i32] %49, i32 0, 49
    %51 = insertvalue [64 x i32] %50, i32 0, 50
    %52 = insertvalue [64 x i32] %51, i32 0, 51
    %53 = insertvalue [64 x i32] %52, i32 0, 52
    %54 = insertvalue [64 x i32] %53, i32 0, 53
    %55 = insertvalue [64 x i32] %54, i32 0, 54
    %56 = insertvalue [64 x i32] %55, i32 0, 55
    %57 = insertvalue [64 x i32] %56, i32 0, 56
    %58 = insertvalue [64 x i32] %57, i32 0, 57
    %59 = insertvalue [64 x i32] %58, i32 0, 58
    %60 = insertvalue [64 x i32] %59, i32 0, 59
    %61 = insertvalue [64 x i32] %60, i32 0, 60
    %62 = insertvalue [64 x i32] %61, i32 0, 61
    %63 = insertvalue [64 x i32] %62, i32 0, 62
    %64 = insertvalue [64 x i32] %63, i32 0, 63
    %65 = alloca [64 x i32]
    store [64 x i32] %64, [64 x i32]* %65
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
    %98 = getelementptr inbounds [64 x i32], [64 x i32]* %65, i32 0, i32 %97
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
    %106 = sub i32 %105, 2
    %107 = getelementptr inbounds [64 x i32], [64 x i32]* %65, i32 0, i32 %106
    %108 = load i32, i32* %107
    %109 = call i32 (i32) @sig1(i32 %108)
    %110 = load i32, i32* %66
    %111 = sub i32 %110, 7
    %112 = getelementptr inbounds [64 x i32], [64 x i32]* %65, i32 0, i32 %111
    %113 = load i32, i32* %112
    %114 = add i32 %109, %113
    %115 = load i32, i32* %66
    %116 = sub i32 %115, 15
    %117 = getelementptr inbounds [64 x i32], [64 x i32]* %65, i32 0, i32 %116
    %118 = load i32, i32* %117
    %119 = call i32 (i32) @sig0(i32 %118)
    %120 = add i32 %114, %119
    %121 = load i32, i32* %66
    %122 = sub i32 %121, 16
    %123 = getelementptr inbounds [64 x i32], [64 x i32]* %65, i32 0, i32 %122
    %124 = load i32, i32* %123
    %125 = add i32 %120, %124
    %126 = load i32, i32* %66
    %127 = getelementptr inbounds [64 x i32], [64 x i32]* %65, i32 0, i32 %126
    store i32 %125, i32* %127
    %128 = load i32, i32* %66
    %129 = add i32 %128, 1
    store i32 %129, i32* %66
    br label %again_2
break_2:
    %130 = alloca [8 x i32]
    %131 = bitcast [8 x i32]* %130 to i8*
    %132 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %133 = bitcast [8 x i32]* %132 to i8*
    %134 = call i8* (i8*, i8*, %SizeT) @memcpy(i8* %131, i8* %133, %SizeT 32)
    store i32 0, i32* %66
    br label %again_3
again_3:
    %135 = load i32, i32* %66
    %136 = icmp ult i32 %135, 64
    br i1 %136 , label %body_3, label %break_3
body_3:
    %137 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 7
    %138 = load i32, i32* %137
    %139 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
    %140 = load i32, i32* %139
    %141 = call i32 (i32) @ep1(i32 %140)
    %142 = add i32 %138, %141
    %143 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
    %144 = load i32, i32* %143
    %145 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 5
    %146 = load i32, i32* %145
    %147 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 6
    %148 = load i32, i32* %147
    %149 = call i32 (i32, i32, i32) @ch(i32 %144, i32 %146, i32 %148)
    %150 = add i32 %142, %149
    %151 = load i32, i32* %66
    %152 = getelementptr inbounds [64 x i32], [64 x i32]* @k, i32 0, i32 %151
    %153 = load i32, i32* %152
    %154 = add i32 %150, %153
    %155 = load i32, i32* %66
    %156 = getelementptr inbounds [64 x i32], [64 x i32]* %65, i32 0, i32 %155
    %157 = load i32, i32* %156
    %158 = add i32 %154, %157
    %159 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 0
    %160 = load i32, i32* %159
    %161 = call i32 (i32) @ep0(i32 %160)
    %162 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 0
    %163 = load i32, i32* %162
    %164 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 1
    %165 = load i32, i32* %164
    %166 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 2
    %167 = load i32, i32* %166
    %168 = call i32 (i32, i32, i32) @maj(i32 %163, i32 %165, i32 %167)
    %169 = add i32 %161, %168
    %170 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 6
    %171 = load i32, i32* %170
    %172 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 7
    store i32 %171, i32* %172
    %173 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 5
    %174 = load i32, i32* %173
    %175 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 6
    store i32 %174, i32* %175
    %176 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
    %177 = load i32, i32* %176
    %178 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 5
    store i32 %177, i32* %178
    %179 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 3
    %180 = load i32, i32* %179
    %181 = add i32 %180, %158
    %182 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 4
    store i32 %181, i32* %182
    %183 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 2
    %184 = load i32, i32* %183
    %185 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 3
    store i32 %184, i32* %185
    %186 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 1
    %187 = load i32, i32* %186
    %188 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 2
    store i32 %187, i32* %188
    %189 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 0
    %190 = load i32, i32* %189
    %191 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 1
    store i32 %190, i32* %191
    %192 = add i32 %158, %169
    %193 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 0
    store i32 %192, i32* %193
    %194 = load i32, i32* %66
    %195 = add i32 %194, 1
    store i32 %195, i32* %66
    br label %again_3
break_3:
    store i32 0, i32* %66
    br label %again_4
again_4:
    %196 = load i32, i32* %66
    %197 = icmp ult i32 %196, 8
    br i1 %197 , label %body_4, label %break_4
body_4:
    %198 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %199 = load i32, i32* %66
    %200 = getelementptr inbounds [8 x i32], [8 x i32]* %198, i32 0, i32 %199
    %201 = load i32, i32* %200
    %202 = load i32, i32* %66
    %203 = getelementptr inbounds [8 x i32], [8 x i32]* %130, i32 0, i32 %202
    %204 = load i32, i32* %203
    %205 = add i32 %201, %204
    %206 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %207 = load i32, i32* %66
    %208 = getelementptr inbounds [8 x i32], [8 x i32]* %206, i32 0, i32 %207
    store i32 %205, i32* %208
    %209 = load i32, i32* %66
    %210 = add i32 %209, 1
    store i32 %210, i32* %66
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
    %4 = load i32, i32* %1
    %5 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %4
    %6 = load i8, i8* %5
    %7 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %8 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %9 = load i32, i32* %8
    %10 = getelementptr inbounds [64 x i8], [64 x i8]* %7, i32 0, i32 %9
    store i8 %6, i8* %10
    %11 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %12 = load i32, i32* %11
    %13 = add i32 %12, 1
    %14 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    store i32 %13, i32* %14
    %15 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %16 = load i32, i32* %15
    %17 = icmp eq i32 %16, 64
    br i1 %17 , label %then_0, label %endif_0
then_0:
    %18 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %19 = bitcast [64 x i8]* %18 to [0 x i8]*
    call void (%SHA256_Context*, [0 x i8]*) @sha256_transform(%SHA256_Context* %ctx, [0 x i8]* %19)
    %20 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %21 = load i64, i64* %20
    %22 = add i64 %21, 512
    %23 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    store i64 %22, i64* %23
    %24 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
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

define void @sha256_final(%SHA256_Context* %ctx, [0 x i8]* %hash) {
    %1 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %2 = load i32, i32* %1
    %3 = alloca i32
    store i32 %2, i32* %3
    ; Pad whatever data is left in the buffer.
    %4 = alloca i32
    store i32 64, i32* %4
    %5 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %6 = load i32, i32* %5
    %7 = icmp ult i32 %6, 56
    br i1 %7 , label %then_0, label %endif_0
then_0:
    store i32 56, i32* %4
    br label %endif_0
endif_0:
    %8 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %9 = load i32, i32* %3
    %10 = getelementptr inbounds [64 x i8], [64 x i8]* %8, i32 0, i32 %9
    store i8 128, i8* %10
    %11 = load i32, i32* %3
    %12 = add i32 %11, 1
    store i32 %12, i32* %3
    %13 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %14 = load i32, i32* %3
    %15 = getelementptr inbounds [64 x i8], [64 x i8]* %13, i32 0, i32 %14
    %16 = bitcast i8* %15 to i8*
    %17 = load i32, i32* %4
    %18 = load i32, i32* %3
    %19 = sub i32 %17, %18
    %20 = zext i32 %19 to %SizeT
    %21 = call i8* (i8*, %Int, %SizeT) @memset(i8* %16, %Int 0, %SizeT %20)
    %22 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %23 = load i32, i32* %22
    %24 = icmp uge i32 %23, 56
    br i1 %24 , label %then_1, label %endif_1
then_1:
    %25 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %26 = bitcast [64 x i8]* %25 to [0 x i8]*
    call void (%SHA256_Context*, [0 x i8]*) @sha256_transform(%SHA256_Context* %ctx, [0 x i8]* %26)
    %27 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %28 = bitcast [64 x i8]* %27 to i8*
    %29 = call i8* (i8*, %Int, %SizeT) @memset(i8* %28, %Int 0, %SizeT 56)
    br label %endif_1
endif_1:
    ; Append to the padding the total message's length in bits and transform.
    %30 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %31 = load i64, i64* %30
    %32 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %33 = load i32, i32* %32
    %34 = zext i32 %33 to i64
    %35 = mul i64 %34, 8
    %36 = add i64 %31, %35
    %37 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    store i64 %36, i64* %37
    %38 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %39 = load i64, i64* %38
    %40 = lshr i64 %39, 0
    %41 = trunc i64 %40 to i8
    %42 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %43 = getelementptr inbounds [64 x i8], [64 x i8]* %42, i32 0, i32 63
    store i8 %41, i8* %43
    %44 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %45 = load i64, i64* %44
    %46 = lshr i64 %45, 8
    %47 = trunc i64 %46 to i8
    %48 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %49 = getelementptr inbounds [64 x i8], [64 x i8]* %48, i32 0, i32 62
    store i8 %47, i8* %49
    %50 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %51 = load i64, i64* %50
    %52 = lshr i64 %51, 16
    %53 = trunc i64 %52 to i8
    %54 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %55 = getelementptr inbounds [64 x i8], [64 x i8]* %54, i32 0, i32 61
    store i8 %53, i8* %55
    %56 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %57 = load i64, i64* %56
    %58 = lshr i64 %57, 24
    %59 = trunc i64 %58 to i8
    %60 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %61 = getelementptr inbounds [64 x i8], [64 x i8]* %60, i32 0, i32 60
    store i8 %59, i8* %61
    %62 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %63 = load i64, i64* %62
    %64 = lshr i64 %63, 32
    %65 = trunc i64 %64 to i8
    %66 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %67 = getelementptr inbounds [64 x i8], [64 x i8]* %66, i32 0, i32 59
    store i8 %65, i8* %67
    %68 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %69 = load i64, i64* %68
    %70 = lshr i64 %69, 40
    %71 = trunc i64 %70 to i8
    %72 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %73 = getelementptr inbounds [64 x i8], [64 x i8]* %72, i32 0, i32 58
    store i8 %71, i8* %73
    %74 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %75 = load i64, i64* %74
    %76 = lshr i64 %75, 48
    %77 = trunc i64 %76 to i8
    %78 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %79 = getelementptr inbounds [64 x i8], [64 x i8]* %78, i32 0, i32 57
    store i8 %77, i8* %79
    %80 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %81 = load i64, i64* %80
    %82 = lshr i64 %81, 56
    %83 = trunc i64 %82 to i8
    %84 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %85 = getelementptr inbounds [64 x i8], [64 x i8]* %84, i32 0, i32 56
    store i8 %83, i8* %85
    %86 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %87 = bitcast [64 x i8]* %86 to [0 x i8]*
    call void (%SHA256_Context*, [0 x i8]*) @sha256_transform(%SHA256_Context* %ctx, [0 x i8]* %87)
    ; Since this implementation uses little endian byte ordering
    ; and SHA uses big endian, reverse all the bytes
    ; when copying the final state to the output hash.
    store i32 0, i32* %3
    br label %again_1
again_1:
    %88 = load i32, i32* %3
    %89 = icmp ult i32 %88, 4
    br i1 %89 , label %body_1, label %break_1
body_1:
    %90 = load i32, i32* %3
    %91 = mul i32 %90, 8
    %92 = sub i32 24, %91
    %93 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %94 = getelementptr inbounds [8 x i32], [8 x i32]* %93, i32 0, i32 0
    %95 = load i32, i32* %94
    %96 = lshr i32 %95, %92
    %97 = trunc i32 %96 to i8
    %98 = load i32, i32* %3
    %99 = add i32 %98, 0
    %100 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %99
    store i8 %97, i8* %100
    %101 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %102 = getelementptr inbounds [8 x i32], [8 x i32]* %101, i32 0, i32 1
    %103 = load i32, i32* %102
    %104 = lshr i32 %103, %92
    %105 = trunc i32 %104 to i8
    %106 = load i32, i32* %3
    %107 = add i32 %106, 4
    %108 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %107
    store i8 %105, i8* %108
    %109 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %110 = getelementptr inbounds [8 x i32], [8 x i32]* %109, i32 0, i32 2
    %111 = load i32, i32* %110
    %112 = lshr i32 %111, %92
    %113 = trunc i32 %112 to i8
    %114 = load i32, i32* %3
    %115 = add i32 %114, 8
    %116 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %115
    store i8 %113, i8* %116
    %117 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %118 = getelementptr inbounds [8 x i32], [8 x i32]* %117, i32 0, i32 3
    %119 = load i32, i32* %118
    %120 = lshr i32 %119, %92
    %121 = trunc i32 %120 to i8
    %122 = load i32, i32* %3
    %123 = add i32 %122, 12
    %124 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %123
    store i8 %121, i8* %124
    %125 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %126 = getelementptr inbounds [8 x i32], [8 x i32]* %125, i32 0, i32 4
    %127 = load i32, i32* %126
    %128 = lshr i32 %127, %92
    %129 = trunc i32 %128 to i8
    %130 = load i32, i32* %3
    %131 = add i32 %130, 16
    %132 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %131
    store i8 %129, i8* %132
    %133 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %134 = getelementptr inbounds [8 x i32], [8 x i32]* %133, i32 0, i32 5
    %135 = load i32, i32* %134
    %136 = lshr i32 %135, %92
    %137 = trunc i32 %136 to i8
    %138 = load i32, i32* %3
    %139 = add i32 %138, 20
    %140 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %139
    store i8 %137, i8* %140
    %141 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %142 = getelementptr inbounds [8 x i32], [8 x i32]* %141, i32 0, i32 6
    %143 = load i32, i32* %142
    %144 = lshr i32 %143, %92
    %145 = trunc i32 %144 to i8
    %146 = load i32, i32* %3
    %147 = add i32 %146, 24
    %148 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %147
    store i8 %145, i8* %148
    %149 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %150 = getelementptr inbounds [8 x i32], [8 x i32]* %149, i32 0, i32 7
    %151 = load i32, i32* %150
    %152 = lshr i32 %151, %92
    %153 = trunc i32 %152 to i8
    %154 = load i32, i32* %3
    %155 = add i32 %154, 28
    %156 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %155
    store i8 %153, i8* %156
    %157 = load i32, i32* %3
    %158 = add i32 %157, 1
    store i32 %158, i32* %3
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


