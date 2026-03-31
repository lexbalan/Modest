
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

; MODULE: aes256

; -- print includes --
; -- end print includes --
; -- print imports 'aes256' --
; -- 1

; from import "builtin"

; end from import "builtin"
; -- end print imports 'aes256' --
; -- strings --
; -- endstrings --

; thx: https://github.com/ilvn/aes256/tree/main
%aes256_Result = type %Word8;
%aes256_Key = type [32 x %Byte];
%aes256_Block = type [16 x %Byte];
%aes256_Context = type {
	%aes256_Key,
	%aes256_Key,
	%aes256_Key
};

define internal %Word8 @rj_xtime(%Word8 %x) {
	%1 = bitcast i8 255 to %Word8
	%2 = bitcast i8 1 to %Word8
	%3 = shl %Word8 %x, %2
	%4 = and %Word8 %1, %3
; if_0
	%5 = bitcast i8 128 to %Word8
	%6 = and %Word8 %x, %5
	%7 = bitcast i8 0 to %Word8
	%8 = icmp ne %Word8 %6, %7
	br %Bool %8 , label %then_0, label %endif_0
then_0:
	%9 = bitcast i8 27 to %Word8
	%10 = xor %Word8 %4, %9
	ret %Word8 %10
	br label %endif_0
endif_0:
	ret %Word8 %4
}

@sbox = constant [256 x %Byte] [
	%Byte 99,
	%Byte 124,
	%Byte 119,
	%Byte 123,
	%Byte 242,
	%Byte 107,
	%Byte 111,
	%Byte 197,
	%Byte 48,
	%Byte 1,
	%Byte 103,
	%Byte 43,
	%Byte 254,
	%Byte 215,
	%Byte 171,
	%Byte 118,
	%Byte 202,
	%Byte 130,
	%Byte 201,
	%Byte 125,
	%Byte 250,
	%Byte 89,
	%Byte 71,
	%Byte 240,
	%Byte 173,
	%Byte 212,
	%Byte 162,
	%Byte 175,
	%Byte 156,
	%Byte 164,
	%Byte 114,
	%Byte 192,
	%Byte 183,
	%Byte 253,
	%Byte 147,
	%Byte 38,
	%Byte 54,
	%Byte 63,
	%Byte 247,
	%Byte 204,
	%Byte 52,
	%Byte 165,
	%Byte 229,
	%Byte 241,
	%Byte 113,
	%Byte 216,
	%Byte 49,
	%Byte 21,
	%Byte 4,
	%Byte 199,
	%Byte 35,
	%Byte 195,
	%Byte 24,
	%Byte 150,
	%Byte 5,
	%Byte 154,
	%Byte 7,
	%Byte 18,
	%Byte 128,
	%Byte 226,
	%Byte 235,
	%Byte 39,
	%Byte 178,
	%Byte 117,
	%Byte 9,
	%Byte 131,
	%Byte 44,
	%Byte 26,
	%Byte 27,
	%Byte 110,
	%Byte 90,
	%Byte 160,
	%Byte 82,
	%Byte 59,
	%Byte 214,
	%Byte 179,
	%Byte 41,
	%Byte 227,
	%Byte 47,
	%Byte 132,
	%Byte 83,
	%Byte 209,
	%Byte 0,
	%Byte 237,
	%Byte 32,
	%Byte 252,
	%Byte 177,
	%Byte 91,
	%Byte 106,
	%Byte 203,
	%Byte 190,
	%Byte 57,
	%Byte 74,
	%Byte 76,
	%Byte 88,
	%Byte 207,
	%Byte 208,
	%Byte 239,
	%Byte 170,
	%Byte 251,
	%Byte 67,
	%Byte 77,
	%Byte 51,
	%Byte 133,
	%Byte 69,
	%Byte 249,
	%Byte 2,
	%Byte 127,
	%Byte 80,
	%Byte 60,
	%Byte 159,
	%Byte 168,
	%Byte 81,
	%Byte 163,
	%Byte 64,
	%Byte 143,
	%Byte 146,
	%Byte 157,
	%Byte 56,
	%Byte 245,
	%Byte 188,
	%Byte 182,
	%Byte 218,
	%Byte 33,
	%Byte 16,
	%Byte 255,
	%Byte 243,
	%Byte 210,
	%Byte 205,
	%Byte 12,
	%Byte 19,
	%Byte 236,
	%Byte 95,
	%Byte 151,
	%Byte 68,
	%Byte 23,
	%Byte 196,
	%Byte 167,
	%Byte 126,
	%Byte 61,
	%Byte 100,
	%Byte 93,
	%Byte 25,
	%Byte 115,
	%Byte 96,
	%Byte 129,
	%Byte 79,
	%Byte 220,
	%Byte 34,
	%Byte 42,
	%Byte 144,
	%Byte 136,
	%Byte 70,
	%Byte 238,
	%Byte 184,
	%Byte 20,
	%Byte 222,
	%Byte 94,
	%Byte 11,
	%Byte 219,
	%Byte 224,
	%Byte 50,
	%Byte 58,
	%Byte 10,
	%Byte 73,
	%Byte 6,
	%Byte 36,
	%Byte 92,
	%Byte 194,
	%Byte 211,
	%Byte 172,
	%Byte 98,
	%Byte 145,
	%Byte 149,
	%Byte 228,
	%Byte 121,
	%Byte 231,
	%Byte 200,
	%Byte 55,
	%Byte 109,
	%Byte 141,
	%Byte 213,
	%Byte 78,
	%Byte 169,
	%Byte 108,
	%Byte 86,
	%Byte 244,
	%Byte 234,
	%Byte 101,
	%Byte 122,
	%Byte 174,
	%Byte 8,
	%Byte 186,
	%Byte 120,
	%Byte 37,
	%Byte 46,
	%Byte 28,
	%Byte 166,
	%Byte 180,
	%Byte 198,
	%Byte 232,
	%Byte 221,
	%Byte 116,
	%Byte 31,
	%Byte 75,
	%Byte 189,
	%Byte 139,
	%Byte 138,
	%Byte 112,
	%Byte 62,
	%Byte 181,
	%Byte 102,
	%Byte 72,
	%Byte 3,
	%Byte 246,
	%Byte 14,
	%Byte 97,
	%Byte 53,
	%Byte 87,
	%Byte 185,
	%Byte 134,
	%Byte 193,
	%Byte 29,
	%Byte 158,
	%Byte 225,
	%Byte 248,
	%Byte 152,
	%Byte 17,
	%Byte 105,
	%Byte 217,
	%Byte 142,
	%Byte 148,
	%Byte 155,
	%Byte 30,
	%Byte 135,
	%Byte 233,
	%Byte 206,
	%Byte 85,
	%Byte 40,
	%Byte 223,
	%Byte 140,
	%Byte 161,
	%Byte 137,
	%Byte 13,
	%Byte 191,
	%Byte 230,
	%Byte 66,
	%Byte 104,
	%Byte 65,
	%Byte 153,
	%Byte 45,
	%Byte 15,
	%Byte 176,
	%Byte 84,
	%Byte 187,
	%Byte 22
]
@sboxinv = constant [256 x %Byte] [
	%Byte 82,
	%Byte 9,
	%Byte 106,
	%Byte 213,
	%Byte 48,
	%Byte 54,
	%Byte 165,
	%Byte 56,
	%Byte 191,
	%Byte 64,
	%Byte 163,
	%Byte 158,
	%Byte 129,
	%Byte 243,
	%Byte 215,
	%Byte 251,
	%Byte 124,
	%Byte 227,
	%Byte 57,
	%Byte 130,
	%Byte 155,
	%Byte 47,
	%Byte 255,
	%Byte 135,
	%Byte 52,
	%Byte 142,
	%Byte 67,
	%Byte 68,
	%Byte 196,
	%Byte 222,
	%Byte 233,
	%Byte 203,
	%Byte 84,
	%Byte 123,
	%Byte 148,
	%Byte 50,
	%Byte 166,
	%Byte 194,
	%Byte 35,
	%Byte 61,
	%Byte 238,
	%Byte 76,
	%Byte 149,
	%Byte 11,
	%Byte 66,
	%Byte 250,
	%Byte 195,
	%Byte 78,
	%Byte 8,
	%Byte 46,
	%Byte 161,
	%Byte 102,
	%Byte 40,
	%Byte 217,
	%Byte 36,
	%Byte 178,
	%Byte 118,
	%Byte 91,
	%Byte 162,
	%Byte 73,
	%Byte 109,
	%Byte 139,
	%Byte 209,
	%Byte 37,
	%Byte 114,
	%Byte 248,
	%Byte 246,
	%Byte 100,
	%Byte 134,
	%Byte 104,
	%Byte 152,
	%Byte 22,
	%Byte 212,
	%Byte 164,
	%Byte 92,
	%Byte 204,
	%Byte 93,
	%Byte 101,
	%Byte 182,
	%Byte 146,
	%Byte 108,
	%Byte 112,
	%Byte 72,
	%Byte 80,
	%Byte 253,
	%Byte 237,
	%Byte 185,
	%Byte 218,
	%Byte 94,
	%Byte 21,
	%Byte 70,
	%Byte 87,
	%Byte 167,
	%Byte 141,
	%Byte 157,
	%Byte 132,
	%Byte 144,
	%Byte 216,
	%Byte 171,
	%Byte 0,
	%Byte 140,
	%Byte 188,
	%Byte 211,
	%Byte 10,
	%Byte 247,
	%Byte 228,
	%Byte 88,
	%Byte 5,
	%Byte 184,
	%Byte 179,
	%Byte 69,
	%Byte 6,
	%Byte 208,
	%Byte 44,
	%Byte 30,
	%Byte 143,
	%Byte 202,
	%Byte 63,
	%Byte 15,
	%Byte 2,
	%Byte 193,
	%Byte 175,
	%Byte 189,
	%Byte 3,
	%Byte 1,
	%Byte 19,
	%Byte 138,
	%Byte 107,
	%Byte 58,
	%Byte 145,
	%Byte 17,
	%Byte 65,
	%Byte 79,
	%Byte 103,
	%Byte 220,
	%Byte 234,
	%Byte 151,
	%Byte 242,
	%Byte 207,
	%Byte 206,
	%Byte 240,
	%Byte 180,
	%Byte 230,
	%Byte 115,
	%Byte 150,
	%Byte 172,
	%Byte 116,
	%Byte 34,
	%Byte 231,
	%Byte 173,
	%Byte 53,
	%Byte 133,
	%Byte 226,
	%Byte 249,
	%Byte 55,
	%Byte 232,
	%Byte 28,
	%Byte 117,
	%Byte 223,
	%Byte 110,
	%Byte 71,
	%Byte 241,
	%Byte 26,
	%Byte 113,
	%Byte 29,
	%Byte 41,
	%Byte 197,
	%Byte 137,
	%Byte 111,
	%Byte 183,
	%Byte 98,
	%Byte 14,
	%Byte 170,
	%Byte 24,
	%Byte 190,
	%Byte 27,
	%Byte 252,
	%Byte 86,
	%Byte 62,
	%Byte 75,
	%Byte 198,
	%Byte 210,
	%Byte 121,
	%Byte 32,
	%Byte 154,
	%Byte 219,
	%Byte 192,
	%Byte 254,
	%Byte 120,
	%Byte 205,
	%Byte 90,
	%Byte 244,
	%Byte 31,
	%Byte 221,
	%Byte 168,
	%Byte 51,
	%Byte 136,
	%Byte 7,
	%Byte 199,
	%Byte 49,
	%Byte 177,
	%Byte 18,
	%Byte 16,
	%Byte 89,
	%Byte 39,
	%Byte 128,
	%Byte 236,
	%Byte 95,
	%Byte 96,
	%Byte 81,
	%Byte 127,
	%Byte 169,
	%Byte 25,
	%Byte 181,
	%Byte 74,
	%Byte 13,
	%Byte 45,
	%Byte 229,
	%Byte 122,
	%Byte 159,
	%Byte 147,
	%Byte 201,
	%Byte 156,
	%Byte 239,
	%Byte 160,
	%Byte 224,
	%Byte 59,
	%Byte 77,
	%Byte 174,
	%Byte 42,
	%Byte 245,
	%Byte 176,
	%Byte 200,
	%Byte 235,
	%Byte 187,
	%Byte 60,
	%Byte 131,
	%Byte 83,
	%Byte 153,
	%Byte 97,
	%Byte 23,
	%Byte 43,
	%Byte 4,
	%Byte 126,
	%Byte 186,
	%Byte 119,
	%Byte 214,
	%Byte 38,
	%Byte 225,
	%Byte 105,
	%Byte 20,
	%Byte 99,
	%Byte 85,
	%Byte 33,
	%Byte 12,
	%Byte 125
]
define internal %Byte @rj_sbox(%Word8 %x) alwaysinline {
	%1 = bitcast %Word8 %x to %Nat8
	%2 = zext %Nat8 %1 to %Nat32
	%3 = getelementptr [256 x %Byte], [256 x %Byte]* @sbox, %Int32 0, %Nat32 %2
	%4 = load %Byte, %Byte* %3
	ret %Byte %4
}

