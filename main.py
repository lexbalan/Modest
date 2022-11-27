
from error import errcnt
from trans import init, translate
from printer import printx


def main():
  init()
  module = translate("main.cm")
  if errcnt == 0:
    outname = "out.c"
    printx(module, outname)
  else:
    exit(1)


if __name__ == '__main__':
  main()

