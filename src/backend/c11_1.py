
from util import nbits_for_num
from .common import str_nl_indent, indent_up, indent_down


def wrap_if(x, cond):
	return "(%s)" % x if cond else x


def str_specs(specs):
	s = ''
	for opt in specs:
		s += opt + ' '
	return s


def with_space(s):
	if s != '':
		return ' ' + s
	return ''




def str_gcc_attributes(annotations):
	if annotations == None:
		return ''

	# Modest attribute -> GCC attribute
	gcc_attributes = {
		# attributes with no parameters
		'inline': 'always_inline',
		'noinline': 'noinline',
		'used': 'used',
		'unused': 'unused',
		'packed': 'packed',
		'deprecated': 'deprecated',  # can be with string parameter
		'weak': 'weak',

		# attributes with one parameter
		'section': 'section',
		'alignment': 'aligned',
		'optimize': 'optimize',
	}

	atts = []
	for anno_name in annotations:
		#print(":anno:" + anno_name)
		asset = annotations[anno_name]
		if anno_name in gcc_attributes:
			gcc_att_name = gcc_attributes[anno_name]

			att_arg = ""
			if asset != {}:
				att_arg = str(asset.asset)
				if isinstance(att_arg, str):
					att_arg = '"%s"' % att_arg
				att_arg = '(' + att_arg + ')'

			atts.append("%s%s" % (gcc_att_name, att_arg))

	if atts != []:
		return "__attribute__((" + ", ".join(atts) + "))\n"

	return ""








class CField():
	def __init__(self, id_str, type, specs=None, nl=0):
		#assert(isinstance(type, CType))
		self.id_str = id_str
		self.type = type
		self.specs = specs if specs != None else []
		self.nl = nl



class CType():
	def __init__(self):
		pass

	def to_str(self, text):
		return "<type> " + text

	def __str__(self):
		return self.to_str(text='')


class CTypeNamed(CType):
	def __init__(self, id_str, specs=None):
		self.id_str = id_str
		self.specs = specs if specs != None else []
		self.precedence = 0

	def to_str(self, text):
		# "const int a"
		return str_specs(self.specs) + self.id_str + with_space(text)

	def __str__(self):
		return self.to_str(text='')


class CTypePointer(CType):
	def __init__(self, to, specs=None):
		self.to = to
		self.specs = specs if specs != None else []
		self.precedence = 1

	def to_str(self, text):
		# "*volatile p"
		text = '*%s' % str_specs(self.specs) + text
		text = wrap_if(text, self.to.precedence > self.precedence)
		text = str_ctype(self.to, text)
		return text

	def __str__(self):
		return self.to_str(text='')


class CTypeArray(CType):
	def __init__(self, of, volume=None, specs=None):
		of.specs = specs  # array specs is array item specs (!)
		self.of = of
		self.volume = volume
		self.specs = specs if specs != None else []
		self.precedence = 2

	def to_str(self, text):
		text = text + '['
		if self.volume != None and not self.volume.isValueUndef():
			from .c12 import do_cvalue
			text += str_cvalue(do_cvalue(self.volume))
		text += ']'
		text = wrap_if(text, self.of.precedence > self.precedence)
		text = str_ctype(self.of, text)
		return text

	def __str__(self):
		return self.to_str(text='')


class CTypeFunc(CType):
	def __init__(self, params, to, volume=None, extra_args=False, specs=None):
		self.params = params
		self.to = to
		self.extra_args = extra_args
		self.specs = specs if specs != None else []
		self.precedence = 3

	def to_str(self, text):
		params_text = ''
		i = 0
		params = self.params
		while i < len(params):
			param = params[i]
			p = str_ctype(param.type, text=param.id_str)
			if i > 0:
				params_text += ', ' + p
			else:
				params_text += p
			i = i + 1

		if self.extra_args:
			params_text += ', ...'

		if params_text == '':
			params_text = 'void'

		text = text + '(%s)' % params_text
		text = str_ctype(self.to, text)
		return text

	def __str__(self):
		return self.to_str(text='')


