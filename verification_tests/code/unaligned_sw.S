.globl _start

_start:
    li a1, 0xFFFFFFFF
    li a2, 0x4A55494F

    sw zero, 80(zero)
    sw zero, 84(zero)
    sw zero, 88(zero)
    sw zero, 92(zero)

    sw a1, 81(zero)
    sw a2, 85(zero)

    lw a3, 80(zero)
    lw a4, 81(zero)
    lw a5, 84(zero)
    lw a6, 85(zero)
    lw a7, 88(zero)
