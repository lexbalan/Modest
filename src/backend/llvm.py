
import copy
from .common import *
from error import info, warning, error, fatal
import type as htype
from type import type_print
from value.value import value_attribute_check, value_print, value_is_undefined, value_is_immediate, value_terminal, value_is_zero, value_is_param
from type import type_pointer
from util import align_bits_up
import settings

import foundation

LLVM_TARGET_TRIPLE = ""
LLVM_TARGET_DATALAYOUT = ""


# LLVM не умеет нативно возвращать большие значения
# Для этого есть механизм sret;
# когда первым параметром идет указатель на возвращаемое значение (ABI)
RET_SIZE_MAX = 16
def need_sret(func_type):
	return htype.type_is_closed_array(func_type['to'])
	#return func_type['to']['size'] > RET_SIZE_MAX


INDENT_SYMBOL = "\t"

NL_INDENT = "\n%s" % INDENT_SYMBOL


fctx = None  # current function context

def fctx_push(ctx):
	global fctx
	prev_fctx = fctx
	fctx = ctx
	ctx['prev_fctx'] = prev_fctx

def fctx_pop():
	global fctx
	if fctx != None:
		fctx = fctx['prev_fctx']
	else:
		assert(False)


def is_global_context():
	return fctx == None


llvm_value_num_zero = None

def init():
	global LLVM_TARGET_TRIPLE, LLVM_TARGET_DATALAYOUT, llvm_value_num_zero
	LLVM_TARGET_TRIPLE = settings.get('target_triple')
	LLVM_TARGET_DATALAYOUT = settings.get('target_datalayout')
	llvm_value_num_zero = llvm_value_num(foundation.typeInt32, 0)


def indent():
	ind(INDENT_SYMBOL)


def lo(s):
	out('\n')
	indent()
	out(s)


def locals_push():
	fctx['locals'].append({})

def locals_pop():
	fctx['locals'].pop()

def locals_add(id, llval):
	fctx['locals'][-1][id] = llval

def locals_get(id):
	# идем по стеку контекстов вглубь в поиске id
	i = len(fctx['locals'])
	while i > 0:
		c = fctx['locals'][i - 1]
		if id in c:
			return c[id]
		i = i - 1
	return None



free_reg = 0

def reg_get():
	global fctx
	assert(not is_global_context())  # we can get reg only locally!
	reg = fctx['free_reg']
	fctx['free_reg'] = fctx['free_reg'] + 1
	return str(reg)


def ll_reg_operation(op, type, reg=None):
	if reg == None:
		reg = reg_get()
	lo("%%%s = %s " % (reg, op))
	return llvm_value_reg(reg, type)


def type_get_aka(t):
	if 'id' in t:
		if 'llvm' in t['id']:
			return t['id']['llvm']

		id_str = t['id']['str']
		if 'prefix' in t['id']:
			#id_str = t['definition']['module']['prefix'] + '_' + id_str

			prefix = t['definition']['module']['prefix']
			if prefix != None:
				id_str = prefix + '_' + id_str

		return '%' + id_str
	return None


def get_id_str(x):
	if 'llvm' in x['id']:
		return '"%s"' % x['id']['llvm']

	id_str = x['id']['str']
	if 'prefix' in x['id']:
		prefix = x['definition']['module']['prefix']
		if prefix != None:
			id_str = prefix + '_' + id_str

	return id_str



def llvm_value_zero(type):
	return {
		'isa': 'll_value',
		'kind': 'zero',
		'type': type,
		'is_adr': False
	}


def llvm_value_num(type, num):
	return {
		'isa': 'll_value',
		'kind': 'num',
		'type': type,
		'asset': num,
		'is_adr': False
	}


def llvm_value_reg(reg, type):
	return {
		'isa': 'll_value',
		'kind': 'reg',
		'type': type,
		'reg': reg,
		'is_adr': False
	}


def llvm_value_id(id, type):
	return {
		'isa': 'll_value',
		'kind': 'id',
		'type': type,
		'id': id,
		'is_adr': False
	}


def llvm_value_record(items, type):
	return {
		'isa': 'll_value',
		'kind': 'record',
		'type': type,
		'items': items,
		'is_adr': False
	}


def llvm_value_array(items, type):
	return {
		'isa': 'll_value',
		'kind': 'array',
		'type': type,
		'items': items,
		'is_adr': False
	}


def llvm_value_str(strid, _str, type, isz=True):
	length = len(_str)
	if isz:
		length = length + 1
	return {
		'isa': 'll_value',
		'kind': 'str',
		'type': type,
		'id': strid,
		'len': length,
		'str': _str,
		'is_adr': False
	}



def llvm_value_inline_cast(type, value):
	return {
		'isa': 'll_value',
		'kind': 'inline_cast',
		'type': type,
		'value': value,
		'is_adr': False
	}




def llvm_print_type_value(x, noundef=False):
	assert(x['isa'] == 'll_value')

	print_type(x['type'])
	if x['is_adr']:
		out("* ")
	else:
		out(" ")

	if noundef:
		out(" noundef")

	llvm_print_value(x)


# вставляет значение поля в 'структуру по значению'
def insertvalue(x, v, pos):
	# %5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
	# %6 = insertvalue %Type24 %5, %Int32 2, 1
	assert(x['isa'] == 'll_value')
	assert(v['isa'] == 'll_value')
	rv = ll_reg_operation('insertvalue', x['type'])
	llvm_print_type_value(x)
	out(", ")
	llvm_print_type_value(v)
	out(", %d" % pos)
	return rv


# возвращает значение поля из 'структуры по значению'
def extractvalue(x, t, pos):
	# %x = extractvalue %Point %p, 0
	# %y = extractvalue %Point %p, 1
	rv = ll_reg_operation('extractvalue', t)
	llvm_print_type_value(x)
	out(', %d' % pos)
	return rv



#"%16 = bitcast i8** %3 to i8*"
#"call void @llvm.va_start(i8* %16)"
def llvm_va_start(x):
	y = llvm_cast('bitcast', x, foundation.typeFreePointer)
	lo("call void @llvm.va_start(i8* %%%s)" % y['reg'])
	return llvm_value_zero(foundation.typeUnit)


#%44 = va_arg i8** %3, i32
def llvm_va_arg(va_list, typ):
	rv = ll_reg_operation('va_arg', typ)
	llvm_print_type_value(va_list)
	out(", ")
	print_type(typ)
	return rv


#"%96 = bitcast i8** %3 to i8*"
#"call void @llvm.va_end(i8* %96)"
def llvm_va_end(x):
	y = llvm_cast('bitcast', x, foundation.typeFreePointer)
	lo("call void @llvm.va_end(i8* %%%s)" % y['reg'])
	return llvm_value_zero(foundation.typeUnit)


def llvm_va_copy(dst, src):
	dst = llvm_cast('bitcast', dst, foundation.typeFreePointer)
	src = llvm_cast('bitcast', src, foundation.typeFreePointer)
	lo("call void @llvm.va_copy(i8* %%%s, i8* %%%s)" % (dst['reg'], src['reg']))
	return llvm_value_zero(foundation.typeUnit)



def llvm_inline_cast(op, to_type, val):
	assert(to_type['isa'] == 'type')
	assert(val['isa'] == 'll_value')
	out("%s (" % op)
	llvm_print_type_value(val)
	out(" to ")
	print_type(to_type)
	out(")")



def llvm_print_value_array(x):
	items = x['items']

	if len(items) == 0:
		out("zeroinitializer")
		return

	out("[\n")
	indent_up()
	n = len(items)
	i = 0
	while i < n:
		item = items[i]
		if i > 0: out(",\n")
		indent()
		llvm_print_type_value(item)
		i = i + 1
	indent_down()
	out("\n"); indent(); out("]")



def llvm_print_value_record(x):
	if len(x['items']) == 0:
		out("zeroinitializer")
		return

	out("{\n")
	indent_up()
	n = len(x['items'])
	i = 0
	while i < n:
		item = x['items'][i]
		if i > 0: out(",\n")
		indent()
		llvm_print_type_value(item['value'])
		i = i + 1
	indent_down()
	out("\n")
	indent()
	out("}")



def llvm_print_value_str(x):
	string_of = x['type']['to']['of']
	char_width = string_of['width']
	str_len = x['len']

	out("bitcast ([%d x i%d]* @%s to [0 x i%d]*)" % (str_len, char_width, x['id'], char_width))



def llvm_print_value_num(x):
	num = x['asset']

	if htype.type_is_pointer(x['type']):
		if num == 0:
			out("null")
		else:
			v = llvm_value_num(foundation.typeNat64, num)
			llvm_inline_cast('inttoptr', x['type'])
		return

	# integer, float, bool, char
	if htype.type_is_float(x['type']):
		# короче суть такая - число сперва нужно причесать
		# так, чтобы оно могло быть четко представлено в LLVM float/double
		# наче LLVM не примет его и сгенерирует ошибку
		packed_float = _float_value_pack(num, x['type']['width'])
		return out("%.16f" % packed_float)

	out(str(num))






