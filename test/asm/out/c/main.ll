; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

@.str = private unnamed_addr constant [21 x i8] c"sumsub64 sum = %lld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"sumsub64 sub = %lld\0A\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"inline asm test\0A\00", align 1
@.str.3 = private unnamed_addr constant [29 x i8] c"sumsub64(%lld, %lld) = %lld\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i64 @sumsub64(i64 noundef %0, i64 noundef %1) #0 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  store i64 %0, i64* %3, align 8
  store i64 %1, i64* %4, align 8
  %7 = load i64, i64* %3, align 8
  %8 = load i64, i64* %4, align 8
  %9 = call { i64, i64 } asm sideeffect "add $0, $2, $3\0Asub $1, $2, $3\0A", "=r,=r,r,r,~{cc}"(i64 %7, i64 %8) #2, !srcloc !9
  %10 = extractvalue { i64, i64 } %9, 0
  %11 = extractvalue { i64, i64 } %9, 1
  store i64 %10, i64* %5, align 8
  store i64 %11, i64* %6, align 8
  %12 = load i64, i64* %5, align 8
  %13 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i64 noundef %12)
  %14 = load i64, i64* %6, align 8
  %15 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i64 noundef %14)
  %16 = load i64, i64* %5, align 8
  %17 = load i64, i64* %6, align 8
  %18 = add nsw i64 %16, %17
  ret i64 %18
}

declare i32 @printf(i8* noundef, ...) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i64 @sum64(i64 noundef %0, i64 noundef %1) #0 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i64 %0, i64* %3, align 8
  store i64 %1, i64* %4, align 8
  %6 = load i64, i64* %3, align 8
  %7 = load i64, i64* %4, align 8
  %8 = call i64 asm sideeffect "add $0, $1, $2", "=r,r,r,~{cc}"(i64 %6, i64 %7) #2, !srcloc !10
  store i64 %8, i64* %5, align 8
  %9 = load i64, i64* %5, align 8
  ret i64 %9
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i64 @sub64(i64 noundef %0, i64 noundef %1) #0 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i64 %0, i64* %3, align 8
  store i64 %1, i64* %4, align 8
  %6 = load i64, i64* %3, align 8
  %7 = load i64, i64* %4, align 8
  %8 = call i64 asm sideeffect "sub $0, $1, $2", "=r,r,r,~{cc}"(i64 %6, i64 %7) #2, !srcloc !11
  store i64 %8, i64* %5, align 8
  %9 = load i64, i64* %5, align 8
  ret i64 %9
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  %5 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0))
  store i64 10, i64* %2, align 8
  store i64 20, i64* %3, align 8
  %6 = load i64, i64* %2, align 8
  %7 = load i64, i64* %3, align 8
  %8 = call i64 @sumsub64(i64 noundef %6, i64 noundef %7)
  store i64 %8, i64* %4, align 8
  %9 = load i64, i64* %2, align 8
  %10 = load i64, i64* %3, align 8
  %11 = load i64, i64* %4, align 8
  %12 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.3, i64 0, i64 0), i64 noundef %9, i64 noundef %10, i64 noundef %11)
  ret i32 0
}

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"branch-target-enforcement", i32 0}
!2 = !{i32 1, !"sign-return-address", i32 0}
!3 = !{i32 1, !"sign-return-address-all", i32 0}
!4 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 1}
!7 = !{i32 7, !"frame-pointer", i32 1}
!8 = !{!"Homebrew clang version 14.0.6"}
!9 = !{i64 265, i64 282}
!10 = !{i64 580}
!11 = !{i64 772}
