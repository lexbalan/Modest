

def stmt_create_bad(ti=None):
  return {
    'isa': 'stmt',
    'kind': 'bad',
    'ti': ti
  }


def stmt_is_bad(x):
  assert x != None
  return x['kind'] == 'bad'

