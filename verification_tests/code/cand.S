.globl _start

_start:
    li a2, 0b1100  # Carrega o valor 0b1100 no registrador a2
    li a1, 0b1010  # Carrega o valor 0b1010 no registrador a1
    c.and a2, a1   # a2 = a2 AND a1 (resultado: 0b1000)
