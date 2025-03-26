#######################################################################
#                             HLIR VALUE                              #
#######################################################################

from error import info
from .entity import Entity
from .misc import Id, Field


class Value(Entity):
	def __init__(self, type, ti=None):
		super().__init__(ti)
		self.id = None
		self.type = type

		self.immediate = False

		#
		self.is_lvalue = False

		# immutable anyway flag
		self.immutable = False

		# (!) items can be not only in #immediate value (!)
		self.items = None
		self.asset = None

		self.nl = 0
		# Нужен для возможного переноса строки
		# перед закрытием скобки композитного литерала
		self.nl_end = 0


	def isLvalue(self):
		return self.is_lvalue

	def isImmediate(self):
		return self.immediate

	def isRuntime(self):
		return not self.isImmediate()

	def isZero(self):
		if self.isImmediate():
			if self.type.is_composite():
				return self.items == []
			else:
				return self.asset == 0

			#return (self.asset == 0 or self.asset == None) and (self.items == None or self.items == [])
		return False


	def isImmutable(self):
		# ONLY lvalue CAN be an immutable value,
		# BUT if immutable flag is set, it is immutable value anyway
		return (not self.isLvalue()) or self.immutable



	def isBad(self):
		return isinstance(self, ValueBad)


	#@staticmethod
	def isUndefined(self):
		return isinstance(self, ValueUndefined)

	def isLiteral(self):
		return isinstance(self, ValueLiteral)

	def isConst(self):
		return isinstance(self, ValueConst)

	def isVar(self):
		return isinstance(self, ValueVar)


	# op = 'eq' | 'ne
	@staticmethod
	def eq(l, r, op, ti):
		assert(isinstance(l, Value))
		assert(isinstance(r, Value))
		assert(op in ['eq', 'ne'])

		if l.type.is_array():
			from value.array import value_array_eq
			return value_array_eq(l, r, op, ti)
		elif l.type.is_record():
			from value.record import value_record_eq
			return value_record_eq(l, r, op, ti)

		# scalar

		from foundation import typeBool
		nv = ValueBin(typeBool, op, l, r, ti=ti)

		if l.isImmediate() and r.isImmediate():
			eq_result = False
			if op == 'eq':
				eq_result = l.asset == r.asset
			else:
				eq_result = l.asset != r.asset

			nv.asset = int(eq_result)
			nv.immediate = True

		return nv



	# Only for immediate value (!)
	def isZero(self):
		if self.isRuntime():
			return False

		if self.type.is_array():
			for item in self.items:
				if not item.isZero():
					return False
			return True

		if self.type.is_record():
			for initializer in self.items:
				if not initializer.value.isZero():
					return False
			return True

		return self.asset == 0


	@staticmethod
	def print(x, msg="value_print:"):
		assert(isinstance(x, Value))

		# can be 'ti_def', but no 'ti'!
		#if 'ti' in x:
		info(msg, x.ti)
		#if 'def_ti' in x:
		#	info(msg, x['def_ti'])

		#print("isa: " + str(x['isa']))
		print("kind: " + str(x.__class__.__name__))
		print("type: ", end="");
		from type import type_print
		type_print(x.type); print()
		print("att: " + str(x.att))

		print('immediate = ' + str(x.immediate))
		print('immutable = ' + str(x.immutable))

		if x.immediate:
			if x.items != None:
				print("items_len = %d" % len(x.items))
				print("items[0] = ")
				print(x.items[0])

		"""print("additional fields:")

		for prop in x:
			if not prop in ['isa', 'kind', 'type', 'att', 'ti', 'immediate', 'immutable']:
				print(" - %s" % prop)"""

		print()





class ValueBad(Value):
	def __init__(self, ti=None):
		from .type import TypeBad
		super().__init__(type=TypeBad(ti), ti=ti)
		from .hlir import Id
		self.id = Id().fromStr('_')


class ValueUndefined(Value):
	def __init__(self, type=None, ti=None):
		from .type import Type
		if type==None:
			type = Type(ti)
		assert(isinstance(type, Type))
		super().__init__(type=type, ti=ti)


