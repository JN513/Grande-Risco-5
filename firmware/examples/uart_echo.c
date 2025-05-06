#include "risco5.h"
#include "uart.h"


int main() {
    char c;

    uart_init();
    
    while (1) {
        while (uart_rx_empty()) {}
        
        c = uart_read();
        
        uart_write(c);
    }

    return 0;
}
