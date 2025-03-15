.global _start

_start:
    li a1, 0x6C6F7665

    sw zero, 80(zero)
    sh a1, 80(zero)
    lw a2, 80(zero)

    li a3, 5
