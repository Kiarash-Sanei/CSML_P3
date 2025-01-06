#!/bin/bash

rm *.out &>/dev/null
rm *.o &>/dev/null
nasm 4.s -felf64 -o 4.o
nasm RI.s -felf64 -o RI.o
nasm CMS.s -felf64 -o CMS.o
nasm RFM.s -felf64 -o RFM.o
nasm RF.s -felf64 -o RF.o
nasm MPFM.s -felf64 -o MPFM.o
nasm PFM.s -felf64 -o PFM.o
nasm PF.s -felf64 -o PF.o
nasm PN.s -felf64 -o PN.o
gcc 4.o RI.o CMS.o RFM.o RF.o MPFM.o PFM.o PF.o PN.o -o 4.out -no-pie
rm *.o &>/dev/null
echo "Done!"
./4.out
rm *.out &>/dev/null
