.globl _start

_start:
    li a1, 0x616D6F72

    sw zero, 80(zero)
    sb a1, 80(zero)
    lw a2, 80(zero)
    li a3, 3

    sw zero, 80(zero)
    sb a1, 81(zero)
    lw a2, 80(zero)
    li a3, 5

    sw zero, 80(zero)
    sb a1, 82(zero)
    lw a2, 80(zero)

    li a3, 7

    sw zero, 80(zero)
    sw zero, 84(zero)
    sb a1, 83(zero)
    lw a2, 80(zero)
    lw a4, 84(zero)

    li a3, 9

    sw zero, 80(zero)
    sb a1, 84(zero)
    lw a2, 80(zero)
    lw a4, 84(zero)

    li a3, 11
