yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral main.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/grande_risco5_types.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/alu_control.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/alu.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/bmu.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/branch_prediction.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/cache_request_multiplexer.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/core.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/csr_unit.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/d_cache.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/forwarding_unit.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/fpu.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/Grande_Risco5.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/i_cache.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/immediate_generator.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/ir_decomp.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/mdu.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/mux.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/registers.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/IFID.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/IDEX.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/EXMEM.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/MEMWB.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/core/invalid_ir_check.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/leds.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/memory.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/dram_controller.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/fifo.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/gpio.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/gpios.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/i2c_master.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/peripheral_bus.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/pwm.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/spi_master.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/timer.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/uart_rx.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/uart_tx.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/uart.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/vga.sv
yosys read_systemverilog -defer -I../../rtl/core -i../../rtl/peripheral ../../rtl/peripheral/soc.sv
yosys read_systemverilog -link

yosys synth_xilinx -flatten -nobram -iopad -nolutram -uram -abc9 -arch xc7
yosys write_json ./build/out.json
