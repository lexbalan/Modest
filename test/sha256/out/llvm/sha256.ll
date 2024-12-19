
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
	%1 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	; -- start vol eval --
	%2 = zext i4 8 to %Int32
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
	%2 = insertvalue [64 x %Word32] zeroinitializer, %Word32 0, 0
	%3 = insertvalue [64 x %Word32] %2, %Word32 0, 1
	%4 = insertvalue [64 x %Word32] %3, %Word32 0, 2
	%5 = insertvalue [64 x %Word32] %4, %Word32 0, 3
	%6 = insertvalue [64 x %Word32] %5, %Word32 0, 4
	%7 = insertvalue [64 x %Word32] %6, %Word32 0, 5
	%8 = insertvalue [64 x %Word32] %7, %Word32 0, 6
	%9 = insertvalue [64 x %Word32] %8, %Word32 0, 7
	%10 = insertvalue [64 x %Word32] %9, %Word32 0, 8
	%11 = insertvalue [64 x %Word32] %10, %Word32 0, 9
	%12 = insertvalue [64 x %Word32] %11, %Word32 0, 10
	%13 = insertvalue [64 x %Word32] %12, %Word32 0, 11
	%14 = insertvalue [64 x %Word32] %13, %Word32 0, 12
	%15 = insertvalue [64 x %Word32] %14, %Word32 0, 13
	%16 = insertvalue [64 x %Word32] %15, %Word32 0, 14
	%17 = insertvalue [64 x %Word32] %16, %Word32 0, 15
	%18 = insertvalue [64 x %Word32] %17, %Word32 0, 16
	%19 = insertvalue [64 x %Word32] %18, %Word32 0, 17
	%20 = insertvalue [64 x %Word32] %19, %Word32 0, 18
	%21 = insertvalue [64 x %Word32] %20, %Word32 0, 19
	%22 = insertvalue [64 x %Word32] %21, %Word32 0, 20
	%23 = insertvalue [64 x %Word32] %22, %Word32 0, 21
	%24 = insertvalue [64 x %Word32] %23, %Word32 0, 22
	%25 = insertvalue [64 x %Word32] %24, %Word32 0, 23
	%26 = insertvalue [64 x %Word32] %25, %Word32 0, 24
	%27 = insertvalue [64 x %Word32] %26, %Word32 0, 25
	%28 = insertvalue [64 x %Word32] %27, %Word32 0, 26
	%29 = insertvalue [64 x %Word32] %28, %Word32 0, 27
	%30 = insertvalue [64 x %Word32] %29, %Word32 0, 28
	%31 = insertvalue [64 x %Word32] %30, %Word32 0, 29
	%32 = insertvalue [64 x %Word32] %31, %Word32 0, 30
	%33 = insertvalue [64 x %Word32] %32, %Word32 0, 31
	%34 = insertvalue [64 x %Word32] %33, %Word32 0, 32
	%35 = insertvalue [64 x %Word32] %34, %Word32 0, 33
	%36 = insertvalue [64 x %Word32] %35, %Word32 0, 34
	%37 = insertvalue [64 x %Word32] %36, %Word32 0, 35
	%38 = insertvalue [64 x %Word32] %37, %Word32 0, 36
	%39 = insertvalue [64 x %Word32] %38, %Word32 0, 37
	%40 = insertvalue [64 x %Word32] %39, %Word32 0, 38
	%41 = insertvalue [64 x %Word32] %40, %Word32 0, 39
	%42 = insertvalue [64 x %Word32] %41, %Word32 0, 40
	%43 = insertvalue [64 x %Word32] %42, %Word32 0, 41
	%44 = insertvalue [64 x %Word32] %43, %Word32 0, 42
	%45 = insertvalue [64 x %Word32] %44, %Word32 0, 43
	%46 = insertvalue [64 x %Word32] %45, %Word32 0, 44
	%47 = insertvalue [64 x %Word32] %46, %Word32 0, 45
	%48 = insertvalue [64 x %Word32] %47, %Word32 0, 46
	%49 = insertvalue [64 x %Word32] %48, %Word32 0, 47
	%50 = insertvalue [64 x %Word32] %49, %Word32 0, 48
	%51 = insertvalue [64 x %Word32] %50, %Word32 0, 49
	%52 = insertvalue [64 x %Word32] %51, %Word32 0, 50
	%53 = insertvalue [64 x %Word32] %52, %Word32 0, 51
	%54 = insertvalue [64 x %Word32] %53, %Word32 0, 52
	%55 = insertvalue [64 x %Word32] %54, %Word32 0, 53
	%56 = insertvalue [64 x %Word32] %55, %Word32 0, 54
	%57 = insertvalue [64 x %Word32] %56, %Word32 0, 55
	%58 = insertvalue [64 x %Word32] %57, %Word32 0, 56
	%59 = insertvalue [64 x %Word32] %58, %Word32 0, 57
	%60 = insertvalue [64 x %Word32] %59, %Word32 0, 58
	%61 = insertvalue [64 x %Word32] %60, %Word32 0, 59
	%62 = insertvalue [64 x %Word32] %61, %Word32 0, 60
	%63 = insertvalue [64 x %Word32] %62, %Word32 0, 61
	%64 = insertvalue [64 x %Word32] %63, %Word32 0, 62
	%65 = insertvalue [64 x %Word32] %64, %Word32 0, 63
	store [64 x %Word32] %65, [64 x %Word32]* %1
	%66 = alloca %Int32, align 4
	store %Int32 0, %Int32* %66
	%67 = alloca %Int32, align 4
	store %Int32 0, %Int32* %67
	br label %again_1
