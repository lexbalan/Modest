
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

type_func_main_to = typeInt32
type_func_main_params = []
type_func_main = TypeFunc(type_func_main_params, type_func_main_to)
value_func_main = ValueFunc(type_func_main, Id("main"), ti=None)

retval = ValueLiteral(typeInt32, 0)
stmt0 = StmtReturn(retval, ti=None)
stmt_func_main = StmtBlock([stmt0], ti=None)
def_func_main = StmtDefFunc("main", value_func_main, stmt_func_main, ti=None)
def_func_main.access_level = 'public'
module.defs.append(def_func_main)

# распечатываем модуль

settings = {
	'output_style': 'legacy',
	'int_width': 32,
}

backend_impline = "backend.c"
backend = importlib.import_module(backend_impline)
backend.init(settings)
backend.run(module, "out")