def llvm_print_value_inlinecast(x):
	v = x['value']
	t = x['type']
	opcode = select_cast_operator(v['type'], t)
	llvm_inline_cast(opcode, t, v)



def llvm_print_value_zero(x):
	if htype.type_is_composite(x['type']):
		out("zeroinitializer")
	elif htype.type_is_pointer(x['type']):
		out("null")
	else:
		out("0")



def llvm_print_value(x):
	assert(x['isa'] == 'll_value')

	k = x['kind']
	if k == 'reg': out('%%%s' % x['reg'])
	elif k == 'id': out('@%s' % x['id'])
	elif k == 'num': llvm_print_value_num(x)
	elif k == 'str': llvm_print_value_str(x)
	elif k == 'array': llvm_print_value_array(x)
	elif k == 'record': llvm_print_value_record(x)
	elif k == 'inline_cast': llvm_print_value_inlinecast(x)
	elif k == 'zero': llvm_print_value_zero(x)
	else:
		out("<llvm::unknown_value_kind '%s'>" % k)
		info("<llvm::unknown_value_kind '%s'>" % k, x['ti'])

	return




def llvm_eval_binary(op, l, r, x=None):
	assert(l['isa'] == 'll_value')
	assert(r['isa'] == 'll_value')

	result_type = l['type']
	if x != None:
		result_type = x['type']

	rv = ll_reg_operation(op, result_type)
	print_type(l['type'])
	out(" ")
	llvm_print_value(l)
	out(", ")
	llvm_print_value(r)
	return rv



def llvm_deref(x):
	assert(x['isa'] == 'll_value')
	nv = copy.copy(x)
	nv['is_adr'] = True
	return nv



# индекс не может быть i64 (!) (а только i32)
# t - тип самой записи или массива (без указателя)
def llvm_getelementptr(v, object_type, indexes, result_type):
	# Есть такой прикол в том что индекс (i) структуры
	# не может быть i64 (!) (а только i32)
	rv = ll_reg_operation('getelementptr inbounds', result_type)
	rv['is_adr'] = True
	print_type(object_type)
	out(", ")
	llvm_print_type_value(v)
	out(", ")
	print_list_with(indexes, llvm_print_type_value)
	return rv



def llvm_cast(kind, value, to_type):
	rv = ll_reg_operation(kind, to_type)
	llvm_print_type_value(value)
	out(" to ")
	print_type(to_type)
	return rv


def llvm_2cast(kind, from_type, to_type, value):
	rv = ll_reg_operation(kind, to_type)
	print_type(from_type)
	out(" ")
	llvm_print_value(value)
	out(" to ")
	print_type(to_type)
	return rv


def llvm_load(x):
	assert(x['isa'] == 'll_value')

	if x['is_adr']:
		rv = ll_reg_operation('load', x['type'])
		print_type(x['type'])
		out(", ")
		llvm_print_type_value(x)
		return rv

	return x


# сохр простых значений
def llvm_store(dst, src):
	assert(dst['isa'] == 'll_value')
	assert(src['isa'] == 'll_value')
	lo("store ")
	llvm_print_type_value(src)
	out(", ")
	llvm_print_type_value(dst)
	return dst



# получает два указателя, и размер
def llvm_memcpy_immsize(dst, src, size, volatile=False):
	#"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
	dst2 = llvm_cast('bitcast', dst, foundation.typeFreePointer)
	src2 = llvm_cast('bitcast', src, foundation.typeFreePointer)
	out(NL_INDENT)
	out("call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(")
	llvm_print_type_value(dst2)
	out(", "); llvm_print_type_value(src2)
	out(", i32 %d" % size);
	out(", i1 %d)" % volatile)


# получает два указателя, и размер
def llvm_memcpy(dst, src, size, volatile=False):
	#"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
	dst2 = llvm_cast('bitcast', dst, foundation.typeFreePointer)
	src2 = llvm_cast('bitcast', src, foundation.typeFreePointer)
	out(NL_INDENT)
	out("call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(")
	llvm_print_type_value(dst2)
	out(", "); llvm_print_type_value(src2)
	out(", "); llvm_print_type_value(size)
	out(", i1 %d)" % volatile)


#declare void @llvm.memset.p0.i32(ptr <dest>, i8 <val>, i32 <len>, i1 <isvolatile>)
def llvm_memzero(dst, size, volatile=False):
	#"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
	dst2 = llvm_cast('bitcast', dst, foundation.typeFreePointer)
	out(NL_INDENT)
	out("call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(")
	llvm_print_type_value(dst2)
	out(", i8 0, i32 %d" % size); #llvm_print_type_value(size)
	out(", i1 %d)" % volatile)



# грубо привести тип integer value к ширине width
def trim(int_value, width):
	assert(int_value['isa'] == 'll_value')
	if int_value['type']['width'] != width:
		return docast(int_value, foundation.typeNat32)
	return int_value


def llvm_memzero(dst, size, volatile=False):
	#"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
	dst2 = llvm_cast('bitcast', dst, foundation.typeFreePointer)
	out(NL_INDENT)

	out("call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(")
	llvm_print_type_value(dst2)
	out(", i8 0, ")
	llvm_print_type_value(size)
	out(", i1 %d)" % volatile)



# memset with offset from start of dst
def llvm_memzero_off(dst, offset, size, volatile=False):
	ll_off = llvm_value_num(foundation.typeInt32, offset)

	# offset pointer
	dst2 = llvm_cast("ptrtoint", dst, foundation.typeInt64)

	ll_dst_plus_off = llvm_eval_binary('add', dst2, ll_off)

	dst3 = llvm_cast("inttoptr", ll_dst_plus_off, foundation.typeFreePointer)

	# do memzero
	llvm_memzero(dst3, size, volatile=volatile)


# получает два указателя, и размер
# LLVM не имеет интиринсика memcmp поэтому используем стандартный...
# @param op = ['eq', 'ne']
def llvm_memcmp(op, p0, p1, size):
	_p0 = llvm_cast('bitcast', p0, foundation.typeFreePointer)
	_p1 = llvm_cast('bitcast', p1, foundation.typeFreePointer)
	rv = ll_reg_operation('call', foundation.typeBool)
	out("i1 (i8*, i8*, i64) @memeq(")
	llvm_print_type_value(_p0)
	out(", ")
	llvm_print_type_value(_p1)
	out(", ")
	llvm_print_type_value(size)
	out(")")

	zero = llvm_value_num(foundation.typeBool, 0)
	op = 'ne' if op == 'eq' else 'eq'
	rv2 = llvm_eval_binary('icmp %s' % op, rv, zero, {'type': foundation.typeBool})

	return rv2


def llvm_br(x, then_label, else_label):
	lo("br ")
	llvm_print_type_value(x)
	out(" , label %%%s, label %%%s" % (then_label, else_label))


def llvm_jump(label):
	lo("br label %%%s" % label)


def llvm_label(label):
	out("\n%s:" % label)


def llvm_alloca(typ, id_str=None, size=None, alignment=0):
	# ;%8 = alloca i32, i64 %6, align 4;
	assert(typ['isa'] == 'type')

	llv = ll_reg_operation('alloca', typ, reg=id_str)
	llv['is_adr'] = True

	print_type(typ)

	if size != None:
		out(", ")
		llvm_print_type_value(size)

	if alignment != 0:
		out(", align %d" % alignment)

	return llv




def llvm_alloca_store(typ, id_str=None, init_value=None):
	nv = llvm_alloca(typ, id_str=id_str)
	if init_value != None:
		return llvm_store(nv, init_value)
	return nv


# получает на вход llvm_value
# и если оно adr то загружает его в регистр
# в любом другом случае просто возвращает исходное значение
def llvm_dold(x):
	assert(x['isa'] == 'll_value')

	if x['is_adr']:
		# It's address of the value, we need to load it
		return llvm_load(x)

	# It is "value by value"
	return x



# получает укзаатель на структуру x
# его тип
# носер поля (просто число)
# возвращает value:address для поля этой структуры
def llvm_eval_access_ptr(x, rec_type, field_no, result_type):
	field_index = llvm_value_num(foundation.typeInt32, field_no)
	return llvm_getelementptr(x, rec_type, (llvm_value_num_zero, field_index), result_type)


