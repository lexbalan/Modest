
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


# stmt while
cond = ValueLiteral(typeInt32, 0)
stmt_block = StmtBlock([], ti=None)
stmt_while = StmtWhile(cond, stmt_block, ti=None)


# stmt if
cond = ValueLiteral(typeInt32, 0)
stmt_then = StmtBlock([], ti=None)
stmt_else = StmtBlock([], ti=None)
stmt_if = StmtIf(cond, stmt_then, stmt_else, ti=None)
stmt_if.nl=2

# stmt return
retval = ValueLiteral(typeInt32, 0)
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

