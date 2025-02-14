.global _start

_start:
    li a1, 0x7FFFFFFF
    li a2, 0x12345678

    mulh a3, a1, a2      # Multiplicação alta (parte superior) de a1 * a2

    li a4, 0x9FAB53      # Carrega o valor esperado (0x9FAB53) em a4
