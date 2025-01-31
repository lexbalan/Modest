
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
; -- print imports 'sha256' --
; -- 0
; -- end print imports 'sha256' --
; -- strings --
; -- endstrings --
%sha256_Hash = type [32 x %Word8];
%sha256_Context = type {
	[64 x %Word8],
	%Int32,
	%Int64,
	[8 x %Word32]
};

define internal %Word32 @sha256_rotleft(%Word32 %a, %Int32 %b) {
	%1 = bitcast %Int32 %b to %Word32
	%2 = shl %Word32 %a, %1
	%3 = sub %Int32 32, %b
	%4 = bitcast %Int32 %3 to %Word32
	%5 = lshr %Word32 %a, %4
	%6 = or %Word32 %2, %5
	ret %Word32 %6
}

define internal %Word32 @sha256_rotright(%Word32 %a, %Int32 %b) {
	%1 = bitcast %Int32 %b to %Word32
	%2 = lshr %Word32 %a, %1
	%3 = sub %Int32 32, %b
	%4 = bitcast %Int32 %3 to %Word32
	%5 = shl %Word32 %a, %4
	%6 = or %Word32 %2, %5
	ret %Word32 %6
}

define internal %Word32 @sha256_ch(%Word32 %x, %Word32 %y, %Word32 %z) {
	%1 = and %Word32 %x, %y
	%2 = xor %Word32 %x, -1
	%3 = and %Word32 %2, %z
	%4 = xor %Word32 %1, %3
	ret %Word32 %4
}

define internal %Word32 @sha256_maj(%Word32 %x, %Word32 %y, %Word32 %z) {
	%1 = and %Word32 %x, %y
	%2 = and %Word32 %x, %z
	%3 = and %Word32 %y, %z
	%4 = xor %Word32 %2, %3
	%5 = xor %Word32 %1, %4
	ret %Word32 %5
}

define internal %Word32 @sha256_ep0(%Word32 %x) {
	%1 = call %Word32 @sha256_rotright(%Word32 %x, %Int32 2)
	%2 = call %Word32 @sha256_rotright(%Word32 %x, %Int32 13)
	%3 = call %Word32 @sha256_rotright(%Word32 %x, %Int32 22)
	%4 = xor %Word32 %2, %3
	%5 = xor %Word32 %1, %4
	ret %Word32 %5
}

define internal %Word32 @sha256_ep1(%Word32 %x) {
	%1 = call %Word32 @sha256_rotright(%Word32 %x, %Int32 6)
	%2 = call %Word32 @sha256_rotright(%Word32 %x, %Int32 11)
	%3 = call %Word32 @sha256_rotright(%Word32 %x, %Int32 25)
	%4 = xor %Word32 %2, %3
	%5 = xor %Word32 %1, %4
	ret %Word32 %5
}

define internal %Word32 @sha256_sig0(%Word32 %x) {
	%1 = call %Word32 @sha256_rotright(%Word32 %x, %Int32 7)
	%2 = call %Word32 @sha256_rotright(%Word32 %x, %Int32 18)
	%3 = zext i8 3 to %Word32
	%4 = lshr %Word32 %x, %3
	%5 = xor %Word32 %2, %4
	%6 = xor %Word32 %1, %5
	ret %Word32 %6
}

define internal %Word32 @sha256_sig1(%Word32 %x) {
	%1 = call %Word32 @sha256_rotright(%Word32 %x, %Int32 17)
	%2 = call %Word32 @sha256_rotright(%Word32 %x, %Int32 19)
	%3 = zext i8 10 to %Word32
	%4 = lshr %Word32 %x, %3
	%5 = xor %Word32 %2, %4
	%6 = xor %Word32 %1, %5
	ret %Word32 %6
}

