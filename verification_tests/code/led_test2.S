.globl _start

_start:
    li sp, 1024
    li a1, 0xF0000000
    li a2, 0x000000AA

    sw a2, 0(a1)

    li a3, 0
    li a4, 255

loop:
    sw a3, 0(a1)
    addi a3, a3, 1
    call delay
    bne a3, a4, loop

    li a3, 0

    j loop

delay:
    li t0, 1000000
    li t1, 0
delay_loop:
    addi t1, t1, 1
    bne t1, t0, delay_loop
    
    ret
