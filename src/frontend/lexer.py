
from error import info

from .source import Source
from .tokenizer import Tokenizer


fname = ""
line = 1
pos = 1


operators1 = [
    '(', ')', '[', ']', '{', '}', ',', '.', '#', ':', ';',
    '=', '+', '-', '/', '*', '%%', '&', '<', '>'
]

operators2 = [
    '==', '!=', '<=', '>=', ':=', '::',
    '<-', '->', '=>', '<<', '>>',
    '++', '--', '<<=', '>>='
]


def doid(src):
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


def donum(src):
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

        if c == '.':
            isfloat = True
            s.append(c)
            continue

        if not (c.isdigit() or (ishex and c in ['a', 'b', 'c', 'd', 'e', 'f', 'A', 'B', 'C', 'D', 'E', 'F'])):
            src.setpos(j)
            break
        s.append(c)

    token = ''.join(s)
    ti['len'] = len(token)
    return ('num', token, ti)


def dosym(src):
    c0, c1 = src.lookup(2)
    #or c0 == '.'
    if not ((c0 == '#') and (c1.isalpha() or c1.isdigit())):
        return False

    ti = src.get_ti()
    #print("dosym")
    # skip '#' / '.'
    src.getc()

    s = []
    while True:
        j = src.getpos()
        c = src.getc()
        if not (c.isalpha() or c.isdigit()):
            src.setpos(j)
            break
        s.append(c)

    token = ''.join(s)
    ti['len'] = len(token)

    return ('sym', token, ti)


def doop2(src):
    ti = src.get_ti()
    s = src.getn(2)
    if s in operators2:
        ti['len'] = 2
        return ('op', s, ti)

    return False


def doop1(src):
    ti = src.get_ti()
    s = src.getc()
    if s in operators1:
        ti['len'] = 1
        return ('op', s, ti)

    return False


def doblank(src):
    c = src.getc()
    if not (c == ' ' or c == '\t'):
        return False
    return None


def dostr(src):
    ti = src.get_ti()
    c = src.getc()
    if not c == '"':
        return False

    par = c

    s = []
    while True:
        c = src.getc()
        if c == '\\':
            s.append(c)
            c = src.getc()
        elif c == par:
            break
        s.append(c)

    # добавляем " чтобы match в парсере не путал "+" с оператором + (!)
    # поскольку match не учитывает класс
    token = '"' + ''.join(s) + '"'
    ti['len'] = len(token) + 2    # "
    return ('str', token, ti)


def dodir(src):
    global line, pos

    s = src.lookup(1)
    if not s == '@':
        return False

    ti = src.get_ti()

    # skip '@'
    src.getc()

    text = ""
    while True:
        # we dont need to eat NL because it will be used by lexer (!)
        c = src.lookup(1)
        if c == '\n':
            line = line + 1
            pos = 1
            break
        else:
            text += c
            src.getc()

            if len(text) == 2:
                if text == 'if':
                    #print("-IF")
                    return ('directive_if', text, ti)
            elif len(text) == 4:
                if text == 'else':
                    c = src.lookup(2)
                    if c == 'if':
                        continue
                    #print("-ELSE")
                    return ('directive_else', text, ti)
            elif len(text) == 5:
                if text == 'endif':
                    #print("-ENDIF")
                    return ('directive_endif', text, ti)
            elif len(text) == 6:
                if text == 'elseif':
                    #print("-ELSEIF")
                    return ('directive_elseif', text, ti)



    return ('directive', text, ti)




def dolcom(src):
    global line, pos

    s = src.lookup(2)
    if not s == '//':
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



def dobcom(src):
    global line, pos
    global f

    s = src.lookup(2)
    if not s == '/*':
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



def donl(src):
    ti = src.get_ti()
    c = src.getc()
    if not c == '\n':
        return False

    global line, pos
    line = line + 1
    pos = 1

    ti['len'] = 0
    return ('nl', '\n', ti)


def dobadsym(src):
    ti = src.get_ti()
    c = src.getc()
    ti['len'] = 1
    return ('badsym', c, ti)



class Lexer:
    def __init__(self):

        rules = (
            donl,
            doblank,
            doid,
            donum,
            dolcom,
            dobcom,
            doop2,
            doop1,
            dostr,
            dodir,
            dobadsym,
        )

        self.tokenizer = Tokenizer(rules)


    def tokenize(self, filename):
        global fname
        fname = filename
        src = Source(filename)
        return self.tokenizer.tokenize(src)


