.globl _start

_start:
    li a1, 1
    li a2, 2
    li a3, 3
    li a4, 4
    li a5, 5

loop:
    addi a1, a1, 1
    addi a2, a2, 3
    addi a3, a3, 5
    addi a4, a4, 7
    addi a5, a5, 9

    j loop

    li a6, 0x9ABC
    li a7, 0x9ABC
    li x18, 0x9ABC
