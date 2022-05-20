`timescale 1ns / 1ps
`define DLY #1

module gtwizard_0_support #
(
    parameter EXAMPLE_SIM_GTRESET_SPEEDUP            = "TRUE",     // Simulation setting for GT SecureIP model
    parameter STABLE_CLOCK_PERIOD                    = 16         //Period of the stable clock driving this state-machine, unit is [ns]

)
(
    input   wire        soft_reset_tx_in,
    input   wire        soft_reset_rx_in,
    input   wire        dont_reset_on_data_error_in,
    input   wire        q0_clk1_gtrefclk_pad_n_in,
    input   wire        q0_clk1_gtrefclk_pad_p_in,
    output  wire        gt0_tx_fsm_reset_done_out,
    output  wire        gt0_rx_fsm_reset_done_out,
    input   wire        gt0_data_valid_in,
 
    output  wire        gt0_txusrclk_out,
    output  wire        gt0_txusrclk2_out,
    output  wire        gt0_rxusrclk_out,
    output  wire        gt0_rxusrclk2_out,
    //_________________________________________________________________________
    //GT0  (X1Y0)
    //____________________________CHANNEL PORTS________________________________
    //------------------------------- CPLL Ports -------------------------------
    output          gt0_cpllfbclklost_out,
    output          gt0_cplllock_out,
    input           gt0_cpllreset_in,
    //-------------------------- Channel - DRP Ports  --------------------------
    input   [8:0]   gt0_drpaddr_in,
    input   [15:0]  gt0_drpdi_in,
    output  [15:0]  gt0_drpdo_out,
    input           gt0_drpen_in,
    output          gt0_drprdy_out,
    input           gt0_drpwe_in,
    //------------------------- Digital Monitor Ports --------------------------
    output  [7:0]   gt0_dmonitorout_out,
    //--------------------------- PCI Express Ports ----------------------------
    input   [2:0]   gt0_rxrate_in,
    //------------------- RX Initialization and Reset Ports --------------------
    input           gt0_eyescanreset_in,
    input           gt0_rxuserrdy_in,
    //------------------------ RX Margin Analysis Ports ------------------------
    output          gt0_eyescandataerror_out,
    input           gt0_eyescantrigger_in,
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    output  [31:0]  gt0_rxdata_out,
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    output  [3:0]   gt0_rxdisperr_out,
    output  [3:0]   gt0_rxnotintable_out,
    //------------------------- Receive Ports - RX AFE -------------------------
    input           gt0_gtxrxp_in,
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    input           gt0_gtxrxn_in,
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    output  [4:0]   gt0_rxphmonitor_out,
    output  [4:0]   gt0_rxphslipmonitor_out,
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    output          gt0_rxbyteisaligned_out,
    output          gt0_rxbyterealign_out,
    output          gt0_rxcommadet_out,
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    input           gt0_rxdfelpmreset_in,
    output  [6:0]   gt0_rxmonitorout_out,
    input   [1:0]   gt0_rxmonitorsel_in,
    //---------- Receive Ports - RX Fabric ClocK Output Control Ports ----------
    output          gt0_rxratedone_out,
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    output          gt0_rxoutclkfabric_out,
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    input           gt0_gtrxreset_in,
    input           gt0_rxpmareset_in,
    //----------------- Receive Ports - RX OOB Signaling ports -----------------
    output          gt0_rxcomsasdet_out,
    output          gt0_rxcomwakedet_out,
    output          gt0_rxcominitdet_out,
    output          gt0_rxelecidle_out,
    //-------------------- Receive Ports - RX gearbox ports --------------------
    input           gt0_rxslide_in,
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    output  [3:0]   gt0_rxchariscomma_out,
    output  [3:0]   gt0_rxcharisk_out,
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    output          gt0_rxresetdone_out,
    //------------------- TX Initialization and Reset Ports --------------------
    input           gt0_gttxreset_in,
    input           gt0_txuserrdy_in,
    //------------------- Transmit Ports - PCI Express Ports -------------------
    input           gt0_txelecidle_in,
    input   [2:0]   gt0_txrate_in,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [31:0]  gt0_txdata_in,
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    output          gt0_gtxtxn_out,
    output          gt0_gtxtxp_out,
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    output          gt0_txoutclkfabric_out,
    output          gt0_txoutclkpcs_out,
    output          gt0_txratedone_out,
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    input   [3:0]   gt0_txcharisk_in,
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    output          gt0_txresetdone_out,
    //---------------- Transmit Ports - TX OOB signalling Ports ----------------
    output          gt0_txcomfinish_out,
    input           gt0_txcominit_in,
    input           gt0_txcomsas_in,
    input           gt0_txcomwake_in,

    //____________________________COMMON PORTS________________________________
    output          gt0_qplloutclk_out,
    output          gt0_qplloutrefclk_out,
    input           sysclk_in

);