class ValueLiteral(Value):
	def __init__(self, type, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		super().__init__(type=type, ti=ti)
		self.nsigns=0


class ValueZero(Value):
	def __init__(self, type, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		super().__init__(type=type, ti=ti)
		if type.is_composite():
			self.items = []
		else:
			self.asset = 0
		self.immediate = True
		self.addAttribute('zero')


class ValueCons(Value):
	def __init__(self, type, value, method, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		assert(method in ['implicit', 'explicit', 'unsafe'])
		super().__init__(type=type, ti=ti)
		self.value = value
		self.method = method
		self.nl_end = value.nl_end


#TODO: onl value as arg (undefined if not init_value, but type from it)
class ValueVar(Value):
	def __init__(self, type, id, init_value, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(id, Id))
		assert(isinstance(init_value, Value))
		super().__init__(type=type, ti=ti)
		self.id = id
		self.init_value = init_value
		self.usecnt = 0
		self.definition = None  # *StmtDefVar
		self.is_lvalue = True


class ValueConst(Value):
	def __init__(self, type, id, init_value, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(id, Id))
		assert(isinstance(init_value, Value))
		super().__init__(type=type, ti=ti)
		self.id = id
		self.init_value = init_value
		self.usecnt = 0
		self.definition = None  # *StmtDefConst


class ValueFunc(Value):
	def __init__(self, type, id, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(id, Id))
		super().__init__(type=type, ti=ti)
		self.id = id
		self.usecnt = 0
		self.definition = None  # *StmtDefFunc



class ValueNot(Value):
	def __init__(self, type, value, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		super().__init__(type=type, ti=ti)
		self.value = value


class ValueNeg(Value):
	def __init__(self, type, value, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		super().__init__(type=type, ti=ti)
		self.value = value


class ValuePos(Value):
	def __init__(self, type, value, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		super().__init__(type=type, ti=ti)
		self.value = value


class ValueRef(Value):
	def __init__(self, value, ti=None):
		assert(isinstance(value, Value))

		from .type import TypePointer
		type = TypePointer(value.type, ti=ti)
		super().__init__(type=type, ti=ti)
		self.value = value


class ValueDeref(Value):
	def __init__(self, value, ti=None):
		assert(isinstance(value, Value))
		super().__init__(type=value.type.to, ti=ti)
		self.value = value
		self.is_lvalue = True



class ValueSubexpr(Value):
	def __init__(self, value, ti=None):
		#mass
		assert(isinstance(value, Value))
		super().__init__(type=value.type, ti=ti)
		self.value = value


#TODO: maybe without op?
class ValueBin(Value):
	def __init__(self, type, op, left, right, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(left, Value))
		assert(isinstance(right, Value))
		super().__init__(type=type, ti=ti)
		self.op = op
		self.left = left
		self.right = right


class ValueShl(Value):
	def __init__(self, left, right, ti=None):
		assert(isinstance(left, Value))
		assert(isinstance(right, Value))
		super().__init__(type=left.type, ti=ti)
		self.left = left
		self.right = right


class ValueShr(Value):
	def __init__(self, left, right, ti=None):
		assert(isinstance(left, Value))
		assert(isinstance(right, Value))
		super().__init__(type=left.type, ti=ti)
		self.left = left
		self.right = right


#TODO: get type from value ret type
class ValueCall(Value):
	def __init__(self, type, func, args, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(func, Value))
		super().__init__(type=type, ti=ti)
		self.func = func
		self.args = args


class ValueAccessRecord(Value):
	def __init__(self, type, left, field, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(left, Value))
		assert(isinstance(field, Field))
		super().__init__(type=type, ti=ti)
		self.left = left
		self.field = field
		self.is_lvalue = True


#TODO: get type from array element type
class ValueIndex(Value):
	def __init__(self, type, left, index, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(left, Value))
		super().__init__(type=type, ti=ti)
		self.left = left
		self.index = index
		self.is_lvalue = True


#TODO: get type from array type
class ValueSlice(Value):
	def __init__(self, type, left, index_from, index_to, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(left, Value))
		assert(isinstance(index_from, Value))
		assert(isinstance(index_to, Value))
		super().__init__(type=type, ti=ti)
		self.left = left
		self.index_from = index_from
		self.index_to = index_to
		self.is_lvalue = True


class ValueNew(Value):
	def __init__(self, value, ti=None):
		assert(isinstance(value, Value))

		from .type import TypePointer
		type = TypePointer(value.type, ti=ti)
		super().__init__(type=type, ti=ti)
		self.value = value


class ValueSizeofType(Value):
	def __init__(self, of, ti=None):
		value_size = of.size

		type = None
		if of.is_vla():
			# is a VLA
			from trans import typeSysInt
			type = typeSysInt
		else:
			from type import type_number_for
			type = type_number_for(value_size, signed=False, ti=ti)

		super().__init__(type=type, ti=ti)
		self.of = of
		self.immediate = True
		self.asset = value_size


class ValueSizeofValue(Value):
	def __init__(self, value, ti=None):

		type = None
		if value.type.is_vla():
			# is a VLA
			from trans import typeSysInt
			type = typeSysInt
		else:
			from type import type_number_for
			value_size = value.type.size
			type = type_number_for(value_size, signed=False, ti=ti)

		super().__init__(type=type, ti=ti)
		self.of = value
		if not value.type.is_vla():
			self.immediate = True
			self.asset = value_size



class ValueLengthof(Value):
	def __init__(self, value, ti=None):

		type = None
		if value.type.is_vla():
			# is a VLA
			from trans import typeSysInt
			type = typeSysInt
		else:
			from type import type_number_for
			length = value.type.volume.asset
			type = type_number_for(length, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		if not value.type.is_vla():
			self.asset = length
			self.immediate = True

		self.value = value



class ValueAlignof(Value):
	def __init__(self, of, ti=None):
		align = of.align
		from type import type_number_for
		type = type_number_for(align, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.of = of
		self.immediate = True
		self.asset = align


class ValueOffsetof(Value):
	def __init__(self, record, field_id, ti=None):
		from type import record_field_get
		field = record_field_get(of, field_id['str'])
		if field == None:
			error("undefined field '%s'" % field_id['str'], field_id.ti)
			return ValueBad({'ti': ti})

		offset = field['offset']
		from type import type_number_for
		type = type_number_for(offset, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.field = field_id
		self.immediate = True
		self.asset = offset



class ValueVaStart(Value):
	def __init__(self, vaList, lastParam, ti=None):
		from foundation import typeUnit
		super().__init__(type=typeUnit, ti=ti)
		self.va_list = vaList
		self.last_param = lastParam


class ValueVaArg(Value):
	def __init__(self, type, vaList, ti=None):
		super().__init__(type=type, ti=ti)
		self.va_list = vaList


class ValueVaEnd(Value):
	def __init__(self, vaList, ti=None):
		from foundation import typeUnit
		super().__init__(type=typeUnit, ti=ti)
		self.va_list = vaList


class ValueVaCopy(Value):
	def __init__(self, dst, src, ti=None):
		from foundation import typeUnit
		super().__init__(type=typeUnit, ti=ti)
		self.dst = dst
		self.src = src


