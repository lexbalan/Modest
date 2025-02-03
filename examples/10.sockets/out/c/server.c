
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "server.h"
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>


#define server_filename  "file2.txt"

#define server_ipAddress  "127.0.0.1"
#define server_port  8080
#define server_bufSize  1024


static bool server_write_file(int sockfd)
{
	char buffer[server_bufSize];
	memset(&buffer, 0, sizeof buffer);

	FILE *fp = fopen(server_filename, "w");
	if (fp == NULL) {
		perror("[-] Error in creating file");
		return false;
	}

	while (true) {
		ssize_t n = recv(sockfd, (char *)&buffer, server_bufSize, 0);

		if (n <= 0) {
			break;
		}

		fprintf(fp, "%s", &buffer);
		memset(&buffer, 0, sizeof buffer);
	}

	return true;
}


int main()
{
	int sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd < 0) {
		perror("[-] Error in socket");
		exit(1);
	}

	printf("[+] Server socket created\n");

	struct sockaddr_in server_addr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_port = server_port,
		.sin_addr = (struct in_addr){
			.s_addr = inet_addr(server_ipAddress)
		}
	};

	struct sockaddr *sockaddr = (struct sockaddr *)&server_addr;
	int e = bind(sockfd, sockaddr, (socklen_t)sizeof(struct sockaddr_in));
	if (e < 0) {
		perror("[-] Error in Binding");
		exit(1);
	}

	printf("[+] Binding Successfull\n");

	e = listen(sockfd, 10);
	if (e != 0) {
		perror("[-] Error in Binding");
		exit(1);
	}

	printf("[+] Listening...\n");

	socklen_t addr_size = (socklen_t)sizeof(struct sockaddr_in);
	struct sockaddr_in new_addr;
	struct sockaddr *sa = (struct sockaddr *)&new_addr;
	int new_sock = accept(sockfd, sa, &addr_size);

	bool suc = server_write_file(new_sock);
	if (suc) {
		printf("[+] Data written in the text file");
	} else {
		perror("[-] Cannot write file");
	}

	return 0;
}

