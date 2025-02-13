.globl _start

_start:
    li a0, 60      # Carrega o endereço 0x1000 em a0 (endereço de memória)
    li a1, 42          # Carrega o valor 42 em a1 (valor a ser armazenado)

    c.sw a1, 0(a0)     # Armazena o valor de a1 (42) no endereço 0x1000

    # Após essa instrução, o valor 42 será armazenado no endereço 0x1000
    lw a2, 0(a0)       # Carrega o valor armazenado no endereço 0x1000 para a2
