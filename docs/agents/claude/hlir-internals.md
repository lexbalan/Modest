# HLIR Internals

All definitions live in `src/hlir/types.py`. Singletons and factory functions in `src/hlir/defs.py`.

## Base classes

```
Entity          — has .ti (TextInfo), .attributes dict, .parent
  ├─ Type       — has .kind, .width, .size, .align, .ops, .generic, .brand
  ├─ Value      — has .type, .id, .asset, .stage, .is_lvalue, .is_immutable
  └─ Stmt       — has .ti, .nl (newlines before), .deps
```

---

## Types

### Type hierarchy

```
Type
  ├─ TypeBad                      # error sentinel — eq to anything
  ├─ TypeUndefined
  ├─ TypeSimple                   # all scalar types
  │    ├─ TypeInteger             # generic Integer literal type
  │    └─ TypeRational            # generic Rational literal type
  ├─ TypeFunc      .params .to .extra_args(bool)
  ├─ TypeArray     .of .volume(Value)
  ├─ TypeRecord    .fields(list[Field])
  ├─ TypePointer   .to
  └─ TypeVaList
```

### TypeSimple kinds (`.kind` field)

| Constant | Types |
|----------|-------|
| `HLIR_TYPE_KIND_INT` | Int8..Int256 |
| `HLIR_TYPE_KIND_NAT` | Nat8..Nat256 |
| `HLIR_TYPE_KIND_WORD` | Word8..Word256 |
| `HLIR_TYPE_KIND_FLOAT` | Float32, Float64 |
| `HLIR_TYPE_KIND_FIXED` | Fixed32, Fixed64 |
| `HLIR_TYPE_KIND_CHAR` | Char8, Char16, Char32 |
| `HLIR_TYPE_KIND_BOOL` | Bool |
| `HLIR_TYPE_KIND_STRING` | generic string literal |
| `HLIR_TYPE_KIND_INTEGER` | generic Integer literal |

### Predefined singletons (from `hlir/defs.py`)

```python
typeUnit          # {} / void — TypeRecord with no fields
typeBool
typeInteger       # generic
typeRational      # generic
typeNil           # generic *Unit (null pointer)
typeFreePointer   # *Unit
typeStr8/16/32    # open []Char* with @zarray attribute
typeWord8..256
typeInt8..256
typeNat8..256
typeChar8/16/32
typeFloat32/64
typeFixed32/64
typeByte          # alias for typeWord8
```

### Key Type methods

```python
t.is_type_int()          t.is_type_nat()          t.is_type_word()
t.is_type_float()        t.is_type_char()         t.is_type_bool()
t.is_type_unit()         t.is_type_record()       t.is_type_array()
t.is_type_pointer()      t.is_type_func()         t.is_type_string()
t.is_generic()      t.is_branded()

t.is_type_unsized_array()   # []Type  (volume is ValueUndef)
t.is_type_sized_array() # [N]Type (volume is known)
t.is_free_pointer() # *Unit
t.is_type_pointer_to_record()
t.is_type_pointer_to_array()
t.is_type_pointer_to_func()

Type.eq(a, b)                      # structural equality, brand-aware
Type.select_common_type(a, b, ti)  # for binary ops, array literals, etc.
t.to_str()                         # human-readable name (uses modest backend)
```

### Field (record field)

```python
Field(id: Id, type: Type, init_value: Value, access_level, ti)
  .field_no   # index in record
  .offset     # byte offset (computed by calc_record_size_align)
  .access_level  # HLIR_ACCESS_LEVEL_{PUBLIC,PRIVATE,LOCAL,UNDEFINED}
```

---

## Values

### Value hierarchy

```
Value
  ├─ ValueBad                   # error sentinel
  ├─ ValueUndef    .type        # uninitialized / unknown
  ├─ ValueLiteral  .asset       # compile-time scalar
  ├─ ValueArray    .asset       # list of Values
  ├─ ValueRecord   .asset       # list of Initializer
  ├─ ValueVar      .id .init_value          # variable reference (lvalue)
  ├─ ValueConst    .id .init_value          # constant reference
  ├─ ValueFunc     .id .type(TypeFunc)      # function reference
  ├─ ValueBin      .op .left .right         # binary operation
  ├─ ValueNot      .value                   # logical/bitwise not
  ├─ ValueNeg      .value                   # unary minus
  ├─ ValuePos      .value                   # unary plus
  ├─ ValueShl      .left .right
  ├─ ValueShr      .left .right
  ├─ ValueCons     .value .oftype .method   # type construction (not cast!)
  ├─ ValueCall     .func .args(list)
  ├─ ValueRef      .value                   # & address-of
  ├─ ValueDeref    .value                   # * dereference (lvalue)
  ├─ ValueSubexpr  .value                   # parenthesized subexpression
  ├─ ValueIndex    .left .index             # arr[i] (lvalue)
  ├─ ValueSlice    .left .index_from .index_to
  ├─ ValueAccessRecord  .left .field(Field) # record.field (lvalue)
  ├─ ValueAccessModule  .imp .id .value
  ├─ ValueNew      .value                   # heap allocation
  ├─ ValueSizeofType    .oftype
  ├─ ValueSizeofValue   .ofvalue
  ├─ ValueAlignofType   .oftype
  ├─ ValueAlignofValue  .value
  ├─ ValueLengthofType  .oftype
  ├─ ValueLengthofValue .value
  ├─ ValueOffsetof      .oftype .field
  ├─ ValueVaStart  .va_list .last_param
  ├─ ValueVaArg    .va_list
  ├─ ValueVaEnd    .va_list
  └─ ValueVaCopy   .dst .src
```