class CTypeStruct(CType):
	def __init__(self, fields, tag, specs=None):
		self.fields = fields
		self.tag = tag
		self.specs = specs if specs != None else []
		self.precedence = 0

	def to_str(self, text):
		nl_end = 0
		sstr = '%s {' % (self.tag)
		indent_up()
		i = 0
		nfields = len(self.fields)
		if nfields > 0:
			while i < nfields:
				field = self.fields[i]
				if field.nl > 0:
					nl_end = 1

				if i > 0 and field.nl == 0:
					if self.fields[i-1].nl == 0:
						sstr += ' '

				sstr += str_nl_indent(field.nl)
				sstr += str_ctype(field.type, text=field.id_str) + ';'
				i = i + 1
		else:
			sstr += 'uint8_t __placeholder;'
		indent_down()
		sstr += str_nl_indent(nl_end) + '}' + with_space(text)
		return sstr

	def __str__(self):
		return self.to_str(text='')



def str_ctype(t, text=''):
	assert(t != None)
	assert(text != None)
	#assert(isinstance(t, dict))

	return t.to_str(text)









def print_list_items(_list, method):
	sstr = ''
	i = 0
	while i < len(_list):
		arg = _list[i]
		if i > 0:
			sstr += ", "
		sstr += method(arg)
		i = i + 1
	return sstr




def string_literal_prefix(width):
	if width > 16: return "U"
	if width > 8: return "u"
	return ""



def str_number_suffix(req_bits, is_unsigned):
	sstr = ""
	if req_bits >= 32: #csettings['int_width']:
		if is_unsigned:
			sstr += "U"   # unsigned

		if req_bits <= 32: #csettings['long_width']:
			sstr += "L"   # long int
		elif req_bits <= 64: #csettings['long_long_width']:
			sstr += "LL"  # long long int
		else:
			sstr += "XL"  # extra long int (not defined in C)

	return sstr




class KV():
	def __init__(self, key, value, nl):
		self.key = key
		self.value = value
		self.nl = nl


class CValue():
	def __init__(self):
		self.mark = None


class CValueNamed(CValue):
	def __init__(self, id_str):
		super().__init__()
		self.id_str = id_str
		self.precedence = 15

	def __str__(self):
		return self.id_str


class CValueInteger(CValue):
	def __init__(self, number, is_unsigned=False, as_hex=False):
		super().__init__()
		self.number = number
		self.is_unsigned = is_unsigned
		self.as_hex = as_hex
		self.nsigns = 0
		self.precedence = 15

	def __str__(self):
		#return str(self.number) + str_number_suffix(nbits_for_num(self.number), self.is_unsigned)
		#def str_value_literal_number(num, nsigns=0, is_unsigned=False, as_hex=False):
		num = self.number
		width = nbits_for_num(num, signed=not self.is_unsigned)
		sstr = ''
		# Big Number?
		if width > 64:
			# print Big Numbers
			a1 = (num >> 64) & 0xFFFFFFFFFFFFFFFF
			a0 = (num >> 0)  & 0xFFFFFFFFFFFFFFFF
			if width == 128:
				return "BIG_INT128(0x%XULL, 0x%XULL)" % (a1, a0)
			elif width == 256:
				a3 = (num >> 192) & 0xFFFFFFFFFFFFFFFF
				a2 = (num >> 128) & 0xFFFFFFFFFFFFFFFF
				return "BIG_INT256(0x%XULL, 0x%XULL, 0x%XULL, 0x%XULL)" % (a3, a2, a1, a0)

		if self.as_hex:
			fmt = "0x%%0%dX" % self.nsigns
			sstr += (fmt % num)
		else:
			sstr += str(num)

		sstr += str_number_suffix(req_bits=nbits_for_num(num), is_unsigned=self.is_unsigned)
		return sstr



class CValueString(CValue):
	def __init__(self, string, width):
		assert(isinstance(string, str))
		super().__init__()
		self.string = string
		self.width = width
		self.precedence = 15

	def __str__(self):
		return '%s"%s"' % (string_literal_prefix(self.width), self.string)


class CValueChar(CValue):
	def __init__(self, char, width=8):
		assert(isinstance(char, str))
		super().__init__()
		self.char = char
		self.width = width
		self.precedence = 15

	def __str__(self):
		return "%s'%s'" % (string_literal_prefix(self.width), self.char)



class CValueArray(CValue):
	def __init__(self, items):
		super().__init__()
		self.items = items
		self.precedence = 15

	def __str__(self):
		items = print_list_items(self.items, str_cvalue)
		if items == '':
			items = '0'
		return '{%s}' % items