def llvm_eval_access(rec, field_no, result_type):
	rt = rec['type']
	# если это структура высичленная на ходу, у нее есть поле 'items'
	# там лежат записи вида {'id': ..., 'value': ...}
	# поле value ссылается при этом на уже вычисленное значение поля
	# ex: let p = {x=0, y=0};	p.x	// <--
	if 'items' in rec:
		return rec['items'][field_no]['value']

	# если сама запись находится в регистре: (let rec = get_rec())
	if not rec['is_adr']:
		return extractvalue(rec, result_type, field_no)

	# если работаем через 'переменую-указатель'
	# сперва нужно загрузить ее в регистр тем самым получим 'указатель'
	if htype.type_is_pointer(rt):
		# pointer to record needs additional load
		rec = llvm_dold(rec)  # загружаем указатель в регистр
		rt = rt['to']

	return llvm_eval_access_ptr(rec, rt, field_no, result_type)




def print_list_with(lst, method):
	i = 0
	while i < len(lst):
		if i > 0: out(", ")
		method(lst[i])
		i = i + 1



def print_type_enum(t):
	out('i%d' % t['width'])


def print_type_record(t):
	packed = 'packed' in t['att']

	if packed:
		out("<")

	out("{")
	fields = t['fields']
	i = 0
	while i < len(fields):
		field = fields[i]

		if i > 0: out(',')
		if is_global_context():
			out(NL_INDENT)

		print_type(field['type'])

		i = i + 1

	if is_global_context():
		out("\n")

	out("}")

	if packed:
		out(">")


def print_type_array(t):
	sz = 0
	if not htype.type_is_vla(t):
		array_size = t['volume']
		if array_size != None:
			sz = array_size['asset']

	out("[")
	out("%d x " % sz)
	print_type(t['of'])
	out("]")



def print_type_pointer(t):
	if htype.type_is_free_pointer(t):
		out("i8*")
	else:
		print_type(t['to']); out("*")



def print_type_id(t):
	t_id = type_get_aka(t)
	if t_id == None:
		return False
	out(t_id)
	return True



def print_int_type_for(width):
	# Generic int can have width (for example) 6 bit, etc.
	out("i%d" % align_bits_up(width))


# функция может получать только указатель на массив
# если же в CM она получает массив то тут и в СИ она получает
# указатель на него, и потом копирует его во внутренний массив
def print_type(t):
	assert(t['isa'] == 'type')
	print_aka=True
	k = t['kind']

	id_str = type_get_aka(t)
	if id_str != None:
		out(id_str)
		return

	if print_aka:
		# тупой LLVM не умеет делать алиасы структур
		# он типа делает, но потом к переменной с таким типом
		# хрен обратишься... дерьмо
		if htype.type_is_record(t):
			if 'id' in t:
				out("%" + t['id']['str'])
				return

		res = print_type_id(t)
		if res:
			return

		# иногда сюда залетают дженерики например в to левое:
		# let p = 0x12345678 to *Nat32
		if htype.type_is_number(t):
			print_int_type_for(t['width'])
			return

	if htype.type_is_func(t): print_type_func(t)
	elif htype.type_is_record(t): print_type_record(t)
	elif htype.type_is_pointer(t): print_type_pointer(t)
	elif htype.type_is_array(t): print_type_array(t)
	elif htype.type_is_enum(t): print_type_enum(t)

	elif htype.type_is_integer(t):
		print_int_type_for(t['width'])

	elif htype.type_is_float(t):
		if t['width'] <= 32:
			out("float")
		else:
			out("double")

	elif htype.type_is_char(t):
		print_int_type_for(t['width'])

	elif htype.type_is_undefined(t):
		out('opaque')

	elif htype.type_is_va_list(t):
		out("i8*")

	else:
		out("<type:%s>" % k)



def do_reval(x):
	return llvm_dold(do_eval(x))


def do_eval_bin(x):

	if value_is_immediate(x):
		return do_eval_literal(x)

	op = x['kind']
	# Composite objects comparison (see below)
	# requires not value, just ADR of value (!)
	l = do_eval(x['left'])
	r = do_eval(x['right'])

	if htype.type_is_composite(x['left']['type']):
		if op in ['eq', 'ne']:
			# Composite objects comparison
			# (eq/ne between composite types)

			# ex:
			#  a == b
			#  a == {x=0, y=0}
			#  *pa == *pb

			# В LLVM нет возможности сравнивать композитные значения
			# Единственный вариант - использовать memcmp ()
			# Для этого нам НУЖНЫ НЕ САМИ ЗНАЧЕНИЯ а их АДРЕСА (adr | pointer)
			# Поэтому мы не здесь не вызываем для них llvm_dold

			# НО если левое или правое уже находится в регистре (само) -
			# выделим под него память на стеке, сохраним его туда,
			# и будем использовать указатель на эту память

			if not l['is_adr']:
				if l['kind'] == 'reg':
					l = llvm_alloca_store(l['type'], id_str=None, init_value=l)

			if not r['is_adr']:
				if r['kind'] == 'reg':
					r = llvm_alloca_store(r['type'], id_str=None, init_value=r)

			# Теперь сравниваем значения по указателям и длине (memcmp)
			sz = llvm_value_num(foundation.typeInt64, l['type']['size'])
			return llvm_memcmp(op, l, r, sz)

		return None

	# working simple objects
	# requires their values as is in register
	l = llvm_dold(l)
	r = llvm_dold(r)

	if op in ['shl', 'shr']:
		# LLVM requires the same type for left & right arguments of shift operator
		# cast right to left
		if not htype.type_is_generic(r['type']):
			r = docast(r, l['type'])

	llvm_opcode = get_bin_opcode(op, x['left']['type'])
	return llvm_eval_binary(llvm_opcode, l, r, x)



def do_eval_deref(x):
	ptr_val = do_reval(x['value'])
	return llvm_deref(ptr_val)


def do_eval_ref(v):
	ve = do_eval(v['value'])

	if is_global_context():
		if v['value']['kind'] == 'var':
			if 'global' in v['value']['att']:
				return llvm_value_id(get_id_str(v['value']), v['type'])

	nv = copy.copy(ve)
	nv['is_adr'] = False
	return nv


def do_eval_not(v, xor_msk):
	#%10 = xor i32 %9, -1
	# or
	#%10 = xor i32 %9, 1
	ve = do_reval(v['value'])
	minus_one = llvm_value_num(v['type'], xor_msk)
	return llvm_eval_binary('xor', ve, minus_one, v)



def do_eval_neg(v):
	#%10 = sub i32 0, %9
	ve = do_reval(v['value'])
	zero = llvm_value_num(v['type'], 0)
	return llvm_eval_binary('sub', zero, ve, v)




def do_eval_call(v):
	# eval all args
	args = []
	for a in v['args']:
		arg = None
		if a['isa'] == 'initializer':
			arg = do_reval(a['value'])
		else:
			arg = do_reval(a)

		#arg = do_reval(a['value'])
		args.append(arg)

	func = v['func']
	ftype = func['type']

	sret = need_sret(ftype)

	sret_retval = False
	if sret:
		out("; alloca memory for return value")
		sret_retval = llvm_alloca(ftype['to'])

	# eval func
	f = do_eval(func)

	if htype.type_is_pointer(ftype):
		# pointer to array needs additional load
		f = llvm_dold(f)
		ftype = ftype['to']

	to_unit = htype.type_eq(ftype['to'], foundation.typeUnit)


	# do call
	rv = None
	if to_unit or sret:
		lo("call ")
		rv = llvm_value_zero(ftype['to'])
	else:
		rv = ll_reg_operation('call', ftype['to'])

	if ftype['extra_args']:
		print_type_func(ftype)
	else:
		if htype.type_is_unit(ftype['to']):
			out("void")
		elif htype.type_is_array(ftype['to']):
			out("void")
		else:
			print_type(ftype['to'])

	out(" ")
	llvm_print_value(f)

	out("(")
	if sret:
		llvm_print_type_value(sret_retval)#, noundef=True)
		if len(args) > 0:
			out(", ")

	print_list_with(args, llvm_print_type_value)
	out(")")

	if sret:
		return sret_retval

	return rv




def is_closed_array_param(value):
	if value_is_param(value):
		if htype.type_is_closed_array(value['type']):
			return True
	return False


def do_eval_index(v):
	if value_is_immediate(v):
		return do_eval(v['immval'])

	left = do_eval(v['array'])
	index = do_reval(v['index'])
	result_type = v['type']


	if htype.type_is_pointer(left['type']):
		# Left is a pointer in 'reg' to pointer to array
		# (access to array via pointer)
		ptr2arr = llvm_load(left)
		array_type = ptr2arr['type']['to']
		return llvm_getelementptr(ptr2arr, array_type, (llvm_value_num_zero, index), result_type)


	# Left is an array

	if not is_closed_array_param(v['array']):
		if not left['is_adr']:
			# Left is an array placed in 'reg' as value
			if not value_is_immediate(v['index']):
				error("expected immediate index value", v['ti'])
				return llvm_value_zero(v['ti'])

			return extractvalue(left, result_type, index['asset'])

	# Left is a pointer to array in 'reg'
	return llvm_getelementptr(left, left['type'], (llvm_value_num_zero, index), result_type)



