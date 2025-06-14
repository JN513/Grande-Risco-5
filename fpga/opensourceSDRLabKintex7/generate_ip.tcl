# Cria o projeto IP
create_project -force ip_project ./ip_project -part xc7k325tffg676-2

# ========================
# MIG IP Configuration
# ========================

# Define caminho do arquivo .prj dinamicamente
set mig_prj_file [file join [pwd] "utils/mig_a.prj"]

# Cria o IP "mig_7series_0"
create_ip -name mig_7series -vendor xilinx.com -library ip -version 4.2 -module_name mig_7series_0 -dir ./ip

# Aplica configurações do MIG
set_property -dict [list \
  CONFIG.ARESETN.INSERT_VIP {0} \
  CONFIG.BOARD_MIG_PARAM {Custom} \
  CONFIG.C0_ARESETN.INSERT_VIP {0} \
  CONFIG.C0_CLOCK.INSERT_VIP {0} \
  CONFIG.C0_DDR2_RESET.INSERT_VIP {0} \
  CONFIG.C0_DDR3_RESET.INSERT_VIP {0} \
  CONFIG.C0_LPDDR2_RESET.INSERT_VIP {0} \
  CONFIG.C0_MMCM_CLKOUT0.INSERT_VIP {0} \
  CONFIG.C0_MMCM_CLKOUT1.INSERT_VIP {0} \
  CONFIG.C0_MMCM_CLKOUT2.INSERT_VIP {0} \
  CONFIG.C0_MMCM_CLKOUT3.INSERT_VIP {0} \
  CONFIG.C0_MMCM_CLKOUT4.INSERT_VIP {0} \
  CONFIG.C0_QDRIIP_RESET.INSERT_VIP {0} \
  CONFIG.C0_RESET.INSERT_VIP {0} \
  CONFIG.C0_RLDIII_RESET.INSERT_VIP {0} \
  CONFIG.C0_RLDII_RESET.INSERT_VIP {0} \
  CONFIG.C0_SYS_CLK_I.INSERT_VIP {0} \
  CONFIG.C1_ARESETN.INSERT_VIP {0} \
  CONFIG.C1_CLOCK.INSERT_VIP {0} \
  CONFIG.C1_DDR2_RESET.INSERT_VIP {0} \
  CONFIG.C1_DDR3_RESET.INSERT_VIP {0} \
  CONFIG.C1_LPDDR2_RESET.INSERT_VIP {0} \
  CONFIG.C1_MMCM_CLKOUT0.INSERT_VIP {0} \
  CONFIG.C1_MMCM_CLKOUT1.INSERT_VIP {0} \
  CONFIG.C1_MMCM_CLKOUT2.INSERT_VIP {0} \
  CONFIG.C1_MMCM_CLKOUT3.INSERT_VIP {0} \
  CONFIG.C1_MMCM_CLKOUT4.INSERT_VIP {0} \
  CONFIG.C1_QDRIIP_RESET.INSERT_VIP {0} \
  CONFIG.C1_RESET.INSERT_VIP {0} \
  CONFIG.C1_RLDIII_RESET.INSERT_VIP {0} \
  CONFIG.C1_RLDII_RESET.INSERT_VIP {0} \
  CONFIG.C1_SYS_CLK_I.INSERT_VIP {0} \
  CONFIG.C2_ARESETN.INSERT_VIP {0} \
  CONFIG.C2_CLOCK.INSERT_VIP {0} \
  CONFIG.C2_DDR2_RESET.INSERT_VIP {0} \
  CONFIG.C2_DDR3_RESET.INSERT_VIP {0} \
  CONFIG.C2_LPDDR2_RESET.INSERT_VIP {0} \
  CONFIG.C2_MMCM_CLKOUT0.INSERT_VIP {0} \
  CONFIG.C2_MMCM_CLKOUT1.INSERT_VIP {0} \
  CONFIG.C2_MMCM_CLKOUT2.INSERT_VIP {0} \
  CONFIG.C2_MMCM_CLKOUT3.INSERT_VIP {0} \
  CONFIG.C2_MMCM_CLKOUT4.INSERT_VIP {0} \
  CONFIG.C2_QDRIIP_RESET.INSERT_VIP {0} \
  CONFIG.C2_RESET.INSERT_VIP {0} \
  CONFIG.C2_RLDIII_RESET.INSERT_VIP {0} \
  CONFIG.C2_RLDII_RESET.INSERT_VIP {0} \
  CONFIG.C2_SYS_CLK_I.INSERT_VIP {0} \
  CONFIG.C3_ARESETN.INSERT_VIP {0} \
  CONFIG.C3_CLOCK.INSERT_VIP {0} \
  CONFIG.C3_DDR2_RESET.INSERT_VIP {0} \
  CONFIG.C3_DDR3_RESET.INSERT_VIP {0} \
  CONFIG.C3_LPDDR2_RESET.INSERT_VIP {0} \
  CONFIG.C3_MMCM_CLKOUT0.INSERT_VIP {0} \
  CONFIG.C3_MMCM_CLKOUT1.INSERT_VIP {0} \
  CONFIG.C3_MMCM_CLKOUT2.INSERT_VIP {0} \
  CONFIG.C3_MMCM_CLKOUT3.INSERT_VIP {0} \
  CONFIG.C3_MMCM_CLKOUT4.INSERT_VIP {0} \
  CONFIG.C3_QDRIIP_RESET.INSERT_VIP {0} \
  CONFIG.C3_RESET.INSERT_VIP {0} \
  CONFIG.C3_RLDIII_RESET.INSERT_VIP {0} \
  CONFIG.C3_RLDII_RESET.INSERT_VIP {0} \
  CONFIG.C3_SYS_CLK_I.INSERT_VIP {0} \
  CONFIG.C4_ARESETN.INSERT_VIP {0} \
  CONFIG.C4_CLOCK.INSERT_VIP {0} \
  CONFIG.C4_DDR2_RESET.INSERT_VIP {0} \
  CONFIG.C4_DDR3_RESET.INSERT_VIP {0} \
  CONFIG.C4_LPDDR2_RESET.INSERT_VIP {0} \
  CONFIG.C4_MMCM_CLKOUT0.INSERT_VIP {0} \
  CONFIG.C4_MMCM_CLKOUT1.INSERT_VIP {0} \
  CONFIG.C4_MMCM_CLKOUT2.INSERT_VIP {0} \
  CONFIG.C4_MMCM_CLKOUT3.INSERT_VIP {0} \
  CONFIG.C4_MMCM_CLKOUT4.INSERT_VIP {0} \
  CONFIG.C4_QDRIIP_RESET.INSERT_VIP {0} \
  CONFIG.C4_RESET.INSERT_VIP {0} \
  CONFIG.C4_RLDIII_RESET.INSERT_VIP {0} \
  CONFIG.C4_RLDII_RESET.INSERT_VIP {0} \
  CONFIG.C4_SYS_CLK_I.INSERT_VIP {0} \
  CONFIG.C5_ARESETN.INSERT_VIP {0} \
  CONFIG.C5_CLOCK.INSERT_VIP {0} \
  CONFIG.C5_DDR2_RESET.INSERT_VIP {0} \
  CONFIG.C5_DDR3_RESET.INSERT_VIP {0} \
  CONFIG.C5_LPDDR2_RESET.INSERT_VIP {0} \
  CONFIG.C5_MMCM_CLKOUT0.INSERT_VIP {0} \
  CONFIG.C5_MMCM_CLKOUT1.INSERT_VIP {0} \
  CONFIG.C5_MMCM_CLKOUT2.INSERT_VIP {0} \
  CONFIG.C5_MMCM_CLKOUT3.INSERT_VIP {0} \
  CONFIG.C5_MMCM_CLKOUT4.INSERT_VIP {0} \
  CONFIG.C5_QDRIIP_RESET.INSERT_VIP {0} \
  CONFIG.C5_RESET.INSERT_VIP {0} \
  CONFIG.C5_RLDIII_RESET.INSERT_VIP {0} \
  CONFIG.C5_RLDII_RESET.INSERT_VIP {0} \
  CONFIG.C5_SYS_CLK_I.INSERT_VIP {0} \
  CONFIG.C6_ARESETN.INSERT_VIP {0} \
  CONFIG.C6_CLOCK.INSERT_VIP {0} \
  CONFIG.C6_DDR2_RESET.INSERT_VIP {0} \
  CONFIG.C6_DDR3_RESET.INSERT_VIP {0} \
  CONFIG.C6_LPDDR2_RESET.INSERT_VIP {0} \
  CONFIG.C6_MMCM_CLKOUT0.INSERT_VIP {0} \
  CONFIG.C6_MMCM_CLKOUT1.INSERT_VIP {0} \
  CONFIG.C6_MMCM_CLKOUT2.INSERT_VIP {0} \
  CONFIG.C6_MMCM_CLKOUT3.INSERT_VIP {0} \
  CONFIG.C6_MMCM_CLKOUT4.INSERT_VIP {0} \
  CONFIG.C6_QDRIIP_RESET.INSERT_VIP {0} \
  CONFIG.C6_RESET.INSERT_VIP {0} \
  CONFIG.C6_RLDIII_RESET.INSERT_VIP {0} \
  CONFIG.C6_RLDII_RESET.INSERT_VIP {0} \
  CONFIG.C6_SYS_CLK_I.INSERT_VIP {0} \
  CONFIG.C7_ARESETN.INSERT_VIP {0} \
  CONFIG.C7_CLOCK.INSERT_VIP {0} \
  CONFIG.C7_DDR2_RESET.INSERT_VIP {0} \
  CONFIG.C7_DDR3_RESET.INSERT_VIP {0} \
  CONFIG.C7_LPDDR2_RESET.INSERT_VIP {0} \
  CONFIG.C7_MMCM_CLKOUT0.INSERT_VIP {0} \
  CONFIG.C7_MMCM_CLKOUT1.INSERT_VIP {0} \
  CONFIG.C7_MMCM_CLKOUT2.INSERT_VIP {0} \
  CONFIG.C7_MMCM_CLKOUT3.INSERT_VIP {0} \
  CONFIG.C7_MMCM_CLKOUT4.INSERT_VIP {0} \
  CONFIG.C7_QDRIIP_RESET.INSERT_VIP {0} \
  CONFIG.C7_RESET.INSERT_VIP {0} \
  CONFIG.C7_RLDIII_RESET.INSERT_VIP {0} \
  CONFIG.C7_RLDII_RESET.INSERT_VIP {0} \
  CONFIG.C7_SYS_CLK_I.INSERT_VIP {0} \
  CONFIG.CLK_REF_I.INSERT_VIP {0} \
  CONFIG.CLOCK.INSERT_VIP {0} \
  CONFIG.DDR2_RESET.INSERT_VIP {0} \
  CONFIG.DDR3_RESET.INSERT_VIP {0} \
  CONFIG.LPDDR2_RESET.INSERT_VIP {0} \
  CONFIG.MIG_DONT_TOUCH_PARAM {Custom} \
  CONFIG.MMCM_CLKOUT0.INSERT_VIP {0} \
  CONFIG.MMCM_CLKOUT1.INSERT_VIP {0} \
  CONFIG.MMCM_CLKOUT2.INSERT_VIP {0} \
  CONFIG.MMCM_CLKOUT3.INSERT_VIP {0} \
  CONFIG.MMCM_CLKOUT4.INSERT_VIP {0} \
  CONFIG.QDRIIP_RESET.INSERT_VIP {0} \
  CONFIG.RESET.INSERT_VIP {0} \
  CONFIG.RESET_BOARD_INTERFACE {Custom} \
  CONFIG.RLDIII_RESET.INSERT_VIP {0} \
  CONFIG.RLDII_RESET.INSERT_VIP {0} \
  CONFIG.S0_AXI.INSERT_VIP {0} \
  CONFIG.S0_AXI_CTRL.INSERT_VIP {0} \
  CONFIG.S1_AXI.INSERT_VIP {0} \
  CONFIG.S1_AXI_CTRL.INSERT_VIP {0} \
  CONFIG.S2_AXI.INSERT_VIP {0} \
  CONFIG.S2_AXI_CTRL.INSERT_VIP {0} \
  CONFIG.S3_AXI.INSERT_VIP {0} \
  CONFIG.S3_AXI_CTRL.INSERT_VIP {0} \
  CONFIG.S4_AXI.INSERT_VIP {0} \
  CONFIG.S4_AXI_CTRL.INSERT_VIP {0} \
  CONFIG.S5_AXI.INSERT_VIP {0} \
  CONFIG.S5_AXI_CTRL.INSERT_VIP {0} \
  CONFIG.S6_AXI.INSERT_VIP {0} \
  CONFIG.S6_AXI_CTRL.INSERT_VIP {0} \
  CONFIG.S7_AXI.INSERT_VIP {0} \
  CONFIG.S7_AXI_CTRL.INSERT_VIP {0} \
  CONFIG.SYSTEM_RESET.INSERT_VIP {0} \
  CONFIG.SYS_CLK_I.INSERT_VIP {0} \
  CONFIG.S_AXI.INSERT_VIP {0} \
  CONFIG.S_AXI_CTRL.INSERT_VIP {0} \
  CONFIG.XML_INPUT_FILE $mig_prj_file \
] [get_ips mig_7series_0]

# Gera o IP MIG
generate_target all [get_ips mig_7series_0]

# ========================
# CLK_WIZ IP Configuration
# ========================

# Cria o IP "clk_wiz_0"
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_0 -dir ./ip

# Aplica configurações do clock wizard
set_property -dict [list \
    CONFIG.PRIM_IN_FREQ {50.0} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {800} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {100} \
    CONFIG.USE_PHASE_ALIGNMENT {true} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.USE_RESET {true} \
] [get_ips clk_wiz_0]

# Gera o IP CLK_WIZ
generate_target all [get_ips clk_wiz_0]
