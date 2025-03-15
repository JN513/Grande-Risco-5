.globl _start

_start:
    li a1, 0x80000000
    li a2, 0x0000AAAA
    sw a2, 0(a1)
