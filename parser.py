#####################################################################
#                            PARSER                                 #
#####################################################################

# https://habr.com/ru/post/693562/

from lexer import Lexer
from error import warning, error, getline


class Parser:
  def __init__(self):
    self.lex = Lexer()
    self.skipnl = True
    
  def is_end(self):
    if self.tokens[self.ctoken][1] == '':
      return True
    return self.ctoken >= (len(self.tokens) - 1)
  
  def is_blank(self, c):
    return c == ' ' or c == '\t' or c == '\n' and self.skipnl
  
  def skip(self):
    if self.ctoken < (len(self.tokens) - 1):
      self.ctoken = self.ctoken + 1
  
  def ctok_class(self):
    return self.tokens[self.ctoken][0]
  
  def ctok(self):
    return self.tokens[self.ctoken][1]
  
  def ti(self):
    try:
      return self.tokens[self.ctoken][2]
    except:
      print(self.tokens[self.ctoken])
    
  
  def gettok(self):
    t = self.ctok()
    self.skip()
    return t
  
  def skip_blanks(self):
    while self.is_blank(self.ctok()):
      self.skip()
  
  def look(self, token):
    self.skip_blanks()
    return self.ctok() == token
  
  def match(self, token):
    yes = self.look(token)
    if yes:
      self.skip()
    return yes
  
  def need(self, token):
    ti = self.ti()
    yes = self.match(token)
    if not yes:
      error("expected '%s' token" % token, ti)
    return yes

  
  def identifier(self):
    ti = self.ti()
    s = self.gettok()
    return {'isa': 'id', 'str': s, 'ti': ti}

  
  
  def open_sep(self):
    old_skipnl = self.skipnl
    self.skipnl = False
    return old_skipnl


  def close_sep(self, old_skipnl, stoppers=['}']):
    separator_ti = self.ti()
    if self.look("\n") or self.look(";"):
      self.skipnl = old_skipnl
      self.skip()
    elif self.ctok() in stoppers:
      pass
    else:
      error("expected separator", separator_ti)

    self.skipnl = old_skipnl


  #
  # Parse Type
  #
  
  def expr_type(self):
    ti = self.ti()
    if self.match("("):
      fields = []
      while not self.match(")"):
        f = self.parse_field()
        self.match(",")
        fields.append(f)
      #r = {'isa': 'type', 'kind': 'record', 'fields': fields}
  
      if self.match("->"):
        t = self.expr_type()
        return {'isa': 'type', 'kind': 'func', 'params': fields, 'to': t, 'ti': ti}
      else:
        error("???", ti)
      #  return r
    
    elif self.match("*"):
      t = self.expr_type()
      return {'isa': 'type', 'kind': 'pointer', 'to': t, 'ti': ti}
    
    elif self.match("record"):
      self.need("{")
      fields = []
      while not self.match("}"):
        old_skipnl = self.open_sep()
        f = self.parse_field()
        self.close_sep(old_skipnl)
        fields.append(f)
      return {'isa': 'type', 'kind': 'record', 'fields': fields, 'ti': ti}
    
    elif self.match("enum"):
      self.need("{")
      items = []
      while not self.match("}"):
        ti = self.ti()
        f = self.identifier()
        self.match(",")
        items.append({'isa': 'id', 'id': f, 'ti': ti})
      return {'isa': 'type', 'kind': 'enum', 'items': items, 'ti': ti}
    
    elif self.match("["):
      y = {'isa': 'type', 'kind': 'array', 'size': None, 'ti': ti}
      s = None
      if not self.match("]"):
        y['size'] = self.expr_value()
        self.need("]")
      y['of'] = self.expr_type()
      return y
    
    elif self.ctok_class() == 'id':
      id = self.identifier() # type by Name
      return {'isa': 'type', 'kind': 'id', 'id': id, 'ti': ti}
    

  
  
  
  def expr_value(self):
    return self.expr_value_0()

    
  def expr_value_0(self):
    v = self.expr_value_1()
    ti = self.ti()
    if self.match("or"):
      r = self.expr_value_1()
      return {'isa': 'value', 'kind': 'or', 'left': v, 'right': r, 'ti': ti}
    else:
      return v
  
  def expr_value_1(self):
    v = self.expr_value_2()
    ti = self.ti()
    if self.match("xor"):
      r = self.expr_value_2()
      return {'isa': 'value', 'kind': 'xor', 'left': v, 'right': r, 'ti': ti}
    else:
      return v
  
  def expr_value_2(self):
    v = self.expr_value_3()
    ti = self.ti()
    if self.match("and"):
      r = self.expr_value_3()
      return {'isa': 'value', 'kind': 'and', 'left': v, 'right': r, 'ti': ti}
    else:
      return v
  
  def expr_value_3(self):
    v = self.expr_value_4()
    while True:
      ti = self.ti()
      if self.match("=="):
        r = self.expr_value_4()
        v = {'isa': 'value', 'kind': 'eq', 'left': v, 'right': r, 'ti': ti}
      elif self.match("!="):
        r = self.expr_value_4()
        v = {'isa': 'value', 'kind': 'ne', 'left': v, 'right': r, 'ti': ti}
      else:
        break
    return v

  def expr_value_4(self):
    v = self.expr_value_5()
    while True:
      ti = self.ti()
      if self.match("<"):
        r = self.expr_value_5()
        v = {'isa': 'value', 'kind': 'lt', 'left': v, 'right': r, 'ti': ti}
      elif self.match(">"):
        r = self.expr_value_5()
        v = {'isa': 'value', 'kind': 'gt', 'left': v, 'right': r, 'ti': ti}
      if self.match("<="):
        r = self.expr_value_5()
        v = {'isa': 'value', 'kind': 'le', 'left': v, 'right': r, 'ti': ti}
      elif self.match(">="):
        r = self.expr_value_5()
        v = {'isa': 'value', 'kind': 'ge', 'left': v, 'right': r, 'ti': ti}
      else:
        break
    return v
        
  def expr_value_5(self):
    v = self.expr_value_6()
    while True:
      ti = self.ti()
      if self.match("<<"):
        r = self.expr_value_6()
        v = {'isa': 'value', 'kind': 'shl', 'left': v, 'right': r, 'ti': ti}
      elif self.match(">>"):
        r = self.expr_value_6()
        v = {'isa': 'value', 'kind': 'shr', 'left': v, 'right': r, 'ti': ti}
      else:
        break
    return v
  
  def expr_value_6(self):
    v = self.expr_value_7()
    while True:
      ti = self.ti()
      if self.match("+"):
        r = self.expr_value_7()
        v = {'isa': 'value', 'kind': 'add', 'left': v, 'right': r, 'ti': ti}
      elif self.match("-"):
        r = self.expr_value_7()
        v = {'isa': 'value', 'kind': 'sub', 'left': v, 'right': r, 'ti': ti}
      else:
        break
    return v
  
  def expr_value_7(self):
    v = self.expr_value_8()
    while True:
      ti = self.ti()
      if self.match("*"):
        r = self.expr_value_8()
        v = {'isa': 'value', 'kind': 'mul', 'left': v, 'right': r, 'ti': ti}
      elif self.match("/"):
        r = self.expr_value_8()
        v = {'isa': 'value', 'kind': 'div', 'left': v, 'right': r, 'ti': ti}
      elif self.match("%"):
        r = self.expr_value_8()
        v = {'isa': 'value', 'kind': 'mod', 'left': v, 'right': r, 'ti': ti}
      else:
        break
    return v
  
  def expr_value_8(self):
    v = self.expr_value_9()
    #while True:
    ti = self.ti()
    if self.match("to"):
      t = self.expr_type()
      v = {'isa': 'value', 'kind': 'to', 'value': v, 'type': t, 'ti': ti}

    return v
  
  
  def expr_value_9(self):
    ti = self.ti()
    if self.match("*"):
      v = self.expr_value_9()
      return {'isa': 'value', 'kind': 'deref', 'value': v, 'ti': ti}
    elif self.match("&"):
      v = self.expr_value_10()
      return {'isa': 'value', 'kind': 'ref', 'value': v, 'ti': ti}
    elif self.match("not"):
      v = self.expr_value_9()
      return {'isa': 'value', 'kind': 'not', 'value': v, 'ti': ti}
    elif self.match("+"):
      v = self.expr_value_10()
      return {'isa': 'value', 'kind': 'plus', 'value': v, 'ti': ti}
    elif self.match("-"):
      v = self.expr_value_10()
      return {'isa': 'value', 'kind': 'minus', 'value': v, 'ti': ti}
    elif self.match("sizeof"):
      self.match("(")
      t = self.expr_type()
      self.need(")")
      return {'isa': 'value', 'kind': 'sizeof', 'type': t, 'ti': ti}
    else:
      return self.expr_value_10()
  
  
  def expr_value_10(self):
    v = self.expr_value_11()
    while True:
      ti = self.ti()
      if self.match("("):
        args = []
        while not self.match(")"):
          a = self.expr_value()
          args.append(a)
          self.match(",")
        
        v = {'isa': 'value', 'kind': 'call', 'left': v, 'args': args, 'ti': ti}
      elif self.match("."):
        f = self.identifier()
        v = {'isa': 'value', 'kind': 'access', 'left': v, 'field': f, 'ti': ti}
      elif self.match("["):
        i = self.expr_value()
        self.need("]")
        v = {'isa': 'value', 'kind': 'index', 'left': v, 'index': i, 'ti': ti}
      else:
        return v
  
  
  def expr_value_11(self):
    ti = self.ti()
    if self.match("("):
      v = self.expr_value()
      self.need(")")
      return v
    return self.parse_value_term()
  
  

  def parse_value_term_comp(self, id, ti):
    ti2 = self.ti()

    old_skipnl = self.skipnl
    self.skipnl = True

    self.need("{")
    items = []
    while not self.match("}"):
      item_ti = self.ti()
      field_id = self.identifier()
      self.need("=")
      field_value = self.expr_value()
      self.match(",")
      item = {
        'isa': 'item',
        'id': field_id,
        'value': field_value,
        'ti': item_ti
      }
      items.append(item)

    self.skipnl = old_skipnl

    return {
      'isa': 'value',
      'kind': 'composite',
      'type': {'isa': 'type', 'kind': 'id', 'id': id, 'ti': ti},
      'items': items,
      'ti': ti2
    }


  def parse_value_term(self):
    ti = self.ti()
    if self.ctok_class() == 'id':
      id = self.identifier()
      if id['str'][0].islower():
        return {'isa': 'value', 'kind': 'id', 'id': id, 'ti': ti}
      else:
        return self.parse_value_term_comp(id, ti)
          
    elif self.ctok_class() == 'num':
      num = self.gettok()
      return {'isa': 'value', 'kind': 'num', 'num': num, 'ti': ti}
    elif self.ctok_class() == 'str':
      str = self.gettok()
      return {'isa': 'value', 'kind': 'str', 'str': str, 'ti': ti}
    elif self.ctok_class() == 'sym':
      num = self.gettok()
      return {'isa': 'value', 'kind': 'sym', 'sym': num, 'ti': ti}
    else:
      cl = self.ctok_class()
      x = self.gettok()
      tokstr = self.ctok()
      error("unexpected token '%s'" % tokstr, ti)
      self.skip()
      #print("BAD TOKEN " + x + ", class= "+ cl)
      return {'isa': 'value', 'kind': 'bad', 'ti': ti}
  
  

  
  def stmt(self):
    ti = self.ti()
    t = self.ctok()

    old_skipnl = self.open_sep()

    # skip nl's before
    while self.match("\n"):
      pass

    """print ("\n#stmt:")
    lin = getline(ti)
    print(lin)
    print("t="+self.ctok())
    input()"""

    if self.match('let'):
      #print("stmt_let")
      s = self.stmt_let()
    elif self.match('if'):
      #print("stmt_if")
      s = self.stmt_if()
    elif self.match('while'):
      #print("stmt_while")
      s = self.stmt_while()
    elif self.look('return'):
      #print("stmt_return")
      s = self.stmt_return()
    elif self.match('var'):
      #print("stmt_var")
      s = self.stmt_var()
    else:
      #print("stmt_expr/assign")
      s = self.stmt_expr_value()

    self.close_sep(old_skipnl)

      
    if s != None:
      if not 'ti' in s:
        s['ti'] = ti
    
    return s
      
  
  def stmt_var(self):
    ti = self.ti()
    id = self.identifier()
    
    t = None
    v = None
    if self.match(":"):
      t = self.expr_type()
    if self.match("<-"):
      v = self.expr_value()
    
    return {'isa': 'stmt', 'kind': 'var', 'id': id, 'type': t, 'value': v}


  def stmt_if(self):
    #print("stmt_if")
    c = self.expr_value()
    t = self.stmt_block()
    e = None
    if self.match('else'):
      if self.match('if'):
        e = self.stmt_if()
      else:
        e = self.stmt_block()
    return {'isa': 'stmt', 'kind': 'if', 'cond': c, 'then': t, 'else': e}
  
  
  def stmt_while(self):
    v = self.expr_value()
    b = self.stmt_block()
    return {'isa': 'stmt', 'kind': 'while', 'cond': v, 'stmt': b}
  
  
  def stmt_return(self):
