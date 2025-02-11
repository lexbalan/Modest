
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "client.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>


#define client_filename  "file.txt"

#define client_ipAddress  "127.0.0.1"
#define client_port  8080
#define client_bufSize  1024


static bool client_send_file(FILE *fp, int sockfd)
{
	char data[client_bufSize];
	memset(&data, 0, sizeof data);

	while (fgets((char *)&data, client_bufSize, fp) != NULL) {
		if (send(sockfd, (char *)&data, (size_t)sizeof(char[client_bufSize]), 0) == -1) {
			return false;
		}
		memset(&data, 0, sizeof data);
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

	struct sockaddr_in server_addr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_port = client_port,
		.sin_addr = {
			.s_addr = inet_addr(client_ipAddress)
		}
	};

	struct sockaddr *const sockaddr = (struct sockaddr *)&server_addr;
	int e = connect(sockfd, sockaddr, (socklen_t)sizeof(struct sockaddr_in));
	if (e < 0) {
		perror("[-] Error in Connecting");
		exit(1);
	}

	printf("[+] Connected to server\n");

	FILE *const fp = fopen(client_filename, "r");
	if (fp == NULL) {
		perror("[-] Error in reading file");
		exit(1);
	}

	const bool suc = client_send_file(fp, sockfd);
	if (suc) {
		printf("[+] File data send successfully\n");
	} else {
		perror("[-] Error in sendung data");
	}

	close(sockfd);
	printf("[+] Disconnected from the server\n");

	return 0;
}

