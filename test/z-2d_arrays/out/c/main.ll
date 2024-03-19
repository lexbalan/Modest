; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

%struct.xx_retval = type { [10 x i8] }
%struct.Sre = type { [40 x i8] }
%struct.ee_x = type { [20 x i8] }

@.str = private unnamed_addr constant [4 x i8] c"%c\0A\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable
define [2 x i64] @xx() #0 {
  %1 = alloca %struct.xx_retval, align 1
  %2 = alloca %struct.xx_retval, align 1
  %3 = alloca [5 x i8], align 1
  %4 = alloca [5 x i8], align 1
  %5 = alloca [2 x i64], align 8
  %6 = getelementptr inbounds %struct.xx_retval, %struct.xx_retval* %2, i32 0, i32 0
  %7 = getelementptr inbounds [10 x i8], [10 x i8]* %6, i64 0, i64 0
  %8 = getelementptr inbounds [5 x i8], [5 x i8]* %3, i64 0, i64 0
  store i8 97, i8* %8, align 1
  %9 = getelementptr inbounds i8, i8* %8, i64 1
  store i8 98, i8* %9, align 1
  %10 = getelementptr inbounds i8, i8* %9, i64 1
  %11 = getelementptr inbounds i8, i8* %8, i64 5
  br label %12

12:                                               ; preds = %12, %0
  %13 = phi i8* [ %10, %0 ], [ %14, %12 ]
  store i8 0, i8* %13, align 1
  %14 = getelementptr inbounds i8, i8* %13, i64 1
  %15 = icmp eq i8* %14, %11
  br i1 %15, label %16, label %12

16:                                               ; preds = %12
  %17 = getelementptr inbounds [5 x i8], [5 x i8]* %3, i64 0, i64 0
  %18 = ptrtoint i8* %17 to i8
  store i8 %18, i8* %7, align 1
  %19 = getelementptr inbounds i8, i8* %7, i64 1
  %20 = getelementptr inbounds [5 x i8], [5 x i8]* %4, i64 0, i64 0
  store i8 99, i8* %20, align 1
  %21 = getelementptr inbounds i8, i8* %20, i64 1
  store i8 100, i8* %21, align 1
  %22 = getelementptr inbounds i8, i8* %21, i64 1
  %23 = getelementptr inbounds i8, i8* %20, i64 5
  br label %24

24:                                               ; preds = %24, %16
  %25 = phi i8* [ %22, %16 ], [ %26, %24 ]
  store i8 0, i8* %25, align 1
  %26 = getelementptr inbounds i8, i8* %25, i64 1
  %27 = icmp eq i8* %26, %23
  br i1 %27, label %28, label %24

28:                                               ; preds = %24
  %29 = getelementptr inbounds [5 x i8], [5 x i8]* %4, i64 0, i64 0
  %30 = ptrtoint i8* %29 to i8
  store i8 %30, i8* %19, align 1
  %31 = getelementptr inbounds i8, i8* %19, i64 1
  %32 = getelementptr inbounds i8, i8* %7, i64 10
  br label %33

33:                                               ; preds = %33, %28
  %34 = phi i8* [ %31, %28 ], [ %35, %33 ]
  store i8 0, i8* %34, align 1
  %35 = getelementptr inbounds i8, i8* %34, i64 1
  %36 = icmp eq i8* %35, %32
  br i1 %36, label %37, label %33

