
MCU = atmega328p
F_CPU = 16000000

ALL_CFLAGS = -g -mmcu=$(MCU) -Os -DF_CPU=$(F_CPU) -I. -DF_CPU=$(F_CPU) -c
ALL_LFLAGS = -g -mmcu=$(MCU)


all:
	mcc -o out/llvm/main -funsafe -mbackend=llvm src/main.m
	llc -march=avr out/llvm/main.ll -o out/llvm/main.s
	avr-gcc -mmcu=$(MCU) out/llvm/main.s -o out/llvm/main.elf
	avr-objcopy -j .text -j .data -O ihex out/llvm/main.elf out/llvm/main.hex
	

C:
	mcc -o out/c/main -funsafe -mbackend=c src/main.m
	avr-gcc $(ALL_CFLAGS) -o out/c/main.o out/c/main.c
	avr-gcc $(ALL_LFLAGS) -o out/c/main.elf out/c/main.o
	avr-objcopy -j .text -j .data -O ihex out/c/main.elf out/c/main.hex


CM:
	mcc -o out/cm/main -funsafe -mbackend=cm src/main.m


flash:
	avrdude -v -p $(MCU) -c arduino -P /dev/tty.usbserial-10 -b 57600 -D -U flash:w:./main.hex:i


