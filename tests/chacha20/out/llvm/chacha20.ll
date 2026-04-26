
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
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
%Fixed32 = type i32
%Fixed64 = type i64
%Size = type i64
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

; MODULE: chacha20

; -- print includes --
; -- end print includes --
; -- print imports private 'chacha20' --

; from import "builtin"

; end from import "builtin"
; -- end print imports private 'chacha20' --
; -- print imports public 'chacha20' --
; -- end print imports public 'chacha20' --
; -- strings --
; -- endstrings --
%chacha20_Key = type [8 x %Word32];
%chacha20_State = type [16 x %Word32];
%chacha20_Block = type [16 x %Word32];
define internal %Word32 @rotl32(%Word32 %x, %Nat32 %n) {
	%1 = bitcast %Nat32 %n to %Word32
	%2 = shl %Word32 %x, %1
	%3 = sub %Nat32 32, %n
	%4 = bitcast %Nat32 %3 to %Word32
	%5 = lshr %Word32 %x, %4
	%6 = or %Word32 %2, %5
	ret %Word32 %6
}

define internal void @quarterRound([4 x %Word32]* %0, %Word32 %a, %Word32 %b, %Word32 %c, %Word32 %d) {
	%2 = alloca %Word32, align 4
	store %Word32 %a, %Word32* %2
	%3 = alloca %Word32, align 4
	store %Word32 %b, %Word32* %3
	%4 = alloca %Word32, align 4
	store %Word32 %c, %Word32* %4
	%5 = alloca %Word32, align 4
	store %Word32 %d, %Word32* %5
	%6 = load %Word32, %Word32* %2
	%7 = bitcast %Word32 %6 to %Nat32
	%8 = load %Word32, %Word32* %3
	%9 = bitcast %Word32 %8 to %Nat32
	%10 = add %Nat32 %7, %9
	%11 = bitcast %Nat32 %10 to %Word32
	store %Word32 %11, %Word32* %2
	%12 = load %Word32, %Word32* %5
	%13 = load %Word32, %Word32* %2
	%14 = xor %Word32 %12, %13
	%15 = call %Word32 @rotl32(%Word32 %14, %Nat32 16)
	store %Word32 %15, %Word32* %5
	%16 = load %Word32, %Word32* %4
	%17 = bitcast %Word32 %16 to %Nat32
	%18 = load %Word32, %Word32* %5
	%19 = bitcast %Word32 %18 to %Nat32
	%20 = add %Nat32 %17, %19
	%21 = bitcast %Nat32 %20 to %Word32
	store %Word32 %21, %Word32* %4
	%22 = load %Word32, %Word32* %3
	%23 = load %Word32, %Word32* %4
	%24 = xor %Word32 %22, %23
	%25 = call %Word32 @rotl32(%Word32 %24, %Nat32 12)
	store %Word32 %25, %Word32* %3
	%26 = load %Word32, %Word32* %2
	%27 = bitcast %Word32 %26 to %Nat32
	%28 = load %Word32, %Word32* %3
	%29 = bitcast %Word32 %28 to %Nat32
	%30 = add %Nat32 %27, %29
	%31 = bitcast %Nat32 %30 to %Word32
	store %Word32 %31, %Word32* %2
	%32 = load %Word32, %Word32* %5
	%33 = load %Word32, %Word32* %2
	%34 = xor %Word32 %32, %33
	%35 = call %Word32 @rotl32(%Word32 %34, %Nat32 8)
	store %Word32 %35, %Word32* %5
	%36 = load %Word32, %Word32* %4
	%37 = bitcast %Word32 %36 to %Nat32
	%38 = load %Word32, %Word32* %5
	%39 = bitcast %Word32 %38 to %Nat32
	%40 = add %Nat32 %37, %39
	%41 = bitcast %Nat32 %40 to %Word32
	store %Word32 %41, %Word32* %4
	%42 = load %Word32, %Word32* %3
	%43 = load %Word32, %Word32* %4
	%44 = xor %Word32 %42, %43
	%45 = call %Word32 @rotl32(%Word32 %44, %Nat32 7)
	store %Word32 %45, %Word32* %3
	%46 = load %Word32, %Word32* %2
	%47 = load %Word32, %Word32* %3
	%48 = load %Word32, %Word32* %4
	%49 = load %Word32, %Word32* %5
	%50 = load %Word32, %Word32* %2
	%51 = insertvalue [4 x %Word32] zeroinitializer, %Word32 %50, 0
	%52 = load %Word32, %Word32* %3
	%53 = insertvalue [4 x %Word32] %51, %Word32 %52, 1
	%54 = load %Word32, %Word32* %4
	%55 = insertvalue [4 x %Word32] %53, %Word32 %54, 2
	%56 = load %Word32, %Word32* %5
	%57 = insertvalue [4 x %Word32] %55, %Word32 %56, 3
	%58 = zext i8 4 to %Nat32
	store [4 x %Word32] %57, [4 x %Word32]* %0
	ret void
}

