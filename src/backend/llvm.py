
import copy

from hlir import *
from .common import *
from value.value import *
from error import info, warning, error, fatal
import type as htype
from type import type_print
from util import align_bits_up
from pprint import pprint


cmodule = None

LLVM_TARGET_TRIPLE = ""
LLVM_TARGET_DATALAYOUT = ""
SIZE_WIDTH = 0


# LLVM не умеет нативно возвращать большие значения
# Для этого есть механизм sret;
# когда первым параметром идет указатель на возвращаемое значение (ABI)
RET_SIZE_MAX = 16
def need_sret(func_type):
	return func_type.to.is_closed_array()
	#return func_type.to.size > RET_SIZE_MAX


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

def init(settings):
	global LLVM_TARGET_TRIPLE, LLVM_TARGET_DATALAYOUT, llvm_value_num_zero, SIZE_WIDTH
	LLVM_TARGET_TRIPLE = settings['target_triple']
	LLVM_TARGET_DATALAYOUT = settings['target_datalayout']
	SIZE_WIDTH = settings['size_width']
	llvm_value_num_zero = llvm_value_num(typeInt32, 0)


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


def is_global_public(x):
	if hasattr(x, 'definition'):
		if x.definition != None:
			if x.definition.access_level == HLIR_ACCESS_LEVEL_PUBLIC:
				return True
	return False


def get_id_str(x):
	if not hasattr(x, 'id'):
		return None

	id = x.id
	if id == None:
		return None

	id_str = id.llvm

	if id.prefix != None:
		id_str = id.prefix + id_str

	if not x.id.hasAttribute('nodecorate'):
		if is_global_public(x):
			module = x.getModule()
			if module != None:
				if not module.hasAttribute('nodecorate'):
					id_str = "%s_%s" % (module.prefix, id_str)

	return id_str



def get_type_id(t):
	id_str = get_id_str(t)
	if id_str == None:
		return None
	return '%' + id_str


def llvm_value_undef(type):
	return {
		'isa': 'll_value',
		'kind': 'undef',
		'type': type,
		'is_adr': False
	}

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


