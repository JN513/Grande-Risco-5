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

iverilog -o build/soc.o -s soc_tb -I src/core src/core/alu_control.v src/core/alu.v \
    src/core/Grande_Risco5.v src/core/core.v src/core/forwarding_unit.v src/core/immediate_generator.v \
    src/core/mux.v src/core/registers.v src/core/csr_unit.v src/core/fpu.v src/core/bmu.v \
    src/core/i_cache.v src/core/d_cache.v src/core/branch_prediction.v src/core/mdu.v \
    src/core/cache_request_multiplexer.v src/peripheral/memory.v tests/soc_test.v \
    src/peripheral/leds.v src/peripheral/soc.v src/core/ir_decomp.v

vvp build/soc.o

rm verification_tests/memory/generic.hex

echo "Teste $nome_do_teste, executado"