def do_eval_slice(v):
	if value_is_immediate(v):
		return do_eval(v['immval'])

	varray = v['left']
	if htype.type_is_pointer(varray['type']):
		pointer = do_reval(varray)
		array_type = pointer['type']['to']
		index = do_reval(v['index_from'])
		result_type = v['type']
		ptr_to_item = llvm_getelementptr(pointer, array_type, (llvm_value_num_zero, index), array_type['of'])
		out("\n;")

		pnv = llvm_cast("bitcast", ptr_to_item, type_pointer(v['type']))
		pnv['is_adr'] = True
		return pnv


	array = do_eval(varray)
	array_type = array['type']
	result_type = v['type']
	index = do_reval(v['index_from'])

	# если сам массив находится в регистре: (let rec = get_rec())
	if not array['is_adr']:
		if not value_is_immediate(v['index']):
			error("expected immediate index value", v['ti'])
			return llvm_value_zero(v['ti'])

		return extractvalue(array, result_type, index['asset'])

	ptr_to_item = llvm_getelementptr(array, array_type, (llvm_value_num_zero, index), array_type['of'])
	pnv = llvm_cast("bitcast", ptr_to_item, type_pointer(v['type']))
	pnv['is_adr'] = True
	return pnv




def do_eval_access(v):
	if htype.type_is_pointer(v['record']['type']):
		ptr = do_reval(v['record'])
		rt = ptr['type']['to']
		pos = v['field']['field_no']
		result_type = v['type']
		return llvm_eval_access_ptr(ptr, rt, pos, result_type)

	if value_is_immediate(v):
		return do_eval(v['immval'])

	result_type = v['type']
	rec = do_eval(v['record'])
	pos = v['field']['field_no']
	return llvm_eval_access(rec, pos, result_type)


def do_eval_access_ptr(v):
	ptr = do_reval(v['pointer'])
	rt = ptr['type']['to']
	pos = v['field']['field_no']
	result_type = v['type']
	return llvm_eval_access_ptr(ptr, rt, pos, result_type)



def do_eval_access_module(x):
	return do_eval(x['value'])


'trunc .. to'
'zext .. to'
'sext .. to'
'fptrunc .. to'
'fpext .. to'
'fptoui .. to'
'fptosi .. to'
'uitofp .. to'
'sitofp .. to'
'ptrtoint .. to'
'inttoptr .. to'
'bitcast .. to'
'addrspacecast .. to'

# cast type a to type b
def select_cast_operator(a, b):
	if htype.type_is_number(a) or htype.type_is_integer(a) or htype.type_is_char(a) or htype.type_is_bool(a) or htype.type_is_word(a):
		if htype.type_is_number(b) or htype.type_is_integer(b) or htype.type_is_char(b) or htype.type_is_bool(b) or htype.type_is_word(b):
			signed = htype.type_is_signed(b)

			# Это плохо тк не работает в некоторых особых ситуациях
			# например для  i17 to i32 вернет bitcast что неверно!
			# но пока не убираю тк непонятно чем аукнется еще
			#aw = align_bits_up(a['width'])
			#bw = align_bits_up(b['width'])

			aw = a['width']
			bw = b['width']

			if aw < bw:
				return 'sext' if signed else 'zext'

			elif aw > bw:
				return 'trunc'

			else:
				return 'bitcast'

		elif htype.type_is_pointer(b):
			return 'inttoptr'

		elif htype.type_is_float(b):
			return 'sitofp' if htype.type_is_signed(a) else 'uitofp'

	elif htype.type_is_pointer(a):
		if htype.type_is_pointer(b):
			return 'bitcast'
		elif htype.type_is_integer(b):
			return 'ptrtoint'

	elif htype.type_is_float(a):
		# Float -> Integer
		if htype.type_is_integer(b):
			return 'fptosi' if htype.type_is_signed(b) else 'fptoui'

		# Float -> Float
		elif htype.type_is_float(b):
			if a['width'] < b['width']:
				return 'fpext'
			elif a['width'] > b['width']:
				return 'fptrunc'
			else:
				return 'bitcast'

	return 'cast <%s -> %s>' % (a['kind'], b['kind'])



def is_adr_or_ptr(x):
	assert(x['isa'] == 'll_value')
	return x['is_adr'] or htype.type_is_pointer(x['type'])


def cons_composite_from_composite(to_type, value, ti):
	#info("cons_composite_from_composite", ti)
	v = do_eval(value)

	if is_global_context():
		# не можем приводить глобально (used!)
		return v

	if v['is_adr']:
		# received not value but it address (formally pointer)
		out("\n; -- cons_composite_from_composite_by_adr --")
		casted_ptr = llvm_cast("bitcast", v, type_pointer(to_type))
		casted_ptr['type'] = to_type
		casted_ptr['is_adr'] = True
		llv = llvm_load(casted_ptr)
		out("\n; -- end cons_composite_from_composite_by_adr --")
		return llv

	#
	# received value in reg
	#

	out("\n; -- cons_composite_from_composite_by_value --")
	if to_type['size'] > value['type']['size']:
		#out("\n\t; extend")
		# выделим память под новое значение
		nv = llvm_alloca(to_type)
		# приводим указатель на слот к указателю на (меньшее) значение
		xnv = llvm_cast("bitcast", nv, type_pointer(v['type']))
		llvm_store(xnv, v)
		nv['is_adr'] = True
	else:
		#out("\n\t; trunk")
		y = llvm_alloca_store(v['type'], init_value=v)
		nv = llvm_cast("bitcast", y, type_pointer(to_type))
		nv['is_adr'] = True
	out("\n; -- end cons_composite_from_composite_by_value --")
	return nv






def eval_cons_record(x):
	value = x['value']
	from_type = value['type']
	to_type = x['type']

	#if value_is_immediate(x):
	if 'items' in x:
		return do_eval_literal(x)

	# Cm имеет структурную систему типов, тогда как llvm - номинативную
	# приведение структуры к структуре по значению не поддерживается LLVM
	# поэтому делаем его специально
	return cons_composite_from_composite(to_type, value, x['ti'])



def eval_cons_array(x):
	if value_is_immediate(x):
		if htype.type_is_vla(x['type']):
			return do_eval_literal(x['value'])
		return do_eval_literal(x)

	return cons_composite_from_composite(x['type'], x['value'], x['ti'])



def do_eval_cons(x):
	value = x['value']
	from_type = value['type']
	to_type = x['type']

	#print(to_type['kind'])

	# skipping cast to the same type
	if id(value['type']) == id(to_type):
		return do_reval(value)

	if htype.type_is_pointer(to_type):
		if htype.type_is_pointer(from_type):
			# skipping cast pointer to pointer of the same type
			if id(to_type['to']) == id(from_type['to']):
				return do_reval(value)


	if htype.type_is_array(to_type):
		return eval_cons_array(x)

	if htype.type_is_record(to_type):
		return eval_cons_record(x)


	if value_is_immediate(value):
		# В случае Nat32 &x у нас занчение immediate но нет asset тк это поздний imm
		if 'asset' in x:
			if not htype.type_is_pointer(to_type):
				#info("???", x['ti'])
				return do_eval_literal(x)


	if htype.type_is_pointer(to_type):
		if htype.type_is_array_of_char(to_type['to']):
			if htype.type_is_string(from_type):
				string_of = to_type['to']['of']
				char_pow = string_of['width']
				return llvm_value_str(x['strid'], x['asset'], x['type'], isz='zstring' in x['att'])


	# cast any type to Unit type
	if htype.type_is_unit(to_type):
		return llvm_value_zero(to_type)

	if htype.type_is_va_list(from_type):
		# приведение объекта типа va_list в CM особенное
		# оно дает доступ к следующему элементу списка
		rv = do_eval(value)
		return llvm_va_arg(rv, to_type)

	v = do_reval(value)

	# anyNonZeroValue to Bool  ==  true  (!)
	# (the same as in C)
	if htype.type_is_bool(to_type):
		zero = llvm_value_num(v['type'], 0)
		return llvm_eval_binary('icmp ne', v, zero, x)


	if is_global_context():
		return v

	# Приводим immediate значение прямо по месту
	if value_is_immediate(value):
		return llvm_value_inline_cast(to_type, v)

	return docast(v, to_type)



def docast(v, to_type):
	from_type = v['type']
	opcode = select_cast_operator(from_type, to_type)
	return llvm_cast(opcode, v, to_type)



bin_ops = [
	'logic_or', 'logic_and',
	'or', 'xor', 'and', 'shl', 'shr',
	'eq', 'ne', 'lt', 'gt', 'le', 'ge',
	'add', 'sub', 'mul', 'div', 'rem',
]


