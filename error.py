

warncnt = 0
errcnt = 0


def getline(ti):
  file = ti['file']
  lineno = ti['line']
  f = open(file, 'r')
  lin = f.read().split("\n")[lineno - 1]
  f.close()
  return lin


def highlight(pos, ccode):
  print(" " * pos, end=''); print('\033[%dm' % ccode + '^' + '\033[0m')


def warning(s, ti):
  global warncnt
  warncnt = warncnt + 1
  print('\033[95m' + 'warning: ' + '\033[0m' + s)
  if ti != None:
    lin = getline(ti)
    print(lin)
    highlight(ti['pos'], 95)


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
    lin = getline(ti)
    print(lin)
    highlight(ti['pos'], 91)


def info(s, ti):
  global errcnt
  errcnt = errcnt + 1

  pre = ''
  if ti != None:
    if not 'file' in ti:
      print("NOT FILE IN TI: " + str(ti))
    pre = '%s:%d:%d: ' % (ti['file'], ti['line'], ti['pos'])
  print(pre + '\033[96m' + 'info: ' + '\033[0m' + s)

  if ti != None:
    lin = getline(ti)
    print(lin)
    highlight(ti['pos'], 96)
  

