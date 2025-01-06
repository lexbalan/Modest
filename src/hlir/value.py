#######################################################################
#                             HLIR VALUE                              #
#######################################################################


class Value():
	def __init__(self, type, ti=None):
		self.type = type
		self.id = None
		self.immutable = False  #TODO: True
		self.immediate = False  #TODO: True
		self.items = None  #!
		self.asset = None  #!
		self.att = []
		self.ti = ti
		self.nl = 0
		self.nl_end = 0  # ??



class ValueBad(Value):
	def __init__(self, ti=None):
		from type import type_bad
		super().__init__(type=type_bad({'ti': ti}), ti=ti)
		self.id = Id().fromStr('_')


class ValueUndefined(Value):
	def __init__(self, type, ti=None):
		super().__init__(type=type, ti=ti)
#		self.asset = 0 #!
#		self.items = [] #!
		self.immutable = True # ??
		self.immediate = False # ??


class ValueLiteral(Value):
	def __init__(self, type, ti=None):
		super().__init__(type=type, ti=ti)
		self.nsigns=0


class ValueZero(Value):
	def __init__(self, type, ti=None):
		super().__init__(type=type, ti=ti)
		from type import type_is_composite
		if type_is_composite(type):
			self.items = []
		else:
			self.asset = 0

		self.att.append('zero')


#TODO: onl value as arg (undefined if not init_value, but type from it)
class ValueVar(Value):
	def __init__(self, id, type, init_value=None, ti=None):
		super().__init__(type=type, ti=ti)
		self.id = id
		self.init_value = init_value
		self.usecnt = 0
		self.definition = None


class ValueConst(Value):
	def __init__(self, id, type, value, ti=None):
		super().__init__(type=type, ti=ti)
		self.id = id
		self.value = value
		self.immutable = True
		self.usecnt = 0
		self.definition = None


class ValueFunc(Value):
	def __init__(self, id, type, ti=None):
		super().__init__(type=type, ti=ti)
		self.id = id
		self.immutable = True
		self.usecnt = 0
		self.definition = None


#TODO: maybe without op?
#TODO: value, type -> only value
class ValueUn(Value):
	def __init__(self, op, value, type, ti=None):
		super().__init__(type=type, ti=ti)
		self.op = op
		self.value = value
		self.immutable = True


#TODO: maybe without op?
#TODO: value, type -> only value
class ValueBin(Value):
	def __init__(self, op, left, right, type, ti=None):
		super().__init__(type=type, ti=ti)
		self.op = op
		self.left = left
		self.right = right
		self.immutable = True



#TODO: get type from value ret type
class ValueCall(Value):
	def __init__(self, func, type, args, ti=None):
		super().__init__(type=type, ti=ti)
		self.func = func
		self.args = args
		self.immutable = True



#TODO: get type from array element type
class ValueIndexArray(Value):
	def __init__(self, left, type, index, ti=None):
		super().__init__(type=type, ti=ti)
		self.left = left
		self.index = index
		#self.immutable = True


#TODO: get type from array type
class ValueSliceArray(Value):
	def __init__(self, left, type, index_from, index_to, ti=None):
		super().__init__(type=type, ti=ti)
		self.left = left
		self.index_from = index_from
		self.index_to = index_to
		#self.immutable = True


class ValueAccessModule(Value):
	def __init__(self, type, left, right, value, ti=None):
		super().__init__(type=type, ti=ti)
		self.left = left
		self.right = right
		self.value = value


class ValueAccessRecord(Value):
	def __init__(self, type, value, field, ti=None):
		super().__init__(type=type, ti=ti)
		self.value = value
		self.field = field


class ValueCons(Value):
	def __init__(self, type, value, method, ti=None):
		assert(method in ['implicit', 'explicit', 'unsafe'])
		assert(type['isa'] == 'type')
		#assert(value['isa'] == 'value')
		super().__init__(type=type, ti=ti)
		self.value = value
		self.method = method
		self.immutable = True
		self.nl_end = value.nl_end


class ValueSizeofType(Value):
	def __init__(self, of, ti=None):
		size = of['size']
		from type import type_number_for
		type = type_number_for(size, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.of = of
		self.asset = size
		self.immutable = True
		self.immediate = True


class ValueSizeofValue(Value):
	def __init__(self, value, ti=None):
		value_size = value.type['size']
		from type import type_number_for
		type = type_number_for(value_size, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.of = value
		self.asset = value_size
		self.immutable = True
		self.immediate = True



class ValueAlignof(Value):
	def __init__(self, of, ti=None):
		align = of['align']
		from type import type_number_for
		type = type_number_for(align, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.of = of
		self.asset = align
		self.immutable = True
		self.immediate = True


class ValueOffsetof(Value):
	def __init__(self, record, field_id, ti=None):
		field = htype.record_field_get(of, field_id['str'])
		if field == None:
			error("undefined field '%s'" % field_id['str'], field_id.ti)
			return ValueBad({'ti': ti})

		offset = field['offset']
		from type import type_number_for
		type = type_number_for(offset, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.field = field_id
		self.asset = offset
		self.immutable = True
		self.immediate = True


class ValueLengthof(Value):
	def __init__(self, value, ti=None):
		length = value.type['volume'].asset
		from type import type_number_for
		type = type_number_for(length, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.value = value
		self.asset = length
		self.immutable = True
		self.immediate = True


class ValueVaStart(Value):
	def __init__(self, vaList, lastParam, ti=None):
		from foundation import typeUnit
		super().__init__(type=typeUnit, ti=ti)
		self.va_list = vaList
		self.last_param = lastParam
		self.immutable = True
		self.immediate = True


class ValueVaArg(Value):
	def __init__(self, vaList, type, ti=None):
		super().__init__(type=type, ti=ti)
		self.va_list = vaList
		self.immutable = True
		self.immediate = False


class ValueVaEnd(Value):
	def __init__(self, vaList, ti=None):
		from foundation import typeUnit
		super().__init__(type=typeUnit, ti=ti)
		self.va_list = vaList
		self.immutable = True
		self.immediate = True



class ValueVaCopy(Value):
	def __init__(self, dst, src, ti=None):
		from foundation import typeUnit
		super().__init__(type=typeUnit, ti=ti)
		self.dst = dst
		self.src = src
		self.immutable = True
		self.immediate = True


