# Sys clk pin
create_clock -period 20.000 -name clk [get_ports sys_clk]

set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property PACKAGE_PIN G22 [get_ports sys_clk]

# Rst_n pin
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN D26 [get_ports rst_n]

# Leds
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN A23 [get_ports {led[0]}]
set_property PACKAGE_PIN A24 [get_ports {led[1]}]
set_property PACKAGE_PIN D23 [get_ports {led[2]}]
set_property PACKAGE_PIN C24 [get_ports {led[3]}]
set_property PACKAGE_PIN C26 [get_ports {led[4]}]
set_property PACKAGE_PIN D24 [get_ports {led[5]}]
set_property PACKAGE_PIN D25 [get_ports {led[6]}]
set_property PACKAGE_PIN E25 [get_ports {led[7]}]

# BTNs
#set_property IOSTANDARD LVCMOS33 [get_ports {btn[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {btn[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {btn[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {btn[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {btn[0]}]
#set_property PACKAGE_PIN D26 [get_ports {btn[0]}]
#set_property PACKAGE_PIN J26 [get_ports {btn[1]}]
#set_property PACKAGE_PIN E26 [get_ports {btn[2]}]
#set_property PACKAGE_PIN G26 [get_ports {btn[3]}]
#set_property PACKAGE_PIN H26 [get_ports {btn[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {btn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[0]}]
set_property PACKAGE_PIN J26 [get_ports {btn[0]}]
set_property PACKAGE_PIN E26 [get_ports {btn[1]}]
set_property PACKAGE_PIN G26 [get_ports {btn[2]}]
set_property PACKAGE_PIN H26 [get_ports {btn[3]}]

# UART Pins
set_property IOSTANDARD LVCMOS33 [get_ports rxd]
set_property IOSTANDARD LVCMOS33 [get_ports txd]
set_property PACKAGE_PIN B20 [get_ports rxd]
set_property PACKAGE_PIN C22 [get_ports txd]

# EEPROM Pins
#set_property IOSTANDARD LVCMOS33 [get_ports EEPROM_SCL]
#set_property IOSTANDARD LVCMOS33 [get_ports EEPROM_SDA]
#set_property PACKAGE_PIN B21 [get_ports EEPROM_SCL]
#set_property PACKAGE_PIN C21 [get_ports EEPROM_SDA]

# HDMI 1

#set_output_delay -clock clk 0.10  [get_ports TMDS_CLK_P1]
#set_output_delay -clock clk 0.10 [get_ports TMDS_CLK_N1]

#set_property IOSTANDARD LVCMOS33 [get_ports HDMI_OUT_EN1]
#set_property PACKAGE_PIN E22 [get_ports HDMI_OUT_EN1]

#set_property PACKAGE_PIN F17 [get_ports TMDS_CLK_P1]
#set_property PACKAGE_PIN J15 [get_ports {TMDS_DATA_P1[0]}]
#set_property PACKAGE_PIN E15 [get_ports {TMDS_DATA_P1[1]}]
#set_property PACKAGE_PIN G17 [get_ports {TMDS_DATA_P1[2]}]

#set_property PACKAGE_PIN E17 [get_ports TMDS_CLK_N1]
#set_property PACKAGE_PIN J16 [get_ports {TMDS_DATA_N1[0]}]
#set_property PACKAGE_PIN E16 [get_ports {TMDS_DATA_N1[1]}]
#set_property PACKAGE_PIN F18 [get_ports {TMDS_DATA_N1[2]}]

# HDMI 2

#set_output_delay -clock clk 0.10  [get_ports TMDS_CLK_P2]
#set_output_delay -clock clk 0.10 [get_ports TMDS_CLK_N2]

#set_property PACKAGE_PIN E18 [get_ports TMDS_CLK_P2]
#set_property PACKAGE_PIN D19 [get_ports {TMDS_DATA_P2[0]}]
#set_property PACKAGE_PIN H17 [get_ports {TMDS_DATA_P2[1]}]
#set_property PACKAGE_PIN G19 [get_ports {TMDS_DATA_P2[2]}]

