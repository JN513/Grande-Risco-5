.globl _start

_start:
    li a0, 10        # Carrega 10 em a0
    li a1, 4         # Carrega 4 em a1

    c.sub a0, a1 # Subtrai a1 de a0 e armazena o resultado em a2 (resultado: 6)

    # Resultado final em a2 será 6