define void @chacha20_chacha20Block(%chacha20_Block* %0, %chacha20_State %__state) {
	%state = alloca %chacha20_State
	%2 = zext i8 16 to %Nat32
	store %chacha20_State %__state, %chacha20_State* %state
	%3 = alloca %chacha20_State, align 4
	%4 = load %chacha20_State, %chacha20_State* %state
	%5 = zext i8 16 to %Nat32
	store %chacha20_State %4, %chacha20_State* %3
	%6 = alloca %Int32, align 4
	store %Int32 0, %Int32* %6
; while_1
	br label %again_1
again_1:
	%7 = load %Int32, %Int32* %6
	%8 = icmp slt %Int32 %7, 10
	br %Bool %8 , label %body_1, label %break_1
body_1:
	%9 = alloca [4 x %Word32], align 4
	%10 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 0
	%11 = load %Word32, %Word32* %10
	%12 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 4
	%13 = load %Word32, %Word32* %12
	%14 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 8
	%15 = load %Word32, %Word32* %14
	%16 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 12
	%17 = load %Word32, %Word32* %16; alloca memory for return value
	%18 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %18, %Word32 %11, %Word32 %13, %Word32 %15, %Word32 %17)
	%19 = load [4 x %Word32], [4 x %Word32]* %18
	%20 = zext i8 4 to %Nat32
	store [4 x %Word32] %19, [4 x %Word32]* %9
	%21 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 0
	%22 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%23 = load %Word32, %Word32* %22
	store %Word32 %23, %Word32* %21
	%24 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 4
	%25 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%26 = load %Word32, %Word32* %25
	store %Word32 %26, %Word32* %24
	%27 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 8
	%28 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%29 = load %Word32, %Word32* %28
	store %Word32 %29, %Word32* %27
	%30 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 12
	%31 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%32 = load %Word32, %Word32* %31
	store %Word32 %32, %Word32* %30
	%33 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 1
	%34 = load %Word32, %Word32* %33
	%35 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 5
	%36 = load %Word32, %Word32* %35
	%37 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 9
	%38 = load %Word32, %Word32* %37
	%39 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 13
	%40 = load %Word32, %Word32* %39; alloca memory for return value
	%41 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %41, %Word32 %34, %Word32 %36, %Word32 %38, %Word32 %40)
	%42 = load [4 x %Word32], [4 x %Word32]* %41
	%43 = zext i8 4 to %Nat32
	store [4 x %Word32] %42, [4 x %Word32]* %9
	%44 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 1
	%45 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%46 = load %Word32, %Word32* %45
	store %Word32 %46, %Word32* %44
	%47 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 5
	%48 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%49 = load %Word32, %Word32* %48
	store %Word32 %49, %Word32* %47
	%50 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 9
	%51 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%52 = load %Word32, %Word32* %51
	store %Word32 %52, %Word32* %50
	%53 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 13
	%54 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%55 = load %Word32, %Word32* %54
	store %Word32 %55, %Word32* %53
	%56 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 2
	%57 = load %Word32, %Word32* %56
	%58 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 6
	%59 = load %Word32, %Word32* %58
	%60 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 10
	%61 = load %Word32, %Word32* %60
	%62 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 14
	%63 = load %Word32, %Word32* %62; alloca memory for return value
	%64 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %64, %Word32 %57, %Word32 %59, %Word32 %61, %Word32 %63)
	%65 = load [4 x %Word32], [4 x %Word32]* %64
	%66 = zext i8 4 to %Nat32
	store [4 x %Word32] %65, [4 x %Word32]* %9
	%67 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 2
	%68 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%69 = load %Word32, %Word32* %68
	store %Word32 %69, %Word32* %67
	%70 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 6
	%71 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%72 = load %Word32, %Word32* %71
	store %Word32 %72, %Word32* %70
	%73 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 10
	%74 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%75 = load %Word32, %Word32* %74
	store %Word32 %75, %Word32* %73
	%76 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 14
	%77 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%78 = load %Word32, %Word32* %77
	store %Word32 %78, %Word32* %76
	%79 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 3
	%80 = load %Word32, %Word32* %79
	%81 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 7
	%82 = load %Word32, %Word32* %81
	%83 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 11
	%84 = load %Word32, %Word32* %83
	%85 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 15
	%86 = load %Word32, %Word32* %85; alloca memory for return value
	%87 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %87, %Word32 %80, %Word32 %82, %Word32 %84, %Word32 %86)
	%88 = load [4 x %Word32], [4 x %Word32]* %87
	%89 = zext i8 4 to %Nat32
	store [4 x %Word32] %88, [4 x %Word32]* %9
	%90 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 3
	%91 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%92 = load %Word32, %Word32* %91
	store %Word32 %92, %Word32* %90
	%93 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 7
	%94 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%95 = load %Word32, %Word32* %94
	store %Word32 %95, %Word32* %93
	%96 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 11
	%97 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%98 = load %Word32, %Word32* %97
	store %Word32 %98, %Word32* %96
	%99 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 15
	%100 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%101 = load %Word32, %Word32* %100
	store %Word32 %101, %Word32* %99
	%102 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 0
	%103 = load %Word32, %Word32* %102
	%104 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 5
	%105 = load %Word32, %Word32* %104
	%106 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 10
	%107 = load %Word32, %Word32* %106
	%108 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 15
	%109 = load %Word32, %Word32* %108; alloca memory for return value
	%110 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %110, %Word32 %103, %Word32 %105, %Word32 %107, %Word32 %109)
	%111 = load [4 x %Word32], [4 x %Word32]* %110
	%112 = zext i8 4 to %Nat32
	store [4 x %Word32] %111, [4 x %Word32]* %9
	%113 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 0
	%114 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%115 = load %Word32, %Word32* %114
	store %Word32 %115, %Word32* %113
	%116 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 5
	%117 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%118 = load %Word32, %Word32* %117
	store %Word32 %118, %Word32* %116
	%119 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 10
	%120 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%121 = load %Word32, %Word32* %120
	store %Word32 %121, %Word32* %119
	%122 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 15
	%123 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%124 = load %Word32, %Word32* %123
	store %Word32 %124, %Word32* %122
	%125 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 1
	%126 = load %Word32, %Word32* %125
	%127 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 6
	%128 = load %Word32, %Word32* %127
	%129 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 11
	%130 = load %Word32, %Word32* %129
	%131 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 12
	%132 = load %Word32, %Word32* %131; alloca memory for return value
	%133 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %133, %Word32 %126, %Word32 %128, %Word32 %130, %Word32 %132)
	%134 = load [4 x %Word32], [4 x %Word32]* %133
	%135 = zext i8 4 to %Nat32
	store [4 x %Word32] %134, [4 x %Word32]* %9
	%136 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 1
	%137 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%138 = load %Word32, %Word32* %137
	store %Word32 %138, %Word32* %136
	%139 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 6
	%140 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%141 = load %Word32, %Word32* %140
	store %Word32 %141, %Word32* %139
	%142 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 11
	%143 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%144 = load %Word32, %Word32* %143
	store %Word32 %144, %Word32* %142
	%145 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 12
	%146 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%147 = load %Word32, %Word32* %146
	store %Word32 %147, %Word32* %145
	%148 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 2
	%149 = load %Word32, %Word32* %148
	%150 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 7
	%151 = load %Word32, %Word32* %150
	%152 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 8
	%153 = load %Word32, %Word32* %152
	%154 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 13
	%155 = load %Word32, %Word32* %154; alloca memory for return value
	%156 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %156, %Word32 %149, %Word32 %151, %Word32 %153, %Word32 %155)
	%157 = load [4 x %Word32], [4 x %Word32]* %156
	%158 = zext i8 4 to %Nat32
	store [4 x %Word32] %157, [4 x %Word32]* %9
	%159 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 2
	%160 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%161 = load %Word32, %Word32* %160
	store %Word32 %161, %Word32* %159
	%162 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 7
	%163 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%164 = load %Word32, %Word32* %163
	store %Word32 %164, %Word32* %162
	%165 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 8
	%166 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%167 = load %Word32, %Word32* %166
	store %Word32 %167, %Word32* %165
	%168 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 13
	%169 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%170 = load %Word32, %Word32* %169
	store %Word32 %170, %Word32* %168
	%171 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 3
	%172 = load %Word32, %Word32* %171
	%173 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 4
	%174 = load %Word32, %Word32* %173
	%175 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 9
	%176 = load %Word32, %Word32* %175
	%177 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 14
	%178 = load %Word32, %Word32* %177; alloca memory for return value
	%179 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %179, %Word32 %172, %Word32 %174, %Word32 %176, %Word32 %178)
	%180 = load [4 x %Word32], [4 x %Word32]* %179
	%181 = zext i8 4 to %Nat32
	store [4 x %Word32] %180, [4 x %Word32]* %9
	%182 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 3
	%183 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%184 = load %Word32, %Word32* %183
	store %Word32 %184, %Word32* %182
	%185 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 4
	%186 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%187 = load %Word32, %Word32* %186
	store %Word32 %187, %Word32* %185
	%188 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 9
	%189 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%190 = load %Word32, %Word32* %189
	store %Word32 %190, %Word32* %188
	%191 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 14
	%192 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%193 = load %Word32, %Word32* %192
	store %Word32 %193, %Word32* %191
	%194 = load %Int32, %Int32* %6
	%195 = add %Int32 %194, 1
	store %Int32 %195, %Int32* %6
	br label %again_1