class CValueStruct(CValue):
	def __init__(self, items):
		super().__init__()
		self.items = items
		self.precedence = 15

	def __str__(self):
		sitems = ''
		#print_list_items(self.items, str_kv)
		indent_up()
		i = 0
		kv = None
		while i < len(self.items):
			kv = self.items[i]
			if i > 0 and kv.nl == 0:
				sitems += ' '
			sitems += str_nl_indent(kv.nl) + ".%s = %s" % (kv.key, str_cvalue(kv.value))
			if i < len(self.items) - 1:
				sitems += ','
			i += 1

		if kv != None and kv.nl > 0:
			sitems += '\n'
		indent_down()

		if sitems == '':
			sitems = '0'
		return '{%s}' % sitems





class CValueSubexpr(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		super().__init__()
		self.value = value
		self.precedence = 15

	def __str__(self):
		return '(%s)' % str_cvalue(self.value)



class CValueCall(CValue):
	def __init__(self, left, args):
		assert(isinstance(left, CValue))
		assert(isinstance(args, list))
		super().__init__()
		self.left = left
		self.args = args
		self.precedence = 14

	def __str__(self):
		return '%s(%s)' % (str_cvalue(self.left), print_list_items(self.args, str_cvalue))


class CValueAccess(CValue):
	def __init__(self, left, field_id_str):
		assert(isinstance(field_id_str, str))
		assert(isinstance(left, CValue))
		super().__init__()
		self.left = left
		self.field_id_str = field_id_str
		self.precedence = 14

	def __str__(self):
		return '%s.%s' % (str_cvalue(self.left), self.field_id_str)


class CValueAccessPtr(CValue):
	def __init__(self, left, field_id_str):
		assert(isinstance(field_id_str, str))
		assert(isinstance(left, CValue))
		super().__init__()
		self.left = left
		self.field_id_str = field_id_str
		self.precedence = 14

	def __str__(self):
		return '%s->%s' % (str_cvalue(self.left), self.field_id_str)


class CValueIndex(CValue):
	def __init__(self, left, index):
		assert(isinstance(left, CValue))
		assert(isinstance(index, CValue))
		super().__init__()
		self.left = left
		self.index = index
		self.precedence = 14

	def __str__(self):
		lstr = wrap_if(str_cvalue(self.left), self.left.precedence < self.precedence)
		return '%s[%s]' % (lstr, str_cvalue(self.index))


class CValueCast(CValue):
	def __init__(self, type, value):
		assert(isinstance(type, CType))
		assert(isinstance(value, CValue))
		super().__init__()
		self.type = type
		self.value = value
		self.precedence = 13

	def __str__(self):
		vstr = wrap_if(str_cvalue(self.value), self.value.precedence < self.precedence)
		return '(%s)%s' % (str_ctype(self.type), vstr)


class CValueRef(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		super().__init__()
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '&%s' % str_cvalue(self.value)


class CValueDeref(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		super().__init__()
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '*%s' % str_cvalue(self.value)


class CValueInc(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		super().__init__()
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '++%s' % (str_cvalue(self.value))


class CValueDec(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		super().__init__()
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '--%s%s' % (str_cvalue(self.value))


class CValuePositive(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		super().__init__()
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '+%s' % (str_cvalue(self.value))


class CValueNegative(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		super().__init__()
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '-%s' % (str_cvalue(self.value))


class CValueNotLogical(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		super().__init__()
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '!%s' % (str_cvalue(self.value))


class CValueNotBitwise(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		super().__init__()
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '~%s' % (str_cvalue(self.value))


class CValueSizeofValue(CValue):
	def __init__(self, ofvalue):
		assert(isinstance(ofvalue, CValue))
		super().__init__()
		self.ofvalue = ofvalue
		self.precedence = 13

	def __str__(self):
		return 'sizeof %s' % (str_cvalue(self.ofvalue))


class CValueSizeofType(CValue):
	def __init__(self, oftype):
		assert(isinstance(oftype, CType))
		super().__init__()
		self.oftype = oftype
		self.precedence = 13

	def __str__(self):
		return 'sizeof(%s)' % (str_ctype(self.oftype))


class CValueMul(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 12

	def __str__(self):
		return '%s * %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueDiv(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 12

	def __str__(self):
		return '%s / %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueRem(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 12

	def __str__(self):
		return '%s %% %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueAdd(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 11

	def __str__(self):
		return '%s + %s' % ((self.left), (self.right))


class CValueSub(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 11

	def __str__(self):
		return '%s - %s' % (str_cvalue(self.left), str_cvalue(self.right))

class CValueShl(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 10

	def __str__(self):
		return '%s << %s' % (str_cvalue(self.left), str_cvalue(self.right))

class CValueShr(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 10

	def __str__(self):
		return '%s >> %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueLt(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 9

	def __str__(self):
		return '%s < %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueGt(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 9

	def __str__(self):
		return '%s > %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueLE(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 9

	def __str__(self):
		return '%s <= %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueGE(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 9

	def __str__(self):
		return '%s >= %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueEq(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 8

	def __str__(self):
		return '%s == %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueNe(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 8

	def __str__(self):
		return '%s != %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueAndBitwise(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 7

	def __str__(self):
		return '%s & %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueXorBitwise(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 6

	def __str__(self):
		return '%s ^ %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueOrBitwise(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 5

	def __str__(self):
		return '%s | %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueAndLogical(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 4

	def __str__(self):
		return '%s && %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueOrLogical(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		super().__init__()
		self.left = left
		self.right = right
		self.precedence = 3

	def __str__(self):
		return '%s || %s' % (str_cvalue(self.left), str_cvalue(self.right))



class CValueVaStart(CValue):
	def __init__(self, va_list, last_param):
		assert(isinstance(va_list, CValue))
		assert(isinstance(last_param, CValue))
		super().__init__()
		self.va_list = va_list
		self.last_param = last_param
		self.precedence = 14

	def __str__(self):
		return 'va_start(%s, %s)' % (str_cvalue(self.va_list), str_cvalue(self.last_param))


class CValueVaArg(CValue):
	def __init__(self, va_list, xtype):
		assert(isinstance(va_list, CValue))
		assert(isinstance(xtype, CType))
		super().__init__()
		self.va_list = va_list
		self.xtype = xtype
		self.precedence = 14

	def __str__(self):
		return 'va_arg(%s, %s)' % (str_cvalue(self.va_list), str_ctype(self.xtype))


class CValueVaEnd(CValue):
	def __init__(self, va_list):
		assert(isinstance(va_list, CValue))
		super().__init__()
		self.va_list = va_list
		self.precedence = 14

	def __str__(self):
		return 'va_end(%s)' % (str_cvalue(self.va_list))


class CValueVaCopy(CValue):
	def __init__(self, va_dst, va_src):
		assert(isinstance(va_dst, CValue))
		assert(isinstance(va_src, CValue))
		super().__init__()
		self.va_dst = va_dst
		self.va_src = va_src
		self.precedence = 14

	def __str__(self):
		return 'va_copy(%s, %s)' % (str_cvalue(self.va_dst), str_cvalue(self.va_src))




def str_cvalue(v):
	assert(v != None)
	if v.mark != None:
		return '/*mark=%s*/' % v.mark + str(v)
	return str(v)




def str_cstmt(x):
	assert(x != None)
	sstr = ''
	#if x.comment != None:
	#	sstr += str_nl_indent(x.comment.nl)
	#	print_comment(x.comment)
	sstr += str_nl_indent(x.nl)
	sstr += str(x)
	return sstr


class CStmt():
	def __init__(self):
		self.comment = None
		self.nl = 1
		pass


class CStmtCommentLine(CStmt):
	def __init__(self, text):
		assert(isinstance(stmts, list))
		super().__init__()
		self.text = text


class CStmtCommentBlock(CStmt):
	def __init__(self, text):
		assert(isinstance(stmts, list))
		super().__init__()
		self.text = text


class CStmtBlock(CStmt):
	def __init__(self, stmts):
		assert(isinstance(stmts, list))
		super().__init__()
		self.nl = 0
		self.stmts = stmts

	def __str__(self):
		sstr = "{"
		nl_end_e = 1
		indent_up()
		for stmt in self.stmts:
			sstr += str_cstmt(stmt)
		indent_down()
		sstr += str_nl_indent(nl=nl_end_e)
		sstr += "}"
		return sstr


class CStmtValueExpr(CStmt):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		super().__init__()
		self.value = value

	def __str__(self):
		return "%s;" % str_cvalue(self.value)


class CStmtValueAssign(CStmt):
	def __init__(self, lvalue, rvalue):
		assert(isinstance(lvalue, CValue))
		assert(isinstance(rvalue, CValue))
		super().__init__()
		self.lvalue = lvalue
		self.rvalue = rvalue

	def __str__(self):
		return "%s = %s;" % (str_cvalue(self.lvalue), str_cvalue(self.rvalue))



class CStmtDeclType(CStmt):
	def __init__(self, type, annotations=None):
		assert(isinstance(type, CTypeNamed))
		super().__init__()
		self.type = type
		self.annotations = annotations

	def __str__(self):
		sstr = "/* do_decl_type_record */\n"
		sstr += str_gcc_attributes(self.annotations)
		sstr += str_ctype(self.type) + ';'
		return sstr


class CStmtDefType(CStmt):
	def __init__(self, id_str, type, annotations=None):
		assert(isinstance(id_str, str))
		assert(isinstance(type, CType))
		super().__init__()
		self.id_str = id_str
		self.type = type
		self.annotations = annotations

	def __str__(self):
		sstr = ''
		sstr += str_gcc_attributes(self.annotations)
		xv = CStmtDefVar(self.id_str, self.type)
		sstr += 'typedef %s' % str(xv)
		return sstr


class CStmtDefVar(CStmt):
	def __init__(self, id_str, type, init_value=None, storage_class='', annotations=None):
		assert(isinstance(id_str, str))
		assert(isinstance(type, CType))
		if init_value != None:
			assert(isinstance(init_value, CValue))
		super().__init__()
		self.id_str = id_str
		self.type = type
		self.storage = storage_class
		self.init_value = init_value
		self.annotations = annotations

	def __str__(self):
		sstr = ''
		sstr += str_gcc_attributes(self.annotations)
		if self.storage not in (None, ''):
			sstr += self.storage + ' '
		sstr += self.type.to_str(text=self.id_str)
		if self.init_value != None:
			sstr += ' = %s' % str_cvalue(self.init_value)
		return sstr + ';'



class CStmtDefFunc(CStmt):
	def __init__(self, id_str, type, block, storage_class='', annotations=None):
		assert(isinstance(id_str, str))
		assert(isinstance(type, CType))
		assert(isinstance(block, CStmtBlock))
		#if init_value != None:
		#	assert(isinstance(init_value, CValue))
		super().__init__()
		self.id_str = id_str
		self.type = type
		self.storage = storage_class
		self.block = block
		self.annotations = annotations

	def __str__(self):
		sstr = ''
		sstr += str_gcc_attributes(self.annotations)
		if self.storage not in (None, ''):
			sstr += self.storage + ' '
		sstr += self.type.to_str(text=self.id_str)
		sstr += str_cstmt(self.block)
		return sstr



class CStmtIf(CStmt):
	def __init__(self, value_cond, block_then, block_else):
		assert(isinstance(value_cond, CValue))
		assert(isinstance(block_then, CStmtBlock))
		if block_else:
			assert(isinstance(block_else, CStmtBlock))
		super().__init__()
		self.value_cond = value_cond
		self.block_then = block_then
		self.block_else = block_else

	def __str__(self):
		sstr = "if (%s)" % str_cvalue(self.value_cond)
		sstr += str(self.block_then)
		if self.block_else != None:
			sstr += ' else '
			sstr += str(self.block_then)
		return sstr


class CStmtWhile(CStmt):
	def __init__(self, value_cond, block):
		assert(isinstance(value_cond, CValue))
		assert(isinstance(block, CStmtBlock))
		super().__init__()
		self.value_cond = value_cond
		self.block = block


class CStmtReturn(CStmt):
	def __init__(self, value_retval):
		if value_retval != None:
			assert(isinstance(value_retval, CValue))
		super().__init__()
		self.value_retval = value_retval

	def __str__(self):
		if self.value_retval != None:
			return "return %s;" % str_cvalue(self.value_retval)
		return "return;"


class CStmtBreak(CStmt):
	def __init__(self):
		super().__init__()
		pass

	def __str__(self):
		return "break;"


class CStmtContinue(CStmt):
	def __init__(self):
		super().__init__()
		pass

	def __str__(self):
		return "continue;"


class CMacrodefinition():
	def __init__(self, id, text=None):
		assert(isinstance(id, str))
		if text:
			assert(isinstance(text, str))
		self.nl = 1  #!!! (because it is not CStmt...)
		super().__init__()
		self.id = id
		self.text = text

	def __str__(self):
		if self.text:
			return "#define %s %s" % (self.id, self.text)
		return "#define %s %s" % (self.id)


class CInclude():
	def __init__(self, text, isglobal):
		assert(isinstance(text, str))
		assert(isinstance(isglobal, bool))
		self.nl = 1  #!!! (because it is not CStmt...)
		super().__init__()
		self.text = text
		self.isglobal = isglobal

	def __str__(self):
		if self.isglobal:
			return "\n#include <%s>" % self.text
		return "\n#include \"%s\"" % self.text


