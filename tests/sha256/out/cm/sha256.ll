
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
	%Nat32,
	%Nat64,
	[8 x %Word32]
};

define internal %Word32 @rotleft(%Word32 %a, %Nat32 %b) {
	%1 = bitcast %Nat32 %b to %Word32
	%2 = shl %Word32 %a, %1
	%3 = sub %Nat32 32, %b
	%4 = bitcast %Nat32 %3 to %Word32
	%5 = lshr %Word32 %a, %4
	%6 = or %Word32 %2, %5
	ret %Word32 %6
}

define internal %Word32 @rotright(%Word32 %a, %Nat32 %b) {
	%1 = bitcast %Nat32 %b to %Word32
	%2 = lshr %Word32 %a, %1
	%3 = sub %Nat32 32, %b
	%4 = bitcast %Nat32 %3 to %Word32
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
	%1 = call %Word32 @rotright(%Word32 %x, %Nat32 2)
	%2 = call %Word32 @rotright(%Word32 %x, %Nat32 13)
	%3 = call %Word32 @rotright(%Word32 %x, %Nat32 22)
	%4 = xor %Word32 %2, %3
	%5 = xor %Word32 %1, %4
	ret %Word32 %5
}

define internal %Word32 @ep1(%Word32 %x) {
	%1 = call %Word32 @rotright(%Word32 %x, %Nat32 6)
	%2 = call %Word32 @rotright(%Word32 %x, %Nat32 11)
	%3 = call %Word32 @rotright(%Word32 %x, %Nat32 25)
	%4 = xor %Word32 %2, %3
	%5 = xor %Word32 %1, %4
	ret %Word32 %5
}

define internal %Word32 @sig0(%Word32 %x) {
	%1 = call %Word32 @rotright(%Word32 %x, %Nat32 7)
	%2 = call %Word32 @rotright(%Word32 %x, %Nat32 18)
	%3 = zext i8 3 to %Word32
	%4 = lshr %Word32 %x, %3
	%5 = xor %Word32 %2, %4
	%6 = xor %Word32 %1, %5
	ret %Word32 %6
}

define internal %Word32 @sig1(%Word32 %x) {
	%1 = call %Word32 @rotright(%Word32 %x, %Nat32 17)
	%2 = call %Word32 @rotright(%Word32 %x, %Nat32 19)
	%3 = zext i8 10 to %Word32
	%4 = lshr %Word32 %x, %3
	%5 = xor %Word32 %2, %4
	%6 = xor %Word32 %1, %5
	ret %Word32 %6
}

@initalState = constant [8 x %Word32] [
	%Word32 1779033703,
	%Word32 3144134277,
	%Word32 1013904242,
	%Word32 2773480762,
	%Word32 1359893119,
	%Word32 2600822924,
	%Word32 528734635,
	%Word32 1541459225
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
	%10 = zext i8 8 to %Nat32
	store [8 x %Word32] %9, [8 x %Word32]* %1
	ret void
}

