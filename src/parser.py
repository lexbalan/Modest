#####################################################################
#                            PARSER                                 #
#####################################################################

from lexer import Lexer
from error import warning, error, getline


top_level_stoppers = ['type', 'const', 'var', 'func']


class Parser:

  def __init__(self):
    self.lex = Lexer()

  def is_end(self):
    if self.tokens[self.ctoken][1] == '':
      return True
    return self.ctoken >= (len(self.tokens) - 1)
  

  def is_blank(self, c):
    return c == ' ' or c == '\t' or c == '\n'
  

  def skip(self):
    if self.ctoken < (len(self.tokens) - 1):
      self.ctoken = self.ctoken + 1
  

  def ctok_class(self):
    return self.tokens[self.ctoken][0]
  

  def ctok(self):
    return self.tokens[self.ctoken][1]
  
  def nextok(self):
    if self.ctoken + 1 > len(self.tokens):
      pass # TODO
    return self.tokens[self.ctoken + 1][1]


  def ti(self):
    try:
      return self.tokens[self.ctoken][2]
    except:
      print("NOT TI IN " + str(self.tokens[self.ctoken]))
    
  
  def gettok(self):
    t = self.ctok()
    self.skip()
    return t
  

  def skip_blanks(self):
    while self.is_blank(self.ctok()):
      self.skip()
  

  def look(self, token):
    return self.ctok() == token
  

  def match(self, token):
    yes = self.look(token)
    if yes:
      self.skip()
    return yes


  def token_class_is(self, clas):
    c = self.ctok_class()
    if c == clas:
      return True
    return False
  

  def need(self, token):
    ti = self.ti()
    yes = self.match(token)
    if not yes:
      error("expected '%s' token" % token, ti)
    return yes

  
  def identifier(self):
    ti = self.ti()
    if self.ctok_class() != 'id':
      self.skip()
      error("expected identifier", ti)
      return None
    s = self.gettok()
    return {'isa': 'id', 'str': s, 'ti': ti}


  def need_sep(self, separators=['\n', ';'], stoppers=['}']):
    if self.ctok() in separators:
      while self.ctok() in separators:
        self.skip()
    elif self.ctok() in stoppers:
      pass
    else:
      error("expected separator", self.ti())


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
        if f != None:
          fields.extend(f)
  
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
        self.skip_blanks()
        f = self.parse_field()
        self.need_sep()
        if f != None:
          fields.extend(f)

      return {'isa': 'type', 'kind': 'record', 'fields': fields, 'ti': ti}

    elif self.match("enum"):
      self.need("{")
      items = []
      while not self.match("}"):
        self.skip_blanks()
        ti = self.ti()
        f = self.identifier()
        self.need_sep(separators=['\n', ','])
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
    

  #
  # Parse Value
  #
  
  def expr_value(self):
    return self.expr_value_0()

    
  def expr_value_0(self):
    v = self.expr_value_1()
    ti = self.ti()
    if self.match("or"):
      r = self.expr_value_0()
      ti['start'] = v['ti']
      ti['end'] = r['ti']
      return {'isa': 'value', 'kind': 'or', 'left': v, 'right': r, 'ti': ti}
    else:
      return v
  

  def expr_value_1(self):
    v = self.expr_value_2()
    ti = self.ti()
    if self.match("xor"):
      r = self.expr_value_1()
      ti['start'] = v['ti']
      ti['end'] = r['ti']
      return {'isa': 'value', 'kind': 'xor', 'left': v, 'right': r, 'ti': ti}
    else:
      return v
  

  def expr_value_2(self):
    v = self.expr_value_3()
    ti = self.ti()
    if self.match("and"):
      r = self.expr_value_2()
      ti['start'] = v['ti']
      ti['end'] = r['ti']
      return {'isa': 'value', 'kind': 'and', 'left': v, 'right': r, 'ti': ti}
    else:
      return v
  

  def expr_value_3(self):
    v = self.expr_value_4()
    while True:
      ti = self.ti()
      if self.match("=="):
        r = self.expr_value_4()
        ti['start'] = v['ti']
        ti['end'] = r['ti']
        v = {'isa': 'value', 'kind': 'eq', 'left': v, 'right': r, 'ti': ti}
      elif self.match("!="):
        r = self.expr_value_4()
        ti['start'] = v['ti']
        ti['end'] = r['ti']
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
        ti['start'] = v['ti']
        ti['end'] = r['ti']
        v = {'isa': 'value', 'kind': 'lt', 'left': v, 'right': r, 'ti': ti}
      elif self.match(">"):
        r = self.expr_value_5()
        ti['start'] = v['ti']
        ti['end'] = r['ti']
        v = {'isa': 'value', 'kind': 'gt', 'left': v, 'right': r, 'ti': ti}
      if self.match("<="):
        r = self.expr_value_5()
        ti['start'] = v['ti']
        ti['end'] = r['ti']
        v = {'isa': 'value', 'kind': 'le', 'left': v, 'right': r, 'ti': ti}
      elif self.match(">="):
        r = self.expr_value_5()
        ti['start'] = v['ti']
        ti['end'] = r['ti']
        v = {'isa': 'value', 'kind': 'ge', 'left': v, 'right': r, 'ti': ti}
      else:
        break
    return v


  def expr_value_5(self):
    #ti_start = self.ti()
    v = self.expr_value_6()
    while True:
      ti = self.ti()
      if self.match("<<"):
        l = v
        r = self.expr_value_6()
        ti['start'] = l['ti']
        ti['end'] = r['ti']
        v = {'isa': 'value', 'kind': 'shl', 'left': v, 'right': r, 'ti': ti}
      elif self.match(">>"):
        l = v
        r = self.expr_value_6()
        ti['start'] = l['ti']
        ti['end'] = r['ti']
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
        ti['start'] = v['ti']
        ti['end'] = r['ti']
        v = {'isa': 'value', 'kind': 'add', 'left': v, 'right': r, 'ti': ti}
      elif self.match("-"):
        r = self.expr_value_7()
        ti['start'] = v['ti']
        ti['end'] = r['ti']
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
        ti['start'] = v['ti']
        ti['end'] = r['ti']
        v = {'isa': 'value', 'kind': 'mul', 'left': v, 'right': r, 'ti': ti}
      elif self.match("/"):
        r = self.expr_value_8()
        ti['start'] = v['ti']
        ti['end'] = r['ti']
        v = {'isa': 'value', 'kind': 'div', 'left': v, 'right': r, 'ti': ti}
      elif self.match("%"):
        r = self.expr_value_8()
        ti['start'] = v['ti']
        ti['end'] = r['ti']
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
      ti['start'] = v['ti']
      ti['end'] = t['ti']
      v = {'isa': 'value', 'kind': 'cast', 'value': v, 'type': t, 'ti': ti}
    return v
  
  
  def expr_value_9(self):
    ti = self.ti()
    if self.match("*"):
      v = self.expr_value_9()
      ti['end'] = v['ti']
      return {'isa': 'value', 'kind': 'deref', 'value': v, 'ti': ti}
    elif self.match("&"):
      v = self.expr_value_10()
      ti['end'] = v['ti']
      return {'isa': 'value', 'kind': 'ref', 'value': v, 'ti': ti}
    elif self.match("not"):
      v = self.expr_value_9()
      ti['end'] = v['ti']
      return {'isa': 'value', 'kind': 'not', 'value': v, 'ti': ti}
    elif self.match("+"):
      v = self.expr_value_10()
      ti['end'] = v['ti']
      return {'isa': 'value', 'kind': 'plus', 'value': v, 'ti': ti}
    elif self.match("-"):
      v = self.expr_value_10()
      ti['end'] = v['ti']
      return {'isa': 'value', 'kind': 'minus', 'value': v, 'ti': ti}
    elif self.match("sizeof"):
      self.match("(")
      t = self.expr_type()
      self.need(")")
      return {'isa': 'value', 'kind': 'sizeof', 'type': t, 'ti': ti}
    else:
      y = self.expr_value_10()
      return y
  
  
  def expr_value_10(self):
    v = self.expr_value_11()
    while True:
      ti = self.ti()
      if self.match("("):
        args = []
        while not self.match(")"):
          self.skip_blanks()
          a = self.expr_value()
          args.append(a)
          self.need_sep(separators=[',', '\n'], stoppers=[')'])
        
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


  def parse_value_term_arr(self, ti):
    items = []

    ti = self.ti()
    self.need("[")
    while not self.match("]"):
      self.skip_blanks()
      field_value = self.expr_value()
      self.need_sep(separators=[',', '\n'], stoppers=[']'])
      items.append(field_value)

    return {
      'isa': 'value',
      'kind': 'array',
      'items': items,
      'ti': ti
    }


  def parse_value_term_rec(self, ti):
    items = []

    ti = self.ti()
    self.need("{")
    while not self.match("}"):
      self.skip_blanks()
      item_ti = self.ti()
      field_id = self.identifier()
      self.need("=")
      field_value = self.expr_value()
      self.need_sep(separators=[',', '\n'], stoppers=['}'])
      items.append({
        'isa': 'item',
        'id': field_id,
        'value': field_value,
        'ti': item_ti
      })

    return {
      'isa': 'value',
      'kind': 'record',
      'items': items,
      'ti': ti
    }


  """def parse_name(self):
    ti = self.ti()
    ids = []

    id = self.identifier()
    ids.append(id)

    while self.match("::"):
      id = self.identifier()
      ids.append(id)

    return {'isa': 'name', 'ids': ids, 'ti': ti}"""


  def parse_value_term_str(self, s, ti):
      str_len = 0
      new_s = ''
      i = 0
      while i < len(s):
        sym = s[i]

        if sym == '\\':
          code = 0

          # nexsym
          i = i + 1
          sym = s[i]

          # '\xCODE' ?
          is_num = sym.isdigit()
          is_hex = sym == 'x'

          if is_num or is_hex:
            asciicode = ''

            if is_hex:
              i = i + 1
              sym = s[i]
              asciicode = '0x'

            hexsyms = [
              'a', 'b', 'c', 'd', 'e', 'f',
              'A', 'B', 'C', 'D', 'E', 'F',
            ]
            while True:
              asciicode = asciicode + sym
              if i == len(s) - 1:
                break
              i = i + 1
              sym = s[i]
              if not sym.isdigit() or (is_hex and sym in hexsyms):
                i = i - 1
                break

            base = 10
            if is_hex:
              base = 16

            code = int(asciicode, base)

          elif sym == 't':
            code = 9
          elif sym == 'n':
            code = 10
          elif sym == 'r':
            code = 13
          elif sym == '"':
            code = '34'
          elif sym == '\\':
            code = 92

          sym = chr(code)

        new_s = new_s + sym
        str_len = str_len + 1
        i = i + 1

      str_len = str_len + 1
      string = ''.join(new_s)

      return {
        'isa': 'value',
        'kind': 'str',
        'len': str_len,
        'str': string,
        'ti': ti
      }


  def parse_value_term(self):
    ti = self.ti()

    if self.ctok_class() == 'id':
      id = self.identifier()

      if self.match("::"):
        id2 = self.identifier()
        return {'isa': 'value', 'kind': 'ns', 'ids': [id, id2], 'ti': ti}

      #if id['str'][0].islower():
      return {'isa': 'value', 'kind': 'id', 'id': id, 'ti': ti}
      #else:
      #  return {'isa': 'value', 'kind': 'id', 'id': id, 'ti': ti}

    elif self.ctok_class() == 'num':
      numstr = self.gettok()

      att = []
      base = 10
      if len(numstr) > 2:
        if numstr[1] == 'x':
          base = 16

      k = 'int'
      numval = 0
      if '.' in numstr:
        k = 'float'
        numval = float(numstr)
      else:
        numval = int(numstr, base)

      if base == 16:
        att.append('hexadecimal')

      return {
        'isa': 'value',
        'kind': k,
        'num': numval,
        'att': att,
        'ti': ti
      }

    elif self.ctok_class() == 'str':
      s = self.gettok()
      return self.parse_value_term_str(s, ti)

    elif self.ctok_class() == 'sym':
      num = self.gettok()
      return {'isa': 'value', 'kind': 'sym', 'sym': num, 'ti': ti}

    elif self.look("["):
      return self.parse_value_term_arr(ti)

    elif self.look("{"):
      return self.parse_value_term_rec(ti)

      """elif self.match("@"):
      #t = self.parse_type()
      if self.look("{"):
        return self.parse_value_term_rec(ti)
      if self.look("["):
        return self.parse_value_term_arr(ti)"""

    else:
      #print("??? " + str(self.ctok()))
      cl = self.ctok_class()
      tokstr = self.ctok()

      if tokstr == '\n':
        tokstr = 'newline'
      elif tokstr == '':
        tokstr = 'end-of-file'
      error("unexpected token '%s'" % tokstr, ti)
      self.skip()
      return {'isa': 'value', 'kind': 'bad', 'ti': ti}

  #
  # Parse Statement
  #
  
  def stmt_let(self):
    id = self.identifier()
    self.need("=")
    r = self.expr_value()
    return {'isa': 'stmt', 'kind': 'let', 'id': id, 'value': r}


  def stmt_if(self):
    c = self.expr_value()
    t = self.stmt_block()
    e = None
    if self.match('else'):
      ti = self.ti()
      if self.match('if'):
        e = self.stmt_if()
      else:
        e = self.stmt_block()
      e['ti'] = ti
    return {'isa': 'stmt', 'kind': 'if', 'cond': c, 'then': t, 'else': e}


  def stmt_while(self):
    v = self.expr_value()
    b = self.stmt_block()
    return {'isa': 'stmt', 'kind': 'while', 'cond': v, 'stmt': b}


  def stmt_return(self):
    self.skip()  # skip 'return' keyword

    v = None
    if not (self.look("\n") or self.look(";") or self.look("}")):
      v = self.expr_value()

    return {'isa': 'stmt', 'kind': 'return', 'value': v}

  
  def stmt_var(self):
    ti = self.ti()
    
    ids = []
    while True:
      id = self.identifier()
      ids.append(id)
      if not self.match(','):
        break

    t = None
    v = None
    if self.match(":"):
      t = self.expr_type()
    if self.match("<-") or self.match(":="):
      v = self.expr_value()

    stmts = []
    for id in ids:
      stmt_var = {
        'isa': 'stmt',
        'kind': 'var',
        'id': id,
        'type': t,
        'value': v,
        'ti': id['ti']
      }
      stmts.append(stmt_var)
    return stmts
  

  def stmt_again(self):
    return {'isa': 'stmt', 'kind': 'again'}


  def stmt_break(self):
    return {'isa': 'stmt', 'kind': 'break'}
  

  def stmt_expr_value(self):
    v = self.expr_value()
    
    # stmt expr
    assign_ti = self.ti()
    if not (self.match(":=") or self.match("<-")):
      return {'isa': 'stmt', 'kind': 'value', 'value': v}
    
    # stmt assign
    r = self.expr_value()
    return {'isa': 'stmt', 'kind': 'assign', 'left': v, 'right': r, 'ti': assign_ti}
  
  
  def stmt(self):
    ti = self.ti()

    if self.match('let'):
      s = self.stmt_let()
    elif self.match('if'):
      s = self.stmt_if()
    elif self.match('while'):
      s = self.stmt_while()
    elif self.look('return'):
      s = self.stmt_return()
    elif self.match('var'):
      s = self.stmt_var()
    elif self.match('again'):
      s = self.stmt_again()
    elif self.match('break'):
      s = self.stmt_break()
    else:
      s = self.stmt_expr_value()

    if s == None:
      return s

    # переменные могут быть объявлены списком
    if isinstance(s, list):
      return s

    if not 'ti' in s:
      s['ti'] = ti

    return s
  
  
  def stmt_block(self):
    ti = self.ti()
    #print('stmt_block')

    self.need("{")
    stmts = []
    while True:
      self.skip_blanks()

      if self.match('}'):
        break

      s = self.stmt()
      if s != None:
        self.need_sep()
        if isinstance(s, list):
          stmts.extend(s)
        else:
          stmts.append(s)

    return {'isa': 'stmt', 'kind': 'block', 'stmts': stmts, 'ti': ti}
  

  def parse_field(self):
    ti = self.ti()

    ids = []
    while True:
      id = self.identifier()
      if id == None:
        break
      ids.append(id)
      if not self.match(','):
        break

    if ids == []:
      self.restore(['\n', ','])
      return None

    if not self.need(":"):
      self.restore(['\n', ','])
      return None

    t = self.expr_type()

    fields = []
    for id in ids:
      field = {'isa': 'field', 'id': id, 'type': t, 'ti': id['ti']}
      fields.append(field)

    return fields
  
  
  #
  # Top Level Directives
  #
  
  def do_import(self):
    ti = self.ti()
    str = self.gettok()
    return {'isa': 'ast_directive', 'kind': 'import', 'str': str, 'ti': ti}

  def do_include(self):
    ti = self.ti()
    str = self.gettok()
    return {'isa': 'ast_directive', 'kind': 'include', 'str': str, 'ti': ti}

  
  def decl_extern(self):
    if self.match('type'):
      return self.def_type(extern=True)
    elif self.match('func'):
      return self.def_func(extern=True)
    else:
      print("bad extern")
      exit(1)
  
  
  def def_func(self, extern=False):
    ti = self.ti()
    id = self.identifier()
    ftyp = self.expr_type()

    # func declaration?
    if self.match("\n"):
      return {
        'isa': 'ast_declaration',
        'kind': 'func',
        'id': id,
        'type': ftyp,
        'extern': extern,
        'ti': ti
      }

    # func definition
    s = self.stmt_block()
    return {
      'isa': 'ast_definition',
      'kind': 'func',
      'id': id,
      'type': ftyp,
      'stmt': s,
      'ti': ti
    }



    
  
  def def_const(self):
    ti = self.ti()
    id = self.identifier()
    self.need('=')
    v = self.expr_value()
    return {
      'isa': 'ast_definition',
      'kind': 'const',
      'id': id,
      'value': v,
      'ti': ti
    }
  
  
  def def_var(self):
    ff = self.parse_field()
    if ff == None:
      return None

    iv = None
    if self.match("<-") or self.match(":="):
      iv = self.expr_value()

    vars = []
    for f in ff:
      vars.append({
        'isa': 'ast_definition',
        'kind': 'var',
        'field': f,
        'init': iv,
        'ti': f['ti']
      })

    return vars
  
  
  def def_type(self, extern=False):
    ti = self.ti()
    id = self.identifier()

    # type declaration
    if self.match("\n"):
      return {
        'isa': 'ast_declaration',
        'kind': 'type',
        'id': id,
        'extern': extern,
        'ti': ti
      }

    # type definition
    t = self.expr_type()
    return {
      'isa': 'ast_definition',
      'kind': 'type',
      'id': id,
      'type': t,
      'ti': ti
    }


  def restore_top_level(self):
    while not self.is_end():
      token_str = self.ctok()
      if token_str in ['func', 'const', 'var', 'type', 'exist', 'extern']:
        break
      self.skip()


  def def_metadir(self):
    ti = self.ti()
    x = self.gettok()
    return {'isa': 'ast_directive', 'kind': 'metadir', 'text': x, 'ti': ti}


  def def_dir(self):
    ti = self.ti()
    x = self.gettok()
    return {'isa': 'ast_directive2', 'kind': 'metadir', 'text': x, 'ti': ti}


  def parse(self, filename):
    self.tokens = self.lex.tokenize(filename)
    #print("ENDLEX: " + filename)
    self.ctoken = 0

    xx = []

    """while True:
      if self.match('import'):
        x = self.do_import()
        xx.append(x)
      elif self.match('include'):
        x = self.do_include()
        xx.append(x)
      elif self.match('\n'):
        pass
      else:
        break"""

    while not self.is_end():

      export = self.match('export')
      x = None

      if self.match('\n'):
        continue
      elif self.match('func'):
        x = self.def_func()
      elif self.match('const'):
        x = self.def_const()
      elif self.match('var'):
        x = self.def_var()
      elif self.match('type'):
        x = self.def_type()
      elif self.match('extern'):
        x = self.decl_extern()

      elif self.token_class_is('block-comment'):
        x = self.def_metadir()
      elif self.token_class_is('line-comment'):
        x = self.def_metadir()
      elif self.token_class_is('directive'):
        x = self.def_dir()
      elif self.match('import'):
        x = self.do_import()
      elif self.match('include'):
        x = self.do_include()

      else:
        error("unexpected token", self.ti())
        self.restore_top_level()
        continue
      
      if x == None:
        continue

      if isinstance(x, list):
        xx.extend(x)
      else:
        xx.append(x)
    
    return xx



  def restore(self, stoppers):
    while not self.ctok() in stoppers:
      if self.ctok() == '':
        return
      self.skip()

