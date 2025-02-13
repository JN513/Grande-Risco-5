.globl _start

_start:
    li a0, 4       # Carrega 4 em a0 (binário: 0100)

    c.slli a0, 2 # Desloca a0 à esquerda por 2 posições e armazena o resultado em a1 (resultado: 16)

    # Resultado final em a1 será 16 (binário: 10000)
