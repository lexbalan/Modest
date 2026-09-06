
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
%Float16 = type half
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


; MODULE: chacha20

; -- print includes --
; -- end print includes --
; -- print imports 'chacha20' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'chacha20' --
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
	%47 = insertvalue [4 x %Word32] zeroinitializer, %Word32 %46, 0
	%48 = load %Word32, %Word32* %3
	%49 = insertvalue [4 x %Word32] %47, %Word32 %48, 1
	%50 = load %Word32, %Word32* %4
	%51 = insertvalue [4 x %Word32] %49, %Word32 %50, 2
	%52 = load %Word32, %Word32* %5
	%53 = insertvalue [4 x %Word32] %51, %Word32 %52, 3
	%54 = zext i8 4 to %Nat32
	store [4 x %Word32] %53, [4 x %Word32]* %0
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
	%10 = zext i8 4 to %Nat32
	%11 = mul %Nat32 %10, 4
	%12 = bitcast [4 x %Word32]* %9 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %12, i8 0, %Nat32 %11, i1 0)
	%13 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 0
	%14 = load %Word32, %Word32* %13
	%15 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 4
	%16 = load %Word32, %Word32* %15
	%17 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 8
	%18 = load %Word32, %Word32* %17
	%19 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 12
	%20 = load %Word32, %Word32* %19; alloca memory for return value
	%21 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %21, %Word32 %14, %Word32 %16, %Word32 %18, %Word32 %20)
	%22 = load [4 x %Word32], [4 x %Word32]* %21
	%23 = zext i8 4 to %Nat32
	store [4 x %Word32] %22, [4 x %Word32]* %9
	%24 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 0
	%25 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%26 = load %Word32, %Word32* %25
	store %Word32 %26, %Word32* %24
	%27 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 4
	%28 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%29 = load %Word32, %Word32* %28
	store %Word32 %29, %Word32* %27
	%30 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 8
	%31 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%32 = load %Word32, %Word32* %31
	store %Word32 %32, %Word32* %30
	%33 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 12
	%34 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%35 = load %Word32, %Word32* %34
	store %Word32 %35, %Word32* %33
	%36 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 1
	%37 = load %Word32, %Word32* %36
	%38 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 5
	%39 = load %Word32, %Word32* %38
	%40 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 9
	%41 = load %Word32, %Word32* %40
	%42 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 13
	%43 = load %Word32, %Word32* %42; alloca memory for return value
	%44 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %44, %Word32 %37, %Word32 %39, %Word32 %41, %Word32 %43)
	%45 = load [4 x %Word32], [4 x %Word32]* %44
	%46 = zext i8 4 to %Nat32
	store [4 x %Word32] %45, [4 x %Word32]* %9
	%47 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 1
	%48 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%49 = load %Word32, %Word32* %48
	store %Word32 %49, %Word32* %47
	%50 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 5
	%51 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%52 = load %Word32, %Word32* %51
	store %Word32 %52, %Word32* %50
	%53 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 9
	%54 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%55 = load %Word32, %Word32* %54
	store %Word32 %55, %Word32* %53
	%56 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 13
	%57 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%58 = load %Word32, %Word32* %57
	store %Word32 %58, %Word32* %56
	%59 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 2
	%60 = load %Word32, %Word32* %59
	%61 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 6
	%62 = load %Word32, %Word32* %61
	%63 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 10
	%64 = load %Word32, %Word32* %63
	%65 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 14
	%66 = load %Word32, %Word32* %65; alloca memory for return value
	%67 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %67, %Word32 %60, %Word32 %62, %Word32 %64, %Word32 %66)
	%68 = load [4 x %Word32], [4 x %Word32]* %67
	%69 = zext i8 4 to %Nat32
	store [4 x %Word32] %68, [4 x %Word32]* %9
	%70 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 2
	%71 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%72 = load %Word32, %Word32* %71
	store %Word32 %72, %Word32* %70
	%73 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 6
	%74 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%75 = load %Word32, %Word32* %74
	store %Word32 %75, %Word32* %73
	%76 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 10
	%77 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%78 = load %Word32, %Word32* %77
	store %Word32 %78, %Word32* %76
	%79 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 14
	%80 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%81 = load %Word32, %Word32* %80
	store %Word32 %81, %Word32* %79
	%82 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 3
	%83 = load %Word32, %Word32* %82
	%84 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 7
	%85 = load %Word32, %Word32* %84
	%86 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 11
	%87 = load %Word32, %Word32* %86
	%88 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 15
	%89 = load %Word32, %Word32* %88; alloca memory for return value
	%90 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %90, %Word32 %83, %Word32 %85, %Word32 %87, %Word32 %89)
	%91 = load [4 x %Word32], [4 x %Word32]* %90
	%92 = zext i8 4 to %Nat32
	store [4 x %Word32] %91, [4 x %Word32]* %9
	%93 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 3
	%94 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%95 = load %Word32, %Word32* %94
	store %Word32 %95, %Word32* %93
	%96 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 7
	%97 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%98 = load %Word32, %Word32* %97
	store %Word32 %98, %Word32* %96
	%99 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 11
	%100 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%101 = load %Word32, %Word32* %100
	store %Word32 %101, %Word32* %99
	%102 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 15
	%103 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%104 = load %Word32, %Word32* %103
	store %Word32 %104, %Word32* %102
	%105 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 0
	%106 = load %Word32, %Word32* %105
	%107 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 5
	%108 = load %Word32, %Word32* %107
	%109 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 10
	%110 = load %Word32, %Word32* %109
	%111 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 15
	%112 = load %Word32, %Word32* %111; alloca memory for return value
	%113 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %113, %Word32 %106, %Word32 %108, %Word32 %110, %Word32 %112)
	%114 = load [4 x %Word32], [4 x %Word32]* %113
	%115 = zext i8 4 to %Nat32
	store [4 x %Word32] %114, [4 x %Word32]* %9
	%116 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 0
	%117 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%118 = load %Word32, %Word32* %117
	store %Word32 %118, %Word32* %116
	%119 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 5
	%120 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%121 = load %Word32, %Word32* %120
	store %Word32 %121, %Word32* %119
	%122 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 10
	%123 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%124 = load %Word32, %Word32* %123
	store %Word32 %124, %Word32* %122
	%125 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 15
	%126 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%127 = load %Word32, %Word32* %126
	store %Word32 %127, %Word32* %125
	%128 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 1
	%129 = load %Word32, %Word32* %128
	%130 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 6
	%131 = load %Word32, %Word32* %130
	%132 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 11
	%133 = load %Word32, %Word32* %132
	%134 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 12
	%135 = load %Word32, %Word32* %134; alloca memory for return value
	%136 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %136, %Word32 %129, %Word32 %131, %Word32 %133, %Word32 %135)
	%137 = load [4 x %Word32], [4 x %Word32]* %136
	%138 = zext i8 4 to %Nat32
	store [4 x %Word32] %137, [4 x %Word32]* %9
	%139 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 1
	%140 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%141 = load %Word32, %Word32* %140
	store %Word32 %141, %Word32* %139
	%142 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 6
	%143 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%144 = load %Word32, %Word32* %143
	store %Word32 %144, %Word32* %142
	%145 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 11
	%146 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%147 = load %Word32, %Word32* %146
	store %Word32 %147, %Word32* %145
	%148 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 12
	%149 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%150 = load %Word32, %Word32* %149
	store %Word32 %150, %Word32* %148
	%151 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 2
	%152 = load %Word32, %Word32* %151
	%153 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 7
	%154 = load %Word32, %Word32* %153
	%155 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 8
	%156 = load %Word32, %Word32* %155
	%157 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 13
	%158 = load %Word32, %Word32* %157; alloca memory for return value
	%159 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %159, %Word32 %152, %Word32 %154, %Word32 %156, %Word32 %158)
	%160 = load [4 x %Word32], [4 x %Word32]* %159
	%161 = zext i8 4 to %Nat32
	store [4 x %Word32] %160, [4 x %Word32]* %9
	%162 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 2
	%163 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%164 = load %Word32, %Word32* %163
	store %Word32 %164, %Word32* %162
	%165 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 7
	%166 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%167 = load %Word32, %Word32* %166
	store %Word32 %167, %Word32* %165
	%168 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 8
	%169 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%170 = load %Word32, %Word32* %169
	store %Word32 %170, %Word32* %168
	%171 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 13
	%172 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%173 = load %Word32, %Word32* %172
	store %Word32 %173, %Word32* %171
	%174 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 3
	%175 = load %Word32, %Word32* %174
	%176 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 4
	%177 = load %Word32, %Word32* %176
	%178 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 9
	%179 = load %Word32, %Word32* %178
	%180 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 14
	%181 = load %Word32, %Word32* %180; alloca memory for return value
	%182 = alloca [4 x %Word32]
	call void @quarterRound([4 x %Word32]* %182, %Word32 %175, %Word32 %177, %Word32 %179, %Word32 %181)
	%183 = load [4 x %Word32], [4 x %Word32]* %182
	%184 = zext i8 4 to %Nat32
	store [4 x %Word32] %183, [4 x %Word32]* %9
	%185 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 3
	%186 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 0
	%187 = load %Word32, %Word32* %186
	store %Word32 %187, %Word32* %185
	%188 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 4
	%189 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 1
	%190 = load %Word32, %Word32* %189
	store %Word32 %190, %Word32* %188
	%191 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 9
	%192 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 2
	%193 = load %Word32, %Word32* %192
	store %Word32 %193, %Word32* %191
	%194 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Int32 14
	%195 = getelementptr [4 x %Word32], [4 x %Word32]* %9, %Int32 0, %Int32 3
	%196 = load %Word32, %Word32* %195
	store %Word32 %196, %Word32* %194
	%197 = load %Int32, %Int32* %6
	%198 = add %Int32 %197, 1
	store %Int32 %198, %Int32* %6
	br label %again_1
