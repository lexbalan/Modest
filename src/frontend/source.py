

class Source:
    def __init__(self, filename):
        self.f = open(filename, "r")
        self.filename = filename
        self.pos = 0
        self.line = 1


    # считать очередной символ
    def getc(self):
        x = self.f.read(1)
        if x == '\n':
            self.pos = 0
            self.line = self.line + 1
        else:
            self.pos = self.pos + 1
        return x


    # считать n следующих символов
    def getn(self, n):
        s = []
        i = 0
        while i < n:
            c = self.getc()
            s.append(c)
            i = i + 1
        return "".join(s)


    # получить позицию в файле
    def getpos(self):
        x = self.f.tell()
        return (x, self.line, self.pos)


    # установить позицию в файле
    def setpos(self, pos):
        self.line = pos[1]
        self.pos = pos[2]
        self.f.seek(pos[0], 0)


    def get_ti(self):
        return {
            'isa': 'ti',
            'file': self.filename,
            'line': self.line,
            'pos': self.pos
        }


    # посмотреть n символов вперед
    def lookup(self, n):
        pos = self.getpos()
        c = self.f.read(n)
        self.setpos(pos)
        return c


