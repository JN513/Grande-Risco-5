.global _start

_start:
    addi a1, x0, 10      # Carrega o dividendo (10) em a1
    addi a2, x0, 3       # Carrega o divisor (3) em a2

    rem a3, a1, a2       # Resto da divisão de a1 por a2 (10 % 3)

    li a4, 0x9FAB53      # Carrega o valor esperado (0x9FAB53) em a4