break_1:
	%199 = alloca [16 x %Word32], align 4
	%200 = zext i8 16 to %Nat32
	%201 = mul %Nat32 %200, 4
	%202 = bitcast [16 x %Word32]* %199 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %202, i8 0, %Nat32 %201, i1 0)
	%203 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %203
; while_2
	br label %again_2
again_2:
	%204 = load %Nat32, %Nat32* %203
	%205 = icmp ult %Nat32 %204, 16
	br %Bool %205 , label %body_2, label %break_2
body_2:
	%206 = load %Nat32, %Nat32* %203
	%207 = bitcast %Nat32 %206 to %Nat32
	%208 = getelementptr [16 x %Word32], [16 x %Word32]* %199, %Int32 0, %Nat32 %207
	%209 = load %Nat32, %Nat32* %203
	%210 = bitcast %Nat32 %209 to %Nat32
	%211 = getelementptr %chacha20_State, %chacha20_State* %3, %Int32 0, %Nat32 %210
	%212 = load %Word32, %Word32* %211
	%213 = bitcast %Word32 %212 to %Nat32
	%214 = load %Nat32, %Nat32* %203
	%215 = bitcast %Nat32 %214 to %Nat32
	%216 = getelementptr %chacha20_State, %chacha20_State* %state, %Int32 0, %Nat32 %215
	%217 = load %Word32, %Word32* %216
	%218 = bitcast %Word32 %217 to %Nat32
	%219 = add %Nat32 %213, %218
	%220 = bitcast %Nat32 %219 to %Word32
	store %Word32 %220, %Word32* %208
	%221 = load %Nat32, %Nat32* %203
	%222 = add %Nat32 %221, 1
	store %Nat32 %222, %Nat32* %203
	br label %again_2
