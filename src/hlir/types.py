

import copy
from util import *


# returns -1 if not found
def get_index_of_item_with_id(_list, id):
	i = 0
	while i < len(_list):
		item = _list[i]
		if item != None:
			if isinstance(item, Initializer) or isinstance(item, Field):
				if item.id.str == id:
					return i
				i = i + 1
				continue
			if item['id'].str == id:
				return i
		i = i + 1
	return -1


def get_item_by_id(_list, id):
	i = get_index_of_item_with_id(_list, id)
	if i < 0:
		return None
	return _list[i]



def _get_int_alias(width, signed):
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






HLIR_VALUE_OP_LOGIC_OR = 'lor'
HLIR_VALUE_OP_LOGIC_XOR = 'lxor'
HLIR_VALUE_OP_LOGIC_AND = 'land'
HLIR_VALUE_OP_LOGIC_NOT = 'lnot'
HLIR_VALUE_OP_OR = 'or'
HLIR_VALUE_OP_XOR = 'xor'
HLIR_VALUE_OP_AND = 'and'
HLIR_VALUE_OP_NOT = 'not'

HLIR_VALUE_OP_ADD = 'add'
HLIR_VALUE_OP_SUB = 'sub'
HLIR_VALUE_OP_MUL = 'mul'
HLIR_VALUE_OP_DIV = 'div'
HLIR_VALUE_OP_REM = 'rem'
HLIR_VALUE_OP_NEG = 'neg'
HLIR_VALUE_OP_POS = 'pos'

HLIR_VALUE_OP_SHL = 'shl'
HLIR_VALUE_OP_SHR = 'shr'

HLIR_VALUE_OP_LT = 'lt'
HLIR_VALUE_OP_GT = 'gt'
HLIR_VALUE_OP_LE = 'le'
HLIR_VALUE_OP_GE = 'ge'
HLIR_VALUE_OP_EQ = 'eq'
HLIR_VALUE_OP_NE = 'ne'

HLIR_VALUE_OP_CONS = 'cons'
HLIR_VALUE_OP_CALL = 'call'
HLIR_VALUE_OP_REF = 'ref'
HLIR_VALUE_OP_DEREF = 'deref'
HLIR_VALUE_OP_INDEX = 'index'
HLIR_VALUE_OP_ACCESS = 'access'

HLIR_VALUE_OP_SIZEOF = 'sizeof'
HLIR_VALUE_OP_ALIGNOF = 'alignof'
HLIR_VALUE_OP_OFFSETOF = 'offsetof'
HLIR_VALUE_OP_LENGTHOF = 'lengthof'
HLIR_VALUE_OP_ACCESS_MODULE = 'access_module'


HLIR_ACCESS_LEVEL_DEFAULT = 'default'
HLIR_ACCESS_LEVEL_PUBLIC = 'public'
HLIR_ACCESS_LEVEL_PRIVATE = 'private'


HLIR_TYPE_SIGNEDNESS_NONE = 0
HLIR_TYPE_SIGNEDNESS_SIGNED = 1
HLIR_TYPE_SIGNEDNESS_UNSIGNED = 2


class Entity():
	def __init__(self, ti):
		self.ti = ti
		self.att = []
		self.annotations = {}
		self.parent = None
		self.is_global_flag = False

	def addAttribute(self, a):
		self.att.append(a)

	def hasAttribute(self, a):
		return a in self.att

	def addAnnotation(self, annotation, params):
		if not annotation in self.annotations:
			self.annotations[annotation] = params

	def getAnnotation(self, annotation):
		if annotation in self.annotations:
			return self.annotations[annotation]
		return None

	def hasAttribute2(self, a):
		a = self.getAnnotation(a)
		return a != None

	def is_global(self):
		return self.is_global_flag


	# возвращает модуль в котором сущность определена (или None)
	def getModule(self):
		if hasattr(self, 'definition'):
			definition = self.definition
			if hasattr(definition, 'module'):
				return self.definition.module
		return None