break_1:
	%196 = alloca [16 x %Word32], align 4
	%197 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %197
; while_2
	br label %again_2
again_2:
	%198 = load %Nat32, %Nat32* %197
	%199 = icmp ult %Nat32 %198, 16
	br %Bool %199 , label %body_2, label %break_2
body_2:
	%200 = load %Nat32, %Nat32* %197
	%201 = bitcast %Nat32 %200 to %Nat32
	%202 = getelementptr [16 x %Word32], [16 x %Word32]* %196, %Int32 0, %Nat32 %201
	%203 = load %Nat32, %Nat32* %197
	%204 = bitcast %Nat32 %203 to %Nat32
	%205 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Nat32 %204
	%206 = load %Word32, %Word32* %205
	%207 = bitcast %Word32 %206 to %Nat32
	%208 = load %Nat32, %Nat32* %197
	%209 = bitcast %Nat32 %208 to %Nat32
	%210 = getelementptr %chacha20_State, %chacha20_State* %state, %Int32 0, %Nat32 %209
	%211 = load %Word32, %Word32* %210
	%212 = bitcast %Word32 %211 to %Nat32
	%213 = add %Nat32 %207, %212
	%214 = bitcast %Nat32 %213 to %Word32
	store %Word32 %214, %Word32* %202
	%215 = load %Nat32, %Nat32* %197
	%216 = add %Nat32 %215, 1
	store %Nat32 %216, %Nat32* %197
	br label %again_2
