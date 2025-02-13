.globl _start

_start:
    li a0, 10      # Carrega 10 em a0
    li a1, 20      # Carrega 20 em a1

    c.nop          # No operation, não faz nada

    add a2, a0, a1 # Soma a0 e a1 e coloca o resultado em a2
