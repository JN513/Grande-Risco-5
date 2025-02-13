.globl _start

_start:
    li a0, -16       # Carrega -16 em a0 (binário de 32 bits: 11111111111111111111111111110000)

    c.srli a0, 2 # Desloca a0 à direita por 2 posições logicamente e armazena o resultado em a1 (resultado: 1073741821)

    # Resultado final em a1 será 1073741821 (binário de 32 bits: 00111111111111111111111111111101)
