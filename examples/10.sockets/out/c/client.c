/* thx: https://github.com/pshashipreetham/File-Transfer-Using-TCP-Socket-in-C-Socket-Programming */

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>

#include "client.h"

#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */


#define filename  "file.txt"

#define ipAddress  "127.0.0.1"
#define port  8080
#define bufSize  1024

static bool send_file(FILE *fp, int sockfd) {
	char data[bufSize];

	while (fgets((char *)&data, __lengthof(data), fp) != NULL) {
		if (send(sockfd, (void *)&data, sizeof data, 0) == -1) {
			return false;
		}
		memset(&data, 0, sizeof(char[bufSize]));
	}

	return true;
}

int main() {
	const int sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd < 0) {
		perror("[-] Error in socket");
		exit(1);
	}

	printf("[+] Server socket created\n");

	struct sockaddr_in server_addr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_port = port,
		.sin_addr = {
			.s_addr = inet_addr(ipAddress)
		}
	};

	struct sockaddr *const sockaddr = (struct sockaddr *)&server_addr;
	int e = connect(sockfd, sockaddr, (socklen_t)sizeof(struct sockaddr_in));
	if (e < 0) {
		perror("[-] Error in Connecting");
		exit(1);
	}

	printf("[+] Connected to server\n");

	FILE *const fp = fopen(filename, "r");
	if (fp == NULL) {
		perror("[-] Error in reading file");
		exit(1);
	}

	const bool suc = send_file(fp, sockfd);
	if (suc) {
		printf("[+] File data send successfully\n");
	} else {
		perror("[-] Error in sendung data");
	}

	close(sockfd);
	printf("[+] Disconnected from the server\n");

	return 0;
}

