# Cria um projeto vazio (requer especificar parte)
create_project -force ip_project ./ip_project -part xc7a100tcsg324-1

# Cria o IP "clk_wiz_0" do tipo "clk_wiz" na pasta "ip/"
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_0 -dir ./ip

# Configurações básicas do IP (exemplo: entrada de 100 MHz, saída de 50 MHz)
set_property -dict [list \
    CONFIG.PRIM_IN_FREQ {100.0} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} \
    CONFIG.USE_PHASE_ALIGNMENT {true} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.USE_RESET {true} \
] [get_ips clk_wiz_0]

# Gera os arquivos HDL do IP
generate_target all [get_ips clk_wiz_0]
