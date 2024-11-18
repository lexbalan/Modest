
from error import info
from .tokenizer import Tokenizer


line = 1
pos = 1


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

# Rule returns Product/None in case if it was triggered
# And False in case if it wasnt triggered


def doBlank(src):
	c = src.lookup(1)
	if (c == ' ' or c == '\t'):
		src.getc()
		return None
	return False



def doNewline(src):
	ti = src.get_ti()
	c = src.lookup(1)
	if not c == '\n':
		return False
	src.getc()

	global line, pos
	line = line + 1
	pos = 1

	ti['len'] = 0
	return ('nl', '\n', ti)



def doId(src):
	c = src.lookup(1)

	if not (c.isalpha() or c == '_'):
		return False

	ti = src.get_ti()
	s = []
	while True:
		j = src.getpos()
		c = src.getc()
		if not (c.isalpha() or c.isdigit() or c == '_'):
			src.setpos(j)
			break
		s.append(c)

	token = ''.join(s)
	ti['len'] = len(token)
	return ('id', token, ti)


def doNumber(src):
	isfloat = False
	c = src.lookup(2)
	if not c[0].isdigit():
		return False
	ti = src.get_ti()
	ishex = False
	if len(c) > 1:
		ishex = c[1] == 'x'

	s = []

	if ishex:
		s.append(src.getc())
		s.append(src.getc())


	while True:
		j = src.getpos()
		c = src.getc()

		if c == '_':
			continue

		if c == '.':
			isfloat = True
			s.append(c)
			continue

		if not (c.isdigit() or (ishex and c in ('a', 'b', 'c', 'd', 'e', 'f', 'A', 'B', 'C', 'D', 'E', 'F'))):
			src.setpos(j)
			break
		s.append(c)

	token = ''.join(s)
	ti['len'] = len(token)
	return ('num', token, ti)



def doOperator2(src):
	ti = src.get_ti()
	s = src.getn(2)
	if s in operators2:
		ti['len'] = 2
		return ('op', s, ti)
	return False


def doOperator3(src):
	ti = src.get_ti()
	s = src.getn(3)
	if s in operators3:
		ti['len'] = 3
		return ('op', s, ti)
	return False


def doOperator1(src):
	ti = src.get_ti()
	s = src.getc()
	if s in operators1:
		ti['len'] = 1
		return ('op', s, ti)
	return False


def doString(src):
	ti = src.get_ti()
	c = src.lookup(1)
	if c != '"' and c != "'":
		return False

	quote = src.getc()  # get first quote

	# Если в строке встречается экранирующий слэш
	# Он и то что он экранирует (следующий символ) попадут в рез. строку
	# (ост. работу сделает уже парсер)
	s = []
	while True:
		c = src.getc()

		if c == '\\':
			s.append(c)
			# следующий символ заэкранирован и как есть попадет в строку
			# (даже если это закр кавычка)
			c = src.getc()

		elif c == quote:
			break  # endstring

		s.append(c)

	# добавляем " чтобы match в парсере не путал "+" с оператором + (!)
	# поскольку match не учитывает класс
	token = ''.join(s)
	ti['len'] = len(token) + 2  # "
	return ('str', token, ti)



def doTag(src):
	c = src.lookup(1)

	if c != '#':
		return False

	src.getc()

	ti = src.get_ti()
	s = []
	while True:
		j = src.getpos()
		c = src.getc()
		if not (c.isalpha() or c.isdigit() or c == '_'):
			src.setpos(j)
			break
		s.append(c)

	token = ''.join(s)
	ti['len'] = len(token)
	return ('tag', token, ti)


def doAttribute(src):
	global line, pos

	s = src.lookup(1)
	if s != '@':
		return False


	src.getc()

	ti = src.get_ti()
	s = []
	while True:
		j = src.getpos()
		c = src.getc()
		if not (c.isalpha() or c.isdigit() or c == '_'):
			src.setpos(j)
			break
		s.append(c)

	token = ''.join(s)
	ti['len'] = len(token)
	return ('attribute', token, ti)


def doDirective(src):
	global line, pos

	s = src.lookup(1)
	if s != '$':
		return False

	src.getc()

	ti = src.get_ti()
	s = []
	while True:
		j = src.getpos()
		c = src.getc()
		if not (c.isalpha() or c.isdigit() or c == '_'):
			src.setpos(j)
			break
		s.append(c)

	token = ''.join(s)
	ti['len'] = len(token)
	return ('directive', token, ti)



def doLineComment(src):
	global line, pos

	s = src.lookup(2)
	if s != '//':
		return False

	ti = src.get_ti()

	# skip '//'
	src.getc()
	src.getc()

	lines = []

	commtext = ""

	while True:

		# we dont need to eat NL because it will be used by lexer (!)
		c = src.lookup(1)
		if c == '\n':
			lines.append({'str': commtext})

			s = src.lookup(3)
			if s == '\n//':
				src.getc()
				src.getc()
				src.getc()
				commtext = ""
				continue

			break
		else:
			commtext += c

		src.getc()

	ti['len'] = 0
	return ('comment-line', lines, ti)

	return None



def doBlockComment(src):
	global line, pos
	global f

	s = src.lookup(2)
	if s != '/*':
		return False

	ti = src.get_ti()

	src.getc() # /
	src.getc() # *

	text = ""

	while True:
		c = src.getc()
		if c == "\n":
			line = line + 1
			pos = 1
		elif c == "*":
			if src.lookup(1) == "/":
				src.getc() # skip "/"
				break
		text = text + c

	ti['len'] = 0 #!
	return ('comment-block', text, ti)



def doBadSymbol(src):
	ti = src.get_ti()
	c = src.getc()
	ti['len'] = 1
	return ('badsym', c, ti)



class Lexer:
	def __init__(self):

		rules = (
			doBlank,
			doNewline,
			doId,
			doNumber,
			doLineComment,
			doBlockComment,
			doOperator3,
			doOperator2,
			doOperator1,
			doString,
			doAttribute,
			doDirective,
			doTag,
			doBadSymbol,
		)

		self.tokenizer = Tokenizer(rules)


	def tokenize(self, source):
		return self.tokenizer.run(source)