//**************************** Wire Declarations ******************************//
//------------------------ GT Wrapper Wires ------------------------------
//________________________________________________________________________
//________________________________________________________________________
//GT0  (X1Y0)
//------------------------------- CPLL Ports -------------------------------
wire            gt0_cpllfbclklost_i;
wire            gt0_cplllock_i;
wire            gt0_cpllrefclklost_i;
wire            gt0_cpllreset_i;
//-------------------------- Channel - DRP Ports  --------------------------
wire    [8:0]   gt0_drpaddr_i;
wire    [15:0]  gt0_drpdi_i;
wire    [15:0]  gt0_drpdo_i;
wire            gt0_drpen_i;
wire            gt0_drprdy_i;
wire            gt0_drpwe_i;
//------------------------- Digital Monitor Ports --------------------------
wire    [7:0]   gt0_dmonitorout_i;
//--------------------------- PCI Express Ports ----------------------------
wire    [2:0]   gt0_rxrate_i;
//------------------- RX Initialization and Reset Ports --------------------
wire            gt0_eyescanreset_i;
wire            gt0_rxuserrdy_i;
//------------------------ RX Margin Analysis Ports ------------------------
wire            gt0_eyescandataerror_i;
wire            gt0_eyescantrigger_i;
//---------------- Receive Ports - FPGA RX interface Ports -----------------
wire    [31:0]  gt0_rxdata_i;
//---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
wire    [3:0]   gt0_rxdisperr_i;
wire    [3:0]   gt0_rxnotintable_i;
//------------------------- Receive Ports - RX AFE -------------------------
wire            gt0_gtxrxp_i;
//---------------------- Receive Ports - RX AFE Ports ----------------------
wire            gt0_gtxrxn_i;
//----------------- Receive Ports - RX Buffer Bypass Ports -----------------
wire            gt0_rxdlysreset_i;
wire            gt0_rxdlysresetdone_i;
wire            gt0_rxphaligndone_i;
wire            gt0_rxphdlyreset_i;
wire    [4:0]   gt0_rxphmonitor_i;
wire    [4:0]   gt0_rxphslipmonitor_i;
//------------ Receive Ports - RX Byte and Word Alignment Ports ------------
wire            gt0_rxbyteisaligned_i;
wire            gt0_rxbyterealign_i;
wire            gt0_rxcommadet_i;
//------------------- Receive Ports - RX Equalizer Ports -------------------
wire            gt0_rxdfelpmreset_i;
wire    [6:0]   gt0_rxmonitorout_i;
wire    [1:0]   gt0_rxmonitorsel_i;
//---------- Receive Ports - RX Fabric ClocK Output Control Ports ----------
wire            gt0_rxratedone_i;
//------------- Receive Ports - RX Fabric Output Control Ports -------------
wire            gt0_rxoutclk_i;
wire            gt0_rxoutclkfabric_i;
//----------- Receive Ports - RX Initialization and Reset Ports ------------
wire            gt0_gtrxreset_i;
wire            gt0_rxpmareset_i;
//----------------- Receive Ports - RX OOB Signaling ports -----------------
wire            gt0_rxcomsasdet_i;
wire            gt0_rxcomwakedet_i;
//---------------- Receive Ports - RX OOB Signaling ports  -----------------
wire            gt0_rxcominitdet_i;
//---------------- Receive Ports - RX OOB signalling Ports -----------------
wire            gt0_rxelecidle_i;
//-------------------- Receive Ports - RX gearbox ports --------------------
wire            gt0_rxslide_i;
//----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
wire    [3:0]   gt0_rxchariscomma_i;
wire    [3:0]   gt0_rxcharisk_i;
//------------ Receive Ports -RX Initialization and Reset Ports ------------
wire            gt0_rxresetdone_i;
//------------------- TX Initialization and Reset Ports --------------------
wire            gt0_gttxreset_i;
wire            gt0_txuserrdy_i;
//------------------- Transmit Ports - PCI Express Ports -------------------
wire            gt0_txelecidle_i;
wire    [2:0]   gt0_txrate_i;
//---------------- Transmit Ports - TX Buffer Bypass Ports -----------------
wire            gt0_txdlyen_i;
wire            gt0_txdlysreset_i;
wire            gt0_txdlysresetdone_i;
wire            gt0_txphalign_i;
wire            gt0_txphaligndone_i;
wire            gt0_txphalignen_i;
wire            gt0_txphdlyreset_i;
wire            gt0_txphinit_i;
wire            gt0_txphinitdone_i;
//---------------- Transmit Ports - TX Data Path interface -----------------
wire    [31:0]  gt0_txdata_i;
//-------------- Transmit Ports - TX Driver and OOB signaling --------------
wire            gt0_gtxtxn_i;
wire            gt0_gtxtxp_i;
//--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
wire            gt0_txoutclk_i;
wire            gt0_txoutclkfabric_i;
wire            gt0_txoutclkpcs_i;
wire            gt0_txratedone_i;
//------------------- Transmit Ports - TX Gearbox Ports --------------------
wire    [3:0]   gt0_txcharisk_i;
//----------- Transmit Ports - TX Initialization and Reset Ports -----------
wire            gt0_txresetdone_i;
//---------------- Transmit Ports - TX OOB signalling Ports ----------------
wire            gt0_txcomfinish_i;
wire            gt0_txcominit_i;
wire            gt0_txcomsas_i;
wire            gt0_txcomwake_i;

