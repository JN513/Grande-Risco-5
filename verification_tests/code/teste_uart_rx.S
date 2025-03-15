.global _start

_start:
    li a1, 0x90000000 # Uart base address
    
    read_loop:

    lw a0, 4(a1)

    beqz a0, loop_delay

    lw a2, 0(a1)
    sw a2, 0(a1)

    loop_delay:
        call delay
    j read_loop

    # Infinite loop
    loop:
        nop
        j loop


delay:
    li t0, 10
    li t1, 0
delay_loop:
    addi t1, t1, 1
    bne t1, t0, delay_loop
    
    ret
