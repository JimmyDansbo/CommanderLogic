#!/bin/bash
pth=$(dirname $0)
cl65 -t cx16 -g   -L $pth/../../zsound/lib \
   --asm-include-dir $pth/../../zsound/inc \
                  -C $pth/x16asm.cfg \
 -o $pth/../ZSBG.BIN $pth/zsbg.asm zsound.lib