again_1:
	%68 = load %Int32, %Int32* %66
	%69 = icmp ult %Int32 %68, 16
	br %Bool %69 , label %body_1, label %break_1
body_1:
	%70 = load %Int32, %Int32* %67
	%71 = add %Int32 %70, 0
	%72 = getelementptr inbounds [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %71
	%73 = load %Word8, %Word8* %72
	%74 = zext %Word8 %73 to %Word32
	%75 = shl %Word32 %74, 24
	%76 = load %Int32, %Int32* %67
	%77 = add %Int32 %76, 1
	%78 = getelementptr inbounds [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %77
	%79 = load %Word8, %Word8* %78
	%80 = zext %Word8 %79 to %Word32
	%81 = shl %Word32 %80, 16
	%82 = load %Int32, %Int32* %67
	%83 = add %Int32 %82, 2
	%84 = getelementptr inbounds [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %83
	%85 = load %Word8, %Word8* %84
	%86 = zext %Word8 %85 to %Word32
	%87 = shl %Word32 %86, 8
	%88 = load %Int32, %Int32* %67
	%89 = add %Int32 %88, 3
	%90 = getelementptr inbounds [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Int32 %89
	%91 = load %Word8, %Word8* %90
	%92 = zext %Word8 %91 to %Word32
	%93 = shl %Word32 %92, 0
	%94 = or %Word32 %87, %93
	%95 = or %Word32 %81, %94
	%96 = or %Word32 %75, %95
	%97 = load %Int32, %Int32* %66
	%98 = getelementptr inbounds [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %97
	store %Word32 %96, %Word32* %98
	%99 = load %Int32, %Int32* %67
	%100 = add %Int32 %99, 4
	store %Int32 %100, %Int32* %67
	%101 = load %Int32, %Int32* %66
	%102 = add %Int32 %101, 1
	store %Int32 %102, %Int32* %66
	br label %again_1
break_1:
	br label %again_2
again_2:
	%103 = load %Int32, %Int32* %66
	%104 = icmp ult %Int32 %103, 64
	br %Bool %104 , label %body_2, label %break_2
body_2:
	%105 = load %Int32, %Int32* %66
	%106 = getelementptr inbounds [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %105
	%107 = load %Int32, %Int32* %66
	%108 = sub %Int32 %107, 2
	%109 = getelementptr inbounds [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %108
	%110 = load %Word32, %Word32* %109
	%111 = call %Word32 @sig1(%Word32 %110)
	%112 = bitcast %Word32 %111 to %Int32
	%113 = load %Int32, %Int32* %66
	%114 = sub %Int32 %113, 7
	%115 = getelementptr inbounds [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %114
	%116 = load %Word32, %Word32* %115
	%117 = bitcast %Word32 %116 to %Int32
	%118 = add %Int32 %112, %117
	%119 = load %Int32, %Int32* %66
	%120 = sub %Int32 %119, 15
	%121 = getelementptr inbounds [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %120
	%122 = load %Word32, %Word32* %121
	%123 = call %Word32 @sig0(%Word32 %122)
	%124 = bitcast %Word32 %123 to %Int32
	%125 = add %Int32 %118, %124
	%126 = load %Int32, %Int32* %66
	%127 = sub %Int32 %126, 16
	%128 = getelementptr inbounds [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %127
	%129 = load %Word32, %Word32* %128
	%130 = bitcast %Word32 %129 to %Int32
	%131 = add %Int32 %125, %130
	%132 = bitcast %Int32 %131 to %Word32
	store %Word32 %132, %Word32* %106
	%133 = load %Int32, %Int32* %66
	%134 = add %Int32 %133, 1
	store %Int32 %134, %Int32* %66
	br label %again_2
break_2:
	%135 = alloca [8 x %Word32], align 4
	%136 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%137 = load [8 x %Word32], [8 x %Word32]* %136
	store [8 x %Word32] %137, [8 x %Word32]* %135
	store %Int32 0, %Int32* %66
	br label %again_3
again_3:
	%138 = load %Int32, %Int32* %66
	%139 = icmp ult %Int32 %138, 64
	br %Bool %139 , label %body_3, label %break_3
body_3:
	%140 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 7
	%141 = load %Word32, %Word32* %140
	%142 = bitcast %Word32 %141 to %Int32
	%143 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 4
	%144 = load %Word32, %Word32* %143
	%145 = call %Word32 @ep1(%Word32 %144)
	%146 = bitcast %Word32 %145 to %Int32
	%147 = add %Int32 %142, %146
	%148 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 4
	%149 = load %Word32, %Word32* %148
	%150 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 5
	%151 = load %Word32, %Word32* %150
	%152 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 6
	%153 = load %Word32, %Word32* %152
	%154 = call %Word32 @ch(%Word32 %149, %Word32 %151, %Word32 %153)
	%155 = bitcast %Word32 %154 to %Int32
	%156 = add %Int32 %147, %155
	%157 = load %Int32, %Int32* %66
	%158 = getelementptr inbounds [64 x %Int32], [64 x %Int32]* @k, %Int32 0, %Int32 %157
	%159 = load %Int32, %Int32* %158
	%160 = bitcast %Int32 %159 to %Int32
	%161 = add %Int32 %156, %160
	%162 = load %Int32, %Int32* %66
	%163 = getelementptr inbounds [64 x %Word32], [64 x %Word32]* %1, %Int32 0, %Int32 %162
	%164 = load %Word32, %Word32* %163
	%165 = bitcast %Word32 %164 to %Int32
	%166 = add %Int32 %161, %165
	%167 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 0
	%168 = load %Word32, %Word32* %167
	%169 = call %Word32 @ep0(%Word32 %168)
	%170 = bitcast %Word32 %169 to %Int32
	%171 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 0
	%172 = load %Word32, %Word32* %171
	%173 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 1
	%174 = load %Word32, %Word32* %173
	%175 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 2
	%176 = load %Word32, %Word32* %175
	%177 = call %Word32 @maj(%Word32 %172, %Word32 %174, %Word32 %176)
	%178 = bitcast %Word32 %177 to %Int32
	%179 = add %Int32 %170, %178
	%180 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 7
	%181 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 6
	%182 = load %Word32, %Word32* %181
	store %Word32 %182, %Word32* %180
	%183 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 6
	%184 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 5
	%185 = load %Word32, %Word32* %184
	store %Word32 %185, %Word32* %183
	%186 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 5
	%187 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 4
	%188 = load %Word32, %Word32* %187
	store %Word32 %188, %Word32* %186
	%189 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 4
	%190 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 3
	%191 = load %Word32, %Word32* %190
	%192 = bitcast %Word32 %191 to %Int32
	%193 = add %Int32 %192, %166
	%194 = bitcast %Int32 %193 to %Word32
	store %Word32 %194, %Word32* %189
	%195 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 3
	%196 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 2
	%197 = load %Word32, %Word32* %196
	store %Word32 %197, %Word32* %195
	%198 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 2
	%199 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 1
	%200 = load %Word32, %Word32* %199
	store %Word32 %200, %Word32* %198
	%201 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 1
	%202 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 0
	%203 = load %Word32, %Word32* %202
	store %Word32 %203, %Word32* %201
	%204 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 0
	%205 = add %Int32 %166, %179
	%206 = bitcast %Int32 %205 to %Word32
	store %Word32 %206, %Word32* %204
	%207 = load %Int32, %Int32* %66
	%208 = add %Int32 %207, 1
	store %Int32 %208, %Int32* %66
	br label %again_3
break_3:
	store %Int32 0, %Int32* %66
	br label %again_4
again_4:
	%209 = load %Int32, %Int32* %66
	%210 = icmp ult %Int32 %209, 8
	br %Bool %210 , label %body_4, label %break_4
body_4:
	%211 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%212 = load %Int32, %Int32* %66
	%213 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %211, %Int32 0, %Int32 %212
	%214 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%215 = load %Int32, %Int32* %66
	%216 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %214, %Int32 0, %Int32 %215
	%217 = load %Word32, %Word32* %216
	%218 = bitcast %Word32 %217 to %Int32
	%219 = load %Int32, %Int32* %66
	%220 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %135, %Int32 0, %Int32 %219
	%221 = load %Word32, %Word32* %220
	%222 = bitcast %Word32 %221 to %Int32
	%223 = add %Int32 %218, %222
	%224 = bitcast %Int32 %223 to %Word32
	store %Word32 %224, %Word32* %213
	%225 = load %Int32, %Int32* %66
	%226 = add %Int32 %225, 1
	store %Int32 %226, %Int32* %66
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
	%4 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%5 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 1
	%6 = load %Int32, %Int32* %5
	%7 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %4, %Int32 0, %Int32 %6
	%8 = load %Int32, %Int32* %1
	%9 = getelementptr inbounds [0 x %Word8], [0 x %Word8]* %msg, %Int32 0, %Int32 %8
	%10 = load %Word8, %Word8* %9
	store %Word8 %10, %Word8* %7
	%11 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 1
	%12 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 1
	%13 = load %Int32, %Int32* %12
	%14 = add %Int32 %13, 1
	store %Int32 %14, %Int32* %11
	%15 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 1
	%16 = load %Int32, %Int32* %15
	%17 = icmp eq %Int32 %16, 64
	br %Bool %17 , label %then_0, label %endif_0
then_0:
	%18 = bitcast %Context* %ctx to %Context*
	%19 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%20 = bitcast [64 x %Word8]* %19 to [0 x %Word8]*
	call void @transform(%Context* %18, [0 x %Word8]* %20)
	%21 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%22 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%23 = load %Int64, %Int64* %22
	%24 = add %Int64 %23, 512
	store %Int64 %24, %Int64* %21
	%25 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 1
	store %Int32 0, %Int32* %25
	br label %endif_0
endif_0:
	%26 = load %Int32, %Int32* %1
	%27 = add %Int32 %26, 1
	store %Int32 %27, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define internal void @final(%Context* %ctx, %sha256_Hash* %outHash) {
	%1 = alloca %Int32, align 4
	%2 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 1
	%3 = load %Int32, %Int32* %2
	store %Int32 %3, %Int32* %1
	; Pad whatever data is left in the buffer.
	%4 = alloca %Int32, align 4
	store %Int32 64, %Int32* %4
	%5 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 1
	%6 = load %Int32, %Int32* %5
	%7 = icmp ult %Int32 %6, 56
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	store %Int32 56, %Int32* %4
	br label %endif_0
endif_0:
	%8 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%9 = load %Int32, %Int32* %1
	%10 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %8, %Int32 0, %Int32 %9
	store %Word8 128, %Word8* %10
	%11 = load %Int32, %Int32* %1
	%12 = add %Int32 %11, 1
	store %Int32 %12, %Int32* %1
	%13 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%14 = load %Int32, %Int32* %1
	%15 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %13, %Int32 0, %Int32 %14
	%16 = bitcast %Word8* %15 to i8*
	%17 = load %Int32, %Int32* %4
	%18 = load %Int32, %Int32* %1
	%19 = sub %Int32 %17, %18
	%20 = zext %Int32 %19 to %SizeT
	%21 = call i8* @memset(i8* %16, %Int 0, %SizeT %20)
	;ctx.data[i:n-i] = []
	%22 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 1
	%23 = load %Int32, %Int32* %22
	%24 = icmp uge %Int32 %23, 56
	br %Bool %24 , label %then_1, label %endif_1
then_1:
	%25 = bitcast %Context* %ctx to %Context*
	%26 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%27 = bitcast [64 x %Word8]* %26 to [0 x %Word8]*
	call void @transform(%Context* %25, [0 x %Word8]* %27)
	%28 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%29 = bitcast [64 x %Word8]* %28 to i8*
	%30 = call i8* @memset(i8* %29, %Int 0, %SizeT 56)
	;ctx.data[0:56] = []
	br label %endif_1
endif_1:
	; Append to the padding the total message's length in bits and transform.
	%31 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%32 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%33 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 1
	%34 = load %Int32, %Int32* %33
	%35 = zext %Int32 %34 to %Int64
	%36 = mul %Int64 %35, 8
	%37 = load %Int64, %Int64* %32
	%38 = add %Int64 %37, %36
	store %Int64 %38, %Int64* %31
	%39 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%40 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %39, %Int32 0, %Int32 63
	%41 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%42 = load %Int64, %Int64* %41
	%43 = bitcast %Int64 %42 to %Word64
	%44 = lshr %Word64 %43, 0
	%45 = trunc %Word64 %44 to %Word8
	store %Word8 %45, %Word8* %40
	%46 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%47 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %46, %Int32 0, %Int32 62
	%48 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%49 = load %Int64, %Int64* %48
	%50 = bitcast %Int64 %49 to %Word64
	%51 = lshr %Word64 %50, 8
	%52 = trunc %Word64 %51 to %Word8
	store %Word8 %52, %Word8* %47
	%53 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%54 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %53, %Int32 0, %Int32 61
	%55 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%56 = load %Int64, %Int64* %55
	%57 = bitcast %Int64 %56 to %Word64
	%58 = lshr %Word64 %57, 16
	%59 = trunc %Word64 %58 to %Word8
	store %Word8 %59, %Word8* %54
	%60 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%61 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %60, %Int32 0, %Int32 60
	%62 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%63 = load %Int64, %Int64* %62
	%64 = bitcast %Int64 %63 to %Word64
	%65 = lshr %Word64 %64, 24
	%66 = trunc %Word64 %65 to %Word8
	store %Word8 %66, %Word8* %61
	%67 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%68 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %67, %Int32 0, %Int32 59
	%69 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%70 = load %Int64, %Int64* %69
	%71 = bitcast %Int64 %70 to %Word64
	%72 = lshr %Word64 %71, 32
	%73 = trunc %Word64 %72 to %Word8
	store %Word8 %73, %Word8* %68
	%74 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%75 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %74, %Int32 0, %Int32 58
	%76 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%77 = load %Int64, %Int64* %76
	%78 = bitcast %Int64 %77 to %Word64
	%79 = lshr %Word64 %78, 40
	%80 = trunc %Word64 %79 to %Word8
	store %Word8 %80, %Word8* %75
	%81 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%82 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %81, %Int32 0, %Int32 57
	%83 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%84 = load %Int64, %Int64* %83
	%85 = bitcast %Int64 %84 to %Word64
	%86 = lshr %Word64 %85, 48
	%87 = trunc %Word64 %86 to %Word8
	store %Word8 %87, %Word8* %82
	%88 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%89 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %88, %Int32 0, %Int32 56
	%90 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%91 = load %Int64, %Int64* %90
	%92 = bitcast %Int64 %91 to %Word64
	%93 = lshr %Word64 %92, 56
	%94 = trunc %Word64 %93 to %Word8
	store %Word8 %94, %Word8* %89
	%95 = bitcast %Context* %ctx to %Context*
	%96 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%97 = bitcast [64 x %Word8]* %96 to [0 x %Word8]*
	call void @transform(%Context* %95, [0 x %Word8]* %97)
	; Since this implementation uses little endian byte ordering
	; and SHA uses big endian, reverse all the bytes
	; when copying the final state to the output hash.
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%98 = load %Int32, %Int32* %1
	%99 = icmp ult %Int32 %98, 4
	br %Bool %99 , label %body_1, label %break_1
body_1:
	%100 = load %Int32, %Int32* %1
	%101 = mul %Int32 %100, 8
	%102 = sub %Int32 24, %101
	%103 = load %Int32, %Int32* %1
	%104 = add %Int32 %103, 0
	%105 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %104
	%106 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%107 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %106, %Int32 0, %Int32 0
	%108 = load %Word32, %Word32* %107
	%109 = bitcast %Int32 %102 to %Word32
	%110 = lshr %Word32 %108, %109
	%111 = trunc %Word32 %110 to %Word8
	store %Word8 %111, %Word8* %105
	%112 = load %Int32, %Int32* %1
	%113 = add %Int32 %112, 4
	%114 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %113
	%115 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%116 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %115, %Int32 0, %Int32 1
	%117 = load %Word32, %Word32* %116
	%118 = bitcast %Int32 %102 to %Word32
	%119 = lshr %Word32 %117, %118
	%120 = trunc %Word32 %119 to %Word8
	store %Word8 %120, %Word8* %114
	%121 = load %Int32, %Int32* %1
	%122 = add %Int32 %121, 8
	%123 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %122
	%124 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%125 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %124, %Int32 0, %Int32 2
	%126 = load %Word32, %Word32* %125
	%127 = bitcast %Int32 %102 to %Word32
	%128 = lshr %Word32 %126, %127
	%129 = trunc %Word32 %128 to %Word8
	store %Word8 %129, %Word8* %123
	%130 = load %Int32, %Int32* %1
	%131 = add %Int32 %130, 12
	%132 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %131
	%133 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%134 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %133, %Int32 0, %Int32 3
	%135 = load %Word32, %Word32* %134
	%136 = bitcast %Int32 %102 to %Word32
	%137 = lshr %Word32 %135, %136
	%138 = trunc %Word32 %137 to %Word8
	store %Word8 %138, %Word8* %132
	%139 = load %Int32, %Int32* %1
	%140 = add %Int32 %139, 16
	%141 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %140
	%142 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%143 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %142, %Int32 0, %Int32 4
	%144 = load %Word32, %Word32* %143
	%145 = bitcast %Int32 %102 to %Word32
	%146 = lshr %Word32 %144, %145
	%147 = trunc %Word32 %146 to %Word8
	store %Word8 %147, %Word8* %141
	%148 = load %Int32, %Int32* %1
	%149 = add %Int32 %148, 20
	%150 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %149
	%151 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%152 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %151, %Int32 0, %Int32 5
	%153 = load %Word32, %Word32* %152
	%154 = bitcast %Int32 %102 to %Word32
	%155 = lshr %Word32 %153, %154
	%156 = trunc %Word32 %155 to %Word8
	store %Word8 %156, %Word8* %150
	%157 = load %Int32, %Int32* %1
	%158 = add %Int32 %157, 24
	%159 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %158
	%160 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%161 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %160, %Int32 0, %Int32 6
	%162 = load %Word32, %Word32* %161
	%163 = bitcast %Int32 %102 to %Word32
	%164 = lshr %Word32 %162, %163
	%165 = trunc %Word32 %164 to %Word8
	store %Word8 %165, %Word8* %159
	%166 = load %Int32, %Int32* %1
	%167 = add %Int32 %166, 28
	%168 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %167
	%169 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%170 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %169, %Int32 0, %Int32 7
	%171 = load %Word32, %Word32* %170
	%172 = bitcast %Int32 %102 to %Word32
	%173 = lshr %Word32 %171, %172
	%174 = trunc %Word32 %173 to %Word8
	store %Word8 %174, %Word8* %168
	%175 = load %Int32, %Int32* %1
	%176 = add %Int32 %175, 1
	store %Int32 %176, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define void @sha256_hash([0 x %Word8]* %msg, %Int32 %msgLen, %sha256_Hash* %outHash) {
	%1 = alloca %Context, align 8
	%2 = insertvalue [64 x %Word8] zeroinitializer, %Word8 0, 0
	%3 = insertvalue [64 x %Word8] %2, %Word8 0, 1
	%4 = insertvalue [64 x %Word8] %3, %Word8 0, 2
	%5 = insertvalue [64 x %Word8] %4, %Word8 0, 3
	%6 = insertvalue [64 x %Word8] %5, %Word8 0, 4
	%7 = insertvalue [64 x %Word8] %6, %Word8 0, 5
	%8 = insertvalue [64 x %Word8] %7, %Word8 0, 6
	%9 = insertvalue [64 x %Word8] %8, %Word8 0, 7
	%10 = insertvalue [64 x %Word8] %9, %Word8 0, 8
	%11 = insertvalue [64 x %Word8] %10, %Word8 0, 9
	%12 = insertvalue [64 x %Word8] %11, %Word8 0, 10
	%13 = insertvalue [64 x %Word8] %12, %Word8 0, 11
	%14 = insertvalue [64 x %Word8] %13, %Word8 0, 12
	%15 = insertvalue [64 x %Word8] %14, %Word8 0, 13
	%16 = insertvalue [64 x %Word8] %15, %Word8 0, 14
	%17 = insertvalue [64 x %Word8] %16, %Word8 0, 15
	%18 = insertvalue [64 x %Word8] %17, %Word8 0, 16
	%19 = insertvalue [64 x %Word8] %18, %Word8 0, 17
	%20 = insertvalue [64 x %Word8] %19, %Word8 0, 18
	%21 = insertvalue [64 x %Word8] %20, %Word8 0, 19
	%22 = insertvalue [64 x %Word8] %21, %Word8 0, 20
	%23 = insertvalue [64 x %Word8] %22, %Word8 0, 21
	%24 = insertvalue [64 x %Word8] %23, %Word8 0, 22
	%25 = insertvalue [64 x %Word8] %24, %Word8 0, 23
	%26 = insertvalue [64 x %Word8] %25, %Word8 0, 24
	%27 = insertvalue [64 x %Word8] %26, %Word8 0, 25
	%28 = insertvalue [64 x %Word8] %27, %Word8 0, 26
	%29 = insertvalue [64 x %Word8] %28, %Word8 0, 27
	%30 = insertvalue [64 x %Word8] %29, %Word8 0, 28
	%31 = insertvalue [64 x %Word8] %30, %Word8 0, 29
	%32 = insertvalue [64 x %Word8] %31, %Word8 0, 30
	%33 = insertvalue [64 x %Word8] %32, %Word8 0, 31
	%34 = insertvalue [64 x %Word8] %33, %Word8 0, 32
	%35 = insertvalue [64 x %Word8] %34, %Word8 0, 33
	%36 = insertvalue [64 x %Word8] %35, %Word8 0, 34
	%37 = insertvalue [64 x %Word8] %36, %Word8 0, 35
	%38 = insertvalue [64 x %Word8] %37, %Word8 0, 36
	%39 = insertvalue [64 x %Word8] %38, %Word8 0, 37
	%40 = insertvalue [64 x %Word8] %39, %Word8 0, 38
	%41 = insertvalue [64 x %Word8] %40, %Word8 0, 39
	%42 = insertvalue [64 x %Word8] %41, %Word8 0, 40
	%43 = insertvalue [64 x %Word8] %42, %Word8 0, 41
	%44 = insertvalue [64 x %Word8] %43, %Word8 0, 42
	%45 = insertvalue [64 x %Word8] %44, %Word8 0, 43
	%46 = insertvalue [64 x %Word8] %45, %Word8 0, 44
	%47 = insertvalue [64 x %Word8] %46, %Word8 0, 45
	%48 = insertvalue [64 x %Word8] %47, %Word8 0, 46
	%49 = insertvalue [64 x %Word8] %48, %Word8 0, 47
	%50 = insertvalue [64 x %Word8] %49, %Word8 0, 48
	%51 = insertvalue [64 x %Word8] %50, %Word8 0, 49
	%52 = insertvalue [64 x %Word8] %51, %Word8 0, 50
	%53 = insertvalue [64 x %Word8] %52, %Word8 0, 51
	%54 = insertvalue [64 x %Word8] %53, %Word8 0, 52
	%55 = insertvalue [64 x %Word8] %54, %Word8 0, 53
	%56 = insertvalue [64 x %Word8] %55, %Word8 0, 54
	%57 = insertvalue [64 x %Word8] %56, %Word8 0, 55
	%58 = insertvalue [64 x %Word8] %57, %Word8 0, 56
	%59 = insertvalue [64 x %Word8] %58, %Word8 0, 57
	%60 = insertvalue [64 x %Word8] %59, %Word8 0, 58
	%61 = insertvalue [64 x %Word8] %60, %Word8 0, 59
	%62 = insertvalue [64 x %Word8] %61, %Word8 0, 60
	%63 = insertvalue [64 x %Word8] %62, %Word8 0, 61
	%64 = insertvalue [64 x %Word8] %63, %Word8 0, 62
	%65 = insertvalue [64 x %Word8] %64, %Word8 0, 63
	%66 = insertvalue %Context zeroinitializer, [64 x %Word8] %65, 0
	%67 = insertvalue %Context %66, %Int32 0, 1
	%68 = insertvalue %Context %67, %Int64 0, 2
	%69 = insertvalue [8 x %Word32] zeroinitializer, %Word32 0, 0
	%70 = insertvalue [8 x %Word32] %69, %Word32 0, 1
	%71 = insertvalue [8 x %Word32] %70, %Word32 0, 2
	%72 = insertvalue [8 x %Word32] %71, %Word32 0, 3
	%73 = insertvalue [8 x %Word32] %72, %Word32 0, 4
	%74 = insertvalue [8 x %Word32] %73, %Word32 0, 5
	%75 = insertvalue [8 x %Word32] %74, %Word32 0, 6
	%76 = insertvalue [8 x %Word32] %75, %Word32 0, 7
	%77 = insertvalue %Context %68, [8 x %Word32] %76, 3
	store %Context %77, %Context* %1
	%78 = bitcast %Context* %1 to %Context*
	call void @contextInit(%Context* %78)
	%79 = bitcast %Context* %1 to %Context*
	call void @update(%Context* %79, [0 x %Word8]* %msg, %Int32 %msgLen)
	%80 = bitcast %Context* %1 to %Context*
	call void @final(%Context* %80, %sha256_Hash* %outHash)
	ret void
}


