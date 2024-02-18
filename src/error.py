# error.py

warncnt = 0
errcnt = 0

MAX_ERRORS = 10


ENDC = 0
BOLD = 1
RED = 91
GREEN = 92
YELLOW = 93
BLUE = 94
MAGENTA = 95
CYAN = 96

COLOR_NOTE = BLUE
COLOR_INFO = CYAN
COLOR_WARNING = MAGENTA
COLOR_ERROR = RED


SIMPLE_MARK = True


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




def colorize(text, color):
    return '\033[%dm%s\033[0m' % (color, text)


def mark(pos, color):
    print(" " * pos, end='')
    print(colorize('^', color))


def himark(lpos, pos, lenc, rpos, color):
    if SIMPLE_MARK:
        mark(pos, color)
        return

    llen = pos - lpos  # длина подчеркивания слева
    rlen = rpos - pos  # длина подчеркивания справа

    print(" " * lpos, end='')
    print(colorize('-' * llen, color), end='')
    print(colorize('^' * lenc, color), end='')
    print(colorize('-' * rlen, color))


def highlight(ti, color, offset):
    pos = ti['pos'] + offset
    start = left_start_pos(ti) + offset
    end = right_end_pos(ti) + offset
    himark(start, pos, ti['len'], end - 1, color)


def common_message(mg, color, s, ti=None):
    pre = ''

    if ti != None:
        if ti['isa'] != 'ti':
            if 'ti' in ti:
                ti = ti['ti']

        pre = '\n%s:%d:%d:\n' % (ti['file'], ti['line'], ti['pos'])

    print(pre + colorize(mg, color) + s)

    if ti != None:
        prelin = "%d |" % ti['line']
        lin = getline(ti)
        print(prelin + lin)
        highlight(ti, color, offset=len(prelin))



def note(s, ti=None):
    common_message('note: ', COLOR_NOTE, s, ti)


def info(s, ti=None):
    common_message('info: ', COLOR_INFO, s, ti)


def warning(s, ti=None):
    from main import features
    if features.get('paranoid'):
        error(s, ti)
        return

    global warncnt
    warncnt = warncnt + 1

    common_message('warning: ', COLOR_WARNING, s, ti)


def error(s, ti=None):
    global errcnt
    errcnt = errcnt + 1
    common_message('error: ', COLOR_ERROR, s, ti)
    if errcnt >= MAX_ERRORS:
        exit(-1)


def fatal(s, ti=None):
    #print('\033[91m' + 'fatal error: ' + '\033[0m' + s)
    common_message('fatal error: ', 91, s, ti)
    exit(1)

