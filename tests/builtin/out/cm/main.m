import "builtin"
include "ctypes64"
include "stdio"
include "stdlib"




public func main () -> Int {
	printf("test builtin\n")

	var w: Word32
	var i: Int32
	var n: Nat32

	printf("sizeof(builtin.Word) = %lu\n", sizeof(Word32))
	printf("sizeof(builtin.Int) = %lu\n", sizeof(Int32))
	printf("sizeof(builtin.Nat) = %lu\n", sizeof(Nat32))

	let version = version
	printf("builtin.compiler.version = %u.%u.%u\n", version.major, version.minor, version.patch)
	if endian == endianBig {
		printf("it is a big-endian system\n")
	} else if endian == endianLittle {
		printf("it is a little-endian system\n")
	} else {
		printf("unknown endianess\n")
	}

	if arch == archArm {
		printf("it is an ARM (32) architecture\n")
	} else if arch == archAarch64 {
		printf("it is an ARM (64) architecture\n")
	} else if arch == archRiscv32 {
		printf("it is an RISC-V (32) architecture\n")
	} else if arch == archRiscv64 {
		printf("it is an RISC-V (64) architecture\n")
	} else if arch == archX86 {
		printf("it is an x86 (32) architecture\n")
	} else if arch == archX86_64 {
		printf("it is an x86 (64) architecture\n")
	} else {
		printf("it is an unknown architecture\n")
	}

	if os == osLinux {
		printf("it is a Linux operation system\n")
	} else if os == osWindows {
		printf("it is a Windows operation system\n")
	} else if os == osMacos {
		printf("it is a MacOS operation system\n")
	} else if os == osNoos {
		printf("There is no operation system\n")
	} else {
		printf("it is an Unknown operation system\n")
	}

	if abi == abiSysV {
		printf("it is a System V ABI\n")
	} else if abi == abiWin32 {
		printf("it is a Win32 ABI\n")
	} else if abi == abiWin64 {
		printf("it is a Win64 ABI\n")
	} else if abi == abiEabi {
		printf("it is a EABI\n")
	} else {
		printf("it is an Unknown ABI\n")
	}

	return exitSuccess
}

