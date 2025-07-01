######################################################################
#                            HLIR TYPE                               #
######################################################################

import copy
from common import settings
from util import get_item_by_id, align_bits_up, nbits_for_num, nbytes_for_bits, align_to

from .entity import Entity
from hlir.value import Value

CONS_OP = ('cons',)
EQ_OPS = ('eq', 'ne')
RELATIONAL_OPS = ('lt', 'gt', 'le', 'ge')
ARITHMETICAL_OPS = ('add', 'sub', 'mul', 'div', 'rem', 'neg', 'pos')
LOGICAL_OPS = ('or', 'xor', 'and', 'not')
BITWISE_OPS = LOGICAL_OPS #+ ('shl', 'shr') -

UNIT_OPS = CONS_OP
WORD_OPS = CONS_OP + EQ_OPS + BITWISE_OPS
INT_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS
FLOAT_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS
BOOL_OPS = CONS_OP + EQ_OPS + LOGICAL_OPS
CHAR_OPS = CONS_OP + EQ_OPS
ENUM_OPS = CONS_OP + EQ_OPS
PTR_OPS = CONS_OP + EQ_OPS + ('deref',)
ARR_OPS = CONS_OP + EQ_OPS + ('add', 'index')
REC_OPS = CONS_OP + EQ_OPS + ('access',)
STR_OPS = CONS_OP + EQ_OPS + ('add',)
NUM_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS + LOGICAL_OPS



