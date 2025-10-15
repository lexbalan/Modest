/* thx: https://github.com/pshashipreetham/File-Transfer-Using-TCP-Socket-in-C-Socket-Programming */

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>

#include "server.h"


#define filename  "file2.txt"

#define ipAddress  "127.0.0.1"
#define port  8080
#define bufSize  1024

static bool writeFile(int sockFd) {
	char buffer[bufSize];

	FILE *const fp = fopen(filename, "w");
	if (fp == NULL) {
		perror("[-] Error in creating file");
		return false;
	}

	while (true) {
		const ssize_t n = recv(sockFd, (void *)&buffer, bufSize, 0);
		if (n <= 0) {
			break;
		}
		fprintf(fp, "%s", (char *)&buffer);
		memset(&buffer, 0, sizeof(char[bufSize]));
	}

	return true;
}


int main() {
	const int sockFd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockFd < 0) {
		perror("[-] Error in socket");
		exit(1);
	}

	printf("[+] Server socket created\n");

	struct sockaddr_in serverAddr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_port = port,
		.sin_addr = (struct in_addr){
			.s_addr = inet_addr(ipAddress)
		}
	};

	struct sockaddr *const sockAddr = (struct sockaddr *)&serverAddr;
	int e = bind(sockFd, sockAddr, (socklen_t)sizeof(struct sockaddr_in));
	if (e < 0) {
		perror("[-] Error in Binding");
		exit(1);
	}

	printf("[+] Binding Successfull\n");

	e = listen(sockFd, 10);
	if (e != 0) {
		perror("[-] Error in Binding");
		exit(1);
	}

	printf("[+] Listening...\n");

	socklen_t addrSize = (socklen_t)sizeof(struct sockaddr_in);
	struct sockaddr_in newAddr;
	struct sockaddr *const sa = (struct sockaddr *)&newAddr;
	const int newSock = accept(sockFd, sa, &addrSize);

	const bool suc = writeFile(newSock);
	if (suc) {
		printf("[+] Data written in the text file");
	} else {
		perror("[-] Cannot write file");
	}

	return 0;
}


