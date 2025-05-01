#include "risco5.h"
#include "uart.h"
#include "conversion.h"

int uart_read_string(char *data, int size) {
    int i = 0;
    while (i < size) {
        while (uart_rx_empty()) {}
        data[i] = uart_read();
        i++;
    }
    return i;
}

void uart_write_string(char *data) {
    int size = strlen(data);
    int i = 0;
    while (i < size) {
        while(uart_tx_full()){}
        uart_write(data[i]);
        i++;
    }
}

void uart_write_int(int data) {
    char buffer[10];
    itoa(data, buffer, 10);
    uart_write_string(buffer);
}

void uart_set_baud_rate(int baud_rate){
    int bit_period = CLK_FREQ / baud_rate;
    set_uart_bit_period(bit_period);
}

void uart_init(){
    uart_set_baud_rate(115200);
    enable_uart_rx();
}