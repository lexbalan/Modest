
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8
%Char = type i8
%ConstChar = type %Char
%SignedChar = type i8
%UnsignedChar = type i8
%Short = type i16
%UnsignedShort = type i16
%Int = type i32
%UnsignedInt = type i32
%LongInt = type i64
%UnsignedLongInt = type i64
%Long = type i64
%UnsignedLong = type i64
%LongLong = type i64
%UnsignedLongLong = type i64
%LongLongInt = type i64
%UnsignedLongLongInt = type i64
%Float = type double
%Double = type double
%LongDouble = type double


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(%SizeT %size)
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare %Int @memcmp(i8* %ptr1, i8* %ptr2, %SizeT %num)
declare void @free(i8* %ptr)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)


declare %Int @ftruncate(%Int %fd, %OffT %size)
















declare %Int @creat(%Str* %path, %ModeT %mode)
declare %Int @open(%Str* %path, %Int %oflags)
declare %Int @read(%Int %fd, i8* %buf, i32 %len)
declare %Int @write(%Int %fd, i8* %buf, i32 %len)
declare %OffT @lseek(%Int %fd, %OffT %offset, %Int %whence)
declare %Int @close(%Int %fd)
declare void @exit(%Int %rc)


declare %DIR* @opendir(%Str* %name)
declare %Int @closedir(%DIR* %dir)


declare %Str* @getcwd(%Str* %buf, %SizeT %size)
declare %Str* @getenv(%Str* %name)


declare void @bzero(i8* %s, %SizeT %n)


declare void @bcopy(i8* %src, i8* %dst, %SizeT %n)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/sha256.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/sha256.cm




%Context = type {
	[64 x i8],
	i32,
	i64,
	[8 x i32]
}


define i32 @rotleft(i32 %a, i32 %b) {
    %1 = shl i32 %a, %b
    %2 = sub i32 32, %b
    %3 = lshr i32 %a, %2
    %4 = or i32 %1, %3
    ret i32 %4
}

define i32 @rotright(i32 %a, i32 %b) {
    %1 = lshr i32 %a, %b
    %2 = sub i32 32, %b
    %3 = shl i32 %a, %2
    %4 = or i32 %1, %3
    ret i32 %4
}

define i32 @ch(i32 %x, i32 %y, i32 %z) {
    %1 = and i32 %x, %y
    %2 = xor i32 %x, -1
    %3 = and i32 %2, %z
    %4 = xor i32 %1, %3
    ret i32 %4
}

define i32 @maj(i32 %x, i32 %y, i32 %z) {
    %1 = and i32 %x, %y
    %2 = and i32 %x, %z
    %3 = and i32 %y, %z
    %4 = xor i32 %2, %3
    %5 = xor i32 %1, %4
    ret i32 %5
}

define i32 @ep0(i32 %x) {
    %1 = call i32 (i32, i32) @rotright(i32 %x, i32 2)
    %2 = call i32 (i32, i32) @rotright(i32 %x, i32 13)
    %3 = call i32 (i32, i32) @rotright(i32 %x, i32 22)
    %4 = xor i32 %2, %3
    %5 = xor i32 %1, %4
    ret i32 %5
}

define i32 @ep1(i32 %x) {
    %1 = call i32 (i32, i32) @rotright(i32 %x, i32 6)
    %2 = call i32 (i32, i32) @rotright(i32 %x, i32 11)
    %3 = call i32 (i32, i32) @rotright(i32 %x, i32 25)
    %4 = xor i32 %2, %3
    %5 = xor i32 %1, %4
    ret i32 %5
}

define i32 @sig0(i32 %x) {
    %1 = call i32 (i32, i32) @rotright(i32 %x, i32 7)
    %2 = call i32 (i32, i32) @rotright(i32 %x, i32 18)
    %3 = lshr i32 %x, 3
    %4 = xor i32 %2, %3
    %5 = xor i32 %1, %4
    ret i32 %5
}

