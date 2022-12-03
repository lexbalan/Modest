

f = None

indent = 0


def o(s):
  f.write(s)

def lo(s):
  f.write('\n')
  f.write(s)

def ind():
  global indent
  f.write("\t" * indent)


typealiases = {
  'Unit': 'void',
  'Int': 'int',
  'Int8': 'int8_t',
  'Int16': 'int16_t',
  'Int32': 'int32_t',
  'Int64': 'int64_t',
  'Nat8': 'uint8_t',
  'Nat16': 'uint16_t',
  'Nat32': 'uint32_t',
  'Nat64': 'uint64_t',
  'Nat1': 'uint8_t',
}

def print_type(t, print_aka=True):
  k = t['kind']
  
  if print_aka:
    if 'aka' in t:
      id = t['aka']
      if id in typealiases:
        o(typealiases[id])
      else:
        o(id)
      return
  
  if k == 'record':
    o("struct {")
    fields = t['fields']
    i = 0
    while i < len(fields):
      field = fields[i]
      o("\n")
      o("\t"); print_field(field)
      o(";")
      i = i + 1
    o("\n}")
  elif k == 'enum':
    o("enum {")
    items = t['items']
    i = 0
    while i < len(items):
      item = items[i]
      o("\n")
      o("\t%s," % item['id'])
      i = i + 1
    o("\n}")
  elif k == 'pointer':
    print_type(t['to'])
    if t['to']['kind'] != 'array':
      o("*")
  elif k == 'array':
    print_type(t['of'])
    o("*")
  elif k == 'func':
    o("void")
    
  else:
    o("<type:%s>" % k)
  

bin_ops = {
  'or': '|', 'xor': '^', 'and': '&', 'shl': '<<', 'shr': '>>',
  'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
  'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'mod': '%'
}

def print_value_expr_bin(v):
  print_value(v['left'])
  o(' ' + bin_ops[v['kind']] + ' ')
  print_value(v['right'])

un_ops = {
  'ref': '&', 'deref': '*', 'plus': '+', 'minus': '-', 'not': '~'
}

def print_value_expr_un(v):
  o(un_ops[v['kind']])
  print_value(v['value'])


def print_value_expr_call(v):
  if v['left']['type']['kind'] == 'pointer':
    t = v['left']['type']['to']
    # вызов через указатель
    # поскольку у нас указатели на функции это *void
    # при вызове приводим левое к указателю на функцию
    o("((")
    print_type(t['to'])
    o("(*)(")
    i = 0
    n = len(t['params'])
    while i < n:
      p = t['params'][i]
      print_field(p)
      i = i + 1
      if i < n:
        o(", ")
    o(")")
    o(")")
    print_value(v['left'])
    o(")")
    
  else:
    print_value(v['left'])
  
  o("(")
  i = 0
  while i < len(v['args']):
    a = v['args'][i]
    print_value(a)
    i = i + 1
    if i < len(v['args']):
      o(", ")
  o(")")


def print_value_expr_index(v):
  print_value(v['array'])
  o("[")
  print_value(v['index'])
  o("]")


def print_value_expr_access(v):
  print_value(v['record'])
  o(".%s" % v['field']['id'])


def print_value_expr_access2(v):
  print_value(v['record'])
  o("->%s" % v['field']['id'])


def print_value_expr_to(v):
  # Чтобы не приводить тип в выражениях типа ((int32_t)0), etc.
  if 'numeric' in v['type']['att']:
    if 'generic' in v['value']['type']['att']:
      if 'numeric' in v['value']['type']['att']:
        print_value(v['value'])
        return
  
  o("((")
  print_type(v['type'])
  o(")")
  print_value(v['value'])
  o(")")


def print_value_composite(v):
  #o("<value:composite>")
  o("(")
  print_type(v['type'])
  o(")")
  o("{")
  for i in v['items']:
    o(".%s=" % i['id'])
    print_value(i['value'])
    o(",")
  o("}")


def print_value(v):
  k = v['kind']
  
  if k in bin_ops:
    print_value_expr_bin(v)
  elif k in un_ops:
    print_value_expr_un(v)
  elif k == 'num':
    o("%s" % v['num'])
  elif k in ['func', 'const', 'var']:
    o("%s" % v['id'])
  elif k == 'str':
    o("\"%s\"" % v['str'])
  elif k == 'composite':
    print_value_composite(v)
  else:
    if k == 'call':
      print_value_expr_call(v)
    elif k == 'index':
      print_value_expr_index(v)
    elif k == 'access':
      print_value_expr_access(v)
    elif k == 'access2':
      print_value_expr_access2(v)
    elif k == 'to':
      print_value_expr_to(v)
    elif k == 'sizeof':
      o("sizeof(")
      print_type(v['of'])
      o(")")
      """elif k == 'ld_id':
        o("LD_ID(")
        print_value(v['value'])
        o(")")
      elif k == 'ld_ptr':
        o("LD_PTR(")
        print_value(v['value'])
        o(")")"""
    else:
      o("<%s>" % k)


def print_stmt_if(x):
  o("if (")
  print_value(x['cond'])
  o(") ")
  print_stmt(x['then'])
  if x['else'] != None:
    o(" else ")
    print_stmt(x['else'])


def print_stmt_while(x):
  o("while (")
  print_value(x['cond'])
  o(") ")
  print_stmt(x['stmt'])


def print_stmt_return(x):
  o("return")
  if x['value'] != None:
    o(" ")
    print_value(x['value'])
  o(";")


