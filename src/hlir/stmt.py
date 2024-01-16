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


