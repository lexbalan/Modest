
from error import error, info
from hlir import TokenInfo


EOF = ''


def isIdChar(x):
	return x.isalpha() or x.isdigit() or x == '_'


# Ave Python!
def isHexDigit(x):
	cc = ord(x)
	if cc <= ord('9'): return cc >= ord('0')
	if cc <= ord('F'): return cc >= ord('A')
	if cc <= ord('f'): return cc >= ord('a')
	return False


class Lexer:
	def __init__(self, lexicalRules):
		self.lexicalRules = lexicalRules
		pass


	def run(self, filename):
		self.filename = filename
		self.line_fpos = 0  # position in file when line starts
		self.space_pos = 0
		self.tab_pos = 0
		self.line = 1
		self.f = open(filename, "r")

		tokens = []
		while True:
			if self.peep() == EOF:
				return tokens

			# save current lexer position in the source
			tokenStartPosition = self.getTextPosition()
			line_start_position = self.line_fpos

			for rule in self.lexicalRules:
				result = rule()

				if result == False:
					# The rule not recognize input chain.
					# Restore lexer position in the source
					# and go to try another lexer rule
					self.setTextPosition(tokenStartPosition)
					continue

				# The rule recognized input chain
				if result != None:
					# There is a token
					# # token = ('<token_class>', <token_data>, <ti>)
					endp = self.f.tell()

					ti = TokenInfo(
						source = self.filename,
						line = tokenStartPosition['line'],
						fpos = line_start_position,
						spaces = tokenStartPosition['nspaces'],
						tabs = tokenStartPosition['ntabs'],
						length = endp - tokenStartPosition['pos']
					)
					token = result + (ti,)
					tokens.append(token)

				break

		return None


	# считать очередной символ
	def getc(self):
		x = self.f.read(1)
		if x == '\n':
			self.line_fpos = self.f.tell()
			self.space_pos = 0
			self.tab_pos = 0
			self.line = self.line + 1
		elif x == '\t':
			self.tab_pos = self.tab_pos + 1
		else:
			self.space_pos = self.space_pos + 1
		return x


	# считать n следующих символов
	def getn(self, n):
		s = []
		i = 0
		while i < n:
			c = self.getc()
			s.append(c)
			i = i + 1
		return "".join(s)


	# получить текущую позицию в файле (точка сохранения)
	def getTextPosition(self):
		return {
			'isa': 'text_position',
			'pos': self.f.tell(),
			'line': self.line,
			'nspaces': self.space_pos,
			'ntabs': self.tab_pos
		}

	# установить позицию в файле (возврат на позицию)
	def setTextPosition(self, pos):
		self.f.seek(pos['pos'], 0)
		self.line = pos['line']
		self.space_pos = pos['nspaces']
		self.tab_pos = pos['ntabs']


	# посмотреть n символов вперед
	def peep(self, n=1):
		fpos = self.f.tell()
		c = self.f.read(n)
		self.f.seek(fpos, 0)
		return c


	def skip(self):
		self.getc()


	def skipn(self, n):
		self.getn(n=n)