@k = constant [64 x %Word32] [
	%Word32 1116352408,
	%Word32 1899447441,
	%Word32 3049323471,
	%Word32 3921009573,
	%Word32 961987163,
	%Word32 1508970993,
	%Word32 2453635748,
	%Word32 2870763221,
	%Word32 3624381080,
	%Word32 310598401,
	%Word32 607225278,
	%Word32 1426881987,
	%Word32 1925078388,
	%Word32 2162078206,
	%Word32 2614888103,
	%Word32 3248222580,
	%Word32 3835390401,
	%Word32 4022224774,
	%Word32 264347078,
	%Word32 604807628,
	%Word32 770255983,
	%Word32 1249150122,
	%Word32 1555081692,
	%Word32 1996064986,
	%Word32 2554220882,
	%Word32 2821834349,
	%Word32 2952996808,
	%Word32 3210313671,
	%Word32 3336571891,
	%Word32 3584528711,
	%Word32 113926993,
	%Word32 338241895,
	%Word32 666307205,
	%Word32 773529912,
	%Word32 1294757372,
	%Word32 1396182291,
	%Word32 1695183700,
	%Word32 1986661051,
	%Word32 2177026350,
	%Word32 2456956037,
	%Word32 2730485921,
	%Word32 2820302411,
	%Word32 3259730800,
	%Word32 3345764771,
	%Word32 3516065817,
	%Word32 3600352804,
	%Word32 4094571909,
	%Word32 275423344,
	%Word32 430227734,
	%Word32 506948616,
	%Word32 659060556,
	%Word32 883997877,
	%Word32 958139571,
	%Word32 1322822218,
	%Word32 1537002063,
	%Word32 1747873779,
	%Word32 1955562222,
	%Word32 2024104815,
	%Word32 2227730452,
	%Word32 2361852424,
	%Word32 2428436474,
	%Word32 2756734187,
	%Word32 3204031479,
	%Word32 3329325298
]
define internal void @transform(%Context* %ctx, [0 x %Word8]* %data) {
	%1 = alloca [64 x %Word32], align 1
	%2 = zext i8 64 to %Nat32
	%3 = mul %Nat32 %2, 4
	%4 = bitcast [64 x %Word32]* %1 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %4, i8 0, %Nat32 %3, i1 0)
	%5 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %5
	%6 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %6
; while_1
	br label %again_1
again_1:
	%7 = load %Nat32, %Nat32* %5
	%8 = icmp ult %Nat32 %7, 16
	br %Bool %8 , label %body_1, label %break_1
body_1:
	%9 = load %Nat32, %Nat32* %6
	%10 = add %Nat32 %9, 0
	%11 = bitcast %Nat32 %10 to %Nat32
	%12 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Nat32 %11
	%13 = load %Word8, %Word8* %12
	%14 = zext %Word8 %13 to %Word32
	%15 = zext i8 24 to %Word32
	%16 = shl %Word32 %14, %15
	%17 = load %Nat32, %Nat32* %6
	%18 = add %Nat32 %17, 1
	%19 = bitcast %Nat32 %18 to %Nat32
	%20 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Nat32 %19
	%21 = load %Word8, %Word8* %20
	%22 = zext %Word8 %21 to %Word32
	%23 = zext i8 16 to %Word32
	%24 = shl %Word32 %22, %23
	%25 = load %Nat32, %Nat32* %6
	%26 = add %Nat32 %25, 2
	%27 = bitcast %Nat32 %26 to %Nat32
	%28 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Nat32 %27
	%29 = load %Word8, %Word8* %28
	%30 = zext %Word8 %29 to %Word32
	%31 = zext i8 8 to %Word32
	%32 = shl %Word32 %30, %31
	%33 = load %Nat32, %Nat32* %6
	%34 = add %Nat32 %33, 3
	%35 = bitcast %Nat32 %34 to %Nat32
	%36 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Nat32 %35
	%37 = load %Word8, %Word8* %36
	%38 = zext %Word8 %37 to %Word32
	%39 = zext i8 0 to %Word32
	%40 = shl %Word32 %38, %39
	%41 = or %Word32 %32, %40
	%42 = or %Word32 %24, %41
	%43 = or %Word32 %16, %42
	%44 = load %Nat32, %Nat32* %5
	%45 = bitcast %Nat32 %44 to %Nat32
	%46 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Nat32 %45
	store %Word32 %43, %Word32* %46
	%47 = load %Nat32, %Nat32* %6
	%48 = add %Nat32 %47, 4
	store %Nat32 %48, %Nat32* %6
	%49 = load %Nat32, %Nat32* %5
	%50 = add %Nat32 %49, 1
	store %Nat32 %50, %Nat32* %5
	br label %again_1
break_1:
; while_2
	br label %again_2
again_2:
	%51 = load %Nat32, %Nat32* %5
	%52 = icmp ult %Nat32 %51, 64
	br %Bool %52 , label %body_2, label %break_2