class Module:
	def __init__(self, idStr, ast, symtab_public, symtab_private, sourcename):
		self.id = idStr
		self.sourcename = sourcename
		self.ast = ast
		self.prefix = idStr
		self.strings = []   # for LLVM backend
		self.anon_recs = [] # anonymous records for C backend
		self.imports = {}   # '<import_id>' => {'isa': 'module'}
		self.included_modules = []
		self.symtab_public = symtab_public
		self.symtab_private = symtab_private
		self.source_abspath = None
		self.defs = []
		self.att = []


	def setPrefix(self, prefixStr):
		self.prefix = prefixStr

	def addAttribute(self, a):
		if not a in self.att:
			self.att.append(a)

	def hasAttribute(self, a):
		return a in self.att


	def type_add(self, id_str, t, is_public=False):
		#print('module_type_add (%s, isPublic=%d)' % (id_str, is_public))
		if is_public:
			self.symtab_public.type_add(id_str, t)
		else:
			self.symtab_private.type_add(id_str, t)


	def value_add(self, id_str, v, is_public=False):
		#print('module_value_add (%s, isPublic=%d)' % (id_str, is_public))
		if is_public:
			self.symtab_public.value_add(id_str, v)
		else:
			self.symtab_private.value_add(id_str, v)


	def value_get_public(self, id_str):
		return self.symtab_public.value_get(id_str)

	def value_get_private(self, id_str):
		return self.symtab_private.value_get(id_str)

	def type_get_public(self, id_str):
		return self.symtab_public.type_get(id_str)

	def type_get_private(self, id_str):
		return self.symtab_private.type_get(id_str)



class Id(Entity):
	def __init__(self, id_str, ti=None):
		super().__init__(None)
		self.prefix = None
		# Каждый принтер всегда использует только свой алиас (!)
		# Такой алиас может быть переопределен без вреда для других принтеров и фронтенда
		self.str = id_str
		self.c = id_str
		self.llvm = id_str
		self.cm = id_str
		self.ti = ti



class Field(Entity):
	def __init__(self, _id, _type, init_value, ti=None):
		super().__init__(ti)
		assert(init_value!=None)
		self.id = _id
		self.type = _type
		self.init_value = init_value
		self.field_no = 0
		self.offset = 0
		self.access_level = HLIR_ACCESS_LEVEL_PRIVATE
		self.att = []
		self.nl = 0
		self.ti = ti
		self.comments = []
		self.line_comment = None



class Initializer(Entity):
	def __init__(self, _id, value, named=False, ti=None, nl=0):
		super().__init__(ti)
		self.id = _id
		self.value = value
		self.ti = ti
		self.nl = nl
		self.att = []
		# этот инициализатор описывает явно именованную сущность? (аргумент)
		# нужно чтобы принтер знал когда стоит печатать аргумент как "key=value"
		self.named = named



class Stmt(Entity):
	def __init__(self, ti=None, nl=1):
		super().__init__(ti)
		self.deps = []
		self.att = []
		self.nl = nl

	def is_stmt_bad(self):
		return False

	def is_stmt_def_func(self):
		return isinstance(self, StmtDefFunc)

	def is_stmt_block(self):
		return isinstance(self, StmtBlock)

	def is_stmt_value_expr(self):
		return isinstance(self, StmtValueExpression)

	def is_stmt_assign(self):
		return isinstance(self, StmtAssign)

	def is_stmt_return(self):
		return isinstance(self, StmtReturn)

	def is_stmt_if(self):
		return isinstance(self, StmtIf)

	def is_stmt_while(self):
		return isinstance(self, StmtWhile)

	def is_stmt_def_var(self):
		return isinstance(self, StmtDefVar)

	def is_stmt_def_const(self):
		return isinstance(self, StmtDefConst)

	def is_stmt_def_type(self):
		return isinstance(self, StmtDefType)

	def is_stmt_break(self):
		return isinstance(self, StmtBreak)

	def is_stmt_again(self):
		return isinstance(self, StmtAgain)

	def is_stmt_comment(self):
		return isinstance(self, StmtComment)

	def is_stmt_asm(self):
		return isinstance(self, StmtAsm)

	def is_stmt_directive(self):
		return isinstance(self, StmtDirective)

	def is_stmt_import(self):
		return isinstance(self, StmtImport)





class StmtBad(Stmt):
	def __init__(self, ti=None, nl=1):
		super().__init__(ti)

	def is_bad(self):
		return True



class StmtComment(Stmt):
	def __init__(self, ti, nl):
		super().__init__(ti=ti, nl=nl)



class StmtCommentLine(StmtComment):
	def __init__(self, lines, ti=None, nl=1):
		super().__init__(ti, nl)
		self.lines = lines



class StmtCommentBlock(StmtComment):
	def __init__(self, text, ti=None, nl=1):
		super().__init__(ti, nl)
		self.text = text



