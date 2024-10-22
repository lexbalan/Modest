
MCU = atmega328p
F_CPU = 16000000

ALL_CFLAGS = -g -mmcu=$(MCU) -Os -DF_CPU=$(F_CPU) -I. -DF_CPU=$(F_CPU) -c
ALL_LFLAGS = -g -mmcu=$(MCU)


all:
	mcc -o out/llvm/main -funsafe -mbackend=llvm src/main.m
	mcc -o out/llvm/avr -funsafe -mbackend=llvm src/avr/avr.m
	mcc -o out/llvm/m328p -funsafe -mbackend=llvm src/avr/m328p.m
	mcc -o out/llvm/delay -funsafe -mbackend=llvm src/avr/delay.m
	llc -march=avr out/llvm/main.ll -o out/llvm/main.s
	llc -march=avr out/llvm/avr.ll -o out/llvm/avr.s
	llc -march=avr out/llvm/m328p.ll -o out/llvm/m328p.s
	llc -march=avr out/llvm/delay.ll -o out/llvm/delay.s
	avr-gcc -mmcu=$(MCU) out/llvm/main.s out/llvm/avr.s out/llvm/m328p.s out/llvm/delay.s -o out/llvm/main.elf
	avr-objcopy -j .text -j .data -O ihex out/llvm/main.elf out/llvm/main.hex
	

C:
	mcc -o out/c/main -funsafe -mbackend=c src/main.m
	mcc -o out/c/delay -funsafe -mbackend=c src/avr/delay.m
	avr-gcc $(ALL_CFLAGS) -o out/c/main.o out/c/main.c
	avr-gcc $(ALL_CFLAGS) -o out/c/avr.o out/c/avr.c
	avr-gcc $(ALL_CFLAGS) -o out/c/m328p.o out/c/m328p.c
	avr-gcc $(ALL_CFLAGS) -o out/c/delay.o out/c/delay.c
	avr-gcc $(ALL_LFLAGS) -o out/c/main.elf out/c/main.o out/c/avr.o out/c/m328p.o out/c/delay.o
	avr-objcopy -j .text -j .data -O ihex out/c/main.elf out/c/main.hex


CM:
	mcc -o out/cm/main -funsafe -mbackend=cm src/main.m
	mcc -o out/cm/avr -funsafe -mbackend=cm src/avr/avr.m
	mcc -o out/cm/m328p -funsafe -mbackend=cm src/avr/m328p.m
	mcc -o out/cm/delay -funsafe -mbackend=cm src/avr/delay.m


flash:
	avrdude -v -p $(MCU) -c arduino -P /dev/tty.usbserial-10 -b 57600 -D -U flash:w:./main.hex:i


