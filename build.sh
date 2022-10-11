#!/bin/bash
rm -rf *.PRG
rm -rf *.prg
acme -f cbm -o DRAWING.PRG drawing.asm
acme -f cbm -o PARTFONT.BIN partialfont.asm
acme -f cbm -o LEVELS.BIN levels.asm
acme -f cbm -o COMLOG.PRG commanderlogic.asm
