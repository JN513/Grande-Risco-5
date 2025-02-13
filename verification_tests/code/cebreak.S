.globl _start

_start:
    li a0, 0xDEAD  # Carrega um valor arbitrário no registrador a0
    c.ebreak       # Interrupção para depuração (breakpoint)
    li a1, 0xBEEF  # Essa instrução pode nunca ser executada