class StmtImport(Stmt):
	def __init__(self, impline, name, module, ti=None, include=False):
		super().__init__(ti)
		self.impline = impline
		self.include = include
		self.module = module
		self.name = name



class StmtDef(Stmt):
	def __init__(self, id, ti=None, nl=1):
		super().__init__(ti)
		self.id = id
		self.access_level = HLIR_ACCESS_LEVEL_PRIVATE
		self.nl = nl



class StmtDefType(StmtDef):
	def __init__(self, id, new_type, proto_type, ti=None, nl=1):
		super().__init__(id, ti, nl)
		self.type = new_type
		self.original_type = proto_type



class StmtDefVar(StmtDef):
	def __init__(self, id, var_value, init_value=None, ti=None, nl=1):
		super().__init__(id, ti, nl)
		self.value = var_value
		self.init_value = init_value



class StmtDefConst(StmtDef):
	def __init__(self, id, const_value, init_value=None, ti=None, nl=1):
		super().__init__(id, ti, nl)
		self.value = const_value
		self.init_value = init_value



class StmtDefFunc(StmtDef):
	def __init__(self, id, funcValue, stmt, ti=None, nl=1):
		super().__init__(id, ti, nl)
		self.value = funcValue
		self.stmt = stmt



class StmtBlock(Stmt):
	def __init__(self, stmts, ti=None, nl=1):
		super().__init__(ti, nl)
		# количество пустых строк перед закрывающей скобкой блока
		self.stmts = stmts



class StmtValueExpression(Stmt):
	def __init__(self, value, ti=None, nl=1):
		super().__init__(ti, nl)
		self.value = value



class StmtAssign(Stmt):
	def __init__(self, left, right, ti=None, nl=1):
		super().__init__(ti, nl)
		self.left = left
		self.right = right



class StmtIf(Stmt):
	def __init__(self, cond, then, els=None, ti=None, nl=1):
		super().__init__(ti, nl)
		self.cond = cond
		self.then = then
		self.els = els



class StmtWhile(Stmt):
	def __init__(self, cond, stmt, ti=None, nl=1):
		super().__init__(ti, nl=1)
		self.cond = cond
		self.stmt = stmt



class StmtAgain(Stmt):
	def __init__(self, ti=None, nl=1):
		super().__init__(ti, nl)



class StmtBreak(Stmt):
	def __init__(self, ti=None, nl=1):
		super().__init__(ti, nl)



class StmtReturn(Stmt):
	def __init__(self, value=None, ti=None, nl=1):
		super().__init__(ti, nl)
		self.value = value



class StmtAsm(Stmt):
	def __init__(self, text, outputs, inputs, clobbers, ti=None, nl=1):
		super().__init__(ti, nl=1)
		self.text = text
		self.outputs = outputs
		self.inputs = inputs
		self.clobbers = clobbers



class StmtDirective(Stmt):
	def __init__(self, ti, nl=1):
		super().__init__(ti, nl)



class StmtDirectiveCInclude(StmtDirective):
	def __init__(self, s, ti=None, nl=1):
		super().__init__(ti, nl)
		self.nl = 1
		self.c_name = s
		self.is_local = s[0:2] == './'



# insert random text into output
class StmtDirectiveInsert(StmtDirective):
	def __init__(self, text, ti=None, nl=1):
		super().__init__(ti, nl)
		self.text = text





######################################################################
#                            HLIR TYPE                               #
######################################################################


CONS_OP = (HLIR_VALUE_OP_CONS,)
EQ_OPS = (HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE)
RELATIONAL_OPS = (HLIR_VALUE_OP_LT, HLIR_VALUE_OP_GT, HLIR_VALUE_OP_LE, HLIR_VALUE_OP_GE)
ARITHMETICAL_OPS = (HLIR_VALUE_OP_ADD, HLIR_VALUE_OP_SUB, HLIR_VALUE_OP_MUL, HLIR_VALUE_OP_DIV, HLIR_VALUE_OP_REM, HLIR_VALUE_OP_NEG, HLIR_VALUE_OP_POS)
LOGICAL_OPS = (HLIR_VALUE_OP_OR, HLIR_VALUE_OP_XOR, HLIR_VALUE_OP_AND, HLIR_VALUE_OP_NOT)
BITWISE_OPS = LOGICAL_OPS #+ (HLIR_VALUE_OP_SHL, HLIR_VALUE_OP_SHR) -