def do_eval_string(x):
	info("do_eval_string??", x['ti'])



def do_eval_array(v):
	# сперва вычисляем все элементы массива в регистры
	# (кроме констант, они едут до последнего)
	items = []
	for item in v['items']:
		iv = do_reval(item)
		items.append(iv)


	# теперь добавим паддинг нулевыми значениями
	fulllen = 0
	if v['type']['volume'] != None:
		if value_is_immediate(v['type']['volume']):
			fulllen = v['type']['volume']['asset']
	else:
		fulllen = len(v['items'])

	n_pad = fulllen - len(items)
	if n_pad > 0:
		i = 0
		while i < n_pad:
			zero = llvm_value_zero(v['type']['of'])
			items.append(zero)
			i = i + 1

	# global?
	# глобальный массив распечатает print_value как литерал
	if is_global_context():
		return llvm_value_array(items, v['type'])

	#
	# local context
	#

	# если мы локальны то создадим иммутабельную структуру
	# с массивом (insertvalue)
	#%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
	xv = llvm_value_array([], v['type'])

	# нет смысла засовывать в 'массив по значению' нулевые элементы
	# тк он порождается из zeroinitializer и zero filled by default

	# набиваем массив
	items = []
	i = 0
	while i < len(v['items']):
		item = v['items'][i]
		if not value_is_zero(item):
			lliv = do_reval(item)
			xv = insertvalue(xv, lliv, i)
		i = i + 1

	return xv



# вычисляем значение-запись по месту
# просто высичлим все его элементы и завернем все в 'll_value'/'record'
def do_eval_record(v):
	# сперва вычисляем все иницифлизаторы поелей структуры в регистры
	# (кроме констант, ведь они едут до последнего)
	rec_type = v['type']

	if is_global_context():
		items = []
		for initializer in v['items']:
			iv = do_reval(initializer['value'])
			items.append({'id': initializer['id'], 'value': iv})
		return llvm_value_record(items, rec_type)

	# local context

	xv = llvm_value_record([], rec_type)

	# набиваем структуру
	for initializer in v['items']:
		# нет смысла засовывать в структуру по значению нулевые элементы
		# тк она порождается из zeroinitializer и по умолчанию заполнена нулями
		if not value_is_zero(initializer['value']):
			iv = do_reval(initializer['value'])
			field = htype.record_field_get(rec_type, get_id_str(initializer))
			xv = insertvalue(xv, iv, field['field_no'])

	return xv




def do_eval_func(x):
	return llvm_value_id(get_id_str(x), x['type'])



def do_eval_var(x):
	id_str = get_id_str(x)

	if value_attribute_check(x, 'local'):
		y = locals_get(id_str)
	else:
		y = llvm_value_id(id_str, x['type'])

	y['is_adr'] = True
	return y



def do_eval_const(x):
	if value_attribute_check(x, 'local'):
		localname = get_id_str(x)
		y = locals_get(localname)
		return y

	if not is_global_context():
		# Аргументы функуции это константы но у них поле value == None!
		if x['value'] != None:
			# константные массивы (даже дженерик)
			# печатаются и их можео индексировать
			if htype.type_is_array(x['value']['type']):
				rv = llvm_value_id(get_id_str(x), x['type'])
				rv['is_adr'] = True
				return rv

	return do_eval(x['value'])


def do_eval_bool(x):
	return llvm_value_num(x['type'], 1 if x['asset'] else 0)


def do_eval_literal(x):
	xt = x['type']
	if htype.type_is_number(xt): return llvm_value_num(xt, x['asset'])
	elif htype.type_is_integer(xt): return llvm_value_num(xt, x['asset'])
	elif htype.type_is_float(xt): return llvm_value_num(xt, x['asset'])
	elif htype.type_is_string(xt): return do_eval_string(x)
	elif htype.type_is_record(xt): return do_eval_record(x)
	elif htype.type_is_array(xt): return do_eval_array(x)
	elif htype.type_is_bool(xt): return do_eval_bool(x)
	elif htype.type_is_free_pointer(xt): return llvm_value_num(xt, x['asset'])
	elif htype.type_is_pointer(xt): return llvm_value_num(x)
	elif htype.type_is_char(xt): return llvm_value_num(xt, x['asset'])
	elif htype.type_is_enum(xt): return llvm_value_num(xt, x['asset'])
	elif htype.type_is_word(xt): return llvm_value_num(xt, x['asset'])
	else:
		error("do_eval_literal: unknown literal", x['ti'])
		value_print(x)
		exit(1)
	return


def do_eval_va_start(x):
	va_list = do_eval(x['va_list'])
	return llvm_va_start(va_list)


def do_eval_va_arg(x):
	va_list = do_eval(x['va_list'])
	typ = x['type']
	return llvm_va_arg(va_list, typ)


def do_eval_va_end(x):
	va_list = do_eval(x['va_list'])
	return llvm_va_end(va_list)


def do_eval_va_copy(x):
	dst = do_eval(x['dst'])
	src = do_eval(x['src'])
	return llvm_va_copy(dst, src)


def do_eval(x):
	assert(x != None)
	assert(x['isa'] == 'value')

	y = None

	k = x['kind']
	if k == 'literal': y = do_eval_literal(x)
	elif k in bin_ops: y = do_eval_bin(x)
	elif k == 'cons': y = do_eval_cons(x)
	elif k == 'ref': y = do_eval_ref(x)
	elif k == 'not': y = do_eval_not(x, xor_msk=-1)
	elif k == 'logic_not': y = do_eval_not(x, xor_msk=1)
	elif k == 'neg': y = do_eval_neg(x)
	elif k == 'deref': y = do_eval_deref(x)
	elif k == 'const': y = do_eval_const(x)
	elif k == 'func': y = do_eval_func(x)
	elif k == 'var': y = do_eval_var(x)
	elif k == 'call': y = do_eval_call(x)
	elif k == 'index': y = do_eval_index(x)
	elif k == 'access': y = do_eval_access(x)
	elif k == 'access_module': y = do_eval_access_module(x)
	elif k == 'slice': y = do_eval_slice(x)
	elif k in ['sizeof_value', 'sizeof_type', 'lengthof', 'alignof', 'offsetof']:
		y = do_eval_literal(x)
	elif k == 'va_start': y = do_eval_va_start(x)
	elif k == 'va_arg': y = do_eval_va_arg(x)
	elif k == 'va_end': y = do_eval_va_end(x)
	elif k == 'va_copy': y = do_eval_va_copy(x)
	else:
		out("<%s>" % k)

	if y == None:
		error("llvm do_eval cannot eval (%s) value" % k, x['ti'])
		#print("htype.type_is_string() = %d" % htype.type_is_string(x['type']))
		value_print(x)
		type_print(x['type'])
		1 / 0
		return llvm_value_zero(x['type'])

	y['type'] = x['type']

	return y


#
#
#

def print_stmt_assign(x):
	if htype.type_is_array(x['right']['type']):
		return do_assign_arrays(x['left'], x['right'])
	l = do_eval(x['left'])
	r = do_reval(x['right'])
	llvm_store(l, r)


def do_assign_arrays(l, r):
	out("\n\t; -- STMT ASSIGN ARRAY --")
	dst = do_eval(l)

	out("\n\t; -- start vol eval --")
	volume = do_eval(r['type']['volume'])
	volume = trim(volume, 32)
	out("\n\t; -- end vol eval --")

	if value_is_zero(r):
		out("\n\t; -- zero fill rest of array")
		# size = volume * item_size
		item_sz = l['type']['of']['size']
		item_size = llvm_value_num(foundation.typeNat32, item_sz)
		size = llvm_eval_binary('mul', volume, item_size)
		llvm_memzero(dst, size, volatile=False)
		return

	src = do_reval(r)
	llvm_store(dst, src)



def print_stmt_if(x):
	global fctx
	if_id = fctx['if_no']
	fctx['if_no'] = fctx['if_no'] + 1
	cv = do_reval(x['cond'])

	then_label = 'then_%d' % if_id
	else_label = 'else_%d' % if_id
	endif_label = 'endif_%d' % if_id

	if x['else'] == None:
		else_label = endif_label

	llvm_br(cv, then_label, else_label)

	# then block
	llvm_label(then_label)
	print_stmt(x['then'])
	llvm_jump(endif_label)

	# else block
	if x['else'] != None:
		llvm_label(else_label)
		print_stmt(x['else'])
		llvm_jump(endif_label)

	# endif label
	llvm_label(endif_label)


