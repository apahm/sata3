`timescale 1ns / 1ps
`define DLY #1
//***************************** Entity Declaration ****************************
module gtwizard_common #
(
    // Simulation attributes
    parameter   WRAPPER_SIM_GTRESET_SPEEDUP    =   "TRUE",     // Set to "true" to speed up sim reset
    parameter   SIM_QPLLREFCLK_SEL             =   3'b001     
)
(
    input   [2:0]   QPLLREFCLKSEL_IN,
    input           GTREFCLK0_IN,
    input           GTREFCLK1_IN,
    output          QPLLLOCK_OUT,
    input           QPLLLOCKDETCLK_IN,
    output          QPLLOUTCLK_OUT,
    output          QPLLOUTREFCLK_OUT,
    output          QPLLREFCLKLOST_OUT,   
    input           QPLLRESET_IN
);



//***************************** Parameter Declarations ************************
    localparam QPLL_FBDIV_TOP =  40;

    localparam QPLL_FBDIV_IN  =  (QPLL_FBDIV_TOP == 16)  ? 10'b0000100000 : 
                (QPLL_FBDIV_TOP == 20)  ? 10'b0000110000 :
                (QPLL_FBDIV_TOP == 32)  ? 10'b0001100000 :
                (QPLL_FBDIV_TOP == 40)  ? 10'b0010000000 :
                (QPLL_FBDIV_TOP == 64)  ? 10'b0011100000 :
                (QPLL_FBDIV_TOP == 66)  ? 10'b0101000000 :
                (QPLL_FBDIV_TOP == 80)  ? 10'b0100100000 :
                (QPLL_FBDIV_TOP == 100) ? 10'b0101110000 : 10'b0000000000;

   localparam QPLL_FBDIV_RATIO = (QPLL_FBDIV_TOP == 16)  ? 1'b1 : 
                (QPLL_FBDIV_TOP == 20)  ? 1'b1 :
                (QPLL_FBDIV_TOP == 32)  ? 1'b1 :
                (QPLL_FBDIV_TOP == 40)  ? 1'b1 :
                (QPLL_FBDIV_TOP == 64)  ? 1'b1 :
                (QPLL_FBDIV_TOP == 66)  ? 1'b0 :
                (QPLL_FBDIV_TOP == 80)  ? 1'b1 :
                (QPLL_FBDIV_TOP == 100) ? 1'b1 : 1'b1;

    // ground and vcc signals
wire            tied_to_ground_i;
wire    [63:0]  tied_to_ground_vec_i;
wire            tied_to_vcc_i;
wire    [63:0]  tied_to_vcc_vec_i;

    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 64'hffffffffffffffff;

    //_________________________________________________________________________
    //_________________________________________________________________________
    //_________________________GTXE2_COMMON____________________________________

    GTXE2_COMMON #
    (
            // Simulation attributes
            .SIM_RESET_SPEEDUP   (WRAPPER_SIM_GTRESET_SPEEDUP),
            .SIM_QPLLREFCLK_SEL  (SIM_QPLLREFCLK_SEL),
            .SIM_VERSION         ("4.0"),


           //----------------COMMON BLOCK Attributes---------------
            .BIAS_CFG                               (64'h0000040000001000),
            .COMMON_CFG                             (32'h00000000),
            .QPLL_CFG                               (27'h06801C1),
            .QPLL_CLKOUT_CFG                        (4'b0000),
            .QPLL_COARSE_FREQ_OVRD                  (6'b010000),
            .QPLL_COARSE_FREQ_OVRD_EN               (1'b0),
            .QPLL_CP                                (10'b0000011111),
            .QPLL_CP_MONITOR_EN                     (1'b0),
            .QPLL_DMONITOR_SEL                      (1'b0),
            .QPLL_FBDIV                             (QPLL_FBDIV_IN),
            .QPLL_FBDIV_MONITOR_EN                  (1'b0),
            .QPLL_FBDIV_RATIO                       (QPLL_FBDIV_RATIO),
            .QPLL_INIT_CFG                          (24'h000006),
            .QPLL_LOCK_CFG                          (16'h21E8),
            .QPLL_LPF                               (4'b1111),
            .QPLL_REFCLK_DIV                        (1)

    )
    gtxe2_common_i
    (
        //----------- Common Block  - Dynamic Reconfiguration Port (DRP) -----------
        .DRPADDR                        (tied_to_ground_vec_i[7:0]),
        .DRPCLK                         (tied_to_ground_i),
        .DRPDI                          (tied_to_ground_vec_i[15:0]),
        .DRPDO                          (),
        .DRPEN                          (tied_to_ground_i),
        .DRPRDY                         (),
        .DRPWE                          (tied_to_ground_i),
        //-------------------- Common Block  - Ref Clock Ports ---------------------
        .GTGREFCLK                      (tied_to_ground_i),
        .GTNORTHREFCLK0                 (tied_to_ground_i),
        .GTNORTHREFCLK1                 (tied_to_ground_i),
        .GTREFCLK0                      (GTREFCLK0_IN),
        .GTREFCLK1                      (GTREFCLK1_IN),
        .GTSOUTHREFCLK0                 (tied_to_ground_i),
        .GTSOUTHREFCLK1                 (tied_to_ground_i),
        //----------------------- Common Block -  QPLL Ports -----------------------
        .QPLLDMONITOR                   (),
        //--------------------- Common Block - Clocking Ports ----------------------
        .QPLLOUTCLK                     (QPLLOUTCLK_OUT),
        .QPLLOUTREFCLK                  (QPLLOUTREFCLK_OUT),
        .REFCLKOUTMONITOR               (),
        //----------------------- Common Block - QPLL Ports ------------------------
        .QPLLFBCLKLOST                  (),
        .QPLLLOCK                       (QPLLLOCK_OUT),
        .QPLLLOCKDETCLK                 (QPLLLOCKDETCLK_IN),
        .QPLLLOCKEN                     (tied_to_vcc_i),
        .QPLLOUTRESET                   (tied_to_ground_i),
        .QPLLPD                         (tied_to_ground_i),
        .QPLLREFCLKLOST                 (QPLLREFCLKLOST_OUT),
        .QPLLREFCLKSEL                  (QPLLREFCLKSEL_IN),
        .QPLLRESET                      (QPLLRESET_IN),
        .QPLLRSVD1                      (16'b0000000000000000),
        .QPLLRSVD2                      (5'b11111),
        //------------------------------- QPLL Ports -------------------------------
        .BGBYPASSB                      (tied_to_vcc_i),
        .BGMONITORENB                   (tied_to_vcc_i),
        .BGPDB                          (tied_to_vcc_i),
        .BGRCALOVRD                     (5'b11111),
        .PMARSVD                        (8'b00000000),
        .RCALENB                        (tied_to_vcc_i)

    );
endmodule