define internal %Byte @rj_sboxInv(%Word8 %x) alwaysinline {
	%1 = bitcast %Word8 %x to %Nat8
	%2 = zext %Nat8 %1 to %Nat32
	%3 = getelementptr [256 x %Byte], [256 x %Byte]* @sboxinv, %Int32 0, %Nat32 %2
	%4 = load %Byte, %Byte* %3
	ret %Byte %4
}

define internal void @subBytes(%aes256_Block* %block) {
	%1 = alloca %Nat8, align 1
	store %Nat8 0, %Nat8* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat8, %Nat8* %1
	%3 = icmp ult %Nat8 %2, 16
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat8, %Nat8* %1
	%5 = zext %Nat8 %4 to %Nat32
	%6 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %5
	%7 = load %Nat8, %Nat8* %1
	%8 = zext %Nat8 %7 to %Nat32
	%9 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %8
	%10 = load %Byte, %Byte* %9
	%11 = call %Byte @rj_sbox(%Byte %10)
	store %Byte %11, %Byte* %6
	%12 = load %Nat8, %Nat8* %1
	%13 = add %Nat8 %12, 1
	store %Nat8 %13, %Nat8* %1
	br label %again_1
break_1:
	ret void
}

define internal void @subBytesInv(%aes256_Block* %block) {
	%1 = alloca %Nat8, align 1
	store %Nat8 0, %Nat8* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat8, %Nat8* %1
	%3 = icmp ult %Nat8 %2, 16
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat8, %Nat8* %1
	%5 = zext %Nat8 %4 to %Nat32
	%6 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %5
	%7 = load %Nat8, %Nat8* %1
	%8 = zext %Nat8 %7 to %Nat32
	%9 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %8
	%10 = load %Byte, %Byte* %9
	%11 = call %Byte @rj_sboxInv(%Byte %10)
	store %Byte %11, %Byte* %6
	%12 = load %Nat8, %Nat8* %1
	%13 = add %Nat8 %12, 1
	store %Nat8 %13, %Nat8* %1
	br label %again_1
break_1:
	ret void
}

