
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

	FILE *const fp = fopen(/*4*/FILENAME, /*4*/"w");
	if (fp == NULL) {
		perror(/*4*/"[-] Error in creating file");
		return false;
	}

	while (true) {
		const ssize_t n = recv(sockFd, (void *)&buffer, BUF_SIZE, 0);
		if (n <= 0) {
			break;
		}
		fprintf(fp, /*4*/"%s", /*4*/(char*)&buffer);
		memset(&buffer, 0, sizeof(char[BUF_SIZE]));
	}

	return true;
}


int main(void) {
	const int sockFd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockFd < 0) {
		perror(/*4*/"[-] Error in socket");
		exit(1);
	}

	printf(/*4*/"[+] Server socket created\n");

	struct sockaddr_in serverAddr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_port = PORT,
		.sin_addr = (struct in_addr){
			.s_addr = inet_addr(/*4*/IP_ADDRESS)
		}
	};

	struct sockaddr *const sockAddr = (struct sockaddr *)&serverAddr;
	int e = bind(sockFd, sockAddr, (socklen_t)sizeof(struct sockaddr_in));
	if (e < 0) {
		perror(/*4*/"[-] Error in Binding");
		exit(1);
	}

	printf(/*4*/"[+] Binding Successfull\n");

	e = listen(sockFd, 10);
	if (e != 0) {
		perror(/*4*/"[-] Error in Binding");
		exit(1);
	}

	printf(/*4*/"[+] Listening...\n");

	socklen_t addrSize = (socklen_t)sizeof(struct sockaddr_in);
	struct sockaddr_in newAddr;
	struct sockaddr *const sa = (struct sockaddr *)&newAddr;
	const int newSock = accept(sockFd, sa, &addrSize);

	const bool suc = writeFile(newSock);
	if (suc) {
		printf(/*4*/"[+] Data written in the text file");
	} else {
		perror(/*4*/"[-] Cannot write file");
	}

	return 0;
}


