
target triple = "arm64-apple-darwin21.6.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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
;ctx.state := initMagic
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
    %17 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %18 = bitcast [64 x i8]* %17 to [0 x i8]*
    call void(%SHA256_Context*, [0 x i8]*) @sha256_transform (%SHA256_Context* %ctx, [0 x i8]* %18)
    %19 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %20 = load i64, i64* %19
    %21 = add i64 %20, 512
    %22 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    store i64 %21, i64* %22
    %23 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    store i32 0, i32* %23
    br label %endif_0
endif_0:
    %24 = load i32, i32* %i
    %25 = add i32 %24, 1
    store i32 %25, i32* %i
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
    %23 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %24 = bitcast [64 x i8]* %23 to [0 x i8]*
    call void(%SHA256_Context*, [0 x i8]*) @sha256_transform (%SHA256_Context* %ctx, [0 x i8]* %24)
    %25 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %26 = bitcast [64 x i8]* %25 to i8*
    %27 = call i8*(i8*, i32, i64) @memset (i8* %26, i32 0, i64 56)
    br label %endif_1
endif_1:
; Append to the padding the total message's length in bits and transform.
    %28 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %29 = load i64, i64* %28
    %30 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 1
    %31 = load i32, i32* %30
    %32 = zext i32 %31 to i64
    %33 = mul i64 %32, 8
    %34 = add i64 %29, %33
    %35 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    store i64 %34, i64* %35
    %36 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %37 = load i64, i64* %36
    %38 = lshr i64 %37, 0
    %39 = trunc i64 %38 to i8
    %40 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %41 = getelementptr inbounds [64 x i8], [64 x i8]* %40, i32 0, i32 63
    store i8 %39, i8* %41
    %42 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %43 = load i64, i64* %42
    %44 = lshr i64 %43, 8
    %45 = trunc i64 %44 to i8
    %46 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %47 = getelementptr inbounds [64 x i8], [64 x i8]* %46, i32 0, i32 62
    store i8 %45, i8* %47
    %48 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %49 = load i64, i64* %48
    %50 = lshr i64 %49, 16
    %51 = trunc i64 %50 to i8
    %52 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %53 = getelementptr inbounds [64 x i8], [64 x i8]* %52, i32 0, i32 61
    store i8 %51, i8* %53
    %54 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %55 = load i64, i64* %54
    %56 = lshr i64 %55, 24
    %57 = trunc i64 %56 to i8
    %58 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %59 = getelementptr inbounds [64 x i8], [64 x i8]* %58, i32 0, i32 60
    store i8 %57, i8* %59
    %60 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %61 = load i64, i64* %60
    %62 = lshr i64 %61, 32
    %63 = trunc i64 %62 to i8
    %64 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %65 = getelementptr inbounds [64 x i8], [64 x i8]* %64, i32 0, i32 59
    store i8 %63, i8* %65
    %66 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %67 = load i64, i64* %66
    %68 = lshr i64 %67, 40
    %69 = trunc i64 %68 to i8
    %70 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %71 = getelementptr inbounds [64 x i8], [64 x i8]* %70, i32 0, i32 58
    store i8 %69, i8* %71
    %72 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %73 = load i64, i64* %72
    %74 = lshr i64 %73, 48
    %75 = trunc i64 %74 to i8
    %76 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %77 = getelementptr inbounds [64 x i8], [64 x i8]* %76, i32 0, i32 57
    store i8 %75, i8* %77
    %78 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 2
    %79 = load i64, i64* %78
    %80 = lshr i64 %79, 56
    %81 = trunc i64 %80 to i8
    %82 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %83 = getelementptr inbounds [64 x i8], [64 x i8]* %82, i32 0, i32 56
    store i8 %81, i8* %83
    %84 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 0
    %85 = bitcast [64 x i8]* %84 to [0 x i8]*
    call void(%SHA256_Context*, [0 x i8]*) @sha256_transform (%SHA256_Context* %ctx, [0 x i8]* %85)
; Since this implementation uses little endian byte ordering
; and SHA uses big endian, reverse all the bytes
; when copying the final state to the output hash.
    store i32 0, i32* %i
    br label %again_1
