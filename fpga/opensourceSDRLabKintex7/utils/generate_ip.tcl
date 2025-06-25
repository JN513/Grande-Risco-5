# Cria o projeto IP
create_project -force ip_project ./ip_project -part xc7k325tffg676-2

# ========================
# CLK_WIZ IP Configuration
# ========================

# Cria o IP "clk_wiz_0"
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_0 -dir ./ip

# Aplica configurações do clock wizard
set_property -dict [list \
    CONFIG.PRIM_IN_FREQ {50.0} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
    CONFIG.USE_PHASE_ALIGNMENT {true} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.USE_RESET {true} \
] [get_ips clk_wiz_0]

# Gera o IP CLK_WIZ
generate_target all [get_ips clk_wiz_0]
