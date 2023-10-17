
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type [0 x i8]*
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
















declare i32 @creat(%Str, i32)
declare i32 @open(%Str, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir(%Str)
declare i32 @closedir(%DIR*)


declare %Str @getcwd(%Str, i64)
declare %Str @getenv(%Str)


declare void @bzero(i8*, i64)


declare void @bcopy(i8*, i8*, i64)

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
    %2 = xor  i32 %x, -1
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
    %1 = call i32(i32, i32) @rotright (i32 %x, i32 2)
    %2 = call i32(i32, i32) @rotright (i32 %x, i32 13)
    %3 = call i32(i32, i32) @rotright (i32 %x, i32 22)
    %4 = xor i32 %2, %3
    %5 = xor i32 %1, %4
    ret i32 %5
}

define i32 @ep1(i32 %x) {
    %1 = call i32(i32, i32) @rotright (i32 %x, i32 6)
    %2 = call i32(i32, i32) @rotright (i32 %x, i32 11)
    %3 = call i32(i32, i32) @rotright (i32 %x, i32 25)
    %4 = xor i32 %2, %3
    %5 = xor i32 %1, %4
    ret i32 %5
}

define i32 @sig0(i32 %x) {
    %1 = call i32(i32, i32) @rotright (i32 %x, i32 7)
    %2 = call i32(i32, i32) @rotright (i32 %x, i32 18)
    %3 = lshr i32 %x, 3
    %4 = xor i32 %2, %3
    %5 = xor i32 %1, %4
    ret i32 %5
}

