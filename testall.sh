#!/bin/bash
for compiler in gnu/13 intel/23.2  aocc/4.1.0 nvhpc/23.7 # llvm/17
do
 module unload gnu intel aocc nvhpc llvm 2>&1 >/dev/null
 module load $compiler 2>&1 >/dev/null
 echo "======================= $compiler ======================="
 $FC "$@" && ./a.out
 rm -f ./a.out
done
