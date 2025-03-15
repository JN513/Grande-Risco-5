.globl _start

_start:
    li a0, 0x4C414953
    li a1, 0xFFFFFFFF
    li a2, 0xAAAAAAAA

    sw a1, 80(zero)
    sw a2, 84(zero)


    lw a3, 80(zero)
    lw a4, 81(zero)
    lw a5, 82(zero)
    lw a6, 83(zero)
    lw a7, 84(zero)

    li a0, 0x9FCD5E15

    lhu a0, 83(zero)