wire            gt0_qplllock_i;
wire            gt0_qpllrefclklost_i  ;
wire            gt0_qpllreset_i  ;
wire            gt0_qpllreset_t  ;
wire            gt0_qplloutclk_i  ;
wire            gt0_qplloutrefclk_i ;

//----------------------------- Global Signals -----------------------------

wire            sysclk_in_i;
wire            gt0_tx_system_reset_c;
wire            gt0_rx_system_reset_c;
wire            tied_to_ground_i;
wire    [63:0]  tied_to_ground_vec_i;
wire            tied_to_vcc_i;
wire    [7:0]   tied_to_vcc_vec_i;
wire            GTTXRESET_IN;
wire            GTRXRESET_IN;
wire            CPLLRESET_IN;
wire            QPLLRESET_IN;

 //--------------------------- User Clocks ---------------------------------
wire            gt0_txusrclk_i; 
wire            gt0_txusrclk2_i; 
wire            gt0_rxusrclk_i; 
wire            gt0_rxusrclk2_i; 
 
//--------------------------- Reference Clocks ----------------------------
    
wire            q0_clk1_refclk_i;

wire            commonreset_i;
wire            commonreset_t;

//**************************** Main Body of Code *******************************

//  Static signal Assigments    
assign tied_to_ground_i             = 1'b0;
assign tied_to_ground_vec_i         = 64'h0000000000000000;
assign tied_to_vcc_i                = 1'b1;
assign tied_to_vcc_vec_i            = 8'hff;

assign gt0_qpllreset_t = tied_to_vcc_i;
assign gt0_qplloutclk_out = gt0_qplloutclk_i;
assign gt0_qplloutrefclk_out = gt0_qplloutrefclk_i;
 
assign  gt0_txusrclk_out = gt0_txusrclk_i; 
assign  gt0_txusrclk2_out = gt0_txusrclk2_i;
assign  gt0_rxusrclk_out = gt0_rxusrclk_i;
assign  gt0_rxusrclk2_out = gt0_rxusrclk2_i;


