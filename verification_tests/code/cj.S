.globl _start

_start:
    li a0, 0x1234  # Carrega um valor arbitrário no registrador a0
    c.j target     # Salta incondicionalmente para 'target'
    li a1, 0x5678  # Essa instrução será ignorada devido ao salto

target:
    li a2, 0x9ABC  # Esta instrução será executada após o salto
