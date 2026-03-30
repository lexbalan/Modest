
import importlib

from hlir import *


mit_license = """
	MIT License

	Copyright (c) [year] [fullname]

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
"""


module = Module(idStr="main", ast=None, symtab_public=None, symtab_private=None, sourcename="main.m")

block_comment = StmtCommentBlock(mit_license, nl=0)
module.defs.append(block_comment)


include0 = StmtDirectiveCInclude("stdio.h")
module.defs.append(include0)

line_comment = StmtCommentLine(['this is', 'a line comment'])
module.defs.append(line_comment)


valueInt32_0 = ValueLiteral(typeInt32, 0)
valueInt32_1 = ValueLiteral(typeInt32, 1)
valueInt32_5 = ValueLiteral(typeInt32, 5)


# def type
module.defs.append(StmtCommentLine(['this is a type definition'], nl=2))
new_type = Type(ti=None)
new_type.id=Id("MyType")
def_type = StmtDefType(Id("MyType"), new_type=new_type, proto_type=typeInt32)
module.defs.append(def_type)


# def const
module.defs.append(StmtCommentLine(['this is a constant definition'], nl=2))
constant_init_value = valueInt32_1
constant = ValueConst(typeInt32, Id("CONDITION"), constant_init_value)
def_constant = StmtDefConst(Id("CONDITION"), constant, constant_init_value)
module.defs.append(def_constant)


# def var
module.defs.append(StmtCommentLine(['this is a variable definition'], nl=2))
var_init_value = valueInt32_0
variable = ValueVar(typeInt32, Id("counter"), var_init_value)
def_var = StmtDefVar(Id("counter"), variable, var_init_value)
module.defs.append(def_var)


module.defs.append(StmtCommentLine(['this is a function definition'], nl=2))

# stmt ++
addd = ValueBin(typeInt32, HLIR_VALUE_OP_ADD, variable, valueInt32_1)
stmt_inc = StmtAssign(variable, addd)

# stmt while
cond = ValueBin(typeBool, HLIR_VALUE_OP_LT, variable, valueInt32_5)
stmt_block = StmtBlock([stmt_inc])
stmt_while = StmtWhile(cond, stmt_block)

# stmt if
if_cond = constant
stmt_then = StmtBlock([StmtCommentLine([' then branch'])])
stmt_else = StmtBlock([StmtCommentBlock(' else branch ')])
stmt_if = StmtIf(if_cond, stmt_then, stmt_else, nl=2)

# stmt return
stmt_ret = StmtReturn(value=valueInt32_0, nl=2)

# def func main
type_func_main_to = typeInt32
type_func_main_params = []
type_func_main = TypeFunc(type_func_main_params, type_func_main_to)
value_func_main = ValueFunc(type_func_main, Id("main"))
stmt_func_main = StmtBlock([stmt_while, stmt_if, stmt_ret])
def_func_main = StmtDefFunc("main", value_func_main, stmt_func_main)
def_func_main.access_level = HLIR_ACCESS_LEVEL_PUBLIC
module.defs.append(def_func_main)


# def func add
type_func_main_to = typeInt32
param0 = Field(Id("a"), typeInt32, init_value=ValueUndef(typeInt32))
param1 = Field(Id("b"), typeInt32, init_value=ValueUndef(typeInt32))
type_func_main_params = [param0, param1]
type_func_main = TypeFunc(type_func_main_params, type_func_main_to)
value_func_main = ValueFunc(type_func_main, Id("sum"))

param_a = ValueConst(param0.type, param0.id, init_value=ValueUndef(param0.type))
param_a.storage_class = HLIR_VALUE_STORAGE_CLASS_PARAM

param_b = ValueConst(param1.type, param1.id, init_value=ValueUndef(param1.type))
param_b.storage_class = HLIR_VALUE_STORAGE_CLASS_PARAM

retval = ValueBin(typeInt32, HLIR_VALUE_OP_ADD, param_a, param_b)
stmt_ret = StmtReturn(retval)

stmt_func_main = StmtBlock([stmt_ret])
def_func_main = StmtDefFunc("sum", value_func_main, stmt_func_main)
def_func_main.access_level = HLIR_ACCESS_LEVEL_PRIVATE
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

