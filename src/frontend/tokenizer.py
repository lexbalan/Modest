
from error import info

# used for ti
TAB_STOP = 4



class Tokenizer:
	def __init__(self):
		pass

	def tokenize(self, filename):
		self.f = open(filename, "r")
		self.filename = filename
		self.pos = 0
		self.line = 1

		tokens = []
		while True:

			# EOF?
			if self.lookup(1) == '':
				return tokens

			pos_before = self.getpos()
			for rule in self.rules:
				result = rule()

				if result == False:
					self.setpos(pos_before)
					continue

				if result != None:
					tokens.append(result)

				break

		return None



	# считать очередной символ
	def getc(self):
		x = self.f.read(1)
		if x == '\n':
			self.pos = 0
			self.line = self.line + 1
		elif x == '\t':
			self.pos = self.pos + TAB_STOP
		else:
			self.pos = self.pos + 1
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


	# получить позицию в файле
	def getpos(self):
		x = self.f.tell()
		return (x, self.line, self.pos)


	# установить позицию в файле
	def setpos(self, pos):
		self.line = pos[1]
		self.pos = pos[2]
		self.f.seek(pos[0], 0)


	def get_ti(self):
		return {
			'isa': 'ti',
			'file': self.filename,
			'line': self.line,
			'len': 0,
			'pos': self.pos
		}


	# посмотреть n символов вперед
	def lookup(self, n):
		pos = self.getpos()
		c = self.f.read(n)
		self.setpos(pos)
		return c




class CmTokenizer(Tokenizer):
	def __init__(self):
		self.rules = (
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

		self.operators1 = (
			'(', ')', '[', ']', '{', '}', ',', '.', ':', ';',
			'=', '+', '-', '/', '*', '%%', '&', '<', '>'
		)

		self.operators2 = (
			'==', '!=', '<=', '>=', '::',
			'<-', '->', '=>', '<<', '>>',
			'++', '--'
		)

		self.operators3 = (
			'<<=', '>>=', '...'
		)

		self.hexDigits = ('a', 'b', 'c', 'd', 'e', 'f', 'A', 'B', 'C', 'D', 'E', 'F')


	#
	# Lexical Rules
	#


	# Rule returns Product/None in case if it was triggered
	# And False in case if it wasnt triggered

	def doBlank(self):
		c = self.lookup(1)
		if (c == ' ' or c == '\t'):
			self.getc()
			return None
		return False


	def doNewline(self):
		ti = self.get_ti()
		c = self.lookup(1)
		if not c == '\n':
			return False
		self.getc()
		ti['len'] = 0
		return ('nl', '\n', ti)


	def doId(self):
		c = self.lookup(1)

		if not (c.isalpha() or c == '_'):
			return False

		ti = self.get_ti()
		s = []
		while True:
			j = self.getpos()
			c = self.getc()
			if not (c.isalpha() or c.isdigit() or c == '_'):
				self.setpos(j)
				break
			s.append(c)

		token = ''.join(s)
		ti['len'] = len(token)
		return ('id', token, ti)


	def doNumber(self):
		isfloat = False
		c = self.lookup(2)
		if not c[0].isdigit():
			return False
		ti = self.get_ti()
		ishex = False
		if len(c) > 1:
			ishex = c[1] == 'x'

		s = []

		if ishex:
			s.append(self.getc())
			s.append(self.getc())


		while True:
			j = self.getpos()
			c = self.getc()

			if c == '_':
				continue

			if c == '.':
				isfloat = True
				s.append(c)
				continue

			if not (c.isdigit() or (ishex and c in self.hexDigits)):
				self.setpos(j)
				break
			s.append(c)

		token = ''.join(s)
		ti['len'] = len(token)
		return ('num', token, ti)


	def doOperator2(self):
		ti = self.get_ti()
		s = self.getn(2)
		if s in self.operators2:
			ti['len'] = 2
			return ('op', s, ti)
		return False


	def doOperator3(self):
		ti = self.get_ti()
		s = self.getn(3)
		if s in self.operators3:
			ti['len'] = 3
			return ('op', s, ti)
		return False


	def doOperator1(self):
		ti = self.get_ti()
		s = self.getc()
		if s in self.operators1:
			ti['len'] = 1
			return ('op', s, ti)
		return False


	def doString(self):
		ti = self.get_ti()
		c = self.lookup(1)
		if c != '"' and c != "'":
			return False

		quote = self.getc()  # get first quote

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

		# добавляем " чтобы match в парсере не путал "+" с оператором + (!)
		# поскольку match не учитывает класс
		token = ''.join(s)
		ti['len'] = len(token) + 2  # "
		return ('str', token, ti)


	def doTag(self):
		c = self.lookup(1)

		if c != '#':
			return False

		self.getc()

		ti = self.get_ti()
		s = []
		while True:
			j = self.getpos()
			c = self.getc()
			if not (c.isalpha() or c.isdigit() or c == '_'):
				self.setpos(j)
				break
			s.append(c)

		token = ''.join(s)
		ti['len'] = len(token)
		return ('tag', token, ti)


	def doAttribute(self):
		global line, pos

		s = self.lookup(1)
		if s != '@':
			return False


		self.getc()

		ti = self.get_ti()
		s = []
		while True:
			j = self.getpos()
			c = self.getc()
			if not (c.isalpha() or c.isdigit() or c == '_'):
				self.setpos(j)
				break
			s.append(c)

		token = ''.join(s)
		ti['len'] = len(token)
		return ('attribute', token, ti)


	def doDirective(self):
		global line, pos

		s = self.lookup(1)
		if s != '$':
			return False

		self.getc()

		ti = self.get_ti()
		s = []
		while True:
			j = self.getpos()
			c = self.getc()
			if not (c.isalpha() or c.isdigit() or c == '_'):
				self.setpos(j)
				break
			s.append(c)

		token = ''.join(s)
		ti['len'] = len(token)
		return ('directive', token, ti)


	def doLineComment(self):
		global line, pos

		s = self.lookup(2)
		if s != '//':
			return False

		ti = self.get_ti()

		# skip '//'
		self.getc()
		self.getc()

		lines = []

		commtext = ""

		while True:

			# we dont need to eat NL because it will be used by lexer (!)
			c = self.lookup(1)
			if c == '\n':
				lines.append({'str': commtext})

				s = self.lookup(3)
				if s == '\n//':
					self.getc()
					self.getc()
					self.getc()
					commtext = ""
					continue

				break
			else:
				commtext += c

			self.getc()

		ti['len'] = 0
		return ('comment-line', lines, ti)

		return None


	def doBlockComment(self):
		global line, pos
		global f

		s = self.lookup(2)
		if s != '/*':
			return False

		ti = self.get_ti()

		self.getc() # /
		self.getc() # *

		text = ""

		while True:
			c = self.getc()
			if c == "\n":
				pass
			elif c == "*":
				if self.lookup(1) == "/":
					self.getc() # skip "/"
					break
			text = text + c

		ti['len'] = 0 #!
		return ('comment-block', text, ti)


	def doBadSymbol(self):
		ti = self.get_ti()
		c = self.getc()
		ti['len'] = 1
		return ('badsym', c, ti)


