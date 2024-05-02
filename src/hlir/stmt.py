######################################################################
#							HLIR STMT							   #
######################################################################



def hlir_stmt_bad(x):
	return {
		'isa': 'stmt',
		'kind': 'bad',
		'ast_stmt': x,
		'att': [],
		'ti': x['ti']
	}


def hlir_stmt_block(stmts, ti=None, end_nl=1):
	return {
		'isa': 'stmt',
		'kind': 'block',
		'stmts': stmts,
		# количество пустых строк перед закрывающей скобкой блока
		'end_nl': end_nl,
		'att': [],
		'nl': 0,
		'ti': ti
	}


def hlir_stmt_def_var(var_value, init_value=None, ti=None):
	return {
		'isa': 'stmt',
		'kind': 'def_var',
		'var': var_value,
		'default_value': init_value,
		'att': [],
		'nl': 0,
		'ti': ti
	}


def hlir_stmt_let(id, value, new_value, ti=None):
	return {
		'isa': 'stmt',
		'kind': 'let',
		'id': id,
		'init_value': value,
		'value': new_value,
		'att': [],
		'nl': 0,
		'ti': ti
	}


def hlir_stmt_value(value, ti=None):
	return {
		'isa': 'stmt',
		'kind': 'value',
		'value': value,
		'att': [],
		'nl': 0,
		'ti': ti
	}


def hlir_stmt_assign(left, right, ti=None):
	return {
		'isa': 'stmt',
		'kind': 'assign',
		'left': left,
		'right': right,
		'att': [],
		'nl': 0,
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
		'nl': 0,
		'ti': ti
	}


def hlir_stmt_while(cond, stmt, ti=None):
	return {
		'isa': 'stmt',
		'kind': 'while',
		'cond': cond,
		'stmt': stmt,
		'att': [],
		'nl': 0,
		'ti': ti
	}


def hlir_stmt_again(ti=None):
	return {'isa': 'stmt', 'kind': 'again', 'att': [], 'nl': 0, 'ti': ti}


def hlir_stmt_break(ti=None):
	return {'isa': 'stmt', 'kind': 'break', 'att': [], 'nl': 0, 'ti': ti}


def hlir_stmt_return(value=None, ti=None):
	return {
		'isa': 'stmt',
		'kind': 'return',
		'value': value,
		'att': [],
		'nl': 0,
		'ti': ti
	}


def hlir_stmt_asm(text, outputs, inputs, clobbers, ti=None):
	return {
		'isa': 'stmt',
		'kind': 'asm',
		'text': text,
		'outputs': outputs,
		'inputs': inputs,
		'clobbers': clobbers,
		'att': [],
		'nl': 0,
		'ti': ti
	}



def hlir_stmt_is_bad(x):
	return x['kind'] == 'bad'

