read_verilog "main.v"
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
set_property PROCESSING_ORDER EARLY [get_files pinout.xdc]

# synth
synth_design -top "top" -part "xc7vx690tffg1761-2"

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