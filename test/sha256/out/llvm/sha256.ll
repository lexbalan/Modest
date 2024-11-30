
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
%VA_List = type i8*
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

%Context = type {
	[64 x %Word8],
	%Int32,
	%Int64,
	[8 x %Word32]
};


define internal %Word32 @rotleft(%Word32 %a, %Int32 %b) {
	%1 = shl %Word32 %a, %b
	%2 = sub %Int32 32, %b
	%3 = lshr %Word32 %a, %2
	%4 = or %Word32 %1, %3
	ret %Word32 %4
}

define internal %Word32 @rotright(%Word32 %a, %Int32 %b) {
	%1 = lshr %Word32 %a, %b
	%2 = sub %Int32 32, %b
	%3 = shl %Word32 %a, %2
	%4 = or %Word32 %1, %3
	ret %Word32 %4
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
	%33 = load %Int64, %Int64* %32
	%34 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 1
	%35 = load %Int32, %Int32* %34
	%36 = zext %Int32 %35 to %Int64
	%37 = mul %Int64 %36, 8
	%38 = add %Int64 %33, %37
	store %Int64 %38, %Int64* %31
	%39 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%40 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %39, %Int32 0, %Int32 63
	%41 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%42 = load %Int64, %Int64* %41
	%43 = trunc %Int64 %42 to %Word32
	%44 = lshr %Word32 %43, 0
	%45 = trunc %Word32 %44 to %Word8
	store %Word8 %45, %Word8* %40
	%46 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%47 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %46, %Int32 0, %Int32 62
	%48 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%49 = load %Int64, %Int64* %48
	%50 = trunc %Int64 %49 to %Word32
	%51 = lshr %Word32 %50, 8
	%52 = trunc %Word32 %51 to %Word8
	store %Word8 %52, %Word8* %47
	%53 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%54 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %53, %Int32 0, %Int32 61
	%55 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%56 = load %Int64, %Int64* %55
	%57 = trunc %Int64 %56 to %Word32
	%58 = lshr %Word32 %57, 16
	%59 = trunc %Word32 %58 to %Word8
	store %Word8 %59, %Word8* %54
	%60 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%61 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %60, %Int32 0, %Int32 60
	%62 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%63 = load %Int64, %Int64* %62
	%64 = trunc %Int64 %63 to %Word32
	%65 = lshr %Word32 %64, 24
	%66 = trunc %Word32 %65 to %Word8
	store %Word8 %66, %Word8* %61
	%67 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%68 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %67, %Int32 0, %Int32 59
	%69 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%70 = load %Int64, %Int64* %69
	%71 = trunc %Int64 %70 to %Word32
	%72 = lshr %Word32 %71, 32
	%73 = trunc %Word32 %72 to %Word8
	store %Word8 %73, %Word8* %68
	%74 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%75 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %74, %Int32 0, %Int32 58
	%76 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%77 = load %Int64, %Int64* %76
	%78 = trunc %Int64 %77 to %Word32
	%79 = lshr %Word32 %78, 40
	%80 = trunc %Word32 %79 to %Word8
	store %Word8 %80, %Word8* %75
	%81 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%82 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %81, %Int32 0, %Int32 57
	%83 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%84 = load %Int64, %Int64* %83
	%85 = trunc %Int64 %84 to %Word32
	%86 = lshr %Word32 %85, 48
	%87 = trunc %Word32 %86 to %Word8
	store %Word8 %87, %Word8* %82
	%88 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 0
	%89 = getelementptr inbounds [64 x %Word8], [64 x %Word8]* %88, %Int32 0, %Int32 56
	%90 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 2
	%91 = load %Int64, %Int64* %90
	%92 = trunc %Int64 %91 to %Word32
	%93 = lshr %Word32 %92, 56
	%94 = trunc %Word32 %93 to %Word8
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
	%109 = lshr %Word32 %108, %102
	%110 = trunc %Word32 %109 to %Word8
	store %Word8 %110, %Word8* %105
	%111 = load %Int32, %Int32* %1
	%112 = add %Int32 %111, 4
	%113 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %112
	%114 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%115 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %114, %Int32 0, %Int32 1
	%116 = load %Word32, %Word32* %115
	%117 = lshr %Word32 %116, %102
	%118 = trunc %Word32 %117 to %Word8
	store %Word8 %118, %Word8* %113
	%119 = load %Int32, %Int32* %1
	%120 = add %Int32 %119, 8
	%121 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %120
	%122 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%123 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %122, %Int32 0, %Int32 2
	%124 = load %Word32, %Word32* %123
	%125 = lshr %Word32 %124, %102
	%126 = trunc %Word32 %125 to %Word8
	store %Word8 %126, %Word8* %121
	%127 = load %Int32, %Int32* %1
	%128 = add %Int32 %127, 12
	%129 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %128
	%130 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%131 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %130, %Int32 0, %Int32 3
	%132 = load %Word32, %Word32* %131
	%133 = lshr %Word32 %132, %102
	%134 = trunc %Word32 %133 to %Word8
	store %Word8 %134, %Word8* %129
	%135 = load %Int32, %Int32* %1
	%136 = add %Int32 %135, 16
	%137 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %136
	%138 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%139 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %138, %Int32 0, %Int32 4
	%140 = load %Word32, %Word32* %139
	%141 = lshr %Word32 %140, %102
	%142 = trunc %Word32 %141 to %Word8
	store %Word8 %142, %Word8* %137
	%143 = load %Int32, %Int32* %1
	%144 = add %Int32 %143, 20
	%145 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %144
	%146 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%147 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %146, %Int32 0, %Int32 5
	%148 = load %Word32, %Word32* %147
	%149 = lshr %Word32 %148, %102
	%150 = trunc %Word32 %149 to %Word8
	store %Word8 %150, %Word8* %145
	%151 = load %Int32, %Int32* %1
	%152 = add %Int32 %151, 24
	%153 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %152
	%154 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%155 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %154, %Int32 0, %Int32 6
	%156 = load %Word32, %Word32* %155
	%157 = lshr %Word32 %156, %102
	%158 = trunc %Word32 %157 to %Word8
	store %Word8 %158, %Word8* %153
	%159 = load %Int32, %Int32* %1
	%160 = add %Int32 %159, 28
	%161 = getelementptr inbounds %sha256_Hash, %sha256_Hash* %outHash, %Int32 0, %Int32 %160
	%162 = getelementptr inbounds %Context, %Context* %ctx, %Int32 0, %Int32 3
	%163 = getelementptr inbounds [8 x %Word32], [8 x %Word32]* %162, %Int32 0, %Int32 7
	%164 = load %Word32, %Word32* %163
	%165 = lshr %Word32 %164, %102
	%166 = trunc %Word32 %165 to %Word8
	store %Word8 %166, %Word8* %161
	%167 = load %Int32, %Int32* %1
	%168 = add %Int32 %167, 1
	store %Int32 %168, %Int32* %1
	br label %again_1
break_1:
	ret void
}



%sha256_Hash = type [32 x %Word8];

define void @sha256_hash([0 x %Word8]* %msg, %Int32 %msgLen, %sha256_Hash* %outHash) {
	%1 = alloca %Context, align 8
	store %Context zeroinitializer, %Context* %1
	%2 = bitcast %Context* %1 to %Context*
	call void @contextInit(%Context* %2)
	%3 = bitcast %Context* %1 to %Context*
	call void @update(%Context* %3, [0 x %Word8]* %msg, %Int32 %msgLen)
	%4 = bitcast %Context* %1 to %Context*
	call void @final(%Context* %4, %sha256_Hash* %outHash)
	ret void
}


