

warncnt = 0
errcnt = 0


def colorize(text, color):
  return '\033[%dm%s\033[0m' % (color, text)


def getline(ti):
  file = ti['file']
  lineno = ti['line']
  f = open(file, 'r')
  lin = f.read().split("\n")[lineno - 1]
  f.close()
  return lin



def left_start_pos(ti):
  if 'start' in ti:
    return left_start_pos(ti['start'])
  return ti['pos']


def right_end_pos(ti):
  if 'end' in ti:
    return right_end_pos(ti['end'])
  return ti['pos'] + ti['len'] - 1




def mark(pos, color):
  print(" " * pos, end=''); print(colorize('^', color))


def himark(lpos, pos, lenc, rpos, color):
  print(" " * lpos, end='')
  llen = pos - lpos
  rlen = rpos - pos
  print(colorize('-' * llen, color), end='')
  print(colorize('*' * lenc, color), end='')
  print(colorize('-' * rlen, color))


def highlight(ti, color):
  pos = ti['pos']
  #mark(pos, color)
  start = left_start_pos(ti)
  end = right_end_pos(ti)
  himark(start, pos, ti['len'], end - 1, color)



def warning(s, ti):
  global warncnt
  warncnt = warncnt + 1
  print('\033[95m' + 'warning: ' + '\033[0m' + s)
  if ti != None:
    if ti['isa'] != 'ti':
      if 'ti' in ti:
        ti = ti['ti']

    lin = getline(ti)
    print(lin)
    highlight(ti, 95)


def error(s, ti):
  global errcnt
  errcnt = errcnt + 1
  
  pre = ''
  if ti != None:
    if ti['isa'] != 'ti':
      if 'ti' in ti:
        ti = ti['ti']

    if not 'file' in ti:
      print("NOT FILE IN TI: " + str(ti))
    pre = '%s:%d:%d: ' % (ti['file'], ti['line'], ti['pos'])

  print(pre + '\033[91m' + 'error: ' + '\033[0m' + s)
  
  if ti != None:
    lin = getline(ti)
    print(lin)
    highlight(ti, 91)

  if errcnt >= 10:
    exit(-1)


def info(s, ti):
  pre = ''
  if ti != None:
    if ti['isa'] != 'ti':
      if 'ti' in ti:
        ti = ti['ti']

    if not 'file' in ti:
      print("NOT FILE IN TI: " + str(ti))
    pre = '%s:%d:%d: ' % (ti['file'], ti['line'], ti['pos'])
  print(pre + '\033[96m' + 'info: ' + '\033[0m' + s)

  if ti != None:
    lin = getline(ti)
    print(lin)
    highlight(ti, 96)
  


def fatal(s):
  print('\033[91m' + 'fatal error: ' + '\033[0m' + s)
  exit(1)

