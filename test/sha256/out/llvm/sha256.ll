
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
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

; MODULE: sha256

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Int8;
%Short = type %Int16;
%UnsignedShort = type %Int16;
%Int = type %Int32;
%UnsignedInt = type %Int32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Int64;
%Long = type %Int64;
%UnsignedLong = type %Int64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Int64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Int64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Int64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Int32;
%PIDT = type %Int32;
%UIDT = type %Int32;
%GIDT = type %Int32;
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
; -- endstrings --
%sha256_Hash = type [32 x %Word8];
%Context = type {
	[64 x %Word8],
	%Int32,
	%Int64,
	[8 x %Word32]
};

define internal %Word32 @rotleft(%Word32 %a, %Int32 %b) {
	%1 = bitcast %Int32 %b to %Word32
	%2 = shl %Word32 %a, %1
	%3 = sub %Int32 32, %b
	%4 = bitcast %Int32 %3 to %Word32
	%5 = lshr %Word32 %a, %4
	%6 = or %Word32 %2, %5
	ret %Word32 %6
}

define internal %Word32 @rotright(%Word32 %a, %Int32 %b) {
	%1 = bitcast %Int32 %b to %Word32
	%2 = lshr %Word32 %a, %1
	%3 = sub %Int32 32, %b
	%4 = bitcast %Int32 %3 to %Word32
	%5 = shl %Word32 %a, %4
	%6 = or %Word32 %2, %5
	ret %Word32 %6
}

define internal %Word32 @ch(%Word32 %x, %Word32 %y, %Word32 %z) {
	%1 = and %Word32 %x, %y
	%2 = xor %Word32 %x, -1
	%3 = and %Word32 %2, %z
	%4 = xor %Word32 %1, %3
	ret %Word32 %4
}

define internal %Word32 @maj(%Word32 %x, %Word32 %y, %Word32 %z) {
	%1 = and %Word32 %x, %y
	%2 = and %Word32 %x, %z
	%3 = and %Word32 %y, %z
	%4 = xor %Word32 %2, %3
	%5 = xor %Word32 %1, %4
	ret %Word32 %5
}

define internal %Word32 @ep0(%Word32 %x) {
	%1 = call %Word32 @rotright(%Word32 %x, %Int32 2)
	%2 = call %Word32 @rotright(%Word32 %x, %Int32 13)
	%3 = call %Word32 @rotright(%Word32 %x, %Int32 22)
	%4 = xor %Word32 %2, %3
	%5 = xor %Word32 %1, %4
	ret %Word32 %5
}

define internal %Word32 @ep1(%Word32 %x) {
	%1 = call %Word32 @rotright(%Word32 %x, %Int32 6)
	%2 = call %Word32 @rotright(%Word32 %x, %Int32 11)
	%3 = call %Word32 @rotright(%Word32 %x, %Int32 25)
	%4 = xor %Word32 %2, %3
	%5 = xor %Word32 %1, %4
	ret %Word32 %5
}

define internal %Word32 @sig0(%Word32 %x) {
	%1 = call %Word32 @rotright(%Word32 %x, %Int32 7)
	%2 = call %Word32 @rotright(%Word32 %x, %Int32 18)
	%3 = lshr %Word32 %x, 3
	%4 = xor %Word32 %2, %3
	%5 = xor %Word32 %1, %4
	ret %Word32 %5
}

