.globl _start

_start:
    li a0, 0x1234   # Carrega um valor arbitrário no registrador a0
    c.jal target     # Salta para 'target' e armazena o endereço de retorno em x1
    li a1, 0x5678    # Esta instrução será ignorada devido ao salto

target:
    li a2, 0x9ABC    # Esta instrução será executada após o salto
    # O endereço de retorno foi salvo em x1, permitindo o retorno ao _start
