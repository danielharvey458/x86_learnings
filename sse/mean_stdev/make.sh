#!/bin/bash
set -eu

${CPP_COMPILER} --std=c++1y meanstd.cpp -o meanstd.o -c -g -O3
yasm -f elf64 -g dwarf2 meanstd_asm.asm
${CPP_COMPILER} --std=c++1y -o meanstd meanstd.o meanstd_asm.o -g 