define i32 @sig1(i32 %x) {
    %1 = call i32 (i32, i32) @rotright(i32 %x, i32 17)
    %2 = call i32 (i32, i32) @rotright(i32 %x, i32 19)
    %3 = lshr i32 %x, 10
    %4 = xor i32 %2, %3
    %5 = xor i32 %1, %4
    ret i32 %5
}



define void @sha256_contextInit(%Context* %ctx) {
    %1 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %2 = insertvalue [8 x i32] zeroinitializer, i32 1779033703, 0
    %3 = insertvalue [8 x i32] %2, i32 3144134277, 1
    %4 = insertvalue [8 x i32] %3, i32 1013904242, 2
    %5 = insertvalue [8 x i32] %4, i32 2773480762, 3
    %6 = insertvalue [8 x i32] %5, i32 1359893119, 4
    %7 = insertvalue [8 x i32] %6, i32 2600822924, 5
    %8 = insertvalue [8 x i32] %7, i32 528734635, 6
    %9 = insertvalue [8 x i32] %8, i32 1541459225, 7
    store [8 x i32] %9, [8 x i32]* %1
    ret void
}



define void @sha256_transform(%Context* %ctx, [0 x i8]* %data) {
    %1 = alloca [64 x i32]
    %2 = insertvalue [64 x i32] zeroinitializer, i32 0, 0
    %3 = insertvalue [64 x i32] %2, i32 0, 1
    %4 = insertvalue [64 x i32] %3, i32 0, 2
    %5 = insertvalue [64 x i32] %4, i32 0, 3
    %6 = insertvalue [64 x i32] %5, i32 0, 4
    %7 = insertvalue [64 x i32] %6, i32 0, 5
    %8 = insertvalue [64 x i32] %7, i32 0, 6
    %9 = insertvalue [64 x i32] %8, i32 0, 7
    %10 = insertvalue [64 x i32] %9, i32 0, 8
    %11 = insertvalue [64 x i32] %10, i32 0, 9
    %12 = insertvalue [64 x i32] %11, i32 0, 10
    %13 = insertvalue [64 x i32] %12, i32 0, 11
    %14 = insertvalue [64 x i32] %13, i32 0, 12
    %15 = insertvalue [64 x i32] %14, i32 0, 13
    %16 = insertvalue [64 x i32] %15, i32 0, 14
    %17 = insertvalue [64 x i32] %16, i32 0, 15
    %18 = insertvalue [64 x i32] %17, i32 0, 16
    %19 = insertvalue [64 x i32] %18, i32 0, 17
    %20 = insertvalue [64 x i32] %19, i32 0, 18
    %21 = insertvalue [64 x i32] %20, i32 0, 19
    %22 = insertvalue [64 x i32] %21, i32 0, 20
    %23 = insertvalue [64 x i32] %22, i32 0, 21
    %24 = insertvalue [64 x i32] %23, i32 0, 22
    %25 = insertvalue [64 x i32] %24, i32 0, 23
    %26 = insertvalue [64 x i32] %25, i32 0, 24
    %27 = insertvalue [64 x i32] %26, i32 0, 25
    %28 = insertvalue [64 x i32] %27, i32 0, 26
    %29 = insertvalue [64 x i32] %28, i32 0, 27
    %30 = insertvalue [64 x i32] %29, i32 0, 28
    %31 = insertvalue [64 x i32] %30, i32 0, 29
    %32 = insertvalue [64 x i32] %31, i32 0, 30
    %33 = insertvalue [64 x i32] %32, i32 0, 31
    %34 = insertvalue [64 x i32] %33, i32 0, 32
    %35 = insertvalue [64 x i32] %34, i32 0, 33
    %36 = insertvalue [64 x i32] %35, i32 0, 34
    %37 = insertvalue [64 x i32] %36, i32 0, 35
    %38 = insertvalue [64 x i32] %37, i32 0, 36
    %39 = insertvalue [64 x i32] %38, i32 0, 37
    %40 = insertvalue [64 x i32] %39, i32 0, 38
    %41 = insertvalue [64 x i32] %40, i32 0, 39
    %42 = insertvalue [64 x i32] %41, i32 0, 40
    %43 = insertvalue [64 x i32] %42, i32 0, 41
    %44 = insertvalue [64 x i32] %43, i32 0, 42
    %45 = insertvalue [64 x i32] %44, i32 0, 43
    %46 = insertvalue [64 x i32] %45, i32 0, 44
    %47 = insertvalue [64 x i32] %46, i32 0, 45
    %48 = insertvalue [64 x i32] %47, i32 0, 46
    %49 = insertvalue [64 x i32] %48, i32 0, 47
    %50 = insertvalue [64 x i32] %49, i32 0, 48
    %51 = insertvalue [64 x i32] %50, i32 0, 49
    %52 = insertvalue [64 x i32] %51, i32 0, 50
    %53 = insertvalue [64 x i32] %52, i32 0, 51
    %54 = insertvalue [64 x i32] %53, i32 0, 52
    %55 = insertvalue [64 x i32] %54, i32 0, 53
    %56 = insertvalue [64 x i32] %55, i32 0, 54
    %57 = insertvalue [64 x i32] %56, i32 0, 55
    %58 = insertvalue [64 x i32] %57, i32 0, 56
    %59 = insertvalue [64 x i32] %58, i32 0, 57
    %60 = insertvalue [64 x i32] %59, i32 0, 58
    %61 = insertvalue [64 x i32] %60, i32 0, 59
    %62 = insertvalue [64 x i32] %61, i32 0, 60
    %63 = insertvalue [64 x i32] %62, i32 0, 61
    %64 = insertvalue [64 x i32] %63, i32 0, 62
    %65 = insertvalue [64 x i32] %64, i32 0, 63
    store [64 x i32] %65, [64 x i32]* %1
    %66 = alloca i32
    %67 = zext i8 0 to i32
    store i32 %67, i32* %66
    %68 = alloca i32
    %69 = zext i8 0 to i32
    store i32 %69, i32* %68
    br label %again_1
again_1:
    %70 = load i32, i32* %66
    %71 = icmp ult i32 %70, 16
    br i1 %71 , label %body_1, label %break_1
body_1:
    %72 = load i32, i32* %68
    %73 = add i32 %72, 0
    %74 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %73
    %75 = load i8, i8* %74
    %76 = zext i8 %75 to i32
    %77 = shl i32 %76, 24
    %78 = load i32, i32* %68
    %79 = add i32 %78, 1
    %80 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %79
    %81 = load i8, i8* %80
    %82 = zext i8 %81 to i32
    %83 = shl i32 %82, 16
    %84 = load i32, i32* %68
    %85 = add i32 %84, 2
    %86 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %85
    %87 = load i8, i8* %86
    %88 = zext i8 %87 to i32
    %89 = shl i32 %88, 8
    %90 = load i32, i32* %68
    %91 = add i32 %90, 3
    %92 = getelementptr inbounds [0 x i8], [0 x i8]* %data, i32 0, i32 %91
    %93 = load i8, i8* %92
    %94 = zext i8 %93 to i32
    %95 = shl i32 %94, 0
    %96 = or i32 %89, %95
    %97 = or i32 %83, %96
    %98 = or i32 %77, %97
    %99 = load i32, i32* %66
    %100 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %99
    store i32 %98, i32* %100
    %101 = load i32, i32* %68
    %102 = add i32 %101, 4
    store i32 %102, i32* %68
    %103 = load i32, i32* %66
    %104 = add i32 %103, 1
    store i32 %104, i32* %66
    br label %again_1
break_1:
    br label %again_2
again_2:
    %105 = load i32, i32* %66
    %106 = icmp ult i32 %105, 64
    br i1 %106 , label %body_2, label %break_2
body_2:
    %107 = load i32, i32* %66
    %108 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %107
    %109 = load i32, i32* %66
    %110 = sub i32 %109, 2
    %111 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %110
    %112 = load i32, i32* %111
    %113 = call i32 (i32) @sig1(i32 %112)
    %114 = load i32, i32* %66
    %115 = sub i32 %114, 7
    %116 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %115
    %117 = load i32, i32* %116
    %118 = add i32 %113, %117
    %119 = load i32, i32* %66
    %120 = sub i32 %119, 15
    %121 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %120
    %122 = load i32, i32* %121
    %123 = call i32 (i32) @sig0(i32 %122)
    %124 = add i32 %118, %123
    %125 = load i32, i32* %66
    %126 = sub i32 %125, 16
    %127 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %126
    %128 = load i32, i32* %127
    %129 = add i32 %124, %128
    store i32 %129, i32* %108
    %130 = load i32, i32* %66
    %131 = add i32 %130, 1
    store i32 %131, i32* %66
    br label %again_2
break_2:
    %132 = alloca [8 x i32]
    %133 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %134 = bitcast [8 x i32]* %132 to i8*
    %135 = bitcast [8 x i32]* %133 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %134, i8* %135, i32 32, i1 0)
    store i32 0, i32* %66
    br label %again_3
