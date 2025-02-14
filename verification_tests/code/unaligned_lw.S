.globl _start

_start:
    li a0, 0x1000
    li a1, 61

    sw zero, -1(a1)
    sw zero, 3(a1)
    sw a0, 0(a1)

    lw a2, 0(a1)

    li a3, 0x9FCD5E15