def print_stmt_while(x):
	global fctx
	old_while_id = fctx['cur_while_id']
	fctx['while_no'] = fctx['while_no'] + 1
	cur_while_id = fctx['while_no']
	fctx['cur_while_id'] = cur_while_id

	again_label = 'again_%d' % cur_while_id
	break_label = 'break_%d' % cur_while_id
	body_label = 'body_%d' % cur_while_id

	llvm_jump(again_label)
	llvm_label(again_label)
	cv = do_reval(x['cond'])
	llvm_br(cv, body_label, break_label)
	llvm_label(body_label)
	print_stmt(x['stmt'])
	llvm_jump(again_label)
	llvm_label(break_label)
	fctx['cur_while_id'] = old_while_id


def print_stmt_again(x):
	global fctx
	cur_while_id = fctx['cur_while_id']
	llvm_jump('again_%d' % cur_while_id)
	reg_get()  # for LLVM


def print_stmt_break(x):
	global fctx
	cur_while_id = fctx['cur_while_id']
	llvm_jump('break_%d' % cur_while_id)
	reg_get()  # for LLVM


def print_stmt_return(x):
	# VLA требует чтобы стек был сохранен в начале работы функции
	# (see: print_def_func) и восстановлен перед возвратом из нее
	if fctx['stackptr'] != None:
		stackrestore(fctx['stackptr'])

	if x['value'] != None:
		v = do_reval(x['value'])
		if not need_sret(fctx['func']['type']):
			lo("ret ")
			llvm_print_type_value(v)
			reg_get()  # for LLVM
			return None

		# return via sret
		to = fctx['func']['type']['to']
		p2retval = llvm_value_reg("0", type_pointer(to))
		llvm_store(p2retval, v)

	lo("ret void")
	reg_get()  # for LLVM
	return None



def print_stmt_var(x):
	var = x['var_value']
	t = var['type']
	id_str = get_id_str(var)

	# only for VLA
	is_vla = False
	sz = None
	if htype.type_is_array(t):
		if not value_is_immediate(t['volume']):
			sz = do_reval(t['volume'])
			t = t['of']

	val = llvm_alloca(t, size=sz, alignment=t['align'])

	# VLA fix
	left = val
	if htype.type_is_vla(var['type']):
		# поскольку VLA реализуется через alloca
		# и поэтому имеет тип <vla_item_type>*,
		# нам просто нужно пределать его в указатель на массив
		# ex:  %8 = alloca i32, i32 %7, align 4
		#      %9 = bitcast i32* %8 to [0 x i32]*
		# и дальше уже будем работать с ним как с *[0 x i32] (%9)
		from_type = type_pointer(var['type']['of'])
		to_type = type_pointer(var['type'])
		left = llvm_2cast('bitcast', from_type, to_type, left)
		val = left

	locals_add(id_str, val)

	init_value = x['init_value']
	if not value_is_undefined(init_value):
		iv = do_reval(init_value)
		llvm_store(val, iv)

	return None



def print_stmt_let(x):
	id_str = get_id_str(x)
	val = x['init_value']

	if htype.type_is_string(val['type']):
		return None

	if val['kind'] == 'call':
		if need_sret(val['func']['type']):
			v = do_eval_call(val)
			locals_add(id_str, v)
			return None

	v = do_reval(val)

	# для let-массивов выделяем память (alloca)
	# поскольку их могут индексировать переменной
	# а массив-значение в "регистре" невозможно индексировать переменной
	if htype.type_is_closed_array(val['type']):
		v = llvm_alloca_store(val['type'], id_str=None, init_value=v)

	locals_add(id_str, v)
	return None


def print_stmt_block(s):
	locals_push()

	for stmt in s['stmts']:
		print_stmt(stmt)

	locals_pop()



def print_comment(x):
	k = x['kind']
	if k == 'line':
		print_comment_line(x)
	elif k == 'block':
		print_comment_block(x)


def print_comment_block(x):
	out('\n') # * x['nl'])
	out(";%s" % x['text'].replace('\n', '\n;'))


def print_comment_line(x):
	out('\n') # * x['nl'])
	lines = x['lines']
	i = 0
	n = len(lines)
	while i < n:
		line = lines[i]
		#if need_indent:
		indent()
		out(";%s" % line['str'])
		i = i + 1
		if i < n:
			out("\n")


"""
%12 = call { i64, i64 } asm sideeffect "add $0, $2, $3\0A\09add $0, $0, $4\0A\09add $1, $0, $4\0A\09", "=r,=r,r,r,r,~{w0},~{cc}"(i64 %9, i64 %10, i64 %11)
"""
"store i64 %13, i64* %7, align 8"
def print_stmt_asm(x):
	asm_text = x['text']['asset']
	asm_text = asm_text.replace("%", "$")

	specs = [] # list of spec & clobber strings
	outs = []  # llvm values ti output

	lo('')
	reg = '00'  # '00' - bad reg
	if len(x['outputs']) > 0:
		# у нас есть output значит будет возврат значения
		reg = reg_get()
		out("%%%s = " % (reg))

		for pair in x['outputs']:
			specs.append(pair[0]['asset'])
			arg = do_eval(pair[1])
			outs.append(arg)

	args = []
	if len(x['inputs']) > 0:
		for pair in x['inputs']:
			specs.append(pair[0]['asset'])
			arg = do_eval(pair[1])
			args.append(arg)

	for clobber in x['clobbers']:
		specs.append("~{%s}" % clobber['asset'])

	out('call ')

	rv = None
	if len(outs) == 0:
		out("void")
	elif len(outs) == 1:
		# если возврат один он идет как есть
		rt = outs[0]['type']
		rv = llvm_value_reg(reg, rt)
		print_type(rt)
	else:
		# если возвратов несколько
		# они возвращаются завернутые в структуру
		fields = []
		for o in outs:
			field_type = o['type']
			from hlir.id import hlir_id
			from hlir.field import hlir_field
			field_id = hlir_id('<noname>')
			f = hlir_field(field_id, field_type, ti=x['ti'])
			fields.append(f)

		rt = htype.type_record(fields)
		rv = llvm_value_reg(reg, rt)
		print_type(rt)

	out(' asm sideeffect ')
	print_str_literal(asm_text)
	out(', "')

	# separator=',' WITHOUT SPACE
	print_list_by(specs, out, separator=',')

	out('" (')
	print_list_by(args, llvm_print_type_value)
	out(")")

	if len(outs) == 1:
		llvm_store(outs[0], rv)
	elif len(outs) > 1:
		n = 0
		for o in outs:
			extracted_rv = extractvalue(rv, o['type'], n)
			llvm_store(o, extracted_rv)
			n = n + 1
		pass



def print_stmt(x):
	assert(x['isa'] == 'stmt')

	k = x['kind']
	if k == 'block': print_stmt_block(x)
	elif k == 'value': do_eval(x['value'])
	elif k == 'assign': print_stmt_assign(x)
	elif k == 'return': print_stmt_return(x)
	elif k == 'if': print_stmt_if(x)
	elif k == 'while': print_stmt_while(x)
	elif k == 'var': print_stmt_var(x)
	elif k == 'let': print_stmt_let(x)
	elif k == 'break': print_stmt_break(x)
	elif k == 'again': print_stmt_again(x)
	elif k == 'comment-line': print_comment_line(x)
	elif k == 'comment-block': print_comment_block(x)
	elif k == 'asm': print_stmt_asm(x)
	else: lo("<stmt %s>" % str(x))




def print_func_params(ftype, only_types=False, with_attributes=True):
	# here can be a pointer to function
	if htype.type_is_pointer(ftype):
		ftype = ftype['to']

	params = ftype['params']
	to = ftype['to']

	if need_sret(ftype):
		# %struct.Sre* noalias sret(%struct.Sre) align 1 %0
		print_type(to)

		"""if with_attributes:
			out("* noalias sret(")
		else:
			out("*")

		if with_attributes:
			print_type(to)
			out(")")"""

		out("*")

		if not only_types:
			out(" %0")

		if len(params) > 0:
			out(", ")


	def print_param_type(param):
		print_type(param['type'])
		#out(' noundef')

	def print_param_w_id(param, id):
		print_type(param['type'])
		#out(' noundef')
		out(" %%%s" % get_id_str(param))

	method = print_param_w_id
	if only_types:
		method = print_param_type

	i = 0
	while i < len(params):
		param = params[i]
		isarr = htype.type_is_closed_array(param['type'])

		if i > 0:
			out(", ")

		print_type(param['type'])

		if not only_types:
			if isarr:
				out(" %%__%s" % get_id_str(param))
			else:
				out(" %%%s" % get_id_str(param))

		i = i + 1


	if ftype['extra_args']:
		out(", ...")



def print_type_func(t):
	if htype.type_is_unit(t['to']) or need_sret(t):
		out("void")
	else:
		print_type(t['to'])

	out(" (")
	print_func_params(t, only_types=True)
	out(")")


