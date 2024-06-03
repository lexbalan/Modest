/* thx: https://github.com/pshashipreetham/File-Transfer-Using-TCP-Socket-in-C-Socket-Programming */

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <arpa/inet.h>






#define filename  "file.txt"

#define ipAddress  "127.0.0.1"
#define port  8080
#define bufSize  1024


void send_file(FILE *fp, int sockfd)
{
	char data[bufSize];

	while (fgets((char *)&data, bufSize, fp) != NULL) {
		if (send(sockfd, (char *)&data, (size_t)sizeof(char[bufSize]), 0) == -1) {
			perror("[-] Error in sendung data");
			exit(1);
		}
		bzero((char *)&data, bufSize);
	}
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
	e = connect(sockfd, sockaddr, (socklen_t)sizeof(struct sockaddr_in));
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

	send_file(fp, sockfd);

	printf("[+] File data send successfully\n");

	close(sockfd);

	printf("[+] Disconnected from the server\n");

	return 0;
}

