.globl _start

_start:
    la a0, target       # Carrega o endereço de destino no registrador a0
    c.jalr a0           # Salta para o endereço em a0 e armazena o endereço de retorno em x1
    li a2, 0x5678       # Esta instrução será ignorada devido ao salto

# O destino do salto é 'target', que está no endereço armazenado em a0
target:
    li a3, 0x9ABC       # Esta instrução será executada após o salto
