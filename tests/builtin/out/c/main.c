
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
	printf("test builtin\n");
	printf("builtin.compiler.version.major = %d\n", 0U);
	printf("builtin.compiler.version.minor = %d\n", 7U);
	if (__builtin_strcmp((char *const )&"little-endian", (char *const )&"big-endian") == 0) {
		printf("it is a big-endian system\n");
	} else if (__builtin_strcmp((char *const )&"little-endian", (char *const )&"little-endian") == 0) {
		printf("it is a little-endian system\n");
	} else {
		printf("unknown endianess\n");
	}
	if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"arm") == 0) {
		printf("it is an ARM (32) architecture\n");
	} else if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"aarch64") == 0) {
		printf("it is an ARM (64) architecture\n");
	} else if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"riscv32") == 0) {
		printf("it is an RISC-V (32) architecture\n");
	} else if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"riscv64") == 0) {
		printf("it is an RISC-V (64) architecture\n");
	} else if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"x86") == 0) {
		printf("it is an x86 (32) architecture\n");
	} else if (__builtin_strcmp((char *const )&"aarch64", (char *const )&"x86_64") == 0) {
		printf("it is an x86 (64) architecture\n");
	} else {
		printf("it is an unknown architecture\n");
	}
	if (__builtin_strcmp((char *const )&"darwin", (char *const )&"linux") == 0) {
		printf("it is a Linux operation system\n");
	} else if (__builtin_strcmp((char *const )&"darwin", (char *const )&"windows") == 0) {
		printf("it is a Windows operation system\n");
	} else if (__builtin_strcmp((char *const )&"darwin", (char *const )&"darwin") == 0) {
		printf("it is a MacOS operation system\n");
	} else if (__builtin_strcmp((char *const )&"darwin", (char *const )&"noos") == 0) {
		printf("There is no operation system\n");
	} else {
		printf("it is an Unknown operation system\n");
	}
	if (__builtin_strcmp((char *const )&"sysv", (char *const )&"sysv") == 0) {
		printf("it is a System V ABI\n");
	} else if (__builtin_strcmp((char *const )&"sysv", (char *const )&"win32") == 0) {
		printf("it is a Win32 ABI\n");
	} else if (__builtin_strcmp((char *const )&"sysv", (char *const )&"win64") == 0) {
		printf("it is a Win64 ABI\n");
	} else if (__builtin_strcmp((char *const )&"sysv", (char *const )&"eabi") == 0) {
		printf("it is a EABI\n");
	} else {
		printf("it is an Unknown ABI\n");
	}
	bool result;
	bool success = true;
	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