#set_property PACKAGE_PIN D18 [get_ports TMDS_CLK_N2]
#set_property PACKAGE_PIN D20 [get_ports {TMDS_DATA_N2[0]}]
#set_property PACKAGE_PIN H18 [get_ports {TMDS_DATA_N2[1]}]
#set_property PACKAGE_PIN F20 [get_ports {TMDS_DATA_N2[2]}]

## ETHERNET 1

#create_clock -period 5.000 -name clk_200m [get_ports clk_200m]
#create_clock -period 8.000 -name phy_rxc [get_ports phy_rxc]
#
#set_property IOSTANDARD LVCMOS18 [get_ports mdc]
#set_property IOSTANDARD LVCMOS18 [get_ports mdio]
#set_property IOSTANDARD LVCMOS18 [get_ports phy_rx_ctrl]
#set_property IOSTANDARD LVCMOS18 [get_ports phy_rstn]
#set_property IOSTANDARD LVCMOS18 [get_ports phy_tx_ctrl]
#set_property IOSTANDARD LVCMOS18 [get_ports phy_rxc]
#set_property IOSTANDARD LVCMOS18 [get_ports phy_txc]
#set_property IOSTANDARD LVCMOS33 [get_ports {linkspeed[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {linkspeed[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[0]}]
#
#set_property PACKAGE_PIN W1  [get_ports mdc]
#set_property PACKAGE_PIN AF5 [get_ports mdio]
#set_property PACKAGE_PIN Y2  [get_ports phy_rstn]
#set_property PACKAGE_PIN AF4 [get_ports phy_rx_ctrl]
#set_property PACKAGE_PIN Y1  [get_ports phy_tx_ctrl]
#set_property PACKAGE_PIN AB2 [get_ports phy_rxc]
#set_property PACKAGE_PIN AC2 [get_ports phy_txc]
#set_property PACKAGE_PIN A23 [get_ports {linkspeed[0]}]
#set_property PACKAGE_PIN A24 [get_ports {linkspeed[1]}]
#set_property PACKAGE_PIN AC1 [get_ports {phy_txd[0]}]
#set_property PACKAGE_PIN AB1 [get_ports {phy_txd[1]}]
#set_property PACKAGE_PIN AB4 [get_ports {phy_txd[2]}]
#set_property PACKAGE_PIN Y3  [get_ports {phy_txd[3]}]
#set_property PACKAGE_PIN AF3 [get_ports {phy_rxd[0]}]
#set_property PACKAGE_PIN AC3 [get_ports {phy_rxd[1]}]
#set_property PACKAGE_PIN AE2 [get_ports {phy_rxd[2]}]
#set_property PACKAGE_PIN AE1 [get_ports {phy_rxd[3]}]

# ETHERNET 2

#create_clock -period 5.000 -name clk_200m [get_ports clk_200m]
#create_clock -period 8.000 -name phy_rxc [get_ports phy_rxc]
#
#set_property IOSTANDARD LVCMOS18 [get_ports mdc]
#set_property IOSTANDARD LVCMOS18 [get_ports mdio]
#set_property IOSTANDARD LVCMOS18 [get_ports phy_rstn]
#set_property IOSTANDARD LVCMOS18 [get_ports phy_rx_ctrl]
#set_property IOSTANDARD LVCMOS18 [get_ports phy_tx_ctrl]
#set_property IOSTANDARD LVCMOS18 [get_ports phy_rxc]
#set_property IOSTANDARD LVCMOS18 [get_ports phy_txc]
#set_property IOSTANDARD LVCMOS33 [get_ports {linkspeed[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {linkspeed[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[0]}]
#
#set_property PACKAGE_PIN Y6  [get_ports phy_tx_ctrl]
#set_property PACKAGE_PIN AD6 [get_ports phy_rx_ctrl]
#set_property PACKAGE_PIN W6  [get_ports phy_rstn]
#set_property PACKAGE_PIN V4  [get_ports mdio]
#set_property PACKAGE_PIN V6  [get_ports mdc]
#set_property PACKAGE_PIN AA2 [get_ports phy_txc]
#set_property PACKAGE_PIN AA3 [get_ports phy_rxc]
#set_property PACKAGE_PIN A23 [get_ports {linkspeed[0]}]
#set_property PACKAGE_PIN A24 [get_ports {linkspeed[1]}]
#set_property PACKAGE_PIN AB6 [get_ports {phy_txd[0]}]
#set_property PACKAGE_PIN AB5 [get_ports {phy_txd[1]}]
#set_property PACKAGE_PIN AA5 [get_ports {phy_txd[2]}]
#set_property PACKAGE_PIN Y5  [get_ports {phy_txd[3]}]
#set_property PACKAGE_PIN AD5 [get_ports {phy_rxd[0]}]
#set_property PACKAGE_PIN AC6 [get_ports {phy_rxd[1]}]
#set_property PACKAGE_PIN AD4 [get_ports {phy_rxd[2]}]
#set_property PACKAGE_PIN AC4 [get_ports {phy_rxd[3]}]

