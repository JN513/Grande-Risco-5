#include "risco5.h"


int strlen(const char *str){
    int i = 0;

    while(str[i] != '\0') i++;

    return i;
}

uint32_t get_cycle_value()
{
    uint32_t cycle;

    cycle = read_csr(cycle);
    
    return cycle;
}

void busy_wait(uint32_t ms)
{
    uint32_t tmp;
    uint32_t count;

    count = ms * MS_TO_CYCLES;
    tmp = get_cycle_value();

    while (get_cycle_value() < (tmp + count));
}