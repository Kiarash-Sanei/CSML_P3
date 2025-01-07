#!/bin/bash

rm *.out &>/dev/null
rm *.o &>/dev/null
nasm 6.s -felf64 -o 6.o
nasm RI.s -felf64 -o RI.o
nasm CMS.s -felf64 -o CMS.o
nasm RFM.s -felf64 -o RFM.o
nasm RF.s -felf64 -o RF.o
nasm TFM.s -felf64 -o TFM.o
nasm MPFM.s -felf64 -o MPFM.o
nasm TFMC.s -felf64 -o TFMC.o
nasm PF.s -felf64 -o PF.o
nasm PN.s -felf64 -o PN.o
gcc 6.o RI.o CMS.o RFM.o RF.o TFM.o MPFM.o TFMC.o PF.o PN.o -o 6.out -no-pie
rm *.o &>/dev/null
echo "Done!"
./6.out
rm *.out &>/dev/null