define internal void @addRoundKey(%aes256_Block* %block, [16 x %Byte]* %k) {
	%1 = alloca %Nat8, align 1
	store %Nat8 0, %Nat8* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat8, %Nat8* %1
	%3 = icmp ult %Nat8 %2, 16
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat8, %Nat8* %1
	%5 = zext %Nat8 %4 to %Nat32
	%6 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %5
	%7 = load %Nat8, %Nat8* %1
	%8 = zext %Nat8 %7 to %Nat32
	%9 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %8
	%10 = load %Nat8, %Nat8* %1
	%11 = zext %Nat8 %10 to %Nat32
	%12 = getelementptr [16 x %Byte], [16 x %Byte]* %k, %Int32 0, %Nat32 %11
	%13 = load %Byte, %Byte* %9
	%14 = load %Byte, %Byte* %12
	%15 = xor %Byte %13, %14
	store %Byte %15, %Byte* %6
	%16 = load %Nat8, %Nat8* %1
	%17 = add %Nat8 %16, 1
	store %Nat8 %17, %Nat8* %1
	br label %again_1
break_1:
	ret void
}

define internal void @addRoundKeyCpy(%aes256_Block* %block, %aes256_Key* %key, %aes256_Key* %cpk) {
	%1 = alloca %Nat8, align 1
	store %Nat8 0, %Nat8* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat8, %Nat8* %1
	%3 = icmp ult %Nat8 %2, 16
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat8, %Nat8* %1
	%5 = zext %Nat8 %4 to %Nat32
	%6 = getelementptr %aes256_Key, %aes256_Key* %key, %Int32 0, %Nat32 %5
	%7 = load %Byte, %Byte* %6
	%8 = load %Nat8, %Nat8* %1
	%9 = zext %Nat8 %8 to %Nat32
	%10 = getelementptr %aes256_Key, %aes256_Key* %cpk, %Int32 0, %Nat32 %9
	store %Byte %7, %Byte* %10
	%11 = load %Nat8, %Nat8* %1
	%12 = zext %Nat8 %11 to %Nat32
	%13 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %12
	%14 = load %Nat8, %Nat8* %1
	%15 = zext %Nat8 %14 to %Nat32
	%16 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %15
	%17 = load %Byte, %Byte* %16
	%18 = xor %Byte %17, %7
	store %Byte %18, %Byte* %13
	%19 = load %Nat8, %Nat8* %1
	%20 = add %Nat8 16, %19
	%21 = zext %Nat8 %20 to %Nat32
	%22 = getelementptr %aes256_Key, %aes256_Key* %cpk, %Int32 0, %Nat32 %21
	%23 = load %Nat8, %Nat8* %1
	%24 = add %Nat8 16, %23
	%25 = zext %Nat8 %24 to %Nat32
	%26 = getelementptr %aes256_Key, %aes256_Key* %key, %Int32 0, %Nat32 %25
	%27 = load %Byte, %Byte* %26
	store %Byte %27, %Byte* %22
	%28 = load %Nat8, %Nat8* %1
	%29 = add %Nat8 %28, 1
	store %Nat8 %29, %Nat8* %1
	br label %again_1
break_1:
	ret void
}

define internal void @shiftRows(%aes256_Block* %block) {
	%1 = alloca %Word8, align 1
	%2 = alloca %Word8, align 1
	%3 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 1
	%4 = load %Byte, %Byte* %3
	store %Byte %4, %Word8* %1
	%5 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 1
	%6 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 5
	%7 = load %Byte, %Byte* %6
	store %Byte %7, %Byte* %5
	%8 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 5
	%9 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 9
	%10 = load %Byte, %Byte* %9
	store %Byte %10, %Byte* %8
	%11 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 9
	%12 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 13
	%13 = load %Byte, %Byte* %12
	store %Byte %13, %Byte* %11
	%14 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 13
	%15 = load %Word8, %Word8* %1
	store %Word8 %15, %Byte* %14
	%16 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 10
	%17 = load %Byte, %Byte* %16
	store %Byte %17, %Word8* %1
	%18 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 10
	%19 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 2
	%20 = load %Byte, %Byte* %19
	store %Byte %20, %Byte* %18
	%21 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 2
	%22 = load %Word8, %Word8* %1
	store %Word8 %22, %Byte* %21
	%23 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 3
	%24 = load %Byte, %Byte* %23
	store %Byte %24, %Word8* %2
	%25 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 3
	%26 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 15
	%27 = load %Byte, %Byte* %26
	store %Byte %27, %Byte* %25
	%28 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 15
	%29 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 11
	%30 = load %Byte, %Byte* %29
	store %Byte %30, %Byte* %28
	%31 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 11
	%32 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 7
	%33 = load %Byte, %Byte* %32
	store %Byte %33, %Byte* %31
	%34 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 7
	%35 = load %Word8, %Word8* %2
	store %Word8 %35, %Byte* %34
	%36 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 14
	%37 = load %Byte, %Byte* %36
	store %Byte %37, %Word8* %2
	%38 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 14
	%39 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 6
	%40 = load %Byte, %Byte* %39
	store %Byte %40, %Byte* %38
	%41 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 6
	%42 = load %Word8, %Word8* %2
	store %Word8 %42, %Byte* %41
	ret void
}

define internal void @shiftRowsInv(%aes256_Block* %block) {
	%1 = alloca %Word8, align 1
	%2 = alloca %Word8, align 1
	%3 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 1
	%4 = load %Byte, %Byte* %3
	store %Byte %4, %Word8* %1
	%5 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 1
	%6 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 13
	%7 = load %Byte, %Byte* %6
	store %Byte %7, %Byte* %5
	%8 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 13
	%9 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 9
	%10 = load %Byte, %Byte* %9
	store %Byte %10, %Byte* %8
	%11 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 9
	%12 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 5
	%13 = load %Byte, %Byte* %12
	store %Byte %13, %Byte* %11
	%14 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 5
	%15 = load %Word8, %Word8* %1
	store %Word8 %15, %Byte* %14
	%16 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 2
	%17 = load %Byte, %Byte* %16
	store %Byte %17, %Word8* %1
	%18 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 2
	%19 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 10
	%20 = load %Byte, %Byte* %19
	store %Byte %20, %Byte* %18
	%21 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 10
	%22 = load %Word8, %Word8* %1
	store %Word8 %22, %Byte* %21
	%23 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 3
	%24 = load %Byte, %Byte* %23
	store %Byte %24, %Word8* %2
	%25 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 3
	%26 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 7
	%27 = load %Byte, %Byte* %26
	store %Byte %27, %Byte* %25
	%28 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 7
	%29 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 11
	%30 = load %Byte, %Byte* %29
	store %Byte %30, %Byte* %28
	%31 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 11
	%32 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 15
	%33 = load %Byte, %Byte* %32
	store %Byte %33, %Byte* %31
	%34 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 15
	%35 = load %Word8, %Word8* %2
	store %Word8 %35, %Byte* %34
	%36 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 6
	%37 = load %Byte, %Byte* %36
	store %Byte %37, %Word8* %2
	%38 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 6
	%39 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 14
	%40 = load %Byte, %Byte* %39
	store %Byte %40, %Byte* %38
	%41 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Int32 14
	%42 = load %Word8, %Word8* %2
	store %Word8 %42, %Byte* %41
	ret void
}

