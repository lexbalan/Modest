
import importlib
from hlir.hlir import *
from type import TypeFunc, TypeInt
from hlir.value import ValueLiteral

# создвем модуль

idStr = "main"
ast = None
symtab_public = None
symtab_private = None
sourcename = "main.m"
module = Module(idStr, ast, symtab_public, symtab_private, sourcename)


# Создаем и регистрируем определения

include0 = StmtDirectiveCInclude("stdio.h")
module.defs.append(include0)

comment0 = StmtCommentLine(['this is', 'line comment'], ti=None, nl=1)
module.defs.append(comment0)

comment1 = StmtCommentBlock("this is\nmultiline comment", ti=None, nl=1)
module.defs.append(comment1)

typeInt32 = TypeInt(32)
typeBool = TypeBool()

valueInt32_0 = ValueLiteral(typeInt32, 0)
valueInt32_1 = ValueLiteral(typeInt32, 1)
valueInt32_5 = ValueLiteral(typeInt32, 5)


# def type
nt = Type(ti=None)
nt.id = Id("MyType")
def_type = StmtDefType(Id("MyType"), nt, typeInt32, ti=None)
def_type.nl = 2
module.defs.append(def_type)


# def const
constant_init_value = valueInt32_1
constant = ValueConst(typeInt32, Id("CONDITION"), constant_init_value, ti=None)
def_constant = StmtDefConst(Id("CONDITION"), constant, constant_init_value, ti=None)
def_constant.nl = 2
module.defs.append(def_constant)


# def var
var_init_value = valueInt32_0
variable = ValueVar(typeInt32, Id("counter"), var_init_value, ti=None)
def_var = StmtDefVar(Id("counter"), variable, var_init_value, ti=None)
def_var.nl = 2
module.defs.append(def_var)


# stmt ++
addd = ValueBin(typeInt32, 'add', variable, valueInt32_1, ti=None)
stmt_inc = StmtAssign(variable, addd, ti=None)

# stmt while
cond = ValueBin(typeBool, 'lt', variable, valueInt32_5, ti=None)
stmt_block = StmtBlock([stmt_inc], ti=None)
stmt_while = StmtWhile(cond, stmt_block, ti=None)

# stmt if
cond = constant
stmt_then = StmtBlock([], ti=None)
stmt_else = StmtBlock([], ti=None)
stmt_if = StmtIf(cond, stmt_then, stmt_else, ti=None)
stmt_if.nl=2

# stmt return
retval = valueInt32_0
stmt0 = StmtReturn(retval, ti=None)
stmt0.nl=2

# def func
type_func_main_to = typeInt32
type_func_main_params = []
type_func_main = TypeFunc(type_func_main_params, type_func_main_to)
value_func_main = ValueFunc(type_func_main, Id("main"), ti=None)
stmt_func_main = StmtBlock([stmt_while, stmt_if, stmt0], ti=None)
def_func_main = StmtDefFunc("main", value_func_main, stmt_func_main, ti=None)
def_func_main.access_level = 'public'
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

