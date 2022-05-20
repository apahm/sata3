set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]
set_property PACKAGE_PIN C26 [get_ports sys_rst_n]
set_property PULLUP true [get_ports sys_rst_n]

set_property PACKAGE_PIN H6 [get_ports pcie_refclkin_p]
set_property PACKAGE_PIN H5 [get_ports pcie_refclkin_n]

set_property PACKAGE_PIN B6 [get_ports {pci_exp_rxp[0]}]
set_property PACKAGE_PIN C4 [get_ports {pci_exp_rxp[1]}]
set_property PACKAGE_PIN E4 [get_ports {pci_exp_rxp[2]}]
set_property PACKAGE_PIN G4 [get_ports {pci_exp_rxp[3]}]

create_clock -period 10.000 -name pcie_ref_clk [get_ports pcie_refclkin_p]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]




