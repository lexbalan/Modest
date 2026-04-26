
#include "server.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#define SERVER_FILENAME "file2.txt"
#define SERVER_IP_ADDRESS "127.0.0.1"
#define SERVER_PORT 8080
#define SERVER_BUF_SIZE 1024

static bool server_writeFile(int sockFd) {
	char buffer[SERVER_BUF_SIZE];
	FILE *const server_fp = fopen(SERVER_FILENAME, "w");
	if (server_fp == NULL) {
		perror("[-] Error in creating file");
		return false;
	}
	while (true) {
		const ssize_t server_n = recv(sockFd, buffer, SERVER_BUF_SIZE, 0);
		if (server_n <= 0LL) {
			break;
		}
		fprintf(server_fp, "%s", buffer);
		__builtin_bzero(&buffer, sizeof(char [SERVER_BUF_SIZE]));
	}
	return true;
}

int main(void) {
	const int server_sockFd = socket(AF_INET, SOCK_STREAM, 0);
	if (server_sockFd < 0) {
		perror("[-] Error in socket");
		exit(1);
	}
	printf("[+] Server socket created\n");
	struct sockaddr_in serverAddr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_port = SERVER_PORT,
		.sin_addr = (struct in_addr){
			.s_addr = inet_addr(SERVER_IP_ADDRESS)
		}
	};
	struct sockaddr *const server_sockAddr = (struct sockaddr *)(void *)&serverAddr;
	int e = bind(server_sockFd, server_sockAddr, (socklen_t)sizeof(struct sockaddr_in));
	if (e < 0) {
		perror("[-] Error in Binding");
		exit(1);
	}
	printf("[+] Binding Successfull\n");
	e = listen(server_sockFd, 10);
	if (e != 0) {
		perror("[-] Error in Binding");
		exit(1);
	}
	printf("[+] Listening...\n");
	socklen_t addrSize = (socklen_t)sizeof(struct sockaddr_in);
	struct sockaddr_in newAddr;
	struct sockaddr *const server_sa = (struct sockaddr *)(void *)&newAddr;
	const int server_newSock = accept(server_sockFd, server_sa, &addrSize);
	const bool server_suc = server_writeFile(server_newSock);
	if (server_suc) {
		printf("[+] Data written in the text file");
	} else {
		perror("[-] Cannot write file");
	}
	return 0;
}

