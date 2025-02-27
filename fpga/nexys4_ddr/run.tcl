read_verilog -sv main.sv
read_verilog -sv ../../src/core/alu_control.sv
read_verilog -sv ../../src/core/alu.sv
read_verilog -sv ../../src/core/bmu.sv
read_verilog -sv ../../src/core/branch_prediction.sv
read_verilog -sv ../../src/core/cache_request_multiplexer.sv
read_verilog ../../src/core/core.v
read_verilog -sv ../../src/core/csr_unit.sv
read_verilog -sv ../../src/core/d_cache.sv
read_verilog -sv ../../src/core/forwarding_unit.sv
read_verilog -sv ../../src/core/fpu.sv
read_verilog ../../src/core/Grande_Risco5.v
read_verilog -sv ../../src/core/i_cache.sv
read_verilog -sv ../../src/core/immediate_generator.sv
read_verilog -sv ../../src/core/ir_decomp.sv
read_verilog -sv ../../src/core/mdu.sv
read_verilog -sv ../../src/core/mux.sv
read_verilog -sv ../../src/core/registers.sv
read_verilog -sv ../../src/peripheral/leds.sv
read_verilog -sv ../../src/peripheral/memory.sv
read_verilog -sv ../../src/peripheral/soc.sv

read_xdc "pinout.xdc"
set_property PROCESSING_ORDER EARLY [get_files pinout.xdc]

# synth
synth_design -top "top" -part "xc7a100tcsg324-1"

# place and route
opt_design
place_design

report_utilization -hierarchical -file reports/utilization_hierarchical_place.rpt
report_utilization -file reports/utilization_place.rpt
report_io -file reports/io.rpt
report_control_sets -verbose -file reports/control_sets.rpt
report_clock_utilization -file reports/clock_utilization.rpt

route_design

report_timing_summary -no_header -no_detailed_paths
report_route_status -file reports/route_status.rpt
report_drc -file reports/drc.rpt
report_timing_summary -datasheet -max_paths 10 -file reports/timing.rpt
report_power -file reports/power.rpt

# write bitstream
write_bitstream -force "./build/out.bit"

exit