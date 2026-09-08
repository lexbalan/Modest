#ifndef __FIXED_POINT__
#define __FIXED_POINT__

#include <stdint.h>

typedef int32_t __fixed32;
typedef int64_t __fixed64;

/* Округление к ближайшему, половина - от нуля: то же правило, что и у
   свертки констант, иначе одно и то же выражение давало бы разный
   результат в зависимости от того, известно оно заранее или нет.
   (!) Макрос обязан оставаться КОНСТАНТНЫМ ВЫРАЖЕНИЕМ - он попадает
   в статические инициализаторы, где вызов функции недопустим. Ценой
   этого (x) вычисляется дважды, поэтому сюда подставляются только
   литералы и константы; для рантайма есть __fixedX_from_float64 */
#define FIXED32(x, f) ((__fixed32)((double)(x) * (double)((int64_t)1 << (f)) + ((x) < 0 ? -0.5 : 0.5)))
#define FIXED64(x, f) ((__fixed64)((double)(x) * (double)((int64_t)1 << (f)) + ((x) < 0 ? -0.5 : 0.5)))

static inline __fixed64 __fixed64_create(int64_t i, uint64_t m, uint64_t n, uint8_t fraction) {
	return (i << fraction) | (m * (1 << fraction) / n);
}

/* у целого источника дробной части нет, поэтому масштаб - ровно
   сдвиг влево, и округлять тут нечего.
   (!) 1 сдвигаем в ширине результата: `1 << 31` на int - переполнение */
__attribute__((used))
static inline __fixed32 __fixed32_from_int32(int32_t a, uint8_t fraction) {
	return (__fixed32)(a * ((int32_t)1 << fraction));
}

__attribute__((used))
static inline __fixed64 __fixed64_from_int64(int64_t a, uint8_t fraction) {
	return (__fixed64)(a * ((int64_t)1 << fraction));
}

/* Перенос двоичной точки между разными @fraction. Считаем в int64
   независимо от ширин: у сужения (Fixed64 -> Fixed32) урезать
   операнд ДО переноса нельзя, целая часть уедет. Целевую ширину
   накладывает приведение результата на стороне вызова.
   Влево - точный сдвиг; вправо - округление к ближайшему, половина
   от нуля, тем же правилом, что и свертка */
__attribute__((used))
static inline int64_t __fixed_rescale(int64_t a, uint8_t from_fraction, uint8_t to_fraction) {
	if (to_fraction >= from_fraction) {
		return a << (to_fraction - from_fraction);
	} else {
		int64_t d = (int64_t)1 << (from_fraction - to_fraction);
		int64_t half = d / 2;
		return (a < 0 ? a - half : a + half) / d;
	}
}

/* аргумент вычисляется один раз (в отличие от макроса) - через это
   проходят рантаймовые значения, в т.ч. вызовы функций */
__attribute__((used))
static inline __fixed32 __fixed32_from_float64(double a, uint8_t fraction) {
	return FIXED32(a, fraction);
}

__attribute__((used))
static inline __fixed64 __fixed64_from_float64(double a, uint8_t fraction) {
	return FIXED64(a, fraction);
}

/* Обратная сторона __fixedX_from_*: снимаем масштаб.
   (!) 1 сдвигаем как int64_t: @fraction(N) доходит до 31 у Fixed32
   и до 63 у Fixed64, а `1 << 31` на int - переполнение со знаком.
   Деление, а не сдвиг: '/' у отрицательных отбрасывает дробь в
   сторону нуля - как того требует таблица конструирования и как
   считает свертка.

   Макрос и inline-функция считают одно и то же; макрос нужен затем,
   что известное заранее снятие масштаба попадает в статические
   инициализаторы, где вызов функции недопустим. В отличие от
   FIXED32()/FIXED64() операнд здесь вычисляется РОВНО ОДИН РАЗ,
   поэтому оговорки "только литералы и константы" тут не нужно */
#define __FIXED32_TO_INT32(x, f) ((int32_t)((x) / ((int64_t)1 << (f))))
#define __FIXED64_TO_INT64(x, f) ((int64_t)((x) / ((int64_t)1 << (f))))
#define __FIXED32_TO_FLOAT64(x, f) ((double)(x) / (double)((int64_t)1 << (f)))
#define __FIXED64_TO_FLOAT64(x, f) ((double)(x) / (double)((int64_t)1 << (f)))

__attribute__((used))
static inline int32_t __fixed32_to_int32(__fixed32 a, uint8_t fraction) {
	return (int32_t)(a / ((int64_t)1 << fraction));
}

