.global _start

_start:
    li a1, 0x90000000 # Uart base address // 4C 41 49 53 20 4C 49 4E 44 41 0A

    li a2, 0x0000004C
    sw a2, 0(a1)

    li a2, 0x00000041
    sw a2, 0(a1)

    li a2, 0x00000049
    sw a2, 0(a1)
    
    li a2, 0x00000053
    sw a2, 0(a1)

    # ' '
    li a2, 0x00000020 # ' '
    sw a2, 0(a1)

    li a2, 0x0000004C
    sw a2, 0(a1)

    li a2, 0x00000049
    sw a2, 0(a1)

    li a2, 0x0000004E
    sw a2, 0(a1)

    li a2, 0x00000044
    sw a2, 0(a1)

    li a2, 0x00000041
    sw a2, 0(a1)

    # '\n'
    li a2, 0x0000000A # '\n
    sw a2, 0(a1)
    
    # Infinite loop
    loop:
        nop
        j loop


delay:
    li t0, 100000
    li t1, 0
delay_loop:
    addi t1, t1, 1
    bne t1, t0, delay_loop
    
    ret
