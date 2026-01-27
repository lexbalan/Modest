
#include "client.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */


#define FILENAME  "file.txt"

#define IP_ADDRESS  "127.0.0.1"
#define PORT  8080
#define BUF_SIZE  1024

static bool sendFile(FILE *fp, int sockFd) {
	char data[BUF_SIZE];

	while (fgets(&data[0], LENGTHOF(data), fp) != NULL) {
		if (send(sockFd, (void *)&data, sizeof data, 0) == -1) {
			return false;
		}
		memset(&data, 0, sizeof(char[BUF_SIZE]));
	}

	return true;
}


int main(void) {
	const int sockFd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockFd < 0) {
		perror("[-] Error in socket");
		exit(1);
	}

	printf("[+] Server socket created\n");

	struct sockaddr_in server_addr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_port = PORT,
		.sin_addr = (struct in_addr){
			.s_addr = inet_addr(IP_ADDRESS)
		}
	};

	struct sockaddr *const sockaddr = (struct sockaddr *)&server_addr;
	int e = connect(sockFd, sockaddr, (socklen_t)sizeof(struct sockaddr_in));
	if (e < 0) {
		perror("[-] Error in Connecting");
		exit(1);
	}

	printf("[+] Connected to server\n");

	FILE *const fp = fopen(FILENAME, "r");
	if (fp == NULL) {
		perror("[-] Error in reading file");
		exit(1);
	}

	const bool suc = sendFile(fp, sockFd);
	if (suc) {
		printf("[+] File data send successfully\n");
	} else {
		perror("[-] Error in sendung data");
	}

	close(sockFd);
	printf("[+] Disconnected from the server\n");

	return 0;
}


