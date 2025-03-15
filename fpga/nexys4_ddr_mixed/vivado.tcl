read_edif build/out.edf
read_xdc "pinout.xdc"

# Criar um design a partir do netlist importado
link_design -part xc7a100tcsg324-1

opt_design
place_design
route_design

# write bitstream
write_bitstream -force "./build/out.bit"

exit