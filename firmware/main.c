#include "risco5.h"
#include "uart.h"
#include "gpio.h"

void led_shift(){
    int r = 0x001F;  // Valor inicial

    while (1) {
        set_led_value(r);
        
        // Faz shift circular nos primeiros 16 bits
        r = ((r << 1) & 0xFFFF) | ((r >> 15) & 0x1);
    
        delay_ms(100);
    }
}

int main() {
    uart_init();

    char msg[] = "Grade Risco 5!\nA Open Source RISC-V Core\n\n";
    
    uart_write_string(msg, 43);
    
    char palavra1[] = " CCC   OOO  FFFFF FFFFF EEEEE EEEEE \n";
    char palavra2[] = "C   C O   O F     F     E     E     \n";
    char palavra3[] = "C     O   O FFFF  FFFF  EEE   EEE   \n";
    char palavra4[] = "C   C O   O F     F     E     E     \n";
    char palavra5[] = " CCC   OOO  F     F     EEEEE EEEEE \n";
    
    uart_write_string(palavra1, 38);
    uart_write_string(palavra2, 38);
    uart_write_string(palavra3, 38);
    uart_write_string(palavra4, 38);
    uart_write_string(palavra5, 38);

    uart_write_string("\n\n", 2);

    char msg2[] = "RISC-V: Instruction Sets Want to be Free!!!\n\n";

    uart_write_string(msg2, 46);

    led_shift();

    return 0;
}