again_3:
    %136 = load i32, i32* %66
    %137 = icmp ult i32 %136, 64
    br i1 %137 , label %body_3, label %break_3
body_3:
    %138 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 7
    %139 = load i32, i32* %138
    %140 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 4
    %141 = load i32, i32* %140
    %142 = call i32 (i32) @ep1(i32 %141)
    %143 = add i32 %139, %142
    %144 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 4
    %145 = load i32, i32* %144
    %146 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 5
    %147 = load i32, i32* %146
    %148 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 6
    %149 = load i32, i32* %148
    %150 = call i32 (i32, i32, i32) @ch(i32 %145, i32 %147, i32 %149)
    %151 = add i32 %143, %150
    %152 = load i32, i32* %66
    %153 = getelementptr inbounds [64 x i32], [64 x i32]* @k, i32 0, i32 %152
    %154 = load i32, i32* %153
    %155 = bitcast i32 %154 to i32
    %156 = add i32 %151, %155
    %157 = load i32, i32* %66
    %158 = getelementptr inbounds [64 x i32], [64 x i32]* %1, i32 0, i32 %157
    %159 = load i32, i32* %158
    %160 = add i32 %156, %159
    %161 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 0
    %162 = load i32, i32* %161
    %163 = call i32 (i32) @ep0(i32 %162)
    %164 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 0
    %165 = load i32, i32* %164
    %166 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 1
    %167 = load i32, i32* %166
    %168 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 2
    %169 = load i32, i32* %168
    %170 = call i32 (i32, i32, i32) @maj(i32 %165, i32 %167, i32 %169)
    %171 = add i32 %163, %170
    %172 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 7
    %173 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 6
    %174 = load i32, i32* %173
    store i32 %174, i32* %172
    %175 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 6
    %176 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 5
    %177 = load i32, i32* %176
    store i32 %177, i32* %175
    %178 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 5
    %179 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 4
    %180 = load i32, i32* %179
    store i32 %180, i32* %178
    %181 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 4
    %182 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 3
    %183 = load i32, i32* %182
    %184 = add i32 %183, %160
    store i32 %184, i32* %181
    %185 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 3
    %186 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 2
    %187 = load i32, i32* %186
    store i32 %187, i32* %185
    %188 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 2
    %189 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 1
    %190 = load i32, i32* %189
    store i32 %190, i32* %188
    %191 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 1
    %192 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 0
    %193 = load i32, i32* %192
    store i32 %193, i32* %191
    %194 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 0
    %195 = add i32 %160, %171
    store i32 %195, i32* %194
    %196 = load i32, i32* %66
    %197 = add i32 %196, 1
    store i32 %197, i32* %66
    br label %again_3
