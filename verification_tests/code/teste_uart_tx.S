.global _start

_start:
    li a1, 0x90000000 # Uart base address
    # 'L'
    li a2, 0x0000004C # 'L
    sw a2, 0(a1)
    # 'A'
    li a2, 0x00000041 # 'A
    sw a2, 0(a1)
    # 'I'
    li a2, 0x00000049 # 'I
    sw a2, 0(a1)
    # 'S'
    li a2, 0x00000053 # 'S
    sw a2, 0(a1)
    # '\n'
    li a2, 0x0000000A # '\n
    sw a2, 0(a1)
    
