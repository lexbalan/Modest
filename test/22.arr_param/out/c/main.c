// examples/22.arr_param/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




struct swap_x {int32_t a[2];};
struct swap_retval {int32_t a[2];};
struct swap_retval swap(struct swap_x x);


struct swap_retval swap(struct swap_x x)
{
    int32_t out[2];
    out[0] = x.a[1];
    out[1] = x.a[0];
    return *(struct swap_retval *)&out;
}


struct ret_str_retval {char a[7];};
struct ret_str_retval ret_str()
{
    return *(struct ret_str_retval *)&(struct ret_str_retval){'h', 'e', 'l', 'l', 'o', '!', '\n'};
}


struct ret_str2_retval {char a[2 * 10];};
struct ret_str2_retval ret_str2()
{
    return *(struct ret_str2_retval *)&(struct ret_str2_retval){'a', 'b', '\x0', '\x0', '\x0', '\x0', '\x0', '\x0', '\x0', '\x0', 'c', 'd', '\x0', '\x0', '\x0', '\x0', '\x0', '\x0', '\x0', '\x0'};
}


struct kk_x {char a[2 * 10];};
void kk(struct kk_x x)
{
    printf("%c\n", x.a[0 * 10 + 0]);
    printf("%c\n", x.a[0 * 10 + 1]);
    printf("%c\n", x.a[0 * 10 + 2]);
    printf("%c\n", x.a[0 * 10 + 3]);
    printf("%c\n", x.a[0 * 10 + 4]);
    printf("%c\n", x.a[0 * 10 + 5]);
    printf("%c\n", x.a[0 * 10 + 6]);
    printf("%c\n", x.a[0 * 10 + 7]);
    printf("%c\n", x.a[0 * 10 + 8]);
    printf("%c\n", x.a[0 * 10 + 9]);
    printf("\n");

    printf("%c\n", x.a[1 * 10 + 0]);
    printf("%c\n", x.a[1 * 10 + 1]);
    printf("%c\n", x.a[1 * 10 + 2]);
    printf("%c\n", x.a[1 * 10 + 3]);
    printf("%c\n", x.a[1 * 10 + 4]);
    printf("%c\n", x.a[1 * 10 + 5]);
    printf("%c\n", x.a[1 * 10 + 6]);
    printf("%c\n", x.a[1 * 10 + 7]);
    printf("%c\n", x.a[1 * 10 + 8]);
    printf("%c\n", x.a[1 * 10 + 9]);
    printf("\n");
}



static int32_t global_array[2] = {1, 2};;


typedef struct {
    int32_t x;
    int32_t y;
} Point;

typedef struct {
    char x[10];
} Pod;


int main()
{

    // function returns array
    struct ret_str_retval returned_string;
    *(struct ret_str_retval *)&returned_string = ret_str();
    printf("returned_string = %s", (char *)&returned_string);


    // function receive array & return array
    int32_t a[2];

    a[0] = 10;
    a[1] = 20;

    printf("before swap:\n");
    printf("a[0] = %i\n", a[0]);
    printf("a[1] = %i\n", a[1]);

    int32_t b[2];
    *(struct swap_retval *)&b = swap(*(struct swap_x *)&a);

    printf("after swap:\n");
    printf("b[0] = %i\n", b[0]);
    printf("b[1] = %i\n", b[1]);



    char w[2 * 10];
    memcpy(&w[0 * 10], &(char[10]){'h', 'e', 'l', 'l', 'o', '\x0', '\x0', '\x0', '\x0', '\x0'}, 10);
    memcpy(&w[1 * 10], &(char[10]){'w', 'o', 'r', 'l', 'd', '\x0', '\x0', '\x0', '\x0', '\x0'}, 10);
    char u[2 * 10];
    memcpy(&u, &w, 20);
    kk(*(struct kk_x *)&u);


    return 0;
}

