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

    char msg[] = "Grade Risco 5!\nAn Open Source RISC-V Core\n\n";
    
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

    char msg_[] = "RISC-V: Instruction Sets Want to be Free!!!\n\n";

    uart_write_string(msg_, 46);

    delay_ms(100);

    uart_write_int(0x4C616973, 16);
    uart_write_string(" is the magic number of this project.\n\n", 40);
    uart_write_int(127, 10);
    uart_write_string(" is the maximum value of a signed 8-bit integer.\n\n", 50);
    uart_write_string("\n\n", 2);

    delay_ms(100);

    char msg3[] = "To my dear platonic passion: Even though you probably never know this, since I met you, your beautiful smile and all your perfection have encouraged me to be a better person every day.\n\n";

    uart_write_string(msg3, 187);

    uart_write_string("CPU Frequency: ", 15);
    uint32_t cpu_freq = get_cpu_freq();
    uart_write_int(cpu_freq, 10);
    uart_write_string(" Hz\n\n", 5);
    uart_write_string("Starting LED Shift...\n", 23);

    led_shift();

    return 0;
}
