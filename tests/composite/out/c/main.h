// tests/composite
//

#ifndef MAIN_H
#define MAIN_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

// Test for composite types

// Pointers

// Functions

// Pointers to function

// Arrays
// Проблема в том что мой getelementptr не умеет в цепь-молнию
// а здесь без нее никак... придется взяться за это и сделать наконец
//var a6: [2][5]*Int = [
//	[&a4[0][0], &a4[0][1], &a4[0][2], &a4[0][3], &a4[0][4]]
//	[&a4[1][0], &a4[1][1], &a4[1][2], &a4[1][3], &a4[1][4]]
//]

//

int32_t main();

#endif /* MAIN_H */
