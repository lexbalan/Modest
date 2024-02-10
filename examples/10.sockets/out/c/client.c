/* from: https://github.com/pshashipreetham/File-Transfer-Using-TCP-Socket-in-C-Socket-Programming/tree/master */

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




#define PORT  8080
#define BUF_SIZE  1024


void send_file(FILE *fp, int sockfd)
{
    char data[BUF_SIZE];

    while (fgets((char *)(char *)&data, BUF_SIZE, fp) != NULL) {
        if (send(sockfd, (void *)(char *)&data, sizeof(char[BUF_SIZE]), 0) == -1) {
            perror("[-] Error in sendung data");
            exit(1);
        }
        bzero((void *)(char *)&data, BUF_SIZE);
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

    struct sockaddr_in server_addr = (struct sockaddr_in){
        .sin_family = AF_INET,
        .sin_port = PORT,
        .sin_addr = (struct in_addr){
            .s_addr = (unsigned long)inet_addr("127.0.0.1")
        }
    };

    struct sockaddr *const sockaddr = (struct sockaddr *)(void *)&server_addr;
    int e = connect(sockfd, sockaddr, sizeof(struct sockaddr_in));
    if (e < 0) {
        perror("[-] Error in Connecting");
        exit(1);
    }

    printf("[+] Connected to server\n");

    FILE *const fp = fopen("file.txt", "r");
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

