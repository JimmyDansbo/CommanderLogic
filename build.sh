#!/bin/bash
echo "Removing files..."
rm -rf *.PRG
rm -rf *.prg
rm -rf ZSBG.BIN PARTFONT.BIN LEVELS.BIN
echo "Building ZSBG.BIN"
zsbg/build.sh
echo "Building PARTFONT.BIN"
acme -f cbm -o PARTFONT.BIN partialfont.asm
echo "Building LEVELS.BIN"
acme -f cbm -o LEVELS.BIN levels.asm
echo "Building COMLOG.PRG"
acme -f cbm -o COMLOG.PRG commanderlogic.asm