### Value.stage

| Constant | Meaning |
|----------|---------|
| `HLIR_VALUE_STAGE_COMPILETIME` | known at compile time (`.asset` is set) |
| `HLIR_VALUE_STAGE_LINKTIME` | known at link time |
| `HLIR_VALUE_STAGE_RUNTIME` | runtime value |

### ValueCons.method

| Value | Meaning |
|-------|---------|
| `'implicit'` | automatic coercion (generic → concrete) |
| `'explicit'` | `Int32 x` — explicit construction |
| `'unsafe'`   | `unsafe Nat64 &ptr` — reinterpret |
| `'default'`  | zero/default value |
| `'extra_arg'`| variadic argument promotion |

### Binary op constants (`HLIR_VALUE_OP_*`)

```python
# arithmetic
HLIR_VALUE_OP_ADD, SUB, MUL, DIV, REM, NEG, POS
# comparison
HLIR_VALUE_OP_LT, GT, LE, GE, EQ, NE
# logical
HLIR_VALUE_OP_LOGIC_OR, LOGIC_AND, LOGIC_NOT
# bitwise
HLIR_VALUE_OP_BITWISE_AND, BITWISE_OR, BITWISE_XOR, BITWISE_NOT
HLIR_VALUE_OP_SHL, SHR
# special
HLIR_VALUE_OP_CONS, CALL, REF, DEREF, INDEX, SLICE, ACCESS
```

---

## Statements

```
Stmt
  ├─ StmtBad
  ├─ StmtComment / StmtCommentLine / StmtCommentBlock
  ├─ StmtImport        .module .name .include(bool)
  ├─ StmtDef           (abstract, has .id .access_level)
  │    ├─ StmtDefType  .type .original_type
  │    ├─ StmtDefVar   .value(ValueVar) .init_value
  │    ├─ StmtDefConst .value(ValueConst) .init_value
  │    └─ StmtDefFunc  .value(ValueFunc) .stmt(StmtBlock)
  ├─ StmtBlock         .stmts(list)
  ├─ StmtValueExpression .value
  ├─ StmtAssign        .left .right
  ├─ StmtIf            .cond .then .els(optional)
  ├─ StmtWhile         .cond .stmt
  ├─ StmtReturn        .value(optional)
  ├─ StmtBreak
  ├─ StmtAgain
  ├─ StmtAsm           .text .outputs .inputs .clobbers
  └─ StmtDirective
       ├─ StmtDirectiveCInclude  .c_name
       └─ StmtDirectiveInsert    .text
```

### Checking statement kind

```python
stmt.is_stmt_def_func()
stmt.is_stmt_block()
stmt.is_stmt_assign()
stmt.is_stmt_if()
stmt.is_stmt_while()
stmt.is_stmt_return()
# etc. — all is_stmt_XXX() methods on Stmt base class
```

---

## Module

```python
Module
  .id           # module name string
  .symtab       # public symbol table
  .imports      # dict id_str → StmtImport
  .defs         # list of top-level Stmt
  .strings      # for LLVM backend
  .anon_recs    # anonymous records for C backend
```

---

## Id (identifier)

```python
Id(str)
  .str      # source name
  .c        # C backend output name
  .llvm     # LLVM backend output name
  .cm       # Modest backend output name
  .c_alias  # alternate C name (e.g. for typedefs)
```

Always set `.c`, `.llvm`, `.cm` when creating a new `Id` for a named entity.

---

## Access levels

```python
HLIR_ACCESS_LEVEL_PUBLIC    # exported from module
HLIR_ACCESS_LEVEL_PRIVATE   # module-private (default for typedef fields)
HLIR_ACCESS_LEVEL_LOCAL     # function-local
HLIR_ACCESS_LEVEL_UNDEFINED # not yet resolved
```
