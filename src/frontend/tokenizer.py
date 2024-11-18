
from error import info


operators1 = (
	'(', ')', '[', ']', '{', '}', ',', '.', ':', ';',
	'=', '+', '-', '/', '*', '%%', '&', '<', '>'
)

operators2 = (
	'==', '!=', '<=', '>=', '::',
	'<-', '->', '=>', '<<', '>>',
	'++', '--'
)

operators3 = (
	'<<=', '>>=', '...'
)


class Tokenizer:
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


	def tokenize(self, source):
		self.src = source
		tokens = []
		while True:

			# EOF?
			if self.src.lookup(1) == '':
				return tokens

			pos_before = self.src.getpos()
			for rule in self.rules:
				result = rule()

				if result == False:
					self.src.setpos(pos_before)
					continue

				if result != None:
					tokens.append(result)

				break

		return None


	#
	# Lexical Rules
	#


	# Rule returns Product/None in case if it was triggered
	# And False in case if it wasnt triggered


	def doBlank(self):
		c = self.src.lookup(1)
		if (c == ' ' or c == '\t'):
			self.src.getc()
			return None
		return False



	def doNewline(self):
		ti = self.src.get_ti()
		c = self.src.lookup(1)
		if not c == '\n':
			return False
		self.src.getc()
		ti['len'] = 0
		return ('nl', '\n', ti)



	def doId(self):
		c = self.src.lookup(1)

		if not (c.isalpha() or c == '_'):
			return False

		ti = self.src.get_ti()
		s = []
		while True:
			j = self.src.getpos()
			c = self.src.getc()
			if not (c.isalpha() or c.isdigit() or c == '_'):
				self.src.setpos(j)
				break
			s.append(c)

		token = ''.join(s)
		ti['len'] = len(token)
		return ('id', token, ti)


	def doNumber(self):
		isfloat = False
		c = self.src.lookup(2)
		if not c[0].isdigit():
			return False
		ti = self.src.get_ti()
		ishex = False
		if len(c) > 1:
			ishex = c[1] == 'x'

		s = []

		if ishex:
			s.append(self.src.getc())
			s.append(self.src.getc())


		while True:
			j = self.src.getpos()
			c = self.src.getc()

			if c == '_':
				continue

			if c == '.':
				isfloat = True
				s.append(c)
				continue

			if not (c.isdigit() or (ishex and c in ('a', 'b', 'c', 'd', 'e', 'f', 'A', 'B', 'C', 'D', 'E', 'F'))):
				self.src.setpos(j)
				break
			s.append(c)

		token = ''.join(s)
		ti['len'] = len(token)
		return ('num', token, ti)



	def doOperator2(self):
		ti = self.src.get_ti()
		s = self.src.getn(2)
		if s in operators2:
			ti['len'] = 2
			return ('op', s, ti)
		return False


	def doOperator3(self):
		ti = self.src.get_ti()
		s = self.src.getn(3)
		if s in operators3:
			ti['len'] = 3
			return ('op', s, ti)
		return False


	def doOperator1(self):
		ti = self.src.get_ti()
		s = self.src.getc()
		if s in operators1:
			ti['len'] = 1
			return ('op', s, ti)
		return False


	def doString(self):
		ti = self.src.get_ti()
		c = self.src.lookup(1)
		if c != '"' and c != "'":
			return False

		quote = self.src.getc()  # get first quote

		# Если в строке встречается экранирующий слэш
		# Он и то что он экранирует (следующий символ) попадут в рез. строку
		# (ост. работу сделает уже парсер)
		s = []
		while True:
			c = self.src.getc()

			if c == '\\':
				s.append(c)
				# следующий символ заэкранирован и как есть попадет в строку
				# (даже если это закр кавычка)
				c = self.src.getc()

			elif c == quote:
				break  # endstring

			s.append(c)

		# добавляем " чтобы match в парсере не путал "+" с оператором + (!)
		# поскольку match не учитывает класс
		token = ''.join(s)
		ti['len'] = len(token) + 2  # "
		return ('str', token, ti)



	def doTag(self):
		c = self.src.lookup(1)

		if c != '#':
			return False

		self.src.getc()

		ti = self.src.get_ti()
		s = []
		while True:
			j = self.src.getpos()
			c = self.src.getc()
			if not (c.isalpha() or c.isdigit() or c == '_'):
				self.src.setpos(j)
				break
			s.append(c)

		token = ''.join(s)
		ti['len'] = len(token)
		return ('tag', token, ti)


	def doAttribute(self):
		global line, pos

		s = self.src.lookup(1)
		if s != '@':
			return False


		self.src.getc()

		ti = self.src.get_ti()
		s = []
		while True:
			j = self.src.getpos()
			c = self.src.getc()
			if not (c.isalpha() or c.isdigit() or c == '_'):
				self.src.setpos(j)
				break
			s.append(c)

		token = ''.join(s)
		ti['len'] = len(token)
		return ('attribute', token, ti)


	def doDirective(self):
		global line, pos

		s = self.src.lookup(1)
		if s != '$':
			return False

		self.src.getc()

		ti = self.src.get_ti()
		s = []
		while True:
			j = self.src.getpos()
			c = self.src.getc()
			if not (c.isalpha() or c.isdigit() or c == '_'):
				self.src.setpos(j)
				break
			s.append(c)

		token = ''.join(s)
		ti['len'] = len(token)
		return ('directive', token, ti)



	def doLineComment(self):
		global line, pos

		s = self.src.lookup(2)
		if s != '//':
			return False

		ti = self.src.get_ti()

		# skip '//'
		self.src.getc()
		self.src.getc()

		lines = []

		commtext = ""

		while True:

			# we dont need to eat NL because it will be used by lexer (!)
			c = self.src.lookup(1)
			if c == '\n':
				lines.append({'str': commtext})

				s = self.src.lookup(3)
				if s == '\n//':
					self.src.getc()
					self.src.getc()
					self.src.getc()
					commtext = ""
					continue

				break
			else:
				commtext += c

			self.src.getc()

		ti['len'] = 0
		return ('comment-line', lines, ti)

		return None



	def doBlockComment(self):
		global line, pos
		global f

		s = self.src.lookup(2)
		if s != '/*':
			return False

		ti = self.src.get_ti()

		self.src.getc() # /
		self.src.getc() # *

		text = ""

		while True:
			c = self.src.getc()
			if c == "\n":
				pass
			elif c == "*":
				if self.src.lookup(1) == "/":
					self.src.getc() # skip "/"
					break
			text = text + c

		ti['len'] = 0 #!
		return ('comment-block', text, ti)



	def doBadSymbol(self):
		ti = self.src.get_ti()
		c = self.src.getc()
		ti['len'] = 1
		return ('badsym', c, ti)