UNIT_OPS = CONS_OP
WORD_OPS = CONS_OP + EQ_OPS + BITWISE_OPS
INT_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS
FLOAT_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS
BOOL_OPS = CONS_OP + EQ_OPS + LOGICAL_OPS
CHAR_OPS = CONS_OP + EQ_OPS
ENUM_OPS = CONS_OP + EQ_OPS
PTR_OPS = CONS_OP + EQ_OPS + (HLIR_VALUE_OP_DEREF,)
ARR_OPS = CONS_OP + EQ_OPS + (HLIR_VALUE_OP_ADD, HLIR_VALUE_OP_INDEX)
REC_OPS = CONS_OP + EQ_OPS + (HLIR_VALUE_OP_ACCESS,)
STR_OPS = CONS_OP + EQ_OPS + (HLIR_VALUE_OP_ADD,)
NUM_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS + LOGICAL_OPS


pointer_width = 0
def init(pwidth):
	global pointer_width
	pointer_width = pwidth


HLIR_TYPE_KIND_UNKNOWN = 0
HLIR_TYPE_KIND_BAD = 1
HLIR_TYPE_KIND_UNIT = 2
HLIR_TYPE_KIND_WORD = 3
HLIR_TYPE_KIND_INT = 4
HLIR_TYPE_KIND_NAT = 5
HLIR_TYPE_KIND_CHAR = 6
HLIR_TYPE_KIND_FUNC = 7
HLIR_TYPE_KIND_ARRAY = 8
HLIR_TYPE_KIND_RECORD = 9
HLIR_TYPE_KIND_POINTER = 10
HLIR_TYPE_KIND_BOOL = 11
HLIR_TYPE_KIND_NUMBER = 12
HLIR_TYPE_KIND_STRING = 13
HLIR_TYPE_KIND_FLOAT = 14
HLIR_TYPE_KIND_VA_LIST = 15



