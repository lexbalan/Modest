; ModuleID = 'out/c/main.c'
source_filename = "out/c/main.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

%struct.stat = type { i32, i16, i16, i64, i32, i32, i32, %struct.timespec, %struct.timespec, %struct.timespec, %struct.timespec, i64, i64, i32, i32, i32, i32, [2 x i64] }
%struct.timespec = type { i64, i64 }

@.str = private unnamed_addr constant [13 x i8] c"stat(\22%s\22):\0A\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"Makefile\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"stat error\0A\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c" device: %x\0A\00", align 1
@.str.4 = private unnamed_addr constant [14 x i8] c" inode: %lld\0A\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c" UID: %u\0A\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c" GID: %u\0A\00", align 1
@.str.7 = private unnamed_addr constant [11 x i8] c" rdev: %u\0A\00", align 1
@.str.8 = private unnamed_addr constant [14 x i8] c" blksize: %u\0A\00", align 1
@.str.9 = private unnamed_addr constant [15 x i8] c" blocks: %lld\0A\00", align 1
@.str.10 = private unnamed_addr constant [19 x i8] c" size: %lld bytes\0A\00", align 1
@.str.11 = private unnamed_addr constant [14 x i8] c" nlinks: %hu\0A\00", align 1
@.str.12 = private unnamed_addr constant [11 x i8] c" perm: %o\0A\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.stat, align 8
  store i32 0, i32* %1, align 4
  %3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0))
  %4 = call i32 @"\01_stat"(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), %struct.stat* noundef %2)
  %5 = icmp slt i32 %4, 0
  br i1 %5, label %6, label %8

6:                                                ; preds = %0
  %7 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.2, i64 0, i64 0))
  store i32 1, i32* %1, align 4
  br label %42

8:                                                ; preds = %0
  %9 = getelementptr inbounds %struct.stat, %struct.stat* %2, i32 0, i32 0
  %10 = load i32, i32* %9, align 8
  %11 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.3, i64 0, i64 0), i32 noundef %10)
  %12 = getelementptr inbounds %struct.stat, %struct.stat* %2, i32 0, i32 3
  %13 = load i64, i64* %12, align 8
  %14 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.4, i64 0, i64 0), i64 noundef %13)
  %15 = getelementptr inbounds %struct.stat, %struct.stat* %2, i32 0, i32 4
  %16 = load i32, i32* %15, align 8
  %17 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i64 0, i64 0), i32 noundef %16)
  %18 = getelementptr inbounds %struct.stat, %struct.stat* %2, i32 0, i32 5
  %19 = load i32, i32* %18, align 4
  %20 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i64 0, i64 0), i32 noundef %19)
  %21 = getelementptr inbounds %struct.stat, %struct.stat* %2, i32 0, i32 6
  %22 = load i32, i32* %21, align 8
  %23 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.7, i64 0, i64 0), i32 noundef %22)
  %24 = getelementptr inbounds %struct.stat, %struct.stat* %2, i32 0, i32 13
  %25 = load i32, i32* %24, align 8
  %26 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.8, i64 0, i64 0), i32 noundef %25)
  %27 = getelementptr inbounds %struct.stat, %struct.stat* %2, i32 0, i32 12
  %28 = load i64, i64* %27, align 8
  %29 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.9, i64 0, i64 0), i64 noundef %28)
  %30 = getelementptr inbounds %struct.stat, %struct.stat* %2, i32 0, i32 11
  %31 = load i64, i64* %30, align 8
  %32 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.10, i64 0, i64 0), i64 noundef %31)
  %33 = getelementptr inbounds %struct.stat, %struct.stat* %2, i32 0, i32 2
  %34 = load i16, i16* %33, align 2
  %35 = zext i16 %34 to i32
  %36 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.11, i64 0, i64 0), i32 noundef %35)
  %37 = getelementptr inbounds %struct.stat, %struct.stat* %2, i32 0, i32 1
  %38 = load i16, i16* %37, align 4
  %39 = zext i16 %38 to i32
  %40 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.12, i64 0, i64 0), i32 noundef %39)
  %41 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i64 0, i64 0))
  store i32 0, i32* %1, align 4
  br label %42

42:                                               ; preds = %8, %6
  %43 = load i32, i32* %1, align 4
  ret i32 %43
}

declare i32 @printf(i8* noundef, ...) #1

declare i32 @"\01_stat"(i8* noundef, %struct.stat* noundef) #1

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

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