37:                                               ; preds = %33
  %38 = bitcast %struct.xx_retval* %1 to i8*
  %39 = bitcast %struct.xx_retval* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %38, i8* align 1 %39, i64 10, i1 false)
  %40 = getelementptr inbounds %struct.xx_retval, %struct.xx_retval* %1, i32 0, i32 0
  %41 = bitcast [2 x i64]* %5 to i8*
  %42 = bitcast [10 x i8]* %40 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %41, i8* align 1 %42, i64 10, i1 false)
  %43 = load [2 x i64], [2 x i64]* %5, align 8
  ret [2 x i64] %43
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @yy(%struct.Sre* noalias sret(%struct.Sre) align 1 %0) #0 {
  %2 = bitcast %struct.Sre* %0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 1 %2, i8 0, i64 40, i1 false)
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @ee(%struct.ee_x* noundef %0) #0 {
  %2 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %3 = getelementptr inbounds [20 x i8], [20 x i8]* %2, i64 0, i64 0
  %4 = load i8, i8* %3, align 1
  %5 = sext i8 %4 to i32
  %6 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %5)
  %7 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %8 = getelementptr inbounds [20 x i8], [20 x i8]* %7, i64 0, i64 1
  %9 = load i8, i8* %8, align 1
  %10 = sext i8 %9 to i32
  %11 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %10)
  %12 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %13 = getelementptr inbounds [20 x i8], [20 x i8]* %12, i64 0, i64 2
  %14 = load i8, i8* %13, align 1
  %15 = sext i8 %14 to i32
  %16 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %15)
  %17 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %18 = getelementptr inbounds [20 x i8], [20 x i8]* %17, i64 0, i64 3
  %19 = load i8, i8* %18, align 1
  %20 = sext i8 %19 to i32
  %21 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %20)
  %22 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %23 = getelementptr inbounds [20 x i8], [20 x i8]* %22, i64 0, i64 4
  %24 = load i8, i8* %23, align 1
  %25 = sext i8 %24 to i32
  %26 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %25)
  %27 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %28 = getelementptr inbounds [20 x i8], [20 x i8]* %27, i64 0, i64 5
  %29 = load i8, i8* %28, align 1
  %30 = sext i8 %29 to i32
  %31 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %30)
  %32 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %33 = getelementptr inbounds [20 x i8], [20 x i8]* %32, i64 0, i64 6
  %34 = load i8, i8* %33, align 1
  %35 = sext i8 %34 to i32
  %36 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %35)
  %37 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %38 = getelementptr inbounds [20 x i8], [20 x i8]* %37, i64 0, i64 7
  %39 = load i8, i8* %38, align 1
  %40 = sext i8 %39 to i32
  %41 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %40)
  %42 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %43 = getelementptr inbounds [20 x i8], [20 x i8]* %42, i64 0, i64 8
  %44 = load i8, i8* %43, align 1
  %45 = sext i8 %44 to i32
  %46 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %45)
  %47 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %48 = getelementptr inbounds [20 x i8], [20 x i8]* %47, i64 0, i64 9
  %49 = load i8, i8* %48, align 1
  %50 = sext i8 %49 to i32
  %51 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %50)
  %52 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %53 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %54 = getelementptr inbounds [20 x i8], [20 x i8]* %53, i64 0, i64 10
  %55 = load i8, i8* %54, align 1
  %56 = sext i8 %55 to i32
  %57 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %56)
  %58 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %59 = getelementptr inbounds [20 x i8], [20 x i8]* %58, i64 0, i64 11
  %60 = load i8, i8* %59, align 1
  %61 = sext i8 %60 to i32
  %62 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %61)
  %63 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %64 = getelementptr inbounds [20 x i8], [20 x i8]* %63, i64 0, i64 12
  %65 = load i8, i8* %64, align 1
  %66 = sext i8 %65 to i32
  %67 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %66)
  %68 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %69 = getelementptr inbounds [20 x i8], [20 x i8]* %68, i64 0, i64 13
  %70 = load i8, i8* %69, align 1
  %71 = sext i8 %70 to i32
  %72 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %71)
  %73 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %74 = getelementptr inbounds [20 x i8], [20 x i8]* %73, i64 0, i64 14
  %75 = load i8, i8* %74, align 1
  %76 = sext i8 %75 to i32
  %77 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %76)
  %78 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %79 = getelementptr inbounds [20 x i8], [20 x i8]* %78, i64 0, i64 15
  %80 = load i8, i8* %79, align 1
  %81 = sext i8 %80 to i32
  %82 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %81)
  %83 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %84 = getelementptr inbounds [20 x i8], [20 x i8]* %83, i64 0, i64 16
  %85 = load i8, i8* %84, align 1
  %86 = sext i8 %85 to i32
  %87 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %86)
  %88 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %89 = getelementptr inbounds [20 x i8], [20 x i8]* %88, i64 0, i64 17
  %90 = load i8, i8* %89, align 1
  %91 = sext i8 %90 to i32
  %92 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %91)
  %93 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %94 = getelementptr inbounds [20 x i8], [20 x i8]* %93, i64 0, i64 18
  %95 = load i8, i8* %94, align 1
  %96 = sext i8 %95 to i32
  %97 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %96)
  %98 = getelementptr inbounds %struct.ee_x, %struct.ee_x* %0, i32 0, i32 0
  %99 = getelementptr inbounds [20 x i8], [20 x i8]* %98, i64 0, i64 19
  %100 = load i8, i8* %99, align 1
  %101 = sext i8 %100 to i32
  %102 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %101)
  %103 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  ret void
}

