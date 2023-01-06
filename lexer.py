

from source import Source
from tokenizer import Tokenizer

fname = ""
line = 1
pos = 1

def get_ti(src):
  #global line, pos
  #global pos
  #return {'file': fname, 'line': line, 'pos': pos}
  return src.get_ti()

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
  if not c.isalpha() or c == '_':
    return False
  
  ti = get_ti(src)
  s = []
  while True:
    j = src.getpos()
    c = src.getc()
    if not (c.isalpha() or c.isdigit() or c == '_'):
      src.setpos(j)
      break
    s.append(c)
  
  token = ''.join(s)
  return ('id', token, ti)


def donum(src):
  c = src.lookup(2)
  if not c[0].isdigit():
    return False
  ti = get_ti(src)
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
    if not (c.isdigit() or (ishex and c in ['a', 'b', 'c', 'd', 'e', 'f'])):
      src.setpos(j)
      break
    s.append(c)
  
  token = ''.join(s)
  return ('num', token, ti)


def dosym(src):
  c0, c1 = src.lookup(2)
  #or c0 == '.'
  if not ((c0 == '#') and (c1.isalpha() or c1.isdigit())):
    return False
  
  ti = get_ti(src)
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
  return ('sym', token, ti)


def doop2(src):
  ti = get_ti(src)
  s = src.getn(2)
  if s in operators2:
    return ('op', s, ti)
  
  return False


def doop1(src):
  ti = get_ti(src)
  s = src.getc()
  if s in operators1:
    return ('op', s, ti)
  
  return False




def doblank(src):
  c = src.getc()
  if not c == ' ' or c == '\t':
    return False
  return None


def dostr(src):
  c = src.getc()
  if not c == '"':
    return False
  
  ti = get_ti(src)
  
  par = c
  
  s = []
  while True:
    c = src.getc()
    if c == par:
      break
    s.append(c)
    
  
  token = ''.join(s)
  return ('str', token, ti)


def dolcom(src):
  global line, pos
  s = src.lookup(2)
  if not s == '//':
    return False
  
  # skip '//'
  src.getc()
  src.getc()

  s = []
  while True:
    # we dont need to eat NL because it will be used by lexer (!)
    c = src.lookup(1)
    if c == '\n':
      line = line + 1
      pos = 1
      break
    src.getc()
    s.append(c)
  
  token = ''.join(s)
  return None #('lcom', token)



def dobcom(src):
  global line, pos
  global f
  
  s = src.lookup(2)
  if not s == '/*':
    return False
  
  bcomlvl = 0
  
  while True:
    s = src.getc()
    if s == '/':
      if src.getc() == '*':
        bcomlvl = bcomlvl + 1
    elif s == '*':
      if src.getc() == '/':
        bcomlvl = bcomlvl - 1
        if bcomlvl == 0:
          break
    elif s == '\n':
      line = line + 1
      pos = 1
    elif s == '':
      print("unexpected end of file")
      exit(1)
  
  return None #('bcom', token)


def donl(src):
  c = src.getc()
  if not c == '\n':
    return False
  
  global line, pos
  line = line + 1
  pos = 1
  return ('nl', '\n', get_ti(src))


def dobadsym(src):
  ti = get_ti(src)
  c = src.getc()
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
      dobadsym,
    )
    
    self.tokenizer = Tokenizer(rules)

   
  def tokenize(self, filename):
    global fname
    fname = filename
    src = Source(filename)
    return self.tokenizer.tokenize(src)


