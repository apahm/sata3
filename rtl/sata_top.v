`timescale 1ns / 1ps

module sata_top#(
    parameter integer CHIPSCOPE = 0,
    parameter integer AXI_DATA_WIDTH = 32,
    parameter integer AXI_DATA_WIDTH = 5
)
(
    input   wire            TILE0_REFCLK_PAD_P_IN,       // Input differential clock pin P 150MHZ 
    input   wire            TILE0_REFCLK_PAD_N_IN,       // Input differential clock pin N 150MHZ
    input   wire            GTPRESET_IN,                 // Reset input for GTP initialization
    output  wire            TILE0_PLLLKDET_OUT,          // GTP PLL Lock detected output

    output  wire            TXP0_OUT,                    // SATA Connector TX P pin
    output  wire            TXN0_OUT,                    // SATA Connector TX N pin
    input   wire            RXP0_IN,                     // SATA Connector RX P pin
    input   wire            RXN0_IN,                     // SATA Connector RX N pin
      
    output  wire            DCMLOCKED_OUT,               // PHY Layer DCM locked
    output  wire            LINKUP,                      // SATA PHY initialisation completed LINK UP
    output  wire [1:0]      GEN,                         // 2 when a SATA3, 1 when a SATA2 device detected, 0 when SATA1 device detected
    output  wire            CLK_OUT,                     // LINK and Transport Layer clock out CLK_OUT = PHY_CLK_OUT / 2
    input   wire            HOST_READ_EN,                // Read enable from host / user logic for Shadow register and PIO data
    input   wire            HOST_WRITE_EN,               // Write enable from host / user logic for Shadow register and PIO data
    input   wire [4:0]      HOST_ADDR_REG,               // Address bus for Shadow register
    input   wire [31:0]     HOST_DATA_IN,                // Data in bus for Shadow register and PIO data
    output  wire [31:0]     HOST_DATA_OUT,               // Data out bus for Shadow register and PIO data
    output  wire            RESET_OUT,                   // Reset out for User logic this is from GTP reset out
    output  wire            WRITE_HOLD_U,                // Write HOLD signal for PIO and DMA write
    output  wire            READ_HOLD_U,                 // Read HOLD signal for PIO and DMA read
    input   wire            PIO_CLK_IN,                  // Clock in for PIO read / write
    input   wire            DMA_CLK_IN,                  // Clock in for DMA read / write
    input   wire            DMA_RQST,                    // DMA request. This should be 1 for DMA operation and 0 for PIO operation
    output  wire [31:0]     DMA_RX_DATA_OUT,             // DMA read data out bus
    input   wire            DMA_RX_REN,                  // DMA read enable
    input   wire [31:0]     DMA_TX_DATA_IN,              // DMA write data in bus
    input   wire            DMA_TX_WEN,                  // DMA write enable
    input   wire            CE,                          // Chip enable
    output  wire            IPF,                         // Interrupt pending flag
    output  wire            DMA_TERMINATED,              // This signal becomes 1 when a DMA terminate primitive get from Device (SSD)
    output  wire            R_ERR,                       // set 1 when R_ERR Primitive received from disk 
    output  wire            ILLEGAL_STATE,               // set 1 when illegal_state transition detected
    input   wire            RX_FIFO_RESET,               // reset signal for Receive data fifo
    input   wire            TX_FIFO_RESET,               // reset signal for Transmit data fifo
    output  wire            DMA_DATA_RCV_ERROR,           // indicates error during DMA data receive operation
    input   wire            OOB_reset_IN,
    input   wire            RX_FSM_reset_IN,
    input   wire            TX_FSM_reset_IN,

    input   wire                            axi_lite_aclk,
    input   wire                            axi_lite_aresetn,
    input   wire [AXI_ADDR_WIDTH-1 : 0]     axi_lite_awaddr,
    input   wire [2 : 0]                    axi_lite_awprot,
    input   wire                            axi_lite_awvalid,
    output  wire                            axi_lite_awready,
    input   wire [AXI_DATA_WIDTH-1 : 0]     axi_lite_wdata,
    input   wire [(AXI_DATA_WIDTH/8)-1 : 0] axi_lite_wstrb,
    input   wire                            axi_lite_wvalid,
    output  wire                            axi_lite_wready,
    output  wire [1 : 0]                    axi_lite_bresp,
    output  wire                            axi_lite_bvalid,
    input   wire                            axi_lite_bready,
    input   wire [AXI_ADDR_WIDTH-1 : 0]     axi_lite_araddr,
    input   wire [2 : 0]                    axi_lite_arprot,
    input   wire                            axi_lite_arvalid,
    output  wire                            axi_lite_arready,
    output  wire [AXI_DATA_WIDTH-1 : 0]     axi_lite_rdata,
    output  wire [1 : 0]                    axi_lite_rresp,
    output  wire                            axi_lite_rvalid,
    input   wire                            axi_lite_rready    
);

 
wire  [31:0]  phy_rx_data_out;
wire  [3:0]   phy_rx_charisk_out;
wire  [31:0]  link_tx_data_out;
wire          link_tx_charisk_out;
wire          linkup_int;
wire          logic_reset;
wire  [1:0]   align_count;
wire          clk;
  
//wire  for link layer
wire  [31:0]  trnsp_tx_data_out;
wire  [31:0]  link_rx_data_out;
wire          pmreq_p_t;
wire          pmreq_s_t;
wire          pm_en;
wire          lreset;
wire          data_rdy_t;
wire          phy_detect_t;
wire          illegal_state_t;
wire          escapecf_t;
wire          frame_end_t;
wire          decerr;
wire          tx_termn_t_o;
wire          rx_fifo_rdy;
wire          rx_fail_t;
wire          crc_err_t;
wire          valid_crc_t;
wire          fis_err;
wire          good_status_t;
wire          unrecgnzd_fis_t;
//wire          tx_termn_t_i;
wire          r_ok_t;
wire          r_err_t;
wire          sof_t;
wire          eof_t;
wire          tx_rdy_ack_t;
wire          data_out_vld_t;
wire          r_ok_sent_t;
  
//for transport layer
wire          dma_init;
wire          dma_end;
wire          stop_dma;
wire          rx_fifo_empty;
wire          hold_L;
wire          cmd_done;
wire          dma_tx_fifo_full;
wire          dma_rx_fifo_empty;
  
wire          data_in_rd_en_t;
wire          x_rdy_sent_t;
wire          tx_rdy_t;
 
sata_control #( 
    .C_S_AXI_DATA_WIDTH(32),
    .C_S_AXI_ADDR_WIDTH(5)
) 
sata_control_inst 
(
    .S_AXI_ACLK             (axi_lite_aclk),
    .S_AXI_ARESETN          (axi_lite_aresetn),
    .S_AXI_AWADDR           (axi_lite_awaddr),
    .S_AXI_AWPROT           (axi_lite_awprot),
    .S_AXI_AWVALID          (axi_lite_awvalid),
    .S_AXI_AWREADY          (axi_lite_awready),
    .S_AXI_WDATA            (axi_lite_wdata),
    .S_AXI_WSTRB            (axi_lite_wstrb),
    .S_AXI_WVALID           (axi_lite_wvalid),
    .S_AXI_WREADY           (axi_lite_wready),
    .S_AXI_BRESP            (axi_lite_bresp),
    .S_AXI_BVALID           (axi_lite_bvalid),
    .S_AXI_BREADY           (axi_lite_bready),
    .S_AXI_ARADDR           (axi_lite_araddr),
    .S_AXI_ARPROT           (axi_lite_arprot),
    .S_AXI_ARVALID          (axi_lite_arvalid),
    .S_AXI_ARREADY          (axi_lite_arready),
    .S_AXI_RDATA            (axi_lite_rdata),
    .S_AXI_RRESP            (axi_lite_rresp),
    .S_AXI_RVALID           (axi_lite_rvalid),
    .S_AXI_RREADY           (axi_lite_rready)
);

assign CLK_OUT       = clk;
assign RESET_OUT     = logic_reset;
assign R_ERR         = r_err_t;
assign ILLEGAL_STATE = illegal_state_t;
  
sata_phy_layer 
sata_phy_layer_inst 
(
    .TILE0_REFCLK_PAD_P_IN  (TILE0_REFCLK_PAD_P_IN),
    .TILE0_REFCLK_PAD_N_IN  (TILE0_REFCLK_PAD_N_IN),
    .GTXRESET_IN            (GTPRESET_IN),
    .TILE0_PLLLKDET_OUT     (TILE0_PLLLKDET_OUT),
    .TXP0_OUT               (TXP0_OUT),
    .TXN0_OUT               (TXN0_OUT),
    .RXP0_IN                (RXP0_IN),
    .RXN0_IN                (RXN0_IN),
    .DCMLOCKED_OUT          (DCMLOCKED_OUT),
    .LINKUP                 (linkup_int),
    .logic_clk              (clk),
    .GEN                    (GEN),
    .tx_data_in             (link_tx_data_out),
    .tx_charisk_in          (link_tx_charisk_out),
    .rx_data_out            (phy_rx_data_out),
    .rx_charisk_out         (phy_rx_charisk_out),
    .logic_reset            (logic_reset),
    .OOB_reset_IN           (OOB_reset_IN),
    .RX_FSM_reset_IN        (RX_FSM_reset_IN),
	.TX_FSM_reset_IN        (TX_FSM_reset_IN)    
);
  
assign LINKUP = linkup_int; 
  
sata_link_layer
sata_link_layer_inst
(
    .clk                (clk),
    .rst                (logic_reset),
    .data_in_p          (phy_rx_data_out),
    .data_in_t          (trnsp_tx_data_out),
    .data_out_p         (link_tx_data_out),
    .data_out_t         (link_rx_data_out),
    .PHYRDY             (linkup_int),
    .TX_RDY_T           (tx_rdy_t),
    .PMREQ_P_T          (1'b0),
    .PMREQ_S_T          (1'b0),
    .PM_EN              (1'b0),
    .LRESET             (1'b0),
    .data_rdy_T         (data_rdy_t),
    .phy_detect_T       (phy_detect_t),
    .illegal_state_t    (illegal_state_t),
    .EscapeCF_T         (escapecf_t),
    .frame_end_T        (frame_end_t),
    .DecErr             (1'b0),
    .tx_termn_T_o       (tx_termn_t_o),
    .rx_FIFO_rdy        (rx_fifo_rdy),
    .rx_fail_T          (rx_fail_t),
    .crc_err_T          (crc_err_t),
    .valid_CRC_T        (valid_crc_t),
    .FIS_err            (fis_err),
    .Good_status_T      (good_status_t),
    .Unrecgnzd_FIS_T    (unrecgnzd_fis_t),
    .tx_termn_T_i       (1'b0),
    .R_OK_T             (r_ok_t),
    .R_ERR_T            (r_err_t),
    .SOF_T              (sof_t),
    .EOF_T              (eof_t),
    .cntrl_char         (link_tx_charisk_out),
    .RX_CHARISK_IN      (phy_rx_charisk_out[1:0]),
    .tx_rdy_ack_t       (tx_rdy_ack_t),
    .data_out_vld_T     (data_out_vld_t),
    .data_in_rd_en_t    (data_in_rd_en_t)
);
  
assign DMA_TERMINATED = tx_termn_t_o;  

sata_transport 
sata_transport_isnt 
(
    .clk                      (clk), 
    .reset                    (logic_reset), 
    .DMA_RQST                 (DMA_RQST), 
    .data_in                  (HOST_DATA_IN),           //output interface 
    .addr_reg                 (HOST_ADDR_REG),          //output interface
    .data_link_in             (link_rx_data_out),  
    .LINK_DMA_ABORT           (tx_termn_t_o), 
    .link_fis_recved_frm_dev  (sof_t), 
    .phy_detect               (phy_detect_t), 
    .H_write                  (HOST_WRITE_EN),           //output interface 
    .H_read                   (HOST_READ_EN),            //output interface 
    .link_txr_rdy             (tx_rdy_ack_t),      
    .r_ok                     (r_ok_t), 
    .r_error                  (r_err_t), 
    .illegal_state            (illegal_state_t), 
    .end_status               (eof_t), 
    .data_link_out            (trnsp_tx_data_out), 
    .FRAME_END_T              (frame_end_t), 
    .hold_L                   (hold_L),            
    .WRITE_HOLD_U             (WRITE_HOLD_U),            
    .READ_HOLD_U              (READ_HOLD_U),
    .txr_rdy                  (tx_rdy_t), 
    .data_out                 (HOST_DATA_OUT),           
    .EscapeCF_T               (escapecf_t), 
    .UNRECGNZD_FIS_T          (unrecgnzd_fis_t), 
    .IPF                      (IPF),  
    .FIS_ERR                  (fis_err), 
    .Good_status_T            (good_status_t), 
    .RX_FIFO_RDY              (rx_fifo_rdy), 
    .cmd_done                 (cmd_done),          
    .DMA_TX_DATA_IN           (DMA_TX_DATA_IN),         
    .DMA_TX_WEN               (DMA_TX_WEN),           
    .DMA_RX_DATA_OUT          (DMA_RX_DATA_OUT),       
    .DMA_RX_REN               (DMA_RX_REN),           
    .VALID_CRC_T              (valid_crc_t), 
    .data_out_vld_T           (data_out_vld_t), 
    .CRC_ERR_T                (crc_err_t), 
    .DMA_INIT                 (1'b 0),                 
    .DMA_END                  (dma_end),           
    .DATA_RDY_T               (data_rdy_t),
    .data_link_rd_en_t        (data_in_rd_en_t),
    .PIO_CLK_IN               (PIO_CLK_IN),
    .DMA_CLK_IN               (DMA_CLK_IN),
    .CE                       (CE),
    .RX_FIFO_RESET            (RX_FIFO_RESET),
    .TX_FIFO_RESET            (TX_FIFO_RESET),
    .DMA_data_rcv_error       (DMA_DATA_RCV_ERROR)
);

endmodule