break_3:
    store i32 0, i32* %66
    br label %again_4
again_4:
    %198 = load i32, i32* %66
    %199 = icmp ult i32 %198, 8
    br i1 %199 , label %body_4, label %break_4
body_4:
    %200 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %201 = load i32, i32* %66
    %202 = getelementptr inbounds [8 x i32], [8 x i32]* %200, i32 0, i32 %201
    %203 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %204 = load i32, i32* %66
    %205 = getelementptr inbounds [8 x i32], [8 x i32]* %203, i32 0, i32 %204
    %206 = load i32, i32* %205
    %207 = load i32, i32* %66
    %208 = getelementptr inbounds [8 x i32], [8 x i32]* %132, i32 0, i32 %207
    %209 = load i32, i32* %208
    %210 = add i32 %206, %209
    store i32 %210, i32* %202
    %211 = load i32, i32* %66
    %212 = add i32 %211, 1
    store i32 %212, i32* %66
    br label %again_4
break_4:
    ret void
}

define void @sha256_update(%Context* %ctx, [0 x i8]* %msg, i32 %msg_len) {
    %1 = alloca i32
    %2 = zext i8 0 to i32
    store i32 %2, i32* %1
    br label %again_1
again_1:
    %3 = load i32, i32* %1
    %4 = icmp ult i32 %3, %msg_len
    br i1 %4 , label %body_1, label %break_1
body_1:
    %5 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %6 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
    %7 = load i32, i32* %6
    %8 = getelementptr inbounds [64 x i8], [64 x i8]* %5, i32 0, i32 %7
    %9 = load i32, i32* %1
    %10 = getelementptr inbounds [0 x i8], [0 x i8]* %msg, i32 0, i32 %9
    %11 = load i8, i8* %10
    store i8 %11, i8* %8
    %12 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
    %13 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
    %14 = load i32, i32* %13
    %15 = add i32 %14, 1
    store i32 %15, i32* %12
    %16 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
    %17 = load i32, i32* %16
    %18 = icmp eq i32 %17, 64
    br i1 %18 , label %then_0, label %endif_0
then_0:
    %19 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %20 = bitcast [64 x i8]* %19 to [0 x i8]*
    call void (%Context*, [0 x i8]*) @sha256_transform(%Context* %ctx, [0 x i8]* %20)
    %21 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %22 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %23 = load i64, i64* %22
    %24 = add i64 %23, 512
    store i64 %24, i64* %21
    %25 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
    store i32 0, i32* %25
    br label %endif_0
endif_0:
    %26 = load i32, i32* %1
    %27 = add i32 %26, 1
    store i32 %27, i32* %1
    br label %again_1
break_1:
    ret void
}

