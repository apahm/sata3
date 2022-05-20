`timescale 1ns / 1ps

module gtwizard_gt_usrclk_source 
(
    output wire  GT0_TXUSRCLK_OUT,
    output wire  GT0_TXUSRCLK2_OUT,
    input  wire  GT0_TXOUTCLK_IN,
    output wire  GT0_RXUSRCLK_OUT,
    output wire  GT0_RXUSRCLK2_OUT,
    input  wire  GT0_RXOUTCLK_IN,
    input  wire  Q0_CLK1_GTREFCLK_PAD_N_IN,
    input  wire  Q0_CLK1_GTREFCLK_PAD_P_IN,
    output wire  Q0_CLK1_GTREFCLK_OUT
);

`define DLY #1

//*********************************Wire Declarations**********************************
    wire            tied_to_ground_i;
    wire            tied_to_vcc_i;
 
    wire            gt0_txoutclk_i; 
    wire            gt0_rxoutclk_i;
    wire  q0_clk1_gtrefclk /*synthesis syn_noclockbuf=1*/;

    wire            gt0_txusrclk_i;
    wire            gt0_rxusrclk_i;


//*********************************** Beginning of Code *******************************

    //  Static signal Assigments    
    assign tied_to_ground_i             = 1'b0;
    assign tied_to_vcc_i                = 1'b1;
    assign gt0_txoutclk_i = GT0_TXOUTCLK_IN;
    assign gt0_rxoutclk_i = GT0_RXOUTCLK_IN;
     
    assign Q0_CLK1_GTREFCLK_OUT = q0_clk1_gtrefclk;

    //IBUFDS_GTE2
    IBUFDS_GTE2 ibufds_instQ0_CLK1  
    (
        .O               (q0_clk1_gtrefclk),
        .ODIV2           (),
        .CEB             (tied_to_ground_i),
        .I               (Q0_CLK1_GTREFCLK_PAD_P_IN),
        .IB              (Q0_CLK1_GTREFCLK_PAD_N_IN)
    );



    // Instantiate a MMCM module to divide the reference clock. Uses internal feedback
    // for improved jitter performance, and to avoid consuming an additional BUFG

    BUFG txoutclk_bufg0_i
    (
        .I                              (gt0_txoutclk_i),
        .O                              (gt0_txusrclk_i)
    );


    BUFG rxoutclk_bufg1_i
    (
        .I                              (gt0_rxoutclk_i),
        .O                              (gt0_rxusrclk_i)
    );



 
assign GT0_TXUSRCLK_OUT = gt0_txusrclk_i;
assign GT0_TXUSRCLK2_OUT = gt0_txusrclk_i;
assign GT0_RXUSRCLK_OUT = gt0_rxusrclk_i;
assign GT0_RXUSRCLK2_OUT = gt0_rxusrclk_i;

endmodule
