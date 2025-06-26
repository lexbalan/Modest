#######################################################################
#                             HLIR VALUE                              #
#######################################################################

from error import info
from util import get_item_by_id
from .entity import Entity
from .misc import Id, Field
import copy


class Value(Entity):
	def __init__(self, type, ti=None):
		super().__init__(ti)
		self.id = None
		self.type = type
		self.definition = None # *StmtDefVar, *StmtDefConst, *StmtDefFunc

		# this value is immediate but are known only in link time
		self.linktime = False
		# this value is immediate
		self.immediate = False

		#
		self.is_lvalue = False

		# immutable anyway flag
		self.immutable = False

		# in case of scalar value type here is code
		# in case of record value here is list of class Initializer
		# in case of array value here is list of values
		# (!) Array & Record items can be not only immediate value (!)
		self.asset = None

		self.nl = 0


	def hasAttribute(self, a):
		return a in self.att or self.type.hasAttribute(a)

	def isLvalue(self):
		return self.is_lvalue

	def isImmediate(self):
		return self.immediate

	def isRuntimeValue(self):
		return not self.isImmediate()

	def isZero(self):
		if self.isImmediate():
			if self.type.is_composite():
				return self.asset == []
			else:
				return self.asset == 0

			#return (self.asset == 0 or self.asset == None) and (self.asset == None or self.asset == [])
		return False


	def isImmutable(self):
		# ONLY lvalue CAN be an immutable value,
		# BUT if immutable flag is set, it is immutable value anyway
		return (not self.isLvalue()) or self.immutable



	def isBad(self):
		return isinstance(self, ValueBad)


	def isUndef(self):
		return isinstance(self, ValueUndef)

	def isLiteral(self):
		return isinstance(self, ValueLiteral)

	def isConst(self):
		return isinstance(self, ValueConst)

	def isVar(self):
		return isinstance(self, ValueVar)


	def copy(self):
		v = copy.copy(self)
		v.att = copy.copy(self.att)
		return v


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
		if self.isRuntimeValue():
			return False

		if self.type.is_array():
			for item in self.asset:
				if not item.isZero():
					return False
			return True

		if self.type.is_record():
			for initializer in self.asset:
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
			if x.asset != None:
				print("items_len = %d" % len(x.asset))
				print("items[0] = ")
				print(x.asset[0])

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
		# чтобы заткнуть жалобы "expected immediate value"
		self.immediate = True


class ValueUndef(Value):
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
			self.asset = []
		else:
			self.asset = 0
		self.immediate = True
		self.addAttribute('zero')



class ValueCons(Value):
	def __init__(self, type, value, method, rawMode, ti):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		assert(method in ['implicit', 'explicit', 'unsafe'])
		super().__init__(type=type, ti=ti)
		self.value = value
		self.method = method
		self.rawMode = rawMode



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


class ValueFunc(Value):
	def __init__(self, type, id, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(id, Id))
		super().__init__(type=type, ti=ti)
		self.id = id
		self.is_pure = False
		self.usecnt = 0



