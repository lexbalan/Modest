
import error
import trans
import printer
import llvm


def main():
  trans.init()
  module = trans.translate("main.cm")
  if error.errcnt > 0:
    exit(1)
  outname = "out"
  llvm.printx(module, trans.strpool, outname)


if __name__ == '__main__':
  main()

