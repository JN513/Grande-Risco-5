.global _start

_start:
    csrr a1, cycle;

    li a0, 0x1FF
    li a4, 0x6A

    csrr a1, cycle;

