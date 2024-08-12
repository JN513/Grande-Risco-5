.global _start

_start:
    addi a1, x0, 10      # Carrega o primeiro número (10) em a1
    addi a2, x0, 20      # Carrega o segundo número (20) em a2
    addi a3, x0, 30       # Inicializa o registrador a3 com 0

    add a4, a2, a3       # Soma a1 e a2, armazena o resultado em a3