__attribute__((used))
static inline int64_t __fixed64_to_int64(__fixed64 a, uint8_t fraction) {
	return a / ((int64_t)1 << fraction);
}

__attribute__((used))
static inline double __fixed32_to_float64(__fixed32 a, uint8_t fraction) {
	return (double)a / (double)((int64_t)1 << fraction);
}

__attribute__((used))
static inline double __fixed64_to_float64(__fixed64 a, uint8_t fraction) {
	return (double)a / (double)((int64_t)1 << fraction);
}

/* у mul масштаб возводится в квадрат, у div - сокращается;
   половину младшего разряда добавляем ДО деления, чтобы округление
   (к ближайшему, половина - от нуля) совпало со сверткой констант.
   Делим, а не сдвигаем: '/' у отрицательных отбрасывает дробь в
   сторону нуля, а '>>' - в сторону минус бесконечности, и половина
   ушла бы не от нуля, а вниз (плюс сдвиг отрицательного в C11 UB).
   Промежуточное произведение вдвое шире хранилища: int64_t у Fixed32,
   __int128 у Fixed64

   (!) МАКРОСЫ обязаны оставаться КОНСТАНТНЫМ ВЫРАЖЕНИЕМ - они попадают
   в статические инициализаторы, где вызов функции недопустим. Ценой
   этого операнды вычисляются дважды, поэтому они применяются только
   там, где выражение известно заранее; для рантайма есть одноименные
   inline-функции */
#define __FIXED32_MUL(a, b, f) \
	((__fixed32)(((int64_t)(a) * (int64_t)(b) < 0 \
		? (int64_t)(a) * (int64_t)(b) - (((int64_t)1 << (f)) / 2) \
		: (int64_t)(a) * (int64_t)(b) + (((int64_t)1 << (f)) / 2)) \
	/ ((int64_t)1 << (f))))

#define __FIXED32_DIV(a, b, f) \
	((__fixed32)((((a) < 0) == ((b) < 0) \
		? (int64_t)(a) * ((int64_t)1 << (f)) + (int64_t)(b) / 2 \
		: (int64_t)(a) * ((int64_t)1 << (f)) - (int64_t)(b) / 2) \
	/ (int64_t)(b)))

static inline __fixed32 __fixed32_mul(__fixed32 a, __fixed32 b, uint8_t fraction) {
	int64_t p = (int64_t)a * (int64_t)b;
	int64_t scale = (int64_t)1 << fraction;
	return (__fixed32)((p < 0 ? p - scale / 2 : p + scale / 2) / scale);
}

static inline __fixed32 __fixed32_div(__fixed32 a, __fixed32 b, uint8_t fraction) {
	int64_t n = (int64_t)a * ((int64_t)1 << fraction);
	int64_t half = (int64_t)b / 2;
	return (__fixed32)(((a < 0) == (b < 0) ? n + half : n - half) / (int64_t)b);
}

/* __int128 есть только у 64-битных целей: под guard, чтобы модуль,
   который пользуется одним лишь Fixed32, собирался и без него */
#ifdef __SIZEOF_INT128__

#define __FIXED64_MUL(a, b, f) \
	((__fixed64)(((__int128)(a) * (__int128)(b) < 0 \
		? (__int128)(a) * (__int128)(b) - (((__int128)1 << (f)) / 2) \
		: (__int128)(a) * (__int128)(b) + (((__int128)1 << (f)) / 2)) \
	/ ((__int128)1 << (f))))

#define __FIXED64_DIV(a, b, f) \
	((__fixed64)((((a) < 0) == ((b) < 0) \
		? (__int128)(a) * ((__int128)1 << (f)) + (__int128)(b) / 2 \
		: (__int128)(a) * ((__int128)1 << (f)) - (__int128)(b) / 2) \
	/ (__int128)(b)))

static inline __fixed64 __fixed64_mul(__fixed64 a, __fixed64 b, uint8_t fraction) {
	__int128 p = (__int128)a * (__int128)b;
	__int128 scale = (__int128)1 << fraction;
	return (__fixed64)((p < 0 ? p - scale / 2 : p + scale / 2) / scale);
}

static inline __fixed64 __fixed64_div(__fixed64 a, __fixed64 b, uint8_t fraction) {
	__int128 n = (__int128)a * ((__int128)1 << fraction);
	__int128 half = (__int128)b / 2;
	return (__fixed64)(((a < 0) == (b < 0) ? n + half : n - half) / (__int128)b);
}

#endif /* __SIZEOF_INT128__ */

#endif /* __FIXED_POINT__ */