define i32 @sig1(i32 %x) {
    %1 = call i32(i32, i32) @rotright (i32 %x, i32 17)
    %2 = call i32(i32, i32) @rotright (i32 %x, i32 19)
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
;ctx.state := initMagic  // not worked; FIXIT!
    %1 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %2 = bitcast [8 x i32]* %1 to i8*
    %3 = bitcast [8 x i32]* @initMagic to i8*
    %4 = call i8*(i8*, i8*, i64) @memcpy (i8* %2, i8* %3, i64 32)
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
    %m = alloca [64 x i32]
    store [64 x i32] %64, [64 x i32]* %m
    %i = alloca i32
    store i32 0, i32* %i
    %j = alloca i32
    store i32 0, i32* %j
    br label %again_1
again_1:
    %65 = load i32, i32* %i
    %66 = icmp ult i32 %65, 16
    br i1 %66 , label %body_1, label %break_1
body_1:
    %67 = load i32, i32* %j
    %68 = add i32 %67, 0
    %69 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %68
    %70 = load i8, i8* %69
    %71 = zext i8 %70 to i32
    %72 = shl i32 %71, 24
    %73 = load i32, i32* %j
    %74 = add i32 %73, 1
    %75 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %74
    %76 = load i8, i8* %75
    %77 = zext i8 %76 to i32
    %78 = shl i32 %77, 16
    %79 = load i32, i32* %j
    %80 = add i32 %79, 2
    %81 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %80
    %82 = load i8, i8* %81
    %83 = zext i8 %82 to i32
    %84 = shl i32 %83, 8
    %85 = load i32, i32* %j
    %86 = add i32 %85, 3
    %87 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %86
    %88 = load i8, i8* %87
    %89 = zext i8 %88 to i32
    %90 = shl i32 %89, 0
    %91 = or i32 %84, %90
    %92 = or i32 %78, %91
    %93 = or i32 %72, %92
    %94 = load i32, i32* %i
    %95 = getelementptr inbounds [64 x i32], [64 x i32]* %m, i32 0, i32 %94
    store i32 %93, i32* %95
    %96 = load i32, i32* %j
    %97 = add i32 %96, 4
    store i32 %97, i32* %j
    %98 = load i32, i32* %i
    %99 = add i32 %98, 1
    store i32 %99, i32* %i
    br label %again_1
break_1:
    br label %again_2
again_2:
    %100 = load i32, i32* %i
    %101 = icmp ult i32 %100, 64
    br i1 %101 , label %body_2, label %break_2
body_2:
    %102 = load i32, i32* %i
    %103 = sub i32 %102, 2
    %104 = getelementptr inbounds [64 x i32], [64 x i32]* %m, i32 0, i32 %103
    %105 = load i32, i32* %104
    %106 = call i32(i32) @sig1 (i32 %105)
    %107 = load i32, i32* %i
    %108 = sub i32 %107, 7
    %109 = getelementptr inbounds [64 x i32], [64 x i32]* %m, i32 0, i32 %108
    %110 = load i32, i32* %109
    %111 = add i32 %106, %110
    %112 = load i32, i32* %i
    %113 = sub i32 %112, 15
    %114 = getelementptr inbounds [64 x i32], [64 x i32]* %m, i32 0, i32 %113
    %115 = load i32, i32* %114
    %116 = call i32(i32) @sig0 (i32 %115)
    %117 = add i32 %111, %116
    %118 = load i32, i32* %i
    %119 = sub i32 %118, 16
    %120 = getelementptr inbounds [64 x i32], [64 x i32]* %m, i32 0, i32 %119
    %121 = load i32, i32* %120
    %122 = add i32 %117, %121
    %123 = load i32, i32* %i
    %124 = getelementptr inbounds [64 x i32], [64 x i32]* %m, i32 0, i32 %123
    store i32 %122, i32* %124
    %125 = load i32, i32* %i
    %126 = add i32 %125, 1
    store i32 %126, i32* %i
    br label %again_2
break_2:
    %x = alloca [8 x i32]
    %127 = bitcast [8 x i32]* %x to i8*
    %128 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %129 = bitcast [8 x i32]* %128 to i8*
    %130 = call i8*(i8*, i8*, i64) @memcpy (i8* %127, i8* %129, i64 32)
    store i32 0, i32* %i
    br label %again_3
again_3:
    %131 = load i32, i32* %i
    %132 = icmp ult i32 %131, 64
    br i1 %132 , label %body_3, label %break_3
body_3:
    %133 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 7
    %134 = load i32, i32* %133
    %135 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 4
    %136 = load i32, i32* %135
    %137 = call i32(i32) @ep1 (i32 %136)
    %138 = add i32 %134, %137
    %139 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 4
    %140 = load i32, i32* %139
    %141 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 5
    %142 = load i32, i32* %141
    %143 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 6
    %144 = load i32, i32* %143
    %145 = call i32(i32, i32, i32) @ch (i32 %140, i32 %142, i32 %144)
    %146 = add i32 %138, %145
    %147 = load i32, i32* %i
    %148 = getelementptr inbounds [64 x i32], [64 x i32]* @k, i32 0, i32 %147
    %149 = load i32, i32* %148
    %150 = add i32 %146, %149
    %151 = load i32, i32* %i
    %152 = getelementptr inbounds [64 x i32], [64 x i32]* %m, i32 0, i32 %151
    %153 = load i32, i32* %152
    %154 = add i32 %150, %153
    %155 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 0
    %156 = load i32, i32* %155
    %157 = call i32(i32) @ep0 (i32 %156)
    %158 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 0
    %159 = load i32, i32* %158
    %160 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 1
    %161 = load i32, i32* %160
    %162 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 2
    %163 = load i32, i32* %162
    %164 = call i32(i32, i32, i32) @maj (i32 %159, i32 %161, i32 %163)
    %165 = add i32 %157, %164
    %166 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 6
    %167 = load i32, i32* %166
    %168 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 7
    store i32 %167, i32* %168
    %169 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 5
    %170 = load i32, i32* %169
    %171 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 6
    store i32 %170, i32* %171
    %172 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 4
    %173 = load i32, i32* %172
    %174 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 5
    store i32 %173, i32* %174
    %175 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 3
    %176 = load i32, i32* %175
    %177 = add i32 %176, %154
    %178 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 4
    store i32 %177, i32* %178
    %179 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 2
    %180 = load i32, i32* %179
    %181 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 3
    store i32 %180, i32* %181
    %182 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 1
    %183 = load i32, i32* %182
    %184 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 2
    store i32 %183, i32* %184
    %185 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 0
    %186 = load i32, i32* %185
    %187 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 1
    store i32 %186, i32* %187
    %188 = add i32 %154, %165
    %189 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 0
    store i32 %188, i32* %189
    %190 = load i32, i32* %i
    %191 = add i32 %190, 1
    store i32 %191, i32* %i
    br label %again_3
break_3:
    store i32 0, i32* %i
    br label %again_4
again_4:
    %192 = load i32, i32* %i
    %193 = icmp ult i32 %192, 8
    br i1 %193 , label %body_4, label %break_4
body_4:
    %194 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %195 = load i32, i32* %i
    %196 = getelementptr inbounds [8 x i32], [8 x i32]* %194, i32 0, i32 %195
    %197 = load i32, i32* %196
    %198 = load i32, i32* %i
    %199 = getelementptr inbounds [8 x i32], [8 x i32]* %x, i32 0, i32 %198
    %200 = load i32, i32* %199
    %201 = add i32 %197, %200
    %202 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %203 = load i32, i32* %i
    %204 = getelementptr inbounds [8 x i32], [8 x i32]* %202, i32 0, i32 %203
    store i32 %201, i32* %204
    %205 = load i32, i32* %i
    %206 = add i32 %205, 1
    store i32 %206, i32* %i
    br label %again_4
break_4:
    ret void
}

