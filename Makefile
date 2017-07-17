all: ascii2hgr2bit packedlogo.s linuxlogo dsk
.PHONY: clean

clean:
	rm -f ascii2hgr2bit packedlogo.s linuxlogo

packedlogo.s: ascii2hgr2bit
	ascii2hgr2bit > packedlogo.s

# https://www.brutaldeluxe.fr/products/crossdevtools/merlin/index.html
linuxlogo:   linuxlogo.s
	merlin32 $<

# a2tools
dsk: linuxlogo
	-a2rm       ll_6502.dsk LINUXLOGO > /dev/null 2>&1
	a2in B.0900 ll_6502.dsk LINUXLOGO linuxlogo

ascii2hgr2bit: ascii2hgr2bit.c
	gcc -Wall -Wextra $< -o $@