define internal %Word32 @sig1(%Word32 %x) {
	%1 = call %Word32 @rotright(%Word32 %x, %Int32 17)
	%2 = call %Word32 @rotright(%Word32 %x, %Int32 19)
	%3 = lshr %Word32 %x, 10
	%4 = xor %Word32 %2, %3
	%5 = xor %Word32 %1, %4
	ret %Word32 %5
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
define internal void @contextInit(%Context* %ctx) {
	%1 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%2 = insertvalue [8 x %Word32] zeroinitializer, %Word32 1779033703, 0
	%3 = insertvalue [8 x %Word32] %2, %Word32 3144134277, 1
	%4 = insertvalue [8 x %Word32] %3, %Word32 1013904242, 2
	%5 = insertvalue [8 x %Word32] %4, %Word32 2773480762, 3
	%6 = insertvalue [8 x %Word32] %5, %Word32 1359893119, 4
	%7 = insertvalue [8 x %Word32] %6, %Word32 2600822924, 5
	%8 = insertvalue [8 x %Word32] %7, %Word32 528734635, 6
	%9 = insertvalue [8 x %Word32] %8, %Word32 1541459225, 7
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%10 = zext i8 8 to %Int32
	; -- end vol eval --
	store [8 x %Word32] %9, [8 x %Word32]* %1
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
define internal void @transform(%Context* %ctx, [0 x %Word8]* %data) {
	%1 = alloca [64 x %Word32], align 1
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%2 = zext i8 64 to %Int32
	; -- end vol eval --
	; -- zero fill rest of array
	%3 = mul %Int32 %2, 4
	%4 = bitcast [64 x %Word32]* %1 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %4, i8 0, %Int32 %3, i1 0)
	%5 = alloca %Int32, align 4
	store %Int32 0, %Int32* %5
	%6 = alloca %Int32, align 4
	store %Int32 0, %Int32* %6
	br label %again_1
again_1:
	%7 = load %Int32, %Int32* %5
	%8 = icmp ult %Int32 %7, 16
	br %Bool %8 , label %body_1, label %break_1
body_1:
	%9 = load %Int32, %Int32* %6
	%10 = add %Int32 %9, 0
	%11 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %10
	%12 = load %Word8, %Word8* %11
	%13 = zext %Word8 %12 to %Word32
	%14 = shl %Word32 %13, 24
	%15 = load %Int32, %Int32* %6
	%16 = add %Int32 %15, 1
	%17 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %16
	%18 = load %Word8, %Word8* %17
	%19 = zext %Word8 %18 to %Word32
	%20 = shl %Word32 %19, 16
	%21 = load %Int32, %Int32* %6
	%22 = add %Int32 %21, 2
	%23 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %22
	%24 = load %Word8, %Word8* %23
	%25 = zext %Word8 %24 to %Word32
	%26 = shl %Word32 %25, 8
	%27 = load %Int32, %Int32* %6
	%28 = add %Int32 %27, 3
	%29 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %28
	%30 = load %Word8, %Word8* %29
	%31 = zext %Word8 %30 to %Word32
	%32 = shl %Word32 %31, 0
	%33 = or %Word32 %26, %32
	%34 = or %Word32 %20, %33
	%35 = or %Word32 %14, %34
	%36 = load %Int32, %Int32* %5
	%37 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %36
	store %Word32 %35, %Word32* %37
	%38 = load %Int32, %Int32* %6
	%39 = add %Int32 %38, 4
	store %Int32 %39, %Int32* %6
	%40 = load %Int32, %Int32* %5
	%41 = add %Int32 %40, 1
	store %Int32 %41, %Int32* %5
	br label %again_1
break_1:
	br label %again_2
again_2:
	%42 = load %Int32, %Int32* %5
	%43 = icmp ult %Int32 %42, 64
	br %Bool %43 , label %body_2, label %break_2
body_2:
	%44 = load %Int32, %Int32* %5
	%45 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %44
	%46 = load %Int32, %Int32* %5
	%47 = sub %Int32 %46, 2
	%48 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %47
	%49 = load %Word32, %Word32* %48
	%50 = call %Word32 @sig1(%Word32 %49)
	%51 = bitcast %Word32 %50 to %Int32
	%52 = load %Int32, %Int32* %5
	%53 = sub %Int32 %52, 7
	%54 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %53
	%55 = load %Word32, %Word32* %54
	%56 = bitcast %Word32 %55 to %Int32
	%57 = add %Int32 %51, %56
	%58 = load %Int32, %Int32* %5
	%59 = sub %Int32 %58, 15
	%60 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %59
	%61 = load %Word32, %Word32* %60
	%62 = call %Word32 @sig0(%Word32 %61)
	%63 = bitcast %Word32 %62 to %Int32
	%64 = add %Int32 %57, %63
	%65 = load %Int32, %Int32* %5
	%66 = sub %Int32 %65, 16
	%67 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %66
	%68 = load %Word32, %Word32* %67
	%69 = bitcast %Word32 %68 to %Int32
	%70 = add %Int32 %64, %69
	%71 = bitcast %Int32 %70 to %Word32
	store %Word32 %71, %Word32* %45
	%72 = load %Int32, %Int32* %5
	%73 = add %Int32 %72, 1
	store %Int32 %73, %Int32* %5
	br label %again_2
break_2:
	%74 = alloca [8 x %Word32], align 1
	%75 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%76 = load [8 x %Word32], [8 x %Word32]* %75
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%77 = zext i8 8 to %Int32
	; -- end vol eval --
	store [8 x %Word32] %76, [8 x %Word32]* %74
	store %Int32 0, %Int32* %5
	br label %again_3
again_3:
	%78 = load %Int32, %Int32* %5
	%79 = icmp ult %Int32 %78, 64
	br %Bool %79 , label %body_3, label %break_3
body_3:
	%80 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 7
	%81 = load %Word32, %Word32* %80
	%82 = bitcast %Word32 %81 to %Int32
	%83 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 4
	%84 = load %Word32, %Word32* %83
	%85 = call %Word32 @ep1(%Word32 %84)
	%86 = bitcast %Word32 %85 to %Int32
	%87 = add %Int32 %82, %86
	%88 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 4
	%89 = load %Word32, %Word32* %88
	%90 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 5
	%91 = load %Word32, %Word32* %90
	%92 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 6
	%93 = load %Word32, %Word32* %92
	%94 = call %Word32 @ch(%Word32 %89, %Word32 %91, %Word32 %93)
	%95 = bitcast %Word32 %94 to %Int32
	%96 = add %Int32 %87, %95
	%97 = load %Int32, %Int32* %5
	%98 = getelementptr [64 x i32], [64 x i32]* @k, %Int32 0, %Int32 %97
	%99 = load i32, i32* %98
	%100 = bitcast i32 %99 to %Int32
	%101 = add %Int32 %96, %100
	%102 = load %Int32, %Int32* %5
	%103 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %102
	%104 = load %Word32, %Word32* %103
	%105 = bitcast %Word32 %104 to %Int32
	%106 = add %Int32 %101, %105
	%107 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 0
	%108 = load %Word32, %Word32* %107
	%109 = call %Word32 @ep0(%Word32 %108)
	%110 = bitcast %Word32 %109 to %Int32
	%111 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 0
	%112 = load %Word32, %Word32* %111
	%113 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 1
	%114 = load %Word32, %Word32* %113
	%115 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 2
	%116 = load %Word32, %Word32* %115
	%117 = call %Word32 @maj(%Word32 %112, %Word32 %114, %Word32 %116)
	%118 = bitcast %Word32 %117 to %Int32
	%119 = add %Int32 %110, %118
	%120 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 7
	%121 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 6
	%122 = load %Word32, %Word32* %121
	store %Word32 %122, %Word32* %120
	%123 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 6
	%124 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 5
	%125 = load %Word32, %Word32* %124
	store %Word32 %125, %Word32* %123
	%126 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 5
	%127 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 4
	%128 = load %Word32, %Word32* %127
	store %Word32 %128, %Word32* %126
	%129 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 4
	%130 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 3
	%131 = load %Word32, %Word32* %130
	%132 = bitcast %Word32 %131 to %Int32
	%133 = add %Int32 %132, %106
	%134 = bitcast %Int32 %133 to %Word32
	store %Word32 %134, %Word32* %129
	%135 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 3
	%136 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 2
	%137 = load %Word32, %Word32* %136
	store %Word32 %137, %Word32* %135
	%138 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 2
	%139 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 1
	%140 = load %Word32, %Word32* %139
	store %Word32 %140, %Word32* %138
	%141 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 1
	%142 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 0
	%143 = load %Word32, %Word32* %142
	store %Word32 %143, %Word32* %141
	%144 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 0
	%145 = add %Int32 %106, %119
	%146 = bitcast %Int32 %145 to %Word32
	store %Word32 %146, %Word32* %144
	%147 = load %Int32, %Int32* %5
	%148 = add %Int32 %147, 1
	store %Int32 %148, %Int32* %5
	br label %again_3
break_3:
	store %Int32 0, %Int32* %5
	br label %again_4
again_4:
	%149 = load %Int32, %Int32* %5
	%150 = icmp ult %Int32 %149, 8
	br %Bool %150 , label %body_4, label %break_4
body_4:
	%151 = load %Int32, %Int32* %5
	%152 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%153 = getelementptr [8 x %Word32], [8 x %Word32]* %152, %Int32 0, %Int32 %151
	%154 = load %Int32, %Int32* %5
	%155 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%156 = getelementptr [8 x %Word32], [8 x %Word32]* %155, %Int32 0, %Int32 %154
	%157 = load %Word32, %Word32* %156
	%158 = bitcast %Word32 %157 to %Int32
	%159 = load %Int32, %Int32* %5
	%160 = getelementptr [8 x %Word32], [8 x %Word32]* %74, %Int32 0, %Int32 %159
	%161 = load %Word32, %Word32* %160
	%162 = bitcast %Word32 %161 to %Int32
	%163 = add %Int32 %158, %162
	%164 = bitcast %Int32 %163 to %Word32
	store %Word32 %164, %Word32* %153
	%165 = load %Int32, %Int32* %5
	%166 = add %Int32 %165, 1
	store %Int32 %166, %Int32* %5
	br label %again_4
break_4:
	ret void
}

define internal void @update(%Context* %ctx, [0 x %Word8]* %msg, %Int32 %msgLen) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%2 = load %Int32, %Int32* %1
	%3 = icmp ult %Int32 %2, %msgLen
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%5 = load %Int32, %Int32* %4
	%6 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%7 = getelementptr [64 x %Word8], [64 x %Word8]* %6, %Int32 0, %Int32 %5
	%8 = load %Int32, %Int32* %1
	%9 = getelementptr [0 x %Word8], [0 x %Word8]* %msg, %Int32 0, %Int32 %8
	%10 = load %Word8, %Word8* %9
	store %Word8 %10, %Word8* %7
	%11 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%12 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%13 = load %Int32, %Int32* %12
	%14 = add %Int32 %13, 1
	store %Int32 %14, %Int32* %11
	%15 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%16 = load %Int32, %Int32* %15
	%17 = icmp eq %Int32 %16, 64
	br %Bool %17 , label %then_0, label %endif_0
then_0:
	%18 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%19 = bitcast [64 x %Word8]* %18 to [0 x %Word8]*
	call void @transform(%Context* %ctx, [0 x %Word8]* %19)
	%20 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%21 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%22 = load %Int64, %Int64* %21
	%23 = add %Int64 %22, 512
	store %Int64 %23, %Int64* %20
	%24 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	store %Int32 0, %Int32* %24
	br label %endif_0
endif_0:
	%25 = load %Int32, %Int32* %1
	%26 = add %Int32 %25, 1
	store %Int32 %26, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define internal void @final(%Context* %ctx, %sha256_Hash* %outHash) {
	%1 = alloca %Int32, align 4
	%2 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%3 = load %Int32, %Int32* %2
	store %Int32 %3, %Int32* %1

	; Pad whatever data is left in the buffer.
	%4 = alloca %Int32, align 4
	store %Int32 64, %Int32* %4
	%5 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%6 = load %Int32, %Int32* %5
	%7 = icmp ult %Int32 %6, 56
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	store %Int32 56, %Int32* %4
	br label %endif_0
endif_0:
	%8 = load %Int32, %Int32* %1
	%9 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%10 = getelementptr [64 x %Word8], [64 x %Word8]* %9, %Int32 0, %Int32 %8
	store %Word8 128, %Word8* %10
	%11 = load %Int32, %Int32* %1
	%12 = add %Int32 %11, 1
	store %Int32 %12, %Int32* %1
	%13 = load %Int32, %Int32* %1
	%14 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%15 = getelementptr [64 x %Word8], [64 x %Word8]* %14, %Int32 0, %Int32 %13
	%16 = bitcast %Word8* %15 to i8*
	%17 = load %Int32, %Int32* %4
	%18 = load %Int32, %Int32* %1
	%19 = sub %Int32 %17, %18
	%20 = zext %Int32 %19 to %SizeT
	%21 = call i8* @memset(i8* %16, %Int 0, %SizeT %20)
	;ctx.data[i:n-i] = []
	%22 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%23 = load %Int32, %Int32* %22
	%24 = icmp uge %Int32 %23, 56
	br %Bool %24 , label %then_1, label %endif_1
then_1:
	%25 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%26 = bitcast [64 x %Word8]* %25 to [0 x %Word8]*
	call void @transform(%Context* %ctx, [0 x %Word8]* %26)
	%27 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%28 = bitcast [64 x %Word8]* %27 to i8*
	%29 = call i8* @memset(i8* %28, %Int 0, %SizeT 56)
	;ctx.data[0:56] = []
	br label %endif_1
endif_1:

	; Append to the padding the total message's length in bits and transform.
	%30 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%31 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%32 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%33 = load %Int32, %Int32* %32
	%34 = zext %Int32 %33 to %Int64
	%35 = mul %Int64 %34, 8
	%36 = load %Int64, %Int64* %31
	%37 = add %Int64 %36, %35
	store %Int64 %37, %Int64* %30
	%38 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%39 = getelementptr [64 x %Word8], [64 x %Word8]* %38, %Int32 0, %Int32 63
	%40 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%41 = load %Int64, %Int64* %40
	%42 = bitcast %Int64 %41 to %Word64
	%43 = lshr %Word64 %42, 0
	%44 = trunc %Word64 %43 to %Word8
	store %Word8 %44, %Word8* %39
	%45 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%46 = getelementptr [64 x %Word8], [64 x %Word8]* %45, %Int32 0, %Int32 62
	%47 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%48 = load %Int64, %Int64* %47
	%49 = bitcast %Int64 %48 to %Word64
	%50 = lshr %Word64 %49, 8
	%51 = trunc %Word64 %50 to %Word8
	store %Word8 %51, %Word8* %46
	%52 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%53 = getelementptr [64 x %Word8], [64 x %Word8]* %52, %Int32 0, %Int32 61
	%54 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%55 = load %Int64, %Int64* %54
	%56 = bitcast %Int64 %55 to %Word64
	%57 = lshr %Word64 %56, 16
	%58 = trunc %Word64 %57 to %Word8
	store %Word8 %58, %Word8* %53
	%59 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%60 = getelementptr [64 x %Word8], [64 x %Word8]* %59, %Int32 0, %Int32 60
	%61 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%62 = load %Int64, %Int64* %61
	%63 = bitcast %Int64 %62 to %Word64
	%64 = lshr %Word64 %63, 24
	%65 = trunc %Word64 %64 to %Word8
	store %Word8 %65, %Word8* %60
	%66 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%67 = getelementptr [64 x %Word8], [64 x %Word8]* %66, %Int32 0, %Int32 59
	%68 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%69 = load %Int64, %Int64* %68
	%70 = bitcast %Int64 %69 to %Word64
	%71 = lshr %Word64 %70, 32
	%72 = trunc %Word64 %71 to %Word8
	store %Word8 %72, %Word8* %67
	%73 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%74 = getelementptr [64 x %Word8], [64 x %Word8]* %73, %Int32 0, %Int32 58
	%75 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%76 = load %Int64, %Int64* %75
	%77 = bitcast %Int64 %76 to %Word64
	%78 = lshr %Word64 %77, 40
	%79 = trunc %Word64 %78 to %Word8
	store %Word8 %79, %Word8* %74
	%80 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%81 = getelementptr [64 x %Word8], [64 x %Word8]* %80, %Int32 0, %Int32 57
	%82 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%83 = load %Int64, %Int64* %82
	%84 = bitcast %Int64 %83 to %Word64
	%85 = lshr %Word64 %84, 48
	%86 = trunc %Word64 %85 to %Word8
	store %Word8 %86, %Word8* %81
	%87 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%88 = getelementptr [64 x %Word8], [64 x %Word8]* %87, %Int32 0, %Int32 56
	%89 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%90 = load %Int64, %Int64* %89
	%91 = bitcast %Int64 %90 to %Word64
	%92 = lshr %Word64 %91, 56
	%93 = trunc %Word64 %92 to %Word8
	store %Word8 %93, %Word8* %88
	%94 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%95 = bitcast [64 x %Word8]* %94 to [0 x %Word8]*
	call void @transform(%Context* %ctx, [0 x %Word8]* %95)

	; Since this implementation uses little endian byte ordering
	; and SHA uses big endian, reverse all the bytes
	; when copying the final state to the output hash.
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%96 = load %Int32, %Int32* %1
	%97 = icmp ult %Int32 %96, 4
	br %Bool %97 , label %body_1, label %break_1
body_1:
	%98 = load %Int32, %Int32* %1
	%99 = mul %Int32 %98, 8
	%100 = sub %Int32 24, %99
	%101 = load %Int32, %Int32* %1
	%102 = add %Int32 %101, 0
	%103 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %102
	%104 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%105 = getelementptr [8 x %Word32], [8 x %Word32]* %104, %Int32 0, %Int32 0
	%106 = load %Word32, %Word32* %105
	%107 = bitcast %Int32 %100 to %Word32
	%108 = lshr %Word32 %106, %107
	%109 = trunc %Word32 %108 to %Word8
	store %Word8 %109, %Word8* %103
	%110 = load %Int32, %Int32* %1
	%111 = add %Int32 %110, 4
	%112 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %111
	%113 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%114 = getelementptr [8 x %Word32], [8 x %Word32]* %113, %Int32 0, %Int32 1
	%115 = load %Word32, %Word32* %114
	%116 = bitcast %Int32 %100 to %Word32
	%117 = lshr %Word32 %115, %116
	%118 = trunc %Word32 %117 to %Word8
	store %Word8 %118, %Word8* %112
	%119 = load %Int32, %Int32* %1
	%120 = add %Int32 %119, 8
	%121 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %120
	%122 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%123 = getelementptr [8 x %Word32], [8 x %Word32]* %122, %Int32 0, %Int32 2
	%124 = load %Word32, %Word32* %123
	%125 = bitcast %Int32 %100 to %Word32
	%126 = lshr %Word32 %124, %125
	%127 = trunc %Word32 %126 to %Word8
	store %Word8 %127, %Word8* %121
	%128 = load %Int32, %Int32* %1
	%129 = add %Int32 %128, 12
	%130 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %129
	%131 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%132 = getelementptr [8 x %Word32], [8 x %Word32]* %131, %Int32 0, %Int32 3
	%133 = load %Word32, %Word32* %132
	%134 = bitcast %Int32 %100 to %Word32
	%135 = lshr %Word32 %133, %134
	%136 = trunc %Word32 %135 to %Word8
	store %Word8 %136, %Word8* %130
	%137 = load %Int32, %Int32* %1
	%138 = add %Int32 %137, 16
	%139 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %138
	%140 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%141 = getelementptr [8 x %Word32], [8 x %Word32]* %140, %Int32 0, %Int32 4
	%142 = load %Word32, %Word32* %141
	%143 = bitcast %Int32 %100 to %Word32
	%144 = lshr %Word32 %142, %143
	%145 = trunc %Word32 %144 to %Word8
	store %Word8 %145, %Word8* %139
	%146 = load %Int32, %Int32* %1
	%147 = add %Int32 %146, 20
	%148 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %147
	%149 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%150 = getelementptr [8 x %Word32], [8 x %Word32]* %149, %Int32 0, %Int32 5
	%151 = load %Word32, %Word32* %150
	%152 = bitcast %Int32 %100 to %Word32
	%153 = lshr %Word32 %151, %152
	%154 = trunc %Word32 %153 to %Word8
	store %Word8 %154, %Word8* %148
	%155 = load %Int32, %Int32* %1
	%156 = add %Int32 %155, 24
	%157 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %156
	%158 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%159 = getelementptr [8 x %Word32], [8 x %Word32]* %158, %Int32 0, %Int32 6
	%160 = load %Word32, %Word32* %159
	%161 = bitcast %Int32 %100 to %Word32
	%162 = lshr %Word32 %160, %161
	%163 = trunc %Word32 %162 to %Word8
	store %Word8 %163, %Word8* %157
	%164 = load %Int32, %Int32* %1
	%165 = add %Int32 %164, 28
	%166 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %165
	%167 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%168 = getelementptr [8 x %Word32], [8 x %Word32]* %167, %Int32 0, %Int32 7
	%169 = load %Word32, %Word32* %168
	%170 = bitcast %Int32 %100 to %Word32
	%171 = lshr %Word32 %169, %170
	%172 = trunc %Word32 %171 to %Word8
	store %Word8 %172, %Word8* %166
	%173 = load %Int32, %Int32* %1
	%174 = add %Int32 %173, 1
	store %Int32 %174, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define void @sha256_hash([0 x %Word8]* %msg, %Int32 %msgLen, %sha256_Hash* %outHash) {
	%1 = alloca %Context, align 128
	store %Context zeroinitializer, %Context* %1
	call void @contextInit(%Context* %1)
	call void @update(%Context* %1, [0 x %Word8]* %msg, %Int32 %msgLen)
	call void @final(%Context* %1, %sha256_Hash* %outHash)
	ret void
}


