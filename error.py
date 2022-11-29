

warncnt = 0
errcnt = 0


def getline(file, lineno):
  f = open(file, 'r')
  lin = f.read().split("\n")[lineno - 1]
  f.close()
  return lin


def highlight(pos):
  print(" " * pos, end=''); print('\033[92m' + '^' + '\033[0m')


def warning(s, ti):
  global warncnt
  warncnt = warncnt + 1
  print('\033[93m' + 'warning: ' + '\033[0m' + s)


def error(s, ti):
  global errcnt
  errcnt = errcnt + 1
  
  pre = ''
  if ti != None:
    if not 'file' in ti:
      print("NOT FILE IN TI: " + str(ti))
    pre = '%s:%d:%d: ' % (ti['file'], ti['line'], ti['pos'])
  print(pre + '\033[91m' + 'error: ' + '\033[0m' + s)
  
  if ti != None:
    lin = getline(ti['file'], ti['line'])
    print(lin)
    highlight(ti['pos'])
  

