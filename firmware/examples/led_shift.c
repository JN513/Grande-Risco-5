#include "risco5.h"
#include "gpio.h"


int main() {
    int r = 0x001F;  // Valor inicial

    while (1) {
        set_led_value(r);
        
        // Faz shift circular nos primeiros 16 bits
        r = ((r << 1) & 0xFFFF) | ((r >> 15) & 0x1);
    
        delay_ms(100);
    }
    
    return 0;
}