define internal void @mixColumns(%aes256_Block* %block) {
	%1 = alloca %Word8, align 1
	%2 = alloca %Word8, align 1
	%3 = alloca %Word8, align 1
	%4 = alloca %Word8, align 1
	%5 = alloca %Word8, align 1
	%6 = alloca %Nat8, align 1
	store %Nat8 0, %Nat8* %6
; while_1
	br label %again_1
again_1:
	%7 = load %Nat8, %Nat8* %6
	%8 = icmp ult %Nat8 %7, 16
	br %Bool %8 , label %body_1, label %break_1
body_1:
	%9 = load %Nat8, %Nat8* %6
	%10 = add %Nat8 %9, 0
	%11 = zext %Nat8 %10 to %Nat32
	%12 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %11
	%13 = load %Byte, %Byte* %12
	store %Byte %13, %Word8* %1
	%14 = load %Nat8, %Nat8* %6
	%15 = add %Nat8 %14, 1
	%16 = zext %Nat8 %15 to %Nat32
	%17 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %16
	%18 = load %Byte, %Byte* %17
	store %Byte %18, %Word8* %2
	%19 = load %Nat8, %Nat8* %6
	%20 = add %Nat8 %19, 2
	%21 = zext %Nat8 %20 to %Nat32
	%22 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %21
	%23 = load %Byte, %Byte* %22
	store %Byte %23, %Word8* %3
	%24 = load %Nat8, %Nat8* %6
	%25 = add %Nat8 %24, 3
	%26 = zext %Nat8 %25 to %Nat32
	%27 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %26
	%28 = load %Byte, %Byte* %27
	store %Byte %28, %Word8* %4
	%29 = load %Word8, %Word8* %3
	%30 = load %Word8, %Word8* %4
	%31 = xor %Word8 %29, %30
	%32 = load %Word8, %Word8* %2
	%33 = xor %Word8 %32, %31
	%34 = load %Word8, %Word8* %1
	%35 = xor %Word8 %34, %33
	store %Word8 %35, %Word8* %5
	%36 = load %Nat8, %Nat8* %6
	%37 = add %Nat8 %36, 0
	%38 = zext %Nat8 %37 to %Nat32
	%39 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %38
	%40 = load %Nat8, %Nat8* %6
	%41 = add %Nat8 %40, 0
	%42 = zext %Nat8 %41 to %Nat32
	%43 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %42
	%44 = load %Word8, %Word8* %1
	%45 = load %Word8, %Word8* %2
	%46 = xor %Word8 %44, %45
	%47 = call %Word8 @rj_xtime(%Word8 %46)
	%48 = load %Word8, %Word8* %5
	%49 = xor %Word8 %48, %47
	%50 = load %Byte, %Byte* %43
	%51 = xor %Byte %50, %49
	store %Byte %51, %Byte* %39
	%52 = load %Nat8, %Nat8* %6
	%53 = add %Nat8 %52, 1
	%54 = zext %Nat8 %53 to %Nat32
	%55 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %54
	%56 = load %Nat8, %Nat8* %6
	%57 = add %Nat8 %56, 1
	%58 = zext %Nat8 %57 to %Nat32
	%59 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %58
	%60 = load %Word8, %Word8* %2
	%61 = load %Word8, %Word8* %3
	%62 = xor %Word8 %60, %61
	%63 = call %Word8 @rj_xtime(%Word8 %62)
	%64 = load %Word8, %Word8* %5
	%65 = xor %Word8 %64, %63
	%66 = load %Byte, %Byte* %59
	%67 = xor %Byte %66, %65
	store %Byte %67, %Byte* %55
	%68 = load %Nat8, %Nat8* %6
	%69 = add %Nat8 %68, 2
	%70 = zext %Nat8 %69 to %Nat32
	%71 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %70
	%72 = load %Nat8, %Nat8* %6
	%73 = add %Nat8 %72, 2
	%74 = zext %Nat8 %73 to %Nat32
	%75 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %74
	%76 = load %Word8, %Word8* %3
	%77 = load %Word8, %Word8* %4
	%78 = xor %Word8 %76, %77
	%79 = call %Word8 @rj_xtime(%Word8 %78)
	%80 = load %Word8, %Word8* %5
	%81 = xor %Word8 %80, %79
	%82 = load %Byte, %Byte* %75
	%83 = xor %Byte %82, %81
	store %Byte %83, %Byte* %71
	%84 = load %Nat8, %Nat8* %6
	%85 = add %Nat8 %84, 3
	%86 = zext %Nat8 %85 to %Nat32
	%87 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %86
	%88 = load %Nat8, %Nat8* %6
	%89 = add %Nat8 %88, 3
	%90 = zext %Nat8 %89 to %Nat32
	%91 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %90
	%92 = load %Word8, %Word8* %4
	%93 = load %Word8, %Word8* %1
	%94 = xor %Word8 %92, %93
	%95 = call %Word8 @rj_xtime(%Word8 %94)
	%96 = load %Word8, %Word8* %5
	%97 = xor %Word8 %96, %95
	%98 = load %Byte, %Byte* %91
	%99 = xor %Byte %98, %97
	store %Byte %99, %Byte* %87
	%100 = load %Nat8, %Nat8* %6
	%101 = add %Nat8 %100, 4
	store %Nat8 %101, %Nat8* %6
	br label %again_1
break_1:
	ret void
}

define internal void @mixColumnsInv(%aes256_Block* %block) {
	%1 = alloca %Word8, align 1
	%2 = alloca %Word8, align 1
	%3 = alloca %Word8, align 1
	%4 = alloca %Word8, align 1
	%5 = alloca %Word8, align 1
	%6 = alloca %Word8, align 1
	%7 = alloca %Word8, align 1
	%8 = alloca %Word8, align 1
	%9 = alloca %Nat8, align 1
	store %Nat8 0, %Nat8* %9
; while_1
	br label %again_1
again_1:
	%10 = load %Nat8, %Nat8* %9
	%11 = icmp ult %Nat8 %10, 16
	br %Bool %11 , label %body_1, label %break_1
body_1:
	%12 = load %Nat8, %Nat8* %9
	%13 = add %Nat8 %12, 0
	%14 = zext %Nat8 %13 to %Nat32
	%15 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %14
	%16 = load %Byte, %Byte* %15
	store %Byte %16, %Word8* %1
	%17 = load %Nat8, %Nat8* %9
	%18 = add %Nat8 %17, 1
	%19 = zext %Nat8 %18 to %Nat32
	%20 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %19
	%21 = load %Byte, %Byte* %20
	store %Byte %21, %Word8* %2
	%22 = load %Nat8, %Nat8* %9
	%23 = add %Nat8 %22, 2
	%24 = zext %Nat8 %23 to %Nat32
	%25 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %24
	%26 = load %Byte, %Byte* %25
	store %Byte %26, %Word8* %3
	%27 = load %Nat8, %Nat8* %9
	%28 = add %Nat8 %27, 3
	%29 = zext %Nat8 %28 to %Nat32
	%30 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %29
	%31 = load %Byte, %Byte* %30
	store %Byte %31, %Word8* %4
	%32 = load %Word8, %Word8* %3
	%33 = load %Word8, %Word8* %4
	%34 = xor %Word8 %32, %33
	%35 = load %Word8, %Word8* %2
	%36 = xor %Word8 %35, %34
	%37 = load %Word8, %Word8* %1
	%38 = xor %Word8 %37, %36
	store %Word8 %38, %Word8* %5
	%39 = load %Word8, %Word8* %5
	%40 = call %Word8 @rj_xtime(%Word8 %39)
	store %Word8 %40, %Word8* %8
	%41 = load %Word8, %Word8* %1
	%42 = load %Word8, %Word8* %3
	%43 = xor %Word8 %41, %42
	%44 = load %Word8, %Word8* %8
	%45 = xor %Word8 %44, %43
	%46 = call %Word8 @rj_xtime(%Word8 %45)
	%47 = call %Word8 @rj_xtime(%Word8 %46)
	%48 = load %Word8, %Word8* %5
	%49 = xor %Word8 %48, %47
	store %Word8 %49, %Word8* %6
	%50 = load %Word8, %Word8* %2
	%51 = load %Word8, %Word8* %4
	%52 = xor %Word8 %50, %51
	%53 = load %Word8, %Word8* %8
	%54 = xor %Word8 %53, %52
	%55 = call %Word8 @rj_xtime(%Word8 %54)
	%56 = call %Word8 @rj_xtime(%Word8 %55)
	%57 = load %Word8, %Word8* %5
	%58 = xor %Word8 %57, %56
	store %Word8 %58, %Word8* %7
	%59 = load %Nat8, %Nat8* %9
	%60 = add %Nat8 %59, 0
	%61 = zext %Nat8 %60 to %Nat32
	%62 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %61
	%63 = load %Nat8, %Nat8* %9
	%64 = add %Nat8 %63, 0
	%65 = zext %Nat8 %64 to %Nat32
	%66 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %65
	%67 = load %Word8, %Word8* %1
	%68 = load %Word8, %Word8* %2
	%69 = xor %Word8 %67, %68
	%70 = call %Word8 @rj_xtime(%Word8 %69)
	%71 = load %Word8, %Word8* %6
	%72 = xor %Word8 %71, %70
	%73 = load %Byte, %Byte* %66
	%74 = xor %Byte %73, %72
	store %Byte %74, %Byte* %62
	%75 = load %Nat8, %Nat8* %9
	%76 = add %Nat8 %75, 1
	%77 = zext %Nat8 %76 to %Nat32
	%78 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %77
	%79 = load %Nat8, %Nat8* %9
	%80 = add %Nat8 %79, 1
	%81 = zext %Nat8 %80 to %Nat32
	%82 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %81
	%83 = load %Word8, %Word8* %2
	%84 = load %Word8, %Word8* %3
	%85 = xor %Word8 %83, %84
	%86 = call %Word8 @rj_xtime(%Word8 %85)
	%87 = load %Word8, %Word8* %7
	%88 = xor %Word8 %87, %86
	%89 = load %Byte, %Byte* %82
	%90 = xor %Byte %89, %88
	store %Byte %90, %Byte* %78
	%91 = load %Nat8, %Nat8* %9
	%92 = add %Nat8 %91, 2
	%93 = zext %Nat8 %92 to %Nat32
	%94 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %93
	%95 = load %Nat8, %Nat8* %9
	%96 = add %Nat8 %95, 2
	%97 = zext %Nat8 %96 to %Nat32
	%98 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %97
	%99 = load %Word8, %Word8* %3
	%100 = load %Word8, %Word8* %4
	%101 = xor %Word8 %99, %100
	%102 = call %Word8 @rj_xtime(%Word8 %101)
	%103 = load %Word8, %Word8* %6
	%104 = xor %Word8 %103, %102
	%105 = load %Byte, %Byte* %98
	%106 = xor %Byte %105, %104
	store %Byte %106, %Byte* %94
	%107 = load %Nat8, %Nat8* %9
	%108 = add %Nat8 %107, 3
	%109 = zext %Nat8 %108 to %Nat32
	%110 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %109
	%111 = load %Nat8, %Nat8* %9
	%112 = add %Nat8 %111, 3
	%113 = zext %Nat8 %112 to %Nat32
	%114 = getelementptr %aes256_Block, %aes256_Block* %block, %Int32 0, %Nat32 %113
	%115 = load %Word8, %Word8* %4
	%116 = load %Word8, %Word8* %1
	%117 = xor %Word8 %115, %116
	%118 = call %Word8 @rj_xtime(%Word8 %117)
	%119 = load %Word8, %Word8* %7
	%120 = xor %Word8 %119, %118
	%121 = load %Byte, %Byte* %114
	%122 = xor %Byte %121, %120
	store %Byte %122, %Byte* %110
	%123 = load %Nat8, %Nat8* %9
	%124 = add %Nat8 %123, 4
	store %Nat8 %124, %Nat8* %9
	br label %again_1
break_1:
	ret void
}

