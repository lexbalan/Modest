
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
	printf("test builtin\n");
	uint32_t w;
	int32_t i;
	uint32_t n;
	printf("sizeof(builtin.Word) = %lu\n", sizeof(uint32_t));
	printf("sizeof(builtin.Int) = %lu\n", sizeof(int32_t));
	printf("sizeof(builtin.Nat) = %lu\n", sizeof(uint32_t));
	struct {uint32_t major; uint32_t minor; uint32_t patch;} version = {.major = 0U, .minor = 7U, .patch = 100U};
	printf("builtin.compiler.version = %u.%u.%u\n", version.major, version.minor, version.patch);
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
	return EXIT_SUCCESS;
}

