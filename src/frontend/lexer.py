
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
    '==', '!=', '<=', '>=', '=', '::',
    '<-', '->', '=>', '<<', '>>',
    '++', '--', '<<=', '>>='
]


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



def doOperation2(src):
    ti = src.get_ti()
    s = src.getn(2)
    if s in operators2:
        ti['len'] = 2
        return ('op', s, ti)

    return False



def doOperation1(src):
    ti = src.get_ti()
    s = src.getc()
    if s in operators1:
        ti['len'] = 1
        return ('op', s, ti)

    return False



def doString(src):
    ti = src.get_ti()
    c = src.lookup(1)
    if not (c == '"' or c == "'"):
        return False

    src.getc()

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
    ti['len'] = len(token) + 2  # "
    return ('str', token, ti)



def doDirective(src):
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
                    break
            elif len(text) == 4:
                if text == 'else':
                    c = src.lookup(2)
                    if c != 'if':
                        break
                elif text == 'info':
                    break
            elif len(text) == 5:
                if text == 'endif':
                    break
                if text == 'error':
                    break
            elif len(text) == 6:
                if text == 'elseif':
                    break
                #if text == 'pragma':
                #    break
            elif len(text) == 7:
                if text == 'warning':
                    break

    return ('directive', text, ti)



def doLineComment(src):
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



def doBlockComment(src):
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
            doOperation2,
            doOperation1,
            doString,
            doDirective,
            doBadSymbol,
        )

        self.tokenizer = Tokenizer(rules)


    def run(self, filename):
        global fname
        fname = filename
        src = Source(filename)
        return self.tokenizer.run(src)



"""def doSymbol(src):
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

    return ('sym', token, ti)"""

