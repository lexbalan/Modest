// tests/builtin/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"



public func main () -> Int {
	printf("test builtin\n")

	printf("builtin.compiler.version.major = %d\n", builtin.compiler.version.major)
	printf("builtin.compiler.version.minor = %d\n", builtin.compiler.version.minor)
//	printf("builtin.target.name = %s\n", *Str8 builtin.target.name)
//	printf("builtin.target.arch = %s\n", *Str8 builtin.target.arch)
//	printf("builtin.target.os = %s\n", *Str8 builtin.target.os)
//	printf("builtin.target.abi = %s\n", *Str8 builtin.target.abi)
//	printf("builtin.target.endian = %s\n", *Str8 builtin.target.endian)

	if builtin.target.endian == builtin.endianBig {
		printf("it is a big-endian system\n")
	} else if builtin.target.endian == builtin.endianLittle {
		printf("it is a little-endian system\n")
	} else {
		printf("unknown endianess\n")
	}

	if builtin.target.arch == builtin.archArm {
		printf("it is an ARM (32) architecture\n")
	} else if builtin.target.arch == builtin.archAarch64 {
		printf("it is an ARM (64) architecture\n")
	} else if builtin.target.arch == builtin.archRiscv32 {
		printf("it is an RISC-V (32) architecture\n")
	} else if builtin.target.arch == builtin.archRiscv64 {
		printf("it is an RISC-V (64) architecture\n")
	} else if builtin.target.arch == builtin.archX86 {
		printf("it is an x86 (32) architecture\n")
	} else if builtin.target.arch == builtin.archX86_64 {
		printf("it is an x86 (64) architecture\n")
	} else {
		printf("it is an unknown architecture\n")
	}

	if builtin.target.os == builtin.osLinux {
		printf("it is a Linux operation system\n")
	} else if builtin.target.os == builtin.osWindows {
		printf("it is a Windows operation system\n")
	} else if builtin.target.os == builtin.osMacos {
		printf("it is a MacOS operation system\n")
	} else if builtin.target.os == builtin.osNoos {
		printf("There is no operation system\n")
	} else {
		printf("it is an Unknown operation system\n")
	}

	if builtin.target.abi == builtin.abiSysV {
		printf("it is a System V ABI\n")
	} else if builtin.target.abi == builtin.abiWin32 {
		printf("it is a Win32 ABI\n")
	} else if builtin.target.abi == builtin.abiWin64 {
		printf("it is a Win64 ABI\n")
	} else if builtin.target.abi == builtin.abiEabi {
		printf("it is a EABI\n")
	} else {
		printf("it is an Unknown ABI\n")
	}

	var result: Bool
	var success = true

	printf("test ")
	if not success {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

