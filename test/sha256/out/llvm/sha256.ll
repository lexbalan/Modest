
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

@initalState = constant [8 x %Int32] [
	%Int32 1779033703,
	%Int32 3144134277,
	%Int32 1013904242,
	%Int32 2773480762,
	%Int32 1359893119,
	%Int32 2600822924,
	%Int32 528734635,
	%Int32 1541459225
]
define internal void @contextInit(%Context* %ctx) {
	; -- STMT ASSIGN ARRAY --
	%1 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	; -- start vol eval --
	%2 = zext %Int8 8 to %Int32
	; -- end vol eval --
	%3 = insertvalue [8 x %Word32] zeroinitializer, %Word32 1779033703, 0
	%4 = insertvalue [8 x %Word32] %3, %Word32 3144134277, 1
	%5 = insertvalue [8 x %Word32] %4, %Word32 1013904242, 2
	%6 = insertvalue [8 x %Word32] %5, %Word32 2773480762, 3
	%7 = insertvalue [8 x %Word32] %6, %Word32 1359893119, 4
	%8 = insertvalue [8 x %Word32] %7, %Word32 2600822924, 5
	%9 = insertvalue [8 x %Word32] %8, %Word32 528734635, 6
	%10 = insertvalue [8 x %Word32] %9, %Word32 1541459225, 7
	store [8 x %Word32] %10, [8 x %Word32]* %1
	ret void
}

