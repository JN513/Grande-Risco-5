#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VGrande_Risco_5_SOC.h"

#define CLOCK_PERIOD 40 // 25 MHz -> 40 ns por ciclo

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
    for (int i = 0; i < 10; i++) {
        soc->clk = 0;
        soc->eval();
        trace->dump(i * CLOCK_PERIOD);
    
        soc->clk = 1;
        soc->eval();
        trace->dump(i * CLOCK_PERIOD + CLOCK_PERIOD / 2);
    }
    soc->rst_n = 1;
    
    // Simulação
    for (int i = 0; i < 1000; i++) {
        soc->clk = 0;
        soc->eval();
        trace->dump(i * CLOCK_PERIOD);
    
        soc->clk = 1;
        soc->eval();
        trace->dump(i * CLOCK_PERIOD + CLOCK_PERIOD / 2);

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
