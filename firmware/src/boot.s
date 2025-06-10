.globl _start
.extern interruption_handling
.extern isr_stack_end
.set MEMORY_SIZE, 65536
.set STACK_INIT, MEMORY_SIZE - 4

_start:

init_csrs:
    la t0, isr_stack_end
    csrw mscratch, t0

    la t0, interruption_handling
    csrw mtvec, t0

    li t0, 0x800
    csrs mie, t0 # enable external interrupts (mie.MEIE <= 1)

    csrrsi zero, mstatus, 8 # enable interrupts (mstatus.MIE <= 1)

clean_registers:
    li x1,  0
    li x2,  0
    li x3,  0
    li x4,  0
    li x5,  0
    li x6,  0
    li x7,  0
    li x8,  0
    li x9,  0
    li x10, 0
    li x11, 0
    li x12, 0
    li x13, 0
    li x14, 0
    li x15, 0
    li x16, 0
    li x17, 0
    li x18, 0
    li x19, 0
    li x20, 0
    li x21, 0
    li x22, 0
    li x23, 0
    li x24, 0
    li x25, 0
    li x26, 0
    li x27, 0
    li x28, 0
    li x29, 0
    li x30, 0
    li x31, 0

init_registers:

    li sp, STACK_INIT # Inicializa o ponteiro da pilha
    li fp, STACK_INIT # Inicializa o ponteiro do frame

    jal main          # Salta e liga para a função main
    
    jal exit          # Salta e liga para a função exit


exit:
	nop
	j exit
