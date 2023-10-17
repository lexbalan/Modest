
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/minmax.cm


define i32 @min_int32(i32 %a, i32 %b) {
    %1 = icmp slt i32 %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret i32 %a
    br label %endif_0
endif_0:
    ret i32 %b
}

define i32 @max_int32(i32 %a, i32 %b) {
    %1 = icmp sgt i32 %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret i32 %a
    br label %endif_0
endif_0:
    ret i32 %b
}

define i64 @min_int64(i64 %a, i64 %b) {
    %1 = icmp slt i64 %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret i64 %a
    br label %endif_0
endif_0:
    ret i64 %b
}

define i64 @max_int64(i64 %a, i64 %b) {
    %1 = icmp sgt i64 %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret i64 %a
    br label %endif_0
endif_0:
    ret i64 %b
}

define i32 @min_nat32(i32 %a, i32 %b) {
    %1 = icmp ult i32 %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret i32 %a
    br label %endif_0
endif_0:
    ret i32 %b
}

define i32 @max_nat32(i32 %a, i32 %b) {
    %1 = icmp ugt i32 %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret i32 %a
    br label %endif_0
endif_0:
    ret i32 %b
}

define i64 @min_nat64(i64 %a, i64 %b) {
    %1 = icmp ult i64 %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret i64 %a
    br label %endif_0
endif_0:
    ret i64 %b
}

define i64 @max_nat64(i64 %a, i64 %b) {
    %1 = icmp ugt i64 %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret i64 %a
    br label %endif_0
endif_0:
    ret i64 %b
}

define float @min_float32(float %a, float %b) {
    %1 = fcmp olt float %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret float %a
    br label %endif_0
endif_0:
    ret float %b
}

define float @max_float32(float %a, float %b) {
    %1 = fcmp ogt float %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret float %a
    br label %endif_0
endif_0:
    ret float %b
}

define double @min_float64(double %a, double %b) {
    %1 = fcmp olt double %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret double %a
    br label %endif_0
endif_0:
    ret double %b
}

define double @max_float64(double %a, double %b) {
    %1 = fcmp ogt double %a, %b
    br i1 %1 , label %then_0, label %endif_0
then_0:
    ret double %a
    br label %endif_0
endif_0:
    ret double %b
}


