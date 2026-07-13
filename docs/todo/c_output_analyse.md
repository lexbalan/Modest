# Анализ качества сгенерированного C-кода

Анализ основан на примерах из `examples/`. Проблемы упорядочены по приоритету.

---

## Высокий приоритет

### 1. `x = x + 1` вместо `x++` / `--x`

Каждый `++i` в Modest-коде превращается в `i = i + 1` в C. Встречается везде — в
циклах, у полей структур, в счётчиках.

```c
// bubble_sort/out/c/main.c
i = i + 1;

// linked_list/out/c/list.c
list->size = list->size + 1;

// web/out/c/main.c
pageCounter = pageCounter + 1;
```

`x++`, `++x`, `x--`, `--x` — валидные C-выражения, идентичные по семантике
(как statements). Использование длинной формы ухудшает читаемость.

---

### 2. `#define n (expr)` / `#undef n` для `let`-биндингов

```c
// 3.multiply_table/out/c/main.c
int main(void) {
    #define n (2 * 2)
    printf("multiply table for %d\n", (int32_t)n);
    mtab(n);
    return 0;
    #undef n   // мёртвый код — после return
}
```

Проблемы:
- `#undef` после `return` — мёртвый код.
- `#define` не ограничен блоком — область видимости шире, чем у переменной.
- Отладчик не видит `n`.
- Имя может конфликтовать с макросами из системных заголовков.

Правильное решение: `const int32_t n = 2 * 2;`

---

### 3. `__builtin_bzero` / `__builtin_memcmp` / `__builtin_memcpy` вместо стандартных функций

```c
// server.c
__builtin_bzero(&buffer, sizeof(char [BUF_SIZE]));

// fsm.c
if (__builtin_memcmp(&self->next_state, &self->state, sizeof(fsm_ComplexState)) != 0)

// sha256.c
__builtin_memcpy(&ctx->state, &(const int32_t [8])INITAL_STATE, sizeof(uint32_t [8]));
```

Это GCC/Clang-специфичные расширения. Не компилируются на MSVC и нестандартных
тулчейнах. `<string.h>` уже включён в большинстве выходных файлов —
`memset`/`memcmp`/`memcpy` оптимизируются компилятором не хуже.

---

## Средний приоритет

### 4. Избыточный cast в compound literal: `T x = (T){...}`

```c
struct context ctx = (struct context){0};
self->state = (fsm_ComplexState){.state = initState, .stage = (fsm_StageId)0};
```

Когда тип слева уже объявлен, явный cast `(T)` в инициализаторе избыточен.
Достаточно `T x = {...}` или `T x = {.field = val}`.

---

### 5. Модульные константы через `#define` вместо `static const`

```c
// demo1/out/c/main.c
#define MIN_NUMBER 0
#define MAX_NUMBER 10

// web/out/c/main.c
#define PORT 8080
```

`#define` не имеет типа, области видимости, не виден в отладчике, может
конфликтовать по имени. Лучше: `static const int32_t PORT = 8080;` или
`enum { PORT = 8080 };`. Исключение — строковые константы (`HTTP_HEADER`),
где `#define` допустим.

---

### 6. Строковые `char[]`-поля разворачиваются в массив символов

```c
// 7.binary_file/out/c/main.c
struct chunk chunk = (struct chunk){
    .id = {'i', 'd'},
    .data = {'d', 'a', 't', 'a'}
};
```

Вместо читаемого:

```c
.id = "id",
.data = "data",
```

Оба варианта валидны для `char[]`-полей. Строковый литерал значительно понятнее.

---

### 7. Потенциальный UB в `abs(pos)` при `pos == INT32_MIN`

```c
// 8.linked_list/out/c/list.c
const uint32_t n = (uint32_t)abs(pos);       // ветка pos >= 0 — abs() лишний
const uint32_t n = (uint32_t)abs(-pos) - 1;  // ветка pos < 0 — UB при INT32_MIN
```