# PCI-E

#set_property IOSTANDARD LVCMOS33 [get_ports init_calib_complete_0]
#set_property IOSTANDARD LVCMOS33 [get_ports user_lnk_up_0]
#set_property IOSTANDARD LVCMOS33 [get_ports reset_rtl_0]
#set_property PACKAGE_PIN A23 [get_ports init_calib_complete_0]
#set_property PACKAGE_PIN A24 [get_ports user_lnk_up_0]
#set_property PACKAGE_PIN A12 [get_ports reset_rtl_0]
#set_property PACKAGE_PIN K6  [get_ports {PCIE_REF_CLK_clk_p[0]}]
#set_property PACKAGE_PIN K5  [get_ports {PCIE_REF_CLK_clk_n[0]}]
#set_property PACKAGE_PIN J4  [get_ports {pcie_7x_mgt_rtl_0_rxp[0]}]
#set_property PACKAGE_PIN L4  [get_ports {pcie_7x_mgt_rtl_0_rxp[1]}]
#set_property PACKAGE_PIN N4  [get_ports {pcie_7x_mgt_rtl_0_rxp[2]}]
#set_property PACKAGE_PIN R4  [get_ports {pcie_7x_mgt_rtl_0_rxp[3]}]
#set_property PACKAGE_PIN J3  [get_ports {pcie_7x_mgt_rtl_0_rxn[0]}]
#set_property PACKAGE_PIN L3  [get_ports {pcie_7x_mgt_rtl_0_rxn[1]}]
#set_property PACKAGE_PIN N3  [get_ports {pcie_7x_mgt_rtl_0_rxn[2]}]
#set_property PACKAGE_PIN R3  [get_ports {pcie_7x_mgt_rtl_0_rxn[3]}]

#set_property PACKAGE_PIN H2  [get_ports {pcie_7x_mgt_rtl_0_txp[0]}]
#set_property PACKAGE_PIN K2  [get_ports {pcie_7x_mgt_rtl_0_txp[1]}]
#set_property PACKAGE_PIN M2  [get_ports {pcie_7x_mgt_rtl_0_txp[2]}]
#set_property PACKAGE_PIN P2  [get_ports {pcie_7x_mgt_rtl_0_txp[3]}]
#set_property PACKAGE_PIN H1  [get_ports {pcie_7x_mgt_rtl_0_txn[0]}]
#set_property PACKAGE_PIN K1  [get_ports {pcie_7x_mgt_rtl_0_txn[1]}]
#set_property PACKAGE_PIN M1  [get_ports {pcie_7x_mgt_rtl_0_txn[2]}]
#set_property PACKAGE_PIN P1  [get_ports {pcie_7x_mgt_rtl_0_txn[3]}]

# FLASH

#set_property IOSTANDARD LVCMOS33 [get_ports {flash_d[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {flash_d[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {flash_d[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {flash_d[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports flash_clk]
#set_property IOSTANDARD LVCMOS33 [get_ports flash_ce]