def print_func_signature(ftype, idStr):
	if htype.type_is_unit(ftype['to']) or need_sret(ftype):
		out("void")
	else:
		print_type(ftype['to'])

	out(" @%s(" % idStr)
	print_func_params(ftype)
	out(")")



def is_private(x):
	if 'access_level' in x:
		return x['access_level'] == 'private'
	return False


#['private', 'internal', 'weak', 'external'] # etc..
def get_linkage(x):
	if is_private(x):
		return "internal"
	return ""


def print_linkage(x):
	linkage = get_linkage(x)
	if linkage != "":
		out("%s " % linkage)



def print_decl_func(x):
	out("\ndeclare ")
	print_linkage(x)
	fn = x['value']
	print_func_signature(fn['type'], get_id_str(fn))



def print_def_func(x):
	fn = x['value']
	ftype = fn['type']

	if x['stmt'] == None:
		return print_decl_func(x)

	fctx = {
		'func': fn,  # cfunc

		'if_no': 0,
		'while_no': 0,
		'cur_while_id': 0,

		'free_reg': 0,

		# map for local lets & vars
		# <id> => <llvm_value>
		'locals': [{}],

		'stackptr': None,  # for VLA
	}

	fctx_push(fctx)

	out("\ndefine ")
	print_linkage(x)
	print_func_signature(ftype, get_id_str(fn))

	if need_sret(ftype):
		reg_get() # get %0 reg for retval

	#
	# Добавляем параметры в локальную таблицу
	#

	params = ftype['params']
	for param in params:
		param_id = get_id_str(param)

		if htype.type_is_va_list(param['type']):
			# see: p216
			continue

		localObject = llvm_value_reg(param_id, param['type'])

		if htype.type_is_closed_array(param['type']):
			localObject['is_adr'] = True

		locals_add(param_id, localObject)


	# 0, 1, 2 - params; 3 - entry label, 4 - first free register
	entry_label = reg_get()  # should be here (!)

	out(" {")
	indent_up()

	# for any array parameter print local holder value
	for param in params:
		ptype = param['type']
		if htype.type_is_closed_array(ptype):
			paramId = get_id_str(param)

			reg = '__' + param['id']['str']
			loadedParam = llvm_value_reg(reg, ptype)


			# Выделяем память под массив
			pholder = llvm_alloca(ptype, id_str=paramId)
			# сохраняем переданный по указателю массив в выделенный выше "регистр"
			# теперь это локальная копия "типа" переданного по значению массива
			# и далее работать будем только с ней
			llvm_store(pholder, loadedParam)

	if len(params) > 0:
		last_param = params[-1]
		if htype.type_is_va_list(last_param['type']):
			# :p216
			# В LLVM va_arg принимает параметром указатель на укзаатель на __VA_List!
			# Но тк мы получаем просто указатель на va_list,
			# создадим локальную переменную сохраним в нее его,
			# и будем передавать va_arg указатель на эту локальную переменную

			# 1. создаем лок переменную для *va_arg
			va_list_srorage = llvm_alloca(foundation.typeFreePointer)

			# 2. сохраняем в нее полученный (параметр) *va_arg
			va_list_param_id = get_id_str(param)

			lo("store ")
			print_type(last_param['type'])
			out(" %%%s" % va_list_param_id)
			out(", ")
			llvm_print_type_value(va_list_srorage)

			# 3. добваляем в локалы именно указатель на эту переменную
			# но называем ее именем самого параметра
			# чтобы при обращении __va_arg va (будто к параметру va)
			# генерировался %2 = va_arg i8** %1, i32 (обращ. к указ. на лок. перем.)
			locals_add(va_list_param_id, va_list_srorage)

	# VLA требует чтобы стек был сохранен в начале работы функции
	# и восстановлен перед возвратом из нее (see: print_stmt_return)
	if 'stacksave' in fn['att']:
		#; stack save
		# %3 = alloca i8*, align 8 ; stack save
		# %7 = call i8* @llvm.stacksave()
		stackptr = llvm_alloca(foundation.typeFreePointer)
		stacksave(stackptr)
		fctx['stackptr'] = stackptr

	print_stmt_block(x['stmt'])

	if htype.type_eq(ftype['to'], foundation.typeUnit):
		print_stmt_return({'value': None})

	indent_down()
	lo("}\n")

	fctx_pop()



#def print_decl_type(x):
#	out("\n%%%s = type opaque" % get_id_str(x))


def print_def_type(x):
	xtype = x['original_type']
	out("\n%%%s = type " % get_id_str(x['type']))
	if htype.type_is_record(xtype):
		# не печатаем имя а печатаем саму структуру
		# тк LLVM дает ошибку на запись вида
		# %Struct1 = type %Struct2; Error, wtf?
		print_type_record(xtype)
	else:
		print_type(xtype)
	out(";")
	if htype.type_is_record(xtype):
		out("\n")



def print_def_var(x, as_extern=False):
	is_extern = 'extern' in x['att'] or as_extern
	is_static = 'static' in x['att']

	#mods = ['global', 'constant']
	mod = 'global'

	var = x['var_value']
	out("\n@%s = " % get_id_str(var))
	print_linkage(x)
	out(mod + ' ')
	print_type(var['type'])

	if not is_extern:
		if not value_is_undefined(x['init_value']):
			out(" ")
			llvm_print_value(do_eval(x['init_value']))
		else:
			out(" zeroinitializer")
	return



def print_def_const(x, as_extern=False):
	init_value = x['init_value']

	#if htype.type_is_composite(const_value['type']):
	# В LLVM мы не печатаем константы, но массивы - вынуждены
	# тк доступ к ним может идти в рантайме по индексу;
	# НО! В константной записи может быть массив! (хз как быть пока)
	if htype.type_is_array(init_value['type']):
		out("\n@%s = constant " % get_id_str(x['value']))
		llvm_print_type_value(do_eval(init_value))

	return




def code_to_char(cc):
	if cc < 0x20:
		if cc == 0x07: return "\\07"   # bell
		elif cc == 0x08: return "\\08" # backspace
		elif cc == 0x09: return "\\09" # horizontal tab
		elif cc == 0x0A: return "\\0A" # line feed
		elif cc == 0x0B: return "\\0B" # vertical tab
		elif cc == 0x0C: return "\\0C" # form feed
		elif cc == 0x0D: return "\\0D" # carriage return
		elif cc == 0x1B: return "\\1B" # escape
		else: return "\\%02X" % cc

	elif cc <= 0x7E :
		sym = chr(cc)
		if sym == '\\': return '\\\\'
		elif sym == '"': return '\\"'
		else: return sym

	elif cc != 0:
		return chr(cc)


def print_str_literal(char_codes):
	out('"')

	i = 0
	while i < len(char_codes):
		cc = ord(char_codes[i])

		if cc == 0:
			i_before = i
			while i < len(x['asset']):
				_cc = asset[i]
				if _cc != 0:
					i = i_before
					break
				i = i + 1
			out("\"")
			return

		out(code_to_char(cc))

		i = i + 1

	out('"')


def print_string_ascii(strid, string):
	ss = ""

	for c in string['asset']:
		ss = ss + chr(c['asset'])

	slen = len(bytes(ss, 'utf-8')) #+ 1 # +1 (zero)

	if 'zstring' in string['att']:
		slen = slen + 1

	ss = ss.replace("\a", "\\07")
	ss = ss.replace("\b", "\\08")
	ss = ss.replace("\t", "\\09")
	ss = ss.replace("\n", "\\0A")
	ss = ss.replace("\v", "\\0B")
	ss = ss.replace("\r", "\\0D")
	#ss = ss.replace("\e", "\\1B")
	ss = ss.replace("\"", "\\22")
	ss = ss.replace("\'", "\\27")

	#ex: @str_1 = private constant [4 x i8] c"Hi!\00"
	lo("@%s = private constant [%d x i8] c\"%s\\00\"" % (strid, slen, ss))



def print_string_as_array(strid, string, char_width):
	slen = len(string['asset'])

	if 'zstring' in string['att']:
		slen = slen + 1

	lo("@%s = private constant [%d x i%d] [" % (strid, slen, char_width))
	i = 0
	for char in string['asset']:
		char_code = char['asset']
		if i > 0:
			out(", ")
		print_int_type_for(char_width)
		out(" %d" % char_code)
		i = i + 1

	if 'zstring' in string['att']:
		if slen > 1:
			out(", ")
		print_int_type_for(char_width)
		out(" 0")

	out("]")



def print_strings(strings):
	out("\n; -- strings --")
	strno = 0
	for string in strings:
		strid = None
		if 'id' in string:
			# it is named constant
			strid = get_id_str(string)
		else:
			# it is anonymous string
			strno = strno + 1
			strid = 'str%d' % strno

		char_width = string['type']['to']['of']['width']

		string['strid'] = strid

		print_string_as_array(strid, string, char_width)
	out("\n; -- endstrings --")
	return