body_2:
	%53 = load %Nat32, %Nat32* %5
	%54 = bitcast %Nat32 %53 to %Nat32
	%55 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Nat32 %54
	%56 = load %Nat32, %Nat32* %5
	%57 = sub %Nat32 %56, 2
	%58 = bitcast %Nat32 %57 to %Nat32
	%59 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Nat32 %58
	%60 = load %Word32, %Word32* %59
	%61 = call %Word32 @sig1(%Word32 %60)
	%62 = bitcast %Word32 %61 to %Nat32
	%63 = load %Nat32, %Nat32* %5
	%64 = sub %Nat32 %63, 7
	%65 = bitcast %Nat32 %64 to %Nat32
	%66 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Nat32 %65
	%67 = load %Word32, %Word32* %66
	%68 = bitcast %Word32 %67 to %Nat32
	%69 = add %Nat32 %62, %68
	%70 = load %Nat32, %Nat32* %5
	%71 = sub %Nat32 %70, 15
	%72 = bitcast %Nat32 %71 to %Nat32
	%73 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Nat32 %72
	%74 = load %Word32, %Word32* %73
	%75 = call %Word32 @sig0(%Word32 %74)
	%76 = bitcast %Word32 %75 to %Nat32
	%77 = add %Nat32 %69, %76
	%78 = load %Nat32, %Nat32* %5
	%79 = sub %Nat32 %78, 16
	%80 = bitcast %Nat32 %79 to %Nat32
	%81 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Nat32 %80
	%82 = load %Word32, %Word32* %81
	%83 = bitcast %Word32 %82 to %Nat32
	%84 = add %Nat32 %77, %83
	%85 = bitcast %Nat32 %84 to %Word32
	store %Word32 %85, %Word32* %55
	%86 = load %Nat32, %Nat32* %5
	%87 = add %Nat32 %86, 1
	store %Nat32 %87, %Nat32* %5
	br label %again_2
break_2:
	%88 = alloca [8 x %Word32], align 1
	%89 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%90 = load [8 x %Word32], [8 x %Word32]* %89
	%91 = zext i8 8 to %Nat32
	store [8 x %Word32] %90, [8 x %Word32]* %88
	store %Nat32 0, %Nat32* %5
; while_3
	br label %again_3
again_3:
	%92 = load %Nat32, %Nat32* %5
	%93 = icmp ult %Nat32 %92, 64
	br %Bool %93 , label %body_3, label %break_3
