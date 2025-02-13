.globl _start

_start:
    li a0, 0x3    # Carrega o valor 3 no registrador a0
    li a1, 0x2    # Carrega o valor 2 no registrador a1

    c.addi a0, 0x4  # Adiciona 4 ao registrador a0 (a0 = a0 + 4)
