.globl _start

_start:
    li sp, 0x1000       # Inicializa o ponteiro de pilha em 0x1000
    c.addi16sp sp, -32  # sp = sp - 32 (Reserva espaço na pilha)
