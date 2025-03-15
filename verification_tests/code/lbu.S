.global _start

_start:
    li a1, 0xFF0008FF

    sw a1, 40(zero)
    lbu a2, 40(zero)
    lw a3, 40(zero)
