.globl _start

_start:
    li a0, 40
    li a1, 20

    sw a1, 0(a0) # Armazena o valor de a1 no endereço de memória a0

    c.lw a2, 0(a0)
    