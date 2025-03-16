.globl interruption_handling
.globl isr_stack_end

interruption_handling:
    csrrw sp, mscratch, sp


    
    csrrw sp, mscratch, sp

    mret


.bss
.align 2
isr_stack: .skip 1024
isr_stack_end:
