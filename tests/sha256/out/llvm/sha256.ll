
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
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
; -- end print includes --
; -- print imports 'sha256' --
; -- 0
; -- end print imports 'sha256' --
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
	%3 = zext i8 3 to %Word32
	%4 = lshr %Word32 %x, %3
	%5 = xor %Word32 %2, %4
	%6 = xor %Word32 %1, %5
	ret %Word32 %6
}

define internal %Word32 @sig1(%Word32 %x) {
	%1 = call %Word32 @rotright(%Word32 %x, %Int32 17)
	%2 = call %Word32 @rotright(%Word32 %x, %Int32 19)
	%3 = zext i8 10 to %Word32
	%4 = lshr %Word32 %x, %3
	%5 = xor %Word32 %2, %4
	%6 = xor %Word32 %1, %5
	ret %Word32 %6
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
	%10 = zext i8 8 to %Int32
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
	%2 = zext i8 64 to %Int32
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
	%11 = bitcast %Int32 %10 to %Int32
	%12 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %11
	%13 = load %Word8, %Word8* %12
	%14 = zext %Word8 %13 to %Word32
	%15 = zext i8 24 to %Word32
	%16 = shl %Word32 %14, %15
	%17 = load %Int32, %Int32* %6
	%18 = add %Int32 %17, 1
	%19 = bitcast %Int32 %18 to %Int32
	%20 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %19
	%21 = load %Word8, %Word8* %20
	%22 = zext %Word8 %21 to %Word32
	%23 = zext i8 16 to %Word32
	%24 = shl %Word32 %22, %23
	%25 = load %Int32, %Int32* %6
	%26 = add %Int32 %25, 2
	%27 = bitcast %Int32 %26 to %Int32
	%28 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %27
	%29 = load %Word8, %Word8* %28
	%30 = zext %Word8 %29 to %Word32
	%31 = zext i8 8 to %Word32
	%32 = shl %Word32 %30, %31
	%33 = load %Int32, %Int32* %6
	%34 = add %Int32 %33, 3
	%35 = bitcast %Int32 %34 to %Int32
	%36 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %35
	%37 = load %Word8, %Word8* %36
	%38 = zext %Word8 %37 to %Word32
	%39 = zext i8 0 to %Word32
	%40 = shl %Word32 %38, %39
	%41 = or %Word32 %32, %40
	%42 = or %Word32 %24, %41
	%43 = or %Word32 %16, %42
	%44 = load %Int32, %Int32* %5
	%45 = bitcast %Int32 %44 to %Int32
	%46 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %45
	store %Word32 %43, %Word32* %46
	%47 = load %Int32, %Int32* %6
	%48 = add %Int32 %47, 4
	store %Int32 %48, %Int32* %6
	%49 = load %Int32, %Int32* %5
	%50 = add %Int32 %49, 1
	store %Int32 %50, %Int32* %5
	br label %again_1
break_1:
	br label %again_2
again_2:
	%51 = load %Int32, %Int32* %5
	%52 = icmp ult %Int32 %51, 64
	br %Bool %52 , label %body_2, label %break_2
body_2:
	%53 = load %Int32, %Int32* %5
	%54 = bitcast %Int32 %53 to %Int32
	%55 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %54
	%56 = load %Int32, %Int32* %5
	%57 = sub %Int32 %56, 2
	%58 = bitcast %Int32 %57 to %Int32
	%59 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %58
	%60 = load %Word32, %Word32* %59
	%61 = call %Word32 @sig1(%Word32 %60)
	%62 = bitcast %Word32 %61 to %Int32
	%63 = load %Int32, %Int32* %5
	%64 = sub %Int32 %63, 7
	%65 = bitcast %Int32 %64 to %Int32
	%66 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %65
	%67 = load %Word32, %Word32* %66
	%68 = bitcast %Word32 %67 to %Int32
	%69 = add %Int32 %62, %68
	%70 = load %Int32, %Int32* %5
	%71 = sub %Int32 %70, 15
	%72 = bitcast %Int32 %71 to %Int32
	%73 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %72
	%74 = load %Word32, %Word32* %73
	%75 = call %Word32 @sig0(%Word32 %74)
	%76 = bitcast %Word32 %75 to %Int32
	%77 = add %Int32 %69, %76
	%78 = load %Int32, %Int32* %5
	%79 = sub %Int32 %78, 16
	%80 = bitcast %Int32 %79 to %Int32
	%81 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %80
	%82 = load %Word32, %Word32* %81
	%83 = bitcast %Word32 %82 to %Int32
	%84 = add %Int32 %77, %83
	%85 = bitcast %Int32 %84 to %Word32
	store %Word32 %85, %Word32* %55
	%86 = load %Int32, %Int32* %5
	%87 = add %Int32 %86, 1
	store %Int32 %87, %Int32* %5
	br label %again_2
break_2:
	%88 = alloca [8 x %Word32], align 1
	%89 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%90 = load [8 x %Word32], [8 x %Word32]* %89
	%91 = zext i8 8 to %Int32
	store [8 x %Word32] %90, [8 x %Word32]* %88
	store %Int32 0, %Int32* %5
	br label %again_3
again_3:
	%92 = load %Int32, %Int32* %5
	%93 = icmp ult %Int32 %92, 64
	br %Bool %93 , label %body_3, label %break_3
body_3:
	%94 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 7
	%95 = load %Word32, %Word32* %94
	%96 = bitcast %Word32 %95 to %Int32
	%97 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 4
	%98 = load %Word32, %Word32* %97
	%99 = call %Word32 @ep1(%Word32 %98)
	%100 = bitcast %Word32 %99 to %Int32
	%101 = add %Int32 %96, %100
	%102 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 4
	%103 = load %Word32, %Word32* %102
	%104 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 5
	%105 = load %Word32, %Word32* %104
	%106 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 6
	%107 = load %Word32, %Word32* %106
	%108 = call %Word32 @ch(%Word32 %103, %Word32 %105, %Word32 %107)
	%109 = bitcast %Word32 %108 to %Int32
	%110 = add %Int32 %101, %109
	%111 = load %Int32, %Int32* %5
	%112 = bitcast %Int32 %111 to %Int32
	%113 = getelementptr [64 x i32], [64 x i32]* @k, %Int32 0, %Int32 %112
	%114 = load i32, i32* %113
	%115 = bitcast i32 %114 to %Int32
	%116 = add %Int32 %110, %115
	%117 = load %Int32, %Int32* %5
	%118 = bitcast %Int32 %117 to %Int32
	%119 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %118
	%120 = load %Word32, %Word32* %119
	%121 = bitcast %Word32 %120 to %Int32
	%122 = add %Int32 %116, %121
	%123 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 0
	%124 = load %Word32, %Word32* %123
	%125 = call %Word32 @ep0(%Word32 %124)
	%126 = bitcast %Word32 %125 to %Int32
	%127 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 0
	%128 = load %Word32, %Word32* %127
	%129 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 1
	%130 = load %Word32, %Word32* %129
	%131 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 2
	%132 = load %Word32, %Word32* %131
	%133 = call %Word32 @maj(%Word32 %128, %Word32 %130, %Word32 %132)
	%134 = bitcast %Word32 %133 to %Int32
	%135 = add %Int32 %126, %134
	%136 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 7
	%137 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 6
	%138 = load %Word32, %Word32* %137
	store %Word32 %138, %Word32* %136
	%139 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 6
	%140 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 5
	%141 = load %Word32, %Word32* %140
	store %Word32 %141, %Word32* %139
	%142 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 5
	%143 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 4
	%144 = load %Word32, %Word32* %143
	store %Word32 %144, %Word32* %142
	%145 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 4
	%146 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 3
	%147 = load %Word32, %Word32* %146
	%148 = bitcast %Word32 %147 to %Int32
	%149 = add %Int32 %148, %122
	%150 = bitcast %Int32 %149 to %Word32
	store %Word32 %150, %Word32* %145
	%151 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 3
	%152 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 2
	%153 = load %Word32, %Word32* %152
	store %Word32 %153, %Word32* %151
	%154 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 2
	%155 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 1
	%156 = load %Word32, %Word32* %155
	store %Word32 %156, %Word32* %154
	%157 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 1
	%158 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 0
	%159 = load %Word32, %Word32* %158
	store %Word32 %159, %Word32* %157
	%160 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 0
	%161 = add %Int32 %122, %135
	%162 = bitcast %Int32 %161 to %Word32
	store %Word32 %162, %Word32* %160
	%163 = load %Int32, %Int32* %5
	%164 = add %Int32 %163, 1
	store %Int32 %164, %Int32* %5
	br label %again_3
break_3:
	store %Int32 0, %Int32* %5
	br label %again_4
again_4:
	%165 = load %Int32, %Int32* %5
	%166 = icmp ult %Int32 %165, 8
	br %Bool %166 , label %body_4, label %break_4
body_4:
	%167 = load %Int32, %Int32* %5
	%168 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%169 = bitcast %Int32 %167 to %Int32
	%170 = getelementptr [8 x %Word32], [8 x %Word32]* %168, %Int32 0, %Int32 %169
	%171 = load %Int32, %Int32* %5
	%172 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%173 = bitcast %Int32 %171 to %Int32
	%174 = getelementptr [8 x %Word32], [8 x %Word32]* %172, %Int32 0, %Int32 %173
	%175 = load %Word32, %Word32* %174
	%176 = bitcast %Word32 %175 to %Int32
	%177 = load %Int32, %Int32* %5
	%178 = bitcast %Int32 %177 to %Int32
	%179 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 %178
	%180 = load %Word32, %Word32* %179
	%181 = bitcast %Word32 %180 to %Int32
	%182 = add %Int32 %176, %181
	%183 = bitcast %Int32 %182 to %Word32
	store %Word32 %183, %Word32* %170
	%184 = load %Int32, %Int32* %5
	%185 = add %Int32 %184, 1
	store %Int32 %185, %Int32* %5
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
	%7 = bitcast %Int32 %5 to %Int32
	%8 = getelementptr [64 x %Word8], [64 x %Word8]* %6, %Int32 0, %Int32 %7
	%9 = load %Int32, %Int32* %1
	%10 = bitcast %Int32 %9 to %Int32
	%11 = getelementptr [0 x %Word8], [0 x %Word8]* %msg, %Int32 0, %Int32 %10
	%12 = load %Word8, %Word8* %11
	store %Word8 %12, %Word8* %8
	%13 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%14 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%15 = load %Int32, %Int32* %14
	%16 = add %Int32 %15, 1
	store %Int32 %16, %Int32* %13
	%17 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%18 = load %Int32, %Int32* %17
	%19 = icmp eq %Int32 %18, 64
	br %Bool %19 , label %then_0, label %endif_0
then_0:
	%20 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%21 = bitcast [64 x %Word8]* %20 to [0 x %Word8]*
	call void @transform(%Context* %ctx, [0 x %Word8]* %21)
	%22 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%23 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%24 = load %Int64, %Int64* %23
	%25 = add %Int64 %24, 512
	store %Int64 %25, %Int64* %22
	%26 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	store %Int32 0, %Int32* %26
	br label %endif_0
endif_0:
	%27 = load %Int32, %Int32* %1
	%28 = add %Int32 %27, 1
	store %Int32 %28, %Int32* %1
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
	%10 = bitcast %Int32 %8 to %Int32
	%11 = getelementptr [64 x %Word8], [64 x %Word8]* %9, %Int32 0, %Int32 %10
	store %Word8 128, %Word8* %11
	%12 = load %Int32, %Int32* %1
	%13 = add %Int32 %12, 1
	store %Int32 %13, %Int32* %1
	%14 = load %Int32, %Int32* %1
	%15 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%16 = bitcast %Int32 %14 to %Int32
	%17 = getelementptr [64 x %Word8], [64 x %Word8]* %15, %Int32 0, %Int32 %16
	%18 = bitcast %Word8* %17 to i8*
	%19 = load %Int32, %Int32* %4
	%20 = load %Int32, %Int32* %1
	%21 = sub %Int32 %19, %20
	%22 = zext %Int32 %21 to %SizeT
	%23 = call i8* @memset(i8* %18, %Int 0, %SizeT %22)
	;ctx.data[i:n-i] = []
	%24 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%25 = load %Int32, %Int32* %24
	%26 = icmp uge %Int32 %25, 56
	br %Bool %26 , label %then_1, label %endif_1
then_1:
	%27 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%28 = bitcast [64 x %Word8]* %27 to [0 x %Word8]*
	call void @transform(%Context* %ctx, [0 x %Word8]* %28)
	%29 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%30 = bitcast [64 x %Word8]* %29 to i8*
	%31 = call i8* @memset(i8* %30, %Int 0, %SizeT 56)
	;ctx.data[0:56] = []
	br label %endif_1
endif_1:

	; Append to the padding the total message's length in bits and transform.
	%32 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%33 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%34 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%35 = load %Int32, %Int32* %34
	%36 = zext %Int32 %35 to %Int64
	%37 = mul %Int64 %36, 8
	%38 = load %Int64, %Int64* %33
	%39 = add %Int64 %38, %37
	store %Int64 %39, %Int64* %32
	%40 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%41 = getelementptr [64 x %Word8], [64 x %Word8]* %40, %Int32 0, %Int32 63
	%42 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%43 = load %Int64, %Int64* %42
	%44 = bitcast %Int64 %43 to %Word64
	%45 = zext i8 0 to %Word64
	%46 = lshr %Word64 %44, %45
	%47 = trunc %Word64 %46 to %Word8
	store %Word8 %47, %Word8* %41
	%48 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%49 = getelementptr [64 x %Word8], [64 x %Word8]* %48, %Int32 0, %Int32 62
	%50 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%51 = load %Int64, %Int64* %50
	%52 = bitcast %Int64 %51 to %Word64
	%53 = zext i8 8 to %Word64
	%54 = lshr %Word64 %52, %53
	%55 = trunc %Word64 %54 to %Word8
	store %Word8 %55, %Word8* %49
	%56 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%57 = getelementptr [64 x %Word8], [64 x %Word8]* %56, %Int32 0, %Int32 61
	%58 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%59 = load %Int64, %Int64* %58
	%60 = bitcast %Int64 %59 to %Word64
	%61 = zext i8 16 to %Word64
	%62 = lshr %Word64 %60, %61
	%63 = trunc %Word64 %62 to %Word8
	store %Word8 %63, %Word8* %57
	%64 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%65 = getelementptr [64 x %Word8], [64 x %Word8]* %64, %Int32 0, %Int32 60
	%66 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%67 = load %Int64, %Int64* %66
	%68 = bitcast %Int64 %67 to %Word64
	%69 = zext i8 24 to %Word64
	%70 = lshr %Word64 %68, %69
	%71 = trunc %Word64 %70 to %Word8
	store %Word8 %71, %Word8* %65
	%72 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%73 = getelementptr [64 x %Word8], [64 x %Word8]* %72, %Int32 0, %Int32 59
	%74 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%75 = load %Int64, %Int64* %74
	%76 = bitcast %Int64 %75 to %Word64
	%77 = zext i8 32 to %Word64
	%78 = lshr %Word64 %76, %77
	%79 = trunc %Word64 %78 to %Word8
	store %Word8 %79, %Word8* %73
	%80 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%81 = getelementptr [64 x %Word8], [64 x %Word8]* %80, %Int32 0, %Int32 58
	%82 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%83 = load %Int64, %Int64* %82
	%84 = bitcast %Int64 %83 to %Word64
	%85 = zext i8 40 to %Word64
	%86 = lshr %Word64 %84, %85
	%87 = trunc %Word64 %86 to %Word8
	store %Word8 %87, %Word8* %81
	%88 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%89 = getelementptr [64 x %Word8], [64 x %Word8]* %88, %Int32 0, %Int32 57
	%90 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%91 = load %Int64, %Int64* %90
	%92 = bitcast %Int64 %91 to %Word64
	%93 = zext i8 48 to %Word64
	%94 = lshr %Word64 %92, %93
	%95 = trunc %Word64 %94 to %Word8
	store %Word8 %95, %Word8* %89
	%96 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%97 = getelementptr [64 x %Word8], [64 x %Word8]* %96, %Int32 0, %Int32 56
	%98 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%99 = load %Int64, %Int64* %98
	%100 = bitcast %Int64 %99 to %Word64
	%101 = zext i8 56 to %Word64
	%102 = lshr %Word64 %100, %101
	%103 = trunc %Word64 %102 to %Word8
	store %Word8 %103, %Word8* %97
	%104 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%105 = bitcast [64 x %Word8]* %104 to [0 x %Word8]*
	call void @transform(%Context* %ctx, [0 x %Word8]* %105)

	; Since this implementation uses little endian byte ordering
	; and SHA uses big endian, reverse all the bytes
	; when copying the final state to the output hash.
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%106 = load %Int32, %Int32* %1
	%107 = icmp ult %Int32 %106, 4
	br %Bool %107 , label %body_1, label %break_1
body_1:
	%108 = load %Int32, %Int32* %1
	%109 = mul %Int32 %108, 8
	%110 = sub %Int32 24, %109
	%111 = load %Int32, %Int32* %1
	%112 = add %Int32 %111, 0
	%113 = bitcast %Int32 %112 to %Int32
	%114 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %113
	%115 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%116 = getelementptr [8 x %Word32], [8 x %Word32]* %115, %Int32 0, %Int32 0
	%117 = load %Word32, %Word32* %116
	%118 = bitcast %Int32 %110 to %Word32
	%119 = lshr %Word32 %117, %118
	%120 = trunc %Word32 %119 to %Word8
	store %Word8 %120, %Word8* %114
	%121 = load %Int32, %Int32* %1
	%122 = add %Int32 %121, 4
	%123 = bitcast %Int32 %122 to %Int32
	%124 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %123
	%125 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%126 = getelementptr [8 x %Word32], [8 x %Word32]* %125, %Int32 0, %Int32 1
	%127 = load %Word32, %Word32* %126
	%128 = bitcast %Int32 %110 to %Word32
	%129 = lshr %Word32 %127, %128
	%130 = trunc %Word32 %129 to %Word8
	store %Word8 %130, %Word8* %124
	%131 = load %Int32, %Int32* %1
	%132 = add %Int32 %131, 8
	%133 = bitcast %Int32 %132 to %Int32
	%134 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %133
	%135 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%136 = getelementptr [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 2
	%137 = load %Word32, %Word32* %136
	%138 = bitcast %Int32 %110 to %Word32
	%139 = lshr %Word32 %137, %138
	%140 = trunc %Word32 %139 to %Word8
	store %Word8 %140, %Word8* %134
	%141 = load %Int32, %Int32* %1
	%142 = add %Int32 %141, 12
	%143 = bitcast %Int32 %142 to %Int32
	%144 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %143
	%145 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%146 = getelementptr [8 x %Word32], [8 x %Word32]* %145, %Int32 0, %Int32 3
	%147 = load %Word32, %Word32* %146
	%148 = bitcast %Int32 %110 to %Word32
	%149 = lshr %Word32 %147, %148
	%150 = trunc %Word32 %149 to %Word8
	store %Word8 %150, %Word8* %144
	%151 = load %Int32, %Int32* %1
	%152 = add %Int32 %151, 16
	%153 = bitcast %Int32 %152 to %Int32
	%154 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %153
	%155 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%156 = getelementptr [8 x %Word32], [8 x %Word32]* %155, %Int32 0, %Int32 4
	%157 = load %Word32, %Word32* %156
	%158 = bitcast %Int32 %110 to %Word32
	%159 = lshr %Word32 %157, %158
	%160 = trunc %Word32 %159 to %Word8
	store %Word8 %160, %Word8* %154
	%161 = load %Int32, %Int32* %1
	%162 = add %Int32 %161, 20
	%163 = bitcast %Int32 %162 to %Int32
	%164 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %163
	%165 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%166 = getelementptr [8 x %Word32], [8 x %Word32]* %165, %Int32 0, %Int32 5
	%167 = load %Word32, %Word32* %166
	%168 = bitcast %Int32 %110 to %Word32
	%169 = lshr %Word32 %167, %168
	%170 = trunc %Word32 %169 to %Word8
	store %Word8 %170, %Word8* %164
	%171 = load %Int32, %Int32* %1
	%172 = add %Int32 %171, 24
	%173 = bitcast %Int32 %172 to %Int32
	%174 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %173
	%175 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%176 = getelementptr [8 x %Word32], [8 x %Word32]* %175, %Int32 0, %Int32 6
	%177 = load %Word32, %Word32* %176
	%178 = bitcast %Int32 %110 to %Word32
	%179 = lshr %Word32 %177, %178
	%180 = trunc %Word32 %179 to %Word8
	store %Word8 %180, %Word8* %174
	%181 = load %Int32, %Int32* %1
	%182 = add %Int32 %181, 28
	%183 = bitcast %Int32 %182 to %Int32
	%184 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %183
	%185 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%186 = getelementptr [8 x %Word32], [8 x %Word32]* %185, %Int32 0, %Int32 7
	%187 = load %Word32, %Word32* %186
	%188 = bitcast %Int32 %110 to %Word32
	%189 = lshr %Word32 %187, %188
	%190 = trunc %Word32 %189 to %Word8
	store %Word8 %190, %Word8* %184
	%191 = load %Int32, %Int32* %1
	%192 = add %Int32 %191, 1
	store %Int32 %192, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define void @sha256_hash([0 x %Word8]* %msg, %Int32 %msgLen, %sha256_Hash* %outHash) {
	%1 = alloca %Context, align 128
	store %Context zeroinitializer, %Context* %1
	%2 = bitcast %Context* %1 to %Context*
	call void @contextInit(%Context* %2)
	%3 = bitcast %Context* %1 to %Context*
	call void @update(%Context* %3, [0 x %Word8]* %msg, %Int32 %msgLen)
	%4 = bitcast %Context* %1 to %Context*
	call void @final(%Context* %4, %sha256_Hash* %outHash)
	ret void
}


