set proj_name "De2_115_Grande_Risco5"
set proj_dir [pwd]

# Cria um novo projeto
project_new -overwrite $proj_name -revision $proj_name

# Configurações do projeto
set_global_assignment -name FAMILY "Cyclone IV"
set_global_assignment -name DEVICE EP4CE115F29C7
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY build

# Adiciona arquivos Verilog ao projeto
set_global_assignment -name SYSTEMVERILOG_FILE $proj_dir/main.sv

set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/grande_risco5_types.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/alu_control.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/alu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/bmu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/branch_prediction.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/cache_request_multiplexer.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/core.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/csr_unit.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/d_cache.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/forwarding_unit.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/fpu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/Grande_Risco5.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/i_cache.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/immediate_generator.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/ir_decomp.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/mdu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/mux.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/registers.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/IFID.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/IDEX.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/EXMEM.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/core/MEMWB.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/peripheral/leds.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/peripheral/memory.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../rtl/peripheral/soc.sv
# Atribuições de pinos
set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_V16 -to led[0]
set_location_assignment PIN_W16 -to led[1]
set_location_assignment PIN_V17 -to led[2]
set_location_assignment PIN_V18 -to led[3]
set_location_assignment PIN_W17 -to led[4]
set_location_assignment PIN_W19 -to led[5]
set_location_assignment PIN_Y19 -to led[6]
set_location_assignment PIN_W20 -to led[7]
set_location_assignment PIN_W21 -to led[8]
set_location_assignment PIN_Y21 -to led[9]

set_location_assignment PIN_AB12 -to sw[0]
set_location_assignment PIN_AC12 -to sw[1]
set_location_assignment PIN_AF9  -to sw[2]
set_location_assignment PIN_AF10 -to sw[3]
set_location_assignment PIN_AD11 -to sw[4]
set_location_assignment PIN_AD12 -to sw[5]
set_location_assignment PIN_AE11 -to sw[6]
set_location_assignment PIN_AC9  -to sw[7]
set_location_assignment PIN_AD10 -to sw[8]
set_location_assignment PIN_AE12 -to sw[9]

set_location_assignment PIN_AA14 -to btn[0]
set_location_assignment PIN_AA15 -to btn[1]
set_location_assignment PIN_W15  -to btn[2]
set_location_assignment PIN_Y16  -to btn[3]

set_location_assignment PIN_B25 -to uart_tx
set_location_assignment PIN_C25 -to uart_rx

set_global_assignment -name SDC_FILE pinout.sdc