again_1:
    %86 = load i32, i32* %i
    %87 = icmp ult i32 %86, 4
    br i1 %87 , label %body_1, label %break_1
body_1:
    %88 = load i32, i32* %i
    %89 = mul i32 %88, 8
    %90 = sub i32 24, %89
    %91 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %92 = getelementptr inbounds [8 x i32], [8 x i32]* %91, i32 0, i32 0
    %93 = load i32, i32* %92
    %94 = lshr i32 %93, %90
    %95 = trunc i32 %94 to i8
    %96 = load i32, i32* %i
    %97 = add i32 %96, 0
    %98 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %97
    store i8 %95, i8* %98
    %99 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %100 = getelementptr inbounds [8 x i32], [8 x i32]* %99, i32 0, i32 1
    %101 = load i32, i32* %100
    %102 = lshr i32 %101, %90
    %103 = trunc i32 %102 to i8
    %104 = load i32, i32* %i
    %105 = add i32 %104, 4
    %106 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %105
    store i8 %103, i8* %106
    %107 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %108 = getelementptr inbounds [8 x i32], [8 x i32]* %107, i32 0, i32 2
    %109 = load i32, i32* %108
    %110 = lshr i32 %109, %90
    %111 = trunc i32 %110 to i8
    %112 = load i32, i32* %i
    %113 = add i32 %112, 8
    %114 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %113
    store i8 %111, i8* %114
    %115 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %116 = getelementptr inbounds [8 x i32], [8 x i32]* %115, i32 0, i32 3
    %117 = load i32, i32* %116
    %118 = lshr i32 %117, %90
    %119 = trunc i32 %118 to i8
    %120 = load i32, i32* %i
    %121 = add i32 %120, 12
    %122 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %121
    store i8 %119, i8* %122
    %123 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %124 = getelementptr inbounds [8 x i32], [8 x i32]* %123, i32 0, i32 4
    %125 = load i32, i32* %124
    %126 = lshr i32 %125, %90
    %127 = trunc i32 %126 to i8
    %128 = load i32, i32* %i
    %129 = add i32 %128, 16
    %130 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %129
    store i8 %127, i8* %130
    %131 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %132 = getelementptr inbounds [8 x i32], [8 x i32]* %131, i32 0, i32 5
    %133 = load i32, i32* %132
    %134 = lshr i32 %133, %90
    %135 = trunc i32 %134 to i8
    %136 = load i32, i32* %i
    %137 = add i32 %136, 20
    %138 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %137
    store i8 %135, i8* %138
    %139 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %140 = getelementptr inbounds [8 x i32], [8 x i32]* %139, i32 0, i32 6
    %141 = load i32, i32* %140
    %142 = lshr i32 %141, %90
    %143 = trunc i32 %142 to i8
    %144 = load i32, i32* %i
    %145 = add i32 %144, 24
    %146 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %145
    store i8 %143, i8* %146
    %147 = getelementptr inbounds %SHA256_Context, %SHA256_Context* %ctx, i32 0, i32 3
    %148 = getelementptr inbounds [8 x i32], [8 x i32]* %147, i32 0, i32 7
    %149 = load i32, i32* %148
    %150 = lshr i32 %149, %90
    %151 = trunc i32 %150 to i8
    %152 = load i32, i32* %i
    %153 = add i32 %152, 28
    %154 = getelementptr inbounds [0 x i8], [0 x i8]* %hash, i32 0, i32 %153
    store i8 %151, i8* %154
    %155 = load i32, i32* %i
    %156 = add i32 %155, 1
    store i32 %156, i32* %i
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

    call void(%SHA256_Context*) @sha256_contextInit (%SHA256_Context* %ctx)
    call void(%SHA256_Context*, [0 x i8]*, i32) @sha256_update (%SHA256_Context* %ctx, [0 x i8]* %msg, i32 %len)
    call void(%SHA256_Context*, [0 x i8]*) @sha256_final (%SHA256_Context* %ctx, [0 x i8]* %hash)
    ret void
}