define internal void @expandEncKey(%aes256_Key* %k, %Byte* %rc) {
	%1 = alloca %Nat8, align 1
	%2 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 0
	%3 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 0
	%4 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 29
	%5 = load %Byte, %Byte* %4
	%6 = call %Byte @rj_sbox(%Byte %5)
	%7 = load %Byte, %Byte* %rc
	%8 = xor %Byte %6, %7
	%9 = load %Byte, %Byte* %3
	%10 = xor %Byte %9, %8
	store %Byte %10, %Byte* %2
	%11 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 1
	%12 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 1
	%13 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 30
	%14 = load %Byte, %Byte* %13
	%15 = call %Byte @rj_sbox(%Byte %14)
	%16 = load %Byte, %Byte* %12
	%17 = xor %Byte %16, %15
	store %Byte %17, %Byte* %11
	%18 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 2
	%19 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 2
	%20 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 31
	%21 = load %Byte, %Byte* %20
	%22 = call %Byte @rj_sbox(%Byte %21)
	%23 = load %Byte, %Byte* %19
	%24 = xor %Byte %23, %22
	store %Byte %24, %Byte* %18
	%25 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 3
	%26 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 3
	%27 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 28
	%28 = load %Byte, %Byte* %27
	%29 = call %Byte @rj_sbox(%Byte %28)
	%30 = load %Byte, %Byte* %26
	%31 = xor %Byte %30, %29
	store %Byte %31, %Byte* %25
	%32 = load %Byte, %Byte* %rc
	%33 = call %Word8 @rj_xtime(%Byte %32)
	store %Word8 %33, %Byte* %rc
	store %Nat8 4, %Nat8* %1
; while_1
	br label %again_1
again_1:
	%34 = load %Nat8, %Nat8* %1
	%35 = icmp ult %Nat8 %34, 16
	br %Bool %35 , label %body_1, label %break_1
body_1:
	%36 = load %Nat8, %Nat8* %1
	%37 = add %Nat8 %36, 0
	%38 = zext %Nat8 %37 to %Nat32
	%39 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %38
	%40 = load %Nat8, %Nat8* %1
	%41 = add %Nat8 %40, 0
	%42 = zext %Nat8 %41 to %Nat32
	%43 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %42
	%44 = load %Nat8, %Nat8* %1
	%45 = sub %Nat8 %44, 4
	%46 = zext %Nat8 %45 to %Nat32
	%47 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %46
	%48 = load %Byte, %Byte* %43
	%49 = load %Byte, %Byte* %47
	%50 = xor %Byte %48, %49
	store %Byte %50, %Byte* %39
	%51 = load %Nat8, %Nat8* %1
	%52 = add %Nat8 %51, 1
	%53 = zext %Nat8 %52 to %Nat32
	%54 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %53
	%55 = load %Nat8, %Nat8* %1
	%56 = add %Nat8 %55, 1
	%57 = zext %Nat8 %56 to %Nat32
	%58 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %57
	%59 = load %Nat8, %Nat8* %1
	%60 = sub %Nat8 %59, 3
	%61 = zext %Nat8 %60 to %Nat32
	%62 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %61
	%63 = load %Byte, %Byte* %58
	%64 = load %Byte, %Byte* %62
	%65 = xor %Byte %63, %64
	store %Byte %65, %Byte* %54
	%66 = load %Nat8, %Nat8* %1
	%67 = add %Nat8 %66, 2
	%68 = zext %Nat8 %67 to %Nat32
	%69 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %68
	%70 = load %Nat8, %Nat8* %1
	%71 = add %Nat8 %70, 2
	%72 = zext %Nat8 %71 to %Nat32
	%73 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %72
	%74 = load %Nat8, %Nat8* %1
	%75 = sub %Nat8 %74, 2
	%76 = zext %Nat8 %75 to %Nat32
	%77 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %76
	%78 = load %Byte, %Byte* %73
	%79 = load %Byte, %Byte* %77
	%80 = xor %Byte %78, %79
	store %Byte %80, %Byte* %69
	%81 = load %Nat8, %Nat8* %1
	%82 = add %Nat8 %81, 3
	%83 = zext %Nat8 %82 to %Nat32
	%84 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %83
	%85 = load %Nat8, %Nat8* %1
	%86 = add %Nat8 %85, 3
	%87 = zext %Nat8 %86 to %Nat32
	%88 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %87
	%89 = load %Nat8, %Nat8* %1
	%90 = sub %Nat8 %89, 1
	%91 = zext %Nat8 %90 to %Nat32
	%92 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %91
	%93 = load %Byte, %Byte* %88
	%94 = load %Byte, %Byte* %92
	%95 = xor %Byte %93, %94
	store %Byte %95, %Byte* %84
	%96 = load %Nat8, %Nat8* %1
	%97 = add %Nat8 %96, 4
	store %Nat8 %97, %Nat8* %1
	br label %again_1
break_1:
	%98 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 16
	%99 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 16
	%100 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 12
	%101 = load %Byte, %Byte* %100
	%102 = call %Byte @rj_sbox(%Byte %101)
	%103 = load %Byte, %Byte* %99
	%104 = xor %Byte %103, %102
	store %Byte %104, %Byte* %98
	%105 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 17
	%106 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 17
	%107 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 13
	%108 = load %Byte, %Byte* %107
	%109 = call %Byte @rj_sbox(%Byte %108)
	%110 = load %Byte, %Byte* %106
	%111 = xor %Byte %110, %109
	store %Byte %111, %Byte* %105
	%112 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 18
	%113 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 18
	%114 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 14
	%115 = load %Byte, %Byte* %114
	%116 = call %Byte @rj_sbox(%Byte %115)
	%117 = load %Byte, %Byte* %113
	%118 = xor %Byte %117, %116
	store %Byte %118, %Byte* %112
	%119 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 19
	%120 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 19
	%121 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 15
	%122 = load %Byte, %Byte* %121
	%123 = call %Byte @rj_sbox(%Byte %122)
	%124 = load %Byte, %Byte* %120
	%125 = xor %Byte %124, %123
	store %Byte %125, %Byte* %119
	store %Nat8 20, %Nat8* %1
; while_2
	br label %again_2
again_2:
	%126 = load %Nat8, %Nat8* %1
	%127 = icmp ult %Nat8 %126, 32
	br %Bool %127 , label %body_2, label %break_2
body_2:
	%128 = load %Nat8, %Nat8* %1
	%129 = add %Nat8 %128, 0
	%130 = zext %Nat8 %129 to %Nat32
	%131 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %130
	%132 = load %Nat8, %Nat8* %1
	%133 = add %Nat8 %132, 0
	%134 = zext %Nat8 %133 to %Nat32
	%135 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %134
	%136 = load %Nat8, %Nat8* %1
	%137 = sub %Nat8 %136, 4
	%138 = zext %Nat8 %137 to %Nat32
	%139 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %138
	%140 = load %Byte, %Byte* %135
	%141 = load %Byte, %Byte* %139
	%142 = xor %Byte %140, %141
	store %Byte %142, %Byte* %131
	%143 = load %Nat8, %Nat8* %1
	%144 = add %Nat8 %143, 1
	%145 = zext %Nat8 %144 to %Nat32
	%146 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %145
	%147 = load %Nat8, %Nat8* %1
	%148 = add %Nat8 %147, 1
	%149 = zext %Nat8 %148 to %Nat32
	%150 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %149
	%151 = load %Nat8, %Nat8* %1
	%152 = sub %Nat8 %151, 3
	%153 = zext %Nat8 %152 to %Nat32
	%154 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %153
	%155 = load %Byte, %Byte* %150
	%156 = load %Byte, %Byte* %154
	%157 = xor %Byte %155, %156
	store %Byte %157, %Byte* %146
	%158 = load %Nat8, %Nat8* %1
	%159 = add %Nat8 %158, 2
	%160 = zext %Nat8 %159 to %Nat32
	%161 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %160
	%162 = load %Nat8, %Nat8* %1
	%163 = add %Nat8 %162, 2
	%164 = zext %Nat8 %163 to %Nat32
	%165 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %164
	%166 = load %Nat8, %Nat8* %1
	%167 = sub %Nat8 %166, 2
	%168 = zext %Nat8 %167 to %Nat32
	%169 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %168
	%170 = load %Byte, %Byte* %165
	%171 = load %Byte, %Byte* %169
	%172 = xor %Byte %170, %171
	store %Byte %172, %Byte* %161
	%173 = load %Nat8, %Nat8* %1
	%174 = add %Nat8 %173, 3
	%175 = zext %Nat8 %174 to %Nat32
	%176 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %175
	%177 = load %Nat8, %Nat8* %1
	%178 = add %Nat8 %177, 3
	%179 = zext %Nat8 %178 to %Nat32
	%180 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %179
	%181 = load %Nat8, %Nat8* %1
	%182 = sub %Nat8 %181, 1
	%183 = zext %Nat8 %182 to %Nat32
	%184 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %183
	%185 = load %Byte, %Byte* %180
	%186 = load %Byte, %Byte* %184
	%187 = xor %Byte %185, %186
	store %Byte %187, %Byte* %176
	%188 = load %Nat8, %Nat8* %1
	%189 = add %Nat8 %188, 4
	store %Nat8 %189, %Nat8* %1
	br label %again_2
break_2:
	ret void
}

