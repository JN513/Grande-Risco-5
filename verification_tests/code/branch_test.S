.text
.global _start

_start:
    addi a1, zero, 1      # Carrega o primeiro número (10) em a1
    addi a2, zero, 2      # Carrega o segundo número (20) em a2

    beq a1, a1, equal

    nop # c
    nop # 10
    nop # 14
    nop # 18

equal:
    li a5, 15 # 1C
