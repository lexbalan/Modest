// libc/ctypes.m

pragma do_not_include
pragma prefix ""

//import "./system"

/*$if (systemWidth == 32)
import "./ctypes32"
$elseif (systemWidth == 64)
import "./ctypes64"
$else
@error("C types not implemented")
$endif*/

public include "./ctypes64"