class Type(Entity):
	def __init__(self, generic=False, width=0, ops=[], ti=None):
		super().__init__(ti)
		size = nbytes_for_bits(width)
		align = 1
		if size > 0:
			align = size
		self.kind = HLIR_TYPE_KIND_UNKNOWN
		self.generic = generic
		self.width = width
		self.size = size
		self.align = align
		self.ops = ops
		self.att = []
		self.annotations = {}
		self.deps = []
		self.signedness = HLIR_TYPE_SIGNEDNESS_NONE
		self.ti = None
		self.incomplete = True
		self.definition = None
		self.is_global_flag = True
		#self.id = id

		self.parent_type = None
		# особое поле - если оно ненулевое значит это distinct тип
		# такие типы будут признаны неравными если их поля dictinct отличны
		# 0 - зарезервирован для не distinct типов (см. @distinct аттрибут)
		self.brand = 0
		self.refine = 0


	def is_bad(self):
		return self.kind == HLIR_TYPE_KIND_BAD


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
		return self.kind == HLIR_TYPE_KIND_UNIT


	def is_bool(self):
		return self.kind == HLIR_TYPE_KIND_BOOL


	# Special type for StringLiteral (!)
	def is_string(self):
		return self.kind == HLIR_TYPE_KIND_STRING


	def is_record(self):
		return self.kind == HLIR_TYPE_KIND_RECORD


	def is_array(self):
		return self.kind == HLIR_TYPE_KIND_ARRAY


	def is_word(self):
		return self.kind == HLIR_TYPE_KIND_WORD


	def is_int(self):
		return self.kind == HLIR_TYPE_KIND_INT


	def is_nat(self):
		return self.kind == HLIR_TYPE_KIND_NAT


	def is_float(self):
		return self.kind == HLIR_TYPE_KIND_FLOAT


	def is_char(self):
		return self.kind == HLIR_TYPE_KIND_CHAR


	# numeric type supports arithmetical operations
	def is_numeric(self):
		return self.is_int() or self.is_number() or self.is_float()


	def is_number(self):
		return self.kind == HLIR_TYPE_KIND_NUMBER


	def is_func(self):
		return self.kind == HLIR_TYPE_KIND_FUNC


	def is_arithmetical(self):
		return self.is_int() or self.is_nat()

	# word, nat, int
	def is_xword(self):
		return self.is_word() or self.is_int() or self.is_nat()




	# (this) type is VLA - variable langth array
	# [n]Int32 -> True, [][n]Int32 -> False
	def is_vla(self):
		if not self.is_array():
			return False
		if self.volume.isValueUndef():
			return False
		return self.volume.isValueRuntime()


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
		return t.is_word() or t.is_int() or t.is_nat() or t.is_char() or t.is_number()


	def is_composite(self):
		return self.is_array() or self.is_record()

	def is_simple(self):
		return not (self.is_composite() or self.is_func() or self.is_pointer())

	def is_nil(self):
		return False


	def is_pointer(self):
		return self.kind == HLIR_TYPE_KIND_POINTER


	def is_va_list(self):
		return self.kind == HLIR_TYPE_KIND_VA_LIST

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
			return not self.volume.isValueUndef()
		return False


	def is_open_array(self):
		if self.is_array():
			return self.volume.isValueUndef()
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
		return self.signedness == HLIR_TYPE_SIGNEDNESS_SIGNED


	def is_unsigned(self):
		return self.signedness == HLIR_TYPE_SIGNEDNESS_UNSIGNED


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
		if a.volume.isValueUndef() or b.volume.isValueUndef():
			if a.volume.isValueUndef() and b.volume.isValueUndef():
				return Type.eq(a.of, b.of, opt)
			return False

		# a.volume & b.volume defined

		if a.volume.isValueImmediate() and b.volume.isValueImmediate():
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
		if a.is_int(): return Type.eq_integer(a, b, opt)
		elif a.is_nat(): return Type.eq_natural(a, b, opt)
		elif a.is_bool(): return True
		elif a.is_number(): return True
		elif a.is_func(): return Type.eq_func(a, b, opt)
		elif a.is_record(): return Type.eq_record(a, b, opt)
		elif a.is_array(): return Type.eq_array(a, b, opt)
		elif a.is_pointer(): return Type.eq_pointer(a, b, opt)
		elif a.is_char(): return Type.eq_char(a, b, opt)
		elif a.is_word(): return Type.eq_word(a, b, opt)
		elif a.is_float(): return Type.eq_float(a, b, opt)
		elif a.is_string(): return True
		elif a.is_unit(): return True
		elif a.is_va_list(): return True
		assert(False)
		return False


	def copy(self):
		y = copy.copy(self)
		y.att = copy.copy(self.att)
		y.annotations = copy.copy(self.annotations)
		return y

	def reborn(self):
		nt = self.copy()
		nt.att = []
		nt.annotations = {}
		return nt

	@staticmethod
	def update(dst, src):
		# Это даже как то работает, ок, пока сойдет
		dst.__dict__.clear()
		dst.__dict__.update(src.__dict__)
		dst.att = copy.copy(src.att)
		dst.annotations = copy.copy(src.annotations)
		dst.__class__ = src.__class__


	# cannot create field with type
	def is_forbidden_field(self):
		if self.is_incompleted() or self.is_unit() or self.is_func():
			return True

		if self.is_array():
			# [_]<Forbidden>
			if self.of.is_forbidden_var():
				return True

			return self.of.is_forbidden_var()


	# cannot create variable with type
	def is_forbidden_var(self, open_array_forbidden=True, zero_array_forbidden=True):
		if self.is_forbidden_field():
			return True

		if self.is_array():
			# []Int32
			if self.is_open_array():
				return open_array_forbidden

			# zero sized array is forbidden for vars
			from trans import is_unsafe_mode
			if not is_unsafe_mode():
				if self.volume.isValueImmediate():
					if self.volume.asset == 0:
						return zero_array_forbidden

			return self.of.is_forbidden_var()

		return False



class TypeBad(Type):
	def __init__(self, ti=None):
		super().__init__(ti=ti)
		self.kind = HLIR_TYPE_KIND_BAD
		self.incomplete = False


