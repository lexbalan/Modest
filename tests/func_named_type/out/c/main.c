
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
typedef void FailHandler(int32_t code);

static void onDiskFail(int32_t code) {
	printf("disk failed with code %d\n", code);
}

static void onNetworkFail(int32_t code) {
	printf("network failed with code %d\n", code);
}

int main(void) {
	onDiskFail(1);
	onNetworkFail(2);
	return 0;
}

