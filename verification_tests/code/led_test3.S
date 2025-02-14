.globl _start

_start:
    li a1, 0xF0000000
    li a2, 0x000000AA

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    li a3, 0x9ABC
    sw a2, 0(a1)
