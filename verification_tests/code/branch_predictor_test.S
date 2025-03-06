.globl _start

_start:
    li a0, 0x0
    li a1, 0x1
    li a2, 0x2
    li a3, 0x0

    # Test 1: Branch taken
    loop:
        addi a3, a3, 1
        bne a0, a1, loop
        li a3, 0x1