break_2:
	%223 = load [16 x %Word32], [16 x %Word32]* %199
	%224 = zext i8 16 to %Nat32
	store [16 x %Word32] %223, %chacha20_Block* %0
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
	%3 = insertvalue [16 x %Word32] zeroinitializer, %Word32 %2, 0
	%4 = bitcast i32 857760878 to %Word32
	%5 = insertvalue [16 x %Word32] %3, %Word32 %4, 1
	%6 = bitcast i32 2036477234 to %Word32
	%7 = insertvalue [16 x %Word32] %5, %Word32 %6, 2
	%8 = bitcast i32 1797285236 to %Word32
	%9 = insertvalue [16 x %Word32] %7, %Word32 %8, 3
	%10 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 0
	%11 = load %Word32, %Word32* %10
	%12 = insertvalue [16 x %Word32] %9, %Word32 %11, 4
	%13 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 1
	%14 = load %Word32, %Word32* %13
	%15 = insertvalue [16 x %Word32] %12, %Word32 %14, 5
	%16 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 2
	%17 = load %Word32, %Word32* %16
	%18 = insertvalue [16 x %Word32] %15, %Word32 %17, 6
	%19 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 3
	%20 = load %Word32, %Word32* %19
	%21 = insertvalue [16 x %Word32] %18, %Word32 %20, 7
	%22 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 4
	%23 = load %Word32, %Word32* %22
	%24 = insertvalue [16 x %Word32] %21, %Word32 %23, 8
	%25 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 5
	%26 = load %Word32, %Word32* %25
	%27 = insertvalue [16 x %Word32] %24, %Word32 %26, 9
	%28 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 6
	%29 = load %Word32, %Word32* %28
	%30 = insertvalue [16 x %Word32] %27, %Word32 %29, 10
	%31 = getelementptr %chacha20_Key, %chacha20_Key* %key, %Int32 0, %Int32 7
	%32 = load %Word32, %Word32* %31
	%33 = insertvalue [16 x %Word32] %30, %Word32 %32, 11
	%34 = insertvalue [16 x %Word32] %33, %Word32 %counter, 12
	%35 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 0
	%36 = load %Word32, %Word32* %35
	%37 = insertvalue [16 x %Word32] %34, %Word32 %36, 13
	%38 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 1
	%39 = load %Word32, %Word32* %38
	%40 = insertvalue [16 x %Word32] %37, %Word32 %39, 14
	%41 = getelementptr [3 x %Word32], [3 x %Word32]* %nonce, %Int32 0, %Int32 2
	%42 = load %Word32, %Word32* %41
	%43 = insertvalue [16 x %Word32] %40, %Word32 %42, 15
	%44 = zext i8 16 to %Nat32
	store %chacha20_State %43, %chacha20_State* %0
	ret void
}


