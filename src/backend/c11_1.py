



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
		self.priority = 0

	def to_str(self, text):
		# "const int a"
		return str_specs(self.specs) + self.id_str + with_space(text)

	def __str__(self):
		return self.to_str(text='')


class CTypePointer(CType):
	def __init__(self, to, specs=None):
		self.to = to
		self.specs = specs if specs != None else []
		self.priority = 1

	def to_str(self, text):
		# "*volatile p"
		text = '*%s' % str_specs(self.specs) + text
		text = wrap_if(text, self.to.priority > self.priority)
		text = str_ctype(self.to, text)
		return text

	def __str__(self):
		return self.to_str(text='')


class CTypeArray(CType):
	def __init__(self, of, volume=None, specs=None):
		self.of = of
		self.volume = volume
		self.specs = specs if specs != None else []
		self.priority = 2

	def to_str(self, text):
		text = text + '['
		if self.volume != None and not self.volume.isValueUndef():
			from .c11 import str_value
			text += str_value(self.volume)
		text += ']'
		text = wrap_if(text, self.of.priority > self.priority)
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
		self.priority = 3

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
		self.priority = 0

	def to_str(self, text):
		nl_end = 0
		sstr = '%s {' % (self.tag)
		from .c11 import indent_up, indent_down, str_nl_indent
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




class CValueNamed():
	def __init__(self, id_str):
		self.id_str = id_str
		self.priority = 0

class CValueNumber():
	def __init__(self, number):
		self.number = number
		self.priority = 0

class CValueString():
	def __init__(self, string):
		self.string = string
		self.priority = 0


class CValueUnary():
	def __init__(self, op, value):
		self.op = op
		self.value = value
		self.priority = 0

class CValueBinary():
	def __init__(self, op, left, right):
		self.op = op
		self.left = left
		self.right = right
		self.priority = 0

class CValueCall():
	def __init__(self, left, args):
		self.left = left
		self.args = args
		self.priority = 0

class CValueAccess():
	def __init__(self, left, field_id_str):
		self.left = left
		self.field_id_str = field_id_str
		self.priority = 0

class CValueAccessPtr():
	def __init__(self, left, field_id_str):
		self.left = left
		self.field_id_str = field_id_str
		self.priority = 0

class CValueIndex():
	def __init__(self, left, index):
		self.left = left
		self.index = index
		self.priority = 0

class CValueRef():
	def __init__(self, value):
		self.value = value
		self.priority = 0

class CValueDeref():
	def __init__(self, value):
		self.value = value
		self.priority = 0


def str_cvalue_named(v):
	return v.id_str

def str_cvalue_number(v):
	return str(v.number)

def str_cvalue_string(v):
	return '"%s"' % v.string

def str_cvalue_cast(v):
	return '(%s)%s' % (str_ctype(v.type), str_cvalue(v.value))

def str_cvalue_unary(v):
	return '%s%s' % (op, str_cvalue(v.value))

def str_cvalue_binary(v):
	return '%s %s %s' % (str_cvalue(v.left), op, str_cvalue(v.right))

def str_cvalue_call(v):
	sstr = str_cvalue(v.left)
	sstr += '('
	i = 0
	while i < len(v.args):
		arg = v.args[i]
		if i > 0:
			out(", ")
		sstr += str_cvalue(arg)
		i = i + 1
	sstr += ')'
	return sstr

def str_cvalue_access(v):
	return '%s.%s' % (str_cvalue(v.left), v.field_id_str)

def str_cvalue_access_ptr(v):
	return '%s->%s' % (str_cvalue(v.left), v.field_id_str)

def str_cvalue_index(v):
	return '%s[%s]' % (str_cvalue(v.left), str_cvalue(v.index))

def str_cvalue_ref(v):
	return '&%s' % str_cvalue(v.value)

def str_cvalue_deref(v):
	return '*%s' % str_cvalue(v.value)


def str_cvalue(v):
	if isinstance(v, CValueNamed): return str_cvalue_named(v)
	if isinstance(v, CValueNumber): return str_cvalue_number(v)
	if isinstance(v, CValueString): return str_cvalue_string(v)
	if isinstance(v, CValueUnary): return str_cvalue_unary(v)
	if isinstance(v, CValueBinary): return str_cvalue_binary(v)
	if isinstance(v, CValueCall): return str_cvalue_call(v)
	if isinstance(v, CValueAccess): return str_cvalue_access(v)
	if isinstance(v, CValueAccessPtr): return str_cvalue_access_ptr(v)
	if isinstance(v, CValueIndex): return str_cvalue_index(v)
	if isinstance(v, CValueRef): return str_cvalue_ref(v)
	if isinstance(v, CValueDeef): return str_cvalue_deref(v)



