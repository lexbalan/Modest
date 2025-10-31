
#ifndef MAIN_H
#define MAIN_H

#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>





struct main_Rec1;
typedef struct main_Rec1 main_Rec1;

struct main_Rec0 {
	main_Rec1 *p;
};
typedef struct main_Rec0 main_Rec0;

struct main_Rec1 {
	main_Rec0 *p;
};
typedef struct main_Rec1 main_Rec1;
int32_t main();

#endif /* MAIN_H */
