read_verilog -sv main.sv
read_verilog -sv ../../rtl/core/grande_risco5_types.sv
read_verilog -sv ../../rtl/core/alu_control.sv
read_verilog -sv ../../rtl/core/alu.sv
read_verilog -sv ../../rtl/core/bmu.sv
read_verilog -sv ../../rtl/core/branch_prediction.sv
read_verilog -sv ../../rtl/core/cache_request_multiplexer.sv
read_verilog -sv ../../rtl/core/core.sv
read_verilog -sv ../../rtl/core/csr_unit.sv
read_verilog -sv ../../rtl/core/d_cache.sv
read_verilog -sv ../../rtl/core/forwarding_unit.sv
read_verilog -sv ../../rtl/core/fpu.sv
read_verilog -sv ../../rtl/core/Grande_Risco5.sv
read_verilog -sv ../../rtl/core/i_cache.sv
read_verilog -sv ../../rtl/core/immediate_generator.sv
read_verilog -sv ../../rtl/core/ir_decomp.sv
read_verilog -sv ../../rtl/core/mdu.sv
read_verilog -sv ../../rtl/core/mux.sv
read_verilog -sv ../../rtl/core/registers.sv
read_verilog -sv ../../rtl/core/IFID.sv
read_verilog -sv ../../rtl/core/IDEX.sv
read_verilog -sv ../../rtl/core/EXMEM.sv
read_verilog -sv ../../rtl/core/MEMWB.sv
read_verilog -sv ../../rtl/core/invalid_ir_check.sv
read_verilog -sv ../../rtl/peripheral/leds.sv
read_verilog -sv ../../rtl/peripheral/memory.sv
read_verilog -sv ../../rtl/peripheral/dram_controller.sv
read_verilog -sv ../../rtl/peripheral/fifo.sv
read_verilog -sv ../../rtl/peripheral/gpio.sv
read_verilog -sv ../../rtl/peripheral/gpios.sv
read_verilog -sv ../../rtl/peripheral/i2c_master.sv
read_verilog -sv ../../rtl/peripheral/peripheral_bus.sv
read_verilog -sv ../../rtl/peripheral/pwm.sv
read_verilog -sv ../../rtl/peripheral/spi_master.sv
read_verilog -sv ../../rtl/peripheral/timer.sv
read_verilog -sv ../../rtl/peripheral/uart_rx.sv
read_verilog -sv ../../rtl/peripheral/uart_tx.sv
read_verilog -sv ../../rtl/peripheral/uart.sv
read_verilog -sv ../../rtl/peripheral/vga.sv
read_verilog -sv ../../rtl/peripheral/soc.sv

# Adiciona o IP clk_wiz_0
read_verilog ./ip/clk_wiz_0/clk_wiz_0_clk_wiz.v
read_verilog ./ip/clk_wiz_0/clk_wiz_0.v
read_xdc     ./ip/clk_wiz_0/clk_wiz_0.xdc

read_xdc "pinout.xdc"
set_property PROCESSING_ORDER EARLY [get_files pinout.xdc]
set_property PROCESSING_ORDER EARLY [get_files ./ip/clk_wiz_0/clk_wiz_0.xdc]

# synth
synth_design -top "top" -part "xc7a100tcsg324-1"

# place and route
opt_design
place_design

report_utilization -hierarchical -file reports/utilization_hierarchical_place.rpt
report_utilization -file               reports/utilization_place.rpt
report_io -file                        reports/io.rpt
report_control_sets -verbose -file     reports/control_sets.rpt
report_clock_utilization -file         reports/clock_utilization.rpt

route_design

report_timing_summary -no_header -no_detailed_paths
report_route_status -file                            reports/route_status.rpt
report_drc -file                                     reports/drc.rpt
report_timing_summary -datasheet -max_paths 10 -file reports/timing.rpt
report_power -file                                   reports/power.rpt

# write bitstream
write_bitstream -force "./build/out.bit"

exit
