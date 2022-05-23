`timescale 1ns / 1ps

module gtwizard_gt_usrclk_source 
(
    output wire         GT0_TXUSRCLK_OUT,
    output wire         GT0_TXUSRCLK2_OUT,
    input  wire         GT0_TXOUTCLK_IN,
    output wire         GT0_RXUSRCLK_OUT,
    output wire         GT0_RXUSRCLK2_OUT,
    
    input  wire         Q0_CLK1_GTREFCLK_PAD_N_IN,
    input  wire         Q0_CLK1_GTREFCLK_PAD_P_IN,
    output wire         Q0_CLK1_GTREFCLK_OUT,
    output wire         STABLE_CLOCK_OUT

);

    wire            tied_to_ground_i;
    wire            tied_to_vcc_i;
 
    wire            gt0_txoutclk_i; 
    wire            q0_clk1_gtrefclk;
    wire            stable_clock_out_int;
    wire            gt0_txusrclk_i;

    assign tied_to_ground_i = 1'b0;
    assign tied_to_vcc_i = 1'b1;
    assign gt0_txoutclk_i = GT0_TXOUTCLK_IN;
     
    assign Q0_CLK1_GTREFCLK_OUT = q0_clk1_gtrefclk;

    //IBUFDS_GTE2
    IBUFDS_GTE2 
    ibufds_inst  
    (
        .O                  (q0_clk1_gtrefclk),
        .ODIV2              (),
        .CEB                (tied_to_ground_i),
        .I                  (Q0_CLK1_GTREFCLK_PAD_P_IN),
        .IB                 (Q0_CLK1_GTREFCLK_PAD_N_IN)
    );

    BUFG 
    txoutclk_inst
    (
        .I                  (gt0_txoutclk_i),
        .O                  (gt0_txusrclk_i)
    );

    BUFG
    stable_clock_bufg
    (
        .I                  (q0_clk1_gtrefclk),
        .O                  (stable_clock_out_int)
    );

    assign STABLE_CLOCK_OUT = stable_clock_out_int;
    assign GT0_TXUSRCLK_OUT = gt0_txusrclk_i;
    assign GT0_TXUSRCLK2_OUT = gt0_txusrclk_i;
    assign GT0_RXUSRCLK_OUT = gt0_txusrclk_i;
    assign GT0_RXUSRCLK2_OUT = gt0_txusrclk_i;

endmodule
