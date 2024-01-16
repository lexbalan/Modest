

import copy
import hlir.type as type
from hlir.type import *
from .id import hlir_id





def hlir_init():
    type.hlir_type_init()


######################################################################
#                          HLIR COMMON                               #
######################################################################


def hlir_field(id, type, ti=None):
    return {
        'isa': 'field',
        'id': id,
        'type': type,
        'field_no': 0,
        'offset': 0,
        'nl': 0,
        'ti': ti
    }





######################################################################
#                           HLIR VALUE                               #
######################################################################


######################################################################
#                            HLIR STMT                               #
######################################################################


def hlir_stmt_bad(ti=None):
    return {'isa': 'stmt', 'kind': 'bad', 'att': [], 'ti': ti}


def hlir_stmt_block(stmts, ti=None, end_nl=1):
    return {
        'isa': 'stmt',
        'kind': 'block',
        'stmts': stmts,
        # количество пустых строк перед закрывающей скобкой блока
        'end_nl': end_nl,
        'att': [],
        'ti': ti
    }


def hlir_stmt_def_var(var_value, init_value=None, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'def_var',
        'var': var_value,
        'init_value': init_value,
        'att': [],
        'ti': ti
    }


def hlir_stmt_let(id, value, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'let',
        'id': id,
        'value': value,
        'att': [],
        'ti': ti
    }


def hlir_stmt_value(value, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'value',
        'value': value,
        'att': [],
        'ti': ti
    }


def hlir_stmt_assign(left, right, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'assign',
        'left': left,
        'right': right,
        'att': [],
        'ti': ti
    }


def hlir_stmt_if(cond, then, els=None, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'if',
        'cond': cond,
        'then': then,
        'else': els,
        'att': [],
        'ti': ti
    }


def hlir_stmt_while(cond, stmt, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'while',
        'cond': cond,
        'stmt': stmt,
        'att': [],
        'ti': ti
    }


def hlir_stmt_again(ti=None):
    return {'isa': 'stmt', 'kind': 'again', 'att': [], 'ti': ti}


def hlir_stmt_break(ti=None):
    return {'isa': 'stmt', 'kind': 'break', 'att': [], 'ti': ti}


def hlir_stmt_return(value=None, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'return',
        'value': value,
        'att': [],
        'ti': ti
    }



######################################################################
#                        HLIR DEFINITIONS                            #
######################################################################


def hlir_decl_type(type, ti):
    return {
        'isa': 'decl_type',
        'type': type,
        'ti': ti
    }


def hlir_def_type(type, already_declared=False, ti=None):
    return {
        'isa': 'def_type',
        'type': type,
        'afterdef': already_declared,
        'ti': ti
    }


def hlir_def_const(value_const, ti):
    return {
        'isa': 'def_const',
        'value': value_const,
        'ti': ti
    }


def hlir_def_var(value_var, ti):
    return {
        'isa': 'def_var',
        'value': value_var,
        'ti': ti
    }


def hlir_decl_func(value_func, ti):
    return {
        'isa': 'decl_func',
        'value': value_func,
        'ti': ti
    }


def hlir_def_func(value_func, ti):
    return {
        'isa': 'def_func',
        'value': value_func,
        'ti': ti
    }


