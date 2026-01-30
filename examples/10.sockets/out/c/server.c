
#include "server.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>



#define FILENAME  "file2.txt"

#define IP_ADDRESS  "127.0.0.1"
#define PORT  8080
#define BUF_SIZE  1024

static bool writeFile(int sockFd) {
	char buffer[BUF_SIZE];

	FILE *const fp = fopen(FILENAME, "w");
	if (fp == NULL) {
		perror("[-] Error in creating file");
		return false;
	}

	while (true) {
		const ssize_t n = recv(sockFd, (void *)buffer, (size_t)BUF_SIZE, 0);
		if (n <= 0) {
			break;
		}
		fprintf(fp, "%s", (char*)buffer);
		memset(&buffer, 0, sizeof(char [BUF_SIZE]));
	}

	return true;
}


int main(void) {
	const int sockFd = socket((int)AF_INET, (int)SOCK_STREAM, 0);
	if (sockFd < 0) {
		perror("[-] Error in socket");
		exit(1);
	}

	printf("[+] Server socket created\n");

	struct sockaddr_in serverAddr = (struct sockaddr_in){
		.sin_family = (uint8_t)AF_INET,
		.sin_port = (unsigned short)PORT,
		.sin_addr = (struct in_addr){
			.s_addr = inet_addr(IP_ADDRESS)
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