body_3:
	%94 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 7
	%95 = load %Word32, %Word32* %94
	%96 = bitcast %Word32 %95 to %Nat32
	%97 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 4
	%98 = load %Word32, %Word32* %97
	%99 = call %Word32 @ep1(%Word32 %98)
	%100 = bitcast %Word32 %99 to %Nat32
	%101 = add %Nat32 %96, %100
	%102 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 4
	%103 = load %Word32, %Word32* %102
	%104 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 5
	%105 = load %Word32, %Word32* %104
	%106 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 6
	%107 = load %Word32, %Word32* %106
	%108 = call %Word32 @ch(%Word32 %103, %Word32 %105, %Word32 %107)
	%109 = bitcast %Word32 %108 to %Nat32
	%110 = add %Nat32 %101, %109
	%111 = load %Nat32, %Nat32* %5
	%112 = bitcast %Nat32 %111 to %Nat32
	%113 = getelementptr [64 x %Word32], [64 x %Word32]* @k, %Int32 0, %Nat32 %112
	%114 = load %Word32, %Word32* %113
	%115 = bitcast %Word32 %114 to %Nat32
	%116 = add %Nat32 %110, %115
	%117 = load %Nat32, %Nat32* %5
	%118 = bitcast %Nat32 %117 to %Nat32
	%119 = getelementptr [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Nat32 %118
	%120 = load %Word32, %Word32* %119
	%121 = bitcast %Word32 %120 to %Nat32
	%122 = add %Nat32 %116, %121
	%123 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 0
	%124 = load %Word32, %Word32* %123
	%125 = call %Word32 @ep0(%Word32 %124)
	%126 = bitcast %Word32 %125 to %Nat32
	%127 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 0
	%128 = load %Word32, %Word32* %127
	%129 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 1
	%130 = load %Word32, %Word32* %129
	%131 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Int32 2
	%132 = load %Word32, %Word32* %131
	%133 = call %Word32 @maj(%Word32 %128, %Word32 %130, %Word32 %132)
	%134 = bitcast %Word32 %133 to %Nat32
	%135 = add %Nat32 %126, %134
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
	%148 = bitcast %Word32 %147 to %Nat32
	%149 = add %Nat32 %148, %122
	%150 = bitcast %Nat32 %149 to %Word32
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
	%161 = add %Nat32 %122, %135
	%162 = bitcast %Nat32 %161 to %Word32
	store %Word32 %162, %Word32* %160
	%163 = load %Nat32, %Nat32* %5
	%164 = add %Nat32 %163, 1
	store %Nat32 %164, %Nat32* %5
	br label %again_3
break_3:
	store %Nat32 0, %Nat32* %5
; while_4
	br label %again_4
again_4:
	%165 = load %Nat32, %Nat32* %5
	%166 = icmp ult %Nat32 %165, 8
	br %Bool %166 , label %body_4, label %break_4
body_4:
	%167 = load %Nat32, %Nat32* %5
	%168 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%169 = bitcast %Nat32 %167 to %Nat32
	%170 = getelementptr [8 x %Word32], [8 x %Word32]* %168, %Int32 0, %Nat32 %169
	%171 = load %Nat32, %Nat32* %5
	%172 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%173 = bitcast %Nat32 %171 to %Nat32
	%174 = getelementptr [8 x %Word32], [8 x %Word32]* %172, %Int32 0, %Nat32 %173
	%175 = load %Word32, %Word32* %174
	%176 = bitcast %Word32 %175 to %Nat32
	%177 = load %Nat32, %Nat32* %5
	%178 = bitcast %Nat32 %177 to %Nat32
	%179 = getelementptr [8 x %Word32], [8 x %Word32]* %88, %Int32 0, %Nat32 %178
	%180 = load %Word32, %Word32* %179
	%181 = bitcast %Word32 %180 to %Nat32
	%182 = add %Nat32 %176, %181
	%183 = bitcast %Nat32 %182 to %Word32
	store %Word32 %183, %Word32* %170
	%184 = load %Nat32, %Nat32* %5
	%185 = add %Nat32 %184, 1
	store %Nat32 %185, %Nat32* %5
	br label %again_4
break_4:
	ret void
}

define internal void @update(%Context* %ctx, [0 x %Word8]* %msg, %Nat32 %msgLen) {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ult %Nat32 %2, %msgLen
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%5 = load %Nat32, %Nat32* %4
	%6 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%7 = bitcast %Nat32 %5 to %Nat32
	%8 = getelementptr [64 x %Word8], [64 x %Word8]* %6, %Int32 0, %Nat32 %7
	%9 = load %Nat32, %Nat32* %1
	%10 = bitcast %Nat32 %9 to %Nat32
	%11 = getelementptr [0 x %Word8], [0 x %Word8]* %msg, %Int32 0, %Nat32 %10
	%12 = load %Word8, %Word8* %11
	store %Word8 %12, %Word8* %8
	%13 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%14 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%15 = load %Nat32, %Nat32* %14
	%16 = add %Nat32 %15, 1
	store %Nat32 %16, %Nat32* %13
; if_0
	%17 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%18 = load %Nat32, %Nat32* %17
	%19 = icmp eq %Nat32 %18, 64
	br %Bool %19 , label %then_0, label %endif_0
then_0:
	%20 = bitcast %Context* %ctx to %Context*
	%21 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%22 = bitcast [64 x %Word8]* %21 to [0 x %Word8]*
	call void @transform(%Context* %20, [0 x %Word8]* %22)
	%23 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%24 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%25 = load %Nat64, %Nat64* %24
	%26 = add %Nat64 %25, 512
	store %Nat64 %26, %Nat64* %23
	%27 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	store %Nat32 0, %Nat32* %27
	br label %endif_0
endif_0:
	%28 = load %Nat32, %Nat32* %1
	%29 = add %Nat32 %28, 1
	store %Nat32 %29, %Nat32* %1
	br label %again_1
break_1:
	ret void
}

