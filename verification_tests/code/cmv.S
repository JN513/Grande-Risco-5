.globl _start

_start:
    li a0, 5         # Carrega 5 em a0
    li a1, 0         # Carrega 0 em a1

    c.mv a2, a0       # Se a0 != 0, a2 = a0; caso contrário, a2 = a1