#set_property PACKAGE_PIN B24 [get_ports {flash_d[0]}]
#set_property PACKAGE_PIN A25 [get_ports {flash_d[1]}]
#set_property PACKAGE_PIN B22 [get_ports {flash_d[2]}]
#set_property PACKAGE_PIN A22 [get_ports {flash_d[3]}]
#set_property PACKAGE_PIN C8  [get_ports flash_clk]
#set_property PACKAGE_PIN C23 [get_ports flash_ce]

# sdcard

#set_property IOSTANDARD LVCMOS33 [get_ports sd_clk]
#set_property IOSTANDARD LVCMOS33 [get_ports sd_cs]
#set_property IOSTANDARD LVCMOS33 [get_ports sd_miso]
#set_property IOSTANDARD LVCMOS33 [get_ports sd_mosi]

#set_property PACKAGE_PIN G24 [get_ports sd_clk]
#set_property PACKAGE_PIN F24 [get_ports sd_cs]
#set_property PACKAGE_PIN F23 [get_ports sd_miso]
#set_property PACKAGE_PIN G25 [get_ports sd_mosi]

# GPIOs - 34 gpios pins are available on the board

set_property IOSTANDARD LVCMOS33 [get_ports {gpio[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[32]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[33]}]

set_property PACKAGE_PIN H14 [get_ports {gpio[0]}]
set_property PACKAGE_PIN H12 [get_ports {gpio[1]}]
set_property PACKAGE_PIN H11 [get_ports {gpio[2]}]
set_property PACKAGE_PIN F14 [get_ports {gpio[3]}]
set_property PACKAGE_PIN G14 [get_ports {gpio[4]}]
set_property PACKAGE_PIN F13 [get_ports {gpio[5]}]
set_property PACKAGE_PIN G12 [get_ports {gpio[6]}]
set_property PACKAGE_PIN F12 [get_ports {gpio[7]}]
set_property PACKAGE_PIN G11 [get_ports {gpio[8]}]
set_property PACKAGE_PIN F10 [get_ports {gpio[9]}]
set_property PACKAGE_PIN F8  [get_ports {gpio[10]}]
set_property PACKAGE_PIN A8  [get_ports {gpio[11]}]
set_property PACKAGE_PIN F9  [get_ports {gpio[12]}]
set_property PACKAGE_PIN B9  [get_ports {gpio[13]}]
set_property PACKAGE_PIN D8  [get_ports {gpio[14]}]
set_property PACKAGE_PIN A9  [get_ports {gpio[15]}]
set_property PACKAGE_PIN E13 [get_ports {gpio[16]}]
set_property PACKAGE_PIN C9  [get_ports {gpio[17]}]
set_property PACKAGE_PIN E10 [get_ports {gpio[18]}]
set_property PACKAGE_PIN B11 [get_ports {gpio[19]}]
set_property PACKAGE_PIN E11 [get_ports {gpio[20]}]
set_property PACKAGE_PIN C11 [get_ports {gpio[21]}]
set_property PACKAGE_PIN D10 [get_ports {gpio[22]}]
set_property PACKAGE_PIN C13 [get_ports {gpio[23]}]
set_property PACKAGE_PIN D9  [get_ports {gpio[24]}]
set_property PACKAGE_PIN A14 [get_ports {gpio[25]}]
set_property PACKAGE_PIN D11 [get_ports {gpio[26]}]
set_property PACKAGE_PIN D14 [get_ports {gpio[27]}]
set_property PACKAGE_PIN E12 [get_ports {gpio[28]}]
set_property PACKAGE_PIN B12 [get_ports {gpio[29]}]
set_property PACKAGE_PIN C12 [get_ports {gpio[30]}]
set_property PACKAGE_PIN C14 [get_ports {gpio[31]}]
set_property PACKAGE_PIN D13 [get_ports {gpio[32]}]
set_property PACKAGE_PIN B14 [get_ports {gpio[33]}]

# Oled display

#set_property IOSTANDARD LVCMOS33 [get_ports {OLED_DC}]
#set_property IOSTANDARD LVCMOS33 [get_ports {OLED_RST}]
#set_property IOSTANDARD LVCMOS33 [get_ports {OLED_SCL}]
#set_property IOSTANDARD LVCMOS33 [get_ports {OLED_SDA}]
#set_property PACKAGE_PIN J21 [get_ports {OLED_RST}]
#set_property PACKAGE_PIN H22 [get_ports {OLED_DC}]
#set_property PACKAGE_PIN J24 [get_ports {OLED_SCL}]
#set_property PACKAGE_PIN J25 [get_ports {OLED_SDA}]

# SFP

####################### GT reference clock constraints #########################

#create_clock -period 8.000 [get_ports Q0_CLK1_GTREFCLK_PAD_P_IN]
#
#set_false_path -to [get_pins -filter REF_PIN_NAME=~*CLR -of_objects [get_cells -hierarchical -filter {NAME =~ *_txfsmresetdone_r*}]]
#set_false_path -to [get_pins -filter REF_PIN_NAME=~*D -of_objects [get_cells -hierarchical -filter {NAME =~ *_txfsmresetdone_r*}]]
#set_false_path -to [get_pins -filter REF_PIN_NAME=~*D -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_on_error_in_r*}]]
################################## RefClk Location constraints #####################
#
#set_property PACKAGE_PIN D6 [get_ports Q0_CLK1_GTREFCLK_PAD_P_IN]
#set_property PACKAGE_PIN D5 [get_ports Q0_CLK1_GTREFCLK_PAD_N_IN]
#
### LOC constrain for DRP_CLK_P/N
### set_property LOC C25 [get_ports  DRP_CLK_IN_P]
### set_property LOC B25 [get_ports  DRP_CLK_IN_N]
#
################################## mgt wrapper constraints #####################
#
###---------- Set placement for gt0_gtx_wrapper_i/GTXE2_CHANNEL ------
###---------- Set placement for gt1_gtx_wrapper_i/GTXE2_CHANNEL ------
#
###---------- Set ASYNC_REG for flop which have async input ----------
###set_property ASYNC_REG TRUE [get_cells -hier -filter {name=~*gt0_frame_gen*system_reset_r_reg}]
###set_property ASYNC_REG TRUE [get_cells -hier -filter {name=~*gt0_frame_check*system_reset_r_reg}]
###set_property ASYNC_REG TRUE [get_cells -hier -filter {name=~*gt1_frame_gen*system_reset_r_reg}]
###set_property ASYNC_REG TRUE [get_cells -hier -filter {name=~*gt1_frame_check*system_reset_r_reg}]
#
###---------- Set False Path from one clock to other ----------
#
#set_property IOSTANDARD LVCMOS33 [get_ports {tx_dis[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {tx_dis[0]}]
#set_property LOC GTXE2_CHANNEL_X0Y6 [get_cells gtwizard_0_support_i/gtwizard_0_init_i/inst/gtwizard_0_i/gt1_gtwizard_0_i/gtxe2_i]
#set_property PACKAGE_PIN C4 [get_ports {RXP_IN[1]}]
#set_property PACKAGE_PIN C3 [get_ports {RXN_IN[1]}]
#set_property LOC GTXE2_CHANNEL_X0Y5 [get_cells gtwizard_0_support_i/gtwizard_0_init_i/inst/gtwizard_0_i/gt0_gtwizard_0_i/gtxe2_i]
#set_property PACKAGE_PIN E4 [get_ports {RXP_IN[0]}]
#set_property PACKAGE_PIN E3 [get_ports {RXP_IN[0]}]

#set_property PACKAGE_PIN B2 [get_ports {TXP_IN[1]}]
#set_property PACKAGE_PIN B1 [get_ports {TXN_IN[1]}]
#set_property PACKAGE_PIN D2 [get_ports {TXP_IN[0]}]
#set_property PACKAGE_PIN D1 [get_ports {TXN_IN[0]}]

#set_property PACKAGE_PIN H23 [get_ports {tx_dis[0]}]
#set_property PACKAGE_PIN H24 [get_ports {tx_dis[1]}]


# Device config

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