#    old_skipnl = self.open_sep()

    self.skip()  # skip 'return' keyword

    v = None
    if not (self.look("\n") or self.look(";") or self.look("}")):
      v = self.expr_value()

#    self.close_sep(old_skipnl)

    return {'isa': 'stmt', 'kind': 'return', 'value': v}
  
  
  def stmt_expr_value(self):
    v = self.expr_value()
    
    # stmt expr
    assign_ti = self.ti()
    if not (self.match(":=") or self.match("<-")):
      return {'isa': 'stmt', 'kind': 'value', 'value': v}
    
    # stmt assign
    r = self.expr_value()
    return {'isa': 'stmt', 'kind': 'assign', 'left': v, 'right': r, 'ti': assign_ti}
  
  
  def stmt_let(self):
    id = self.identifier()
    self.need("=")
    r = self.expr_value()
    return {'isa': 'stmt', 'kind': 'let', 'id': id, 'value': r}
  
  
  def stmt_block(self):
    ti = self.ti()
    #print('stmt_block')
    self.need("{")
    stmts = []
    while not self.match("}"):
      s = self.stmt()
      stmts.append(s)
    return {'isa': 'stmt', 'kind': 'block', 'stmts': stmts, 'ti': ti}
  
  
  def parse_field(self):
    ti = self.ti()
    id = self.identifier()
    self.need(":")
    t = self.expr_type()
    return {'isa': 'field', 'id': id, 'type': t, 'ti': ti}
  
  
  #
  # Top Level Directives
  #
  
  def doimport(self):
    ti = self.ti()
    local = self.match("@")
    str = self.gettok()
    return {'isa': 'import', 'local': local, 'str': str, 'ti': ti}
  
  
  def decl_exist(self):
    f = self.parse_field()
    return {'isa': 'exist', 'field': f, 'ti': f['ti']}
  
  
  def decl_extern(self):
    f = self.parse_field()
    return {'isa': 'extern', 'field': f, 'ti': f['ti']}
  
  
  def def_func(self):
    ti = self.ti()
    id = self.identifier()
    t = self.expr_type()
    s = self.stmt_block()
    return {'isa': 'func', 'id': id, 'type': t, 'stmt': s, 'ti': ti}
    
  
  def def_const(self):
    ti = self.ti()
    id = self.identifier()
    self.need('=')
    v = self.expr_value()
    return {'isa': 'const', 'id': id, 'value': v, 'ti': ti}
  
  
  def def_var(self):
    f = self.parse_field()
    return {'isa': 'var', 'field': f, 'ti': f['ti']}
  
  
  def def_type(self):
    ti = self.ti()
    id = self.identifier()
    t = self.expr_type()
    return {'isa': 'type', 'id': id, 'type': t, 'ti': ti}
  
  
  def parse(self, filename):
    self.tokens = self.lex.tokenize(filename)
    self.ctoken = 0

    xx = []

    while self.match('import'):
      x = self.doimport()
      xx.append(x)
      
    while not self.is_end():
      export = self.match('export')
      x = None
      if self.match('func'):
        x = self.def_func()
      elif self.match('const'):
        x = self.def_const()
      elif self.match('var'):
        x = self.def_var()
      elif self.match('type'):
        x = self.def_type()
      elif self.match('exist'):
        x = self.decl_exist()
      elif self.match('extern'):
        x = self.decl_extern()
      
      if x != None:
        xx.append(x)
    
    return xx