@k = constant [64 x %Int32] [
	%Int32 1116352408,
	%Int32 1899447441,
	%Int32 3049323471,
	%Int32 3921009573,
	%Int32 961987163,
	%Int32 1508970993,
	%Int32 2453635748,
	%Int32 2870763221,
	%Int32 3624381080,
	%Int32 310598401,
	%Int32 607225278,
	%Int32 1426881987,
	%Int32 1925078388,
	%Int32 2162078206,
	%Int32 2614888103,
	%Int32 3248222580,
	%Int32 3835390401,
	%Int32 4022224774,
	%Int32 264347078,
	%Int32 604807628,
	%Int32 770255983,
	%Int32 1249150122,
	%Int32 1555081692,
	%Int32 1996064986,
	%Int32 2554220882,
	%Int32 2821834349,
	%Int32 2952996808,
	%Int32 3210313671,
	%Int32 3336571891,
	%Int32 3584528711,
	%Int32 113926993,
	%Int32 338241895,
	%Int32 666307205,
	%Int32 773529912,
	%Int32 1294757372,
	%Int32 1396182291,
	%Int32 1695183700,
	%Int32 1986661051,
	%Int32 2177026350,
	%Int32 2456956037,
	%Int32 2730485921,
	%Int32 2820302411,
	%Int32 3259730800,
	%Int32 3345764771,
	%Int32 3516065817,
	%Int32 3600352804,
	%Int32 4094571909,
	%Int32 275423344,
	%Int32 430227734,
	%Int32 506948616,
	%Int32 659060556,
	%Int32 883997877,
	%Int32 958139571,
	%Int32 1322822218,
	%Int32 1537002063,
	%Int32 1747873779,
	%Int32 1955562222,
	%Int32 2024104815,
	%Int32 2227730452,
	%Int32 2361852424,
	%Int32 2428436474,
	%Int32 2756734187,
	%Int32 3204031479,
	%Int32 3329325298
]
define internal void @transform(%Context* %ctx, [0 x %Word8]* %data) {
	%1 = alloca [64 x %Word32], align 4
	store [64 x %Word32] zeroinitializer, [64 x %Word32]* %1
	%2 = alloca %Int32, align 4
	store %Int32 0, %Int32* %2
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	%4 = load %Int32, %Int32* %2
	%5 = icmp ult %Int32 %4, 16
	br %Bool %5 , label %body_1, label %break_1
body_1:
	%6 = load %Int32, %Int32* %3
	%7 = add %Int32 %6, 0
	%8 = getelementptr %Word8, [0 x %Word8]* %data, %Int32 %7
	%9 = load %Word8, %Word8* %8
	%10 = zext %Word8 %9 to %Word32
	%11 = shl %Word32 %10, 24
	%12 = load %Int32, %Int32* %3
	%13 = add %Int32 %12, 1
	%14 = getelementptr %Word8, [0 x %Word8]* %data, %Int32 %13
	%15 = load %Word8, %Word8* %14
	%16 = zext %Word8 %15 to %Word32
	%17 = shl %Word32 %16, 16
	%18 = load %Int32, %Int32* %3
	%19 = add %Int32 %18, 2
	%20 = getelementptr %Word8, [0 x %Word8]* %data, %Int32 %19
	%21 = load %Word8, %Word8* %20
	%22 = zext %Word8 %21 to %Word32
	%23 = shl %Word32 %22, 8
	%24 = load %Int32, %Int32* %3
	%25 = add %Int32 %24, 3
	%26 = getelementptr %Word8, [0 x %Word8]* %data, %Int32 %25
	%27 = load %Word8, %Word8* %26
	%28 = zext %Word8 %27 to %Word32
	%29 = shl %Word32 %28, 0
	%30 = or %Word32 %23, %29
	%31 = or %Word32 %17, %30
	%32 = or %Word32 %11, %31
	%33 = load %Int32, %Int32* %2
	%34 = getelementptr %Word32, [64 x %Word32]* %1, %Int32 %33
	store %Word32 %32, %Word32* %34
	%35 = load %Int32, %Int32* %3
	%36 = add %Int32 %35, 4
	store %Int32 %36, %Int32* %3
	%37 = load %Int32, %Int32* %2
	%38 = add %Int32 %37, 1
	store %Int32 %38, %Int32* %2
	br label %again_1
break_1:
	br label %again_2
again_2:
	%39 = load %Int32, %Int32* %2
	%40 = icmp ult %Int32 %39, 64
	br %Bool %40 , label %body_2, label %break_2
body_2:
	%41 = load %Int32, %Int32* %2
	%42 = getelementptr %Word32, [64 x %Word32]* %1, %Int32 %41
	%43 = load %Int32, %Int32* %2
	%44 = sub %Int32 %43, 2
	%45 = getelementptr %Word32, [64 x %Word32]* %1, %Int32 %44
	%46 = load %Word32, %Word32* %45
	%47 = call %Word32 @sig1(%Word32 %46)
	%48 = bitcast %Word32 %47 to %Int32
	%49 = load %Int32, %Int32* %2
	%50 = sub %Int32 %49, 7
	%51 = getelementptr %Word32, [64 x %Word32]* %1, %Int32 %50
	%52 = load %Word32, %Word32* %51
	%53 = bitcast %Word32 %52 to %Int32
	%54 = add %Int32 %48, %53
	%55 = load %Int32, %Int32* %2
	%56 = sub %Int32 %55, 15
	%57 = getelementptr %Word32, [64 x %Word32]* %1, %Int32 %56
	%58 = load %Word32, %Word32* %57
	%59 = call %Word32 @sig0(%Word32 %58)
	%60 = bitcast %Word32 %59 to %Int32
	%61 = add %Int32 %54, %60
	%62 = load %Int32, %Int32* %2
	%63 = sub %Int32 %62, 16
	%64 = getelementptr %Word32, [64 x %Word32]* %1, %Int32 %63
	%65 = load %Word32, %Word32* %64
	%66 = bitcast %Word32 %65 to %Int32
	%67 = add %Int32 %61, %66
	%68 = bitcast %Int32 %67 to %Word32
	store %Word32 %68, %Word32* %42
	%69 = load %Int32, %Int32* %2
	%70 = add %Int32 %69, 1
	store %Int32 %70, %Int32* %2
	br label %again_2
break_2:
	%71 = alloca [8 x %Word32], align 4
	%72 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%73 = load [8 x %Word32], [8 x %Word32]* %72
	store [8 x %Word32] %73, [8 x %Word32]* %71
	store %Int32 0, %Int32* %2
	br label %again_3
again_3:
	%74 = load %Int32, %Int32* %2
	%75 = icmp ult %Int32 %74, 64
	br %Bool %75 , label %body_3, label %break_3
body_3:
	%76 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 7
	%77 = load %Word32, %Word32* %76
	%78 = bitcast %Word32 %77 to %Int32
	%79 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 4
	%80 = load %Word32, %Word32* %79
	%81 = call %Word32 @ep1(%Word32 %80)
	%82 = bitcast %Word32 %81 to %Int32
	%83 = add %Int32 %78, %82
	%84 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 4
	%85 = load %Word32, %Word32* %84
	%86 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 5
	%87 = load %Word32, %Word32* %86
	%88 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 6
	%89 = load %Word32, %Word32* %88
	%90 = call %Word32 @ch(%Word32 %85, %Word32 %87, %Word32 %89)
	%91 = bitcast %Word32 %90 to %Int32
	%92 = add %Int32 %83, %91
	%93 = load %Int32, %Int32* %2
	%94 = getelementptr %Int32, [64 x %Int32]* @k, %Int32 %93
	%95 = load %Int32, %Int32* %94
	%96 = bitcast %Int32 %95 to %Int32
	%97 = add %Int32 %92, %96
	%98 = load %Int32, %Int32* %2
	%99 = getelementptr %Word32, [64 x %Word32]* %1, %Int32 %98
	%100 = load %Word32, %Word32* %99
	%101 = bitcast %Word32 %100 to %Int32
	%102 = add %Int32 %97, %101
	%103 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 0
	%104 = load %Word32, %Word32* %103
	%105 = call %Word32 @ep0(%Word32 %104)
	%106 = bitcast %Word32 %105 to %Int32
	%107 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 0
	%108 = load %Word32, %Word32* %107
	%109 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 1
	%110 = load %Word32, %Word32* %109
	%111 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 2
	%112 = load %Word32, %Word32* %111
	%113 = call %Word32 @maj(%Word32 %108, %Word32 %110, %Word32 %112)
	%114 = bitcast %Word32 %113 to %Int32
	%115 = add %Int32 %106, %114
	%116 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 7
	%117 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 6
	%118 = load %Word32, %Word32* %117
	store %Word32 %118, %Word32* %116
	%119 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 6
	%120 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 5
	%121 = load %Word32, %Word32* %120
	store %Word32 %121, %Word32* %119
	%122 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 5
	%123 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 4
	%124 = load %Word32, %Word32* %123
	store %Word32 %124, %Word32* %122
	%125 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 4
	%126 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 3
	%127 = load %Word32, %Word32* %126
	%128 = bitcast %Word32 %127 to %Int32
	%129 = add %Int32 %128, %102
	%130 = bitcast %Int32 %129 to %Word32
	store %Word32 %130, %Word32* %125
	%131 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 3
	%132 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 2
	%133 = load %Word32, %Word32* %132
	store %Word32 %133, %Word32* %131
	%134 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 2
	%135 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 1
	%136 = load %Word32, %Word32* %135
	store %Word32 %136, %Word32* %134
	%137 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 1
	%138 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 0
	%139 = load %Word32, %Word32* %138
	store %Word32 %139, %Word32* %137
	%140 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 0
	%141 = add %Int32 %102, %115
	%142 = bitcast %Int32 %141 to %Word32
	store %Word32 %142, %Word32* %140
	%143 = load %Int32, %Int32* %2
	%144 = add %Int32 %143, 1
	store %Int32 %144, %Int32* %2
	br label %again_3
break_3:
	store %Int32 0, %Int32* %2
	br label %again_4
again_4:
	%145 = load %Int32, %Int32* %2
	%146 = icmp ult %Int32 %145, 8
	br %Bool %146 , label %body_4, label %break_4
body_4:
	%147 = load %Int32, %Int32* %2
	%148 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%149 = getelementptr %Word32, [8 x %Word32]* %148, %Int32 %147
	%150 = load %Int32, %Int32* %2
	%151 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%152 = getelementptr %Word32, [8 x %Word32]* %151, %Int32 %150
	%153 = load %Word32, %Word32* %152
	%154 = bitcast %Word32 %153 to %Int32
	%155 = load %Int32, %Int32* %2
	%156 = getelementptr %Word32, [8 x %Word32]* %71, %Int32 %155
	%157 = load %Word32, %Word32* %156
	%158 = bitcast %Word32 %157 to %Int32
	%159 = add %Int32 %154, %158
	%160 = bitcast %Int32 %159 to %Word32
	store %Word32 %160, %Word32* %149
	%161 = load %Int32, %Int32* %2
	%162 = add %Int32 %161, 1
	store %Int32 %162, %Int32* %2
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
	%7 = getelementptr %Word8, [64 x %Word8]* %6, %Int32 %5
	%8 = load %Int32, %Int32* %1
	%9 = getelementptr %Word8, [0 x %Word8]* %msg, %Int32 %8
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
	;{'str': ' Pad whatever data is left in the buffer.'}
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
	%10 = getelementptr %Word8, [64 x %Word8]* %9, %Int32 %8
	store %Word8 128, %Word8* %10
	%11 = load %Int32, %Int32* %1
	%12 = add %Int32 %11, 1
	store %Int32 %12, %Int32* %1
	%13 = load %Int32, %Int32* %1
	%14 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%15 = getelementptr %Word8, [64 x %Word8]* %14, %Int32 %13
	%16 = bitcast %Word8* %15 to i8*
	%17 = load %Int32, %Int32* %4
	%18 = load %Int32, %Int32* %1
	%19 = sub %Int32 %17, %18
	%20 = zext %Int32 %19 to %SizeT
	%21 = call i8* @memset(i8* %16, %Int 0, %SizeT %20)
	;{'str': 'ctx.data[i:n-i] = []'}
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
	;{'str': 'ctx.data[0:56] = []'}
	br label %endif_1
endif_1:
	;{'str': " Append to the padding the total message's length in bits and transform."}
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
	%39 = getelementptr %Word8, [64 x %Word8]* %38, %Int32 63
	%40 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%41 = load %Int64, %Int64* %40
	%42 = bitcast %Int64 %41 to %Word64
	%43 = lshr %Word64 %42, 0
	%44 = trunc %Word64 %43 to %Word8
	store %Word8 %44, %Word8* %39
	%45 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%46 = getelementptr %Word8, [64 x %Word8]* %45, %Int32 62
	%47 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%48 = load %Int64, %Int64* %47
	%49 = bitcast %Int64 %48 to %Word64
	%50 = lshr %Word64 %49, 8
	%51 = trunc %Word64 %50 to %Word8
	store %Word8 %51, %Word8* %46
	%52 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%53 = getelementptr %Word8, [64 x %Word8]* %52, %Int32 61
	%54 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%55 = load %Int64, %Int64* %54
	%56 = bitcast %Int64 %55 to %Word64
	%57 = lshr %Word64 %56, 16
	%58 = trunc %Word64 %57 to %Word8
	store %Word8 %58, %Word8* %53
	%59 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%60 = getelementptr %Word8, [64 x %Word8]* %59, %Int32 60
	%61 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%62 = load %Int64, %Int64* %61
	%63 = bitcast %Int64 %62 to %Word64
	%64 = lshr %Word64 %63, 24
	%65 = trunc %Word64 %64 to %Word8
	store %Word8 %65, %Word8* %60
	%66 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%67 = getelementptr %Word8, [64 x %Word8]* %66, %Int32 59
	%68 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%69 = load %Int64, %Int64* %68
	%70 = bitcast %Int64 %69 to %Word64
	%71 = lshr %Word64 %70, 32
	%72 = trunc %Word64 %71 to %Word8
	store %Word8 %72, %Word8* %67
	%73 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%74 = getelementptr %Word8, [64 x %Word8]* %73, %Int32 58
	%75 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%76 = load %Int64, %Int64* %75
	%77 = bitcast %Int64 %76 to %Word64
	%78 = lshr %Word64 %77, 40
	%79 = trunc %Word64 %78 to %Word8
	store %Word8 %79, %Word8* %74
	%80 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%81 = getelementptr %Word8, [64 x %Word8]* %80, %Int32 57
	%82 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%83 = load %Int64, %Int64* %82
	%84 = bitcast %Int64 %83 to %Word64
	%85 = lshr %Word64 %84, 48
	%86 = trunc %Word64 %85 to %Word8
	store %Word8 %86, %Word8* %81
	%87 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%88 = getelementptr %Word8, [64 x %Word8]* %87, %Int32 56
	%89 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 2
	%90 = load %Int64, %Int64* %89
	%91 = bitcast %Int64 %90 to %Word64
	%92 = lshr %Word64 %91, 56
	%93 = trunc %Word64 %92 to %Word8
	store %Word8 %93, %Word8* %88
	%94 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 0
	%95 = bitcast [64 x %Word8]* %94 to [0 x %Word8]*
	call void @transform(%Context* %ctx, [0 x %Word8]* %95)
	;{'str': ' Since this implementation uses little endian byte ordering'}
	;{'str': ' and SHA uses big endian, reverse all the bytes'}
	;{'str': ' when copying the final state to the output hash.'}
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
	%103 = getelementptr %Word8, %sha256_Hash* %outHash, %Int32 %102
	%104 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%105 = getelementptr %Word32, [8 x %Word32]* %104, %Int32 0
	%106 = load %Word32, %Word32* %105
	%107 = bitcast %Int32 %100 to %Word32
	%108 = lshr %Word32 %106, %107
	%109 = trunc %Word32 %108 to %Word8
	store %Word8 %109, %Word8* %103
	%110 = load %Int32, %Int32* %1
	%111 = add %Int32 %110, 4
	%112 = getelementptr %Word8, %sha256_Hash* %outHash, %Int32 %111
	%113 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%114 = getelementptr %Word32, [8 x %Word32]* %113, %Int32 1
	%115 = load %Word32, %Word32* %114
	%116 = bitcast %Int32 %100 to %Word32
	%117 = lshr %Word32 %115, %116
	%118 = trunc %Word32 %117 to %Word8
	store %Word8 %118, %Word8* %112
	%119 = load %Int32, %Int32* %1
	%120 = add %Int32 %119, 8
	%121 = getelementptr %Word8, %sha256_Hash* %outHash, %Int32 %120
	%122 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%123 = getelementptr %Word32, [8 x %Word32]* %122, %Int32 2
	%124 = load %Word32, %Word32* %123
	%125 = bitcast %Int32 %100 to %Word32
	%126 = lshr %Word32 %124, %125
	%127 = trunc %Word32 %126 to %Word8
	store %Word8 %127, %Word8* %121
	%128 = load %Int32, %Int32* %1
	%129 = add %Int32 %128, 12
	%130 = getelementptr %Word8, %sha256_Hash* %outHash, %Int32 %129
	%131 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%132 = getelementptr %Word32, [8 x %Word32]* %131, %Int32 3
	%133 = load %Word32, %Word32* %132
	%134 = bitcast %Int32 %100 to %Word32
	%135 = lshr %Word32 %133, %134
	%136 = trunc %Word32 %135 to %Word8
	store %Word8 %136, %Word8* %130
	%137 = load %Int32, %Int32* %1
	%138 = add %Int32 %137, 16
	%139 = getelementptr %Word8, %sha256_Hash* %outHash, %Int32 %138
	%140 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%141 = getelementptr %Word32, [8 x %Word32]* %140, %Int32 4
	%142 = load %Word32, %Word32* %141
	%143 = bitcast %Int32 %100 to %Word32
	%144 = lshr %Word32 %142, %143
	%145 = trunc %Word32 %144 to %Word8
	store %Word8 %145, %Word8* %139
	%146 = load %Int32, %Int32* %1
	%147 = add %Int32 %146, 20
	%148 = getelementptr %Word8, %sha256_Hash* %outHash, %Int32 %147
	%149 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%150 = getelementptr %Word32, [8 x %Word32]* %149, %Int32 5
	%151 = load %Word32, %Word32* %150
	%152 = bitcast %Int32 %100 to %Word32
	%153 = lshr %Word32 %151, %152
	%154 = trunc %Word32 %153 to %Word8
	store %Word8 %154, %Word8* %148
	%155 = load %Int32, %Int32* %1
	%156 = add %Int32 %155, 24
	%157 = getelementptr %Word8, %sha256_Hash* %outHash, %Int32 %156
	%158 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%159 = getelementptr %Word32, [8 x %Word32]* %158, %Int32 6
	%160 = load %Word32, %Word32* %159
	%161 = bitcast %Int32 %100 to %Word32
	%162 = lshr %Word32 %160, %161
	%163 = trunc %Word32 %162 to %Word8
	store %Word8 %163, %Word8* %157
	%164 = load %Int32, %Int32* %1
	%165 = add %Int32 %164, 28
	%166 = getelementptr %Word8, %sha256_Hash* %outHash, %Int32 %165
	%167 = getelementptr %Context, %Context* %ctx, %Int32 0, %Int32 3
	%168 = getelementptr %Word32, [8 x %Word32]* %167, %Int32 7
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
	%1 = alloca %Context, align 8
	store %Context zeroinitializer, %Context* %1
	call void @contextInit(%Context* %1)
	call void @update(%Context* %1, [0 x %Word8]* %msg, %Int32 %msgLen)
	call void @final(%Context* %1, %sha256_Hash* %outHash)
	ret void
}


