"""
from error import *


ctx = {}

# compile-time call
def ct_call(x):
	info("ct_call", x['expr_ti'])

	global ctx
	old_ctx = ctx


	#
	# ADD args to context
	#
	params = x['func']['type']['params']
	i = 0
	while i < len(params):
		p = params[i]
		a = x['args'][i]

		print("ADD %s" % p['id']['str'])
		ctx[p['id']['str']] = a

		i = i + 1


	# run block!
	y = ct_stmt_block(x['func']['stmt'])

	if y != None:
		print("Y!")

	ctx = old_ctx
	return x



def ct_stmt_block(x):
	for stmt in x['stmts']:
		y = ct_stmt(stmt)
		if y != None:
			return y

	return None


def ct_stmt(x):
	k = x['kind']
	y = None
	if k == 'block': y = ct_stmt_block(x)
	#elif k == 'value': ct_stmt_value(x)
	#elif k == 'assign': ct_stmt_assign(x)
	elif k == 'return': y = ct_stmt_return(x)
	#elif k == 'if': y = ct_stmt_if(x)
	#elif k == 'while': ct_stmt_while(x)
	#elif k == 'var': ct_stmt_var(x)
	#elif k == 'let': ct_stmt_let(x)
	#elif k == 'break': ct_stmt_break(x)
	#elif k == 'again': ct_stmt_again(x)
	return



def ct_stmt_return(x):
	print("ct_stmt_return!")
	if x['value'] != None:
		return ct_value(x['value'])
	return None


def ct_value(x):
	pass




"""
