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


verilator --cc --exe --build --trace --timing --timescale 1ns/1ps --top-module Grande_Risco_5_SOC \
    testbenchs/soc_main.cpp rtl/core/grande_risco5_types.sv rtl/core/csr_unit.sv rtl/core/branch_prediction.sv \
    rtl/core/alu_control.sv rtl/core/alu.sv rtl/core/bmu.sv  rtl/core/cache_request_multiplexer.sv rtl/core/core.sv \
    rtl/core/d_cache.sv rtl/core/EXMEM.sv rtl/core/forwarding_unit.sv rtl/core/fpu.sv rtl/core/i_cache.sv rtl/core/IDEX.sv \
    rtl/core/IFID.sv rtl/core/immediate_generator.sv rtl/core/ir_decomp.sv rtl/core/mdu.sv rtl/core/MEMWB.sv rtl/core/mux.sv \
    rtl/core/registers.sv rtl/core/Grande_Risco5.sv rtl/peripheral/memory.sv rtl/peripheral/leds.sv rtl/peripheral/soc.sv -Irtl/core

./obj_dir/VGrande_Risco_5_SOC

rm verification_tests/memory/generic.hex

echo "Teste $nome_do_teste, executado"