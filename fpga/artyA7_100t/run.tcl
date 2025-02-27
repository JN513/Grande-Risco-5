read_verilog "main.v"
read_verilog ../../debug/reset.v
read_verilog ../../src/core/alu_control.v
read_verilog ../../src/core/alu.v
read_verilog ../../src/core/bmu.v
read_verilog ../../src/core/branch_prediction.v
read_verilog ../../src/core/cache_request_multiplexer.v
read_verilog ../../src/core/core.v
read_verilog ../../src/core/csr_unit.v
read_verilog ../../src/core/d_cache.v
read_verilog ../../src/core/forwarding_unit.v
read_verilog ../../src/core/fpu.v
read_verilog ../../src/core/Grande_Risco5.v
read_verilog ../../src/core/i_cache.v
read_verilog ../../src/core/immediate_generator.v
read_verilog ../../src/core/ir_decomp.v
read_verilog ../../src/core/mdu.v
read_verilog ../../src/core/mux.v
read_verilog ../../src/core/registers.v
read_verilog ../../src/peripheral/leds.v
read_verilog ../../src/peripheral/memory.v
read_verilog ../../src/peripheral/soc.v

read_xdc "pinout.xdc"

# synth
synth_design -top "top" -part "xc7a100tcsg324-1"

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "./build/out.bit"