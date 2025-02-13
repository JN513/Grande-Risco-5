.globl _start

_start:
    li a0, -16       # Carrega -16 em a0 (binário de 32 bits: 11111111111111111111111111110000)

    c.srai a0, 2 # Desloca a0 à direita por 2 posições aritmeticamente e armazena o resultado em a1 (resultado: -4)

    # Resultado final em a1 será -4 (binário de 32 bits: 11111111111111111111111111111100)
