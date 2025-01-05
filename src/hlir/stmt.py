######################################################################
#                             HLIR STMT                              #
######################################################################


class Stmt():
	def __init__(self, ti, nl=1):
		self.ti = ti
		self.att = []
		self.nl = nl
		self.end_nl = 1


class StmtBad(Stmt):
	def __init__(self, ti, nl=1):
		super().__init__(ti)


class StmtBlock(Stmt):
	def __init__(self, stmts, ti, end_nl=1):
		super().__init__(ti)
		# количество пустых строк перед закрывающей скобкой блока
		self.end_nl=end_nl
		self.stmts = stmts


class StmtDefVar(Stmt):
	def __init__(self, id, var_value, init_value=None, ti=None):
		super().__init__(ti)
		self.id = id
		self.var_value = var_value
		self.init_value = init_value


class StmtDefConst(Stmt):
	def __init__(self, id, new_value, init_value=None, ti=None):
		super().__init__(ti)
		self.id = id
		self.value = new_value
		self.init_value = init_value


class StmtValue(Stmt):
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


class StmtCommentLine(Stmt):
	def __init__(self, lines, ti=None, nl=0):
		super().__init__(ti, nl=nl)
		self.lines = lines


class StmtCommentBlock(Stmt):
	def __init__(self, text, ti=None, nl=0):
		super().__init__(ti, nl=nl)
		self.text = text



