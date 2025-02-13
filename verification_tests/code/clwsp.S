.globl _start

_start:
    li sp, 128      # Inicializa o ponteiro de pilha em 0x1000
    addi sp, sp, -8
    li a0, 0x3    # Carrega o valor 3 no registrador a0
    li a1, 0x2    # Carrega o valor 2 no registrador a1
    sw a1, 0(sp) # Armazena o valor de a1 no endereço de memória sp + 0
    sw a0, 4(sp) # Armazena o valor de a0 no endereço de memória sp + 4

    # c.lwsp rd, offset -> Carrega uma palavra (32 bits) de memória para rd, com base em sp + offset
    # Exemplo 1: c.lwsp a0, 0 -> Carrega a palavra de memória em sp + 0 para a0
    c.lwsp a3, 0(sp)
    c.lwsp a2, 4(sp)
