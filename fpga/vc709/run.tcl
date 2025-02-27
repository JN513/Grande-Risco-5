read_verilog -sv main.sv
read_verilog -sv ../../rtl/core/alu_control.sv
read_verilog -sv ../../rtl/core/alu.sv
read_verilog -sv ../../rtl/core/bmu.sv
read_verilog -sv ../../rtl/core/branch_prediction.sv
read_verilog -sv ../../rtl/core/cache_request_multiplexer.sv
read_verilog ../../rtl/core/core.v
read_verilog -sv ../../rtl/core/csr_unit.sv
read_verilog -sv ../../rtl/core/d_cache.sv
read_verilog -sv ../../rtl/core/forwarding_unit.sv
read_verilog -sv ../../rtl/core/fpu.sv
read_verilog ../../rtl/core/Grande_Risco5.v
read_verilog -sv ../../rtl/core/i_cache.sv
read_verilog -sv ../../rtl/core/immediate_generator.sv
read_verilog -sv ../../rtl/core/ir_decomp.sv
read_verilog -sv ../../rtl/core/mdu.sv
read_verilog -sv ../../rtl/core/mux.sv
read_verilog -sv ../../rtl/core/registers.sv
read_verilog -sv ../../rtl/peripheral/leds.sv
read_verilog -sv ../../rtl/peripheral/memory.sv
read_verilog -sv ../../rtl/peripheral/soc.sv

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