gtwizard_gt_usrclk_source 
gt_usrclk_source_inst
(
    .GT0_TXUSRCLK_OUT    (gt0_txusrclk_i),
    .GT0_TXUSRCLK2_OUT   (gt0_txusrclk2_i),
    .GT0_TXOUTCLK_IN     (gt0_txoutclk_i),
    .GT0_RXUSRCLK_OUT    (gt0_rxusrclk_i),
    .GT0_RXUSRCLK2_OUT   (gt0_rxusrclk2_i),
    .GT0_RXOUTCLK_IN     (gt0_rxoutclk_i),
 
    .Q0_CLK1_GTREFCLK_PAD_N_IN  (q0_clk1_gtrefclk_pad_n_in),
    .Q0_CLK1_GTREFCLK_PAD_P_IN  (q0_clk1_gtrefclk_pad_p_in),
    .Q0_CLK1_GTREFCLK_OUT       (q0_clk1_refclk_i)
);

assign  sysclk_in_i = sysclk_in;

gtwizard_common #(
    .WRAPPER_SIM_GTRESET_SPEEDUP(EXAMPLE_SIM_GTRESET_SPEEDUP),
    .SIM_QPLLREFCLK_SEL(3'b001)
)
common0_i
(
    .QPLLREFCLKSEL_IN(3'b001),
    .GTREFCLK0_IN(tied_to_ground_i),
    .GTREFCLK1_IN(tied_to_ground_i),
    .QPLLLOCK_OUT(gt0_qplllock_i),
    .QPLLLOCKDETCLK_IN(sysclk_in_i),
    .QPLLOUTCLK_OUT(gt0_qplloutclk_i),
    .QPLLOUTREFCLK_OUT(gt0_qplloutrefclk_i),
    .QPLLREFCLKLOST_OUT(gt0_qpllrefclklost_i),    
    .QPLLRESET_IN(gt0_qpllreset_t)

);

gtwizard_common_reset #(
      .STABLE_CLOCK_PERIOD (STABLE_CLOCK_PERIOD)        // Period of the stable clock driving this state-machine, unit is [ns]
)
common_reset_i
(    
    .STABLE_CLOCK(sysclk_in_i),             //Stable Clock, either a stable clock from the PCB
    .SOFT_RESET(soft_reset_tx_in),               //User Reset, can be pulled any time
    .COMMON_RESET(commonreset_i)              //Reset QPLL
);


    
gtwizard_0 
gtwizard_0_inst
(
    .sysclk_in                      (sysclk_in_i),
    .soft_reset_tx_in               (soft_reset_tx_in),
    .soft_reset_rx_in               (soft_reset_rx_in),
    .dont_reset_on_data_error_in    (dont_reset_on_data_error_in),
    .gt0_tx_fsm_reset_done_out      (gt0_tx_fsm_reset_done_out),
    .gt0_rx_fsm_reset_done_out      (gt0_rx_fsm_reset_done_out),
    .gt0_data_valid_in              (gt0_data_valid_in),

    //_____________________________________________________________________
    //_____________________________________________________________________
    //GT0  (X1Y0)

    //------------------------------- CPLL Ports -------------------------------
    .gt0_cpllfbclklost_out          (gt0_cpllfbclklost_out), // output wire gt0_cpllfbclklost_out
    .gt0_cplllock_out               (gt0_cplllock_out), // output wire gt0_cplllock_out
    .gt0_cplllockdetclk_in          (sysclk_in_i), // input wire sysclk_in_i
    .gt0_cpllreset_in               (gt0_cpllreset_in), // input wire gt0_cpllreset_in
    //------------------------ Channel - Clocking Ports ------------------------
    .gt0_gtrefclk0_in               (tied_to_ground_i), // input wire tied_to_ground_i
    .gt0_gtrefclk1_in               (q0_clk1_refclk_i), // input wire q0_clk1_refclk_i
    //-------------------------- Channel - DRP Ports  --------------------------
    .gt0_drpaddr_in                 (gt0_drpaddr_in), // input wire [8:0] gt0_drpaddr_in
    .gt0_drpclk_in                  (sysclk_in_i), // input wire sysclk_in_i
    .gt0_drpdi_in                   (gt0_drpdi_in), // input wire [15:0] gt0_drpdi_in
    .gt0_drpdo_out                  (gt0_drpdo_out), // output wire [15:0] gt0_drpdo_out
    .gt0_drpen_in                   (gt0_drpen_in), // input wire gt0_drpen_in
    .gt0_drprdy_out                 (gt0_drprdy_out), // output wire gt0_drprdy_out
    .gt0_drpwe_in                   (gt0_drpwe_in), // input wire gt0_drpwe_in
    //------------------------- Digital Monitor Ports --------------------------
    .gt0_dmonitorout_out            (gt0_dmonitorout_out), // output wire [7:0] gt0_dmonitorout_out
    //--------------------------- PCI Express Ports ----------------------------
    .gt0_rxrate_in                  (gt0_rxrate_in), // input wire [2:0] gt0_rxrate_in
    //------------------- RX Initialization and Reset Ports --------------------
    .gt0_eyescanreset_in            (gt0_eyescanreset_in), // input wire gt0_eyescanreset_in
    .gt0_rxuserrdy_in               (gt0_rxuserrdy_in), // input wire gt0_rxuserrdy_in
    //------------------------ RX Margin Analysis Ports ------------------------
    .gt0_eyescandataerror_out       (gt0_eyescandataerror_out), // output wire gt0_eyescandataerror_out
    .gt0_eyescantrigger_in          (gt0_eyescantrigger_in), // input wire gt0_eyescantrigger_in
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    .gt0_rxusrclk_in                (gt0_rxusrclk_i), // input wire gt0_rxusrclk_i
    .gt0_rxusrclk2_in               (gt0_rxusrclk2_i), // input wire gt0_rxusrclk2_i
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    .gt0_rxdata_out                 (gt0_rxdata_out), // output wire [31:0] gt0_rxdata_out
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    .gt0_rxdisperr_out              (gt0_rxdisperr_out), // output wire [3:0] gt0_rxdisperr_out
    .gt0_rxnotintable_out           (gt0_rxnotintable_out), // output wire [3:0] gt0_rxnotintable_out
    //------------------------- Receive Ports - RX AFE -------------------------
    .gt0_gtxrxp_in                  (gt0_gtxrxp_in), // input wire gt0_gtxrxp_in
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    .gt0_gtxrxn_in                  (gt0_gtxrxn_in), // input wire gt0_gtxrxn_in
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    .gt0_rxphmonitor_out            (gt0_rxphmonitor_out), // output wire [4:0] gt0_rxphmonitor_out
    .gt0_rxphslipmonitor_out        (gt0_rxphslipmonitor_out), // output wire [4:0] gt0_rxphslipmonitor_out
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    .gt0_rxbyteisaligned_out        (gt0_rxbyteisaligned_out), // output wire gt0_rxbyteisaligned_out
    .gt0_rxbyterealign_out          (gt0_rxbyterealign_out), // output wire gt0_rxbyterealign_out
    .gt0_rxcommadet_out             (gt0_rxcommadet_out), // output wire gt0_rxcommadet_out
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    .gt0_rxdfelpmreset_in           (gt0_rxdfelpmreset_in), // input wire gt0_rxdfelpmreset_in
    .gt0_rxmonitorout_out           (gt0_rxmonitorout_out), // output wire [6:0] gt0_rxmonitorout_out
    .gt0_rxmonitorsel_in            (gt0_rxmonitorsel_in), // input wire [1:0] gt0_rxmonitorsel_in
    //---------- Receive Ports - RX Fabric ClocK Output Control Ports ----------
    .gt0_rxratedone_out             (gt0_rxratedone_out), // output wire gt0_rxratedone_out
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    .gt0_rxoutclk_out               (gt0_rxoutclk_i), // output wire gt0_rxoutclk_i
    .gt0_rxoutclkfabric_out         (gt0_rxoutclkfabric_out), // output wire gt0_rxoutclkfabric_out
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    .gt0_gtrxreset_in               (gt0_gtrxreset_in), // input wire gt0_gtrxreset_in
    .gt0_rxpmareset_in              (gt0_rxpmareset_in), // input wire gt0_rxpmareset_in
    //----------------- Receive Ports - RX OOB Signaling ports -----------------
    .gt0_rxcomsasdet_out            (gt0_rxcomsasdet_out), // output wire gt0_rxcomsasdet_out
    .gt0_rxcomwakedet_out           (gt0_rxcomwakedet_out), // output wire gt0_rxcomwakedet_out
    //---------------- Receive Ports - RX OOB Signaling ports  -----------------
    .gt0_rxcominitdet_out           (gt0_rxcominitdet_out), // output wire gt0_rxcominitdet_out
    //---------------- Receive Ports - RX OOB signalling Ports -----------------
    .gt0_rxelecidle_out             (gt0_rxelecidle_out), // output wire gt0_rxelecidle_out
    //-------------------- Receive Ports - RX gearbox ports --------------------
    .gt0_rxslide_in                 (gt0_rxslide_in), // input wire gt0_rxslide_in
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    .gt0_rxchariscomma_out          (gt0_rxchariscomma_out), // output wire [3:0] gt0_rxchariscomma_out
    .gt0_rxcharisk_out              (gt0_rxcharisk_out), // output wire [3:0] gt0_rxcharisk_out
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    .gt0_rxresetdone_out            (gt0_rxresetdone_out), // output wire gt0_rxresetdone_out
    //------------------- TX Initialization and Reset Ports --------------------
    .gt0_gttxreset_in               (gt0_gttxreset_in), // input wire gt0_gttxreset_in
    .gt0_txuserrdy_in               (gt0_txuserrdy_in), // input wire gt0_txuserrdy_in
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    .gt0_txusrclk_in                (gt0_txusrclk_i), // input wire gt0_txusrclk_i
    .gt0_txusrclk2_in               (gt0_txusrclk2_i), // input wire gt0_txusrclk2_i
    //------------------- Transmit Ports - PCI Express Ports -------------------
    .gt0_txelecidle_in              (gt0_txelecidle_in), // input wire gt0_txelecidle_in
    .gt0_txrate_in                  (gt0_txrate_in), // input wire [2:0] gt0_txrate_in
    //---------------- Transmit Ports - TX Data Path interface -----------------
    .gt0_txdata_in                  (gt0_txdata_in), // input wire [31:0] gt0_txdata_in
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    .gt0_gtxtxn_out                 (gt0_gtxtxn_out), // output wire gt0_gtxtxn_out
    .gt0_gtxtxp_out                 (gt0_gtxtxp_out), // output wire gt0_gtxtxp_out
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    .gt0_txoutclk_out               (gt0_txoutclk_i), // output wire gt0_txoutclk_i
    .gt0_txoutclkfabric_out         (gt0_txoutclkfabric_out), // output wire gt0_txoutclkfabric_out
    .gt0_txoutclkpcs_out            (gt0_txoutclkpcs_out), // output wire gt0_txoutclkpcs_out
    .gt0_txratedone_out             (gt0_txratedone_out), // output wire gt0_txratedone_out
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    .gt0_txcharisk_in               (gt0_txcharisk_in), // input wire [3:0] gt0_txcharisk_in
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    .gt0_txresetdone_out            (gt0_txresetdone_out), // output wire gt0_txresetdone_out
    //---------------- Transmit Ports - TX OOB signalling Ports ----------------
    .gt0_txcomfinish_out            (gt0_txcomfinish_out), // output wire gt0_txcomfinish_out
    .gt0_txcominit_in               (gt0_txcominit_in), // input wire gt0_txcominit_in
    .gt0_txcomsas_in                (gt0_txcomsas_in), // input wire gt0_txcomsas_in
    .gt0_txcomwake_in               (gt0_txcomwake_in), // input wire gt0_txcomwake_in

    .gt0_qplloutclk_in(gt0_qplloutclk_i),
    .gt0_qplloutrefclk_in(gt0_qplloutrefclk_i)

);

 
endmodule
    


