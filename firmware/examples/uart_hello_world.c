#include "risco5.h"
#include "uart.h"


int main() {
    
    char msg[] = "Hello, World!\n\0";
    
    uart_write_string(msg);

    return 0;
}