define void @sha256_update(%SHA256_Context* %ctx, [0 x i8]* %data, i32 %len) {
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    %1 = load i32, i32* %i
    %2 = icmp ult i32 %1, %len
    br i1 %2 , label %body_1, label %break_1
body_1:
    %3 = load i32, i32* %i
    %4 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %3
    %5 = load i8, i8* %4
    %6 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %7 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %8 = load i32, i32* %7
    %9 = getelementptr inbounds [64 x i8], [64 x i8]* %6, i32 0, i32 %8
    store i8 %5, i8* %9
    %10 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %11 = load i32, i32* %10
    %12 = add i32 %11, 1
    %13 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    store i32 %12, i32* %13
    %14 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %15 = load i32, i32* %14
    %16 = icmp eq i32 %15, 64
    br i1 %16 , label %then_0, label %endif_0
then_0:
    %17 = bitcast %SHA256_Context* %ctx to %SHA256_Context*
    %18 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %19 = bitcast [64 x i8]* %18 to [0 x i8]*
    call void(%SHA256_Context*, [0 x i8]*) @sha256_transform (%SHA256_Context* %17, [0 x i8]* %19)
    %20 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %21 = load i64, i64* %20
    %22 = add i64 %21, 512
    %23 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    store i64 %22, i64* %23
    %24 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    store i32 0, i32* %24
    br label %endif_0
endif_0:
    %25 = load i32, i32* %i
    %26 = add i32 %25, 1
    store i32 %26, i32* %i
    br label %again_1
break_1:
    ret void
}

