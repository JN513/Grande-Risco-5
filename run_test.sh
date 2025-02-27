#!/usr/bin/bash

mkdir -p build

# Verifica se um argumento foi passado, caso contrário executa read
if [ -z "$1" ]; then
    echo "Digite o nome do teste:"
    read nome_do_teste
else
    nome_do_teste=$1
fi

cp verification_tests/memory/$nome_do_teste.hex verification_tests/memory/generic.hex

iverilog -o build/soc.o -s soc_tb -I rtl/core -g2012 rtl/core/alu_control.sv rtl/core/alu.sv \
    rtl/core/Grande_Risco5.v rtl/core/core.v rtl/core/forwarding_unit.sv rtl/core/immediate_generator.sv \
    rtl/core/mux.sv rtl/core/registers.sv rtl/core/csr_unit.sv rtl/core/fpu.sv rtl/core/bmu.sv \
    rtl/core/i_cache.sv rtl/core/d_cache.sv rtl/core/branch_prediction.sv rtl/core/mdu.sv \
    rtl/core/cache_request_multiplexer.sv rtl/peripheral/memory.sv tests/soc_test.sv \
    rtl/peripheral/leds.sv rtl/peripheral/soc.sv rtl/core/ir_decomp.sv

vvp build/soc.o

rm verification_tests/memory/generic.hex

echo "Teste $nome_do_teste, executado"