break_2:
	%217 = load [16 x %Word32], [16 x %Word32]* %196
	%218 = zext i8 16 to %Nat32
	store [16 x %Word32] %217, %chacha20_Block* %0
	ret void
}



; nonce = number used once
; Чтобы один и тот же ключ можно было использовать много раз.
; Если шифровать два сообщения одним ключом keystream будет одинаковым - это катастрофа
; Он НЕ секретный. Его обычно: передают вместе с сообщением
; кладут в заголовок пакета хранят рядом с ciphertext
; ⚠️ Самое важное правило: Nonce нельзя повторять с тем же ключом. Никогда.
; Важное правило: Nonce не нужно секретить. Ты можешь просто записать его в самое начало зашифрованного файла (первые 12 байт).
; Чтобы расшифровать файл, тебе понадобятся твой секретный ключ (который в голове или в сейфе) и этот Nonce
; (который прикреплен к файлу).
; Итог: Оставь Nonce открытым. Сила ChaCha20 не в секретности Nonce, а в том, что даже зная его, никто не сможет вычислить ключ.
define void @chacha20_makeState(%chacha20_State* %0, %chacha20_Key* %key, %Word32 %counter, [3 x %Word32]* %nonce) {
	%2 = bitcast i32 1634760805 to %Word32
	%3 = bitcast i32 857760878 to %Word32
	%4 = bitcast i32 2036477234 to %Word32
	%5 = bitcast i32 1797285236 to %Word32
	%6 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 0
	%7 = load %Word32, %Word32* %6
	%8 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 1
	%9 = load %Word32, %Word32* %8
	%10 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 2
	%11 = load %Word32, %Word32* %10
	%12 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 3
	%13 = load %Word32, %Word32* %12
	%14 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 4
	%15 = load %Word32, %Word32* %14
	%16 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 5
	%17 = load %Word32, %Word32* %16
	%18 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 6
	%19 = load %Word32, %Word32* %18
	%20 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 7
	%21 = load %Word32, %Word32* %20
	%22 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 0
	%23 = load %Word32, %Word32* %22
	%24 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 1
	%25 = load %Word32, %Word32* %24
	%26 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 2
	%27 = load %Word32, %Word32* %26
	%28 = bitcast i32 1634760805 to %Word32
	%29 = insertvalue [16 x %Word32] zeroinitializer, %Word32 %28, 0
	%30 = bitcast i32 857760878 to %Word32
	%31 = insertvalue [16 x %Word32] %29, %Word32 %30, 1
	%32 = bitcast i32 2036477234 to %Word32
	%33 = insertvalue [16 x %Word32] %31, %Word32 %32, 2
	%34 = bitcast i32 1797285236 to %Word32
	%35 = insertvalue [16 x %Word32] %33, %Word32 %34, 3
	%36 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 0
	%37 = load %Word32, %Word32* %36
	%38 = insertvalue [16 x %Word32] %35, %Word32 %37, 4
	%39 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 1
	%40 = load %Word32, %Word32* %39
	%41 = insertvalue [16 x %Word32] %38, %Word32 %40, 5
	%42 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 2
	%43 = load %Word32, %Word32* %42
	%44 = insertvalue [16 x %Word32] %41, %Word32 %43, 6
	%45 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 3
	%46 = load %Word32, %Word32* %45
	%47 = insertvalue [16 x %Word32] %44, %Word32 %46, 7
	%48 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 4
	%49 = load %Word32, %Word32* %48
	%50 = insertvalue [16 x %Word32] %47, %Word32 %49, 8
	%51 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 5
	%52 = load %Word32, %Word32* %51
	%53 = insertvalue [16 x %Word32] %50, %Word32 %52, 9
	%54 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 6
	%55 = load %Word32, %Word32* %54
	%56 = insertvalue [16 x %Word32] %53, %Word32 %55, 10
	%57 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 7
	%58 = load %Word32, %Word32* %57
	%59 = insertvalue [16 x %Word32] %56, %Word32 %58, 11
	%60 = insertvalue [16 x %Word32] %59, %Word32 %counter, 12
	%61 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 0
	%62 = load %Word32, %Word32* %61
	%63 = insertvalue [16 x %Word32] %60, %Word32 %62, 13
	%64 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 1
	%65 = load %Word32, %Word32* %64
	%66 = insertvalue [16 x %Word32] %63, %Word32 %65, 14
	%67 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 2
	%68 = load %Word32, %Word32* %67
	%69 = insertvalue [16 x %Word32] %66, %Word32 %68, 15
	%70 = zext i8 16 to %Nat32
	store %chacha20_State %69, %chacha20_State* %0
	ret void
}


