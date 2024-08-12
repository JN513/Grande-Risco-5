#!/usr/bin/zsh

mkdir -p build

echo "Digite o nome do teste:"
read nome_do_teste

cp software/memory/$nome_do_teste.hex software/memory/generic.hex

iverilog -o build/core_test.o -s core_tb src/core/* src/peripheral/memory.v tests/core_test.v
vvp build/core_test.o

rm software/memory/generic.hex

echo "Teste $nome_do_teste, executado"