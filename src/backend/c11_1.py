



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
		self.of = of
		self.volume = volume
		self.specs = specs if specs != None else []
		self.precedence = 2

	def to_str(self, text):
		text = text + '['
		if self.volume != None and not self.volume.isValueUndef():
			from .c12 import str_value
			text += str_value(self.volume)
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
		from .c12 import indent_up, indent_down, str_nl_indent
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


def str_kv(x):
	sstr = ''

	return sstr


def string_literal_prefix(width):
	if width > 16: return "U"
	if width > 8: return "u"
	return ""



class CValue():
	def __init__(self):
		pass


class CValueNamed(CValue):
	def __init__(self, id_str):
		self.id_str = id_str
		self.precedence = 15

	def __str__(self):
		return self.id_str


class CValueNumber(CValue):
	def __init__(self, number):
		self.number = number
		self.precedence = 15

	def __str__(self):
		return str(self.number)



class CValueString(CValue):
	def __init__(self, string, width):
		assert(isinstance(string, str))
		self.string = string
		self.width = width
		self.precedence = 15

	def __str__(self):
		return '%s"%s"' % (string_literal_prefix(self.width), self.string)


class CValueChar(CValue):
	def __init__(self, char, width=8):
		assert(isinstance(char, str))
		self.char = char
		self.width = width
		self.precedence = 15

	def __str__(self):
		return "%s'%s'" % (string_literal_prefix(self.width), self.char)



class CValueArray(CValue):
	def __init__(self, items):
		self.items = items
		self.precedence = 15

	def __str__(self):
		return '{' + print_list_items(self.items, str_cvalue) + '}'


class CValueStruct(CValue):
	def __init__(self, items):
		self.items = items
		self.precedence = 15

	def __str__(self):
		return '{}' #+ print_list_items(self.items, str_kv) + '}'





class CValueSubexpr(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		self.value = value
		self.precedence = 15

	def __str__(self):
		return '(%s)' % str_cvalue(self.value)



class CValueCall(CValue):
	def __init__(self, left, args):
		assert(isinstance(left, CValue))
		assert(isinstance(args, list))
		self.left = left
		self.args = args
		self.precedence = 14

	def __str__(self):
		sstr = str_cvalue(self.left)
		sstr += '(' + print_list_items(self.args, str_cvalue) + ')'
		return sstr


class CValueAccess(CValue):
	def __init__(self, left, field_id_str):
		assert(isinstance(field_id_str, str))
		assert(isinstance(left, CValue))
		self.left = left
		self.field_id_str = field_id_str
		self.precedence = 14

	def __str__(self):
		return '%s.%s' % (str_cvalue(self.left), self.field_id_str)


class CValueAccessPtr(CValue):
	def __init__(self, left, field_id_str):
		assert(isinstance(field_id_str, str))
		assert(isinstance(left, CValue))
		self.left = left
		self.field_id_str = field_id_str
		self.precedence = 14

	def __str__(self):
		return '%s->%s' % (str_cvalue(self.left), self.field_id_str)


class CValueIndex(CValue):
	def __init__(self, left, index):
		assert(isinstance(left, CValue))
		assert(isinstance(index, CValue))
		self.left = left
		self.index = index
		self.precedence = 14

	def __str__(self):
		return '%s[%s]' % (str_cvalue(self.left), str_cvalue(self.index))


class CValueCast(CValue):
	def __init__(self, type, value):
		assert(isinstance(type, CType))
		assert(isinstance(value, CValue))
		self.type = type
		self.value = value
		self.precedence = 13

	def __str__(self):
		vstr = wrap_if(str(self.value), self.value.precedence < self.precedence)
		return '(%s)%s' % (str_ctype(self.type), vstr)


class CValueRef(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '&%s' % str_cvalue(self.value)


class CValueDeref(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '*%s' % str_cvalue(self.value)


class CValueInc(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '++%s' % (str_cvalue(self.value))


class CValueDec(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '--%s%s' % (str_cvalue(self.value))


class CValuePositive(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '+%s' % (str_cvalue(self.value))


class CValueNegative(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '-%s' % (str_cvalue(self.value))


class CValueNotLogical(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '!%s' % (str_cvalue(self.value))


class CValueNotBitwise(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		self.value = value
		self.precedence = 13

	def __str__(self):
		return '~%s' % (str_cvalue(self.value))


class CValueSizeof(CValue):
	def __init__(self, value):
		assert(isinstance(value, CValue))
		self.value = value
		self.precedence = 13

	def __str__(self):
		return 'sizeof(%s)' % (str_cvalue(self.value))


class CValueMul(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 12

	def __str__(self):
		return '%s * %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueDiv(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 12

	def __str__(self):
		return '%s / %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueRem(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 12

	def __str__(self):
		return '%s %% %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueAdd(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 11

	def __str__(self):
		return '%s + %s' % ((self.left), (self.right))


class CValueSub(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 11

	def __str__(self):
		return '%s - %s' % (str_cvalue(self.left), str_cvalue(self.right))

class CValueShl(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 10

	def __str__(self):
		return '%s << %s' % (str_cvalue(self.left), str_cvalue(self.right))

class CValueShr(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 10

	def __str__(self):
		return '%s >> %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueLt(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 9

	def __str__(self):
		return '%s < %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueGt(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 9

	def __str__(self):
		return '%s > %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueLE(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 9

	def __str__(self):
		return '%s <= %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueGE(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 9

	def __str__(self):
		return '%s >= %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueEq(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 8

	def __str__(self):
		return '%s == %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueNe(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 8

	def __str__(self):
		return '%s != %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueAndBitwise(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 7

	def __str__(self):
		return '%s & %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueXorBitwise(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 6

	def __str__(self):
		return '%s ^ %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueOrBitwise(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 5

	def __str__(self):
		return '%s | %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueAndLogical(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 4

	def __str__(self):
		return '%s && %s' % (str_cvalue(self.left), str_cvalue(self.right))


class CValueOrLogical(CValue):
	def __init__(self, left, right):
		assert(isinstance(left, CValue))
		assert(isinstance(right, CValue))
		self.left = left
		self.right = right
		self.precedence = 3

	def __str__(self):
		return '%s || %s' % (str_cvalue(self.left), str_cvalue(self.right))




def str_cvalue(v):
	return str(v)