define internal void @expandDecKey(%aes256_Key* %k, %Byte* %rc) {
	%1 = alloca %Nat8, align 1
	store %Nat8 28, %Nat8* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat8, %Nat8* %1
	%3 = icmp ugt %Nat8 %2, 16
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat8, %Nat8* %1
	%5 = add %Nat8 %4, 0
	%6 = zext %Nat8 %5 to %Nat32
	%7 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %6
	%8 = load %Nat8, %Nat8* %1
	%9 = add %Nat8 %8, 0
	%10 = zext %Nat8 %9 to %Nat32
	%11 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %10
	%12 = load %Nat8, %Nat8* %1
	%13 = sub %Nat8 %12, 4
	%14 = zext %Nat8 %13 to %Nat32
	%15 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %14
	%16 = load %Byte, %Byte* %11
	%17 = load %Byte, %Byte* %15
	%18 = xor %Byte %16, %17
	store %Byte %18, %Byte* %7
	%19 = load %Nat8, %Nat8* %1
	%20 = add %Nat8 %19, 1
	%21 = zext %Nat8 %20 to %Nat32
	%22 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %21
	%23 = load %Nat8, %Nat8* %1
	%24 = add %Nat8 %23, 1
	%25 = zext %Nat8 %24 to %Nat32
	%26 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %25
	%27 = load %Nat8, %Nat8* %1
	%28 = sub %Nat8 %27, 3
	%29 = zext %Nat8 %28 to %Nat32
	%30 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %29
	%31 = load %Byte, %Byte* %26
	%32 = load %Byte, %Byte* %30
	%33 = xor %Byte %31, %32
	store %Byte %33, %Byte* %22
	%34 = load %Nat8, %Nat8* %1
	%35 = add %Nat8 %34, 2
	%36 = zext %Nat8 %35 to %Nat32
	%37 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %36
	%38 = load %Nat8, %Nat8* %1
	%39 = add %Nat8 %38, 2
	%40 = zext %Nat8 %39 to %Nat32
	%41 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %40
	%42 = load %Nat8, %Nat8* %1
	%43 = sub %Nat8 %42, 2
	%44 = zext %Nat8 %43 to %Nat32
	%45 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %44
	%46 = load %Byte, %Byte* %41
	%47 = load %Byte, %Byte* %45
	%48 = xor %Byte %46, %47
	store %Byte %48, %Byte* %37
	%49 = load %Nat8, %Nat8* %1
	%50 = add %Nat8 %49, 3
	%51 = zext %Nat8 %50 to %Nat32
	%52 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %51
	%53 = load %Nat8, %Nat8* %1
	%54 = add %Nat8 %53, 3
	%55 = zext %Nat8 %54 to %Nat32
	%56 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %55
	%57 = load %Nat8, %Nat8* %1
	%58 = sub %Nat8 %57, 1
	%59 = zext %Nat8 %58 to %Nat32
	%60 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %59
	%61 = load %Byte, %Byte* %56
	%62 = load %Byte, %Byte* %60
	%63 = xor %Byte %61, %62
	store %Byte %63, %Byte* %52
	%64 = load %Nat8, %Nat8* %1
	%65 = sub %Nat8 %64, 4
	store %Nat8 %65, %Nat8* %1
	br label %again_1
break_1:
	%66 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 16
	%67 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 16
	%68 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 12
	%69 = load %Byte, %Byte* %68
	%70 = call %Byte @rj_sbox(%Byte %69)
	%71 = load %Byte, %Byte* %67
	%72 = xor %Byte %71, %70
	store %Byte %72, %Byte* %66
	%73 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 17
	%74 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 17
	%75 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 13
	%76 = load %Byte, %Byte* %75
	%77 = call %Byte @rj_sbox(%Byte %76)
	%78 = load %Byte, %Byte* %74
	%79 = xor %Byte %78, %77
	store %Byte %79, %Byte* %73
	%80 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 18
	%81 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 18
	%82 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 14
	%83 = load %Byte, %Byte* %82
	%84 = call %Byte @rj_sbox(%Byte %83)
	%85 = load %Byte, %Byte* %81
	%86 = xor %Byte %85, %84
	store %Byte %86, %Byte* %80
	%87 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 19
	%88 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 19
	%89 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 15
	%90 = load %Byte, %Byte* %89
	%91 = call %Byte @rj_sbox(%Byte %90)
	%92 = load %Byte, %Byte* %88
	%93 = xor %Byte %92, %91
	store %Byte %93, %Byte* %87
	store %Nat8 12, %Nat8* %1
; while_2
	br label %again_2
again_2:
	%94 = load %Nat8, %Nat8* %1
	%95 = icmp ugt %Nat8 %94, 0
	br %Bool %95 , label %body_2, label %break_2
body_2:
	%96 = load %Nat8, %Nat8* %1
	%97 = add %Nat8 %96, 0
	%98 = zext %Nat8 %97 to %Nat32
	%99 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %98
	%100 = load %Nat8, %Nat8* %1
	%101 = add %Nat8 %100, 0
	%102 = zext %Nat8 %101 to %Nat32
	%103 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %102
	%104 = load %Nat8, %Nat8* %1
	%105 = sub %Nat8 %104, 4
	%106 = zext %Nat8 %105 to %Nat32
	%107 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %106
	%108 = load %Byte, %Byte* %103
	%109 = load %Byte, %Byte* %107
	%110 = xor %Byte %108, %109
	store %Byte %110, %Byte* %99
	%111 = load %Nat8, %Nat8* %1
	%112 = add %Nat8 %111, 1
	%113 = zext %Nat8 %112 to %Nat32
	%114 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %113
	%115 = load %Nat8, %Nat8* %1
	%116 = add %Nat8 %115, 1
	%117 = zext %Nat8 %116 to %Nat32
	%118 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %117
	%119 = load %Nat8, %Nat8* %1
	%120 = sub %Nat8 %119, 3
	%121 = zext %Nat8 %120 to %Nat32
	%122 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %121
	%123 = load %Byte, %Byte* %118
	%124 = load %Byte, %Byte* %122
	%125 = xor %Byte %123, %124
	store %Byte %125, %Byte* %114
	%126 = load %Nat8, %Nat8* %1
	%127 = add %Nat8 %126, 2
	%128 = zext %Nat8 %127 to %Nat32
	%129 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %128
	%130 = load %Nat8, %Nat8* %1
	%131 = add %Nat8 %130, 2
	%132 = zext %Nat8 %131 to %Nat32
	%133 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %132
	%134 = load %Nat8, %Nat8* %1
	%135 = sub %Nat8 %134, 2
	%136 = zext %Nat8 %135 to %Nat32
	%137 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %136
	%138 = load %Byte, %Byte* %133
	%139 = load %Byte, %Byte* %137
	%140 = xor %Byte %138, %139
	store %Byte %140, %Byte* %129
	%141 = load %Nat8, %Nat8* %1
	%142 = add %Nat8 %141, 3
	%143 = zext %Nat8 %142 to %Nat32
	%144 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %143
	%145 = load %Nat8, %Nat8* %1
	%146 = add %Nat8 %145, 3
	%147 = zext %Nat8 %146 to %Nat32
	%148 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %147
	%149 = load %Nat8, %Nat8* %1
	%150 = sub %Nat8 %149, 1
	%151 = zext %Nat8 %150 to %Nat32
	%152 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Nat32 %151
	%153 = load %Byte, %Byte* %148
	%154 = load %Byte, %Byte* %152
	%155 = xor %Byte %153, %154
	store %Byte %155, %Byte* %144
	%156 = load %Nat8, %Nat8* %1
	%157 = sub %Nat8 %156, 4
	store %Nat8 %157, %Nat8* %1
	br label %again_2
break_2:
	%158 = alloca %Word8, align 1
	%159 = bitcast i8 0 to %Word8
	store %Word8 %159, %Word8* %158
; if_0
	%160 = bitcast i8 1 to %Byte
	%161 = load %Byte, %Byte* %rc
	%162 = and %Byte %161, %160
	%163 = bitcast i8 0 to %Byte
	%164 = icmp ne %Byte %162, %163
	br %Bool %164 , label %then_0, label %endif_0
then_0:
	%165 = bitcast i8 141 to %Word8
	store %Word8 %165, %Word8* %158
	br label %endif_0
endif_0:
	%166 = load %Byte, %Byte* %rc
	%167 = bitcast i8 1 to %Byte
	%168 = lshr %Byte %166, %167
	%169 = load %Word8, %Word8* %158
	%170 = xor %Byte %168, %169
	store %Byte %170, %Byte* %rc
	%171 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 0
	%172 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 0
	%173 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 29
	%174 = load %Byte, %Byte* %173
	%175 = call %Byte @rj_sbox(%Byte %174)
	%176 = load %Byte, %Byte* %rc
	%177 = xor %Byte %175, %176
	%178 = load %Byte, %Byte* %172
	%179 = xor %Byte %178, %177
	store %Byte %179, %Byte* %171
	%180 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 1
	%181 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 1
	%182 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 30
	%183 = load %Byte, %Byte* %182
	%184 = call %Byte @rj_sbox(%Byte %183)
	%185 = load %Byte, %Byte* %181
	%186 = xor %Byte %185, %184
	store %Byte %186, %Byte* %180
	%187 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 2
	%188 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 2
	%189 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 31
	%190 = load %Byte, %Byte* %189
	%191 = call %Byte @rj_sbox(%Byte %190)
	%192 = load %Byte, %Byte* %188
	%193 = xor %Byte %192, %191
	store %Byte %193, %Byte* %187
	%194 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 3
	%195 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 3
	%196 = getelementptr %aes256_Key, %aes256_Key* %k, %Int32 0, %Int32 28
	%197 = load %Byte, %Byte* %196
	%198 = call %Byte @rj_sbox(%Byte %197)
	%199 = load %Byte, %Byte* %195
	%200 = xor %Byte %199, %198
	store %Byte %200, %Byte* %194
	ret void
}

