
from error import errcnt
import trans

from printer import printx
#from llvm import printx


def main():
  trans.init()
  module = trans.translate("main.cm")
  if errcnt == 0:
    outname = "out.c"
    printx(module, outname)
  else:
    exit(1)


if __name__ == '__main__':
  main()

