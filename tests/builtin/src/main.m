// tests/builtin/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"



public func main () -> Int {
	printf("test builtin\n")

	var w: builtin.target.Word
	var i: builtin.target.Int
	var n: builtin.target.Nat

	printf("sizeof(builtin.target.Word) = %lu\n", sizeof(builtin.target.Word))
	printf("sizeof(builtin.target.Int) = %lu\n", sizeof(builtin.target.Int))
	printf("sizeof(builtin.target.Nat) = %lu\n", sizeof(builtin.target.Nat))

	let version = builtin.compiler.version
	printf("builtin.compiler.version = %u.%u.%u\n", version.major, version.minor, version.patch)

	// TODO: Проблема - LLVM бекенд не может сконструировать строки здесь...
//	printf("builtin.target.name = %s\n", *Str8 builtin.target.name)
//	printf("builtin.target.arch = %s\n", *Str8 builtin.target.arch)
//	printf("builtin.target.os = %s\n", *Str8 builtin.target.os)
//	printf("builtin.target.abi = %s\n", *Str8 builtin.target.abi)
//	printf("builtin.target.endian = %s\n", *Str8 builtin.target.endian)

	// TODO: Проблема - результаты этих операций сравнения посему то не immediate....
	if builtin.target.endian == builtin.target.endianBig {
		printf("it is a big-endian system\n")
	} else if builtin.target.endian == builtin.target.endianLittle {
		printf("it is a little-endian system\n")
	} else {
		printf("unknown endianess\n")
	}

	if builtin.target.arch == builtin.target.archArm {
		printf("it is an ARM (32) architecture\n")
	} else if builtin.target.arch == builtin.target.archAarch64 {
		printf("it is an ARM (64) architecture\n")
	} else if builtin.target.arch == builtin.target.archRiscv32 {
		printf("it is an RISC-V (32) architecture\n")
	} else if builtin.target.arch == builtin.target.archRiscv64 {
		printf("it is an RISC-V (64) architecture\n")
	} else if builtin.target.arch == builtin.target.archX86 {
		printf("it is an x86 (32) architecture\n")
	} else if builtin.target.arch == builtin.target.archX86_64 {
		printf("it is an x86 (64) architecture\n")
	} else {
		printf("it is an unknown architecture\n")
	}

	if builtin.target.os == builtin.target.osLinux {
		printf("it is a Linux operation system\n")
	} else if builtin.target.os == builtin.target.osWindows {
		printf("it is a Windows operation system\n")
	} else if builtin.target.os == builtin.target.osMacos {
		printf("it is a MacOS operation system\n")
	} else if builtin.target.os == builtin.target.osNoos {
		printf("There is no operation system\n")
	} else {
		printf("it is an Unknown operation system\n")
	}

	if builtin.target.abi == builtin.target.abiSysV {
		printf("it is a System V ABI\n")
	} else if builtin.target.abi == builtin.target.abiWin32 {
		printf("it is a Win32 ABI\n")
	} else if builtin.target.abi == builtin.target.abiWin64 {
		printf("it is a Win64 ABI\n")
	} else if builtin.target.abi == builtin.target.abiEabi {
		printf("it is a EABI\n")
	} else {
		printf("it is an Unknown ABI\n")
	}

	return exitSuccess
}