class TypeNumber(Type):
	def __init__(self, width=0, signedness=False, ti=None):
		super().__init__(generic=True, width=width, ops=NUM_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_NUMBER
		self.incomplete = False
		self.id = Id(None)
		self.signedness = signedness
		#self.signed=signed
		#self.unsigned=not signed


class TypeString(Type):
	def __init__(self, char_width, length, ti=None):
		width = char_width
		size = nbytes_for_bits(width)
		super().__init__(width=width, generic=True, ops=STR_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_STRING
		self.incomplete = False
		self.size=size
		self.char_width=char_width
		self.length=length
		#self.volume = ValueLiteral(TypeNumber(width=64), length, ti)


class TypeUnit(Type):
	def __init__(self, ti=None):
		super().__init__(ops=UNIT_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_UNIT
		self.incomplete = False
		self.id = Id('Unit')
		self.id.c = 'void'
		self.id.llvm = 'void'


class TypeBool(Type):
	def __init__(self, ti=None):
		super().__init__(width=1, ops=BOOL_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_BOOL
		self.incomplete = False
		self.id = Id('Bool')
		self.id.c = 'bool'
		self.id.llvm = 'Bool'


class TypeWord(Type):
	def __init__(self, width, ti=None):
		width = align_bits_up(width)

		super().__init__(width=width, ops=WORD_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_WORD
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

		self.id = Id('Word%d' % width)
		self.id.c = calias
		self.id.llvm = llvm_alias


class TypeInt(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=INT_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_INT
		self.incomplete = False
		alias = _get_int_alias(width, signed=True)
		self.id = Id(alias['cm'])
		self.id.c = alias['c']
		self.id.llvm = alias['llvm']
		self.signedness = HLIR_TYPE_SIGNEDNESS_SIGNED


class TypeNat(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=INT_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_NAT
		self.incomplete = False
		alias = _get_int_alias(width, signed=False)
		self.id = Id(alias['cm'])
		self.id.c = alias['c']
		self.id.llvm = alias['llvm']
		self.signedness = HLIR_TYPE_SIGNEDNESS_UNSIGNED


class TypeFloat(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=FLOAT_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_FLOAT
		self.incomplete = False

		calias = 'float'
		if width > 32:
			calias = 'double'

		alias = _get_int_alias(width, signed=True)
		self.id = Id('Float%d' % width)
		self.id.c = calias
		self.id.llvm = 'Float%d' % width
		self.signedness = HLIR_TYPE_SIGNEDNESS_SIGNED


class TypeChar(Type):
	def __init__(self, width, ti=None):
		super().__init__(width=width, ops=CHAR_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_CHAR
		self.incomplete = False

		#alias = _get_int_alias(width, signed=False)
		self.id = Id('Char%d' % width)
		self.id.llvm = 'Char%d' % width
		if width <= 8:
			self.id.c = 'char'
		else:
			self.id.c = 'char%d_t' % width


class TypePointer(Type):
	def __init__(self, to, generic=False, ti=None):
		w = int(pointer_width)
		super().__init__(width=w, generic=generic, ops=PTR_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_POINTER
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
		if volume != None and not volume.isValueUndef():
			if volume.immediate:
				array_size = item_size * volume.asset

		super().__init__(generic=generic, ops=ARR_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_ARRAY
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
		self.kind = HLIR_TYPE_KIND_RECORD
		self.incomplete = False
		self.fields = fields


class TypeFunc(Type):
	def __init__(self, params, to, va_args=False, ti=None):
		w = int(pointer_width)
		super().__init__(width=w, ops=PTR_OPS, ti=ti)
		self.kind = HLIR_TYPE_KIND_FUNC
		self.incomplete = False
		self.params = params
		self.to = to
		self.extra_args = va_args


class TypeVaList(Type):
	def __init__(self):
		super().__init__(width=0, ti=None)
		self.kind = HLIR_TYPE_KIND_VA_LIST
		self.incomplete = False
		self.id = Id('va_list')
		self.id.c = 'va_list'
		self.id.llvm = '__VA_List'




HLIR_VALUE_STORAGE_CLASS_GLOBAL = "global"
HLIR_VALUE_STORAGE_CLASS_PARAM = "param"
HLIR_VALUE_STORAGE_CLASS_LOCAL = "local"
HLIR_VALUE_STORAGE_CLASS_DEFAULT = HLIR_VALUE_STORAGE_CLASS_LOCAL


class Value(Entity):
	def __init__(self, type, ti=None):
		super().__init__(ti)
		self.id = None
		self.type = type
		self.storage_class = HLIR_VALUE_STORAGE_CLASS_DEFAULT
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
		return a in self.att or self.type.hasAttribute2(a)

	def isLvalue(self):
		return self.is_lvalue

	def isValueRuntime(self):
		return not self.isValueImmediate()

	def isValueImmediate(self):
		return self.immediate

	def isValueImmutable(self):
		# ONLY lvalue CAN be an immutable value,
		# BUT if immutable flag is set, it is immutable value anyway
		return (not self.isLvalue()) or self.immutable

	def isValueBad(self):
		return isinstance(self, ValueBad)

	def isValueUndef(self):
		return isinstance(self, ValueUndef)

	def isValueLiteral(self):
		return isinstance(self, ValueLiteral)

	def isValueConst(self):
		return isinstance(self, ValueConst)

	def isValueVar(self):
		return isinstance(self, ValueVar)

	def isValueFunc(self):
		return isinstance(self, ValueFunc)

	def isValueSubexpr(self):
		return isinstance(self, ValueSubexpr)

	def isValueNew(self):
		return isinstance(self, ValueNew)

	def isValueVaArg(self):
		return isinstance(self, ValueVaArg)

	def isValueVaStart(self):
		return isinstance(self, ValueVaStart)

	def isValueVaEnd(self):
		return isinstance(self, ValueVaEnd)

	def isValueVaCopy(self):
		return isinstance(self, ValueVaCopy)

	def isValueBin(self):
		return isinstance(self, ValueBin)

	def isValueLogicOr(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_LOGIC_OR

	def isValueLogicAnd(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_LOGIC_AND

	def isValueLogicXor(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_LOGIC_XOR

	def isValueLogicNot(self):
		return isinstance(self, ValueNot) and self.value.type.is_bool()

	def isValueOr(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_OR

	def isValueAnd(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_AND

	def isValueXor(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_XOR

	def isValueNot(self):
		return isinstance(self, ValueNot) #and not self.value.type.is_bool()

	def isValueAdd(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_ADD

	def isValueSub(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_SUB

	def isValueMul(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_MUL

	def isValueDiv(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_DIV

	def isValueRem(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_REM

	def isValueNeg(self):
		return isinstance(self, ValueNeg)

	def isValuePos(self):
		return isinstance(self, ValuePos)

	def isValueShl(self):
		return isinstance(self, ValueShl)

	def isValueShr(self):
		return isinstance(self, ValueShr)

	def isValueLt(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_LT

	def isValueGt(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_GT

	def isValueLe(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_LE

	def isValueGe(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_GE

	def isValueEq(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_EQ

	def isValueNe(self):
		return self.isBin() and self.op == HLIR_VALUE_OP_NE

	def isValueCons(self):
		return isinstance(self, ValueCons)

	def isValueCall(self):
		return isinstance(self, ValueCall)

	def isValueRef(self):
		return isinstance(self, ValueRef)

	def isValueDeref(self):
		return isinstance(self, ValueDeref)

	def isValueIndex(self):
		return isinstance(self, ValueIndex)

	def isValueSlice(self):
		return isinstance(self, ValueSlice)

	def isValueAccessRecord(self):
		return isinstance(self, ValueAccessRecord)

	def isValueSizeofValue(self):
		return isinstance(self, ValueSizeofValue)

	def isValueSizeofType(self):
		return isinstance(self, ValueSizeofType)

	def isValueAlignof(self):
		return isinstance(self, ValueAlignof)

	def isValueOffsetof(self):
		return isinstance(self, ValueOffsetof)

	def isValueLengthof(self):
		return isinstance(self, ValueLengthof)

	def isValueAccessModule(self):
		return isinstance(self, ValueAccessModule)


	def copy(self):
		v = copy.copy(self)
		v.att = copy.copy(self.att)
		return v


	# Only for immediate value (!)
	def isValueZero(self):
		if self.isValueRuntime():
			return False

		if self.type.is_array():
			for item in self.asset:
				if not item.isValueZero():
					return False
			return True

		if self.type.is_record():
			for initializer in self.asset:
				if not initializer.value.isValueZero():
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
		super().__init__(type=TypeBad(ti), ti=ti)
		self.id = Id('_')
		# чтобы заткнуть жалобы "expected immediate value"
		self.immediate = True


class ValueUndef(Value):
	def __init__(self, type=None, ti=None):
		if type==None:
			type = Type(ti)
		assert(isinstance(type, Type))
		super().__init__(type=type, ti=ti)
		self.immediate = True
		self.asset = None


class ValueLiteral(Value):
	def __init__(self, type, asset, ti=None):
		assert(isinstance(type, Type))
		super().__init__(type=type, ti=ti)
		self.asset = asset
		self.immediate = True
		self.nsigns=0


class ValueZero(Value):
	def __init__(self, type, ti=None):
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
		assert(isinstance(type, Type))
		assert(isinstance(id, Id))
		assert(isinstance(init_value, Value))
		super().__init__(type=type, ti=ti)
		self.id = id
		self.init_value = init_value
		self.usecnt = 0



class ValueFunc(Value):
	def __init__(self, type, id, ti=None):
		assert(isinstance(type, Type))
		assert(isinstance(id, Id))
		super().__init__(type=type, ti=ti)
		self.id = id
		self.is_pure = False
		self.usecnt = 0



class ValueNot(Value):
	def __init__(self, type, value, ti=None):
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		super().__init__(type=type, ti=ti)
		self.value = value




class ValueNeg(Value):
	def __init__(self, type, value, ti=None):
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		super().__init__(type=type, ti=ti)
		self.value = value



class ValuePos(Value):
	def __init__(self, type, value, ti=None):
		assert(isinstance(type, Type))
		assert(isinstance(value, Value))
		super().__init__(type=type, ti=ti)
		self.value = value



class ValueRef(Value):
	def __init__(self, value, ti=None):
		assert(isinstance(value, Value))
		type = TypePointer(value.type, ti=ti)
		super().__init__(type=type, ti=ti)
		self.value = value

		if value.is_global():
			self.immediate = True
			# не можно поставить 0 тк иначе значение будет трактоваться как zero
			# и LLVM printer его не всунет в композитны тип (пропустит insertelement)
			# поэтому временно заткнул единицей, но вообще нужно будет обдумать
			self.asset = 1



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



#TODO: maybe without op?
class ValueBin(Value):
	def __init__(self, type, op, left, right, ti=None):
		assert(isinstance(type, Type))
		assert(isinstance(left, Value))
		assert(isinstance(right, Value))
		super().__init__(type=type, ti=ti)
		self.op = op
		self.left = left
		self.right = right



class ValueShl(Value):
	def __init__(self, type, left, right, ti=None):
		assert(isinstance(type, Type))
		assert(isinstance(left, Value))
		assert(isinstance(right, Value))
		super().__init__(type=type, ti=ti)
		self.left = left
		self.right = right



class ValueShr(Value):
	def __init__(self, type, left, right, ti=None):
		assert(isinstance(type, Type))
		assert(isinstance(left, Value))
		assert(isinstance(right, Value))
		super().__init__(type=type, ti=ti)
		self.left = left
		self.right = right



def get_func_from(x):
	if isinstance(x, ValueFunc):
		return x
	elif isinstance(x, ValueAccessModule):
		return x.value
	return None



#TODO: get type from value ret type
class ValueCall(Value):
	def __init__(self, type, func, args, ti=None):
		assert(isinstance(type, Type))
		assert(isinstance(func, Value))
		super().__init__(type=type, ti=ti)
		self.func = func
		self.args = args



class ValueAccessRecord(Value):
	def __init__(self, type, left, field, ti=None):
		assert(isinstance(type, Type))
		assert(isinstance(left, Value))
		assert(isinstance(field, Field))
		super().__init__(type=type, ti=ti)
		self.left = left
		self.field = field
		self.is_lvalue = True



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
		assert(isinstance(type, Type))
		assert(isinstance(left, Value))
		super().__init__(type=type, ti=ti)
		self.left = left
		self.index = index
		self.is_lvalue = True



#TODO: get type from array type
class ValueSlice(Value):
	def __init__(self, type, left, index_from, index_to, ti=None):
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
			length = 0
			if value.type.is_array():
				length = value.type.volume.asset
			elif value.type.is_string():
				length = len(value.asset)
			type = type_number_for(length, signedness=HLIR_TYPE_SIGNEDNESS_UNSIGNED, ti=ti)
		super().__init__(type=type, ti=ti)
		if not value.type.is_vla():
			self.asset = length
			self.immediate = True

		self.value = value



class ValueAlignof(Value):
	def __init__(self, of, ti=None):
		align = of.align
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
		type = type_number_for(offset, signedness=HLIR_TYPE_SIGNEDNESS_UNSIGNED, ti=ti)
		super().__init__(type=type, ti=ti)
		self.field = field_id
		self.immediate = True
		self.asset = offset



class ValueVaStart(Value):
	def __init__(self, type, vaList, lastParam, ti=None):
		super().__init__(type=type, ti=ti)
		self.va_list = vaList
		self.last_param = lastParam



class ValueVaArg(Value):
	def __init__(self, type, vaList, ti=None):
		super().__init__(type=type, ti=ti)
		self.va_list = vaList



class ValueVaEnd(Value):
	def __init__(self, type, vaList, ti=None):
		super().__init__(type=type, ti=ti)
		self.va_list = vaList



class ValueVaCopy(Value):
	def __init__(self, type, dst, src, ti=None):
		super().__init__(type=type, ti=ti)
		self.dst = dst
		self.src = src



