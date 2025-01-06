#!/bin/bash

rm *.out &>/dev/null
rm *.o &>/dev/null
nasm 2.s -felf64 -o 2.o
nasm RI.s -felf64 -o RI.o
nasm CMS.s -felf64 -o CMS.o
nasm RIM.s -felf64 -o RIM.o
nasm TIM.s -felf64 -o TIM.o
nasm MIM.s -felf64 -o MIM.o
nasm TIMC.s -felf64 -o TIMC.o
nasm PI.s -felf64 -o PI.o
nasm PN.s -felf64 -o PN.o
gcc 2.o RI.o CMS.o RIM.o TIM.o MIM.o TIMC.o PI.o PN.o -o 2.out -no-pie
rm *.o &>/dev/null
echo "Done!"
./2.out
rm *.out &>/dev/null
