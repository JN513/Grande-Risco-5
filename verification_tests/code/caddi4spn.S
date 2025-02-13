.globl _start

_start:
    li sp, 0x1000      # Inicializa o ponteiro de pilha em 0x1000
    c.addi4spn a0, sp, 16  # a0 = sp + 16