class CmLexer(Lexer):
	def __init__(self):
		lexicalRules = (
			self.doBlank,
			self.doNewline,
			self.doId,
			self.doNumber,
			self.doLineComment,
			self.doBlockComment,
			self.doOperator3,
			self.doOperator2,
			self.doOperator1,
			self.doString,
			self.doAttribute,
			self.doDirective,
			self.doTag,
			self.doBadSymbol,
		)
		super().__init__(lexicalRules)


	#
	# Lexical Rules
	#


	# Rule returns False in case if it wasnt triggered
	# And Product/None in case if it was triggered

	# пробелы и табы не попадают в аутпут
	def doBlank(self):
		c = self.peep()
		if c == ' ' or c == '\t':
			self.skip()
			return None
		return False


	def doNewline(self):
		c = self.peep()
		if c != '\n':
			return False
		self.skip()  # '\n'
		return ('nl', '\n')


	def doId(self):
		c = self.peep()

		if not (c.isalpha() or c == '_'):
			return False

		s = ""
		while isIdChar(c):
			s = s + str(self.getc())
			c = self.peep()


		isa = 'id'
		for c in s:
			if c.isalpha():
				if c.isupper():
					isa = 'Id'
				break

		return (isa, s)


	def doNumber(self):
		c = self.peep(2)

		if not c[0].isdigit():
			return False

		ishex = False
		isfloat = False

		if len(c) > 1:
			ishex = c[1] == 'x'

		s = []

		if ishex:
			s.append(self.getc())
			s.append(self.getc())

		while True:
			sp = self.getTextPosition()
			c = self.getc()

			if c == '_':
				continue

			if c == '.':
				isfloat = True
				s.append(c)
				continue

			if not (c.isdigit() or (ishex and isHexDigit(c))):
				self.setTextPosition(sp)
				break

			s.append(c)

		return ('num', ''.join(s))


	def doOperator1(self):
		operators1 = (
			'*', ',', '=', '.', ':', '(', ')', '+', '-', '/',
			'&', '<', '>', '[', ']', '{', '}', '%', ';'
		)

		if self.peep() in operators1:
			s = self.getc()
			return ('op', s)

		return False


	def doOperator2(self):
		operators2 = (
			'==', '!=', '<=', '>=', '::',
			'<-', '->', '=>', '<<', '>>',
			'++', '--'
		)

		if self.peep(2) in operators2:
			s = self.getn(2)
			return ('op', s)

		return False


	def doOperator3(self):
		operators3 = (
			'<<=', '>>=', '...'
		)

		if self.peep(3) in operators3:
			s = self.getn(3)
			return ('op', s)

		return False


	def doString(self):
		c = self.peep()
		if c != '"' and c != "'":
			return False

		quote = self.getc()  # get start quote

		# Если в строке встречается экранирующий слэш
		# Он и то что он экранирует (следующий символ) попадут в рез. строку
		# (ост. работу сделает уже парсер)
		s = []
		while True:
			c = self.getc()

			if c == '\\':
				s.append(c)
				# следующий символ заэкранирован и как есть попадет в строку
				# (даже если это закр кавычка)
				c = self.getc()

			elif c == quote:
				break  # endstring

			s.append(c)

		ss = ''.join(s)
		# добавляем " чтобы match в парсере не путал "+" с оператором + (!)
		# поскольку match не учитывает класс
		return ('str', ss)


	def doTag(self):
		c = self.peep()

		if c != '#':
			return False

		self.skip()  # '#'

		s = []
		while True:
			sp = self.getTextPosition()
			c = self.getc()
			if not isIdChar(c):
				self.setTextPosition(sp)
				break
			s.append(c)

		return ('tag', ''.join(s))


	def doAttribute(self):
		s = self.peep()
		if s != '@':
			return False

		self.skip()  # '@'

		s = []
		while True:
			sp = self.getTextPosition()
			c = self.getc()
			if not isIdChar(c):
				self.setTextPosition(sp)
				break
			s.append(c)

		return ('annotation', ''.join(s))


	def doDirective(self):
		s = self.peep()
		if s != '$':
			return False

		self.skip()  # '$'

		s = []
		while True:
			sp = self.getTextPosition()
			c = self.getc()
			if not isIdChar(c):
				self.setTextPosition(sp)
				break
			s.append(c)

		return ('directive', ''.join(s))


	def doLineComment(self):
		if self.peep(2) != '//':
			return False

		self.skipn(2)  # skip '//'

		lines = []

		commtext = ""

		while True:
			# we dont need to eat NL because it will be used by lexer (!)
			c = self.peep()
			if c == '\n':
				lines.append({'str': commtext})

				s = self.peep(3)
				if s == '\n//':
					self.skipn(3)
					commtext = ""
					continue

				break
			else:
				commtext += c

			self.skip()

		return ('comment-line', lines)


	def doBlockComment(self):
		if self.peep(2) != '/*':
			return False

		self.skipn(2)  # '/*'

		text = ""

		while True:
			c = self.getc()
			if c == "*":
				if self.peep() == "/":
					self.skip()  # '/'
					break
			text = text + c

		return ('comment-block', text)


	def doBadSymbol(self):
		tp = self.getTextPosition()
		ti = TokenInfo(self.filename, tp, tp)
		c = self.getc()
		error("unexpected symbol '%c'" % c, ti)
		return ('badsym', c)