define %aes256_Result @aes256_init(%aes256_Context* %ctx, %aes256_Key* %key) {
; if_0
	%1 = icmp eq %aes256_Context* %ctx, null
	%2 = icmp eq %aes256_Key* %key, null
	%3 = or %Bool %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = bitcast i8 1 to %aes256_Result
	ret %aes256_Result %4
	br label %endif_0
endif_0:
	%6 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 2
	%7 = load %aes256_Key, %aes256_Key* %key
	%8 = zext i8 32 to %Nat32
	store %aes256_Key %7, %aes256_Key* %6
	%9 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 1
	%10 = load %aes256_Key, %aes256_Key* %key
	%11 = zext i8 32 to %Nat32
	store %aes256_Key %10, %aes256_Key* %9
	%12 = alloca %Byte, align 1
	%13 = bitcast i8 1 to %Byte
	store %Byte %13, %Byte* %12
	%14 = alloca %Nat8, align 1
	store %Nat8 0, %Nat8* %14
; while_1
	br label %again_1
again_1:
	%15 = load %Nat8, %Nat8* %14
	%16 = icmp ult %Nat8 %15, 7
	br %Bool %16 , label %body_1, label %break_1
body_1:
	%17 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 2
	call void @expandEncKey(%aes256_Key* %17, %Byte* %12)
	%18 = load %Nat8, %Nat8* %14
	%19 = add %Nat8 %18, 1
	store %Nat8 %19, %Nat8* %14
	br label %again_1
break_1:
	%20 = bitcast i8 0 to %aes256_Result
	ret %aes256_Result %20
}