declare i32 @printf(i8* noundef, ...) #3

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.Sre, align 1
  %3 = alloca [20 x i8], align 1
  %4 = alloca [10 x i8], align 1
  %5 = alloca [10 x i8], align 1
  %6 = alloca [20 x i8], align 1
  %7 = alloca %struct.ee_x, align 1
  store i32 0, i32* %1, align 4
  call void @yy(%struct.Sre* sret(%struct.Sre) align 1 %2)
  %8 = getelementptr inbounds [20 x i8], [20 x i8]* %3, i64 0, i64 0
  %9 = getelementptr inbounds [10 x i8], [10 x i8]* %4, i64 0, i64 0
  store i8 104, i8* %9, align 1
  %10 = getelementptr inbounds i8, i8* %9, i64 1
  store i8 101, i8* %10, align 1
  %11 = getelementptr inbounds i8, i8* %10, i64 1
  store i8 108, i8* %11, align 1
  %12 = getelementptr inbounds i8, i8* %11, i64 1
  store i8 108, i8* %12, align 1
  %13 = getelementptr inbounds i8, i8* %12, i64 1
  store i8 111, i8* %13, align 1
  %14 = getelementptr inbounds i8, i8* %13, i64 1
  %15 = getelementptr inbounds i8, i8* %9, i64 10
  br label %16

16:                                               ; preds = %16, %0
  %17 = phi i8* [ %14, %0 ], [ %18, %16 ]
  store i8 0, i8* %17, align 1
  %18 = getelementptr inbounds i8, i8* %17, i64 1
  %19 = icmp eq i8* %18, %15
  br i1 %19, label %20, label %16

20:                                               ; preds = %16
  %21 = bitcast [10 x i8]* %4 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %8, i8* align 1 %21, i64 10, i1 false)
  %22 = getelementptr inbounds [20 x i8], [20 x i8]* %3, i64 0, i64 10
  %23 = getelementptr inbounds [10 x i8], [10 x i8]* %5, i64 0, i64 0
  store i8 119, i8* %23, align 1
  %24 = getelementptr inbounds i8, i8* %23, i64 1
  store i8 111, i8* %24, align 1
  %25 = getelementptr inbounds i8, i8* %24, i64 1
  store i8 114, i8* %25, align 1
  %26 = getelementptr inbounds i8, i8* %25, i64 1
  store i8 108, i8* %26, align 1
  %27 = getelementptr inbounds i8, i8* %26, i64 1
  store i8 100, i8* %27, align 1
  %28 = getelementptr inbounds i8, i8* %27, i64 1
  %29 = getelementptr inbounds i8, i8* %23, i64 10
  br label %30

30:                                               ; preds = %30, %20
  %31 = phi i8* [ %28, %20 ], [ %32, %30 ]
  store i8 0, i8* %31, align 1
  %32 = getelementptr inbounds i8, i8* %31, i64 1
  %33 = icmp eq i8* %32, %29
  br i1 %33, label %34, label %30

34:                                               ; preds = %30
  %35 = bitcast [10 x i8]* %5 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %22, i8* align 1 %35, i64 10, i1 false)
  %36 = bitcast [20 x i8]* %6 to i8*
  %37 = bitcast [20 x i8]* %3 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %36, i8* align 1 %37, i64 20, i1 false)
  %38 = bitcast [20 x i8]* %6 to %struct.ee_x*
  %39 = bitcast %struct.ee_x* %7 to i8*
  %40 = bitcast %struct.ee_x* %38 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %39, i8* align 1 %40, i64 20, i1 false)
  call void @ee(%struct.ee_x* noundef %7)
  ret i32 0
}

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { argmemonly nofree nounwind willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn writeonly }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

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
