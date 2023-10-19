
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/3.const/main.cm

#define genericIntConst  42
#define int32Const  genericIntConst

#define genericStringConst  "Hello!"
#define string8Const  genericStringConst
#define string16Const  genericStringConst
#define string32Const  genericStringConst


typedef struct {
    uint32_t x;
    uint32_t y;
} Point;

#define points  (Point [3]){ \
    (Point){.x = 0, .y = 0}, \
    (Point){.x = 1, .y = 1}, \
    (Point){.x = 2, .y = 2} \
}


// есть проблема - в C глобальные переменные с модификатором const
// не могут быть так инициализированы, поскольку points является приведением
// непонятно существует ли хорошее решение
//@property("c_prefix", "const")
Point points2[3] = points;


// define function main
int main(void)
{
    printf("test const\n");

    printf("genericIntConst = %d\n", (int32_t)genericIntConst);
    printf("int32Const = %d\n", int32Const);

    //	printf("genericStringConst = %s\n", genericStringConst)
    printf("string8Const = %s\n", string8Const);

    return 0;
}

