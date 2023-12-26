
#include <stdarg.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm


void _putchar(char c)
{
    putchar((int)c);
}


void put_str8(char *s)
{
    int i = 0;
    while (true) {
        const char c = s[i];
        if (c == '\x0') {
            break;
        }
        _putchar((char)c);
        i = i + 1;
    }
}


void sprintf_dec_int32(char *buf, int x);
void sprintf_dec_nat32(char *buf, uint32_t x);
void sprintf_hex_nat32(char *buf, uint32_t x);



void ff_printf(char *str, ...)
{
    va_list __vargs;
    va_start(__vargs, str);
    int i = 0;
    while (true) {
        char c = str[i];

        if (c == '\x0') {
            break;
        }

        if (c == '%') {
            i = i + 1;
            c = str[i];

            // буффер для печати всего, кроме строк
            char buf[10 + 1];
            char *sptr;
            sptr = (char *)&buf[0];
            sptr[0] = '\x0';

            if ((c == 'i') || (c == 'd')) {
                // %i & %d for signed integer (Int)
                const int32_t i = va_arg(__vargs, const int32_t);
                sprintf_dec_int32(sptr, (int)i);
            } else if (c == 'n') {
                // %n for unsigned integer (Nat)
                const uint32_t n = va_arg(__vargs, const uint32_t);
                sprintf_dec_nat32(sptr, (uint32_t)n);
            } else if ((c == 'x') || (c == 'p')) {
                // %x for unsigned integer (Nat)
                // %p for pointers
                const uint32_t x = va_arg(__vargs, const uint32_t);
                sprintf_hex_nat32(sptr, (uint32_t)x);
            } else if (c == 's') {
                // %s pointer to string
                char *const s = va_arg(__vargs, char *const);
                sptr = s;
            } else if (c == 'c') {
                // %c for char
                const char c = va_arg(__vargs, const char);
                sptr[0] = c;
                sptr[1] = 0;
            } else if (c == '%') {
                // %% for PERCENT_SYMBOL
                sptr = "%";
            }

            put_str8(sptr);

        } else {
            _putchar(c);
        }

        i = i + 1;
    }
    va_end(__vargs);
}


char n_to_sym(uint8_t n)
{
    char c;
    if (n <= 9) {
        c = (char)('0' + n);
    } else {
        c = (char)('A' + n - 10);
    }
    return c;
}


void sprintf_hex_nat32(char *buf, uint32_t x)
{
    char cc[8];

    uint32_t d = x;

    int i = 0;
    while (true) {
        const uint32_t n = d % 16;
        d = d / 16;

        cc[i] = n_to_sym((uint8_t)n);
        i = i + 1;

        if (d == 0) {
            break;
        }
    }

    // mirroring into buffer
    int j = 0;
    while (i > 0) {
        i = i - 1;
        buf[j] = cc[i];
        j = j + 1;
    }

    buf[j] = 0;

    //return buf
}


void sprintf_dec_int32(char *buf, int x)
{
    char cc[11];

    int32_t d = x;

    const bool neg = d < 0;

    if (neg) {
        d = -d;
    }

    int i = 0;
    while (true) {
        const int32_t n = d % 10;
        d = d / 10;
        cc[i] = n_to_sym((uint8_t)n);
        i = i + 1;

        if (d == 0) {
            break;
        }
    }

    int j = 0;

    if (neg) {
        buf[0] = '-';
        j = j + 1;
    }

    while (i > 0) {
        i = i - 1;
        buf[j] = cc[i];
        j = j + 1;
    }

    buf[j] = '\x0';

    //return buf
}


void sprintf_dec_nat32(char *buf, uint32_t x)
{
    char cc[11];

    uint32_t d = x;

    int i = 0;
    while (true) {
        const uint32_t n = d % 10;
        d = d / 10;
        cc[i] = n_to_sym((uint8_t)n);
        i = i + 1;

        if (d == 0) {
            break;
        }
    }

    int j = 0;
    while (i > 0) {
        i = i - 1;
        buf[j] = cc[i];
        j = j + 1;
    }

    buf[j] = '\x0';

    //return buf
}



int main(void)
{
    ff_printf("Hello World!\n");

    const char c = '$';
    char *const s = "Hi!";
    const int32_t i = (const int32_t)-1;
    const uint32_t n = 123;
    const uint32_t x = 0x1234567F;

    ff_printf("%% = '%%'\n");
    ff_printf("c = '%c'\n", c);
    ff_printf("s = \"%s\"\n", s);
    ff_printf("i := %i\n", i);
    ff_printf("n = %n\n", n);
    ff_printf("x = 0x%x\n", x);

    return 0;
}

