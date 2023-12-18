
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <arpa/inet.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

/* from: https://github.com/pshashipreetham/File-Transfer-Using-TCP-Socket-in-C-Socket-Programming/tree/master */


#define SIZE  1024


void send_file(FILE *fp, int sockfd)
{
    char data[SIZE];

    while (fgets((char *)&data[0], SIZE, fp) != NULL) {
        if (send(sockfd, (void *)&data[0], sizeof(char [SIZE]), 0) == -1) {
            perror("[-] Error in sendung data");
            exit(1);
        }
        bzero((void *)&data[0], SIZE);
    }
}


#define role  {} /*GENERIC-STRING*/


int main(void)
{
    char *const ip = "127.0.0.1";
    const uint16_t port = 8080;

    if (true) {
        printf("role - CLIENT\n");
    }

    if (false) {
        printf("role - SERVER\n");
    }

    char *const filename = "file.txt";

    const int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("[-] Error in socket");
        exit(1);
    }

    printf("[+] Server socket created. \n");

    struct sockaddr_in server_addr = (struct sockaddr_in){
        .sin_family = AF_INET,
        .sin_port = port,
        .sin_addr = (struct in_addr){
            .s_addr = ((unsigned long)/*?*/(uint32_t)inet_addr((const char *)ip))
        }
    };

    struct sockaddr *const s = (struct sockaddr *const)(void *)&server_addr;
    int e = connect((int)sockfd, (struct sockaddr *)s, sizeof(struct sockaddr_in));
    if (e == -1) {
        perror("[-] Error in Connecting");
        exit(1);
    }

    printf("[+] Connected to server.\n");

    FILE *const fp = fopen((char *)filename, "r");
    if (fp == NULL) {
        perror("[-] Error in reading file.");
        exit(1);
    }

    send_file((FILE *)fp, (int)sockfd);

    printf("[+] File data send successfully.\n");

    close((int)sockfd);

    printf("[+] Disconnected from the server.\n");

    return 0;
}