define void @sha256_final(%Context* %ctx, [32 x i8]* %out_hash) {
    %1 = alloca i32
    %2 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
    %3 = load i32, i32* %2
    store i32 %3, i32* %1
    ; Pad whatever data is left in the buffer.
    %4 = alloca i32
    %5 = zext i8 64 to i32
    store i32 %5, i32* %4
    %6 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
    %7 = load i32, i32* %6
    %8 = icmp ult i32 %7, 56
    br i1 %8 , label %then_0, label %endif_0
then_0:
    store i32 56, i32* %4
    br label %endif_0
endif_0:
    %9 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %10 = load i32, i32* %1
    %11 = getelementptr inbounds [64 x i8], [64 x i8]* %9, i32 0, i32 %10
    store i8 128, i8* %11
    %12 = load i32, i32* %1
    %13 = add i32 %12, 1
    store i32 %13, i32* %1
    %14 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %15 = load i32, i32* %1
    %16 = getelementptr inbounds [64 x i8], [64 x i8]* %14, i32 0, i32 %15
    %17 = bitcast i8* %16 to i8*
    %18 = load i32, i32* %4
    %19 = load i32, i32* %1
    %20 = sub i32 %18, %19
    %21 = zext i32 %20 to %SizeT
    %22 = call i8* (i8*, %Int, %SizeT) @memset(i8* %17, %Int 0, %SizeT %21)
    %23 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
    %24 = load i32, i32* %23
    %25 = icmp uge i32 %24, 56
    br i1 %25 , label %then_1, label %endif_1
then_1:
    %26 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %27 = bitcast [64 x i8]* %26 to [0 x i8]*
    call void (%Context*, [0 x i8]*) @sha256_transform(%Context* %ctx, [0 x i8]* %27)
    %28 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %29 = bitcast [64 x i8]* %28 to i8*
    %30 = call i8* (i8*, %Int, %SizeT) @memset(i8* %29, %Int 0, %SizeT 56)
    br label %endif_1
endif_1:
    ; Append to the padding the total message's length in bits and transform.
    %31 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %32 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %33 = load i64, i64* %32
    %34 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 1
    %35 = load i32, i32* %34
    %36 = zext i32 %35 to i64
    %37 = mul i64 %36, 8
    %38 = add i64 %33, %37
    store i64 %38, i64* %31
    %39 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %40 = getelementptr inbounds [64 x i8], [64 x i8]* %39, i32 0, i32 63
    %41 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %42 = load i64, i64* %41
    %43 = lshr i64 %42, 0
    %44 = trunc i64 %43 to i8
    store i8 %44, i8* %40
    %45 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %46 = getelementptr inbounds [64 x i8], [64 x i8]* %45, i32 0, i32 62
    %47 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %48 = load i64, i64* %47
    %49 = lshr i64 %48, 8
    %50 = trunc i64 %49 to i8
    store i8 %50, i8* %46
    %51 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %52 = getelementptr inbounds [64 x i8], [64 x i8]* %51, i32 0, i32 61
    %53 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %54 = load i64, i64* %53
    %55 = lshr i64 %54, 16
    %56 = trunc i64 %55 to i8
    store i8 %56, i8* %52
    %57 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %58 = getelementptr inbounds [64 x i8], [64 x i8]* %57, i32 0, i32 60
    %59 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %60 = load i64, i64* %59
    %61 = lshr i64 %60, 24
    %62 = trunc i64 %61 to i8
    store i8 %62, i8* %58
    %63 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %64 = getelementptr inbounds [64 x i8], [64 x i8]* %63, i32 0, i32 59
    %65 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %66 = load i64, i64* %65
    %67 = lshr i64 %66, 32
    %68 = trunc i64 %67 to i8
    store i8 %68, i8* %64
    %69 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %70 = getelementptr inbounds [64 x i8], [64 x i8]* %69, i32 0, i32 58
    %71 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %72 = load i64, i64* %71
    %73 = lshr i64 %72, 40
    %74 = trunc i64 %73 to i8
    store i8 %74, i8* %70
    %75 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %76 = getelementptr inbounds [64 x i8], [64 x i8]* %75, i32 0, i32 57
    %77 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %78 = load i64, i64* %77
    %79 = lshr i64 %78, 48
    %80 = trunc i64 %79 to i8
    store i8 %80, i8* %76
    %81 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %82 = getelementptr inbounds [64 x i8], [64 x i8]* %81, i32 0, i32 56
    %83 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 2
    %84 = load i64, i64* %83
    %85 = lshr i64 %84, 56
    %86 = trunc i64 %85 to i8
    store i8 %86, i8* %82
    %87 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 0
    %88 = bitcast [64 x i8]* %87 to [0 x i8]*
    call void (%Context*, [0 x i8]*) @sha256_transform(%Context* %ctx, [0 x i8]* %88)
    ; Since this implementation uses little endian byte ordering
    ; and SHA uses big endian, reverse all the bytes
    ; when copying the final state to the output hash.
    store i32 0, i32* %1
    br label %again_1
again_1:
    %89 = load i32, i32* %1
    %90 = icmp ult i32 %89, 4
    br i1 %90 , label %body_1, label %break_1
body_1:
    %91 = load i32, i32* %1
    %92 = mul i32 %91, 8
    %93 = sub i32 24, %92
    %94 = load i32, i32* %1
    %95 = add i32 %94, 0
    %96 = getelementptr inbounds [32 x i8], [32 x i8]* %out_hash, i32 0, i32 %95
    %97 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %98 = getelementptr inbounds [8 x i32], [8 x i32]* %97, i32 0, i32 0
    %99 = load i32, i32* %98
    %100 = lshr i32 %99, %93
    %101 = trunc i32 %100 to i8
    store i8 %101, i8* %96
    %102 = load i32, i32* %1
    %103 = add i32 %102, 4
    %104 = getelementptr inbounds [32 x i8], [32 x i8]* %out_hash, i32 0, i32 %103
    %105 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %106 = getelementptr inbounds [8 x i32], [8 x i32]* %105, i32 0, i32 1
    %107 = load i32, i32* %106
    %108 = lshr i32 %107, %93
    %109 = trunc i32 %108 to i8
    store i8 %109, i8* %104
    %110 = load i32, i32* %1
    %111 = add i32 %110, 8
    %112 = getelementptr inbounds [32 x i8], [32 x i8]* %out_hash, i32 0, i32 %111
    %113 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %114 = getelementptr inbounds [8 x i32], [8 x i32]* %113, i32 0, i32 2
    %115 = load i32, i32* %114
    %116 = lshr i32 %115, %93
    %117 = trunc i32 %116 to i8
    store i8 %117, i8* %112
    %118 = load i32, i32* %1
    %119 = add i32 %118, 12
    %120 = getelementptr inbounds [32 x i8], [32 x i8]* %out_hash, i32 0, i32 %119
    %121 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %122 = getelementptr inbounds [8 x i32], [8 x i32]* %121, i32 0, i32 3
    %123 = load i32, i32* %122
    %124 = lshr i32 %123, %93
    %125 = trunc i32 %124 to i8
    store i8 %125, i8* %120
    %126 = load i32, i32* %1
    %127 = add i32 %126, 16
    %128 = getelementptr inbounds [32 x i8], [32 x i8]* %out_hash, i32 0, i32 %127
    %129 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %130 = getelementptr inbounds [8 x i32], [8 x i32]* %129, i32 0, i32 4
    %131 = load i32, i32* %130
    %132 = lshr i32 %131, %93
    %133 = trunc i32 %132 to i8
    store i8 %133, i8* %128
    %134 = load i32, i32* %1
    %135 = add i32 %134, 20
    %136 = getelementptr inbounds [32 x i8], [32 x i8]* %out_hash, i32 0, i32 %135
    %137 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %138 = getelementptr inbounds [8 x i32], [8 x i32]* %137, i32 0, i32 5
    %139 = load i32, i32* %138
    %140 = lshr i32 %139, %93
    %141 = trunc i32 %140 to i8
    store i8 %141, i8* %136
    %142 = load i32, i32* %1
    %143 = add i32 %142, 24
    %144 = getelementptr inbounds [32 x i8], [32 x i8]* %out_hash, i32 0, i32 %143
    %145 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %146 = getelementptr inbounds [8 x i32], [8 x i32]* %145, i32 0, i32 6
    %147 = load i32, i32* %146
    %148 = lshr i32 %147, %93
    %149 = trunc i32 %148 to i8
    store i8 %149, i8* %144
    %150 = load i32, i32* %1
    %151 = add i32 %150, 28
    %152 = getelementptr inbounds [32 x i8], [32 x i8]* %out_hash, i32 0, i32 %151
    %153 = getelementptr inbounds %Context, %Context* %ctx, i32 0, i32 3
    %154 = getelementptr inbounds [8 x i32], [8 x i32]* %153, i32 0, i32 7
    %155 = load i32, i32* %154
    %156 = lshr i32 %155, %93
    %157 = trunc i32 %156 to i8
    store i8 %157, i8* %152
    %158 = load i32, i32* %1
    %159 = add i32 %158, 1
    store i32 %159, i32* %1
    br label %again_1
break_1:
    ret void
}

define void @sha256_doHash([0 x i8]* %msg, i32 %msg_len, [32 x i8]* %out_hash) {
    %1 = alloca %Context
    store %Context zeroinitializer, %Context* %1
    call void (%Context*) @sha256_contextInit(%Context* %1)
    call void (%Context*, [0 x i8]*, i32) @sha256_update(%Context* %1, [0 x i8]* %msg, i32 %msg_len)
    call void (%Context*, [32 x i8]*) @sha256_final(%Context* %1, [32 x i8]* %out_hash)
    ret void
}


