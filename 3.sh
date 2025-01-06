#!/bin/bash

rm *.out &>/dev/null
rm *.o &>/dev/null
nasm 3.s -felf64 -o 3.o
nasm RI.s -felf64 -o RI.o
nasm CMS.s -felf64 -o CMS.o
nasm RFM.s -felf64 -o RFM.o
nasm RF.s -felf64 -o RF.o
nasm MFM.s -felf64 -o MFM.o
nasm PFM.s -felf64 -o PFM.o
nasm PF.s -felf64 -o PF.o
nasm PN.s -felf64 -o PN.o
gcc 3.o RI.o CMS.o RFM.o RF.o MFM.o PFM.o PF.o PN.o -o 3.out -no-pie
rm *.o &>/dev/null
echo "Done!"
./3.out
rm *.out &>/dev/null
