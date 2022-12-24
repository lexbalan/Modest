
%Bool= type i1
%Void = type i1
%Nil = type i1*
%Unit = type i1
%Str = type [0 x i8]*
%Nat1 = type i1
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Int = type i64
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Float16 = type half
%Float32 = type float
%Float64 = type double
%Float128 = type fp128
@str_0 = constant [10 x i8] c"Iter #%d\0A\00"

declare void @printf([0 x %Nat8]*, ...);

%CounterState = type i32

%Counter = type {
	%Int32
}

@state = global %CounterState zeroinitializer

define void @stateTest() {
  %1 = load %CounterState, %CounterState* @state
  %2 = icmp eq %CounterState %1, 1000
  br i1%2 , label %then_0, label %endif_0
then_0:
  store %CounterState 1001, %CounterState* @state
  br label %endif_0
endif_0:
  ret void
}

@cnt = global %Int64 zeroinitializer

define void @counter_rst() {
  %1 = bitcast %Int 0 to %Int64
  store %Int64 %1, %Int64* @cnt
  ret void
}

define void @counter_inc() {
  %1 = load %Int64, %Int64* @cnt
  %2 = bitcast %Int 1 to %Int64
  %3 = add %Int64 %1, %2
  store %Int64 %3, %Int64* @cnt
  ret void
}

define %Int64 @add(%Int64 %a, %Int64 %b) {
  %1 = add %Int64 %a, %b
  ret %Int64 %1
}

define %Int64 @max(%Int64 %a, %Int64 %b) {
  %res = alloca %Int64
  %1 = icmp ugt %Int64 %a, %b
  br i1%1 , label %then_0, label %else_0
then_0:
  store %Int64 %a, %Int64* %res
  br label %endif_0
else_0:
  store %Int64 %b, %Int64* %res
  br label %endif_0
endif_0:
  %2 = load %Int64, %Int64* %res
  ret %Int64 %2
}

define %Int64 @div(%Int64 %a, %Int64 %b) {
  %1 = sdiv %Int64 %a, %b
  ret %Int64 %1
}

define %Int64 @mul(%Int64 %a, %Int64 %b) {
  %1 = mul %Int64 %a, %b
  ret %Int64 %1
}

@cnt0 = global %Counter zeroinitializer

define %Int64 @main() {
  %i = alloca %Int64
  %1 = bitcast %Int 0 to %Int64
  store %Int64 %1, %Int64* %i
  call void() @counter_rst ()
  br label %again_1
again_1:
  %2 = load %Int64, %Int64* %i
  %3 = bitcast %Int 10 to %Int64
  %4 = icmp ult %Int64 %2, %3
  br i1%4 , label %body_1, label %break_1
body_1:
  %5 = load %Int64, %Int64* %i
  call void([0 x %Nat8]*, ...) @printf ([0 x %Nat8]* bitcast ([10 x i8]* @str_0 to %Str), %Int64 %5)
  call void() @counter_inc ()
  %6 = load %Int64, %Int64* %i
  %7 = bitcast %Int 1 to %Int64
  %8 = add %Int64 %6, %7
  store %Int64 %8, %Int64* %i
  br label %again_1
break_1:
  %9 = load %Int64, %Int64* @cnt
  ret %Int64 %9
}

