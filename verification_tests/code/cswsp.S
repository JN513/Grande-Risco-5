.globl _start

_start:
    li sp, 60
    li a0, 42          # Carrega o valor 42 em a0 (valor a ser armazenado)

    c.swsp a0, 0(sp)   # Armazena o valor de a0 (42) no endereço de memória apontado por x2 + 0

    # Após essa instrução, o valor 42 será armazenado no endereço apontado por x2 (ponteiro de pilha)
    lw a2, 0(sp)       # Carrega o valor armazenado no endereço apontado por x2 para a2