class Type(Entity):
	def __init__(self, generic=False, width=0, ops=[], ti=None):
		super().__init__(ti)
		size = nbytes_for_bits(width)
		align = 1
		if size > 0:
			align = size
		self.generic = generic
		self.width = width
		self.size = size
		self.align = align
		self.ops = ops
		self.att = []
		self.deps = []
		self.signed = None  # Not defined for all types (!)
		self.ti = None
		self.incomplete = True
		self.definition = None

		# особое поле - если оно ненулевое значит это distinct тип
		# такие типы будут признаны неравными если их поля dictinct отличны
		# 0 - зарезервирован для не distinct типов (см. @distinct аттрибут)
		self.brand = 0
		pass


	def is_bad(self):
		return isinstance(self, TypeBad)

	def supports(self, operation):
		if self.is_bad():
			return True
		return operation in self.ops


	# TypeFunc бывает incomplete
	# то есть все что известно - что это функция,
	# а больше никакой конкретики
	def is_incompleted(self):
		return self.incomplete

	def is_generic(self):
		return self.generic

	def is_distinct(self):
		return self.brand != 0


	def is_unit(self):
		return isinstance(self, TypeUnit)


	def is_bool(self):
		return isinstance(self, TypeBool)


	# Special type for StringLiteral (!)
	def is_string(self):
		return isinstance(self, TypeString)


	def is_num(self):
		return isinstance(self, TypeNumber)


	def is_record(self):
		return isinstance(self, TypeRecord)


	def is_array(self):
		return isinstance(self, TypeArray)


	def is_word(self):
		return isinstance(self, TypeWord)


	def is_int(self):
		return isinstance(self, TypeInt)


	def is_nat(self):
		return isinstance(self, TypeNat)


	def is_arithmetical(self):
		return self.is_int() or self.is_nat()

	# word, nat, int
	def is_xword(self):
		return self.is_word() or self.is_int() or self.is_nat()


	def is_float(self):
		return isinstance(self, TypeFloat)


	def is_char(self):
		return isinstance(self, TypeChar)


	# numeric type supports arithmetical operations
	def is_numeric(self):
		return isinstance(self, TypeInt) or isinstance(self, TypeNumber) or isinstance(self, TypeFloat)


	def is_number(self):
		return isinstance(self, TypeNumber)


	def is_func(self):
		return isinstance(self, TypeFunc)



	# (this) type is VLA - variable langth array
	# [n]Int32 -> True, [][n]Int32 -> False
	def is_vla(self):
		if not self.is_array():
			return False
		if self.volume.isUndef():
			return False
		return self.volume.isRuntimeValue()


	# *[10]*[3]*[n] -> True
	def contains_vla(self):
		if self.is_vla():
			return True
		elif self.is_array():
			return self.of.contains_vla()
		elif self.is_pointer():
			return self.to.contains_vla()
		return False



	def is_scalar_type(t):
		return t.is_word() or t.is_int() or t.is_nat() or t.is_char() or t.is_num()


	def is_composite(self):
		return self.is_array() or self.is_record()

	def is_simple(self):
		return not (self.is_composite() or self.is_func() or self.is_pointer())

	def is_nil(self):
		return False
		#return isinstance(self, TypeNil)

	def is_pointer(self):
		return isinstance(self, TypePointer)


	def is_va_list(self):
		return isinstance(self, TypeVaList)

	def is_generic_int(self):
		return self.is_int() and self.is_generic()

	def is_generic_nat(self):
		return self.is_nat() and self.is_generic()

	def is_generic_word(self):
		return self.is_word() and self.is_generic()


	def is_generic_char(self):
		return self.is_char() and self.is_generic()


	def is_generic_record(self):
		return self.is_record() and self.is_generic()


	def is_generic_array(self):
		return self.is_array() and self.is_generic()


	def is_generic_array_of_char(self):
		if self.is_generic_array():
			if t.of != None: # in case of empty array field #of can be None
				return self.of.is_char()

		return False



	def is_closed_array(self):
		if self.is_array():
			return not self.volume.isUndef()
		return False


	def is_open_array(self):
		if self.is_array():
			return self.volume.isUndef()
		return False


	def is_array_of_char(self):
		if self.is_array():
			return self.of.is_char()
		return False


	def is_array_of_array(self):
		if self.is_array():
			return self.of.is_array()
		return False

	# [10][]Int32, [][]Int32, [][][]Int64, etc..
	def is_array_of_open_array(self):
		if not self.is_array():
			return False
		return self.of.is_open_array()


	def is_generic_pointer(self):
		if self.is_generic():
			return self.is_pointer()
		return False


	def is_free_pointer(self):
		if self.is_pointer():
			return self.to.is_unit()
		return False


	def is_pointer_to_record(self):
		if self.is_pointer():
			return self.to.is_record()
		return False


	def is_pointer_to_array(self):
		if self.is_pointer():
			return self.to.is_array()
		return False


	# array of char not always is Str (!) (z-string) see is_str
	def is_pointer_to_str(self):
		if self.is_pointer():
			return self.to.is_array_of_char()
		return False


	# type is array of chars (see is_string() for literals)
	def is_str(self):
		if self.is_array_of_char():
			return 'z-string' in self.att
		return False


	def is_pointer_to_zstr(self):
		if self.is_pointer():
			return self.to.is_str()
		return False


	def is_pointer_to_func(self):
		if self.is_pointer():
			return self.to.is_func()
		return False


	def is_pointer_to_open_array(self):
		if self.is_pointer():
			return self.to.is_open_array()
		return False


	def is_pointer_to_closed_array(self):
		if self.is_pointer():
			return self.to.is_closed_array()
		return False


	def is_signed(self):
		return self.signed == True


	def is_unsigned(self):
		return self.signed == False


	# returns root type of any array
	# ex: *[n][m][10]Int32  -> Int32
	def get_array_root(self):
		if self.is_array():
			return self.of.get_array_root()
		return self


	def is_anonymous(self):
		return not hasattr(self, "id")


	@staticmethod
	def eq_integer(a, b, opt):
		return a.width == b.width

	@staticmethod
	def eq_natural(a, b, opt):
		return a.width == b.width

	@staticmethod
	def eq_char(a, b, opt):
		return a.width == b.width

	@staticmethod
	def eq_word(a, b, opt):
		return a.width == b.width

	@staticmethod
	def eq_pointer(a, b, opt):
		return Type.eq(a.to, b.to, opt)

	@staticmethod
	def eq_array(a, b, opt):
		if a.volume.isUndef() or b.volume.isUndef():
			if a.volume.isUndef() and b.volume.isUndef():
				return Type.eq(a.of, b.of, opt)
			return False

		# a.volume & b.volume defined

		if a.volume.isImmediate() and b.volume.isImmediate():
			if a.volume.asset != b.volume.asset:
				return False

		if a.of == None and b.of == None:
			return True

		return Type.eq(a.of, b.of, opt)

	@staticmethod
	def eq_func(a, b, opt):
		if not Type.eq(a.to, b.to, opt):
			return False
		return Type.eq_fields(a.params, b.params, opt)

	@staticmethod
	def eq_fields(a, b, opt):
		if len(a) != len(b):
			return False

		for ax, bx in zip(a, b):
			if ax.id.str != bx.id.str:
				return False

			# (infinity recursion protection)
			if id(ax.type) == id(bx.type):
				return True

			if not Type.eq(ax.type, bx.type, opt):
				return False

		return True

	@staticmethod
	def eq_record(a, b, opt):
		if len(a.fields) != len(b.fields):
			return False
		return Type.eq_fields(a.fields, b.fields, opt)

	@staticmethod
	def eq_enum(a, b, opt):
		return id(a) == id(b)

	@staticmethod
	def eq_float(a, b, opt):
		return a.width == b.width


	@staticmethod
	def eq(a, b, opt=[]):
		assert a != None
		assert b != None
		if id(a) == id(b):
			return True

		if a.is_bad() or b.is_bad():
			return True

		if a.__class__.__name__ != b.__class__.__name__:
			return False

		if a.brand != b.brand:
			return False

		# проверять аттрибуты (volatile, const)
		# использую для C чтобы можно было более строго проверить типы
		# напр для явного приведения в беканде C *volatile uint32_t -> uint32_t
		if 'att_checking' in opt:
			if a.att != b.att:
				return False

		# дженерик и не дженерик типы не равны
		# это важно для конструирования записей из джененрков
		# (в противном случае конструирование будет скипнуто тк они типа уже равны)
		if a.is_generic() != b.is_generic():
			return False

		# usual checking
		if isinstance(a, TypeInt): return Type.eq_integer(a, b, opt)
		elif isinstance(a, TypeNat): return Type.eq_natural(a, b, opt)
		elif isinstance(a, TypeBool): return True
		elif isinstance(a, TypeNumber): return True
		elif isinstance(a, TypeFunc): return Type.eq_func(a, b, opt)
		elif isinstance(a, TypeRecord): return Type.eq_record(a, b, opt)
		elif isinstance(a, TypeArray): return Type.eq_array(a, b, opt)
		elif isinstance(a, TypePointer): return Type.eq_pointer(a, b, opt)
		elif isinstance(a, TypeChar): return Type.eq_char(a, b, opt)
		elif isinstance(a, TypeWord): return Type.eq_word(a, b, opt)
		elif isinstance(a, TypeFloat): return Type.eq_float(a, b, opt)
		elif isinstance(a, TypeString): return True
		elif isinstance(a, TypeUnit): return True
		elif isinstance(a, TypeVaList): return True
		assert(False)
		return False


	def copy(self):
		y = copy.copy(self)
		y.att = []
		return y


	@staticmethod
	def update(dst, src):
		# Это даже как то работает, ок, пока сойдет
		dst.__dict__.clear()
		dst.__dict__.update(src.__dict__)
		dst.att = copy.copy(src.att)
		dst.__class__ = src.__class__


	# cannot create variable with type
	def is_forbidden_var(self, zero_array_forbidden=True):
		t = self
		if t.is_incompleted() or t.is_unit() or t.is_func():
			return True

		if t.is_array():
			# [_]<Forbidden>
			if t.of.is_forbidden_var():
				return True

			# []Int
			if t.is_open_array():
				return True

			# [0]Int
			from trans import is_unsafe_mode
			if zero_array_forbidden or not is_unsafe_mode():
				if t.volume.isImmediate():
					if t.volume.asset == 0:
						return True

			return t.of.is_forbidden_var()

		return False



