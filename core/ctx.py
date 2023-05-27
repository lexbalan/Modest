
from error import error


top = {
  'base': None,
  'types': {},
  'values': {}
}


def push():
  #print("PUSH")
  global top
  newlayer = {
    'base': top,
    'types': {},
    'values': {}
  }
  top = newlayer


def pop():
  #print("POP")
  global top
  assert(top != None)
  oldtop = top
  top = oldtop['base']
  del oldtop


def add_value(id, v):
  global top
  top['values'][id] = v
  return v


def add_type(id, t):
  global top
  #print("add type " + id)
  top['types'][id] = t
  return t


def get_type_ctx(ctx, id):
  if ctx == None:
    return None

  if id in ctx['types']:
    return ctx['types'][id]

  return get_type_ctx(ctx['base'], id)


def get_value_ctx(ctx, id):
  if ctx == None:
    return None

  if id in ctx['values']:
    return ctx['values'][id]

  return get_value_ctx(ctx['base'], id)


def get_type(id):
  global top
  return get_type_ctx(top, id)


def get_value(id):
  global top
  return get_value_ctx(top, id)

