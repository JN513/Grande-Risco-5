yosys read_verilog GR5.v

yosys synth_gowin -json ./build/out.json -abc9
