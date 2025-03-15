.global _start

_start:
    li a1, 0xFF08FFFF

    sw a1, 40(zero)
    lh a2, 40(zero)
    lw a3, 40(zero)