class TypeBad(Type):
	def __init__(self, ti=None):
		super().__init__(ti=ti)
		self.incomplete = False


class TypeNumber(Type):
	def __init__(self, width=0, signed=False, ti=None):
		super().__init__(generic=True, width=width, ops=NUM_OPS, ti=ti)
		self.incomplete = False
		from .misc import Id
		self.id = Id(None)
		self.signed=signed
		pass


class TypeString(Type):
	def __init__(self, char_width, length, ti=None):
		width = char_width
		size = nbytes_for_bits(width)
		super().__init__(width=width, generic=True, ops=STR_OPS, ti=ti)
		self.incomplete = False
		self.size=size
		self.char_width=char_width
		self.length=length
		pass


class TypeUnit(Type):
	def __init__(self, ti=None):
		super().__init__(ops=UNIT_OPS, ti=ti)
		from .misc import Id
		self.incomplete = False
		self.id = Id().fromStr('Unit')
		self.id.c = 'void'
		self.id.llvm = 'void'


class TypeBool(Type):
	def __init__(self, ti=None):
		super().__init__(width=1, ops=BOOL_OPS, ti=ti)
		from .misc import Id
		self.incomplete = False
		self.id = Id().fromStr('Bool')
		self.id.c = 'bool'
		self.id.llvm = 'Bool'