define void @sha256_final(%SHA256_Context* %ctx, [0 x i8]* %hash) {
    %1 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %i = alloca i32
    %2 = load i32, i32* %1
    store i32 %2, i32* %i
; Pad whatever data is left in the buffer.
    %n = alloca i32
    store i32 64, i32* %n
    %3 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %4 = load i32, i32* %3
    %5 = icmp ult i32 %4, 56
    br i1 %5 , label %then_0, label %endif_0
then_0:
    store i32 56, i32* %n
    br label %endif_0
endif_0:
    %6 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %7 = load i32, i32* %i
    %8 = getelementptr inbounds [64 x i8], [64 x i8]* %6, i32 0, i32 %7
    store i8 128, i8* %8
    %9 = load i32, i32* %i
    %10 = add i32 %9, 1
    store i32 %10, i32* %i
    %11 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %12 = load i32, i32* %i
    %13 = getelementptr inbounds [64 x i8], [64 x i8]* %11, i32 0, i32 %12
    %14 = bitcast i8* %13 to i8*
    %15 = load i32, i32* %n
    %16 = load i32, i32* %i
    %17 = sub i32 %15, %16
    %18 = zext i32 %17 to i64
    %19 = call i8*(i8*, i32, i64) @memset (i8* %14, i32 0, i64 %18)
    %20 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %21 = load i32, i32* %20
    %22 = icmp uge i32 %21, 56
    br i1 %22 , label %then_1, label %endif_1
then_1:
    %23 = bitcast %SHA256_Context* %ctx to %SHA256_Context*
    %24 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %25 = bitcast [64 x i8]* %24 to [0 x i8]*
    call void(%SHA256_Context*, [0 x i8]*) @sha256_transform (%SHA256_Context* %23, [0 x i8]* %25)
    %26 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %27 = bitcast [64 x i8]* %26 to i8*
    %28 = call i8*(i8*, i32, i64) @memset (i8* %27, i32 0, i64 56)
    br label %endif_1
endif_1:
; Append to the padding the total message's length in bits and transform.
    %29 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %30 = load i64, i64* %29
    %31 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %32 = load i32, i32* %31
    %33 = zext i32 %32 to i64
    %34 = mul i64 %33, 8
    %35 = add i64 %30, %34
    %36 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    store i64 %35, i64* %36
    %37 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %38 = load i64, i64* %37
    %39 = lshr i64 %38, 0
    %40 = trunc i64 %39 to i8
    %41 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %42 = getelementptr inbounds [64 x i8], [64 x i8]* %41, i32 0, i32 63
    store i8 %40, i8* %42
    %43 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %44 = load i64, i64* %43
    %45 = lshr i64 %44, 8
    %46 = trunc i64 %45 to i8
    %47 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %48 = getelementptr inbounds [64 x i8], [64 x i8]* %47, i32 0, i32 62
    store i8 %46, i8* %48
    %49 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %50 = load i64, i64* %49
    %51 = lshr i64 %50, 16
    %52 = trunc i64 %51 to i8
    %53 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %54 = getelementptr inbounds [64 x i8], [64 x i8]* %53, i32 0, i32 61
    store i8 %52, i8* %54
    %55 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %56 = load i64, i64* %55
    %57 = lshr i64 %56, 24
    %58 = trunc i64 %57 to i8
    %59 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %60 = getelementptr inbounds [64 x i8], [64 x i8]* %59, i32 0, i32 60
    store i8 %58, i8* %60
    %61 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %62 = load i64, i64* %61
    %63 = lshr i64 %62, 32
    %64 = trunc i64 %63 to i8
    %65 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %66 = getelementptr inbounds [64 x i8], [64 x i8]* %65, i32 0, i32 59
    store i8 %64, i8* %66
    %67 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %68 = load i64, i64* %67
    %69 = lshr i64 %68, 40
    %70 = trunc i64 %69 to i8
    %71 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %72 = getelementptr inbounds [64 x i8], [64 x i8]* %71, i32 0, i32 58
    store i8 %70, i8* %72
    %73 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %74 = load i64, i64* %73
    %75 = lshr i64 %74, 48
    %76 = trunc i64 %75 to i8
    %77 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %78 = getelementptr inbounds [64 x i8], [64 x i8]* %77, i32 0, i32 57
    store i8 %76, i8* %78
    %79 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %80 = load i64, i64* %79
    %81 = lshr i64 %80, 56
    %82 = trunc i64 %81 to i8
    %83 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %84 = getelementptr inbounds [64 x i8], [64 x i8]* %83, i32 0, i32 56
    store i8 %82, i8* %84
    %85 = bitcast %SHA256_Context* %ctx to %SHA256_Context*
    %86 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %87 = bitcast [64 x i8]* %86 to [0 x i8]*
    call void(%SHA256_Context*, [0 x i8]*) @sha256_transform (%SHA256_Context* %85, [0 x i8]* %87)
; Since this implementation uses little endian byte ordering
; and SHA uses big endian, reverse all the bytes
; when copying the final state to the output hash.
    store i32 0, i32* %i
    br label %again_1
again_1:
    %88 = load i32, i32* %i
    %89 = icmp ult i32 %88, 4
    br i1 %89 , label %body_1, label %break_1
body_1:
    %90 = load i32, i32* %i
    %91 = mul i32 %90, 8
    %92 = sub i32 24, %91
    %93 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %94 = getelementptr inbounds [8 x i32], [8 x i32]* %93, i32 0, i32 0
    %95 = load i32, i32* %94
    %96 = lshr i32 %95, %92
    %97 = trunc i32 %96 to i8
    %98 = load i32, i32* %i
    %99 = add i32 %98, 0
    %100 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %99
    store i8 %97, i8* %100
    %101 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %102 = getelementptr inbounds [8 x i32], [8 x i32]* %101, i32 0, i32 1
    %103 = load i32, i32* %102
    %104 = lshr i32 %103, %92
    %105 = trunc i32 %104 to i8
    %106 = load i32, i32* %i
    %107 = add i32 %106, 4
    %108 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %107
    store i8 %105, i8* %108
    %109 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %110 = getelementptr inbounds [8 x i32], [8 x i32]* %109, i32 0, i32 2
    %111 = load i32, i32* %110
    %112 = lshr i32 %111, %92
    %113 = trunc i32 %112 to i8
    %114 = load i32, i32* %i
    %115 = add i32 %114, 8
    %116 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %115
    store i8 %113, i8* %116
    %117 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %118 = getelementptr inbounds [8 x i32], [8 x i32]* %117, i32 0, i32 3
    %119 = load i32, i32* %118
    %120 = lshr i32 %119, %92
    %121 = trunc i32 %120 to i8
    %122 = load i32, i32* %i
    %123 = add i32 %122, 12
    %124 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %123
    store i8 %121, i8* %124
    %125 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %126 = getelementptr inbounds [8 x i32], [8 x i32]* %125, i32 0, i32 4
    %127 = load i32, i32* %126
    %128 = lshr i32 %127, %92
    %129 = trunc i32 %128 to i8
    %130 = load i32, i32* %i
    %131 = add i32 %130, 16
    %132 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %131
    store i8 %129, i8* %132
    %133 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %134 = getelementptr inbounds [8 x i32], [8 x i32]* %133, i32 0, i32 5
    %135 = load i32, i32* %134
    %136 = lshr i32 %135, %92
    %137 = trunc i32 %136 to i8
    %138 = load i32, i32* %i
    %139 = add i32 %138, 20
    %140 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %139
    store i8 %137, i8* %140
    %141 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %142 = getelementptr inbounds [8 x i32], [8 x i32]* %141, i32 0, i32 6
    %143 = load i32, i32* %142
    %144 = lshr i32 %143, %92
    %145 = trunc i32 %144 to i8
    %146 = load i32, i32* %i
    %147 = add i32 %146, 24
    %148 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %147
    store i8 %145, i8* %148
    %149 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %150 = getelementptr inbounds [8 x i32], [8 x i32]* %149, i32 0, i32 7
    %151 = load i32, i32* %150
    %152 = lshr i32 %151, %92
    %153 = trunc i32 %152 to i8
    %154 = load i32, i32* %i
    %155 = add i32 %154, 28
    %156 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %155
    store i8 %153, i8* %156
    %157 = load i32, i32* %i
    %158 = add i32 %157, 1
    store i32 %158, i32* %i
    br label %again_1
break_1:
    ret void
}



define void @sha256_doHash([0 x i8]* %msg, i32 %len, [0 x i8]* %hash) {
    %ctx = alloca %SHA256_Context

; -- record assign
    %1 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    store [64 x i8] zeroinitializer, [64 x i8]* %1
    %2 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    store i32 0, i32* %2
    %3 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    store i64 0, i64* %3
    %4 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    store [8 x i32] zeroinitializer, [8 x i32]* %4
; -- end record assign

    %5 = bitcast %SHA256_Context* %ctx to %SHA256_Context*
    call void(%SHA256_Context*) @sha256_contextInit (%SHA256_Context* %5)
    %6 = bitcast %SHA256_Context* %ctx to %SHA256_Context*
    call void(%SHA256_Context*, [0 x i8]*, i32) @sha256_update (%SHA256_Context* %6, [0 x i8]* %msg, i32 %len)
    %7 = bitcast %SHA256_Context* %ctx to %SHA256_Context*
    call void(%SHA256_Context*, [0 x i8]*) @sha256_final (%SHA256_Context* %7, [0 x i8]* %hash)
    ret void
}


