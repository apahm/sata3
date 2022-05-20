`timescale 1ns / 1ps
`define DLY #1

module sata_phy_layer #(
    parameter EXAMPLE_SIM_GTRESET_SPEEDUP          =   "TRUE",    // simulation setting for GT SecureIP model
    parameter STABLE_CLOCK_PERIOD                  = 16
)
(
    input wire  Q0_CLK1_GTREFCLK_PAD_N_IN,
    input wire  Q0_CLK1_GTREFCLK_PAD_P_IN,
    input wire  DRP_CLK_IN_P,
    input wire  DRP_CLK_IN_N,
    output wire TRACK_DATA_OUT,
    input  wire         RXN_IN,
    input  wire         RXP_IN,
    output wire         TXN_OUT,
    output wire         TXP_OUT
);

    wire soft_reset_i;
    (*mark_debug = "TRUE" *) wire soft_reset_vio_i;

//************************** Register Declarations ****************************

    wire            gt_txfsmresetdone_i;
    wire            gt_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt_txfsmresetdone_r2;
    wire            gt0_txfsmresetdone_i;
    wire            gt0_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt0_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_vio_r3;

    reg [5:0] reset_counter = 0;
    reg     [3:0]   reset_pulse;

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

    //____________________________COMMON PORTS________________________________
    //-------------------- Common Block  - Ref Clock Ports ---------------------
    wire            gt0_gtrefclk1_common_i;
    //----------------------- Common Block - QPLL Ports ------------------------
    wire            gt0_qplllock_i;
    wire            gt0_qpllrefclklost_i;
    wire            gt0_qpllreset_i;


    //----------------------------- Global Signals -----------------------------

    wire            drpclk_in_i;
    wire            DRPCLK_IN;
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


    //--------------------- Frame check/gen Module Signals --------------------
    wire            gt0_matchn_i;
    
    wire    [3:0]   gt0_txcharisk_float_i;
   
    wire    [15:0]  gt0_txdata_float16_i;
    wire    [31:0]  gt0_txdata_float_i;
    
    
    wire            gt0_block_sync_i;
    wire            gt0_track_data_i;
    wire    [7:0]   gt0_error_count_i;
    wire            gt0_frame_check_reset_i;
    wire            gt0_inc_in_i;
    wire            gt0_inc_out_i;
    wire    [31:0]  gt0_unscrambled_data_i;

    wire            reset_on_data_error_i;
    wire            track_data_out_i;

    wire            gttxreset_i;
    wire            gtrxreset_i;

    wire            user_tx_reset_i;
    wire            user_rx_reset_i;
    wire            tx_vio_clk_i;
    wire            tx_vio_clk_mux_out_i;    
    wire            rx_vio_ila_clk_i;
    wire            rx_vio_ila_clk_mux_out_i;

    wire            cpllreset_i;
    


  wire [(80 -32) -1:0] zero_vector_rx_80 ;
  wire [(8 -4) -1:0] zero_vector_rx_8 ;
  wire [79:0] gt0_rxdata_ila ;
  wire [1:0]  gt0_rxdatavalid_ila; 
  wire [7:0]  gt0_rxcharisk_ila ;
  wire gt0_txmmcm_lock_ila ;
  wire gt0_rxmmcm_lock_ila ;
  wire gt0_rxresetdone_ila ;
  wire gt0_txresetdone_ila ;

//**************************** Main Body of Code *******************************

    //  Static signal Assigments    
    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 8'hff;

    assign zero_vector_rx_80 = 0;
    assign zero_vector_rx_8 = 0;

    
assign  q0_clk1_refclk_i                     =  1'b0;

    //***********************************************************************//
    //                                                                       //
    //--------------------------- The GT Wrapper ----------------------------//
    //                                                                       //
    //***********************************************************************//
    
    // Use the instantiation template in the example directory to add the GT wrapper to your design.
    // In this example, the wrapper is wired up for basic operation with a frame generator and frame 
    // checker. The GTs will reset, then attempt to align and transmit data. If channel bonding is 
    // enabled, bonding should occur after alignment.
    // While connecting the GT TX/RX Reset ports below, please add a delay of
    // minimum 500ns as mentioned in AR 43482.

    
