
import importlib

from hlir import *


# создаем модуль

idStr = "main"
ast = None
symtab_public = None
symtab_private = None
sourcename = "main.m"
module = Module(idStr, ast, symtab_public, symtab_private, sourcename)


# Создаем и регистрируем определения

include0 = StmtDirectiveCInclude("stdio.h")
module.defs.append(include0)

comment0 = StmtCommentLine(['this is', 'line comment'], nl=1)
module.defs.append(comment0)

comment1 = StmtCommentBlock("this is\nmultiline comment", nl=1)
module.defs.append(comment1)

typeInt32 = TypeInt(32)
typeBool = TypeBool()

valueInt32_0 = ValueLiteral(typeInt32, 0)
valueInt32_1 = ValueLiteral(typeInt32, 1)
valueInt32_5 = ValueLiteral(typeInt32, 5)


# def type
nt = Type(ti=None)
nt.id = Id("MyType")
def_type = StmtDefType(Id("MyType"), nt, typeInt32)
def_type.nl = 2
module.defs.append(def_type)


# def const
constant_init_value = valueInt32_1
constant = ValueConst(typeInt32, Id("CONDITION"), constant_init_value)
def_constant = StmtDefConst(Id("CONDITION"), constant, constant_init_value)
def_constant.nl = 2
module.defs.append(def_constant)


# def var
var_init_value = valueInt32_0
variable = ValueVar(typeInt32, Id("counter"), var_init_value)
def_var = StmtDefVar(Id("counter"), variable, var_init_value)
def_var.nl = 2
module.defs.append(def_var)


# stmt ++
addd = ValueBin(typeInt32, HLIR_VALUE_OP_ADD, variable, valueInt32_1)
stmt_inc = StmtAssign(variable, addd)

# stmt while
cond = ValueBin(typeBool, HLIR_VALUE_OP_LT, variable, valueInt32_5)
stmt_block = StmtBlock([stmt_inc])
stmt_while = StmtWhile(cond, stmt_block)

# stmt if
cond = constant
stmt_then = StmtBlock([])
stmt_else = StmtBlock([])
stmt_if = StmtIf(cond, stmt_then, stmt_else)
stmt_if.nl=2

# stmt return
retval = valueInt32_0
stmt_ret = StmtReturn(retval)
stmt_ret.nl=2

# def func main
type_func_main_to = typeInt32
type_func_main_params = []
type_func_main = TypeFunc(type_func_main_params, type_func_main_to)
value_func_main = ValueFunc(type_func_main, Id("main"))
stmt_func_main = StmtBlock([stmt_while, stmt_if, stmt_ret])
def_func_main = StmtDefFunc("main", value_func_main, stmt_func_main)
def_func_main.access_level = HLIR_ACCESS_LEVEL_PUBLIC
def_func_main.nl = 2
module.defs.append(def_func_main)


# def func add
type_func_main_to = typeInt32
p0 = Field(Id("a"), typeInt32, init_value=ValueUndef(typeInt32))
p1 = Field(Id("b"), typeInt32, init_value=ValueUndef(typeInt32))
type_func_main_params = [p0, p1]
type_func_main = TypeFunc(type_func_main_params, type_func_main_to)
value_func_main = ValueFunc(type_func_main, Id("sum"))


param_a = ValueConst(p0.type, p0.id, init_value=ValueUndef(p0.type))
param_a.storage_class = VALUE_STORAGE_CLASS_PARAM

param_b = ValueConst(p1.type, p1.id, init_value=ValueUndef(p1.type))
param_b.storage_class = VALUE_STORAGE_CLASS_PARAM

retval = ValueBin(typeInt32, HLIR_VALUE_OP_ADD, param_a, param_b)
stmt_ret = StmtReturn(retval)

stmt_func_main = StmtBlock([stmt_ret])
def_func_main = StmtDefFunc("sum", value_func_main, stmt_func_main)
def_func_main.access_level = HLIR_ACCESS_LEVEL_PRIVATE
def_func_main.nl = 2
module.defs.append(def_func_main)


# печатаем модуль

settings = {
	'output_style': 'legacy',
	'int_width': 32,
}

backend_impline = "backend.c"
backend = importlib.import_module(backend_impline)
backend.init(settings)
backend.run(module, "out")

