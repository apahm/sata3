create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name general_fifo

set_property -dict [list \
	CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
	CONFIG.Input_Data_Width {32} \
	CONFIG.Input_Depth {2048} \
	CONFIG.Output_Data_Width {32} \
	CONFIG.Output_Depth {2048} \
	CONFIG.Reset_Type {Asynchronous_Reset} \
	CONFIG.Full_Flags_Reset_Value {1} \
	CONFIG.Almost_Full_Flag {true} \
	CONFIG.Almost_Empty_Flag {true} \
	CONFIG.Data_Count_Width {11} \
	CONFIG.Write_Data_Count {true} \
	CONFIG.Write_Data_Count_Width {11} \
	CONFIG.Read_Data_Count {true} \
	CONFIG.Read_Data_Count_Width {11} \
	CONFIG.Programmable_Full_Type {Single_Programmable_Full_Threshold_Constant} \
	CONFIG.Full_Threshold_Assert_Value {1900} \
	CONFIG.Full_Threshold_Negate_Value {1899} \
	CONFIG.Enable_Safety_Circuit {true} \
] [get_ips general_fifo]