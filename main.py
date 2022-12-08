
import error
import trans
import printer


def main():
  trans.init()
  module = trans.translate("main.cm")
  if error.errcnt > 0:
    exit(1)
  outname = "out.c"
  printer.printx(module, outname)


if __name__ == '__main__':
  main()

