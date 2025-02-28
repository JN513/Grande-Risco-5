#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VGrande_Risco_5_SOC.h"

#define CLOCK_PERIOD 20 // 25 MHz -> 40 ns por ciclo

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);
    VGrande_Risco_5_SOC *soc = new VGrande_Risco_5_SOC;
    
    VerilatedVcdC *trace = new VerilatedVcdC;
    Verilated::traceEverOn(true);
    
    soc->trace(trace, 100);
    trace->set_time_unit("1ns");  // Define a resolução mínima de 1ns
    trace->open("build/soc.vcd");
    
    
    // Inicializa sinais
    soc->clk = 0;
    soc->rst_n = 0;
    soc->halt = 0;
    
    // Reset
    int i = 0;
    for (i = 0; i < 10; i++) {
        soc->clk = !soc->clk;
        soc->eval();
        trace->dump(i * CLOCK_PERIOD);
    }
    soc->rst_n = 1;
    
    // Simulação
    for (; i < 1000; i++) {
        soc->clk = !soc->clk;
        soc->eval();
        trace->dump(i * CLOCK_PERIOD);
        
        // Exemplo: verifica os LEDs
        if (i % 100 == 0) {
            printf("LEDs: %02X\n", soc->leds);
        }
    }
    
    trace->close();
    delete soc;
    delete trace;
    return 0;
}
