
MCU = atmega328p
F_CPU = 16000000

ALL_CFLAGS = -g -mmcu=$(MCU) -Os -DF_CPU=$(F_CPU) -I. -DF_CPU=$(F_CPU) -c
ALL_LFLAGS = -g -mmcu=$(MCU)


BIN=bin/

all:
	mcc -o out/llvm/main -funsafe -mbackend=llvm src/main.m
	mcc -o out/llvm/avr -funsafe -mbackend=llvm src/avr/avr.m
	mcc -o out/llvm/m328p -funsafe -mbackend=llvm src/avr/m328p.m
	mcc -o out/llvm/delay -funsafe -mbackend=llvm src/avr/delay.m
	mcc -o out/llvm/led -funsafe -mbackend=llvm src/led.m
	mcc -o out/llvm/animation -funsafe -mbackend=llvm src/animation.m
	
	llc -march=avr out/llvm/main.ll -o $(BIN)/S/main.s
	llc -march=avr out/llvm/avr.ll -o $(BIN)/S/avr.s
	llc -march=avr out/llvm/m328p.ll -o $(BIN)/S/m328p.s
	llc -march=avr out/llvm/delay.ll -o $(BIN)/S/delay.s
	
	avr-gcc -mmcu=$(MCU) $(BIN)/S/main.s $(BIN)/S/avr.s $(BIN)/S/m328p.s $(BIN)/S/delay.s $(BIN)/S/led.s $(BIN)/S/animation.s -o $(BIN)/main.elf
	avr-objcopy -j .text -j .data -O ihex $(BIN)/main.elf $(BIN)/main.hex


C:
	mcc -o out/c/main -funsafe -mbackend=c src/main.m
	mcc -o out/c/avr/delay -funsafe -mbackend=c src/avr/delay.m
	mcc -o out/c/avr/avr -funsafe -mbackend=c src/avr/avr.m
	mcc -o out/c/avr/m328p -funsafe -mbackend=c src/avr/m328p.m
	mcc -o out/c/led -funsafe -mbackend=c src/led.m
	mcc -o out/c/animation -funsafe -mbackend=c src/animation.m
	mcc -o out/c/bsp -funsafe -mbackend=c src/bsp.m
	mcc -o out/c/rgb24 -funsafe -mbackend=c src/rgb24.m
	
	avr-gcc $(ALL_CFLAGS) -o $(BIN)/main.o out/c/main.c
	avr-gcc $(ALL_CFLAGS) -o $(BIN)/avr.o out/c/avr/avr.c
	avr-gcc $(ALL_CFLAGS) -o $(BIN)/m328p.o out/c/avr/m328p.c
	avr-gcc $(ALL_CFLAGS) -o $(BIN)/delay.o out/c/avr/delay.c
	avr-gcc $(ALL_CFLAGS) -o $(BIN)/led.o out/c/led.c
	avr-gcc $(ALL_CFLAGS) -o $(BIN)/animation.o out/c/animation.c
	avr-gcc $(ALL_CFLAGS) -o $(BIN)/bsp.o out/c/bsp.c
	avr-gcc $(ALL_LFLAGS) -o $(BIN)/main.elf $(BIN)/main.o $(BIN)/avr.o $(BIN)/animation.o $(BIN)/m328p.o $(BIN)/delay.o $(BIN)/led.o $(BIN)/bsp.o
	avr-objcopy -j .text -j .data -O ihex $(BIN)/main.elf $(BIN)/main.hex


CM:
	mcc -o out/cm/main -funsafe -mbackend=cm src/main.m
	mcc -o out/cm/avr -funsafe -mbackend=cm src/avr/avr.m
	mcc -o out/cm/m328p -funsafe -mbackend=cm src/avr/m328p.m
	mcc -o out/cm/delay -funsafe -mbackend=cm src/avr/delay.m


flash:
	avrdude -v -p $(MCU) -c arduino -P /dev/tty.usbserial-10 -b 57600 -D -U flash:w:bin/main.hex:i


