// ./out/c/client.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "client.h"



/* anonymous records */
#define filename  "file.txt"
#define ipAddress  "127.0.0.1"
#define port  8080
#define bufSize  1024










static bool send_file(FILE *fp, int sockfd)
{
	char data[bufSize];

	while (fgets((char *)&data, bufSize, fp) != NULL) {
		if (send(sockfd, (char *)&data, (size_t)sizeof(char[bufSize]), 0) == -1) {
			return false;
		}
		memset(&data, 0, sizeof(char[bufSize]));
	}

	return true;
}

int main()
{
	const int sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd < 0) {
		perror("[-] Error in socket");
		exit(1);
	}

	printf("[+] Server socket created\n");

	struct sockaddr_in server_addr;
	server_addr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_port = port,
		.sin_addr = {
			.s_addr = inet_addr(ipAddress)
		}
	};

	struct sockaddr *const sockaddr = (struct sockaddr *)(void *)&server_addr;
	int e;
	e = connect(sockfd, (struct sockaddr *)sockaddr, (socklen_t)sizeof(struct sockaddr_in));
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

