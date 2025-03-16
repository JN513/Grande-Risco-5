#include "risco5.h"
#include "gpio.h"


int main() {
    
    for(int i = 0; i <= 0xFFFF; i++) {
        set_led_value(i);
        delay_ms(1000);
    }

    return 0;
}