class ValueNot(Value):
	def __init__(self, type, value, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		super().__init__(type=type, ti=ti)
		self.value = value
		if value.isImmediate():
			# because: ~(1) = -1 (not 0) !
			if value.type.is_bool():
				self.asset = not value.asset
			else:
				self.asset = ~value.asset

			self.immediate = True



class ValueNeg(Value):
	def __init__(self, type, value, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		super().__init__(type=type, ti=ti)
		self.value = value
		
		if value.isImmediate():
			self.asset = -value.asset
			self.immediate = True

			if self.type.is_generic():
				from type import type_number_for
				self.type = type_number_for(value.asset, signed=True, ti=ti)


class ValuePos(Value):
	def __init__(self, type, value, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		super().__init__(type=type, ti=ti)
		self.value = value
		
		if value.isImmediate():
			self.asset = +value.asset
			self.immediate = True

		if self.type.is_generic():
			from type import type_number_for
			self.type = type_number_for(value.asset, signed=True, ti=ti)
		


class ValueRef(Value):
	def __init__(self, value, ti=None):
		assert(isinstance(value, Value))

		from .type import TypePointer
		type = TypePointer(value.type, ti=ti)
		super().__init__(type=type, ti=ti)
		self.value = value
		
		if value.is_global():
			self.immediate = True
			# не можно поставить 0 тк иначе значение будет трактоваться как zero
			# и LLVM printer его не всунет в композитны тип (пропустит insertelement)
			# поэтому временно заткнул единицей, но вообще нужно будет обдумать
			self.asset = 1
			self.addAttribute('ptr_to_glb_val')


class ValueDeref(Value):
	def __init__(self, value, ti=None):
		assert(isinstance(value, Value))
		super().__init__(type=value.type.to, ti=ti)
		self.value = value
		self.is_lvalue = True



class ValueSubexpr(Value):
	def __init__(self, value, ti=None):
		assert(isinstance(value, Value))
		super().__init__(type=value.type, ti=ti)
		self.value = value
		if value.isImmediate():
			from trans import cp_immediate
			cp_immediate(self, value)


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
		
		# if left & right are immediate, we can fold const
		# and append field .asset to bin_value
		if left.isImmediate() and right.isImmediate():
			ops = {
				'logic_or': lambda a, b: a or b,
				'logic_and': lambda a, b: a and b,
				'or': lambda a, b: a | b,
				'and': lambda a, b: a & b,
				'xor': lambda a, b: a ^ b,
				'lt': lambda a, b: a < b,
				'gt': lambda a, b: a > b,
				'le': lambda a, b: a <= b,
				'ge': lambda a, b: a >= b,
				'add': lambda a, b: a + b,
				'sub': lambda a, b: a - b,
				'mul': lambda a, b: a * b,
				'div': lambda a, b: left.asset // right.asset,
				'fdiv': lambda a, b: left.asset / right.asset,
				'rem': lambda a, b: a % b,
				'eq':  lambda a, b: a == b,
				'ne':  lambda a, b: a != b
			}

			if op == 'div' and type.is_float():
				op = 'fdiv'

			asset = ops[op](left.asset, right.asset)

			if type.is_num():
				# (для операций типа 1 + 2)
				# Пересматриваем generic тип для нового значения
				from type import type_number_for
				self.type = type_number_for(asset, signed=(asset < 0), ti=ti)

			self.immediate = True
			self.asset = asset



class ValueShl(Value):
	def __init__(self, left, right, ti=None):
		assert(isinstance(left, Value))
		assert(isinstance(right, Value))
		super().__init__(type=left.type, ti=ti)
		self.left = left
		self.right = right

		if left.isImmediate() and right.isImmediate():
			self.asset = int(left.asset << right.asset)
			self.immediate = True


class ValueShr(Value):
	def __init__(self, left, right, ti=None):
		assert(isinstance(left, Value))
		assert(isinstance(right, Value))
		super().__init__(type=left.type, ti=ti)
		self.left = left
		self.right = right

		if left.isImmediate() and right.isImmediate():
			self.asset = int(left.asset >> right.asset)
			self.immediate = True


def get_func_from(x):
	if isinstance(x, ValueFunc):
		return x
	elif isinstance(x, ValueAccessModule):
		return x.value
	return None


#TODO: get type from value ret type
class ValueCall(Value):
	def __init__(self, type, func, args, ti=None):
		from .type import Type
		assert(isinstance(type, Type))
		assert(isinstance(func, Value))
		super().__init__(type=type, ti=ti)
		self.func = func
		self.args = args

		args_is_imm = True
		for arg in args:
			if not arg.value.isImmediate():
				args_is_imm = False
				break

		fn = get_func_from(func)
		if fn != None:
			if fn.is_pure and args_is_imm:
				self.immediate = True
				self.asset = 0


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
		
		if not left.type.is_pointer():
			self.immutable = left.immutable

			# access to immediate object
			if left.isImmediate():
				initializer = get_item_by_id(left.asset, field.id.str)

				# (!) #asset of immediate index & access contains VALUE (!)
				self.immediate = True
				from trans import cp_immediate
				cp_immediate(self, initializer.value)


class ValueAccessModule(Value):
	def __init__(self, type, imp, id, value, ti=None):
		super().__init__(type=type, ti=ti)
		self.imp = imp
		self.id = id
		self.value = value

		self.immediate = value.immediate
		self.asset = value.asset

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
		
		
		
		if not left.type.is_pointer():
			self.immutable = left.immutable
			
			array_typ = left.type

			if left.isImmediate():
				if index.isImmediate():
					#info("immediate index", x['ti'])
					index_imm = index.asset

					if index_imm >= array_typ.volume.asset:
						error("array index out of bounds", x['index'])
						return ValueBad(x['ti'])

					if index_imm < len(left.asset):
						item = left.asset[index_imm]
					else:
						item = ValueZero(array_typ.of, x['ti'])

					self.immediate = True
					from trans import cp_immediate
					cp_immediate(self, item)


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

		if not left.type.is_pointer():
			self.immutable = left.immutable


class ValueNew(Value):
	def __init__(self, value, ti=None):
		assert(isinstance(value, Value))

		from .type import TypePointer
		type = TypePointer(value.type, ti=ti)
		super().__init__(type=type, ti=ti)
		self.value = value


class ValueSizeofType(Value):
	def __init__(self, of, ti=None):
		from trans import typeSysSize
		super().__init__(type=typeSysSize, ti=ti)
		self.of = of
		if not of.is_vla():
			self.immediate = True
			self.asset = of.size
		else:
			self.immediate = False



class ValueSizeofValue(Value):
	def __init__(self, value, ti=None):
		from trans import typeSysSize
		super().__init__(type=typeSysSize, ti=ti)
		self.of = value
		if not value.type.is_vla():
			self.immediate = True
			self.asset = value.type.size
		else:
			self.immediate = False



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
		#from type import type_number_for
		#type = type_number_for(align, signed=False, ti=ti)
		from trans import typeSysSize
		super().__init__(type=typeSysSize, ti=ti)
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


