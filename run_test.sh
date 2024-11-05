#!/usr/bin/bash

mkdir -p build

# Verifica se um argumento foi passado, caso contrário executa read
if [ -z "$1" ]; then
    echo "Digite o nome do teste:"
    read nome_do_teste
else
    nome_do_teste=$1
fi

cp software/memory/$nome_do_teste.hex software/memory/generic.hex

iverilog -o build/core.o -s core_tb src/core/alu_control.v src/core/alu.v src/core/core.v src/core/forwarding_unit.v src/core/immediate_generator.v src/core/mux.v src/core/registers.v tests/core_test.v src/peripheral/memory.v
vvp build/core.o

rm software/memory/generic.hex

echo "Teste $nome_do_teste, executado"