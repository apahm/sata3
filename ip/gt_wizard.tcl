create_ip -name gtwizard -vendor xilinx.com -library ip -module_name gtwizard_0

set_property -dict [list \
	CONFIG.identical_protocol_file {sata3} \
	CONFIG.gt_val_tx_pll {QPLL} \
	CONFIG.gt_val_rx_pll {QPLL} \
	CONFIG.advanced_clocking {false} \
	CONFIG.gt0_val_tx_data_width {32} \
	CONFIG.gt0_val_tx_int_datawidth {40} \
	CONFIG.gt0_val_rx_data_width {32} \
	CONFIG.gt0_val_rx_int_datawidth {40} \
	CONFIG.gt0_val_drp_clock {150} \
	CONFIG.gt0_val_txbuf_en {true} \
	CONFIG.gt0_val_rxbuf_en {true} \
	CONFIG.gt0_val_rxusrclk {TXOUTCLK} \
	CONFIG.gt0_val_port_txpolarity {true} \
	CONFIG.gt0_val_port_rxpolarity {true} \
	CONFIG.gt0_val_port_rxstatus {true} \
	CONFIG.identical_val_tx_line_rate {6.0} \
	CONFIG.identical_val_no_tx {false} \
	CONFIG.identical_val_rx_line_rate {6.0} \
	CONFIG.identical_val_no_rx {false} \
	CONFIG.gt_val_drp {false} \
	CONFIG.gt_val_drp_clock {100} \
	CONFIG.gt0_val {true} \
	CONFIG.gt0_val_tx_refclk {REFCLK1_Q0} \
	CONFIG.gt0_val_rx_refclk {REFCLK1_Q0} \
	CONFIG.gt1_val {false} \
	CONFIG.gt1_val_tx_refclk {REFCLK1_Q0} \
	CONFIG.gt1_val_rx_refclk {REFCLK1_Q0} \
	CONFIG.gt2_val {false} \
	CONFIG.gt2_val_tx_refclk {REFCLK1_Q0} \
	CONFIG.gt2_val_rx_refclk {REFCLK1_Q0} \
	CONFIG.gt3_val {false} \
	CONFIG.gt3_val_tx_refclk {REFCLK1_Q0} \
	CONFIG.gt3_val_rx_refclk {REFCLK1_Q0} \
	CONFIG.gt4_val {false} \
	CONFIG.gt4_val_tx_refclk {REFCLK1_Q1} \
	CONFIG.gt4_val_rx_refclk {REFCLK1_Q1} \
	CONFIG.gt5_val {false} \
	CONFIG.gt5_val_tx_refclk {REFCLK1_Q1} \
	CONFIG.gt5_val_rx_refclk {REFCLK1_Q1} \
	CONFIG.gt6_val {false} \
	CONFIG.gt6_val_tx_refclk {REFCLK1_Q1} \
	CONFIG.gt6_val_rx_refclk {REFCLK1_Q1} \
	CONFIG.gt7_val {false} \
	CONFIG.gt7_val_tx_refclk {REFCLK1_Q1} \
	CONFIG.gt7_val_rx_refclk {REFCLK1_Q1} \
	CONFIG.gt8_val {false} \
	CONFIG.gt8_val_tx_refclk {REFCLK1_Q2} \
	CONFIG.gt8_val_rx_refclk {REFCLK1_Q2} \
	CONFIG.gt9_val {false} \
	CONFIG.gt9_val_tx_refclk {REFCLK1_Q2} \
	CONFIG.gt9_val_rx_refclk {REFCLK1_Q2} \
	CONFIG.gt10_val {false} \
	CONFIG.gt10_val_tx_refclk {REFCLK1_Q2} \
	CONFIG.gt10_val_rx_refclk {REFCLK1_Q2} \
	CONFIG.gt11_val {false} \
	CONFIG.gt11_val_tx_refclk {REFCLK1_Q2} \
	CONFIG.gt11_val_rx_refclk {REFCLK1_Q2} \
	CONFIG.gt12_val {false} \
	CONFIG.gt12_val_tx_refclk {REFCLK1_Q3} \
	CONFIG.gt12_val_rx_refclk {REFCLK1_Q3} \
	CONFIG.gt13_val {false} \
	CONFIG.gt13_val_tx_refclk {REFCLK1_Q3} \
	CONFIG.gt13_val_rx_refclk {REFCLK1_Q3} \
	CONFIG.gt14_val {false} \
	CONFIG.gt14_val_tx_refclk {REFCLK1_Q3} \
	CONFIG.gt14_val_rx_refclk {REFCLK1_Q3} \
	CONFIG.gt15_val {false} \
	CONFIG.gt15_val_tx_refclk {REFCLK1_Q3} \
	CONFIG.gt15_val_rx_refclk {REFCLK1_Q3} \
	CONFIG.identical_val_tx_reference_clock {150.000} \
	CONFIG.identical_val_rx_reference_clock {150.000} \
	CONFIG.gt0_val_protocol_file {sata3} \
	CONFIG.gt0_val_no_tx {false} \
	CONFIG.gt0_val_no_rx {false} \
	CONFIG.gt0_val_tx_line_rate {6.0} \
	CONFIG.gt0_val_encoding {8B/10B} \
	CONFIG.gt0_val_tx_reference_clock {150.000} \
	CONFIG.gt0_val_rx_line_rate {6.0} \
	CONFIG.gt0_val_decoding {8B/10B} \
	CONFIG.gt0_val_rx_reference_clock {150.000} \
	CONFIG.gt0_val_cpll_fbdiv_45 {5} \
	CONFIG.gt0_val_cpll_fbdiv {4} \
	CONFIG.gt0_val_cpll_refclk_div {1} \
	CONFIG.gt0_val_qpll_refclk_div {1} \
	CONFIG.gt0_val_qpll_fbdiv {40} \
	CONFIG.gt0_val_cpll_rxout_div {1} \
	CONFIG.gt0_val_cpll_txout_div {1} \
	CONFIG.gt0_val_drp {true} \
	CONFIG.gt0_val_port_tx8b10bbypass {false} \
	CONFIG.gt0_val_port_txchardispmode {false} \
	CONFIG.gt0_val_port_txchardispval {false} \
	CONFIG.gt0_val_port_rxchariscomma {true} \
	CONFIG.gt0_val_port_rxcharisk {true} \
	CONFIG.gt0_val_tx_buffer_bypass_mode {Auto} \
	CONFIG.gt0_val_txusrclk {TXOUTCLK} \
	CONFIG.gt0_val_txoutclk_source {false} \
	CONFIG.gt0_val_rx_buffer_bypass_mode {Auto} \
	CONFIG.gt0_val_rxoutclk_source {false} \
	CONFIG.gt0_val_port_txpcsreset {false} \
	CONFIG.gt0_val_port_txbufstatus {false} \
	CONFIG.gt0_val_port_txrate {true} \
	CONFIG.gt0_val_port_rxpcsreset {false} \
	CONFIG.gt0_val_port_rxbufstatus {false} \
	CONFIG.gt0_val_port_rxbufreset {false} \
	CONFIG.gt0_val_port_rxrate {true} \
	CONFIG.gt0_val_port_txpmareset {false} \
	CONFIG.gt0_val_port_txsysclksel {true} \
	CONFIG.gt0_val_port_rxpmareset {true} \
	CONFIG.gt0_val_port_rxcdrhold {false} \
	CONFIG.gt0_val_port_cpllpd {false} \
	CONFIG.gt0_val_port_qpllpd {false} \
	CONFIG.gt0_val_rxcomma_deten {true} \
	CONFIG.gt0_val_align_mcomma_det {true} \
	CONFIG.gt0_val_align_pcomma_det {true} \
	CONFIG.gt0_val_dec_mcomma_detect {true} \
	CONFIG.gt0_val_dec_pcomma_detect {true} \
	CONFIG.gt0_val_dec_valid_comma_only {false} \
	CONFIG.gt0_val_comma_preset {K28.5} \
	CONFIG.gt0_val_align_pcomma_value {0101111100} \
	CONFIG.gt0_val_align_mcomma_value {1010000011} \
	CONFIG.gt0_val_align_comma_enable {1111111111} \
	CONFIG.gt0_val_align_comma_double {false} \
	CONFIG.gt0_val_align_comma_word {Any_Byte_Boundary} \
	CONFIG.gt0_val_port_rxpcommaalignen {false} \
	CONFIG.gt0_val_port_rxmcommaalignen {false} \
	CONFIG.gt0_val_port_rxslide {true} \
	CONFIG.gt0_val_port_rxbyteisaligned {true} \
	CONFIG.gt0_val_port_rxbyterealign {true} \
	CONFIG.gt0_val_port_rxcommadet {true} \
	CONFIG.gt0_val_txdiffctrl {false} \
	CONFIG.gt0_val_txpostcursor {false} \
	CONFIG.gt0_val_txprecursor {false} \
	CONFIG.gt0_val_dfe_mode {LPM-Auto} \
	CONFIG.gt0_val_rx_termination_voltage {Programmable} \
	CONFIG.gt0_val_rx_cm_trim {800} \
	CONFIG.gt0_val_port_txinhibit {false} \
	CONFIG.gt0_val_port_txqpibiasen {false} \
	CONFIG.gt0_val_port_txqpisenn {false} \
	CONFIG.gt0_val_port_txqpisenp {false} \
	CONFIG.gt0_val_port_rxqpien {false} \
	CONFIG.gt0_val_port_rxqpisenn {false} \
	CONFIG.gt0_val_port_rxqpisenp {false} \
	CONFIG.gt0_val_port_txqpistrongpdown {false} \
	CONFIG.gt0_val_port_txqpiweakpup {false} \
	CONFIG.gt0_val_port_rxdfereset {true} \
	CONFIG.gt0_val_port_rxdfeagcovrden {false} \
	CONFIG.gt0_val_port_rxlpmhfovrden {false} \
	CONFIG.gt0_val_port_rxlpmlfklovrden {false} \
	CONFIG.gt0_val_port_rxlpmen {false} \
	CONFIG.gt0_val_pcs_pcie_en {false} \
	CONFIG.gt0_val_sata_rx_burst_val {7} \
	CONFIG.gt0_val_sata_e_idle_val {7} \
	CONFIG.gt0_val_pd_trans_time_to_p2 {100} \
	CONFIG.gt0_val_pd_trans_time_from_p2 {60} \
	CONFIG.gt0_val_pd_trans_time_non_p2 {60} \
	CONFIG.gt0_val_port_loopback {false} \
	CONFIG.gt0_val_port_rxvalid {false} \
	CONFIG.gt0_val_port_cominitdet {true} \
	CONFIG.gt0_val_port_comsasdet {true} \
	CONFIG.gt0_val_port_comwakedet {true} \
	CONFIG.gt0_val_port_txcominit {true} \
	CONFIG.gt0_val_port_txcomsas {true} \
	CONFIG.gt0_val_port_txcomwake {true} \
	CONFIG.gt0_val_port_txcomfinish {true} \
	CONFIG.gt0_val_port_txdetectrx {false} \
	CONFIG.gt0_val_port_txelecidle {true} \
	CONFIG.gt0_val_port_phystatus {false} \
	CONFIG.gt0_val_port_txpowerdown {false} \
	CONFIG.gt0_val_port_rxpowerdown {false} \
	CONFIG.gt0_val_oob {true} \
	CONFIG.gt0_val_prbs_detector {false} \
	CONFIG.gt0_val_port_txprbssel {false} \
	CONFIG.gt0_val_port_txprbsforceerr {false} \
	CONFIG.gt0_val_rxprbs_err_loopback {false} \
	CONFIG.gt0_val_cb {false} \
	CONFIG.gt0_val_chan_bond_seq_2_use {false} \
	CONFIG.gt0_val_chan_bond_seq_len {1} \
	CONFIG.gt0_val_chan_bond_max_skew {1} \
	CONFIG.gt0_val_cc {false} \
	CONFIG.gt0_val_ppm_offset {100} \
	CONFIG.gt0_val_clk_cor_seq_2_use {false} \
	CONFIG.gt0_val_clk_cor_seq_len {1} \
	CONFIG.gt0_val_chan_bond_seq_1_1 {00000000} \
	CONFIG.gt0_val_chan_bond_seq_1_2 {00000000} \
	CONFIG.gt0_val_chan_bond_seq_1_3 {00000000} \
	CONFIG.gt0_val_chan_bond_seq_1_4 {00000000} \
	CONFIG.gt0_val_chan_bond_seq_2_1 {00000000} \
	CONFIG.gt0_val_chan_bond_seq_2_2 {00000000} \
	CONFIG.gt0_val_chan_bond_seq_2_3 {00000000} \
	CONFIG.gt0_val_chan_bond_seq_2_4 {00000000} \
	CONFIG.gt0_val_clk_cor_seq_1_1 {00000000} \
	CONFIG.gt0_val_clk_cor_seq_1_2 {00000000} \
	CONFIG.gt0_val_clk_cor_seq_1_3 {00000000} \
	CONFIG.gt0_val_clk_cor_seq_1_4 {00000000} \
	CONFIG.gt0_val_clk_cor_seq_2_1 {00000000} \
	CONFIG.gt0_val_clk_cor_seq_2_2 {00000000} \
	CONFIG.gt0_val_clk_cor_seq_2_3 {00000000} \
	CONFIG.gt0_val_clk_cor_seq_2_4 {00000000} \
	CONFIG.gt0_val_rxslide_mode {PCS} \
	CONFIG.gt0_val_max_cb_level {7} \
	CONFIG.gt0_val_port_pll0pd {false} \
	CONFIG.gt0_val_port_pll1pd {false} \
] [get_ips gtwizard_0]


