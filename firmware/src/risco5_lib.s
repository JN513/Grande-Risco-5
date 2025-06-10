.global get_cycle_value # Declara a função get_cycle_value global
.global get_cpu_freq # Declara a função get_cpu_freq global

.equ mhzfreq, 0xFC1

get_cpu_freq:
    csrr a0, mhzfreq

    ret

get_cycle_value:
    csrr a0, cycle;
    csrr a1, cycleh;

    ret