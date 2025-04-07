#include "risco5.h"
#include "uart.h"


int main() {
    char msg[] = "Hello, World!\0";
    
    int size = strlen(msg);

    for(int i = 0; i < size; i++) {
        uart_write(msg[i]);
    }

    return 0;
}
