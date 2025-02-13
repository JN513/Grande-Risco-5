.globl _start

_start:
    c.lui a1, 0x1    # Carrega o valor imediato 0x12345 no registrador a1
    c.lui a2, 0xA    # Carrega o valor imediato 0xABCDE no registrador a2
    c.lui a3, 0xF    # Carrega o valor imediato 0xFFFFF no registrador a3

    # Você pode usar os valores em a1, a2 e a3 em outras instruções
    li a4, 0x0           # Apenas uma instrução para ilustrar
