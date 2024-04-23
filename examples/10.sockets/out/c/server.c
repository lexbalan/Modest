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






#define filename  "file2.txt"

#define ipAddress  "127.0.0.1"
#define port  8080
#define bufSize  1024


void write_file(int sockfd)
{
    char buffer[bufSize];

    FILE *const fp = fopen((char *)filename, "w");
    if (fp == NULL) {
        perror("[-] Error in creating file");
        exit(1);
    }

    while (true) {
        const ssize_t n = recv(sockfd, (void *)(char *)&buffer, ((size_t)(uint16_t)bufSize), 0);

        if (n <= 0) {
            break;
        }

        fprintf(fp, "%s", (char *)&buffer);
        bzero((void *)(char *)&buffer, ((size_t)(uint16_t)bufSize));
    }
}


int main()
{
    const int sockfd = socket((int)AF_INET, (int)SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("[-] Error in socket");
        exit(1);
    }

    printf("[+] Server socket created\n");

    struct sockaddr_in server_addr;
    server_addr = (struct sockaddr_in){
        .sin_len = 0,
        .sin_family = (uint8_t)AF_INET,
        .sin_port = (unsigned short)port,
        .sin_addr = (struct in_addr){
            .s_addr = inet_addr((const char *)ipAddress)
        },
        .sin_zero = {}
    };

    struct sockaddr *const sockaddr = (struct sockaddr *)(void *)&server_addr;
    int e;
    e = bind(sockfd, sockaddr, (socklen_t)sizeof(struct sockaddr_in));
    if (e < 0) {
        perror("[-] Error in Binding");
        exit(1);
    }

    printf("[+] Binding Successfull\n");

    e = listen(sockfd, 10);
    if (e == 0) {
        printf("[+] Listening...\n");
    } else {
        perror("[-] Error in Binding");
        exit(1);
    }

    socklen_t addr_size;
    addr_size = (socklen_t)sizeof(struct sockaddr_in);
    struct sockaddr_in new_addr;
    struct sockaddr *const sa = (struct sockaddr *)(void *)&new_addr;
    const int new_sock = accept(sockfd, sa, &addr_size);

    write_file(new_sock);

    printf("[+] Data written in the text file");

    return 0;
}