define internal void @final(%Context* %ctx, %sha256_Hash* %outHash) {
	%1 = alloca %Nat32, align 4
	%2 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%3 = load %Nat32, %Nat32* %2
	store %Nat32 %3, %Nat32* %1

	; Pad whatever data is left in the buffer.
	%4 = alloca %Nat32, align 4
	store %Nat32 64, %Nat32* %4
; if_0
	%5 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%6 = load %Nat32, %Nat32* %5
	%7 = icmp ult %Nat32 %6, 56
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	store %Nat32 56, %Nat32* %4
	br label %endif_0
endif_0:
	%8 = load %Nat32, %Nat32* %1
	%9 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%10 = bitcast %Nat32 %8 to %Nat32
	%11 = getelementptr [64 x %Word8], [64 x %Word8]* %9, %Int32 0, %Nat32 %10
	store %Word8 128, %Word8* %11
	%12 = load %Nat32, %Nat32* %1
	%13 = add %Nat32 %12, 1
	store %Nat32 %13, %Nat32* %1
	%14 = load %Nat32, %Nat32* %1
	%15 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%16 = bitcast %Nat32 %14 to %Nat32
	%17 = getelementptr [64 x %Word8], [64 x %Word8]* %15, %Int32 0, %Nat32 %16
	%18 = bitcast %Word8* %17 to i8*
	%19 = load %Nat32, %Nat32* %4
	%20 = load %Nat32, %Nat32* %1
	%21 = sub %Nat32 %19, %20
	%22 = zext %Nat32 %21 to %SizeT
	%23 = call i8* @memset(i8* %18, %Int 0, %SizeT %22)
	;ctx.data[i:n-i] = []
; if_1
	%24 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%25 = load %Nat32, %Nat32* %24
	%26 = icmp uge %Nat32 %25, 56
	br %Bool %26 , label %then_1, label %endif_1
then_1:
	%27 = bitcast %Context* %ctx to %Context*
	%28 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%29 = bitcast [64 x %Word8]* %28 to [0 x %Word8]*
	call void @transform(%Context* %27, [0 x %Word8]* %29)
	%30 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%31 = bitcast [64 x %Word8]* %30 to i8*
	%32 = call i8* @memset(i8* %31, %Int 0, %SizeT 56)
	;ctx.data[0:56] = []
	br label %endif_1
endif_1:

	; Append to the padding the total message's length in bits and transform.
	%33 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%34 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%35 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 1
	%36 = load %Nat32, %Nat32* %35
	%37 = zext %Nat32 %36 to %Nat64
	%38 = mul %Nat64 %37, 8
	%39 = load %Nat64, %Nat64* %34
	%40 = add %Nat64 %39, %38
	store %Nat64 %40, %Nat64* %33
	%41 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%42 = getelementptr [64 x %Word8], [64 x %Word8]* %41, %Int32 0, %Int32 63
	%43 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%44 = load %Nat64, %Nat64* %43
	%45 = bitcast %Nat64 %44 to %Word64
	%46 = zext i8 0 to %Word64
	%47 = lshr %Word64 %45, %46
	%48 = trunc %Word64 %47 to %Word8
	store %Word8 %48, %Word8* %42
	%49 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%50 = getelementptr [64 x %Word8], [64 x %Word8]* %49, %Int32 0, %Int32 62
	%51 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%52 = load %Nat64, %Nat64* %51
	%53 = bitcast %Nat64 %52 to %Word64
	%54 = zext i8 8 to %Word64
	%55 = lshr %Word64 %53, %54
	%56 = trunc %Word64 %55 to %Word8
	store %Word8 %56, %Word8* %50
	%57 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%58 = getelementptr [64 x %Word8], [64 x %Word8]* %57, %Int32 0, %Int32 61
	%59 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%60 = load %Nat64, %Nat64* %59
	%61 = bitcast %Nat64 %60 to %Word64
	%62 = zext i8 16 to %Word64
	%63 = lshr %Word64 %61, %62
	%64 = trunc %Word64 %63 to %Word8
	store %Word8 %64, %Word8* %58
	%65 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%66 = getelementptr [64 x %Word8], [64 x %Word8]* %65, %Int32 0, %Int32 60
	%67 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%68 = load %Nat64, %Nat64* %67
	%69 = bitcast %Nat64 %68 to %Word64
	%70 = zext i8 24 to %Word64
	%71 = lshr %Word64 %69, %70
	%72 = trunc %Word64 %71 to %Word8
	store %Word8 %72, %Word8* %66
	%73 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%74 = getelementptr [64 x %Word8], [64 x %Word8]* %73, %Int32 0, %Int32 59
	%75 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%76 = load %Nat64, %Nat64* %75
	%77 = bitcast %Nat64 %76 to %Word64
	%78 = zext i8 32 to %Word64
	%79 = lshr %Word64 %77, %78
	%80 = trunc %Word64 %79 to %Word8
	store %Word8 %80, %Word8* %74
	%81 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%82 = getelementptr [64 x %Word8], [64 x %Word8]* %81, %Int32 0, %Int32 58
	%83 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%84 = load %Nat64, %Nat64* %83
	%85 = bitcast %Nat64 %84 to %Word64
	%86 = zext i8 40 to %Word64
	%87 = lshr %Word64 %85, %86
	%88 = trunc %Word64 %87 to %Word8
	store %Word8 %88, %Word8* %82
	%89 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%90 = getelementptr [64 x %Word8], [64 x %Word8]* %89, %Int32 0, %Int32 57
	%91 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%92 = load %Nat64, %Nat64* %91
	%93 = bitcast %Nat64 %92 to %Word64
	%94 = zext i8 48 to %Word64
	%95 = lshr %Word64 %93, %94
	%96 = trunc %Word64 %95 to %Word8
	store %Word8 %96, %Word8* %90
	%97 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%98 = getelementptr [64 x %Word8], [64 x %Word8]* %97, %Int32 0, %Int32 56
	%99 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%100 = load %Nat64, %Nat64* %99
	%101 = bitcast %Nat64 %100 to %Word64
	%102 = zext i8 56 to %Word64
	%103 = lshr %Word64 %101, %102
	%104 = trunc %Word64 %103 to %Word8
	store %Word8 %104, %Word8* %98
	%105 = bitcast %Context* %ctx to %Context*
	%106 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%107 = bitcast [64 x %Word8]* %106 to [0 x %Word8]*
	call void @transform(%Context* %105, [0 x %Word8]* %107)

	; Since this implementation uses little endian byte ordering
	; and SHA uses big endian, reverse all the bytes
	; when copying the final state to the output hash.
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	%108 = load %Nat32, %Nat32* %1
	%109 = icmp ult %Nat32 %108, 4
	br %Bool %109 , label %body_1, label %break_1
body_1:
	%110 = load %Nat32, %Nat32* %1
	%111 = mul %Nat32 %110, 8
	%112 = sub %Nat32 24, %111
	%113 = load %Nat32, %Nat32* %1
	%114 = add %Nat32 %113, 0
	%115 = bitcast %Nat32 %114 to %Nat32
	%116 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Nat32 %115
	%117 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%118 = getelementptr [8 x %Word32], [8 x %Word32]* %117, %Int32 0, %Int32 0
	%119 = load %Word32, %Word32* %118
	%120 = bitcast %Nat32 %112 to %Word32
	%121 = lshr %Word32 %119, %120
	%122 = trunc %Word32 %121 to %Word8
	store %Word8 %122, %Word8* %116
	%123 = load %Nat32, %Nat32* %1
	%124 = add %Nat32 %123, 4
	%125 = bitcast %Nat32 %124 to %Nat32
	%126 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Nat32 %125
	%127 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%128 = getelementptr [8 x %Word32], [8 x %Word32]* %127, %Int32 0, %Int32 1
	%129 = load %Word32, %Word32* %128
	%130 = bitcast %Nat32 %112 to %Word32
	%131 = lshr %Word32 %129, %130
	%132 = trunc %Word32 %131 to %Word8
	store %Word8 %132, %Word8* %126
	%133 = load %Nat32, %Nat32* %1
	%134 = add %Nat32 %133, 8
	%135 = bitcast %Nat32 %134 to %Nat32
	%136 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Nat32 %135
	%137 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%138 = getelementptr [8 x %Word32], [8 x %Word32]* %137, %Int32 0, %Int32 2
	%139 = load %Word32, %Word32* %138
	%140 = bitcast %Nat32 %112 to %Word32
	%141 = lshr %Word32 %139, %140
	%142 = trunc %Word32 %141 to %Word8
	store %Word8 %142, %Word8* %136
	%143 = load %Nat32, %Nat32* %1
	%144 = add %Nat32 %143, 12
	%145 = bitcast %Nat32 %144 to %Nat32
	%146 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Nat32 %145
	%147 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%148 = getelementptr [8 x %Word32], [8 x %Word32]* %147, %Int32 0, %Int32 3
	%149 = load %Word32, %Word32* %148
	%150 = bitcast %Nat32 %112 to %Word32
	%151 = lshr %Word32 %149, %150
	%152 = trunc %Word32 %151 to %Word8
	store %Word8 %152, %Word8* %146
	%153 = load %Nat32, %Nat32* %1
	%154 = add %Nat32 %153, 16
	%155 = bitcast %Nat32 %154 to %Nat32
	%156 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Nat32 %155
	%157 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%158 = getelementptr [8 x %Word32], [8 x %Word32]* %157, %Int32 0, %Int32 4
	%159 = load %Word32, %Word32* %158
	%160 = bitcast %Nat32 %112 to %Word32
	%161 = lshr %Word32 %159, %160
	%162 = trunc %Word32 %161 to %Word8
	store %Word8 %162, %Word8* %156
	%163 = load %Nat32, %Nat32* %1
	%164 = add %Nat32 %163, 20
	%165 = bitcast %Nat32 %164 to %Nat32
	%166 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Nat32 %165
	%167 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%168 = getelementptr [8 x %Word32], [8 x %Word32]* %167, %Int32 0, %Int32 5
	%169 = load %Word32, %Word32* %168
	%170 = bitcast %Nat32 %112 to %Word32
	%171 = lshr %Word32 %169, %170
	%172 = trunc %Word32 %171 to %Word8
	store %Word8 %172, %Word8* %166
	%173 = load %Nat32, %Nat32* %1
	%174 = add %Nat32 %173, 24
	%175 = bitcast %Nat32 %174 to %Nat32
	%176 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Nat32 %175
	%177 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%178 = getelementptr [8 x %Word32], [8 x %Word32]* %177, %Int32 0, %Int32 6
	%179 = load %Word32, %Word32* %178
	%180 = bitcast %Nat32 %112 to %Word32
	%181 = lshr %Word32 %179, %180
	%182 = trunc %Word32 %181 to %Word8
	store %Word8 %182, %Word8* %176
	%183 = load %Nat32, %Nat32* %1
	%184 = add %Nat32 %183, 28
	%185 = bitcast %Nat32 %184 to %Nat32
	%186 = getelementptr %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Nat32 %185
	%187 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%188 = getelementptr [8 x %Word32], [8 x %Word32]* %187, %Int32 0, %Int32 7
	%189 = load %Word32, %Word32* %188
	%190 = bitcast %Nat32 %112 to %Word32
	%191 = lshr %Word32 %189, %190
	%192 = trunc %Word32 %191 to %Word8
	store %Word8 %192, %Word8* %186
	%193 = load %Nat32, %Nat32* %1
	%194 = add %Nat32 %193, 1
	store %Nat32 %194, %Nat32* %1
	br label %again_1
break_1:
	ret void
}

define void @sha256_hash([0 x %Word8]* %msg, %Nat32 %msgLen, %sha256_Hash* %outHash) {
	%1 = alloca %Context, align 128
	store %Context zeroinitializer, %Context* %1
	%2 = bitcast %Context* %1 to %Context*
	call void @contextInit(%Context* %2)
	%3 = bitcast %Context* %1 to %Context*
	call void @update(%Context* %3, [0 x %Word8]* %msg, %Nat32 %msgLen)
	%4 = bitcast %Context* %1 to %Context*
	call void @final(%Context* %4, %sha256_Hash* %outHash)
	ret void
}


