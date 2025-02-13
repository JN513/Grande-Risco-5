.globl _start

_start:
    li a0, 0x5        # Carrega o valor 0x5 em a0 (0101 em binário)
    li a1, 0x3        # Carrega o valor 0x3 em a1 (0011 em binário)

    c.xor a0, a1  # Realiza XOR entre a0 e a1 e armazena o resultado em a2

    # O resultado da operação XOR de 0101 e 0011 é 0110 (0x6)
    # Portanto, o valor de a2 será 0x6