printed = []

def een(defs, decl_only=False):
	isa_prev = None
	for x in defs:
		isa = x['isa']

		if isa == 'comment':
			print_comment(x)
			continue

		if not 'id' in x:
		#	print(x['isa'])
			continue

		if 'll_no_print' in x['att']:
			continue
		if 'no_print' in x['att']:
			continue

		# Тупейшая Защита от повторного определения
		# (А они происходят тк импорты и инклуюды сложно сплетены и повтор.)
		uid = x['module']['id'] + '.' + x['id']['str']

		if uid in printed:
			continue

		printed.append(uid)
		#print(uid)

		if isa_prev != isa:
			out("\n")
			isa_prev = isa

		if isa == 'def_var':
			print_def_var(x, as_extern=decl_only)

		elif isa == 'def_const':
			print_def_const(x, as_extern=decl_only)

		elif isa == 'def_func':
			if not decl_only:
				print_def_func(x)
			else:
				print_decl_func(x)

		elif isa == 'def_type':
			print_def_type(x)

		elif isa == 'comment':
			print("AFEKLMLKFMLKMDFLKMEFLKDMLAKMLMLWMDLAMWDLMALDMAWLDMALWDAWDLKMW")
			print_comment(x)


# защита от повторного включения
already_in = []
def print_included(m):
	for inc in m['included_modules']:
		# защита от повторного включения
		if inc['id'] not in already_in:
			already_in.append(inc['id'])
			print_included(inc)

			out("\n; from included %s" % inc['id'])

			for d in inc['defs']:
				if is_private(d):
					continue

				if d['isa'] == 'def_type':
					print_def_type(d)
				elif d['isa'] == 'def_func':
					print_decl_func(d)
				#elif d['isa'] == 'def_const':
				#	print_decl_const(x)


def print_imports(m):
	for imp_id in m['imports']:
		imp = m['imports'][imp_id]
		#print(">>>> %s" % imp['id'])
		print_included(imp)
		print_imports(imp)

		for d in imp['defs']:
			if is_private(d):
				continue

			if d['isa'] == 'def_type':
				print_def_type(d)
			elif d['isa'] == 'def_func':
				print_decl_func(d)

		#een(imp['defs'], decl_only=True)


separatorLine = "\n; " + '-' * 77
# список имен модулей распечатанных в текущей сброке
#printed_modules = []

def print_module(m):
	#if m['source_info']['path'] in printed_modules:
	#	return

	out("; MODULE: %s\n" % m['id'])

	out("\n; -- print includes --")
	print_included(m)
	out("\n; -- end print includes --")

	out("\n; -- print imports --")
	print_imports(m)
	out("\n; -- end print imports --")

	# печатаем декларации
	# из экспортируемой части импортированных модулей
	"""for imported_module_id in m['imports']:
		imp = m['imports'][imported_module_id]
		out(separatorLine)
		out("\n; declarations from: %s" % (imported_module_id))
		out(separatorLine)
		een(imp['defs'])
		out("\n\n")"""

	print_strings(m['strings'])

	een(m['defs'])

	out("\n\n")
	return



def run(module, outname, options):
	outname = outname + '.ll'
	output_open(outname)

	out('\ntarget datalayout = "%s"' % LLVM_TARGET_DATALAYOUT)
	out('\ntarget triple = "%s"\n\n' % LLVM_TARGET_TRIPLE)

	lo("%Unit = type i1")
	lo("%Bool = type i1")
	lo("%Word8 = type i8")
	lo("%Word16 = type i16")
	lo("%Word32 = type i32")
	lo("%Word64 = type i64")
	lo("%Word128 = type i128")
	lo("%Char8 = type i8")
	lo("%Char16 = type i16")
	lo("%Char32 = type i32")
	lo("%Int8 = type i8")
	lo("%Int16 = type i16")
	lo("%Int32 = type i32")
	lo("%Int64 = type i64")
	lo("%Int128 = type i128")
	lo("%Nat8 = type i8")
	lo("%Nat16 = type i16")
	lo("%Nat32 = type i32")
	lo("%Nat64 = type i64")
	lo("%Nat128 = type i128")
	lo("%Float32 = type float")
	lo("%Float64 = type double")
	lo("%Pointer = type i8*")
	lo("%Str8 = type [0 x %Char8]")
	lo("%Str16 = type [0 x %Char16]")
	lo("%Str32 = type [0 x %Char32]")
	lo("%__VA_List = type i8*")

	if 'use_va_arg' in module['att']:
		lo("declare void @llvm.va_start(i8*)")
		lo("declare void @llvm.va_copy(i8*, i8*)")
		lo("declare void @llvm.va_end(i8*)")

	lo("declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)")
	lo("declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)\n")

	lo("declare i8* @llvm.stacksave()\n")
	lo("declare void @llvm.stackrestore(i8*)\n")
	lo("\n")


	#lo("declare i32 @memcmp(i8* %ptr1, i8* %ptr2, i64 %len)\n")
	out(memeq_impl)

	print_module(module)
	output_close()



REL_OPS = ['eq', 'ne', 'lt', 'gt', 'le', 'ge']


def get_bin_opcode(op, t):
	# ["icmp slt", "icmp ult", x]
	def select_bin_opcode_su(sop, uop, t):
		if htype.type_is_unsigned(t):
			return uop
		return sop

	# ["sdiv", "udiv", "fdiv", x]
	def select_bin_opcode_f(op, fop, t):
		if htype.type_is_float(t):
			return fop
		return op

	# ["sdiv", "udiv", "fdiv", x]
	def select_bin_opcode_suf(sop, uop, fop, t):
		if htype.type_is_float(t):
			return fop
		return select_bin_opcode_su(sop, uop, t)

	opcode = "<unknown opcode '%s'>" % op
	if op in ['eq', 'ne']:
		opcode = select_bin_opcode_f('icmp ' + op, 'fcmp o' + op, t)
	elif op in ['add', 'sub', 'mul']:
		opcode = select_bin_opcode_f(op, 'f' + op, t)
	elif op in ['and', 'or', 'xor', 'shl']:
		opcode = op
	elif op in ['div', 'rem']:
		opcode = select_bin_opcode_suf('s' + op, 'u' + op, 'f' + op, t)
	elif op in ['lt', 'gt', 'le', 'ge']:
		opcode = select_bin_opcode_suf('icmp s' + op, 'icmp u' + op, 'fcmp o' + op, t)
	elif op == 'shr':
		opcode = 'ashr' if htype.type_is_signed(t) else 'lshr'
	elif op == 'logic_or':
		opcode = 'or'
	elif op == 'logic_and':
		opcode = 'and'

	return opcode




memeq_impl = """
%CPU.Word = type i64
define weak i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU.Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU.Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %7
	%9 = load %CPU.Word, %CPU.Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %10
	%12 = load %CPU.Word, %CPU.Word* %11
	%13 = icmp ne %CPU.Word %9, %12
	br i1 %13 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%15 = load i64, i64* %4
	%16 = add i64 %15, 1
	store i64 %16, i64* %4
	br label %again_1
break_1:
	%17 = urem i64 %len, 8
	%18 = load i64, i64* %4
	%19 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU.Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU.Word* %22 to [0 x i8]*
	store i64 0, i64* %4
	br label %again_2
again_2:
	%24 = load i64, i64* %4
	%25 = icmp ult i64 %24, %17
	br i1 %25 , label %body_2, label %break_2
body_2:
	%26 = load i64, i64* %4
	%27 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %26
	%28 = load i8, i8* %27
	%29 = load i64, i64* %4
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %23, i32 0, i64 %29
	%31 = load i8, i8* %30
	%32 = icmp ne i8 %28, %31
	br i1 %32 , label %then_1, label %endif_1
then_1:
	ret i1 0
	br label %endif_1
endif_1:
	%34 = load i64, i64* %4
	%35 = add i64 %34, 1
	store i64 %35, i64* %4
	br label %again_2
break_2:
	ret i1 1
}

"""



def stackrestore(sptr):
	r = llvm_dold(sptr)
	lo("call void @llvm.stackrestore(")
	llvm_print_type_value(r)
	out(")")
	return r


def stacksave(sptr):
	r = ll_reg_operation("call i8* @llvm.stacksave()", type=sptr['type'])
	return llvm_store(sptr, r)



# получаем 32 или 64 битное представление float числа
def _float_value_pack(f_num, width):
	import struct
	z = 0
	if width == 32:
		z = struct.unpack('<f', struct.pack('<f', f_num))[0]
	elif width == 64:
		z = struct.unpack('<d', struct.pack('<d', f_num))[0]
	else:
		fatal("too big float, _float_value_pack not implemented")

	return z

