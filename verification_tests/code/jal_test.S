.text
.global _start

_start:
    addi a1, zero, 10      # Carrega o primeiro número (10) em a1
    addi a2, zero, 20      # Carrega o segundo número (20) em a2

    jal desvio

    nop
    nop
    nop
    nop

desvio:
    li a5, 15
