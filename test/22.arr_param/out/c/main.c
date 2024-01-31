// examples/22.arr_param/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>



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


struct ret_str_retval {char a[8];};
struct ret_str_retval ret_str()
{
    return *(struct ret_str_retval *)&(struct ret_str_retval){'h', 'e', 'l', 'l', 'o', 'm', 'a', '!'};
}



/*func ret_str2() -> [2][10]Char8 {
    var out: [2][10]Char8
    out[0] = "hello "
    out[1] = "world!"
    return out
}*/

struct ret_str2_retval {char a[2 * 10];};
struct ret_str2_retval ret_str2()
{
    return *(struct ret_str2_retval *)&(struct ret_str2_retval){'a', 'b', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0', 'c', 'd', '\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0'};
}

struct ee_x {char a[2 * 10];};
void ee(struct ee_x x)
{
    //var y = x
    //y[0][6] = 0 to Char8
    //y[1][7] = 0 to Char8

    printf("%c\n", x.a[1 * 10 + 0]);
    printf("%c\n", x.a[1 * 10 + 1]);
    printf("%c\n", x.a[1 * 10 + 2]);
    /*printf("\n")

    var i = 0
    while i < 10 {
        printf("%c\n", y[0][i])
        i = i + 1
    }
    printf("\n")
    i = 0
    while i < 10 {
        printf("%c\n", y[1][i])
        i = i + 1
    }

    printf("ee_x[0] = %s\n", &y[0])
    printf("ee_x[1] = %s\n", &y[1])*/
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
    /*var local_array: [2]Int32

    local_array[0] = 10
    local_array[1] = 20

    let a = swap(local_array)

    printf("a[0] = %i\n", a[0])
    printf("a[1] = %i\n", a[1])

    let b = swap(global_array)

    printf("b[0] = %i\n", b[0])
    printf("b[1] = %i\n", b[1])*/

    /*var c = */

    //let d = c[0]

    //let s0 = c

    //var s1 = c

    // прикольно что имя массива чаров имеет тип char *
    // а ziseof = char [n] ))

    /*var s: [10]Char8
    s = c

    printf("s = %s\n", &s)
    printf("s[0] = %c\n", s[0])
    printf("s[1] = %c\n", s[1])
    printf("s[2] = %c\n", s[2])
    printf("s[3] = %c\n", s[3])
    printf("s[4] = %c\n", s[4])
    printf("s[5] = %c\n", s[5])
    printf("s[6] = %c\n", s[6])*/


    /*var s2 = ret_str()
    var s3 = s2

    s2 = s3

    printf("s2 = %s\n", &s2)
    printf("s3 = %s\n", &s3)

    var p0: Point
    var p1: Point

    p1 = p0

    var pod: Pod
    pod.x = ret_str()

    printf("pod.x = %s\n", &pod.x)*/


    /*let y = ret_str2() //-> [2][10]Char8
    var z = y
    printf("z[0] = %s\n", &z[0])
    printf("z[1] = %s\n", &z[1])


    printf("%c\n", y[1][0])
    printf("%c\n", y[1][1])
    printf("%c\n", y[1][2])
    printf("%c\n", y[1][3])
    printf("%c\n", y[1][4])

    ee(y)

    printf("end\n")*/

    /*
    let c = ret_str()
    //var s = c  // not worked
    var s: [10]Char8 = c
    */

    char w[2 * 10];
    memcpy(&w[0 * 10], &(char [10]){'h', 'e', 'l', 'l', 'o', '\0', '\0', '\0', '\0', '\0'}, sizeof (char [10]));
    memcpy(&w[1 * 10], &(char [10]){'w', 'o', 'r', 'l', 'd', '\0', '\0', '\0', '\0', '\0'}, sizeof (char [10]));
    char u[2 * 10];
    memcpy(&u, &w, sizeof u);
    kk(*(struct kk_x *)&u);


    return 0;
}

