
#ifndef MAIN_H
#define MAIN_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>


#ifndef __BIG_INT128__
#define BIG_INT128(hi64, lo64) (((__int128)(hi64) << 64) | ((__int128)(lo64)))
#endif  /* __BIG_INT128__ */

#ifndef __BIG_INT256__
#define BIG_INT256(a, b, c, d)
#endif  /* __BIG_INT256__ */
int main(void);

#endif /* MAIN_H */
