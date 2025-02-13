.globl _start

_start:
    li a0, 5       # Carrega 5 em a0 (binário: 0101)
    li a1, 3       # Carrega 3 em a1 (binário: 0011)

    c.or a0, a1 # Realiza OR entre a0 e a1, e armazena o resultado em a2 (resultado: 0111)

    # Resultado final em a2 será 7 (binário: 0111)
