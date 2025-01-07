#!/bin/bash

rm *.out &>/dev/null
rm *.o &>/dev/null
nasm 7.s -felf64 -o 7.o
nasm RI.s -felf64 -o RI.o
nasm CMS.s -felf64 -o CMS.o
nasm RIM.s -felf64 -o RIM.o
nasm DPTIMC.s -felf64 -o DPTIMC.o
nasm PI.s -felf64 -o PI.o
nasm PN.s -felf64 -o PN.o
gcc 7.o RI.o CMS.o RIM.o DPTIMC.o PI.o PN.o -o 7.out -no-pie
rm *.o &>/dev/null
echo "Done!"
./7.out
rm *.out &>/dev/null