#!/bin/bash
rm -rf *.PRG
rm -rf *.prg
zsbg/build.sh
acme -f cbm -o PARTFONT.BIN partialfont.asm
acme -f cbm -o LEVELS.BIN levels.asm
acme -f cbm -o COMLOG.PRG commanderlogic.asm
