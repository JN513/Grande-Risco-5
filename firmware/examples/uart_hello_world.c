#include "risco5.h"
#include "uart.h"


int main() {
    uart_init();
    
    char msg[] = "Hello, World!\n";
    
    uart_write_string(msg, 15);

    return 0;
}