def llvm_value_inline_gep(result_type, value, indexes, object_type):
	return {
		'isa': 'll_value',
		'kind': 'inline_getelemantptr',
		'object_type': object_type,
		'type': result_type,
		'value': value,
		'indexes': indexes,
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
	y = llvm_cast('bitcast', x, typeFreePointer)
	lo("call void @llvm.va_start(i8* %%%s)" % y['reg'])
	return llvm_value_zero(typeUnit)


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
	y = llvm_cast('bitcast', x, typeFreePointer)
	lo("call void @llvm.va_end(i8* %%%s)" % y['reg'])
	return llvm_value_zero(typeUnit)


def llvm_va_copy(dst, src):
	dst = llvm_cast('bitcast', dst, typeFreePointer)
	src = llvm_cast('bitcast', src, typeFreePointer)
	lo("call void @llvm.va_copy(i8* %%%s, i8* %%%s)" % (dst['reg'], src['reg']))
	return llvm_value_zero(typeUnit)



def llvm_inline_cast(op, to_type, val):
	assert(isinstance(to_type, Type))
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

	nn = (x['type'].volume.asset)
	i = 0
	while i < nn:
		item = None
		if i < n:
			item = items[i]
		else:
			item = do_eval(create_zero_literal(x['type'].of))

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
	string_of = x['type'].to.of
	char_width = string_of.width
	str_len = x['len']

	out("bitcast ([%d x i%d]* @%s to [0 x i%d]*)" % (str_len, char_width, x['id'], char_width))



def llvm_print_value_num(x):
	num = x['asset']

	if x['type'].is_pointer():
		if num == 0:
			out("null")
		else:
			v = llvm_value_num(typeNat64, num)
			llvm_inline_cast('inttoptr', x['type'])
		return

	if x['type'].is_float():
		# число сперва нужно причесать,
		# так, чтобы оно могло быть четко представлено в LLVM float/double
		# иначе LLVM не примет его и сгенерирует ошибку
		packed_float = _float_value_pack(num, x['type'].width)
		return out("%.16f" % packed_float)

	out(str(num))




def llvm_print_value_inline_cast(x):
	t = x['type']
	v = x['value']

	if v['kind'] in ['num']:
		if t.is_pointer():
			out("null")
		else:
			out("%d" % v['asset'])
		return

	opcode = select_cast_operator(v['type'], t)
	llvm_inline_cast(opcode, t, v)



"ptr getelementptr (i8, ptr @a0, i64 4)"
"%Int32** getelementptr (%Int32**, [5 x %Int32*]* @a1, %Int32 0)"
def llvm_print_value_inline_getelemantptr(x):
	out("getelementptr (")
	print_type(x['object_type'])
	out(", ")
	llvm_print_type_value(x['value'])
	out(", ")
	print_list_with(x['indexes'], llvm_print_type_value)
	out(")")



def llvm_print_ValueZero(x):
	if x['type'].is_composite():
		out("zeroinitializer")
	elif x['type'].is_pointer():
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
	elif k == 'inline_cast': llvm_print_value_inline_cast(x)
	elif k == 'inline_getelemantptr': llvm_print_value_inline_getelemantptr(x)
	elif k == 'zero': llvm_print_ValueZero(x)
	elif k == 'undef': out("undef")
	else:
		out("<llvm::unknown_value_kind '%s'>" % k)
		info("<llvm::unknown_value_kind '%s'>" % k, x['ti'])

	return




def llvm_eval_binary(op, l, r, x=None):
	assert(l['isa'] == 'll_value')
	assert(r['isa'] == 'll_value')

	result_type = l['type']
	if x != None:
		result_type = x.type

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
def llvm_gep(v, object_type, indexes, result_type, et):
	# Есть такой прикол в том что индекс (i) структуры
	# не может быть i64 (!) (а только i32)

	# Индексы должны быть 32-бита,
	# если меньше (например 8) - GEP возвращает херь
	# поэтому приводим все к 32-битам
	indexes32 = []
	for index in indexes:
		if not Type.eq(index['type'], typeInt32):
		#if index['type'].size != 32: #typeFreePointer.size:
			index = docast(index, typeNat32)
		indexes32.append(index)

	if is_global_context():
		return llvm_value_inline_gep(result_type, v, indexes32, object_type)

	#rv = ll_reg_operation('getelementptr inbounds', result_type)
	rv = ll_reg_operation('getelementptr', result_type)
	rv['is_adr'] = True
	print_type(et)
	out(", ")
	llvm_print_type_value(v)
	out(", ")
	print_list_with(indexes32, llvm_print_type_value)
	return rv


# возвращает значение поля из 'структуры по значению'
def llvm_extractvalue(x, result_type, indexes):
	# %x = extractvalue %Point %p, 0
	# %y = extractvalue %Point %p, 1
	rv = ll_reg_operation('extractvalue', result_type)
	llvm_print_type_value(x)
	out(", ")
	print_list_with(indexes, llvm_print_value)
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

	if src['type'].is_array():
		do_assign_arrays(dst, src)
		return

	llvm_store_simple(dst, src)


def llvm_store_simple(dst, src):
	lo("store ")
	llvm_print_type_value(src)
	out(", ")
	llvm_print_type_value(dst)



def do_assign_arrays(dst, src):
	#out("\n\t; -- ASSIGN ARRAY --")

	#out("\n\t; -- start vol eval --")
	volume = do_reval(src['type'].volume)
	volume = trim(volume, 32)
	#out("\n\t; -- end vol eval --")

	if 'items' in src:
		if src['items'] == []:
			#out("\n\t; -- zero fill rest of array")

			# `size = volume * item_size`
			item_sz = src['type'].of.size
			item_size = llvm_value_num(typeNat32, item_sz)
			size = llvm_eval_binary(HLIR_VALUE_OP_MUL, volume, item_size)

			llvm_memzero(dst, size, volatile=False)
			return

	#r = do_reval(src)
	llvm_store_simple(dst, src)



# получает два указателя, и размер
def llvm_memcpy_immsize(dst, src, size, volatile=False):
	#"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
	dst2 = llvm_cast('bitcast', dst, typeFreePointer)
	src2 = llvm_cast('bitcast', src, typeFreePointer)
	out(NL_INDENT)
	out("call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(")
	llvm_print_type_value(dst2)
	out(", "); llvm_print_type_value(src2)
	out(", i32 %d" % size);
	out(", i1 %d)" % volatile)


# получает два указателя, и размер
def llvm_memcpy(dst, src, size, volatile=False):
	#"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
	dst2 = llvm_cast('bitcast', dst, typeFreePointer)
	src2 = llvm_cast('bitcast', src, typeFreePointer)
	out(NL_INDENT)
	out("call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(")
	llvm_print_type_value(dst2)
	out(", "); llvm_print_type_value(src2)
	out(", "); llvm_print_type_value(size)
	out(", i1 %d)" % volatile)


#declare void @llvm.memset.p0.i32(ptr <dest>, i8 <val>, i32 <len>, i1 <isvolatile>)
def llvm_memzero(dst, size, volatile=False):
	#"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
	dst2 = llvm_cast('bitcast', dst, typeFreePointer)
	out(NL_INDENT)
	out("call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(")
	llvm_print_type_value(dst2)
	out(", i8 0, i32 %d" % size); #llvm_print_type_value(size)
	out(", i1 %d)" % volatile)



# грубо привести тип integer value к ширине width
def trim(int_value, width):
	assert(int_value['isa'] == 'll_value')
	if int_value['type'].width != width:
		return docast(int_value, typeNat32)
	return int_value


def llvm_memzero(dst, size, volatile=False):
	#"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
	dst2 = llvm_cast('bitcast', dst, typeFreePointer)
	out(NL_INDENT)

	out("call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(")
	llvm_print_type_value(dst2)
	out(", i8 0, ")
	llvm_print_type_value(size)
	out(", i1 %d)" % volatile)



# memset with offset from start of dst
def llvm_memzero_off(dst, offset, size, volatile=False):
	ll_off = llvm_value_num(typeInt32, offset)

	# offset pointer
	dst2 = llvm_cast("ptrtoint", dst, typeInt64)
	ll_dst_plus_off = llvm_eval_binary(HLIR_VALUE_OP_ADD, dst2, ll_off)
	dst3 = llvm_cast("inttoptr", ll_dst_plus_off, typeFreePointer)

	# do memzero
	llvm_memzero(dst3, size, volatile=volatile)


# получает два указателя, и размер
# LLVM не имеет интиринсика memcmp поэтому используем стандартный...
# @param op = [HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE]
def llvm_memcmp(op, p0, p1, size):
	_p0 = llvm_cast('bitcast', p0, typeFreePointer)
	_p1 = llvm_cast('bitcast', p1, typeFreePointer)
	rv = ll_reg_operation(HLIR_VALUE_OP_CALL, typeBool)
	out("i1 (i8*, i8*, i64) @memeq(")
	llvm_print_type_value(_p0)
	out(", ")
	llvm_print_type_value(_p1)
	out(", ")
	llvm_print_type_value(size)
	out(")")

	zero = llvm_value_num(typeBool, 0)
	op = HLIR_VALUE_OP_NE if op == HLIR_VALUE_OP_EQ else HLIR_VALUE_OP_EQ

	vvv = ValueUndef(typeBool)
	rv2 = llvm_eval_binary('icmp %s' % op, rv, zero, vvv)

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
	assert(isinstance(typ, Type))

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
		llvm_store(nv, init_value)
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


def print_list_with(lst, method):
	i = 0
	while i < len(lst):
		if i > 0: out(", ")
		method(lst[i])
		i = i + 1


def print_type_enum(t):
	out('i%d' % t.width)


def print_type_record(t):
	packed = t.hasAttribute2('packed')

	if packed:
		out("<")

	out("{")
	fields = t.fields
	i = 0
	while i < len(fields):
		field = fields[i]

		if i > 0: out(',')
		if is_global_context():
			out(NL_INDENT)

		print_type(field.type)

		i = i + 1

	if is_global_context():
		out("\n")

	out("}")

	if packed:
		out(">")


def print_type_array(t):
	sz = 0
	if not t.is_vla():
		array_size = t.volume
		if not array_size.isValueUndef():
			if not array_size.type.is_incompleted():
				if array_size.isValueImmediate():
					sz = array_size.asset

	out("[")
	out("%d x " % sz)
	print_type(t.of)
	out("]")



def print_type_pointer(t):
	if t.is_free_pointer():
		out("i8*")
	else:
		print_type(t.to); out("*")



def print_int_type_for(width):
	# Generic int can have width (for example) 6 bit, etc.
	out("i%d" % align_bits_up(width))


# функция может получать только указатель на массив
# если же в CM она получает массив то тут и в СИ она получает
# указатель на него, и потом копирует его во внутренний массив
def print_type(t):
	assert(isinstance(t, Type))
	print_aka=True

	id_str = get_type_id(t)
	if id_str != None:
		out(id_str)
		return

	if print_aka:
		# тупой LLVM не умеет делать алиасы структур
		# он типа делает, но потом к переменной с таким типом
		# хрен обратишься... дерьмо
		if t.is_record():
			if hasattr(t, 'id') and t.id != None:
				out("%" + t.id.str)
				return

		t_id = get_type_id(t)
		if t_id != None:
			out(t_id)
			return

		# иногда сюда залетают дженерики например в to левое:
		# let p = 0x12345678 to *Nat32
		if t.is_number():
			print_int_type_for(t.width)
			return

	if t.is_func(): print_type_func(t)
	elif t.is_record(): print_type_record(t)
	elif t.is_pointer(): print_type_pointer(t)
	elif t.is_array(): print_type_array(t)
	#elif t.is_enum(): print_type_enum(t)

	elif t.is_int():
		print_int_type_for(t.width)

	elif t.is_float():
		if t.width <= 32:
			out("float")
		else:
			out("double")

	elif t.is_char():
		print_int_type_for(t.width)

	elif t.is_incompleted():
		out('opaque')

	elif t.is_va_list():
		out("i8*")

	else:
		out(str(t))



def do_reval(x):
	return llvm_dold(do_eval(x))


def do_eval_bin(x):
	if x.isValueImmediate():
		return do_eval_literal(x)

	op = x.op
	# Composite objects comparison (see below)
	# requires not value, just ADR of value (!)
	l = do_eval(x.left)
	r = do_eval(x.right)

	if x.left.type.is_composite():
		if op in [HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE]:
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
					if r == None:
						1/0

			# Теперь сравниваем значения по указателям и длине (memcmp)
			sz = llvm_value_num(typeInt64, l['type'].size)

			return llvm_memcmp(op, l, r, sz)

		return None

	# working simple objects
	# requires their values as is in register
	l = llvm_dold(l)
	r = llvm_dold(r)

	if op in [HLIR_VALUE_OP_SHL, HLIR_VALUE_OP_SHR]:
		# LLVM requires the same type for left & right arguments of shift operator
		# cast right to left
		if not r['type'].is_generic():
			r = docast(r, l['type'])

	llvm_opcode = get_bin_opcode(op, x.left.type)
	return llvm_eval_binary(llvm_opcode, l, r, x)


def do_eval_shl(x):
	if x.isValueImmediate():
		return do_eval_literal(x)

	# Composite objects comparison (see below)
	# requires not value, just ADR of value (!)
	l = do_reval(x.left)
	r = do_reval(x.right)
	r = docast(r, l['type'])

	return llvm_eval_binary(HLIR_VALUE_OP_SHL, l, r, x)


def do_eval_shr(x):
	if x.isValueImmediate():
		return do_eval_literal(x)

	# Composite objects comparison (see below)
	# requires not value, just ADR of value (!)
	l = do_reval(x.left)
	r = do_reval(x.right)
	r = docast(r, l['type'])

	opcode = 'ashr' if Type.is_signed(l['type']) else 'lshr'
	return llvm_eval_binary(opcode, l, r, x)



def ll_malloc(res_type, obj_type):
	obj_sz = _eval_sizeof_type(obj_type)
	return ll_malloc_sz(res_type, obj_sz)


def ll_malloc_sz(t, llsz):
	# %1 = call %table_Table* @malloc(%Int32 8)
	lv = ll_reg_operation(HLIR_VALUE_OP_CALL, t)
	print_type(t)
	out(" @malloc(")
	llvm_print_type_value(llsz)
	out(")")
	return lv


def do_eval_new(x):
	lv = ll_malloc(x.type, x.value.type)
	val = do_reval(x.value)
	llvm_store(lv, val)
	return lv


def do_eval_deref(x):
	ptr_val = do_reval(x.value)
	return llvm_deref(ptr_val)


def do_eval_ref(v):
	ve = do_eval(v.value)
	nv = copy.copy(ve)
	nv['is_adr'] = False
	return nv


def do_eval_call(v):

	if v.isValueImmediate():
		return do_eval_literal(v)

	# eval all args
	args = []
	for a in v.args:
		arg = do_reval(a.value)
		args.append(arg)

	func = v.func
	ftype = func.type

	sret = need_sret(ftype)

	sret_retval = False
	if sret:
		out("; alloca memory for return value")
		sret_retval = llvm_alloca(ftype.to)

	# eval func
	f = do_eval(func)

	if ftype.is_pointer():
		# pointer to array needs additional load
		f = llvm_dold(f)
		ftype = ftype.to

	to_unit = Type.eq(ftype.to, typeUnit)


	# do call
	rv = None
	if to_unit or sret:
		lo("call ")
		rv = llvm_value_zero(ftype.to)
	else:
		rv = ll_reg_operation(HLIR_VALUE_OP_CALL, ftype.to)

	if ftype.extra_args:
		print_type_func(ftype)
	else:
		if ftype.to.is_unit():
			out("void")
		elif ftype.to.is_array():
			out("void")
		else:
			print_type(ftype.to)

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




def index(x):
	i = do_reval(x.index)

	# разфменовываем указатель на массив по умолчанию сами
	if x.left.type.is_pointer():
		ll = do_reval(x.left)
		return (ll, (i,))

	if x.left.isValueIndex():
		y, i2 = index(x.left)
		return (y, i2 + (i,))

	return do_eval(x.left), (i,)



def do_eval_index(x):
	if x.isValueImmediate():
		return do_eval_literal(x)

	left, indexes = index(x)
	return ass(left, indexes)



def getET(et):
	if et.is_pointer():
		return et.to
	return et


# GEP !элемент массива на который указываешь!
def ass(left, indexes):
	result_type = left['type']

	# VLA VLA VLA
	# ACCESS TO VLA, SPECIAL WAY
	lt = left['type']
	if lt.is_pointer():
		lt = lt.to

	if lt.is_vla():
		rootType = lt.get_array_root()
		# получаем полное смещение в единицах - rootType
		# (GEP будет оперировать с шагом sizeof(rootType))
		# Полное смещение - смещение сразу для всех индексов (если их несколько)
		#out("\n\t; -- INDEX VLA --")
		full_offset = llvm_value_zero(typeInt32)
		i = 0
		while i < len(indexes):
			index = indexes[i]
			step = lt.of.runtimeSizeRoots
			offset = llvm_eval_binary(HLIR_VALUE_OP_MUL, index, step)
			full_offset = llvm_eval_binary(HLIR_VALUE_OP_ADD, full_offset, offset)
			lt = lt.of
			i += 1

		ep = llvm_gep(left, left['type'], [full_offset], result_type, rootType)
		#out("\n\t; -- END INDEX VLA --")
		return ep

	# classic access through pointer
	et = getET(left['type'])
	indexes = (llvm_value_num_zero,) + indexes
	return llvm_gep(left, left['type'], indexes, result_type, et)



def do_eval_slice(x):
	if x.isValueImmediate():
		return do_eval_literal(x)

	left = x.left
	if left.type.is_pointer():
		pointer = do_reval(left)
		array_type = pointer['type'].to
		index = do_reval(x.index_from)
		result_type = x.type
		indexes = (llvm_value_num_zero, index)
		et = getET(left.type)
		ptr_to_item = llvm_gep(pointer, array_type, indexes, array_type.of, et)
		out("\n;")

		pnv = llvm_cast("bitcast", ptr_to_item, TypePointer(x.type))
		pnv['is_adr'] = True
		return pnv


	array = do_eval(left)
	array_type = array['type']
	result_type = x.type
	index = do_reval(x.index_from)

	# если сам массив находится в регистре: (let rec = get_rec())
	if not array['is_adr']:
		if v[HLIR_VALUE_OP_INDEX].isValueRuntime():
			error("expected immediate index value", x.ti)
			return llvm_value_zero(x.type)

		return extractvalue(array, result_type, index.asset)

	indexes = (llvm_value_num_zero, index)
	et = getET(left.type)
	ptr_to_item = llvm_gep(array, array_type, indexes, array_type.of, et)
	pnv = llvm_cast("bitcast", ptr_to_item, TypePointer(x.type))
	pnv['is_adr'] = True
	return pnv



def getET2(et):
	while et.is_pointer():
		et = et.to
	return et



def by_value(x):
	return not (x['is_adr'] or x['type'].is_pointer())


# GEP !элемент массива на который указываешь!
def ass2(left, indexes):
	result_type = left['type']
	et = getET2(left['type'])

	if by_value(left):
		return llvm_extractvalue(left, result_type, indexes)

	# когда обращаемся к структуре через указатель
	# первый индекс GEP должен быть 0
	indexes = [llvm_value_num_zero] + indexes
	return llvm_gep(left, left['type'], indexes, result_type, et)


def access(x):
	i = x.field

	# разфменовываем указатель на массив по умолчанию сами
	if x.left.type.is_pointer():
		ll = do_reval(x.left)
		return (ll, (i,))

	if x.left.isValueAccessRecord():
		y, i2 = access(x.left)
		return (y, i2 + (i,))

	return do_eval(x.left), (i,)



def do_eval_access(x):
	if x.isValueImmediate():
		return do_eval_literal(x)

	left, fields = access(x)
	notype = typeInt32
	indexes = []

	for f in fields:
		fno = llvm_value_num(notype, f.field_no)
		indexes.append(fno)
	return ass2(left, indexes)





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
	if a.is_number() or a.is_arithmetical() or a.is_char() or a.is_bool() or a.is_word():

		if Type.is_pointer(b):
			return 'bitcast'

		if b.is_number() or b.is_arithmetical() or b.is_char() or b.is_bool() or b.is_word():
			signed = Type.is_signed(b)

			# Это плохо тк не работает в некоторых особых ситуациях
			# например для  i17 to i32 вернет bitcast что неверно!
			# но пока не убираю тк непонятно чем аукнется еще
			#aw = align_bits_up(a.width)
			#bw = align_bits_up(b.width)

			aw = a.width
			bw = b.width

			if aw < bw:
				return 'sext' if signed else 'zext'

			elif aw > bw:
				return 'trunc'

			else:
				return 'bitcast'

		elif Type.is_pointer(b):
			return 'inttoptr'

		elif Type.is_float(b):
			return 'sitofp' if Type.is_signed(a) else 'uitofp'

	elif Type.is_pointer(a):
		if Type.is_pointer(b):
			return 'bitcast'
		elif Type.is_arithmetical(b) or Type.is_word(b):
			return 'ptrtoint'

	elif Type.is_float(a):
		# Float -> Integer
		if Type.is_arithmetical(b):
			return 'fptosi' if Type.is_signed(b) else 'fptoui'

		# Float -> Float
		elif Type.is_float(b):
			if a.width < b.width:
				return 'fpext'
			elif a.width > b.width:
				return 'fptrunc'
			else:
				return 'bitcast'

	return 'cast <%s -> %s>' % (str(a), str(b))



def is_adr_or_ptr(x):
	assert(x['isa'] == 'll_value')
	return x['is_adr'] or Type.is_pointer(x['type'])


def cons_composite_from_composite(to_type, value, ti):
	#info("cons_composite_from_composite", ti)
	v = do_eval(value)

	if is_global_context():
		# не можем приводить глобально (used!)
		return v

	if v['is_adr']:
		# received not value but it address (formally pointer)
		out("\n; -- cons_composite_from_composite_by_adr --")
		casted_ptr = llvm_cast("bitcast", v, TypePointer(to_type))
		casted_ptr['type'] = to_type
		casted_ptr['is_adr'] = True
		llv = llvm_load(casted_ptr)
		out("\n; -- end cons_composite_from_composite_by_adr --")
		return llv

	#
	# received value in reg
	#

	out("\n; -- cons_composite_from_composite_by_value --")
	if to_type.size > value.type.size:
		#out("\n\t; extend")
		# выделим память под новое значение
		nv = llvm_alloca(to_type)
		# приводим указатель на слот к указателю на (меньшее) значение
		xnv = llvm_cast("bitcast", nv, TypePointer(v['type']))
		llvm_store(xnv, v)
		nv['is_adr'] = True
	else:
		#out("\n\t; trunk")
		y = llvm_alloca_store(v['type'], init_value=v)
		nv = llvm_cast("bitcast", y, TypePointer(to_type))
		nv['is_adr'] = True
	out("\n; -- end cons_composite_from_composite_by_value --")
	return nv






def eval_cons_record(x):
	value = x.value
	from_type = value.type
	to_type = x.type

	if x.asset != None:
		return do_eval_literal(x)

	# Cm имеет структурную систему типов, тогда как llvm - номинативную
	# приведение структуры к структуре по значению не поддерживается LLVM
	# поэтому делаем его специально
	return cons_composite_from_composite(to_type, value, x.ti)



def eval_cons_array(x):
	if x.isValueImmediate():
		if Type.is_vla(x.type):
			return do_eval_literal(x.value)
		return do_eval_literal(x)

	return cons_composite_from_composite(x.type, x.value, x.ti)



# Рекурсивно вычисляем itemSizeInRootElements & arraySizeInRootElements
# для каждого типа массива (в цепочке [m][n]...)
# Если встречаем в цепи указатель, перешагиваем и идем дальше
# тк надо обработать все типы-массивы в цепочке
# Ex: *[m]*[n]*[p]Int32
def handleVLA(t):
	#info("calculate VLA step", t.ti)
	# type size (in VLA chain) in root-items
	runtimeSizeRoots = None
	runtimeSizeBytes = None
	runtimeVolume = None

	if hasattr(t, 'runtimeSizeRoots'):
		# already handled type, skip
		return

	if t.is_array():
		handleVLA(t.of)
		# Get VLA size
		# размер массива = его объем * объем его элемента
		if t.is_closed_array():
			#out("\n\t; -- HANDLE VLA --")
			volume = do_reval(t.volume)
			runtimeVolume = volume
			runtimeSizeRoots = llvm_eval_binary(HLIR_VALUE_OP_MUL, volume, t.of.runtimeSizeRoots)
			#out("\n\t; -- END HANDLE VLA --")
		else:
			# Если это open_array
			runtimeSizeRoots = llvm_value_num(typeInt32, 1)
			runtimeVolume = llvm_value_num(typeInt32, 1)

		runtimeSizeBytes = llvm_eval_binary(HLIR_VALUE_OP_MUL, runtimeVolume, t.of.runtimeSizeBytes)

	else:
		# Если встретили указатель - перешагиваем и идем дальше
		if t.is_pointer():
			handleVLA(t.to)

		runtimeSizeBytes = llvm_value_num(typeInt32, t.size)
		runtimeSizeRoots = llvm_value_num(typeInt32, 1)
		runtimeVolume = llvm_value_num(typeInt32, 1)

	t.runtimeSizeRoots = runtimeSizeRoots
	t.runtimeSizeBytes = runtimeSizeBytes
	t.runtimeVolume = runtimeVolume
	return


def do_eval_cons_pointer_to_array(x):
	value = x.value
	from_type = value.type
	type = x.type

	# Calculate size of VLA value in runtime (!)
	if type.to.is_vla():
		handleVLA(type.to)

	v = do_reval(value)
	return docast(v, type)


def do_eval_cons(x):
	value = x.value
	from_type = value.type
	type = x.type

	# (!) WARNING (!)
	# - in C  int32(-1) -> uint64 => 0xffffffffffffffff
	# - in Cm int32(-1) -> uint64 => 0x00000000ffffffff
	# required: (uint64_t)((uint32)int32_value)
	if type.is_word():
		#if from_type.is_int() or from_type.is_number():
		if from_type.is_int() or from_type.is_number():
			v = do_reval(value)
			return docast(v, type)


	if type.is_scalar_type():
		if from_type.is_number():
			if type.width == from_type.width:
				return do_reval(value)


	# skipping cast to THE SAME type
	if id(value.type) == id(type):
		return do_reval(value)


	if from_type.is_va_list():
		# приведение объекта типа va_list в CM особенное
		# оно дает доступ к следующему элементу списка
		rv = do_eval(value)
		return llvm_va_arg(rv, type)


	if type.is_pointer():
		if from_type.is_pointer():
			# skipping cast pointer to pointer of the same type
			if id(type.to) == id(from_type.to):
				return do_reval(value)

			if type.to.is_closed_array():
				if from_type.to.is_array():
					return do_eval_cons_pointer_to_array(x)


		elif from_type.is_string():
			# *Str8 "A"
			if type.to.is_array_of_char():
				string_of = type.to.of
				char_pow = string_of.width
				iszstr = True #x.hasAttribute3('zstring')
				return llvm_value_str(x.strid, x.strdata, x.type, isz=iszstr)

	elif type.is_array():
		return eval_cons_array(x)

	elif type.is_record():
		return eval_cons_record(x)

	elif type.is_char():
		if value.type.is_string():
			return do_eval_literal(x)

	elif type.is_unit():
		return llvm_value_zero(type)

	# anyNonZeroValue to Bool  ==  true  (!)
	# (the same as in C)
	elif type.is_bool():
		v = do_reval(value)
		zero = llvm_value_num(v.type, 0)
		return llvm_eval_binary('icmp ne', v, zero, x)


	if value.isValueImmediate():
		if x.asset:
			# В случае Nat32 &x у нас занчение immediate
			# но нет asset тк это поздний imm
			if not type.is_pointer():
				return do_eval_literal(x)

	v = do_reval(value)


	if is_global_context():
		return v

	# Приводим immediate значение прямо по месту
	if value.isValueImmediate():
		return llvm_value_inline_cast(type, v)

	return docast(v, type)



def docast(v, to_type):
	from_type = v['type']
	opcode = select_cast_operator(from_type, to_type)
	return llvm_cast(opcode, v, to_type)



bin_ops = [
	HLIR_VALUE_OP_LOGIC_OR, HLIR_VALUE_OP_LOGIC_AND,
	HLIR_VALUE_OP_OR, HLIR_VALUE_OP_XOR, HLIR_VALUE_OP_AND, HLIR_VALUE_OP_SHL, HLIR_VALUE_OP_SHR,
	HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE, HLIR_VALUE_OP_LT, HLIR_VALUE_OP_GT, HLIR_VALUE_OP_LE, HLIR_VALUE_OP_GE,
	HLIR_VALUE_OP_ADD, HLIR_VALUE_OP_SUB, HLIR_VALUE_OP_MUL, HLIR_VALUE_OP_DIV, HLIR_VALUE_OP_REM,
]


def do_eval_string(x):
	info("do_eval_string??", x.ti)
	1/0


def do_eval_array(v):
	# сперва вычисляем все элементы массива в регистры
	# (кроме констант, они едут до последнего)
	items = []
	for item in v.asset:
		iv = do_reval(item)
		items.append(iv)

	# global?
	# глобальный массив распечатает print_value как литерал
	if is_global_context():
		return llvm_value_array(items, v.type)

	#
	# local context
	#

	# если мы локальны то создадим иммутабельную структуру
	# с массивом (insertvalue)
	#%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
	xv = llvm_value_array([], v.type)

	# набиваем массив
	items = []
	i = 0
	while i < len(v.asset):
		item = v.asset[i]
		# нет смысла засовывать в 'массив по значению' нулевые элементы
		# тк он порождается из zeroinitializer и zero filled by default
		if not item.isValueZero():
			lliv = do_reval(item)
			xv = insertvalue(xv, lliv, i)
		i = i + 1

	return xv



# вычисляем значение-запись по месту
# просто высичлим все его элементы и завернем все в 'll_value'/'record'
def do_eval_record(v):
	# сперва вычисляем все иницифлизаторы поелей структуры в регистры
	# (кроме констант, ведь они едут до последнего)
	rec_type = v.type

	if is_global_context():
		items = []
		for initializer in v.asset:
			iv = do_reval(initializer.value)
			items.append({'id': initializer.id, 'value': iv})
		return llvm_value_record(items, rec_type)

	# local context

	xv = llvm_value_record([], rec_type)

	# набиваем структуру
	for initializer in v.asset:
		# нет смысла засовывать в структуру по значению нулевые элементы
		# тк она порождается из zeroinitializer и по умолчанию заполнена нулями
		if not initializer.value.isValueZero():
			iv = do_reval(initializer.value)
			field = htype.record_field_get(rec_type, get_id_str(initializer))
			xv = insertvalue(xv, iv, field.field_no)

	return xv



def do_eval_func(x):
	return llvm_value_id(get_id_str(x), x.type)


def do_eval_var(x):
	id_str = get_id_str(x)

	if x.storage_class in (HLIR_VALUE_STORAGE_CLASS_LOCAL, HLIR_VALUE_STORAGE_CLASS_PARAM):
		y = locals_get(id_str)
	else:
		y = llvm_value_id(id_str, x.type)

	y['is_adr'] = True
	return y



def do_eval_const(x):
	if x.storage_class in (HLIR_VALUE_STORAGE_CLASS_LOCAL, HLIR_VALUE_STORAGE_CLASS_PARAM):
		localname = get_id_str(x)
		y = locals_get(localname)
		return y

	if not is_global_context():
		# Аргументы функуции это константы но у них поле value == None!
		if x.init_value != None:
			# константные массивы (даже дженерик)
			# печатаются и их можео индексировать
			if x.init_value.type.is_array():
				rv = llvm_value_id(get_id_str(x), x.type)
				rv['is_adr'] = True
				return rv

	return do_eval(x.init_value)


def do_eval_bool(x):
	return llvm_value_num(x.type, 1 if x.asset else 0)


def do_eval_literal(x):
	xt = x.type
	if xt.is_number(): return llvm_value_num(xt, x.asset)
	elif xt.is_arithmetical(): return llvm_value_num(xt, x.asset)
	elif xt.is_float(): return llvm_value_num(xt, x.asset)
	elif xt.is_record(): return do_eval_record(x)
	elif xt.is_array(): return do_eval_array(x)
	elif xt.is_bool(): return do_eval_bool(x)
	elif xt.is_free_pointer(): return llvm_value_num(xt, x.asset)
	elif xt.is_pointer(): return do_eval_pointer(x)
	elif xt.is_char(): return llvm_value_num(xt, x.asset)
	elif xt.is_word(): return llvm_value_num(xt, x.asset)
	elif xt.is_string(): return do_eval_string(x)
	#elif xt.is_enum(): return llvm_value_num(xt, x.asset)
	else:
		error("do_eval_literal: unknown literal", x.ti)
		Value.print(x)
		exit(1)


def do_eval_pointer(x):
	return llvm_value_num(x.type, x.asset)


def do_eval_va_start(x):
	va_list = do_eval(x.va_list)
	return llvm_va_start(va_list)


def do_eval_va_arg(x):
	va_list = do_eval(x.va_list)
	return llvm_va_arg(va_list, x.type)


def do_eval_va_end(x):
	va_list = do_eval(x.va_list)
	return llvm_va_end(va_list)


def do_eval_va_copy(x):
	dst = do_eval(x.dst)
	src = do_eval(x.src)
	return llvm_va_copy(dst, src)


def do_eval_not2(v, xor_msk):
	#%10 = xor i32 %9, -1
	# or
	#%10 = xor i32 %9, 1
	ve = do_reval(v.value)
	minus_one = llvm_value_num(v.type, xor_msk)
	return llvm_eval_binary(HLIR_VALUE_OP_XOR, ve, minus_one, v)


def do_eval_not(x):
	if x.value.type.is_bool():
		return do_eval_not2(x, xor_msk=1)
	# is word
	return do_eval_not2(x, xor_msk=-1)


def do_eval_neg(v):
	#%10 = sub i32 0, %9
	ve = do_reval(v.value)
	zero = llvm_value_num(v.type, 0)
	return llvm_eval_binary(HLIR_VALUE_OP_SUB, zero, ve, v)


def do_eval_pos(v):
	return do_reval(v.value)


def _eval_sizeof_type(t):
	if t.is_vla():
		handleVLA(t)

		return t.runtimeSizeBytes
		# size = VLA_volume * sizeof(VLA_rootType)
		rs = t.get_array_root().size
		rootSize = llvm_value_num(typeInt32, rs)
		size = llvm_eval_binary(HLIR_VALUE_OP_MUL, t.runtimeSizeRoots, rootSize)
		return size

	return llvm_value_num(typeInt32, t.size)


def do_eval_sizeof_value(x):
	return _eval_sizeof_type(x.of.type)

def do_eval_sizeof_type(x):
	return _eval_sizeof_type(x.of)




def do_eval(x):
	assert(isinstance(x, Value))

	y = None
	if x.isValueLiteral(): y = do_eval_literal(x)
	elif x.isValueBin(): y = do_eval_bin(x)
	elif x.isValueShl(): y = do_eval_shl(x)
	elif x.isValueShr(): y = do_eval_shr(x)
	elif x.isValueCons(): y = do_eval_cons(x)
	elif x.isValueRef(): y = do_eval_ref(x)
	elif x.isValueDeref(): y = do_eval_deref(x)
	elif x.isValueConst(): y = do_eval_const(x)
	elif x.isValueFunc(): y = do_eval_func(x)
	elif x.isValueVar(): y = do_eval_var(x)
	elif x.isValueCall(): y = do_eval_call(x)
	elif x.isValueIndex(): y = do_eval_index(x)
	elif x.isValueAccessModule(): y = do_eval(x.value)
	elif x.isValueAccessRecord(): y = do_eval_access(x)
	elif x.isValueSlice(): y = do_eval_slice(x)
	elif x.isValueSubexpr(): y = do_eval(x.value)
	elif x.isValueNot(): y = do_eval_not(x)
	elif x.isValueNeg(): y = do_eval_neg(x)
	elif x.isValuePos(): y = do_eval_pos(x)
	elif x.isValueNew(): y = do_eval_new(x)
	elif x.isValueZero(): y = do_eval_literal(x)
	elif x.isValueSizeofValue(): y = do_eval_sizeof_value(x)
	elif x.isValueSizeofType(): y = do_eval_sizeof_type(x)
	elif x.isValueLengthof(): y = do_eval_lengthof(x)
	elif x.isValueAlignof(): y = do_eval_literal(x)
	elif x.isValueOffsetof(): y = do_eval_literal(x)
	elif x.isValueVaStart(): y = do_eval_va_start(x)
	elif x.isValueVaArg(): y = do_eval_va_arg(x)
	elif x.isValueVaEnd(): y = do_eval_va_end(x)
	elif x.isValueVaCopy(): y = do_eval_va_copy(x)
	elif x.isValueUndef(): y = llvm_value_undef(x.type)
	else:
		out("<??>")

	if y == None:
		error("llvm do_eval cannot eval (%s) value" % 'k', x.ti)
		print(x)
		Value.print(x)
		type_print(x.type)
		1 / 0
		return llvm_value_zero(x.type)

	y['proto'] = x
	y['type'] = x.type

	return y


def do_eval_lengthof(x):
	t = x.value.type
	if t.is_vla():
		handleVLA(t)
		return t.runtimeVolume

	return llvm_value_num(typeInt32, t.length)


#
#
#

def print_stmt_assign(x):
	l = do_eval(x.left)
	r = do_reval(x.right)
	llvm_store(l, r)


def print_stmt_if(x):
	global fctx
	if_id = fctx['if_no']
	fctx['if_no'] = fctx['if_no'] + 1
	out("\n; if_%d" % if_id)
	cv = do_reval(x.cond)

	then_label = 'then_%d' % if_id
	else_label = 'else_%d' % if_id
	endif_label = 'endif_%d' % if_id

	if x.els == None:
		else_label = endif_label

	llvm_br(cv, then_label, else_label)

	# then block
	llvm_label(then_label)
	print_stmt(x.then)
	llvm_jump(endif_label)

	# else block
	if x.els != None:
		llvm_label(else_label)
		print_stmt(x.els)
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

	out("\n; while_%d" % cur_while_id)
	llvm_jump(again_label)
	llvm_label(again_label)
	cv = do_reval(x.cond)
	llvm_br(cv, body_label, break_label)
	llvm_label(body_label)
	print_stmt(x.stmt)
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

	if x.value != None:
		v = do_reval(x.value)
		if not need_sret(fctx['func'].type):
			lo("ret ")
			llvm_print_type_value(v)
			reg_get()  # for LLVM
			return None

		# return via sret
		to = fctx['func'].type.to
		p2retval = llvm_value_reg("0", TypePointer(to))
		llvm_store(p2retval, v)

	lo("ret void")
	reg_get()  # for LLVM
	return None



def print_stmt_var(x):
	var = x.value
	t = var.type
	id_str = get_id_str(var)

	sz = None

	# VLA VLA VLA
	# Calculate size of VLA value in runtime (!)
	if t.contains_vla():
		handleVLA(t)
		sz = t.runtimeSizeRoots
	if t.is_vla():
		t = t.get_array_root()
	# VLA VLA VLA


	left = llvm_alloca(t, size=sz, alignment=t.align)
	locals_add(id_str, left)

	init_value = x.init_value
	if not init_value.isValueUndef():
		iv = do_reval(init_value)
		llvm_store(left, iv)

	return None



def print_stmt_const(x):
	id_str = get_id_str(x)
	iv = x.init_value

	if iv.type.is_string():
		return None

	if iv.isValueCall():
		if need_sret(iv.func.type):
			v = do_eval_call(iv)
			locals_add(id_str, v)
			return None

	v = do_reval(iv)
	t = x.value.type

	# VLA VLA VLA
	# Calculate size of VLA value in runtime (!)
	if t.contains_vla():
		handleVLA(t)
		sz = t.runtimeSizeRoots
	if t.is_vla():
		t = t.get_array_root()
	# VLA VLA VLA

	# для let-массивов выделяем память (alloca)
	# поскольку их могут индексировать переменной
	# а массив-значение в "регистре" невозможно индексировать переменной
	if Type.is_closed_array(t) or Type.is_record(t):
		v = llvm_alloca_store(t, id_str=None, init_value=v)

	locals_add(id_str, v)
	return None


def print_stmt_block(s):
	locals_push()

	for stmt in s.stmts:
		print_stmt(stmt)

	locals_pop()



def print_comment(x):
	out("\n" * x.nl)
	if isinstance(x, StmtCommentLine):
		print_comment_line(x)
	elif isinstance(x, StmtCommentBlock):
		print_comment_block(x)


def print_comment_block(x):
	out(";%s" % x.text.replace('\n', '\n;'))


def print_comment_line(x):
	lines = x.lines
	i = 0
	n = len(lines)
	while i < n:
		line = lines[i]
		#if need_indent:
		indent()
		out(";%s" % line)
		i = i + 1
		if i < n:
			out("\n")


"""
%12 = call { i64, i64 } asm sideeffect "add $0, $2, $3\0A\09add $0, $0, $4\0A\09add $1, $0, $4\0A\09", "=r,=r,r,r,r,~{w0},~{cc}"(i64 %9, i64 %10, i64 %11)
"""
"store i64 %13, i64* %7, align 8"
def print_stmt_asm(x):
	asm_text = x.text.asset
	asm_text = asm_text.replace("%", "$")

	specs = [] # list of spec & clobber strings
	outs = []  # llvm values ti output

	lo('')
	reg = '00'  # '00' - bad reg
	if len(x.outputs) > 0:
		# у нас есть output значит будет возврат значения
		reg = reg_get()
		out("%%%s = " % (reg))

		for pair in x.outputs:
			specs.append(pair[0].asset)
			arg = do_eval(pair[1])
			outs.append(arg)

	args = []
	if len(x.inputs) > 0:
		for pair in x.inputs:
			specs.append(pair[0].asset)
			arg = do_eval(pair[1])
			args.append(arg)

	for clobber in x.clobbers:
		specs.append("~{%s}" % clobber.asset)

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
			id = Id('<noname>')
			f = Field(id, field_type, init_value=ValueUndef(field_type), ti=x.ti)
			fields.append(f)

		rt = TypeRecord(fields)
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
	assert(isinstance(x, Stmt))
	if x.is_stmt_block(): print_stmt_block(x)
	elif x.is_stmt_value_expr(): do_eval(x.value)
	elif x.is_stmt_assign(): print_stmt_assign(x)
	elif x.is_stmt_return(): print_stmt_return(x)
	elif x.is_stmt_if(): print_stmt_if(x)
	elif x.is_stmt_while(): print_stmt_while(x)
	elif x.is_stmt_def_var(): print_stmt_var(x)
	elif x.is_stmt_def_const(): print_stmt_const(x)
	elif x.is_stmt_break(): print_stmt_break(x)
	elif x.is_stmt_again(): print_stmt_again(x)
	elif x.is_stmt_comment(): print_comment(x)
	elif x.is_stmt_asm(): print_stmt_asm(x)
	elif x.is_stmt_def_type(): pass #print_def_type(x)
	else: lo("<stmt %s>" % str(x))




def print_func_params(ftype, only_types=False, with_attributes=True):
	# here can be a pointer to function
	if Type.is_pointer(ftype):
		ftype = ftype.to

	params = ftype.params
	to = ftype.to

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
		isarr = Type.is_closed_array(param.type)

		if i > 0:
			out(", ")

		print_type(param.type)

		if not only_types:
			if isarr:
				out(" %%__%s" % get_id_str(param))
			else:
				out(" %%%s" % get_id_str(param))

		i = i + 1


	if ftype.extra_args:
		out(", ...")



def print_type_func(t):
	if Type.is_unit(t.to) or need_sret(t):
		out("void")
	else:
		print_type(t.to)

	out(" (")
	print_func_params(t, only_types=True)
	out(")")


def print_func_signature(ftype, idStr):
	if Type.is_unit(ftype.to) or need_sret(ftype):
		out("void")
	else:
		print_type(ftype.to)

	out(" @%s(" % idStr)
	print_func_params(ftype)
	out(")")




def is_private(x):
	if isinstance(x, StmtDef):
		return x.access_level == HLIR_ACCESS_LEVEL_PRIVATE
	return False


#['private', 'internal', 'weak', 'external'] # etc..
def get_linkage(x):
	if x.hasAttribute('extern'):
		return "external"
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
	fn = x.value
	str = get_id_str(fn)
	print_func_signature(fn.type, str)



def print_def_func(x):
	fn = x.value
	ftype = fn.type

	if x.stmt == None:
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


	if x.hasAttribute2('inlinehint'):
		out(" inlinehint")
	if x.hasAttribute2('inline'):
		out(" alwaysinline")
	if x.hasAttribute2('noinline'):
		out(" noinline")

	#
	# Добавляем параметры в локальную таблицу
	#

	params = ftype.params
	for param in params:
		param_id = get_id_str(param)

		if Type.is_va_list(param.type):
			# see: p216
			continue

		localObject = llvm_value_reg(param_id, param.type)

		if Type.is_closed_array(param.type):
			localObject['is_adr'] = True

		locals_add(param_id, localObject)


	# 0, 1, 2 - params; 3 - entry label, 4 - first free register
	entry_label = reg_get()  # should be here (!)

	out(" {")
	indent_up()

	# for any array parameter print local holder value
	for param in params:
		ptype = param.type
		if Type.is_closed_array(ptype):
			paramId = get_id_str(param)

			reg = '__' + param.id.str
			loadedParam = llvm_value_reg(reg, ptype)


			# Выделяем память под массив
			pholder = llvm_alloca(ptype, id_str=paramId)
			# сохраняем переданный по указателю массив в выделенный выше "регистр"
			# теперь это локальная копия "типа" переданного по значению массива
			# и далее работать будем только с ней
			llvm_store(pholder, loadedParam)

	if len(params) > 0:
		last_param = params[-1]
		if Type.is_va_list(last_param.type):
			# :p216
			# В LLVM va_arg принимает параметром указатель на укзаатель на __VA_List!
			# Но тк мы получаем просто указатель на va_list,
			# создадим локальную переменную сохраним в нее его,
			# и будем передавать va_arg указатель на эту локальную переменную

			# 1. создаем лок переменную для *va_arg
			va_list_srorage = llvm_alloca(typeFreePointer)

			# 2. сохраняем в нее полученный (параметр) *va_arg
			va_list_param_id = get_id_str(param)

			lo("store ")
			print_type(last_param.type)
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
	if fn.hasAttribute('stacksave'):
		#; stack save
		# %3 = alloca i8*, align 8 ; stack save
		# %7 = call i8* @llvm.stacksave()
		stackptr = llvm_alloca(typeFreePointer)
		stacksave(stackptr)
		fctx['stackptr'] = stackptr

	print_stmt_block(x.stmt)

	if Type.eq(ftype.to, typeUnit):
		print_stmt_return(StmtReturn(None))

	indent_down()
	lo("}\n")

	fctx_pop()



#def print_decl_type(x):
#	out("\n%%%s = type opaque" % get_id_str(x))


def print_def_type(x):
	xtype = x.original_type
	out("\n%%%s = type " % get_id_str(x.type))
	if Type.is_record(xtype):
		# не печатаем имя а печатаем саму структуру
		# тк LLVM дает ошибку на запись вида
		# %Struct1 = type %Struct2; Error, wtf?
		print_type_record(xtype)
	else:
		print_type(xtype)
	out(";")
	if Type.is_record(xtype):
		out("\n")



def print_def_var(x, as_extern=False):
	is_extern = x.hasAttribute2('extern') or as_extern

	#mods = ['global', 'constant']
	mod = 'global'

	var = x.value
	out("\n@%s = " % get_id_str(var))
	print_linkage(x)
	out(mod + ' ')
	print_type(var.type)

	if not is_extern:
		if not x.init_value.isValueUndef():
			out(" ")
			llvm_print_value(do_eval(x.init_value))
		else:
			out(" zeroinitializer")

	if x.hasAttribute2('section'):
		section = x.getAnnotation('section')
		out(", section \"%s\"" % section.asset)

	if x.hasAttribute2('alignment'):
		alignment = x.getAnnotation('alignment')
		out(", align %d" % alignment.asset)

	return



def print_def_const(x, as_extern=False):
	init_value = x.init_value

	#if Type.is_composite(const_value.type):
	# В LLVM мы не печатаем константы, но массивы - вынуждены
	# тк доступ к ним может идти в рантайме по индексу;
	# НО! В константной записи может быть массив! (хз как быть пока)
	if Type.is_array(init_value.type):
		out("\n@%s = constant " % get_id_str(x.value))
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
			while i < len(x.asset):
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

	for c in string.asset:
		ss = ss + chr(c.asset)

	slen = len(bytes(ss, 'utf-8'))  #+ 1 # +1 (zero)

	if True: #string.hasAttribute3('zstring'):
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
	slen = len(string.strdata)

	if True: #string.hasAttribute3('zstring'):
		slen = slen + 1

	lo("@%s = private constant [%d x i%d] [" % (strid, slen, char_width))
	i = 0
	for char in string.strdata:
		char_code = char.asset
		if i > 0:
			out(", ")
		print_int_type_for(char_width)
		out(" %d" % char_code)
		i = i + 1

	if True: #string.hasAttribute3('zstring'):
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
		if string.id:
			# it is named constant
			strid = get_id_str(string)
		else:
			# it is anonymous string
			strno = strno + 1
			strid = 'str%d' % strno

		char_width = string.type.to.of.width

		string.strid = strid

		print_string_as_array(strid, string, char_width)
	out("\n; -- endstrings --")
	return


printed = []

def een(defs, decl_only=False):
	isa_prev = None
	for x in defs:

		if x.is_stmt_comment():
			print_comment(x)
			continue

		if x.is_stmt_directive():
			continue

		if x.hasAttribute2('ll_no_print'):
			continue
		if x.hasAttribute2('no_print'):
			continue

		if hasattr(x, 'id'):
			# Тупейшая Защита от повторного определения
			# (А они происходят тк импорты и инклуюды сложно сплетены и повтор.)
			uid = x.parent.id + '.' + x.id.str
			#uid = x.module.id + '.' + x.module.id

			if uid in printed:
				continue

			printed.append(uid)

#		if isa_prev != isa:
#			out("\n")
#			isa_prev = isa

		if x.is_stmt_def_var():
			print_def_var(x, as_extern=decl_only)

		elif x.is_stmt_def_const():
			print_def_const(x, as_extern=decl_only)

		elif x.is_stmt_def_func():
			if not decl_only:
				print_def_func(x)
			else:
				print_decl_func(x)

		elif x.is_stmt_def_type():
			print_def_type(x)

		elif x.is_stmt_comment():
			print_comment(x)


# защита от повторного включения
already_in = []

def print_included(m):

	if isinstance(m, Stmt):
		if m.is_stmt_import():
			m = m.module

	for inc in m.included_modules:
		# защита от повторного включения
		if inc.id not in already_in:
			already_in.append(inc.id)
			print_included(inc)

			out("\n; from included %s" % inc.id)

			for d in inc.defs:
				if is_private(d):
					continue

				if d.is_stmt_def_type():
					print_def_type(d)
				elif d.is_stmt_def_func():
					print_decl_func(d)
				#elif d['isa'] == 'def_const':
				#	print_decl_const(x)



already_imported = []

def print_imports(imports):
	for imp_id in imports:
		imp = imports[imp_id]

		# Защита от повторной распечатки импорта
		if imp.name in already_imported:
			continue
		already_imported.append(imp.name)

		print_included(imp)
		print_imports(imp.module.imports)

		out("\n\n; from import \"%s\"" % imp.name)

		for d in imp.module.defs:
			if is_private(d):
				continue

			if d.is_stmt_def_type():
				print_def_type(d)
			elif d.is_stmt_def_func():
				print_decl_func(d)

		out("\n\n; end from import \"%s\"" % imp.name)



separatorLine = "\n; " + '-' * 77
# список имен модулей распечатанных в текущей сброке
#printed_modules = []

def print_module(m):
	#if m['source_info']['path'] in printed_modules:
	#	return

	out("; MODULE: %s\n" % m.id)

#	out("\n; -- print lldeps --")
#	for d in cmodule.lldeps:
#		out("; -- %s" % get_id_str(d))
#	out("\n; -- end print lldeps --")

	out("\n; -- print includes --")
	print_included(m)
	out("\n; -- end print includes --")

	out("\n; -- print imports '%s' --" % m.id)
	out("\n; -- %d" % len(m.imports))
	print_imports(m.imports)
	out("\n; -- end print imports '%s' --" % m.id)

	# печатаем декларации
	# из экспортируемой части импортированных модулей
	"""for imported_module_id in m['imports']:
		imp = m['imports'][imported_module_id]
		out(separatorLine)
		out("\n; declarations from: %s" % (imported_module_id))
		out(separatorLine)
		een(imp.defs)
		out("\n\n")"""

	print_strings(m.strings)

	een(m.defs)

	out("\n\n")
	return



def run(module, outname):
	global cmodule
	cmodule = module
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
	lo("%Word256 = type i256")
	lo("%Char8 = type i8")
	lo("%Char16 = type i16")
	lo("%Char32 = type i32")
	lo("%Int8 = type i8")
	lo("%Int16 = type i16")
	lo("%Int32 = type i32")
	lo("%Int64 = type i64")
	lo("%Int128 = type i128")
	lo("%Int256 = type i256")
	lo("%Nat8 = type i8")
	lo("%Nat16 = type i16")
	lo("%Nat32 = type i32")
	lo("%Nat64 = type i64")
	lo("%Nat128 = type i128")
	lo("%Nat256 = type i256")
	lo("%Float32 = type float")
	lo("%Float64 = type double")
	lo("%%Size = type i%d" % SIZE_WIDTH)
	lo("%Pointer = type i8*")
	lo("%Str8 = type [0 x %Char8]")
	lo("%Str16 = type [0 x %Char16]")
	lo("%Str32 = type [0 x %Char32]")
	lo("%__VA_List = type i8*")

	if module.hasAttribute('use_va_arg'):
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



REL_OPS = [HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE, HLIR_VALUE_OP_LT, HLIR_VALUE_OP_GT, HLIR_VALUE_OP_LE, HLIR_VALUE_OP_GE]


def get_bin_opcode(op, t):
	# ["icmp slt", "icmp ult", x]
	def select_bin_opcode_su(sop, uop, t):
		if Type.is_unsigned(t):
			return uop
		return sop

	# ["sdiv", "udiv", "fdiv", x]
	def select_bin_opcode_f(op, fop, t):
		if Type.is_float(t):
			return fop
		return op

	# ["sdiv", "udiv", "fdiv", x]
	def select_bin_opcode_suf(sop, uop, fop, t):
		if Type.is_float(t):
			return fop
		return select_bin_opcode_su(sop, uop, t)

	opcode = "<unknown opcode '%s'>" % op
	if op in [HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE]:
		opcode = select_bin_opcode_f('icmp ' + op, 'fcmp o' + op, t)
	elif op in [HLIR_VALUE_OP_ADD, HLIR_VALUE_OP_SUB, HLIR_VALUE_OP_MUL]:
		opcode = select_bin_opcode_f(op, 'f' + op, t)
	elif op in [HLIR_VALUE_OP_AND, HLIR_VALUE_OP_OR, HLIR_VALUE_OP_XOR, HLIR_VALUE_OP_SHL]:
		opcode = op
	elif op in [HLIR_VALUE_OP_DIV, HLIR_VALUE_OP_REM]:
		opcode = select_bin_opcode_suf('s' + op, 'u' + op, 'f' + op, t)
	elif op in [HLIR_VALUE_OP_LT, HLIR_VALUE_OP_GT, HLIR_VALUE_OP_LE, HLIR_VALUE_OP_GE]:
		opcode = select_bin_opcode_suf('icmp s' + op, 'icmp u' + op, 'fcmp o' + op, t)
	#elif op == HLIR_VALUE_OP_SHR:
	#	opcode = 'ashr' if Type.is_signed(t) else 'lshr'
	elif op == HLIR_VALUE_OP_LOGIC_OR:
		opcode = HLIR_VALUE_OP_OR
	elif op == HLIR_VALUE_OP_LOGIC_AND:
		opcode = HLIR_VALUE_OP_AND

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
	llvm_store(sptr, r)
	return sptr



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