class TypeWord(Type):
	def __init__(self, width, ti=None):
		width = align_bits_up(width)

		super().__init__(width=width, ops=WORD_OPS, ti=ti)
		self.incomplete = False

		calias = None
		llvm_alias = None

		if width == 128:
			calias = 'unsigned __int128'
		else:
			calias = 'uint%d_t' % width

		llvm_alias = 'Word%d' % width
		#if width in [8, 16, 32, 64, 128]:
		#	llvm_alias = 'Word%d' % width
		#else:
		#	llvm_alias = 'i%d' % width

		from .misc import Id
		self.id = Id().fromStr('Word%d' % width)
		self.id.c = calias
		self.id.llvm = llvm_alias


class TypeInt(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=INT_OPS, ti=ti)
		self.incomplete = False

		alias = get_int_alias(width, signed=True)

		from .misc import Id
		self.id = Id().fromStr(alias['cm'])
		self.id.c = alias['c']
		self.id.llvm = alias['llvm']
		self.signed = True


class TypeNat(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=INT_OPS, ti=ti)
		self.incomplete = False

		alias = get_int_alias(width, signed=False)

		from .misc import Id
		self.id = Id().fromStr(alias['cm'])
		self.id.c = alias['c']
		self.id.llvm = alias['llvm']
		self.signed = False


class TypeFloat(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=FLOAT_OPS, ti=ti)
		self.incomplete = False

		calias = 'float'
		if width > 32:
			calias = 'double'

		alias = get_int_alias(width, signed=True)

		from .misc import Id
		self.id = Id().fromStr('Float%d' % width)
		self.id.c = calias
		self.id.llvm = 'Float%d' % width


class TypeChar(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=CHAR_OPS, ti=ti)
		self.incomplete = False

		alias = get_int_alias(width, signed=False)

		from .misc import Id
		self.id = Id().fromStr('Char%d' % width)
		if width <= 8:
			self.id.c = 'char'
		else:
			self.id.c = 'uint%d_t' % width
		self.id.llvm = 'Char%d' % width


class TypePointer(Type):
	def __init__(self, to, generic=False, ti=None):
		w = int(settings['pointer_width'])
		super().__init__(width=w, generic=generic, ops=PTR_OPS, ti=ti)
		self.incomplete = False
		self.to = to


class TypeArray(Type):
	def __init__(self, of, volume, generic=False, ti=None):
		item_size = 0
		item_align = 0
		if of != None:
			item_size = of.size
			item_align = of.align

		array_size = 0
		if volume != None:
			if volume.immediate:
				array_size = item_size * volume.asset

		super().__init__(generic=generic, ops=ARR_OPS, ti=ti)
		self.incomplete = False
		self.size=array_size
		self.of = of
		self.volume = volume
		self.size = array_size


class TypeRecord(Type):
	def __init__(self, fields, generic=False, ti=None):
		field_no = 0
		offset = 0
		record_align = 1

		for field in fields:
			field.field_no = field_no
			field_no = field_no + 1

			field_size = field.type.size
			field_align = field.type.align

			# смещение поля должно быть выровнено
			# по требуемому для него шагу выравнивания
			offset = align_to(offset, field_align)
			field.offset = offset
			offset = offset + field_size

			# выравнивание структуры - макс выравнивание в ней
			record_align = max(record_align, field_align)

		# Afterall we need to align record_size to record_align (!)
		record_size = align_to(offset, record_align)

		super().__init__(generic=generic, width=(record_size * 8), ops=REC_OPS, ti=ti)
		self.incomplete = False
		self.fields = fields


class TypeFunc(Type):
	def __init__(self, params, to, va_args, ti=None):
		w = int(settings['pointer_width'])
		super().__init__(width=w, ops=PTR_OPS, ti=ti)
		self.incomplete = False
		self.params = params
		self.to = to
		self.extra_args = va_args


class TypeVaList(Type):
	def __init__(self):
		super().__init__(width=0, ti=None)
		from .misc import Id
		self.incomplete = False
		self.id = Id().fromStr('va_list')
		self.id.c = 'va_list'
		self.id.llvm = '__VA_List'


def get_int_alias(width, signed):
	width = align_bits_up(width)

	if signed:
		aka = 'Int%d' % width

		if width == 128:
			calias = '__int128'
		else:
			calias = 'int%d_t' % width

		llvm_alias = 'Int%d' % width

	else:
		aka = 'Nat%d' % width
		if width == 128:
			calias = 'unsigned __int128'
		else:
			calias = 'uint%d_t' % width

		llvm_alias = 'Nat%d' % width

	return {'c': calias, 'llvm': llvm_alias, 'cm': aka}
