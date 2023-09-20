

warncnt = 0
errcnt = 0


HEADER = '\033[95m'
BLUE = '\033[94m'
YELLOW = '\033[93m'
INFO = '\033[96m'
WARNING = '\033[95m'
ERROR = '\033[91m'
BOLD = '\033[1m'
ENDC = '\033[0m'
UNDERLINE = '\033[4m'


SIMPLE_MARK = True

from opt import *


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
    return ti['pos'] - ti['len']# - 1


def mark(pos, color):
    print(" " * pos, end=''); print(colorize('^', color))



def himark(lpos, pos, lenc, rpos, color):
    if SIMPLE_MARK:
        print(" " * pos, end='')
        print(colorize('^', color))
        return


    print(" " * lpos, end='')

    llen = pos - lpos
    print(colorize('-' * llen, color), end='')

    print(colorize('^' * lenc, color), end='')

    rlen = rpos - pos
    print(colorize('-' * rlen, color))


def highlight(ti, color, offset):
    pos = ti['pos'] + offset
    #mark(pos, color)
    start = left_start_pos(ti) + offset
    end = right_end_pos(ti) + offset
    #print(ti)
    #print("start = " + str(start))
    #print("end = " + str(end))
    himark(start, pos, ti['len'], end - 1, color)




def note(s, ti=None):
    print(BOLD + 'note: ' + s + ENDC)


def info(s, ti=None):
    pre = ''
    if ti != None:
        if ti['isa'] != 'ti':
            if 'ti' in ti:
                ti = ti['ti']

        pre = '%s:%d:%d: ' % (ti['file'], ti['line'], ti['pos'])
    print(pre + '\033[96m' + 'info: ' + '\033[0m' + s)

    if ti != None:
        prelin = "%d |" % ti['line']
        lin = getline(ti)
        print(prelin + lin)
        highlight(ti, 96, offset=len(prelin))


def warning(s, ti=None):

    if 'paranoid' in features:
        error(s, ti)
        #info("paranoid mode endbled")
        return

    global warncnt
    warncnt = warncnt + 1

    print(WARNING + 'warning: ' + '\033[0m' + s)
    if ti != None:
        if ti['isa'] != 'ti':
            if 'ti' in ti:
                ti = ti['ti']

        prelin = "%d |" % ti['line']

        lin = getline(ti)
        print(prelin + lin)
        highlight(ti, 95, offset=len(prelin))


def error(s, ti=None):
    global errcnt
    errcnt = errcnt + 1

    pre = ''
    if ti != None:
        if ti['isa'] != 'ti':
            if 'ti' in ti:
                ti = ti['ti']

        pre = '%s:%d:%d: ' % (ti['file'], ti['line'], ti['pos'])

    print(pre + '\033[91m' + 'error: ' + '\033[0m' + s)

    if ti != None:
        prelin = "%d |" % ti['line']

        lin = getline(ti)
        print(prelin + lin)
        highlight(ti, 91, offset=len(prelin))

    if errcnt >= 10:
        exit(-1)



def fatal(s):
    print('\033[91m' + 'fatal error: ' + '\033[0m' + s)
    exit(1)

