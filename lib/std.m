// std.m

$pragma do_not_include

$if (__systemIntWidth == 32)
type Int Int32
type Nat Nat32
$elseif (__systemIntWidth == 64)
type Int Int64
type Nat Nat64
$else
@error ("bad __systemIntWidth")
$endif

