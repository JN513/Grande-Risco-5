.globl _start

.equ mhzfreq, 0xFC1

_start:
    csrr a0, mhzfreq
