.global _start

_start:
    addi a1, x0, 10      # Carrega o primeiro número (10) em a1
    addi a2, x0, 20      # Carrega o segundo número (20) em a2

    mul a3, a1, a2       # Multiplica a1 * a2 e armazena o resultado em a3

    li a4, 0x9FAB53      # Carrega o valor esperado (0x9FAB53) em a4
