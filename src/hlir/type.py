######################################################################
#                            HLIR TYPE                               #
######################################################################

import settings
from util import get_item_by_id, nbits_for_num, nbytes_for_bits, align_bits_up, align_to

from .entity import Entity

CONS_OP = ('cons',)
EQ_OPS = ('eq', 'ne')
RELATIONAL_OPS = ('lt', 'gt', 'le', 'ge')
ARITHMETICAL_OPS = ('add', 'sub', 'mul', 'div', 'rem', 'neg', 'pos')
LOGICAL_OPS = ('or', 'xor', 'and', 'not')

UNIT_OPS = CONS_OP
WORD_OPS = CONS_OP + EQ_OPS + LOGICAL_OPS
INT_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS + LOGICAL_OPS
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
		pass


	def supports(self, operation):
		return operation in self.ops





class TypeBad(Type):
	def __init__(self, ti=None):
		super().__init__(ti=ti)


class TypeUndefined(Type):
	def __init__(self, ti=None):
		super().__init__(ti=ti)


class TypeNumber(Type):
	def __init__(self, width=0, signed=False, ti=None):
		super().__init__(generic=True, width=width, ops=NUM_OPS, ti=ti)
		from .misc import Id
		self.id = Id(None)
		self.signed=signed
		pass


class TypeString(Type):
	def __init__(self, char_width, length, ti=None):
		width = char_width
		size = nbytes_for_bits(width)
		super().__init__(width=width, generic=True, ops=STR_OPS, ti=ti)
		self.size=size
		self.char_width=char_width
		self.length=length
		pass



class TypeUnit(Type):
	def __init__(self, ti=None):
		super().__init__(ops=UNIT_OPS, ti=ti)
		from .misc import Id
		self.id = Id().fromStr('Unit')
		self.id.c = 'void'
		self.id.llvm = 'void'



class TypeBool(Type):
	def __init__(self, ti=None):
		super().__init__(width=1, ops=BOOL_OPS, ti=ti)
		from .misc import Id
		self.id = Id().fromStr('Bool')
		self.id.c = 'bool'
		self.id.llvm = '%Bool'



class TypeWord(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=WORD_OPS, ti=ti)

		calias = None
		llvm_alias = None

		if width == 128:
			calias = 'unsigned __int128'
		else:
			calias = 'uint%d_t' % width

		if width in [8, 16, 32, 64, 128]:
			llvm_alias = '%%Word%d' % width
		else:
			llvm_alias = 'i%d' % width

		from .misc import Id
		self.id = Id().fromStr('Word%d' % width)
		self.id.c = calias
		self.id.llvm = llvm_alias



class TypeInt(Type):
	def __init__(self, width, signed=True, ti=None):
		super().__init__(width=width, ops=INT_OPS, ti=ti)

		alias = get_int_alias(width, signed)

		from .misc import Id
		self.id = Id().fromStr(alias['cm'])
		self.id.c = alias['c']
		self.id.llvm = alias['llvm']

		self.signed = signed


class TypeFloat(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=FLOAT_OPS, ti=ti)

		calias = 'float'
		if width > 32:
			calias = 'double'

		alias = get_int_alias(width, signed=True)

		from .misc import Id
		self.id = Id().fromStr('Float%d' % width)
		self.id.c = calias
		self.id.llvm = calias



class TypeChar(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=CHAR_OPS, ti=ti)

		alias = get_int_alias(width, signed=False)

		from .misc import Id
		self.id = Id().fromStr('Char%d' % width)
		if width<=8:
			self.id.c = 'char'
		else:
			self.id.c = 'uint%d_t' % width
		self.id.llvm = '%%Char%d' % width



class TypePointer(Type):
	def __init__(self, to, generic=False, ti=None):
		w = int(settings.get('pointer_width'))
		super().__init__(width=w, generic=generic, ops=PTR_OPS, ti=ti)
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
		self.fields = fields


class TypeFunc(Type):
	def __init__(self, params, to, va_args, ti=None):
		w = int(settings.get('pointer_width'))
		super().__init__(width=w, ops=PTR_OPS, ti=ti)
		self.params = params
		self.to = to
		self.extra_args = va_args


class TypeVaList(Type):
	def __init__(self):
		super().__init__(width=0, ti=None)
		from .misc import Id
		self.id = Id().fromStr('va_list')
		self.id.c = 'va_list'
		self.id.llvm = 'i8*'



def get_int_alias(width, signed):
	if signed:
		aka = 'Int%d' % width

		if width == 128:
			calias = '__int128'
		else:
			calias = 'int%d_t' % width

		if width in [8, 16, 32, 64, 128]:
			llvm_alias = '%%Int%d' % width
		else:
			llvm_alias = 'i%d' % width

	else:
		aka = 'Nat%d' % width
		if width == 128:
			calias = 'unsigned __int128'
		else:
			calias = 'uint%d_t' % width

		if width in [8, 16, 32, 64, 128]:
			llvm_alias = '%%Int%d' % width
		else:
			llvm_alias = 'i%d' % width
	return {'c': calias, 'llvm': llvm_alias, 'cm': aka}