gtwizard_0_support #(
    .EXAMPLE_SIM_GTRESET_SPEEDUP    (EXAMPLE_SIM_GTRESET_SPEEDUP),
    .STABLE_CLOCK_PERIOD            (STABLE_CLOCK_PERIOD)
)
gtwizard_0_support_i
(
    .soft_reset_tx_in               (soft_reset_i),
    .soft_reset_rx_in               (soft_reset_i),
    .dont_reset_on_data_error_in    (tied_to_ground_i),
    .q0_clk1_gtrefclk_pad_n_in      (Q0_CLK1_GTREFCLK_PAD_N_IN),
    .q0_clk1_gtrefclk_pad_p_in      (Q0_CLK1_GTREFCLK_PAD_P_IN),
    .gt0_tx_fsm_reset_done_out      (gt0_txfsmresetdone_i),
    .gt0_rx_fsm_reset_done_out      (gt0_rxfsmresetdone_i),
    .gt0_data_valid_in              (gt0_track_data_i),
 
    .gt0_txusrclk_out               (gt0_txusrclk_i),
    .gt0_txusrclk2_out              (gt0_txusrclk2_i),
    .gt0_rxusrclk_out               (gt0_rxusrclk_i),
    .gt0_rxusrclk2_out              (gt0_rxusrclk2_i),


    //_____________________________________________________________________
    //_____________________________________________________________________
    //GT0  (X1Y0)

    //------------------------------- CPLL Ports -------------------------------
    .gt0_cpllfbclklost_out          (gt0_cpllfbclklost_i),
    .gt0_cplllock_out               (gt0_cplllock_i),
    .gt0_cpllreset_in               (tied_to_ground_i),
    //-------------------------- Channel - DRP Ports  --------------------------
    .gt0_drpaddr_in                 (gt0_drpaddr_i),
    .gt0_drpdi_in                   (gt0_drpdi_i),
    .gt0_drpdo_out                  (gt0_drpdo_i),
    .gt0_drpen_in                   (gt0_drpen_i),
    .gt0_drprdy_out                 (gt0_drprdy_i),
    .gt0_drpwe_in                   (gt0_drpwe_i),
    //------------------------- Digital Monitor Ports --------------------------
    .gt0_dmonitorout_out            (gt0_dmonitorout_i),
    //--------------------------- PCI Express Ports ----------------------------
    .gt0_rxrate_in                  (gt0_rxrate_i),
    //------------------- RX Initialization and Reset Ports --------------------
    .gt0_eyescanreset_in            (tied_to_ground_i),
    .gt0_rxuserrdy_in               (tied_to_vcc_i),
    //------------------------ RX Margin Analysis Ports ------------------------
    .gt0_eyescandataerror_out       (gt0_eyescandataerror_i),
    .gt0_eyescantrigger_in          (tied_to_ground_i),
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    .gt0_rxdata_out                 (gt0_rxdata_i),
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    .gt0_rxdisperr_out              (gt0_rxdisperr_i),
    .gt0_rxnotintable_out           (gt0_rxnotintable_i),
    //------------------------- Receive Ports - RX AFE -------------------------
    .gt0_gtxrxp_in                  (RXP_IN),
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    .gt0_gtxrxn_in                  (RXN_IN),
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    .gt0_rxphmonitor_out            (gt0_rxphmonitor_i),
    .gt0_rxphslipmonitor_out        (gt0_rxphslipmonitor_i),
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    .gt0_rxbyteisaligned_out        (gt0_rxbyteisaligned_i),
    .gt0_rxbyterealign_out          (gt0_rxbyterealign_i),
    .gt0_rxcommadet_out             (gt0_rxcommadet_i),
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    .gt0_rxdfelpmreset_in           (tied_to_ground_i),
    .gt0_rxmonitorout_out           (gt0_rxmonitorout_i),
    .gt0_rxmonitorsel_in            (2'b00),
    //---------- Receive Ports - RX Fabric ClocK Output Control Ports ----------
    .gt0_rxratedone_out             (gt0_rxratedone_i),
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    .gt0_rxoutclkfabric_out         (gt0_rxoutclkfabric_i),
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    .gt0_gtrxreset_in               (tied_to_ground_i),
    .gt0_rxpmareset_in              (gt0_rxpmareset_i),
    //----------------- Receive Ports - RX OOB Signaling ports -----------------
    .gt0_rxcomsasdet_out            (gt0_rxcomsasdet_i),
    .gt0_rxcomwakedet_out           (gt0_rxcomwakedet_i),
    //---------------- Receive Ports - RX OOB Signaling ports  -----------------
    .gt0_rxcominitdet_out           (gt0_rxcominitdet_i),
    //---------------- Receive Ports - RX OOB signalling Ports -----------------
    .gt0_rxelecidle_out             (gt0_rxelecidle_i),
    //-------------------- Receive Ports - RX gearbox ports --------------------
    .gt0_rxslide_in                 (gt0_rxslide_i),
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    .gt0_rxchariscomma_out          (gt0_rxchariscomma_i),
    .gt0_rxcharisk_out              (gt0_rxcharisk_i),
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    .gt0_rxresetdone_out            (gt0_rxresetdone_i),
    //------------------- TX Initialization and Reset Ports --------------------
    .gt0_gttxreset_in               (tied_to_ground_i),
    .gt0_txuserrdy_in               (tied_to_vcc_i),
    //------------------- Transmit Ports - PCI Express Ports -------------------
    .gt0_txelecidle_in              (gt0_txelecidle_i),
    .gt0_txrate_in                  (gt0_txrate_i),
    //---------------- Transmit Ports - TX Data Path interface -----------------
    .gt0_txdata_in                  (gt0_txdata_i),
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    .gt0_gtxtxn_out                 (TXN_OUT),
    .gt0_gtxtxp_out                 (TXP_OUT),
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    .gt0_txoutclkfabric_out         (gt0_txoutclkfabric_i),
    .gt0_txoutclkpcs_out            (gt0_txoutclkpcs_i),
    .gt0_txratedone_out             (gt0_txratedone_i),
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    .gt0_txcharisk_in               (gt0_txcharisk_i),
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    .gt0_txresetdone_out            (gt0_txresetdone_i),
    //---------------- Transmit Ports - TX OOB signalling Ports ----------------
    .gt0_txcomfinish_out            (gt0_txcomfinish_i),
    .gt0_txcominit_in               (gt0_txcominit_i),
    .gt0_txcomsas_in                (gt0_txcomsas_i),
    .gt0_txcomwake_in               (gt0_txcomwake_i),


    //____________________________COMMON PORTS________________________________
    .gt0_qplloutclk_out(),
    .gt0_qplloutrefclk_out(),
    .sysclk_in(drpclk_in_i)
);

IBUFDS 
IBUFDS_DRP_CLK
(
    .I  (DRP_CLK_IN_P),
    .IB (DRP_CLK_IN_N),
    .O  (DRPCLK_IN)
);

BUFG 
DRP_CLK_BUFG
(
    .I  (DRPCLK_IN),
    .O  (drpclk_in_i) 
);

always @(posedge gt0_rxusrclk2_i or negedge gt0_rxresetdone_i)
begin
    if (!gt0_rxresetdone_i)
    begin
        gt0_rxresetdone_r    <=   `DLY 1'b0;
        gt0_rxresetdone_r2   <=   `DLY 1'b0;
        gt0_rxresetdone_r3   <=   `DLY 1'b0;
    end
    else
    begin
        gt0_rxresetdone_r    <=   `DLY gt0_rxresetdone_i;
        gt0_rxresetdone_r2   <=   `DLY gt0_rxresetdone_r;
        gt0_rxresetdone_r3   <=   `DLY gt0_rxresetdone_r2;
    end
end

always @(posedge  gt0_rxusrclk2_i or negedge gt0_rxfsmresetdone_i)
begin
    if (!gt0_rxfsmresetdone_i)
    begin
        gt0_rxfsmresetdone_r    <=   `DLY 1'b0;
        gt0_rxfsmresetdone_r2   <=   `DLY 1'b0;
    end
    else
    begin
        gt0_rxfsmresetdone_r    <=   `DLY gt0_rxfsmresetdone_i;
        gt0_rxfsmresetdone_r2   <=   `DLY gt0_rxfsmresetdone_r;
    end
end

    
    
always @(posedge  gt0_txusrclk2_i or negedge gt0_txfsmresetdone_i)
begin
    if (!gt0_txfsmresetdone_i)
    begin
        gt0_txfsmresetdone_r    <=   `DLY 1'b0;
        gt0_txfsmresetdone_r2   <=   `DLY 1'b0;
    end
    else
    begin
        gt0_txfsmresetdone_r    <=   `DLY gt0_txfsmresetdone_i;
        gt0_txfsmresetdone_r2   <=   `DLY gt0_txfsmresetdone_r;
    end
end


assign TRACK_DATA_OUT = track_data_out_i;

assign track_data_out_i = gt0_track_data_i;


out_of_band 
out_of_band_inst 
(
    .clk                (),
    .reset              (),
    .link_reset         (),
    .rx_locked          (),
    .tx_datain          (),      
    .tx_chariskin       (),
    .tx_dataout         (),      
    .tx_charisk_out     (),          
    .rx_charisk         (),                             
    .rx_datain          (),       
    .rx_dataout         (),      
    .rx_charisk_out     (), 
    .linkup             (),
    .gen                (),
    .rxreset            (),
    .txcominit          (),
    .txcomwake          (),
    .cominitdet         (), 
    .comwakedet         (),
    .rxelecidle         (),
    .txelecidle         (),
    .rxbyteisaligned    (), 
    .CurrentState_out   (),
    .align_det_out      (),
    .sync_det_out       (),
    .rx_sof_det_out     (),
    .rx_eof_det_out     (),
    .gt0_rxresetdone_i  (),
    .gt0_txresetdone_i  (),
    .gtx_rx_reset_out   ()
);

//------------ optional Ports assignments --------------
assign  gt0_txcominit_i                      =  0;
assign  gt0_txcomsas_i                       =  0;
assign  gt0_txcomwake_i                      =  0;
 //------GTH/GTP
assign  gt0_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt0_rxpmareset_i                     =  tied_to_ground_i;
assign  gt0_rxrate_i                         =  0;
assign  gt0_txelecidle_i                     =  tied_to_ground_i;
assign  gt0_txrate_i                         =  0;

//------------------------------------------------------
// assign resets for frame_gen modules
assign  gt0_tx_system_reset_c = !gt0_txfsmresetdone_r2;

// assign resets for frame_check modules
assign  gt0_rx_system_reset_c = !gt0_rxfsmresetdone_r2;

assign gt0_drpaddr_i = 9'd0;
assign gt0_drpdi_i = 16'd0;
assign gt0_drpen_i = 1'b0;
assign gt0_drpwe_i = 1'b0;
assign soft_reset_i = tied_to_ground_i;

endmodule
    

