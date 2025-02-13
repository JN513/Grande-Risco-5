.globl _start

_start:
    li a2, 0b1100  # Carrega o valor 0b1100 no registrador a2
    c.andi a2, 0b101  # a2 = a2 AND 0b101 (resultado: 0b0100)