Вызов `abs()` на `int32_t` при значении `INT32_MIN` — undefined behavior (переполнение).
Безопаснее: `(uint32_t)(-(int64_t)pos)`. В положительной ветке `abs()` не нужен вообще.

---

### 8. Раздельное объявление и инициализация переменной

```c
int32_t number;
number = 0;  // вместо int32_t number = 0;
```

Везде, где Modest разделяет `var`-объявление и первый `=`. Двухшаговый стиль
хуже читается и оставляет переменную неинициализированной между строками.

---

## Низкий приоритет (шум / стиль)

### 9. Двойной cast `(struct sockaddr *)(void *)&addr`

```c
// server.c, client.c
struct sockaddr *const sockAddr = (struct sockaddr *)(void *)&serverAddr;
```

Промежуточный `(void *)` избыточен — в файле `web/out/c/main.c` уже используется
прямой каст. Несогласованность между файлами.

---

### 10. Избыточный cast `(TypeAlias)0` в сравнениях

```c
// 9.fsm/out/c/main.c
if (state.stage == (fsm_StageId)0)  // fsm_StageId — typedef uint16_t
if (state.stage == (fsm_StageId)1)
```

Целый литерал `0` неявно приводится к любому арифметическому типу в C.
Cast только добавляет шум.

---

### 11. `__asm__ volatile` всегда, даже для чистых asm-блоков с выходами

```c
// asm/out/c/main.c
__asm__ volatile ("add %0, %1, %2" : "=r" (sum) : "r" (a), "r" (b) : "cc");
```

`volatile` запрещает компилятору оптимизировать/перемещать блок. Для asm,
который только вычисляет значение и не имеет побочных эффектов, это мешает
оптимизатору. `volatile` следует ставить только там, где есть реальные
побочные эффекты (барьеры памяти, IO).

---

### 12. `#define LENGTHOF` дублируется в каждом файле

```c
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
```

Встречается в `bubble_sort`, `sha256`, `web`, `sockets`. Логичнее вынести
в общий runtime-заголовок компилятора.

---

### 13. Коллизионно-опасное преобразование `Point2D` → `point2_d`

`Point2D` → `point2_d` (underscore перед цифрой). Нестандартно и может
приводить к коллизиям: `Point2D` и `Point2d` дадут одно и то же имя.
Конвенциональнее: `point2d` или `point_2d`.

---

### 14. `(void *)` cast в `fwrite`/`fread` — лишний

```c
fwrite((void *)&chunk, sizeof(struct chunk), 1, fp);
fread((void *)&chunk, sizeof(struct chunk), 1, fp);
```

Любой указатель на объект неявно конвертируется в `void *` в C.

---

## Итого: приоритеты исправлений

| # | Проблема | Файлы | Приоритет |
|---|----------|-------|-----------|
| 1 | `x = x + 1` → `x++` / `--x` | Везде в циклах | Высокий |
| 2 | `#define`/`#undef` для `let` | `3.multiply_table` | Высокий |
| 3 | `__builtin_*` → `mem*` из `<string.h>` | `table`, `sha256`, `sockets` | Высокий |
| 4 | Лишний cast `(T){...}` | Все структуры | Средний |
| 5 | `#define` для констант → `static const` | `demo1`, `web`, `sockets` | Средний |
| 6 | `char[]` как `{'a','b'}` вместо `"ab"` | `7.binary_file` | Средний |
| 7 | UB в `abs(INT32_MIN)` | `8.linked_list` | Средний |
| 8 | Раздельное объявление + инициализация | Везде с `var` | Средний |
| 9 | Двойной `(void *)` cast | `10.sockets` | Низкий |
| 10 | `(TypeAlias)0` в сравнениях | `9.fsm` | Низкий |
| 11 | Лишний `volatile` в `__asm__` | `asm` | Низкий |
| 12 | `LENGTHOF` в каждом файле | `bubble_sort`, `sha256`, `web` | Низкий |
| 13 | `Point2D` → `point2_d` коллизии | `annotations` | Низкий |
| 14 | `(void *)` в `fwrite`/`fread` | `7.binary_file` | Низкий |
