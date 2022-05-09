create_project -force -part xc7k325t-ffg900-2 fpga
add_files -fileset sources_1 defines.v  ../rtl/fpga.v 
add_files -fileset constrs_1  ../fpga.xdc 
source ../ip/gt_wizard.tcl
