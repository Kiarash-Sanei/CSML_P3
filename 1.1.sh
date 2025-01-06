#!/bin/bash

rm *.out &>/dev/null
rm *.o &>/dev/null
nasm 1.1.s -felf64 -o 1.1.o
nasm RI.s -felf64 -o RI.o
nasm CMS.s -felf64 -o CMS.o
nasm RIM.s -felf64 -o RIM.o
nasm MIM.s -felf64 -o MIM.o
nasm PIM.s -felf64 -o PIM.o
nasm PI.s -felf64 -o PI.o
nasm PN.s -felf64 -o PN.o
gcc 1.1.o RI.o CMS.o RIM.o MIM.o PIM.o PI.o PN.o -o 1.1.out -no-pie
rm *.o &>/dev/null
echo "Done!"
./1.1.out
rm *.out &>/dev/null