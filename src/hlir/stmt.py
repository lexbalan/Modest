#######################################################################
#                             HLIR STMT                               #
#######################################################################

from .entity import Entity

class Stmt(Entity):
	def __init__(self, ti, nl=1):
		super().__init__(ti)
		self.deps = []
		self.att = []
		self.nl = nl
		self.nl_end = 1




class StmtBad(Stmt):
	def __init__(self, ti, nl=1):
		super().__init__(ti)


class StmtComment(Stmt):
	def __init__(self, ti, nl):
		super().__init__(ti=ti, nl=nl)


class StmtCommentLine(StmtComment):
	def __init__(self, lines, ti, nl=0):
		super().__init__(ti, nl)
		self.lines = lines


class StmtCommentBlock(StmtComment):
	def __init__(self, text, ti, nl=0):
		super().__init__(ti, nl)
		self.text = text



class StmtDef(Stmt):
	def __init__(self, id, ti=None):
		super().__init__(ti)
		self.id = id
		self.access_level = 'private'


class StmtDefType(StmtDef):
	def __init__(self, id, newType, protoType, ti=None):
		super().__init__(id, ti)
		self.type = newType
		self.original_type = protoType


class StmtDefVar(StmtDef):
	def __init__(self, id, var_value, init_value=None, ti=None):
		super().__init__(id, ti)
		self.var_value = var_value
		self.init_value = init_value


class StmtDefConst(StmtDef):
	def __init__(self, id, const_value, init_value=None, ti=None):
		super().__init__(id, ti)
		self.value = const_value
		self.init_value = init_value


class StmtDefFunc(StmtDef):
	def __init__(self, id, funcValue, stmt, ti=None):
		super().__init__(id, ti)
		self.value = funcValue
		self.stmt = stmt




class StmtBlock(Stmt):
	# nl_end нужен для отступов при лесенке if-else-if
	# там пустая строка в конце блока влияет на читаемость
	def __init__(self, stmts, ti, nl_end):
		super().__init__(ti)
		# количество пустых строк перед закрывающей скобкой блока
		self.nl_end=nl_end
		self.stmts = stmts


class StmtValueExpression(Stmt):
	def __init__(self, value, ti=None):
		super().__init__(ti)
		self.value = value


class StmtAssign(Stmt):
	def __init__(self, left, right, ti=None):
		super().__init__(ti)
		self.left = left
		self.right = right


class StmtIf(Stmt):
	def __init__(self, cond, then, els=None, ti=None):
		super().__init__(ti)
		self.cond = cond
		self.then = then
		self.els = els


class StmtWhile(Stmt):
	def __init__(self, cond, stmt, ti=None):
		super().__init__(ti)
		self.cond = cond
		self.stmt = stmt


class StmtAgain(Stmt):
	def __init__(self, ti=None):
		super().__init__(ti)


class StmtBreak(Stmt):
	def __init__(self, ti=None):
		super().__init__(ti)


class StmtReturn(Stmt):
	def __init__(self, value=None, ti=None):
		super().__init__(ti)
		self.value = value


class StmtAsm(Stmt):
	def __init__(self, text, outputs, inputs, clobbers, ti=None):
		super().__init__(ti)
		self.text = text
		self.outputs = outputs
		self.inputs = inputs
		self.clobbers = clobbers



class StmtDirective(Stmt):
	def __init__(self, ti):
		super().__init__(ti)


class StmtDirectiveImport(StmtDirective):
	def __init__(self, impline, ti, include=False):
		super().__init__(ti)
		self.impline = impline
		self.include = include
		self.import_module = None


class StmtDirectiveCInclude(StmtDirective):
	def __init__(self, s):
		super().__init__(None)
		self.nl = 1
		self.c_name = s
		self.is_local = s[0:2] == './'


# insert random text into output
class StmtDirectiveInsert(StmtDirective):
	def __init__(self, text, ti):
		super().__init__(ti)
		self.text = text


