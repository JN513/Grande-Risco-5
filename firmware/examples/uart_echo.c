#include "risco5.h"
#include "uart.h"


int main() {
    enable_uart_rx();
    set_uart_parity_type(1);
    
    while (1) {
        while (uart_rx_empty()) {}
        char c = uart_read();
        uart_write(c);
    }

    return 0;
}