def print_stmt_defvar(x):
  print_field({'isa': 'field', 'id': x['id'], 'type': x['type']})
  if x['value'] != None:
    o(" = ")
    print_value(x['value']) 
  o(";")


def print_stmt_let(x):
  f = {'isa': 'field', 'id': x['id'], 'type': x['value']['type']}
  print_field(f)
  o(" = ")
  print_value(x['value'])
  o(";")


def print_stmt(x):
  global indent
  
  k = x['kind']
  if k == 'block':
    print_stmt_block(x)
  else:
    o("\n")
    ind()
    if k == 'value':
      print_value(x['value'])
      o(";")
    elif k == 'assign':
      print_value(x['left'])
      o(" = ")
      print_value(x['right'])
      o(";")
    elif k == 'return':
      print_stmt_return(x)
    elif k == 'if':
      print_stmt_if(x)
    elif k == 'while':
      print_stmt_while(x)
    elif k == 'defvar':
      print_stmt_defvar(x)
    elif k == 'let':
      print_stmt_let(x)
    else:
      lo("<stmt %s>" % str(x))
  


def print_stmt_block(s):
  global indent
  indent = indent + 1
  o("{")
  for stmt in s['stmts']:
    print_stmt(stmt)
  indent = indent - 1
  o("\n")
  ind()
  o("}")
  


def print_func_signature(id, typ):
  params = typ['params']
  to = typ['to']
  t = to
  
  # возврат является масссивом?
  is_array = t['kind'] == 'array'
  array_size = None
  if is_array:
    array_size = t['size']
    t = t['of']
  
  # поле является указателем?
  ptr_level = 0
  while t['kind'] == 'pointer':
    ptr_level = ptr_level + 1
    t = t['to']
    # *[] or *[n] -> just *
    if t['kind'] == 'array':
      t = t['of']
  
  print_type(t)
  o(" " + "*" * ptr_level)
  o("%s(" % id)
  
  i = 0
  while i < len(params):
    param = params[i]
    print_field(param)
    i = i + 1
    if i < len(params):
      o(", ")
      
  if 'arghack' in typ:
    if typ['arghack']:
      o(", ...")
  
  o(")")


def print_funcdef(x):
  o("\n")
  print_func_signature(x['id'], x['type'])
  o(" ")
  print_stmt_block(x['stmt'])



def print_exist_extern(x, extern=False):
  f = x['field']
  if extern:
    o("extern ")
  if f['type']['kind'] == 'func':
    print_func_signature(f['id'], f['type'])
  else:
    print_field(f)
  o(";")
  
def print_exist(x):
  print_exist_extern(x)

def print_extern(x):
  print_exist_extern(x, extern=True)


def print_typedef(x):
  if x['type']['kind'] in ['record', 'enum']:
    o("\n")
  
  o("typedef ")
  print_type(x['type'], print_aka=False)
  o(" %s;" % x['id'])
  


# из за того что с C типы через жопу
# приходится печатать типы ptr, arr & func вместе с именем поля
def print_field(x):
  t = x['type']
    
  # поле является масссивом?
  is_array = t['kind'] == 'array'
  array_size = None
  if is_array:
    array_size = t['size']
    t = t['of']
  
  # поле является указателем?
  ptr_level = 0
  while t['kind'] == 'pointer':
    t = t['to']
    
    if t == 'func':
      t = type.typeUnit
    else:
      ptr_level = ptr_level + 1
      # *[] or *[n] -> just *
      if t['kind'] == 'array':
        t = t['of']
  
  print_type(t)
  o(" ")
  o("*" * ptr_level)
  o("%s" % (x['id']))
  if is_array:
    o("[")
    if array_size != None:
      print_value(array_size)
    o("]")



def print_vardef(x):
  print_field(x['field'])
  o(";")




def printx(module, outname):
  global f
  
  f = open(outname, "w")

  """
  import yaml
  yy = yaml.dump(x)
  print(yy)
  print("END.")
  """
  
  o("/* Cm foundation */")
  lo("#include <stdint.h>")
  
  """lo("#ifndef __TYPE_STR__")
  lo("#define __TYPE_STR__")
  lo("typedef char * Str;")
  lo("#endif /* __TYPE_STR__ */\n")"""
  
  """
    guardname = outname[:-2].upper() + '_H'
    if is_header:
      lo("#ifndef %s" % guardname)
      lo("#define %s\n" % guardname)
  """
  
  isa_prev = None
  
  for x in module:
    o("\n")
    isa = x['isa']
    if isa_prev != isa:
      if not isa in ['funcdef', 'typedef']:
        o("\n")
      isa_prev = isa
    
    
    #print("PRINT: %s" % isa)
    if isa == 'import':
      s = x['str'] + '.h'
      if x['local']:
        s = '"' + s + '"'
      else:
        s = '<' + s + '>'
      o("#include %s" % s)
    elif isa == 'vardef':
      print_vardef(x)
    elif isa == 'constdef':
      o("#define %s  (" % x['id'])
      print_value(x['value'])
      o(")")
    elif isa == 'funcdef':
      print_funcdef(x)
    elif isa == 'typedef':
      print_typedef(x)
    elif isa == 'exist':
      print_exist(x)
    elif isa == 'extern':
      print_extern(x)

  o("\n")
  """if is_header:
    lo("#endif /* %s */" % guardname)"""
  o("\n")
  f.close()





