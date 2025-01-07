#!/bin/bash

rm *.out &>/dev/null
rm *.o &>/dev/null
nasm 5.s -felf64 -o 5.o
nasm RI.s -felf64 -o RI.o
nasm CMS.s -felf64 -o CMS.o
nasm RIM.s -felf64 -o RIM.o
nasm DTIMC.s -felf64 -o DTIMC.o
nasm PI.s -felf64 -o PI.o
nasm PN.s -felf64 -o PN.o
gcc 5.o RI.o CMS.o RIM.o DTIMC.o PI.o PN.o -o 5.out -no-pie
rm *.o &>/dev/null
echo "Done!"
./5.out
rm *.out &>/dev/null