@sha256_initalState = constant [8 x i32] [
	i32 1779033703,
	i32 3144134277,
	i32 1013904242,
	i32 2773480762,
	i32 1359893119,
	i32 2600822924,
	i32 528734635,
	i32 1541459225
]
define internal void @sha256_contextInit(%sha256_Context* %ctx) {
	%1 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
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

@sha256_k = constant [64 x i32] [
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
define internal void @sha256_transform(%sha256_Context* %ctx, [0 x %Word8]* %data) {
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
	%14 = zext i8 24 to %Word32
	%15 = shl %Word32 %13, %14
	%16 = load %Int32, %Int32* %6
	%17 = add %Int32 %16, 1
	%18 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %17
	%19 = load %Word8, %Word8* %18
	%20 = zext %Word8 %19 to %Word32
	%21 = zext i8 16 to %Word32
	%22 = shl %Word32 %20, %21
	%23 = load %Int32, %Int32* %6
	%24 = add %Int32 %23, 2
	%25 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %24
	%26 = load %Word8, %Word8* %25
	%27 = zext %Word8 %26 to %Word32
	%28 = zext i8 8 to %Word32
	%29 = shl %Word32 %27, %28
	%30 = load %Int32, %Int32* %6
	%31 = add %Int32 %30, 3
	%32 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %31
	%33 = load %Word8, %Word8* %32
	%34 = zext %Word8 %33 to %Word32
	%35 = zext i8 0 to %Word32
	%36 = shl %Word32 %34, %35
	%37 = or %Word32 %29, %36
	%38 = or %Word32 %22, %37
	%39 = or %Word32 %15, %38
	%40 = load %Int32, %Int32* %5
	%41 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %40
	store %Word32 %39, %Word32* %41
	%42 = load %Int32, %Int32* %6
	%43 = add %Int32 %42, 4
	store %Int32 %43, %Int32* %6
	%44 = load %Int32, %Int32* %5
	%45 = add %Int32 %44, 1
	store %Int32 %45, %Int32* %5
	br label %again_1
break_1:
	br label %again_2
again_2:
	%46 = load %Int32, %Int32* %5
	%47 = icmp ult %Int32 %46, 64
	br %Bool %47 , label %body_2, label %break_2
body_2:
	%48 = load %Int32, %Int32* %5
	%49 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %48
	%50 = load %Int32, %Int32* %5
	%51 = sub %Int32 %50, 2
	%52 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %51
	%53 = load %Word32, %Word32* %52
	%54 = call %Word32 @sha256_sig1(%Word32 %53)
	%55 = bitcast %Word32 %54 to %Int32
	%56 = load %Int32, %Int32* %5
	%57 = sub %Int32 %56, 7
	%58 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %57
	%59 = load %Word32, %Word32* %58
	%60 = bitcast %Word32 %59 to %Int32
	%61 = add %Int32 %55, %60
	%62 = load %Int32, %Int32* %5
	%63 = sub %Int32 %62, 15
	%64 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %63
	%65 = load %Word32, %Word32* %64
	%66 = call %Word32 @sha256_sig0(%Word32 %65)
	%67 = bitcast %Word32 %66 to %Int32
	%68 = add %Int32 %61, %67
	%69 = load %Int32, %Int32* %5
	%70 = sub %Int32 %69, 16
	%71 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %70
	%72 = load %Word32, %Word32* %71
	%73 = bitcast %Word32 %72 to %Int32
	%74 = add %Int32 %68, %73
	%75 = bitcast %Int32 %74 to %Word32
	store %Word32 %75, %Word32* %49
	%76 = load %Int32, %Int32* %5
	%77 = add %Int32 %76, 1
	store %Int32 %77, %Int32* %5
	br label %again_2
break_2:
	%78 = alloca [8 x %Word32], align 1
	%79 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%80 = load [8 x %Word32], [8 x %Word32]* %79
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%81 = zext i8 8 to %Int32
	; -- end vol eval --
	store [8 x %Word32] %80, [8 x %Word32]* %78
	store %Int32 0, %Int32* %5
	br label %again_3
again_3:
	%82 = load %Int32, %Int32* %5
	%83 = icmp ult %Int32 %82, 64
	br %Bool %83 , label %body_3, label %break_3
body_3:
	%84 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 7
	%85 = load %Word32, %Word32* %84
	%86 = bitcast %Word32 %85 to %Int32
	%87 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 4
	%88 = load %Word32, %Word32* %87
	%89 = call %Word32 @sha256_ep1(%Word32 %88)
	%90 = bitcast %Word32 %89 to %Int32
	%91 = add %Int32 %86, %90
	%92 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 4
	%93 = load %Word32, %Word32* %92
	%94 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 5
	%95 = load %Word32, %Word32* %94
	%96 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 6
	%97 = load %Word32, %Word32* %96
	%98 = call %Word32 @sha256_ch(%Word32 %93, %Word32 %95, %Word32 %97)
	%99 = bitcast %Word32 %98 to %Int32
	%100 = add %Int32 %91, %99
	%101 = load %Int32, %Int32* %5
	%102 = getelementptr [64 x i32], [64 x i32]* @sha256_k, %Int32 0, %Int32 %101
	%103 = load i32, i32* %102
	%104 = bitcast i32 %103 to %Int32
	%105 = add %Int32 %100, %104
	%106 = load %Int32, %Int32* %5
	%107 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %106
	%108 = load %Word32, %Word32* %107
	%109 = bitcast %Word32 %108 to %Int32
	%110 = add %Int32 %105, %109
	%111 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 0
	%112 = load %Word32, %Word32* %111
	%113 = call %Word32 @sha256_ep0(%Word32 %112)
	%114 = bitcast %Word32 %113 to %Int32
	%115 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 0
	%116 = load %Word32, %Word32* %115
	%117 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 1
	%118 = load %Word32, %Word32* %117
	%119 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 2
	%120 = load %Word32, %Word32* %119
	%121 = call %Word32 @sha256_maj(%Word32 %116, %Word32 %118, %Word32 %120)
	%122 = bitcast %Word32 %121 to %Int32
	%123 = add %Int32 %114, %122
	%124 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 7
	%125 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 6
	%126 = load %Word32, %Word32* %125
	store %Word32 %126, %Word32* %124
	%127 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 6
	%128 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 5
	%129 = load %Word32, %Word32* %128
	store %Word32 %129, %Word32* %127
	%130 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 5
	%131 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 4
	%132 = load %Word32, %Word32* %131
	store %Word32 %132, %Word32* %130
	%133 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 4
	%134 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 3
	%135 = load %Word32, %Word32* %134
	%136 = bitcast %Word32 %135 to %Int32
	%137 = add %Int32 %136, %110
	%138 = bitcast %Int32 %137 to %Word32
	store %Word32 %138, %Word32* %133
	%139 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 3
	%140 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 2
	%141 = load %Word32, %Word32* %140
	store %Word32 %141, %Word32* %139
	%142 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 2
	%143 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 1
	%144 = load %Word32, %Word32* %143
	store %Word32 %144, %Word32* %142
	%145 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 1
	%146 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 0
	%147 = load %Word32, %Word32* %146
	store %Word32 %147, %Word32* %145
	%148 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 0
	%149 = add %Int32 %110, %123
	%150 = bitcast %Int32 %149 to %Word32
	store %Word32 %150, %Word32* %148
	%151 = load %Int32, %Int32* %5
	%152 = add %Int32 %151, 1
	store %Int32 %152, %Int32* %5
	br label %again_3
break_3:
	store %Int32 0, %Int32* %5
	br label %again_4
again_4:
	%153 = load %Int32, %Int32* %5
	%154 = icmp ult %Int32 %153, 8
	br %Bool %154 , label %body_4, label %break_4
body_4:
	%155 = load %Int32, %Int32* %5
	%156 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%157 = getelementptr [8 x %Word32], [8 x %Word32]* %156, %Int32 0, %Int32 %155
	%158 = load %Int32, %Int32* %5
	%159 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%160 = getelementptr [8 x %Word32], [8 x %Word32]* %159, %Int32 0, %Int32 %158
	%161 = load %Word32, %Word32* %160
	%162 = bitcast %Word32 %161 to %Int32
	%163 = load %Int32, %Int32* %5
	%164 = getelementptr [8 x %Word32], [8 x %Word32]* %78, %Int32 0, %Int32 %163
	%165 = load %Word32, %Word32* %164
	%166 = bitcast %Word32 %165 to %Int32
	%167 = add %Int32 %162, %166
	%168 = bitcast %Int32 %167 to %Word32
	store %Word32 %168, %Word32* %157
	%169 = load %Int32, %Int32* %5
	%170 = add %Int32 %169, 1
	store %Int32 %170, %Int32* %5
	br label %again_4
break_4:
	ret void
}

define internal void @sha256_update(%sha256_Context* %ctx, [0 x %Word8]* %msg, %Int32 %msgLen) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%2 = load %Int32, %Int32* %1
	%3 = icmp ult %Int32 %2, %msgLen
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 1
	%5 = load %Int32, %Int32* %4
	%6 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%7 = getelementptr [64 x %Word8], [64 x %Word8]* %6, %Int32 0, %Int32 %5
	%8 = load %Int32, %Int32* %1
	%9 = getelementptr [0 x %Word8], [0 x %Word8]* %msg, %Int32 0, %Int32 %8
	%10 = load %Word8, %Word8* %9
	store %Word8 %10, %Word8* %7
	%11 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 1
	%12 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 1
	%13 = load %Int32, %Int32* %12
	%14 = add %Int32 %13, 1
	store %Int32 %14, %Int32* %11
	%15 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 1
	%16 = load %Int32, %Int32* %15
	%17 = icmp eq %Int32 %16, 64
	br %Bool %17 , label %then_0, label %endif_0
then_0:
	%18 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%19 = bitcast [64 x %Word8]* %18 to [0 x %Word8]*
	call void @sha256_transform(%sha256_Context* %ctx, [0 x %Word8]* %19)
	%20 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%21 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%22 = load %Int64, %Int64* %21
	%23 = add %Int64 %22, 512
	store %Int64 %23, %Int64* %20
	%24 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 1
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

define internal void @sha256_final(%sha256_Context* %ctx, %sha256_Hash* %outHash) {
	%1 = alloca %Int32, align 4
	%2 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 1
	%3 = load %Int32, %Int32* %2
	store %Int32 %3, %Int32* %1

	; Pad whatever data is left in the buffer.
	%4 = alloca %Int32, align 4
	store %Int32 64, %Int32* %4
	%5 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 1
	%6 = load %Int32, %Int32* %5
	%7 = icmp ult %Int32 %6, 56
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	store %Int32 56, %Int32* %4
	br label %endif_0
endif_0:
	%8 = load %Int32, %Int32* %1
	%9 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%10 = getelementptr [64 x %Word8], [64 x %Word8]* %9, %Int32 0, %Int32 %8
	store %Word8 128, %Word8* %10
	%11 = load %Int32, %Int32* %1
	%12 = add %Int32 %11, 1
	store %Int32 %12, %Int32* %1
	%13 = load %Int32, %Int32* %1
	%14 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%15 = getelementptr [64 x %Word8], [64 x %Word8]* %14, %Int32 0, %Int32 %13
	%16 = bitcast %Word8* %15 to i8*
	%17 = load %Int32, %Int32* %4
	%18 = load %Int32, %Int32* %1
	%19 = sub %Int32 %17, %18
	%20 = zext %Int32 %19 to %SizeT
	%21 = call i8* @memset(i8* %16, %Int 0, %SizeT %20)
	;ctx.data[i:n-i] = []
	%22 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 1
	%23 = load %Int32, %Int32* %22
	%24 = icmp uge %Int32 %23, 56
	br %Bool %24 , label %then_1, label %endif_1
then_1:
	%25 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%26 = bitcast [64 x %Word8]* %25 to [0 x %Word8]*
	call void @sha256_transform(%sha256_Context* %ctx, [0 x %Word8]* %26)
	%27 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%28 = bitcast [64 x %Word8]* %27 to i8*
	%29 = call i8* @memset(i8* %28, %Int 0, %SizeT 56)
	;ctx.data[0:56] = []
	br label %endif_1
endif_1:

	; Append to the padding the total message's length in bits and transform.
	%30 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%31 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%32 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 1
	%33 = load %Int32, %Int32* %32
	%34 = zext %Int32 %33 to %Int64
	%35 = mul %Int64 %34, 8
	%36 = load %Int64, %Int64* %31
	%37 = add %Int64 %36, %35
	store %Int64 %37, %Int64* %30
	%38 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%39 = getelementptr [64 x %Word8], [64 x %Word8]* %38, %Int32 0, %Int32 63
	%40 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%41 = load %Int64, %Int64* %40
	%42 = bitcast %Int64 %41 to %Word64
	%43 = zext i8 0 to %Word64
	%44 = lshr %Word64 %42, %43
	%45 = trunc %Word64 %44 to %Word8
	store %Word8 %45, %Word8* %39
	%46 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%47 = getelementptr [64 x %Word8], [64 x %Word8]* %46, %Int32 0, %Int32 62
	%48 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%49 = load %Int64, %Int64* %48
	%50 = bitcast %Int64 %49 to %Word64
	%51 = zext i8 8 to %Word64
	%52 = lshr %Word64 %50, %51
	%53 = trunc %Word64 %52 to %Word8
	store %Word8 %53, %Word8* %47
	%54 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%55 = getelementptr [64 x %Word8], [64 x %Word8]* %54, %Int32 0, %Int32 61
	%56 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%57 = load %Int64, %Int64* %56
	%58 = bitcast %Int64 %57 to %Word64
	%59 = zext i8 16 to %Word64
	%60 = lshr %Word64 %58, %59
	%61 = trunc %Word64 %60 to %Word8
	store %Word8 %61, %Word8* %55
	%62 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%63 = getelementptr [64 x %Word8], [64 x %Word8]* %62, %Int32 0, %Int32 60
	%64 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%65 = load %Int64, %Int64* %64
	%66 = bitcast %Int64 %65 to %Word64
	%67 = zext i8 24 to %Word64
	%68 = lshr %Word64 %66, %67
	%69 = trunc %Word64 %68 to %Word8
	store %Word8 %69, %Word8* %63
	%70 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%71 = getelementptr [64 x %Word8], [64 x %Word8]* %70, %Int32 0, %Int32 59
	%72 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%73 = load %Int64, %Int64* %72
	%74 = bitcast %Int64 %73 to %Word64
	%75 = zext i8 32 to %Word64
	%76 = lshr %Word64 %74, %75
	%77 = trunc %Word64 %76 to %Word8
	store %Word8 %77, %Word8* %71
	%78 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%79 = getelementptr [64 x %Word8], [64 x %Word8]* %78, %Int32 0, %Int32 58
	%80 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%81 = load %Int64, %Int64* %80
	%82 = bitcast %Int64 %81 to %Word64
	%83 = zext i8 40 to %Word64
	%84 = lshr %Word64 %82, %83
	%85 = trunc %Word64 %84 to %Word8
	store %Word8 %85, %Word8* %79
	%86 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%87 = getelementptr [64 x %Word8], [64 x %Word8]* %86, %Int32 0, %Int32 57
	%88 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%89 = load %Int64, %Int64* %88
	%90 = bitcast %Int64 %89 to %Word64
	%91 = zext i8 48 to %Word64
	%92 = lshr %Word64 %90, %91
	%93 = trunc %Word64 %92 to %Word8
	store %Word8 %93, %Word8* %87
	%94 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%95 = getelementptr [64 x %Word8], [64 x %Word8]* %94, %Int32 0, %Int32 56
	%96 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 2
	%97 = load %Int64, %Int64* %96
	%98 = bitcast %Int64 %97 to %Word64
	%99 = zext i8 56 to %Word64
	%100 = lshr %Word64 %98, %99
	%101 = trunc %Word64 %100 to %Word8
	store %Word8 %101, %Word8* %95
	%102 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 0
	%103 = bitcast [64 x %Word8]* %102 to [0 x %Word8]*
	call void @sha256_transform(%sha256_Context* %ctx, [0 x %Word8]* %103)

	; Since this implementation uses little endian byte ordering
	; and SHA uses big endian, reverse all the bytes
	; when copying the final state to the output hash.
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%104 = load %Int32, %Int32* %1
	%105 = icmp ult %Int32 %104, 4
	br %Bool %105 , label %body_1, label %break_1
body_1:
	%106 = load %Int32, %Int32* %1
	%107 = mul %Int32 %106, 8
	%108 = sub %Int32 24, %107
	%109 = load %Int32, %Int32* %1
	%110 = add %Int32 %109, 0
	%111 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %110
	%112 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%113 = getelementptr [8 x %Word32], [8 x %Word32]* %112, %Int32 0, %Int32 0
	%114 = load %Word32, %Word32* %113
	%115 = bitcast %Int32 %108 to %Word32
	%116 = lshr %Word32 %114, %115
	%117 = trunc %Word32 %116 to %Word8
	store %Word8 %117, %Word8* %111
	%118 = load %Int32, %Int32* %1
	%119 = add %Int32 %118, 4
	%120 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %119
	%121 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%122 = getelementptr [8 x %Word32], [8 x %Word32]* %121, %Int32 0, %Int32 1
	%123 = load %Word32, %Word32* %122
	%124 = bitcast %Int32 %108 to %Word32
	%125 = lshr %Word32 %123, %124
	%126 = trunc %Word32 %125 to %Word8
	store %Word8 %126, %Word8* %120
	%127 = load %Int32, %Int32* %1
	%128 = add %Int32 %127, 8
	%129 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %128
	%130 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%131 = getelementptr [8 x %Word32], [8 x %Word32]* %130, %Int32 0, %Int32 2
	%132 = load %Word32, %Word32* %131
	%133 = bitcast %Int32 %108 to %Word32
	%134 = lshr %Word32 %132, %133
	%135 = trunc %Word32 %134 to %Word8
	store %Word8 %135, %Word8* %129
	%136 = load %Int32, %Int32* %1
	%137 = add %Int32 %136, 12
	%138 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %137
	%139 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%140 = getelementptr [8 x %Word32], [8 x %Word32]* %139, %Int32 0, %Int32 3
	%141 = load %Word32, %Word32* %140
	%142 = bitcast %Int32 %108 to %Word32
	%143 = lshr %Word32 %141, %142
	%144 = trunc %Word32 %143 to %Word8
	store %Word8 %144, %Word8* %138
	%145 = load %Int32, %Int32* %1
	%146 = add %Int32 %145, 16
	%147 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %146
	%148 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%149 = getelementptr [8 x %Word32], [8 x %Word32]* %148, %Int32 0, %Int32 4
	%150 = load %Word32, %Word32* %149
	%151 = bitcast %Int32 %108 to %Word32
	%152 = lshr %Word32 %150, %151
	%153 = trunc %Word32 %152 to %Word8
	store %Word8 %153, %Word8* %147
	%154 = load %Int32, %Int32* %1
	%155 = add %Int32 %154, 20
	%156 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %155
	%157 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%158 = getelementptr [8 x %Word32], [8 x %Word32]* %157, %Int32 0, %Int32 5
	%159 = load %Word32, %Word32* %158
	%160 = bitcast %Int32 %108 to %Word32
	%161 = lshr %Word32 %159, %160
	%162 = trunc %Word32 %161 to %Word8
	store %Word8 %162, %Word8* %156
	%163 = load %Int32, %Int32* %1
	%164 = add %Int32 %163, 24
	%165 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %164
	%166 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%167 = getelementptr [8 x %Word32], [8 x %Word32]* %166, %Int32 0, %Int32 6
	%168 = load %Word32, %Word32* %167
	%169 = bitcast %Int32 %108 to %Word32
	%170 = lshr %Word32 %168, %169
	%171 = trunc %Word32 %170 to %Word8
	store %Word8 %171, %Word8* %165
	%172 = load %Int32, %Int32* %1
	%173 = add %Int32 %172, 28
	%174 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %173
	%175 = getelementptr %sha256_Context, %sha256_Context* %ctx, %Int32 0, %Int32 3
	%176 = getelementptr [8 x %Word32], [8 x %Word32]* %175, %Int32 0, %Int32 7
	%177 = load %Word32, %Word32* %176
	%178 = bitcast %Int32 %108 to %Word32
	%179 = lshr %Word32 %177, %178
	%180 = trunc %Word32 %179 to %Word8
	store %Word8 %180, %Word8* %174
	%181 = load %Int32, %Int32* %1
	%182 = add %Int32 %181, 1
	store %Int32 %182, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define void @sha256_hash([0 x %Word8]* %msg, %Int32 %msgLen, %sha256_Hash* %outHash) {
	%1 = alloca %sha256_Context, align 128
	store %sha256_Context zeroinitializer, %sha256_Context* %1
	call void @sha256_contextInit(%sha256_Context* %1)
	call void @sha256_update(%sha256_Context* %1, [0 x %Word8]* %msg, %Int32 %msgLen)
	call void @sha256_final(%sha256_Context* %1, %sha256_Hash* %outHash)
	ret void
}