define %aes256_Result @aes256_encrypt_ecb(%aes256_Context* %ctx, %aes256_Block* %block) {
; if_0
	%1 = icmp eq %aes256_Context* %ctx, null
	%2 = icmp eq %aes256_Block* %block, null
	%3 = or %Bool %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = bitcast i8 1 to %aes256_Result
	ret %aes256_Result %4
	br label %endif_0
endif_0:
	%6 = alloca %Byte, align 1
	%7 = bitcast i8 1 to %Byte
	store %Byte %7, %Byte* %6
	%8 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 1
	%9 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	call void @addRoundKeyCpy(%aes256_Block* %block, %aes256_Key* %8, %aes256_Key* %9)
	%10 = alloca %Nat8, align 1
	store %Nat8 0, %Nat8* %10
; while_1
	br label %again_1
again_1:
	%11 = load %Nat8, %Nat8* %10
	%12 = icmp ult %Nat8 %11, 13
	br %Bool %12 , label %body_1, label %break_1
body_1:
	%13 = load %Nat8, %Nat8* %10
	%14 = add %Nat8 %13, 1
	store %Nat8 %14, %Nat8* %10
	call void @subBytes(%aes256_Block* %block)
	call void @shiftRows(%aes256_Block* %block)
	call void @mixColumns(%aes256_Block* %block)
; if_1
	%15 = load %Nat8, %Nat8* %10
	%16 = bitcast %Nat8 %15 to %Word8
	%17 = bitcast i8 1 to %Word8
	%18 = and %Word8 %16, %17
	%19 = bitcast i8 1 to %Word8
	%20 = icmp eq %Word8 %18, %19
	br %Bool %20 , label %then_1, label %else_1
then_1:
	%21 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	%22 = zext i8 16 to %Nat32
	%23 = getelementptr %aes256_Key, %aes256_Key* %21, %Int32 0, %Nat32 %22
	%24 = bitcast %Byte* %23 to [16 x %Byte]*
	call void @addRoundKey(%aes256_Block* %block, [16 x %Byte]* %24)
	br label %endif_1
else_1:
	%25 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	call void @expandEncKey(%aes256_Key* %25, %Byte* %6)
	%26 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	%27 = zext i8 0 to %Nat32
	%28 = getelementptr %aes256_Key, %aes256_Key* %26, %Int32 0, %Nat32 %27
	%29 = bitcast %Byte* %28 to [16 x %Byte]*
	call void @addRoundKey(%aes256_Block* %block, [16 x %Byte]* %29)
	br label %endif_1
endif_1:
	br label %again_1
break_1:
	call void @subBytes(%aes256_Block* %block)
	call void @shiftRows(%aes256_Block* %block)
	%30 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	call void @expandEncKey(%aes256_Key* %30, %Byte* %6)
	%31 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	%32 = zext i8 0 to %Nat32
	%33 = getelementptr %aes256_Key, %aes256_Key* %31, %Int32 0, %Nat32 %32
	%34 = bitcast %Byte* %33 to [16 x %Byte]*
	call void @addRoundKey(%aes256_Block* %block, [16 x %Byte]* %34)
	%35 = bitcast i8 0 to %aes256_Result
	ret %aes256_Result %35
}

define %aes256_Result @aes256_decrypt_ecb(%aes256_Context* %ctx, %aes256_Block* %block) {
; if_0
	%1 = icmp eq %aes256_Context* %ctx, null
	%2 = icmp eq %aes256_Block* %block, null
	%3 = or %Bool %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = bitcast i8 1 to %aes256_Result
	ret %aes256_Result %4
	br label %endif_0
endif_0:
	%6 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 2
	%7 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	call void @addRoundKeyCpy(%aes256_Block* %block, %aes256_Key* %6, %aes256_Key* %7)
	call void @shiftRowsInv(%aes256_Block* %block)
	call void @subBytesInv(%aes256_Block* %block)
	%8 = alloca %Byte, align 1
	%9 = bitcast i8 128 to %Byte
	store %Byte %9, %Byte* %8
	%10 = alloca %Nat8, align 1
	store %Nat8 13, %Nat8* %10
; while_1
	br label %again_1
again_1:
	%11 = load %Nat8, %Nat8* %10
	%12 = icmp ugt %Nat8 %11, 0
	br %Bool %12 , label %body_1, label %break_1
body_1:
; if_1
	%13 = load %Nat8, %Nat8* %10
	%14 = bitcast %Nat8 %13 to %Word8
	%15 = bitcast i8 1 to %Word8
	%16 = and %Word8 %14, %15
	%17 = bitcast i8 1 to %Word8
	%18 = icmp eq %Word8 %16, %17
	br %Bool %18 , label %then_1, label %else_1
then_1:
	%19 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	call void @expandDecKey(%aes256_Key* %19, %Byte* %8)
	%20 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	%21 = zext i8 16 to %Nat32
	%22 = getelementptr %aes256_Key, %aes256_Key* %20, %Int32 0, %Nat32 %21
	%23 = bitcast %Byte* %22 to [16 x %Byte]*
	call void @addRoundKey(%aes256_Block* %block, [16 x %Byte]* %23)
	br label %endif_1
else_1:
	%24 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	%25 = zext i8 0 to %Nat32
	%26 = getelementptr %aes256_Key, %aes256_Key* %24, %Int32 0, %Nat32 %25
	%27 = bitcast %Byte* %26 to [16 x %Byte]*
	call void @addRoundKey(%aes256_Block* %block, [16 x %Byte]* %27)
	br label %endif_1
endif_1:
	call void @mixColumnsInv(%aes256_Block* %block)
	call void @shiftRowsInv(%aes256_Block* %block)
	call void @subBytesInv(%aes256_Block* %block)
	%28 = load %Nat8, %Nat8* %10
	%29 = sub %Nat8 %28, 1
	store %Nat8 %29, %Nat8* %10
	br label %again_1
break_1:
	%30 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	%31 = zext i8 0 to %Nat32
	%32 = getelementptr %aes256_Key, %aes256_Key* %30, %Int32 0, %Nat32 %31
	%33 = bitcast %Byte* %32 to [16 x %Byte]*
	call void @addRoundKey(%aes256_Block* %block, [16 x %Byte]* %33)
	%34 = bitcast i8 0 to %aes256_Result
	ret %aes256_Result %34
}

define %aes256_Result @aes256_deinit(%aes256_Context* %ctx) {
; if_0
	%1 = icmp eq %aes256_Context* %ctx, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	%2 = bitcast i8 1 to %aes256_Result
	ret %aes256_Result %2
	br label %endif_0
endif_0:
	%4 = alloca %aes256_Key, align 1
	%5 = zext i8 32 to %Nat32
	%6 = mul %Nat32 %5, 1
	%7 = bitcast %aes256_Key* %4 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %7, i8 0, %Nat32 %6, i1 0)
	%8 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 0
	%9 = load %aes256_Key, %aes256_Key* %4
	%10 = zext i8 32 to %Nat32
	store %aes256_Key %9, %aes256_Key* %8
	%11 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 1
	%12 = load %aes256_Key, %aes256_Key* %4
	%13 = zext i8 32 to %Nat32
	store %aes256_Key %12, %aes256_Key* %11
	%14 = getelementptr %aes256_Context, %aes256_Context* %ctx, %Int32 0, %Int32 2
	%15 = load %aes256_Key, %aes256_Key* %4
	%16 = zext i8 32 to %Nat32
	store %aes256_Key %15, %aes256_Key* %14
	%17 = bitcast i8 0 to %aes256_Result
	ret %aes256_Result %17
}


